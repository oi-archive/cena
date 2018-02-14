unit GatherThreadU;

interface

uses
  Classes, SysUtils, ComCtrls, ExtCtrls, Windows, IdTCPClient, ojtc, myutils,
  libojcd, ojconst, jvgnugettext;

type


  TCollectorThread = class(TThread)
  private
    { Private declarations }
    ClientID: TClientID;
    ClientName: widestring;
    ClientIP: string;
    FMessage: widestring;
  protected
//    ip:string;
    procedure GetClient;     
    procedure ok;
    procedure err;
    procedure Execute; override;
    procedure BeforePeople;
    procedure AfterPeople;
    procedure AddMessage; overload;
    procedure AddMessage(AMessage: widestring); overload;
    procedure IncCount;
    procedure DecCount;
  public
  end;

var
  ActiveCollectorThreads: integer;
  ClientsToGet: TClientIDList;
  Threads:array[1..5] of TCollectorThread=(nil,nil,nil,nil,nil);


implementation

uses
  MyTypes, MessageFormU, MainFormU, JudgeThreadU, ResultFormU;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TCollectorThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TCollectorThread }

procedure TCollectorThread.GetClient;
var
  Client: TClient;
begin
  if ClientsToGet.Count>0 then begin
    Client:=Judge.Clients.FindClientID(ClientsToGet.Head.ClientID);
    if Client<>nil then begin
      ClientID:=ClientsToGet.Head.ClientID;
      ClientIP:=Client.IP;
      ClientName:=UTF8Decode(Client.Info.Name);
    end;
    ClientsToGet.DeleteHead;
  end
  else
    ClientIP:='';
end;

procedure TCollectorThread.ok;
begin
//  TListItem(Client.People.Data).SubItems.Strings[1]:='完成';
end;

procedure TCollectorThread.err;
begin
  //
//  this.node.SubItems.Strings[1]:='错误';
end;

