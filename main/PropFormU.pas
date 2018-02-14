unit PropFormU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ojtc, libojcd, jvgnugettext, ComCtrls, ojrc;

type
  TPropForm = class(TForm)
    bvl1: TBevel;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    _address: TEdit;
    _os: TEdit;
    _name: TEdit;
    Label5: TLabel;
    _workdir: TEdit;
    _id: TEdit;
    Label6: TLabel;
    lblTotalFileSize: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    _perm: TCheckBox;
    Label1: TLabel;
    Label8: TLabel;
    _usescomputername: TCheckBox;
    _autorun: TCheckBox;
    PageControl1: TPageControl;
    tsLocalPage: TTabSheet;
    tsRemotePage: TTabSheet;
    Bevel1: TBevel;
    lblHighestScore: TLabel;
    lblLowestScore: TLabel;
    lblLowestRank: TLabel;
    lblHighestRank: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    Peoples: array of TPeople;
    peoplesCount: integer;
  end;

var
  PropForm: TPropForm;

implementation

uses MainFormU;

var
  ClientCount: integer;
  LocalCount: integer;


{$R *.dfm}

procedure TPropForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin
  for i:=0 to PeoplesCount-1 do
    if Peoples[i]<>nil then Peoples[i].PropWnd:=nil;
  Action:=caFree;
end;

procedure TPropForm.FormShow(Sender: TObject);
const
  MaxNamesLong=56;
var
  i: integer;
  Remotes,Locals: widestring;
  RTooLong,LTooLong: boolean;
  pr: TPeople;
  HighestScore,LowestScore: double;
  HighestScoreTIme,LowestScoreTime: double;
  HighestRank,LowestRank: integer;
  TotalFileSize: int64;
begin
  Remotes:='';  Locals:='';
  RTooLong:=false;  LTooLong:=false;
  ClientCount:=0;
  LocalCount:=0;
  TotalFileSize:=0;
  HighestScore:=0;
  LowestScore:=-Maxlongint;
  HighestRank:=Maxlongint;
  LowestRank:=0;
  pr:=nil;
  for i:=0 to PeoplesCount-1 do if Peoples[i]<>nil then begin

    if Peoples[i].HasResult then begin
      if StrToInt(TListItem(peoples[i].Data1).SubItems[0])<HighestRank then begin
        HighestRank:=StrToInt(TListItem(peoples[i].Data1).SubItems[0]);
        HighestScore:=StrToFloat(TListItem(peoples[i].Data1).SubItems[1]);
        HighestScoreTime:=StrToFloat(TListItem(peoples[i].Data1).SubItems[2]);
      end;
      if StrToInt(TListItem(peoples[i].Data1).SubItems[0])>LowestRank then begin
        LowestRank:=StrToInt(TListItem(peoples[i].Data1).SubItems[0]);
        LowestScore:=StrToFloat(TListItem(peoples[i].Data1).SubItems[1]);
        LowestScoreTime:=StrToFloat(TListItem(peoples[i].Data1).SubItems[2]);
      end;
      // Calc Total File Size
    end;

    if Peoples[i].Client<>nil then begin
      inc(ClientCount);
      pr:=Peoples[i];
      if not RTooLong then
        if Length(Remotes+Peoples[i].Name+',')>MaxNamesLong then begin
          delete(Remotes,Length(Remotes),1);
          Remotes:=Remotes+' ...';
          RTooLong:=true;
        end else Remotes:=Remotes+Peoples[i].Name+',';
    end;
    if Peoples[i].HasLocalFolder then begin
      inc(LocalCount);
      if not LTooLong then
        if Length(Locals+Peoples[i].Name+',')>MaxNamesLong then begin
          delete(Locals,Length(Locals),1);
          Locals:=Locals+' ...';
          LTooLong:=true;
        end else Locals:=Locals+Peoples[i].Name+',';
    end;
  end;
  if (Length(Remotes)>0)and(Remotes[Length(Remotes)]=',') then delete(Remotes,Length(Remotes),1);
  if (Length( Locals)>0)and( Locals[Length( Locals)]=',') then delete( Locals,Length( Locals),1);
  if ClientCount>0 then begin
    Label1.Caption:=WideFormat(_('%s (%d contestants)'),[Remotes,ClientCount]);
    PageControl1.ActivePageIndex:=1;
  end
  else
    Label1.Caption:=_('(none)');
  tsRemotePage.Enabled:=ClientCount>0;
  GroupBox1.Visible:=ClientCount>0;

  if LocalCount>0 then begin
    Label8.Caption:=WideFormat(_('%s (%d contestants)'),[Locals,LocalCount]);
    PageControl1.ActivePageIndex:=0;
  end
  else
    Label8.Caption:=_('(none)');
  tsLocalPage.Enabled:=LocalCount>0;
  lblTotalFileSize.Caption:=_(lblTotalFileSize.Caption+IntToStr(TotalFileSize));
  lblHighestScore.Caption:=_(lblHighestScore.Caption+FloatToStr(HighestScore)+' ('+FloatToStr(HighestScoreTime)+'s)');
  lblLowestScore.Caption:=_(lblLowestScore.Caption+FloatToStr(LowestScore)+' ('+FloatToStr(LowestScoreTime)+'s)');
  lblHighestRank.Caption:=_(lblHighestRank.Caption+IntToStr(HighestRank));
  lblLowestRank.Caption:=_(lblLowestRank.Caption+IntToStr(LowestRank));

