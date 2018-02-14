unit CIFormU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPServer,
  IdCustomHTTPServer, IdHTTPServer, IdGlobal, jvgnugettext;

type
  TCIForm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    hs1: TIdHTTPServer;
    mmo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure hs1CommandGet(AThread: TIdPeerThread;
      ARequestInfo: TIdHTTPRequestInfo;
      AResponseInfo: TIdHTTPResponseInfo);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    FText: string;
  public
  published
    procedure AddLog(AText: string);
    { Public declarations }
  end;

  TAddLog=object
    Text: string;
    procedure AddLog; overload;
    procedure AddLog(AText: string); overload;
  end;

var
  CIForm: TCIForm;
  exepath: string;

implementation

{$R *.dfm}

procedure TCIForm.Button1Click(Sender: TObject);
var
  AddLog: TAddLog;
begin
  if not hs1.Active then begin
    try
      hs1.Bindings.Clear;
      hs1.DefaultPort:=strtoint(edit1.Text);
      hs1.Active:=true;
      AddLog.AddLog(_('Service started.'));
      Button1.Caption:=_('&Stop Service');
    except
//      MessageBoxW(handle,pwidechar(_('Unable to start the service.')+#13#10#13#10+WideFormat(_('Error %d: %s'),[getlasterror,SysErrorMessage(getlasterror)])),'',0);
      MessageBoxW(handle,pwidechar(_('Unable to start service.')),pwidechar(_('Error')),MB_ICONERROR);
    end;
  end else begin
    try
      hs1.Active:=false;
      AddLog.AddLog(_('Service stopped.'));
      Button1.Caption:=_('&Start Service');
    except
//      MessageBox(handle,pchar(SysErrorMessage(getlasterror)),'',0);
    end;
  end;
end;

procedure TCIForm.hs1CommandGet(AThread: TIdPeerThread;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  AFile: string;
  AddLog: TAddLog;
  PeerIP: string;
begin
  if ARequestInfo.Document='/' then
    AResponseInfo.Redirect('cenaclient-install.exe')
  else begin
    afile:=exepath+'\cenaclient-install.exe';
    PeerIP:=AThread.Connection.Socket.Binding.PeerIP;
    try
      AResponseInfo.ContentType := 'application/octet-stream';
      AResponseInfo.ContentLength := FileSizeByName(aFile);
      AResponseInfo.WriteHeader;
      AThread.Connection.WriteFile(aFile);
      AThread.Connection.Disconnect;
      AddLog.Text:=WideFormat(_('%s downloaded successfully.'),[PeerIP]);
      AThread.Synchronize(AddLog.AddLog);
    except
      AddLog.Text:=WideFormat(_('%s downloaded unsuccessfully.'),[PeerIP]);
      AThread.Synchronize(AddLog.AddLog);
    end;
  end;
end;

procedure TCIForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
  CIForm:=nil;
end;

procedure TCIForm.FormCreate(Sender: TObject);
begin
  SetWindowLong(Edit1.Handle, GWL_STYLE, GetWindowLong(Edit1.Handle, GWL_STYLE) or ES_NUMBER);
  TranslateComponent(self);
end;

procedure TCIForm.AddLog(AText: string);
begin
  mmo1.Lines.Add(AText);
end;

procedure TAddLog.AddLog;
begin
  CIForm.mmo1.Lines.Add('['+TimeToStr(Now)+'] '+Text);
end;

procedure TAddLog.AddLog(AText: string);
begin
  Text:=AText;
  AddLog;
end;

initialization
  exepath:=application.exename;
  while exepath[length(exepath)]<>'\' do
    delete(exepath,length(exepath),1);
end.