function CheckFileName(AFileName: string):boolean;
begin
  result:=(pos('..',AFileName)=0)and
          (pos(':',AFileName)=0)and
          (pos('/',AFileName)=0)and
          (pos('\',AFileName)=0);
end;


procedure TCollectorThread.Execute;
var
  tcp:TIdTCPClient;
  HeaderReceived, HeaderToSend: THeader;
  FileCount, ReceivedFileCount: integer;
  FileName: widestring;
  TotalSize, FileSize, ReceivedSize: int64;
  hFile: cardinal;
  Data: array[0..FILEPART_SIZE] of char;
  i,j,k:integer;
  mapi: cardinal;
  Status: cardinal;
begin
  Synchronize(IncCount);

  HeaderReceived.Properties:=TPropertyList.Create;
  HeaderToSend.Properties:=TPropertyList.Create;

  tcp:=TIdTCPClient.Create(nil);
//  tcp.ReadTimeout:=1000;

  while ClientsToGet.Count>0 do begin
   
    Synchronize(GetClient);

    if ClientIP='' then
      continue;

    Synchronize(BeforePeople);  
    tcp.Host:=ClientIP;
    tcp.Port:=12574; 

    try
      tcp.Connect;

      HeaderToSend.Command:='GET';
      HeaderToSend.Properties.Clear;
      if Judge.Settings.NormalSet.CollectFileCorrelative then
        for i:=0 to Judge.Contest.Problems.Count-1 do
          HeaderToSend.Properties.Add('Accept-Name: '+Judge.Contest.Problems.Items[i].FileName)
      else
        HeaderToSend.Properties.Add('Accept-Name: *');

      if Judge.Settings.NormalSet.CollectExtCorrelative then
        for i:=0 to Judge.Settings.Compilers.Count-1 do
          HeaderToSend.Properties.Add('Accept-Extension: '+Judge.Settings.Compilers.Items[i].Extension)
      else
        HeaderToSend.Properties.Add('Accept-Extension: *');

      if Judge.Settings.NormalSet.FileSizeLimitB then
        HeaderToSend.Properties.Add(Format('Max-Size: %d',[Judge.Settings.NormalSet.FileSizeLimit]));
        
      HeaderToSend.WriteTo(tcp);
      
      HeaderReceived.ReadFrom(tcp);
      for i:=0 to HeaderReceived.Properties.Count-1 do begin
        if HeaderReceived.Properties.Name[i]='Files-Count' then
          FileCount:=strtoint(HeaderReceived.Properties.Value[i]);
        if HeaderReceived.Properties.Name[i]='Total-Size' then
          TotalSize:=strtoint(HeaderReceived.Properties.Value[i]);
      end;
      ReceivedSize:=0;
      ReceivedFileCount:=0;

      if HeaderReceived.Command='OK' then begin
        if not DirectoryExists(Judge.Contest.Path+'\src\'+ClientName) then
          MkDir(Judge.Contest.Path+'\src\'+ClientName);
          
        for i:=0 to FileCount-1 do begin

          Status:=Maxlongint;  // 不发 status 属性则认为出了错!!! 到底status:=几？
          HeaderReceived.ReadFrom(tcp);  // 没有检查 Command  (应该=FILE)
          for j:=0 to HeaderReceived.Properties.Count-1 do begin
            if HeaderReceived.Properties.Name[j]='Status'    then
              Status  :=StrToInt(HeaderReceived.Properties.Value[j]);
            if HeaderReceived.Properties.Name[j]='File-Name' then begin
              FileName:=UTF8Decode(HeaderReceived.Properties.Value[j]);
            end;
            if HeaderReceived.Properties.Name[j]='File-Size' then
              FileSize:=strtoint(HeaderReceived.Properties.Value[j]);
          end;
          {检查文件名   允许unicode字符集的文件名，只是文件名会丢失
          for j:=1 to length(FileName) do
            if FileName[j]='?' then FileName[j]:='_';
          }
          if Status>0 then begin
            // 报错!!!  客户端CreateFile时出错
            continue;  // skip this file
          end;

          if CheckFileName(FileName) then begin
            hFile:=CreateFileW(pwidechar(Judge.Contest.Path+'\src\'+ClientName+'\'+FileName),GENERIC_WRITE,FILE_SHARE_WRITE,nil,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0);
            if hFile=INVALID_HANDLE_VALUE then begin
              // 中止连接  服务端CreateFile时出错
              raise Exception.Create('创建文件失败。连接中断。'+Judge.Contest.Path+'\src\'+ClientName+'\'+FileName);
            end else begin
              for j:=1 to FileSize div FILEPART_SIZE do begin
                HeaderReceived.ReadFrom(tcp);
                Status:=Maxlongint;  // 不发 status 属性则认为出了错!!!
                if HeaderReceived.Command='FILEPART' then begin
                  for k:=0 to HeaderReceived.Properties.Count-1 do begin
                    if HeaderReceived.Properties.Name[k]='Status' then
                      Status:=strtoint(HeaderReceived.Properties.Value[k]);
                  end;
                  if Status=0 then begin
                    tcp.ReadBuffer(Data,FILEPART_SIZE);
                    if not WriteFile(hFile,Data,FILEPART_SIZE,mapi,nil) then begin
                      // 报错!!!  服务端WriteFile时出错
                      break;
                    end else begin
                      inc(ReceivedSize,FILEPART_SIZE);
                      // 刷新状态列表 !!!
                    end;
                  end
                  else begin
                    // 报错!!!  客户端ReadFile时出错
                    break;
                  end;
                end;
              end;

              if Status=0 then
                if FileSize mod FILEPART_SIZE > 0 then begin
                  HeaderReceived.ReadFrom(tcp);
                  if HeaderReceived.Command='FILEPART' then begin
                    for k:=0 to HeaderReceived.Properties.Count-1 do begin
                      if HeaderReceived.Properties.Name[k]='Status' then
                        Status:=strtoint(HeaderReceived.Properties.Value[k]);
                    end;
                    if Status=0 then begin
                      tcp.ReadBuffer(Data,FileSize mod FILEPART_SIZE);
                      if not WriteFile(hFile,Data,FileSize mod FILEPART_SIZE,mapi,nil) then begin
                        // 报错!!!  服务端WriteFile时出错
                      end else begin
                        inc(ReceivedSize,FileSize mod FILEPART_SIZE);
                        inc(ReceivedFileCount);  // 最后一块接收完毕
                        // 刷新状态列表 !!!
                      end;
                    end
                    else begin
                      // 报错!!!  客户端ReadFile时出错
                    end;
                  end;
                end
                else
                  inc(ReceivedFileCount);  // 当前文件已接收完毕(这个文件没有“边角料”)
              CloseHandle(hFile);
            end;
          end;
        end;

        HeaderToSend.Command:='DONE';
        HeaderToSend.Properties.Clear;
        HeaderToSend.WriteTo(tcp);

      end
      else
        raise Exception.Create('Error reply was received from client.');  

      AddMessage(WideFormat(_('[Message] Gathered %0:d files from %1:s (%2:d bytes).'),[ReceivedFileCount,ClientName,ReceivedSize]));  //!!!

      Synchronize(ok);
    except
      AddMessage(WideFormat(_('[ Error ] Error while gathering files from %s. '),[ClientName]));   //!!!
      Synchronize(err);
    end;
    tcp.Disconnect;

    Synchronize(AfterPeople);

  end;

  tcp.Destroy;
  HeaderReceived.Properties.Destroy;
  HeaderToSend.Properties.Destroy;
  Synchronize(DecCount);  
end;

procedure TCollectorThread.BeforePeople;
var
  Client: TClient;
begin
  Client:=Judge.Clients.FindClientID(ClientID);
  if Client<>nil then begin
    Client.People.Status:=PS_GETTING;
    MainForm.RefreshPeople(Client.People);
  end;
end;

procedure TCollectorThread.AfterPeople;
var
  Client: TClient;
  People: TPeople;
begin
  Client:=Judge.Clients.FindClientID(ClientID);
  if Client=nil then
    People:=Judge.Contest.Peoples.FindName(ClientName)
  else
    People:=Client.People;
  if People<>nil then begin
    if assigned(People.ResultWnd) then
      TResultForm(People.ResultWnd).Destroy;
    if People.HasResult then
      DeleteFile(pchar(People.Path+'\.result'));
    People.Status:=PS_UNKNOWN;
    MainForm.RefreshPeople(People);
  end;
end;

procedure TCollectorThread.AddMessage;
begin
  MessageForm.Show;
  MessageForm.lb.AddItem('  '+FMessage,nil);
end;

procedure TCollectorThread.AddMessage(AMessage: widestring);
begin
  FMessage:=AMessage;
  Synchronize(AddMessage);
end;

procedure TCollectorThread.IncCount;
begin
  inc(ActiveCollectorThreads);
  if JudgeThread.Judging then
    MainForm.stat1.Panels[0].Text:=_('Gathering and Judging...')
  else
    MainForm.stat1.Panels[0].Text:=_('Gathering...');


end;

procedure TCollectorThread.DecCount;
begin
  dec(ActiveCollectorThreads);
  if ActiveCollectorThreads=0 then
    if JudgeThread.Judging then
      MainForm.stat1.Panels[0].Text:=_('Judging...')
    else
      MainForm.stat1.Panels[0].Text:=_('Idle');
end;

begin
  ClientsToGet:=TClientIDList.Create;
end.
