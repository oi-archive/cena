unit NewFormU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, MyTypes, MyUtils, ojtc, ComCtrls, ShellCtrls, jvgnugettext,
  Menus;

type
  TNewForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    pgc1: TPageControl;
    ts1: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    _title: TEdit;
    _root: TEdit;
    _juror: TEdit;
    ts2: TTabSheet;
    lv1: TListView;
    ts3: TTabSheet;
    ShellTreeView1: TShellTreeView;
    edt1: TEdit;
    PopupMenu1: TPopupMenu;
    Deletefromlist1: TMenuItem;
    procedure Button1Click(Sender: TObject);
    procedure _titleChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure _rootChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure ShellTreeView1Change(Sender: TObject; Node: TTreeNode);
    procedure edt1Change(Sender: TObject);
    procedure lv1DblClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ts2Resize(Sender: TObject);
    procedure ts3Resize(Sender: TObject);
    procedure ts1Resize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure pgc1Change(Sender: TObject);
    procedure lv1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure Deletefromlist1Click(Sender: TObject);
  private
    autochanging, changed: boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  NewForm: TNewForm;

implementation

uses MainFormU;

{$R *.dfm}

procedure TNewForm.Button1Click(Sender: TObject);
var
  ffd:TWin32FindDataA;
  hFile:THandle;
  Have:boolean;
  ErrorMsg: cardinal;