//  lblTotalFileSize.Visible:=LocalCount>0;
  lblHighestScore.Visible:=LocalCount>0;
  lblLowestScore.Visible:=LocalCount>0;
  lblHighestRank.Visible:=LocalCount>0;
  lblLowestRank.Visible:=LocalCount>0;

  if ClientCount=0 then
    GroupBox1.Visible:=false
  else
  if ClientCount=1 then begin
    GroupBox1.Visible:=true;
    _id.Text:=ClientToStr(pr.Client.Info.ClientID);
    _address.Text:=pr.Client.IP;
    _os.Text:=pr.Client.Info.OperatingSystem;
    _name.Text:=pr.Name;
    _workdir.Text:=UTF8Decode(pr.Client.Info.WorkDir);
    _perm.Checked:=pr.Client.Info.Permissions=1;
    _perm.AllowGrayed:=false;
    _usescomputername.Checked:=pr.Client.Info.UsesComputerName;
    _usescomputername.AllowGrayed:=false;
    _autorun.Checked:=pr.Client.Info.AutoStartUp;
    _autorun.AllowGrayed:=false;
  end else begin
    GroupBox1.Visible:=true;
    _id.Text:='';       _id.Enabled:=false;       _id.Color:=clBtnFace;
    _address.Text:='';  _address.Enabled:=false;  _address.Color:=clBtnFace;
    _os.Text:='';       _os.Enabled:=false;       _os.Color:=clBtnFace;
    _name.Text:='';     _name.Enabled:=false;     _name.Color:=clBtnFace;
    _workdir.Text:='';
    _perm.AllowGrayed:=true;
    _perm.State:=cbGrayed;
    _usescomputername.AllowGrayed:=true;
    _usescomputername.State:=cbGrayed;
    _autorun.AllowGrayed:=true;
    _autorun.State:=cbGrayed;
  end;
end;

procedure TPropForm.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TPropForm.Button3Click(Sender: TObject);
var
  DataToSend: TPacket;
  i: integer;
begin
  InitPacket(DataToSend);
  DataToSend.dwOperation:=PO_SHOW_TEST_MESSAGE;

  for i:=0 to PeoplesCount-1 do
    if Peoples[i].Client<>nil then
      MainForm.udp.SendBuffer(Peoples[i].Client.IP,12574,DataToSend,sizeof(DataToSend));

  MessageBoxW(Handle,pwidechar(_('The test message has been sent.')),pwidechar(_('Information')),MB_ICONINFORMATION);
end;

procedure TPropForm.Button1Click(Sender: TObject);
var
  DataToSend: TPacket;
  i: integer;
begin
  for i:=0 to PeoplesCount-1 do
    if Peoples[i].Client<>nil then begin
      InitPacket(DataToSend);
      DataToSend.dwOperation:=PO_CHANGESETTING;
      DataToSend.ClientInfo:=Peoples[i].Client.Info;

      if ClientCount=1 then
        StrLCopy(DataToSend.ClientInfo.Name,pchar(UTF8Encode(_name.Text)),sizeof(ClientInfo.Name));

      if Length(_workdir.Text)>0 then 
        StrLCopy(DataToSend.ClientInfo.WorkDir,pchar(UTF8Encode(_workdir.Text)),sizeof(ClientInfo.WorkDir));

      if _perm.State<>cbGrayed then
        if _perm.Checked then DataToSend.ClientInfo.Permissions:=1
        else DataToSend.ClientInfo.Permissions:=0;

      if _usescomputername.State<>cbGrayed then
        DataToSend.ClientInfo.UsesComputerName:=_usescomputername.Checked;

      if _autorun.State<>cbGrayed then
        DataToSend.ClientInfo.AutoStartUp:=_autorun.Checked;

      MainForm.udp.SendBuffer(Peoples[i].Client.IP,12574,DataToSend,sizeof(DataToSend));
    end;
  Close;
end;

procedure TPropForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

end.
