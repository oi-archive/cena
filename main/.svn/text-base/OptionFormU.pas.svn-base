unit OptionFormU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, IniFiles, ExtCtrls, MyTypes, ojtc, CheckLst, jvgnugettext;
                  
type
  TOptionForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    PageControl1: TPageControl;
    TabSheet2: TTabSheet;
    Button3: TButton;
    Button4: TButton;
    Button8: TButton;
    Button9: TButton;
    grp1: TGroupBox;
    lbl1: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    _commandline: TEdit;
    _title: TEdit;
    _extension: TEdit;
    Label1: TLabel;
    Label5: TLabel;
    _executable: TEdit;
    lv1: TListView;
    TabSheet1: TTabSheet;
    Bevel1: TBevel;
    Label6: TLabel;
    Bevel2: TBevel;
    Panel1: TPanel;
    Label7: TLabel;
    Panel2: TPanel;
    Label8: TLabel;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    Label9: TLabel;
    Label10: TLabel;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    Panel3: TPanel;
    Label14: TLabel;
    Edit2: TEdit;
    Label11: TLabel;
    Edit3: TEdit;
    Label12: TLabel;
    Edit4: TEdit;
    Label13: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Bevel4: TBevel;
    procedure _titleChange(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure lv1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lv1Changing(Sender: TObject; Item: TListItem;
      Change: TItemChange; var AllowChange: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure _extensionChange(Sender: TObject);
    procedure lv1DblClick(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lv1Click(Sender: TObject);
  private
    { Private declarations }
  public
  published
    procedure CheckEdit1;
    procedure LockLv1;
    procedure UnLockLv1;
    { Public declarations }
  end;

var
  OptionForm: TOptionForm;

implementation

uses MainFormU;

{$R *.dfm}

var
  OldOnChanging: TLVChangingEvent;
  OldOnChange: TLVChangeEvent;

procedure TOptionForm._titleChange(Sender: TObject);
begin
  if lv1.SelCount=1 then
    lv1.Selected.Caption:=_title.Text;
end;

procedure TOptionForm.Button4Click(Sender: TObject);
var
  p: ptagCompiler;
  i: integer;
begin
  LockLv1;
  for i:=lv1.Items.Count-1 downto 0 do if lv1.Items.Item[i].Selected then begin
    p:=lv1.Items.Item[i].Data;
    lv1.Items.Item[i].Delete;
    FreeMem(p,sizeof(tagCompiler));
  end;
  UnLockLv1;
  lv1Change(nil,nil,ctState);
end;

procedure TOptionForm.Button3Click(Sender: TObject);
var
  P: ptagCompiler;
begin
  lv1.ClearSelection;
  with lv1.Items.Add do begin
    new(P);
    Data:=P;
    ZeroMemory(P,sizeof(tagCompiler));
    P.Active:=true;
    P.Title:=_('New Compiler');
    P.Extension:='';
    P.CommandLine:=' %s';
    P.Executable:='%s.exe';

    LockLv1;
    Caption:=_('New Compiler');
    SubItems.Add('');
    Checked:=true;
    UnLockLv1;
    
    selected:=true;
  end;
end;

procedure TOptionForm.Button2Click(Sender: TObject);
var
  i:integer;
  AllowChange: boolean;
  p: ptagcompiler;
begin
  // Notmal setting
  Judge.Settings.NormalSet.CollectFileCorrelative:=OptionForm.CheckBox2.Checked;
  Judge.Settings.NormalSet.CollectExtCorrelative:=CheckBox3.Checked;
  Judge.Settings.NormalSet.FileSizeLimitB:=CheckBox1.Checked;
  Judge.Settings.NormalSet.FileSizeLimit:=StrToInt(Edit1.Text)*1024;
  Judge.Settings.NormalSet.DefaultScore:=StrToInt(Edit2.Text);
  Judge.Settings.NormalSet.DefaultMemL:=StrToInt(Edit4.Text);
  Judge.Settings.NormalSet.DefaultTimeL:=StrToFloat(Edit3.Text);
  // compiler
  AllowChange:=true;
  if lv1.SelCount=1 then
    lv1Changing(nil,lv1.Selected,ctImage,AllowChange);
  if AllowChange=false then exit;

  lv1.OnChanging:=nil;

  Judge.Settings.Compilers.Clear;
  for i:=0 to lv1.Items.Count-1 do begin
    with Judge.Settings.Compilers.Add do begin
      p:=lv1.Items[i].Data;
      p.Active:=lv1.Items[i].Checked;
      MoveFrom(lv1.Items[i].Data);
    end;
  end;

  Judge.Settings.Save;

  Close;
end;

procedure TOptionForm.lv1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  P:ptagCompiler;
begin
  LockLv1;
  grp1.Visible:=lv1.SelCount=1;
  if lv1.SelCount=1 then begin
    button4.Enabled:=true;
    button8.Enabled:=true;
    button9.Enabled:=true;
    if lv1.Items[0].Selected then
      button8.Enabled:=false;
    if lv1.Items[lv1.Items.Count-1].Selected then
      button9.Enabled:=false;

    P:=lv1.Selected.Data;
    _title.Text:=P.Title;
    _extension.Text:=P.Extension;
    _commandline.Text:=P.CommandLine;
    _executable.Text:=P.Executable;
    lv1.Selected.Caption:=P.Title;
    lv1.Selected.SubItems.Strings[0]:=p.Extension;
    //lv1.Selected.Checked:=P.Active;
  end;
  if lv1.SelCount=0 then begin
    button4.Enabled:=false;
    button8.Enabled:=false;
    button9.Enabled:=false;
  end;
  if lv1.SelCount>1 then begin
    button4.Enabled:=true;
    button8.Enabled:=true;
    button9.Enabled:=true;
    if lv1.Items[0].Selected then
      button8.Enabled:=false;
    if lv1.Items[lv1.Items.Count-1].Selected then
      button9.Enabled:=false;
  end;
  UnLockLv1;
end;

procedure TOptionForm.lv1Changing(Sender: TObject; Item: TListItem;
  Change: TItemChange; var AllowChange: Boolean);
var
  P:ptagCompiler;
begin
  if lv1.SelCount=1 then begin
    P:=lv1.Selected.Data;
    P.Title:=_title.Text;
    P.Extension:=_extension.Text;
    P.CommandLine:=_commandline.Text;
    P.Executable:=_executable.Text;
  end;
end;

procedure TOptionForm.Button1Click(Sender: TObject);
begin
  lv1.OnChanging:=nil;
end;

procedure TOptionForm._extensionChange(Sender: TObject);
begin
  if lv1.SelCount=1 then
    lv1.Selected.SubItems.Strings[0]:=_extension.Text;
end;

procedure TOptionForm.lv1DblClick(Sender: TObject);
begin
  if lv1.SelCount=1 then _title.SetFocus;
end;

procedure TOptionForm.Button8Click(Sender: TObject);
var
  i: integer;
  xd: ptagcompiler;
  xc,xe: string;
  xch: boolean;
begin
  LockLv1;
  for i:=1 to lv1.Items.Count-1 do if lv1.Items.Item[i].Selected then begin
    xc:=lv1.Items.Item[i-1].Caption;
    xe:=lv1.Items.Item[i-1].SubItems.Strings[0];
    xd:=lv1.Items.Item[i-1].Data;
    xch:=lv1.Items.item[i-1].Checked;
    lv1.Items.Delete(i-1);
    with lv1.Items.Insert(i) do begin
      Caption:=xc;
      SubItems.Add(xe);
      Data:=xd;
      Checked:=xch;
    end;
  end;
  UnLockLv1;
  button4.Enabled:=true;
  button8.Enabled:=true;
  button9.Enabled:=true;
  if lv1.Items[0].Selected then
    button8.Enabled:=false;
  if lv1.Items[lv1.Items.Count-1].Selected then
    button9.Enabled:=false;
end;

procedure TOptionForm.Button9Click(Sender: TObject);
var
  i: integer;
  xd: ptagcompiler;
  xc,xe: string;
  xch: boolean;
begin
  LockLv1;
  for i:=lv1.Items.Count-2 downto 0 do if lv1.Items.Item[i].Selected then begin
    xc:=lv1.Items.Item[i+1].Caption;
    xe:=lv1.Items.Item[i+1].SubItems.Strings[0];
    xd:=lv1.Items.Item[i+1].Data;
    xch:=lv1.Items.item[i+1].Checked;
    lv1.Items.Delete(i+1);
    with lv1.Items.Insert(i) do begin
      Caption:=xc;
      SubItems.Add(xe);
      Data:=xd;
      Checked:=xch;
    end;
  end;
  UnLockLv1;
  button4.Enabled:=true;
  button8.Enabled:=true;
  button9.Enabled:=true;
  if lv1.Items[0].Selected then
    button8.Enabled:=false;
  if lv1.Items[lv1.Items.Count-1].Selected then
    button9.Enabled:=false;
end;

procedure TOptionForm.CheckEdit1;
begin
  if CheckBox1.Checked then begin
    Edit1.Color:=clWindow;
    Edit1.Enabled:=true;
  end else begin
    Edit1.Color:=clBtnFace;
    Edit1.Enabled:=false;
  end;
end;

procedure TOptionForm.CheckBox1Click(Sender: TObject);
begin
  CheckEdit1;
end;

procedure TOptionForm.LockLv1;
begin
  OldOnChange:=lv1.OnChange;
  OldOnChanging:=lv1.OnChanging;
  lv1.OnChange:=nil;
  lv1.OnChanging:=nil;
end;

procedure TOptionForm.UnLockLv1;
begin
  lv1.OnChange:=OldOnChange;
  lv1.OnChanging:=OldOnChanging;
end;

procedure TOptionForm.FormCreate(Sender: TObject);
var
  i:integer;
begin
  // compiler
  lv1.Clear;
  for i:=0 to Judge.Settings.Compilers.Count-1 do begin
    with lv1.Items.Add do begin
      Checked:=Judge.Settings.Compilers.Items[i].Active;
      Caption:=Judge.Settings.Compilers.Items[i].Title;
      SubItems.Add(Judge.Settings.Compilers.Items[i].Extension);
      Data:=Judge.Settings.Compilers.Items[i].CopyTo;
    end;
  end;

  // normal
  CheckBox2.Checked:=Judge.Settings.NormalSet.CollectFileCorrelative;
  CheckBox3.Checked:=Judge.Settings.NormalSet.CollectExtCorrelative;
  CheckBox1.Checked:=Judge.Settings.NormalSet.FileSizeLimitB;
  Edit1.Text:=IntToStr(Judge.Settings.NormalSet.FileSizeLimit div 1024);
  Edit2.Text:=IntToStr(Judge.Settings.NormalSet.DefaultScore);
  Edit4.Text:=IntToStr(Judge.Settings.NormalSet.DefaultMemL);
  Edit3.Text:=FloatToStr(Judge.Settings.NormalSet.DefaultTimeL);

  // others
  SetWindowLong(Edit1.Handle, GWL_STYLE, GetWindowLong(Edit1.Handle, GWL_STYLE) or ES_NUMBER);
  SetWindowLong(Edit2.Handle, GWL_STYLE, GetWindowLong(Edit2.Handle, GWL_STYLE) or ES_NUMBER);
  SetWindowLong(Edit3.Handle, GWL_STYLE, GetWindowLong(Edit3.Handle, GWL_STYLE) or ES_NUMBER);
  SetWindowLong(Edit4.Handle, GWL_STYLE, GetWindowLong(Edit4.Handle, GWL_STYLE) or ES_NUMBER);


  CheckEdit1;

  // language
  TranslateComponent(self);
end;

procedure TOptionForm.lv1Click(Sender: TObject);
var
  p: TPoint;
  Item: TListItem;
begin
  GetCursorPos(p);
  p:=lv1.ScreenToClient(p);
  Item:=lv1.GetItemAt(p.X,p.Y);
  if (lv1.SelCount=0) and (Item<>nil) then begin
    Item.Selected:=true;
    Item.Focused:=true;
  end;
end;

end.