begin

  case pgc1.ActivePageIndex of
    0:
      begin
        if DirectoryExists(_root.Text) then begin
          hFile:=FindFirstFileA(pchar(_root.Text+'\*'),ffd);
          Have:=false;
          repeat
            if (strpas(ffd.cFileName)<>'.') and (ffd.cFileName<>'..') then begin
              Have:=true;
              break;
            end;
          until not FindNextFileA(hFile,ffd);
          windows.FindClose(hFile);
          if Have then
            if MessageBoxW(Handle,pwidechar(_('There are some files in the folder, continue?')),pwidechar(_('Warning')),MB_DEFBUTTON2 or MB_YESNO or MB_ICONWARNING)=IDNO then exit;
        end;
        ErrorMsg:=Judge.Contest.New(_root.Text,_title.Text,_juror.Text);
        if ErrorMsg<>0 then begin
          // 创建失败，给予提示 !!!
          MessageBoxW(Handle,pwidechar(_('Unable to create the contest.')+#13#10#13#10+WideFormat(_('Error %d: %s'),[ErrorMsg,SysErrorMessage(ErrorMsg)])),pwidechar(_('Error')),MB_OK or MB_ICONERROR);
        end
        else
          Close;
      end;
    1:
      begin
        if IsContest(lv1.Selected.SubItems.Strings[0]) then begin
          Judge.Contest.Open(lv1.Selected.SubItems.Strings[0]);
          if Judge.Contest.IsOpen then
            Close;
        end
        else begin
          if MessageBoxW(Handle,pwidechar(_('Create a new contest here?')),pwidechar(_('Confirm')),MB_YESNO or MB_ICONQUESTION)=IDYES then begin
            _root.Text:=lv1.Selected.SubItems.Strings[0];
            pgc1.ActivePageIndex:=0;
          end;
        end;
      end;
    2:
      begin
        if IsContest(edt1.Text) then begin
          Judge.Contest.Open(edt1.Text);
          if Judge.Contest.IsOpen then
            Close;
        end
        else begin
          if MessageBoxW(Handle,pwidechar(_('Create a new contest here?')),pwidechar(_('Confirm')),MB_YESNO or MB_ICONQUESTION)=IDYES then begin
            _root.Text:=edt1.Text;
            pgc1.ActivePageIndex:=0;
          end;
        end;
      end;
  end;

end;

procedure TNewForm._titleChange(Sender: TObject);
var
  s:string;
  i:integer;
begin
  s:='';
  for i:=1 to length(_title.Text) do
    if _title.Text[i] in ['a'..'z','A'..'Z','0'..'9'] then
      s:=s+_title.Text[i];
  if not changed then begin
    autochanging:=true;
    _root.Text:='C:\TEST\'+s;
    autochanging:=false;
  end;
end;

procedure TNewForm.FormShow(Sender: TObject);
var
  buf:array[0..1023] of char;
  size:cardinal;
  i,j:integer;
  x: TContest;
  s:string;
begin
  // Show text
  _title.Text:=WideFormat(_('Contest on %s'),[DateToStr(Now)]);
  size:=sizeof(buf);
  windows.GetComputerName(@buf[0],size);
  _juror.Text:=buf;
  size:=sizeof(buf);
  windows.GetUserName(@buf[0],size);
  _juror.Text:=''+buf+'@'+_juror.Text;

  for i:=Judge.Settings.Recents.Count-1 downto 0 do begin
    with lv1.Items.Add do begin
      x:=TContest.Create;
      SubItems.Add(Judge.Settings.Recents.Items[i].FileName);
      if x.LoadFromFile(Judge.Settings.Recents.Items[i].FileName+'\data\dataconf.xml')=0 then begin
        Caption:=x.Title;
        if x.Problems.Count>0 then begin
          s:='';
          for j:=0 to x.Problems.Count-1 do
            s:=s+x.Problems.Items[j].Title+'('+x.Problems.Items[j].FileName+'); ';
          SubItems.Add(s);
        end
        else
          SubItems.Add(_('(Unconfigurated)'));
        x.Destroy;
      end
      else begin
        Caption:=_('(Unable to Open)');
        SubItems.Add(_('(Unable to Open)'));
      end;
    end;
  end;
  Width:=Width+1;
  Width:=Width-1;

  if (pgc1.ActivePageIndex=1) and (lv1.Items.Count=0) then
    pgc1.ActivePageIndex:=0; 

  pgc1Change(nil);  

end;

procedure TNewForm._rootChange(Sender: TObject);
begin
  if not autochanging then
    changed:=true;
end;

procedure TNewForm.SpeedButton1Click(Sender: TObject);
var
  s: string;
begin
  s:=BrowseforFile(Handle,'','','');
  if s<>'' then
    _root.Text:=s;
end;

procedure TNewForm.ShellTreeView1Change(Sender: TObject; Node: TTreeNode);
begin
  edt1.Text:=ShellTreeView1.Path;
end;

procedure TNewForm.edt1Change(Sender: TObject);
begin
  button1.Enabled:={IsContest(edt1.Text);}true;
end;

procedure TNewForm.lv1DblClick(Sender: TObject);
begin
  if lv1.SelCount=1 then
    Button1.Click;
end;

procedure TNewForm.FormCreate(Sender: TObject);
var
  i: integer;
begin
  // Apply Settings
  with Judge.Settings do begin
    Height:=WindowSet.NHeight;
    Width:=WindowSet.NWidth;
    for i:=0 to lv1.Columns.Count-1 do
      lv1.Columns[i].Width:=WindowSet.NLv1ColWidth.Width[i];
  end;

  // language
  TranslateComponent(self);
end;

procedure TNewForm.FormResize(Sender: TObject);
begin
  pgc1.Width:=self.ClientWidth-20;
  pgc1.Height:=self.ClientHeight-46;
  button1.Left:=self.ClientWidth-193;
  button1.Top:=self.ClientHeight-29;
  button2.Top:=self.ClientHeight-29;
  button2.Left:=self.ClientWidth-97;
end;

procedure TNewForm.ts2Resize(Sender: TObject);
begin
  lv1.Width:=ts2.ClientWidth-16;
  lv1.Height:=ts2.ClientHeight-16;
end;

procedure TNewForm.ts3Resize(Sender: TObject);
begin
  ShellTreeView1.Width:=ts3.ClientWidth-16;
  ShellTreeView1.Height:=ts3.ClientHeight-45;
  edt1.Top:=ts3.ClientHeight-29;
  edt1.Width:=ts3.ClientWidth-16;
end;

procedure TNewForm.ts1Resize(Sender: TObject);
begin
  _title.Width:=ts1.ClientWidth-32;
  _root.Width:=ts1.ClientWidth-64;
  SpeedButton1.Left:=ts1.ClientWidth-41;
end;

procedure TNewForm.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
begin
  with Judge.Settings do begin
    for i:=0 to lv1.Columns.Count-1 do
      WindowSet.NLv1ColWidth.Width[i]:=lv1.Column[i].Width;

    WindowSet.NHeight:=Height;
    WindowSet.NWidth:=Width;
  end;
end;

procedure TNewForm.pgc1Change(Sender: TObject);
begin
  case pgc1.ActivePageIndex of
    0:
      button1.Enabled:=true;
    1:
      button1.Enabled:=(lv1.SelCount<>0);
    2:
      edt1Change(nil);
  end;
end;

procedure TNewForm.lv1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  button1.Enabled:=(lv1.SelCount<>0);
end;

procedure TNewForm.Deletefromlist1Click(Sender: TObject);
begin
  if lv1.SelCount=1 then begin
    Judge.Settings.Recents.Delete(Judge.Settings.Recents.Count-lv1.Selected.Index-1);
    lv1.Selected.Delete;
  end;
end;

end.

