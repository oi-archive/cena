unit OptionFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, shlobj, registry, libojcd, myutils, ExtCtrls;

type
  TOptionForm = class(TForm)
    Label1: TLabel;
    MyWorkPath: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label2: TLabel;
    MyName: TEdit;
    AutoRun: TCheckBox;
    Bevel1: TBevel;
    bvl1: TBevel;
    bvl2: TBevel;
    rb1: TRadioButton;
    rb2: TRadioButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure MyNameChange(Sender: TObject);
    procedure rb1Click(Sender: TObject);
  private
    { Private declarations }
  public
  published
    { Public declarations }
    procedure Checkrb1;
  end;

var
  OptionForm: TOptionForm;

implementation

uses MainFormUnit, jvgnugettext;

{$R *.dfm}

procedure CheckAutoBoot(AutoBoot: boolean);
var f: TReginifile;
begin
  if AutoBoot then begin
    f:=treginifile.Create;
    f.RootKey:=HKEY_CURRENT_USER;
    f.WriteString('Software\Microsoft\Windows\CurrentVersion\Run','Client',Paramstr(0));
    f.Free;
  end else begin
    f:=treginifile.Create;
    f.RootKey:=HKEY_CURRENT_USER;
    f.DeleteKey('Software\Microsoft\Windows\CurrentVersion\Run','Client');
    f.Free;
  end;
end;

function RegAutoRun: boolean;
var f: TReginifile;
begin
  f:=treginifile.Create;
  f.RootKey:=HKEY_CURRENT_USER;

  if UpperCase(paramstr(0))=UpperCase(f.ReadString('Software\Microsoft\Windows\CurrentVersion\Run','Client','')) then
    Result:=true
  else Result:=false;
  f.Free;
end;

procedure TOptionForm.FormShow(Sender: TObject);
var
  s: string;
begin
  rb1.Checked:=ClientInfo.UsesComputerName;
  rb2.Checked:=not ClientInfo.UsesComputerName;
  Checkrb1;
  MyName.Text:=UTF8Decode(ClientInfo.Name);
  MyWorkPath.Text:=UTF8Decode(ClientInfo.WorkDir);
  AutoRun.Checked:=ClientInfo.AutoStartUp;
  MainForm.ApplyClientSetting;
{  AutoRun.Checked:=RegAutoRun;}
end;

procedure TOptionForm.Button1Click(Sender: TObject);
var
  s: string;
begin
//  s:=BrowseforFile(Handle,_('Please choose your working directory'),'','');
  s:=BrowseforFile(Handle,_('请选择您的工作目录'),'','');
  if s<>'' then
    MyWorkPath.Text:=s;
end;

function StrInStrs(s:widestring; strs: array of widestring):boolean;
var
  i:integer;
begin
  for i:=low(strs) to high(strs) do
    if samefilename(s,strs[i]) then begin
      result:=true;
      exit;
    end;
  result:=false;
end;

procedure TOptionForm.Button2Click(Sender: TObject);
var
  DataToSend: TPacket;
  i: integer;
  Have: boolean;
begin
  MyName.Text:=MainForm.CheckMyName(MyName.Text);
  if MyName.Text='' then begin
//    MessageBoxW(Handle,pwidechar(_('Please input your contestant name.')),pwidechar(_('Error')),MB_ICONERROR);
    MessageBoxW(Handle,pwidechar(_('请输入选手名称。')),pwidechar(_('错误')),MB_ICONERROR);
    MyName.SetFocus;
    exit;
  end;

  Have:=false;
  for i:=0 to Clients.Count-1 do
    if SameFileName(Clients.Items[i].Info.Name,MyName.Text) then begin
      Have:=true;
      break;
    end;
  if Have then begin
    MessageBoxW(Handle,pwidechar(WideFormat('与 %s 的选手名称相同。',[Clients.Items[i].IP])),pwidechar(_('错误')),MB_ICONERROR);
//    MessageBoxW(Handle,pwidechar(Format('Duplicated contestant name with %s.',[Clients.Items[i].IP])),pwidechar(_('Error')),MB_ICONERROR);
    exit;
  end;

  if strinstrs(MyName.Text,['con','nul','clock$','aux','lpt1','lpt2','lpt3','lpt4','com1','com2','com3','com4']) then begin
    MessageBoxW(Handle,pwidechar(WideFormat(_('"%s" 是 DOS 设备名称。'),[UpperCase(MyName.Text)])),pwidechar(_('错误')),MB_ICONERROR);
//    MessageBoxW(Handle,pwidechar(Format(_('"%s" 是is a DOS device name.'),[UpperCase(MyName.Text)])),pwidechar(_('Error')),MB_ICONERROR);
    exit;
  end;

    

  ClientInfo.UsesComputerName:=rb1.Checked;
  ClientInfo.AutoStartUp:=AutoRun.Checked;
  CheckAutoBoot(AutoRun.Checked);
  StrLCopy(ClientInfo.Name,pchar(UTF8Encode(myname.Text)),sizeof(ClientInfo.Name));
  StrLCopy(ClientInfo.WorkDir,pchar(UTF8Encode(myworkpath.Text)),sizeof(ClientInfo.WorkDir));

  WriteMySet(ClientInfo);
  MainForm.ModifySysTrayIcon;

  InitPacket(DataToSend);
  DataToSend.dwOperation:=PO_ONLINE;
  try
    MainForm.UDP.SendBuffer('255.255.255.255',12575,DataToSend,sizeof(DataToSend));
    MainForm.UDP.SendBuffer('255.255.255.255',12574,DataToSend,sizeof(DataToSend));
  except
  end;

  Close;
end;

procedure TOptionForm.Button3Click(Sender: TObject);
begin
  WriteMySet(ClientInfo);
  Close;
end;

procedure TOptionForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
  OptionForm:=nil;
end;

procedure TOptionForm.FormCreate(Sender: TObject);
var
  rStyle: cardinal;
begin
  rStyle:=GetWindowLong(Handle, GWL_EXSTYLE);
  rStyle := (rStyle or WS_EX_NOPARENTNOTIFY);
  SetWindowLong(Handle, GWL_EXSTYLE, rStyle);
  SetWindowPos(Handle, 0, 0, 0, 0, 0, $1 Or $2 Or $4 Or $20);
  TranslateComponent(self);
end;

procedure TOptionForm.MyNameChange(Sender: TObject);
begin
  MyName.Text:=MainForm.CheckMyName(MyName.Text);
end;

procedure TOptionForm.Checkrb1;
begin
  MyName.ReadOnly:=rb1.Checked;
  if rb1.Checked then MyName.Text:=ComputerName;
end;

procedure TOptionForm.rb1Click(Sender: TObject);
begin
  Checkrb1;
end;

end.

