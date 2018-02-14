unit MainFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, IdTCPServer, IdBaseComponent, MyTypes, ojrc, JclSysInfo,
  IdComponent, IdUDPBase, IdUDPServer, IdSocketHandle, shellapi, Menus, MyUtils,
  StdCtrls, IdTCPConnection, IdTCPClient, ExtCtrls, registry, xpman, ojtc
  , libojcd, ojconst, AppEvnts, math;

const
  NIF_INFO = $10;
  NIF_MESSAGE = 1;
  NIF_ICON = 2;
  NOTIFYICON_VERSION = 3;
  NIF_TIP = 4;
  NIM_SETVERSION = $00000004;
  NIM_SETFOCUS = $00000003;
  NIIF_INFO = $00000001;
  NIIF_WARNING = $00000002;
  NIIF_ERROR = $00000003;

  NIN_BALLOONSHOW = WM_USER + 2;
  NIN_BALLOONHIDE = WM_USER + 3;
  NIN_BALLOONTIMEOUT = WM_USER + 4;
  NIN_BALLOONUSERCLICK = WM_USER + 5;
  NIN_SELECT = WM_USER + 0;
  NINF_KEY = $1;
  NIN_KEYSELECT = NIN_SELECT or NINF_KEY;

  {other constants can be found in vs.net---vc7's dir: PlatformSDK\Include\ShellAPI.h}

  {define the callback message}
  TRAY_CALLBACK = WM_USER + $7258;

  {new NotifyIconData structure definition}
type
  PNewNotifyIconData = ^TNewNotifyIconData;
  TDUMMYUNIONNAME    = record
    case Integer of
      0: (uTimeout: UINT);
      1: (uVersion: UINT);
  end;

  TNewNotifyIconData = record
    cbSize: DWORD;
    Wnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
   //Version 5.0 is 128 chars, old ver is 64 chars
    szTip: array [0..127] of Char;
    dwState: DWORD; //Version 5.0
    dwStateMask: DWORD; //Version 5.0
    szInfo: array [0..255] of Char; //Version 5.0
    DUMMYUNIONNAME: TDUMMYUNIONNAME;
    szInfoTitle: array [0..63] of Char; //Version 5.0
    dwInfoFlags: DWORD;   //Version 5.0
  end;


type
  TMainForm = class(TForm)
    UDP: TIdUDPServer;
    PopupMenu1: TPopupMenu;
    O1: TMenuItem;
    N21: TMenuItem;
    A1: TMenuItem;
    X1: TMenuItem;
    V1: TMenuItem;
    N1: TMenuItem;
    IdTCPServer1: TIdTCPServer;
    Timer1: TTimer;
    Timer2: TTimer;
    U1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure UDPUDPRead(Sender: TObject; AData: TStream;
      ABinding: TIdSocketHandle);
    procedure A1Click(Sender: TObject);
    procedure X1Click(Sender: TObject);
    procedure O1Click(Sender: TObject);
    procedure CloseOptionForm;
    procedure V1Click(Sender: TObject);
    procedure IdTCPServer1Connect(AThread: TIdPeerThread);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer2Timer(Sender: TObject);
  private
    IconData: TNewNotifyIconData; 
    procedure TrayMessage(var Msg: TMessage); message TRAY_CALLBACK;
  public
  published
    procedure AddSysTrayIcon;
    procedure ShowBalloonTips(TipInfo, TipTitle: string; Flags: cardinal);
    procedure DeleteSysTrayIcon;
    procedure ModifySysTrayIcon;
    procedure CheckNames;
    function CheckStr(st: widestring): integer;
    function CheckMyName(NewName: widestring): widestring;
    procedure ApplyClientSetting;
    { Public declarations }
  end;



var
  MainForm: TMainForm;
  ok:boolean=true;

  ps,es:array of string;

  Clients: TClients;



implementation

{$R *.dfm}

uses AboutFormUnit, OptionFormUnit, ResultFormU, AutoUpdateThreadU, jvgnugettext;

procedure TMainForm.CloseOptionForm;
begin
  OptionForm.Close;
end;

procedure TMainForm.TrayMessage(var Msg: TMessage);
var
  p: TPoint;
begin
{
  allocconsole;
  if msg.lparam<>512 then
    writeln(msg.lparam);
}
  case Msg.lParam of
    WM_MOUSEMOVE:;
    WM_LBUTTONDOWN:;
    WM_LBUTTONUP:;
    WM_LBUTTONDBLCLK:
      V1.Click;
    {WM_RBUTTONDOWN,} WM_RBUTTONUP{, WM_CONTEXTMENU}:
      begin
        GetCursorPos(p);
        SetForegroundWindow(Handle);
        popupmenu1.popup(p.x,p.y);
      end;
    WM_RBUTTONDBLCLK:;
    //followed by the new messages 
    NIN_BALLOONSHOW:
    {Sent when the balloon is shown}
{      ShowMessage('NIN_BALLOONSHOW')};
    NIN_BALLOONHIDE:                                   
    {Sent when the balloon disappears?Rwhen the icon is deleted,
    for example. This message is not sent if the balloon is dismissed because of
    a timeout or mouse click by the user. }
{      ShowMessage('NIN_BALLOONHIDE')};
    NIN_BALLOONTIMEOUT:
    {Sent when the balloon is dismissed because of a timeout.} 
{      ShowMessage('NIN_BALLOONTIMEOUT')}; 
    NIN_BALLOONUSERCLICK: 
    {Sent when the balloon is dismissed because the user clicked the mouse. 
    Note: in XP there's Close button on he balloon tips, when click the button, 
    send NIN_BALLOONTIMEOUT message actually.} 
{      ShowMessage('NIN_BALLOONUSERCLICK')}; 
  end;

end;



procedure TMainForm.FormCreate(Sender: TObject);
var
  i:integer;
//  x:array[0..255] of char;
  DataToSend: TPacket;
  st: widestring;
begin
  for i:=0 to 31 do
    ClientInfo.ClientID[i]:=random(256);                  
  StrLCopy(ClientInfo.OperatingSystem,pchar(GetWindowsVersionString+' '+NtProductTypeString+' '+GetWindowsServicePackVersionString),sizeof(ClientInfo.OperatingSystem));

  ReadMySet(ClientInfo);
  st:=CheckMyName(UTF8Decode(ClientInfo.Name));
  if st='' then st:=UTF8Decode(ComputerName);
  StrLCopy(@ClientInfo.Name,pchar(UTF8Encode(st)),sizeof(ClientInfo.Name));// !!!

  MainForm.X1.Visible:=ClientInfo.Permissions>0;
  
  AddSysTrayIcon;

  if Paramstr(1)='-f' then
    MainForm.ShowBalloonTips(_('Cena Client 已成功安装。'),_('安装成功'),NIIF_INFO);  
//    MainForm.ShowBalloonTips(_('Cena Client has been installed successfully.'),_('Installation Succeeded'),NIIF_INFO);
  if ParamStr(1)='-fu' then
    MainForm.ShowBalloonTips(Format(_('Cena Client 已经升级到新版本。当前版本为 %d.'),[ClientInfo.Version]),_('版本已升级'),NIIF_INFO);
//    MainForm.ShowBalloonTips(Format(_('Cena Client has been upgraded to the newer version. The current version is %d.'),[ClientInfo.Version]),_('Version Upgraded'),NIIF_INFO);


  try
    InitPacket(DataToSend);
    DataToSend.dwOperation:=PO_ONLINE;
    udp.SendBuffer('255.255.255.255',12575,DataToSend,sizeof(DataToSend));
    udp.SendBuffer('255.255.255.255',12574,DataToSend,sizeof(DataToSend));

    DataToSend.dwOperation:=PO_WHO_IS_ONLINE;
    udp.SendBuffer('255.255.255.255',12574,DataToSend,sizeof(DataToSend));
  except
  end;

  TranslateComponent(self);  
  
end;

procedure TMainForm.UDPUDPRead(Sender: TObject; AData: TStream;
  ABinding: TIdSocketHandle);
var
  DataReceived, DataToSend: TPacket;
  Client: TClient;
  st: string;
begin
  AData.ReadBuffer(DataReceived,min(sizeof(DataReceived),AData.Size));
  case DataReceived.dwOperation of
    PO_WHO_IS_ONLINE:
      begin
//        writeln('PO_WHO_IS_ONLINE');
        DataToSend.dwProtocolVersion:=1;
        DataToSend.dwOperation:=PO_ONLINE;
        DataToSend.ClientInfo:=ClientInfo;
        UDP.SendBuffer(ABinding.PeerIP,ABinding.PeerPort,DataToSend,sizeof(DataToSend));
      end;
    PO_SHOW_TEST_MESSAGE:
      begin
//        writeln('PO_SHOW_TEST_MESSAGE');
        ShowTestMessage(ClientInfo.Name);
      end;
    PO_ONLINE:
      begin
//        writeln('PO_ONLINE');
//        writeln('from ',datareceived.clientinfo.name);
        if CompareMem(@ClientInfo.ClientID,@DataReceived.ClientInfo.ClientID,sizeof(TClientID)) then
          exit;
        Client:=Clients.FindClientID(DataReceived.ClientInfo.ClientID);
        if Client=nil then begin
          Client:=Clients.Add;
          Client.IP:=ABinding.PeerIP;
//        if not CompareMem(@ClientInfo.ClientID,@DataReceived.ClientInfo.ClientID,sizeof(TClientID))
        end;
        Client.Info:=DataReceived.ClientInfo;
{        if SameFileName(ClientInfo.Name,DataReceived.ClientInfo.Name) then begin
          InitPacket(DataToSend);
          DataToSend.dwOperation:=PO_NAME_CONF;
          ClientInfo.Status:=CS_NAME_CONF;
          UDP.SendBuffer(ABinding.PeerIP,ABinding.PeerPort,DataToSend,sizeof(DataToSend));
          ShowBalloonTips(Format('这台客户端的选手名称与 %s 的选手名称相同。请更改选手名称。',[ABinding.PeerIP]),'名称相同',NIIF_ERROR);
        end;}
        CheckNames;
      end;
    PO_CHANGESETTING:
      begin
//        writeln('PO_CHANGESETTING');
        ClientInfo:=DataReceived.ClientInfo;
        if ClientInfo.UsesComputerName then begin
          st:=ComputerName;
          StrLCopy(@ClientInfo.Name,pchar(UTF8Encode(st)),sizeof(ClientInfo.Name));
        end;
        st:=CheckMyName(ClientInfo.Name);
        if st='' then st:=ComputerName;
        StrLCopy(@ClientInfo.Name,pchar(st),sizeof(ClientInfo.Name));
        MainForm.ModifySysTrayIcon;
        ApplyClientSetting;
        InitPacket(DataToSend);
        DataToSend.dwOperation:=PO_ONLINE;
        DataToSend.ClientInfo:=ClientInfo;
        UDP.SendBuffer('255.255.255.255',12575,DataToSend,sizeof(DataToSend));
        UDP.SendBuffer('255.255.255.255',12574,DataToSend,sizeof(DataToSend));
        WriteMySet(ClientInfo);
      end;
    PO_NAME_CONF:
      begin
//        ClientInfo.Status:=CS_NAME_CONF;
//        ShowBalloonTips(Format('这台客户端的选手名称与 %s 的选手名称相同。请更改选手名称。',[ABinding.PeerIP]),'名称相同',NIIF_ERROR);
      end;
    PO_OFFLINE:
      begin
//        writeln('PO_OFFLINE');
        Client:=Clients.FindClientID(DataReceived.ClientInfo.ClientID);
        if Client<>nil then
          Clients.Delete(Client);
      end;
{    PO_COMMAND_EC:
      begin
        ShellExecute(0,'open',pchar(Co),pchar(Pa),nil,SW_SHOW);

      end;}
  end;
end;

procedure TMainForm.A1Click(Sender: TObject);
begin
  if AboutForm=nil then
    Application.CreateForm(TAboutForm,AboutForm);
  AboutForm.Show;
  AboutForm.SetFocus;
end;

procedure TMainForm.X1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.O1Click(Sender: TObject);
begin
  if OptionForm=nil then
    Application.CreateForm(TOptionForm,OptionForm);
  OptionForm.Show;
  OptionForm.SetFocus;
end;

procedure TMainForm.V1Click(Sender: TObject);
{var
  pr:TPeopleResult;}
begin
{
  if ResultForm=nil then
    CreateForm(0,TResultForm,ResultForm);
  ResultForm.Show;
  pr:=TPeopleResult.Create;
//!!!!!  ResultForm.Caption:=Format('%s (%s)',[username,datetimetostr(pr.JudgeTime)]);

  ResultForm.Show;
  ResultForm.SetFocus;
}
end;

procedure TMainForm.IdTCPServer1Connect(AThread: TIdPeerThread);
var
  HeaderReceived, HeaderToSend: THeader;
  Files: TFiles;
  Errors: TArrInteger;
  ffd:TWin32FindDataW;
  i,j:integer;
  hFile:dword;
  TotalSize, FileSize: LARGE_INTEGER;
  OkFiles, ErrorFiles: string;
  OkStrAdd,ErrorStrAdd: boolean;
  Data: array[0..FILEPART_SIZE-1] of char;
//  FilePart: TFilePart;
  nl,el: TStringList;
  mapi: cardinal;
  OkCount: integer;
  ws: widestring;
  MaxSize: int64;
begin

//  AThread.Connection.WriteLn('Welcome to Cena Client.');
  HeaderReceived.Properties:=TPropertyList.Create;
  HeaderToSend.Properties:=TPropertyList.Create;
  hFile:=INVALID_HANDLE_VALUE;

  try

//  while AThread.Connection.Connected do begin

    HeaderReceived.ReadFrom(AThread.Connection);

    if HeaderReceived.Command='GET' then begin
//      MainForm.ShowBalloonTips('接到服务端收取文件的请求。','准备发送文件',NIIF_INFO);
      nl:=TStringList.Create;
      el:=TStringList.Create;

      MaxSize:=high(int64);
      for i:=0 to HeaderReceived.Properties.Count-1 do begin
        if HeaderReceived.Properties.Name[i]='Accept-Name' then
          nl.Add(UTF8Decode(HeaderReceived.Properties.Value[i]));
        if HeaderReceived.Properties.Name[i]='Accept-Extension' then
          el.Add(UTF8Decode(HeaderReceived.Properties.Value[i]));
        if HeaderReceived.Properties.Name[i]='Max-Size' then
          MaxSize:=strtoint(HeaderReceived.Properties.Value[i]);
      end;

      TotalSize.QuadPart:=0;
      Files:=TFiles.Create;
      Errors:=TArrInteger.Create;

      for i:=0 to nl.Count-1 do
        for j:=0 to el.Count-1 do begin
          ws:=''+UTF8Decode(ClientInfo.WorkDir)+'\'+nl.Strings[i]+'.'+el.Strings[j];
          hFile:=FindFirstFileW(pwidechar(ws),ffd);
          if hFile<>INVALID_HANDLE_VALUE then begin
            repeat
              if (ffd.cFileName[0]<>'.') and (ffd.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY=0) then begin
                FileSize.HighPart:=ffd.nFileSizeHigh;
                FileSize.LowPart:=ffd.nFileSizeLow;
                if FileSize.QuadPart<=MaxSize then begin
                  Files.Add.FileName:=ffd.cFileName;
                  Errors.Count:=Files.Count;
                  Errors.Items[Errors.Count-1]:=0;
                  inc(TotalSize.LowPart,ffd.nFileSizeLow);
                  inc(TotalSize.HighPart,ffd.nFileSizeHigh);
                end;
              end;
            until not FindNextFileW(hFile,ffd);
            windows.FindClose(hFile);
          end;
        end;

      HeaderToSend.Command:='OK';
      HeaderToSend.Properties.Clear;
      HeaderToSend.Properties.Add(Format('Files-Count: %d',[Files.Count]));
      HeaderToSend.Properties.Add(Format('Total-Length: %d',[TotalSize.QuadPart]));
      HeaderToSend.WriteTo(AThread.Connection);

//      MainForm.ShowBalloonTips('开始发送文件。','开始',NIIF_INFO);


      for i:=0 to Files.Count-1 do begin

        HeaderToSend.Command:='FILE';

        HeaderToSend.Properties.Clear;
        HeaderToSend.Properties.Add(Format('File-Name: %s',[UTF8Encode(Files.Items[i].FileName)]));  // !!! insecure
        hFile:=CreateFileW(pwidechar(''+UTF8Decode(ClientInfo.WorkDir)+'\'+Files.Items[i].FileName),GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,FILE_ATTRIBUTE_ARCHIVE,0);

        if hFile=INVALID_HANDLE_VALUE then begin

//          writeln('failed to open ',''+ClientInfo.WorkDir+'\'+Files.Items[i].FileName);

          Errors.Items[i]:=GetLastError;
          HeaderToSend.Properties.Add(Format('Status: %d',[Errors.Items[i]]));
          HeaderToSend.WriteTo(AThread.Connection);
        end
        else begin

          FileSize.HighPart:=0;
          FileSize.LowPart:=GetFileSize(hFile,@FileSize.HighPart);

          HeaderToSend.Properties.Add('Status: 0');
          HeaderToSend.Properties.Add(Format('File-Size: %d',[FileSize.QuadPart]));
          HeaderToSend.WriteTo(AThread.Connection);

          HeaderToSend.Command:='FILEPART';

          for j:=1 to FileSize.QuadPart div FILEPART_SIZE do begin
            HeaderToSend.Properties.Clear;
            if ReadFile(hFile,Data,FILEPART_SIZE,mapi,nil) then begin
              HeaderToSend.Properties.Add('Status: 0');
              HeaderToSend.Properties.Add(Format('Content-Length: %d',[FILEPART_SIZE]));
              HeaderToSend.WriteTo(AThread.Connection);
              AThread.Connection.WriteBuffer(Data,FILEPART_SIZE,true);
            end
            else begin  // abandon this file
              Errors.Items[i]:=GetLastError;
              HeaderToSend.Properties.Add(Format('Status: %d',[Errors.Items[i]]));
              HeaderToSend.WriteTo(AThread.Connection);
              break;
            end;
          end;

          if (Errors.Items[i]=0) and (FileSize.QuadPart mod FILEPART_SIZE > 0) then begin // 前面没有出错，发送剩下的一小砣
            HeaderToSend.Properties.Clear;
            if ReadFile(hFile,Data,FileSize.QuadPart mod FILEPART_SIZE,mapi,nil) then begin
              HeaderToSend.Properties.Add('Status: 0');
              HeaderToSend.Properties.Add(Format('Content-Length: %d',[FileSize.QuadPart mod FILEPART_SIZE]));
              HeaderToSend.WriteTo(AThread.Connection);
              AThread.Connection.WriteBuffer(Data,FileSize.QuadPart mod FILEPART_SIZE,true);
            end
            else begin  // abandon the last piece
              Errors.Items[i]:=GetLastError;
              HeaderToSend.Properties.Add(Format('Status: %d',[Errors.Items[i]]));  // getlasterror;
              HeaderToSend.WriteTo(AThread.Connection);
            end;
          end;

          CloseHandle(hFile);
        end;

        hFile:=INVALID_HANDLE_VALUE;
      end;

      HeaderReceived.ReadFrom(AThread.Connection);
      if HeaderReceived.Command='DONE' then begin
        // 发送失败的记录下来
        OkFiles:='';
        ErrorFiles:='';
        OkCount:=0;
        OkStrAdd:=true;
        ErrorStrAdd:=true;
        for j:=0 to Files.Count-1 do
          if Errors.Items[j]=0 then begin
            inc(OkCount);
            if OkStrAdd then
              if Length(OkFiles)>100 then begin
                OkFiles:=OkFiles+'  ...'#13#10;
                OkStrAdd:=false;
              end else
                OkFiles:=OkFiles+'  '+Files.Items[j].FileName+#13#10;
          end else
            if ErrorStrAdd then
              if Length(ErrorFiles)>100 then begin
                ErrorFiles:=ErrorFiles+'  ...'#13#10;
                ErrorStrAdd:=false;
              end else
                ErrorFiles:=ErrorFiles+'  '+Files.Items[j].FileName+#13#10;
{
        if OkCount>0 then
          MainForm.ShowBalloonTips(Format('%s has gathered the following files from this computer:'#13#10+'%s'+'%d Files.',[AThread.Connection.Socket.Binding.PeerIP,OkFiles,OkCount]),'Programs has been sent',NIIF_INFO)
        else
          MainForm.ShowBalloonTips(Format('%s tried to gather programs from this computer, but there''re no needed files in the working directory.',[AThread.Connection.Socket.Binding.PeerIP]),'No programs has been sent',NIIF_WARNING);
}

        if OkCount>0 then
          MainForm.ShowBalloonTips(Format('%s 已从本机收取以下程序:'#13#10+'%s'+'%d Files.',[AThread.Connection.Socket.Binding.PeerIP,OkFiles,OkCount]),'程序已发送',NIIF_INFO)
        else
          MainForm.ShowBalloonTips(Format('%s 试图从本机收取程序，但在工作目录下找不到所需的文件。',[AThread.Connection.Socket.Binding.PeerIP]),'程序未发送',NIIF_WARNING);

      end
      else begin
        MainForm.ShowBalloonTips(Format('在 %s 从本机收取程序时发生了错误。',[AThread.Connection.Socket.Binding.PeerIP]),'错误',NIIF_ERROR);
//        MainForm.ShowBalloonTips(Format('An error occurred while %s was gathering programs from this computer.',[AThread.Connection.Socket.Binding.PeerIP]),'Error',NIIF_ERROR);
      end;

      Files.Destroy;
    end
    else if HeaderReceived.Command='RESULT' then begin

      for i:=0 to HeaderReceived.Properties.Count-1 do begin
        if HeaderReceived.Properties.Name[i]='File-Size' then
          FileSize.QuadPart:=strtoint(HeaderReceived.Properties.Value[i]);
      end;

      for i:=1 to FileSize.QuadPart div FILEPART_SIZE do begin
        HeaderReceived.ReadFrom(AThread.Connection);
        if HeaderReceived.Command='FILEPART' then begin
          AThread.Connection.ReadBuffer(Data,FILEPART_SIZE);
          WriteFile(hFile,Data,FILEPART_SIZE,mapi,nil);
        end
        else begin
          // !!!
        end;
      end;

      if FileSize.QuadPart mod FILEPART_SIZE > 0 then begin
        HeaderReceived.ReadFrom(AThread.Connection);
        if HeaderReceived.Command='FILEPART' then begin
          AThread.Connection.ReadBuffer(Data,FileSize.QuadPart mod FILEPART_SIZE);
          WriteFile(hFile,Data,FileSize.QuadPart mod FILEPART_SIZE,mapi,nil);
        end
        else begin
          // !!!
        end;
      end;

    end
    else if HeaderReceived.Command='UPDATE' then begin

//      MainForm.ShowBalloonTips(Format('接到%s自动更新请求。',[AThread.Connection.Socket.Binding.PeerIP]),'提供更新',NIIF_INFO);
      HeaderToSend.Command:='OK';
      HeaderToSend.Properties.Clear;
      ws:=Application.ExeName;
      hFile:=CreateFileW(pwidechar(ws),GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,FILE_ATTRIBUTE_ARCHIVE,0);
      if hFile<>INVALID_HANDLE_VALUE then begin
        FileSize.LowPart:=GetFileSize(hFile,@FileSize.HighPart);
        HeaderToSend.Properties.Add(Format('Content-Length: %d',[FileSize.QuadPart]));
        HeaderToSend.WriteTo(AThread.Connection);

        for i:=1 to FileSize.QuadPart div FILEPART_SIZE do begin
          Windows.ReadFile(hFile,Data,FILEPART_SIZE,mapi,nil);
          AThread.Connection.WriteBuffer(Data,FILEPART_SIZE,true);
        end;

        if FileSize.QuadPart mod FILEPART_SIZE>0 then begin
          Windows.ReadFile(hFile,Data,FileSize.QuadPart mod FILEPART_SIZE,mapi,nil);
          AThread.Connection.WriteBuffer(Data,FileSize.QuadPart mod FILEPART_SIZE,true);
        end;
         
      end;
      CloseHandle(hFile);
      hFile:=INVALID_HANDLE_VALUE;
//      MainForm.ShowBalloonTips(Format('为%s提供的更新结束。',[AThread.Connection.Socket.Binding.PeerIP]),'更新结束',NIIF_INFO);
    end;
//  end;

  except
    CloseHandle(hFile);
    MainForm.ShowBalloonTips(WideFormat(_('与 %s 的连接被断开。'),[AThread.Connection.Socket.Binding.PeerIP]),_('错误'),NIIF_ERROR);
//    MainForm.ShowBalloonTips(WideFormat(_('The connection to %s is disconnected.'),[AThread.Connection.Socket.Binding.PeerIP]),_('Error'),NIIF_ERROR);
  end;

  AThread.Connection.Disconnect;

  HeaderReceived.Properties.Destroy;
  HeaderToSend.Properties.Destroy;


end;

procedure TMainForm.AddSysTrayIcon;
begin
  IconData.cbSize := SizeOf(IconData);
//  IconData.Wnd := AllocateHWnd(SysTrayIconMsgHandler);
  IconData.Wnd:=Handle;
  {SysTrayIconMsgHandler is then callback message' handler}
  IconData.uID := 100;
  IconData.uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
  IconData.uCallbackMessage := TRAY_CALLBACK;   //user defined callback message
  IconData.hIcon := Application.Icon.Handle;    //an Icon's Handle
  Shell_NotifyIcon(NIM_ADD, @IconData);
  ModifySysTrayIcon;
end;

procedure TMainForm.ShowBalloonTips(TipInfo, TipTitle: string; Flags: cardinal);
begin
//  ModifySysTrayIcon;
  IconData.cbSize := SizeOf(IconData);
  IconData.uFlags := NIF_INFO;
  strPLCopy(IconData.szInfo, TipInfo, SizeOf(IconData.szInfo) - 1);
  IconData.DUMMYUNIONNAME.uTimeout := 3000;
  strPLCopy(IconData.szInfoTitle, TipTitle, SizeOf(IconData.szInfoTitle) - 1);
  IconData.dwInfoFlags := Flags;     //NIIF_ERROR;  //NIIF_WARNING;
  Shell_NotifyIcon(NIM_MODIFY, @IconData); 
  {in my testing, the following code has no use}
  IconData.DUMMYUNIONNAME.uVersion := NOTIFYICON_VERSION;


  Shell_NotifyIcon(NIM_SETVERSION, @IconData);         
end;


procedure TMainForm.DeleteSysTrayIcon;
begin
  Shell_NotifyIcon(NIM_DELETE, @IconData);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  DeleteSysTrayIcon;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  SetProcessWorkingSetSize(GetCurrentProcess,$ffffffff,$ffffffff);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  DataToSend: TPacket;
begin
  InitPacket(DataToSend);
  DataToSend.dwOperation:=PO_OFFLINE;
  try
    udp.SendBuffer('255.255.255.255',12575,DataToSend,sizeof(DataToSend));
    udp.SendBuffer('255.255.255.255',12574,DataToSend,sizeof(DataToSend));
  except
  end;
  WriteMySet(ClientInfo);
end;

procedure TMainForm.Timer2Timer(Sender: TObject);
var
  i:integer;
  Max, MaxCount, this: integer;
  DataToSend: TPacket;
begin
  Timer2.Interval:=random(8000)+1000;


  try
    InitPacket(DataToSend);
    DataToSend.dwOperation:=PO_ONLINE;
    udp.SendBuffer('255.255.255.255',12575,DataToSend,sizeof(DataToSend));
    udp.SendBuffer('255.255.255.255',12574,DataToSend,sizeof(DataToSend));
  except
  end;

  max:=ClientInfo.Version;
  maxcount:=0;

  for i:=0 to Clients.Count-1 do begin
    if Clients.Items[i].Info.Version>max then begin
      max:=Clients.Items[i].Info.Version;
      maxcount:=1;
    end
    else if Clients.Items[i].Info.Version=max then
      inc(maxcount);
  end;

//  writeln('found ',maxcount,' newer clients.');

  if max=ClientInfo.Version then
    exit;

  this:=random(maxcount)+1;

  for i:=0 to Clients.Count-1 do
    if Clients.Items[i].Info.Version=max then begin
      dec(this);
      if this=0 then begin
        with TAutoUpdateThread.Create(false) do begin
//          writeln('update with ',Clients.Items[i].IP);
          Host:=Clients.Items[i].IP;
          Resume;
        end;
        exit;
      end;
    end;
end;

procedure TMainForm.ModifySysTrayIcon;
var
  x: widestring;
  xx: string;
begin
  IconData.uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
  x:='选手名称: '+' '+UTF8Decode(ClientInfo.Name)+#13#10+'工作目录: '+' '+UTF8Decode(ClientInfo.WorkDir);
  if Length(x)>128 then x:=copy(x,1,125)+'...';
  xx:=x;
  Strlcopy(@IconData.szTip,pchar(xx),sizeof(IconData.szTip));
  Shell_NotifyIcon(NIM_MODIFY, @IconData);
end;

procedure TMainForm.CheckNames;
var
  i: integer;
  have: boolean;
  LastStatus: integer;
  DataToSend: TPacket;
begin
  have:=false;
  for i:=0 to Clients.Count-1 do
    if SameFileName(Clients.Items[i].Info.Name,ClientInfo.Name) then begin
      have:=true;
      break;
    end;
  LastStatus:=ClientInfo.Status;
  if have then begin
    MainForm.ShowBalloonTips(WideFormat(_('本客户端的选手名称与 %s 相同。请更改您的选手名称。'),[Clients.Items[i].IP]),_('名称相同'),NIIF_ERROR);
//    MainForm.ShowBalloonTips(WideFormat(_('The contestant name of is the same as the one of %s. Please change your contestant name.'),[Clients.Items[i].IP]),_('Duplicated Names'),NIIF_ERROR);
    ClientInfo.Status:=CS_NAME_CONF;
    // !!!给服务端发送消息
  end else ClientInfo.Status:=CS_OK;
  if LastStatus<>ClientInfo.Status then begin
    InitPacket(DataToSend);
    DataToSend.dwOperation:=PO_ONLINE;
    try
      MainForm.UDP.SendBuffer('255.255.255.255',12575,DataToSend,sizeof(DataToSend));
    except
    end;
//    MainForm.UDP.SendBuffer('255.255.255.255',12574,DataToSend,sizeof(DataToSend));
  end;
end;

function TMainForm.CheckStr(st: widestring): integer;
var
  i: integer;
begin
  for i:=1 to Length(st) do
    if not CanBeFN[ord(st[i])] then begin
      Result:=i;
      exit;
    end;
  Result:=0;
end;

function TMainForm.CheckMyName(NewName: widestring): widestring;
var
  i: integer;
begin
  i:=CheckStr(NewName);
  while i>0 do begin
    Delete(NewName,i,1);
    i:=CheckStr(NewName);
  end;
  Result:=trim(NewName);
end;

procedure TMainForm.ApplyClientSetting;
begin
  X1.Visible:=ClientInfo.Permissions>0;
  if OptionForm<>nil then with OptionForm do begin
    Button1.Enabled:=not(ClientInfo.Permissions=0);
    button2.Enabled:=not(ClientInfo.Permissions=0);
    AutoRun.Enabled:=not(ClientInfo.Permissions=0);
    rb1.Enabled:=not(ClientInfo.Permissions=0);
    rb2.Enabled:=not(ClientInfo.Permissions=0);
    MyName.ReadOnly:=(ClientInfo.Permissions=0)or(ClientInfo.UsesComputerName);
    MyWorkPath.ReadOnly:=(ClientInfo.Permissions=0);
    if ClientInfo.Permissions=0 then begin
      MyName.Color:=clBtnFace;
      MyWorkPath.Color:=clBtnFace;
    end else begin
      MyName.Color:=clWindow;
      MyWorkPath.Color:=clWindow;
    end;
  end;
end;


initialization
  Clients:=TClients.Create;

finalization
  Clients.Destroy;

end.

