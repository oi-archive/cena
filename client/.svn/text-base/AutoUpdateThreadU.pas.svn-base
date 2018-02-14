unit AutoUpdateThreadU;

interface

uses
  Classes, IdTCPClient, libojcd, windows, Forms, sysutils;

type
  TAutoUpdateThread = class(TThread)
  private
  protected
    procedure Execute; override;
    procedure BeforeUpdate;
    procedure AfterUpdate;
  public
    Host: string;
  
  end;

implementation

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TAutoUpdateThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }

{ TAutoUpdateThread }

uses
  MainFormUnit;

procedure TAutoUpdateThread.AfterUpdate;
begin
  MainForm.timer2.Enabled:=true;
end;

procedure TAutoUpdateThread.BeforeUpdate;
begin
  MainForm.timer2.Enabled:=false;
end;

procedure TAutoUpdateThread.Execute;
var
  tcp: TIdTCPClient;
  HeaderToSend, HeaderReceived: THeader;
  TempFile: array[0..255] of char;
  si: _STARTUPINFOA;
  pi: _PROCESS_INFORMATION;
  i:integer;
//  p: pointer;
  FileSize: int64;
  size: cardinal;
  Data: array[0..FILEPART_SIZE-1] of byte;
  tmppath: array[0..255]of char;
  hFile: cardinal;
  mapi: cardinal;
begin

  Synchronize(BeforeUpdate);
  HeaderToSend.Properties:=TPropertyList.Create;
  HeaderReceived.Properties:=TPropertyList.Create;

  tcp:=TIdTCPClient.Create(nil);
  tcp.Host:=Host;
  tcp.Port:=12574;

  try
    tcp.Connect;

    HeaderToSend.Command:='UPDATE';
    HeaderToSend.Properties.Clear;
    HeaderToSend.WriteTo(tcp);

    HeaderReceived.ReadFrom(tcp);

    if HeaderReceived.Command='OK' then begin
      FileSize:=0;
      for i:=0 to HeaderReceived.Properties.Count-1 do
        if HeaderReceived.Properties.Name[i]='Content-Length' then
          FileSize:=strtoint(HeaderReceived.Properties.Value[i]);

//    writeln('requesting update, size=',filesize);

      size:=sizeof(tmppath);
      windows.GetTempPath(size,@tmppath);
      windows.GetTempFileName(@tmppath,'ojcd',0,@TempFile);

      hFile:=CreateFile(@TempFile,GENERIC_WRITE,FILE_SHARE_WRITE,nil,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE or FILE_ATTRIBUTE_TEMPORARY,0);

      if hFile=INVALID_HANDLE_VALUE then
        raise Exception.Create('cannot create file.');
      for i:=1 to FileSize div FILEPART_SIZE do begin
        tcp.ReadBuffer(Data,FILEPART_SIZE);
        WriteFile(hFile,Data,FILEPART_SIZE,mapi,nil);
      end;
      if FileSize mod FILEPART_SIZE>0 then begin
        tcp.ReadBuffer(Data,FileSize mod FILEPART_SIZE);
        WriteFile(hFile,Data,FileSize mod FILEPART_SIZE,mapi,nil);
      end;
      CloseHandle(hFile);

//    writeln('saved in ',TempFile);

      fillchar(si,sizeof(si),0);
      si.cb:=sizeof(si);
      if CreateProcess(Tempfile,pchar(Tempfile+' -u '+inttostr(MainForm.Handle)),nil,nil,false,0,nil,nil,si,pi) then begin
//      writeln('ok to createprocess');
        CloseHandle(pi.hProcess);
        CloseHandle(pi.hThread);
        tcp.Disconnect;
        Synchronize(MainForm.Close);
      end
      else begin
        raise Exception.Create('');
//      writeln('failed to createprocess.');
      end;
    end;

  except
    Synchronize(AfterUpdate);
  end;

  tcp.Disconnect;

  tcp.Destroy;
  HeaderToSend.Properties.Destroy;
  HeaderReceived.Properties.Destroy;
end;

end.

