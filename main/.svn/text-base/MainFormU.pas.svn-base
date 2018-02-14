unit MainFormU;

interface

uses
  Windows, Messages, SysUtils, ExtCtrls, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ComCtrls, ImgList, StdCtrls, Buttons, MyTypes, MyUtils,
  ojconst, math, ShellAPI, JudgeThreadU, ojtc, ojrc, IdBaseComponent,
  IdComponent, IdUDPBase, IdUDPServer, IdSocketHandle, IdTCPServer,
  AppEvnts, activex, ShellCtrls, JvComCtrls, CommCtrl, ojcount, libojcd,
  GatherThreadU, JvExComCtrls, shdocvw, libxml2;

type

  TDragAndDropOLE=class(TObject, IUnknown, IDropTarget)
  private
    CanDrop:HResult;
    fe:TFormatEtc;
    FRefCount:integer;
  protected
    { IUnknown }
    function _AddRef:integer;stdcall;
    function _Release:integer;stdcall;
    function QueryInterface(const IID:TGUID;out Obj):HResult;stdcall;
    { IdropTarget }
    function DragEnter(const dataObj: IDataObject; grfKeyState: Longint;
       pt: TPoint; var dwEffect: Longint): HResult;stdcall;
    function DragOver(grfKeyState: Longint; pt: TPoint;var dwEffect: Longint):HResult;stdcall;
    function DragLeave: HResult;stdcall;
    function Drop(const dataObj: IDataObject; grfKeyState: Longint; pt: TPoint;
      var dwEffect: Longint): HResult; stdcall;
  public
    constructor Create;
    destructor Destroy;override;
  end;

  TMainForm = class(TForm)
    mm1: TMainMenu;
    F1: TMenuItem;
    N5: TMenuItem;
    N1: TMenuItem;
    P1: TMenuItem;
    N6: TMenuItem;
    X1: TMenuItem;
    C2: TMenuItem;
    V2: TMenuItem;
    N12: TMenuItem;
    D1: TMenuItem;
    T1: TMenuItem;
    O2: TMenuItem;
    H1: TMenuItem;
    A2: TMenuItem;
    pgc1: TPageControl;
    ts1: TTabSheet;
    ts2: TTabSheet;
    stat1: TStatusBar;
    SaveButton: TButton;
    RestoreButton: TButton;
    lv1: TListView;
    il1: TImageList;
    pnl3: TPanel;
    btn5: TButton;
    btn6: TButton;
    pm2: TPopupMenu;
    N3: TMenuItem;
    N4: TMenuItem;
    N16: TMenuItem;
    C1: TMenuItem;
    Timer1: TTimer;
    udp: TIdUDPServer;
    det: TGroupBox;
    pnl2: TPanel;
    lbl7: TLabel;
    lbl8: TLabel;
    lbl14: TLabel;
    lbl11: TLabel;
    lbl13: TLabel;
    lbl10: TLabel;
    lbl9: TLabel;
    lbl15: TLabel;
    t_in: TMemo;
    t_out: TEdit;
    t_score: TEdit;
    t_time: TEdit;
    t_mem: TEdit;
    pnl1: TPanel;
    lbl1: TLabel;
    lbl3: TLabel;
    lbl12: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    Label1: TLabel;
    lbl2: TLabel;
    p_title: TEdit;
    p_in: TMemo;
    p_out: TEdit;
    p_compare: TEdit;
    p_add: TMemo;
    p_cm: TComboBox;
    p_name: TEdit;
    I1: TMenuItem;
    Label4: TLabel;
    N7: TMenuItem;
    M1: TMenuItem;
    D2: TMenuItem;
    ts3: TTabSheet;
    Button2: TButton;
    Button3: TButton;
    Panel1: TPanel;
    PeopleView: TListView;
    Splitter1: TSplitter;
    ProblemView: TJvTreeView;
    ApplicationEvents1: TApplicationEvents;
    N8: TMenuItem;
    R1: TMenuItem;
    G1: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    V1: TMenuItem;
    B1: TMenuItem;
    pm1: TPopupMenu;
    MenuItem1: TMenuItem;
    N2: TMenuItem;
    MenuItem2: TMenuItem;
    F2: TMenuItem;
    Timer2: TTimer;
    O4: TMenuItem;
    Bevel1: TBevel;
    PeopleViewPopupMenu: TPopupMenu;
    A1: TMenuItem;
    N13: TMenuItem;
    C3: TMenuItem;
    C4: TMenuItem;
    V3: TMenuItem;
    N15: TMenuItem;
    B2: TMenuItem;
    V4: TMenuItem;
    N17: TMenuItem;
    P2: TMenuItem;
    ProblemPopupMenu: TPopupMenu;
    N18: TMenuItem;
    N14: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    z1: TMenuItem;
    N21: TMenuItem;
    S1: TMenuItem;
    N24: TMenuItem;
    N23: TMenuItem;
    N25: TMenuItem;
    N11: TMenuItem;
    N26: TMenuItem;
    N27: TMenuItem;
    P3: TMenuItem;
    N22: TMenuItem;
    C6: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    grp1: TGroupBox;
    pnl4: TPanel;
    tv1: TTreeView;
    N31: TMenuItem;
    Timer3: TTimer;
    CheckBox1: TCheckBox;
    A3: TMenuItem;
    N30: TMenuItem;
    N32: TMenuItem;
    procedure FormResize(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure O3Click(Sender: TObject);
    procedure lv1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure X1Click(Sender: TObject);
    procedure A2Click(Sender: TObject);
    procedure ts2Resize(Sender: TObject);
    procedure tv1Change(Sender: TObject; Node: TTreeNode);
    procedure MenuItem1Click(Sender: TObject);
    procedure p_cmChange(Sender: TObject);
    procedure RestoreButtonClick(Sender: TObject);
    procedure btn9Click(Sender: TObject);
    procedure O2Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn6Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure RecentClick(Sender: TObject);
    procedure P1Click(Sender: TObject);
    procedure tv1Changing(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure C1Click(Sender: TObject);
    procedure pgc1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure udpUDPRead(Sender: TObject; AData: TStream;
      ABinding: TIdSocketHandle);
    procedure lv1DblClick(Sender: TObject);
    procedure ts1Resize(Sender: TObject);
    procedure pnl1Resize(Sender: TObject);
    procedure pnl2Resize(Sender: TObject);
    procedure p_titleChange(Sender: TObject);
    procedure t_inKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure t_inClick(Sender: TObject);
    procedure t_inExit(Sender: TObject);
    procedure t_inChange(Sender: TObject);
    procedure I1Click(Sender: TObject);
    procedure D1Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure lv1Edited(Sender: TObject; Item: TListItem; var S: String);
    procedure M1Click(Sender: TObject);
    procedure D2Click(Sender: TObject);
    procedure tv1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Splitter1Moved(Sender: TObject);
    procedure Splitter1CanResize(Sender: TObject; var NewSize: Integer;
      var Accept: Boolean);
    procedure ts3Resize(Sender: TObject);
    procedure ProblemViewClick(Sender: TObject);
    procedure ProblemViewKeyPress(Sender: TObject; var Key: Char);
    procedure lv1AdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure R1Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure G1Click(Sender: TObject);
    procedure lv1Change(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure p_nameChange(Sender: TObject);
    procedure tv1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure F2Click(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormDeactivate(Sender: TObject);
    procedure t_inKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure O4Click(Sender: TObject);
    procedure t_outChange(Sender: TObject);
    procedure t_outKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lv1Editing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure tv1Addition(Sender: TObject; Node: TTreeNode);
    procedure PeopleViewColumnClick(Sender: TObject; Column: TListColumn);
    procedure C7Click(Sender: TObject);
    procedure B1Click(Sender: TObject);
    procedure A1Click(Sender: TObject);
    procedure V3Click(Sender: TObject);
    procedure C3Click(Sender: TObject);
    procedure C4Click(Sender: TObject);
    procedure V4Click(Sender: TObject);
    procedure B2Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure PeopleViewDblClick(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure t_scoreChange(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure z1Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N26Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure N24Click(Sender: TObject);
    procedure P3Click(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure N25Click(Sender: TObject);
    procedure V2Click(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure C6Click(Sender: TObject);
    procedure p_addExit(Sender: TObject);
    procedure tv1Deletion(Sender: TObject; Node: TTreeNode);
    procedure N31Click(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure tv1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure tv1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure A3Click(Sender: TObject);
    procedure t_outClick(Sender: TObject);
  private
    { Private declarations }
    SortColumn1, SortOrder1, SortColumn2, SortOrder2: integer;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  public
  published
    procedure ContestOpen(Sender: TObject);
    procedure ContestClose(Sender: TObject);
    procedure SetColumnImage(List: TListView; Column, Image: Integer;
      ShowImage: Boolean);
    procedure LoadPeoples;
    procedure RefreshPeople(People: TPeople);
    procedure UpdatePlaces;
    procedure SaveAllOptions;
    procedure DelProForm(People: TPeople);
    procedure RefProForm(People: TPeople);
    procedure OpenBtns;
    procedure CloseBtns;
    procedure UpdateLook;
    procedure JudgeNow(OnlySelected, OnlyModified: boolean);
    procedure TranslateTo(Lang: string);
    procedure GatherNow(OnlySelected: boolean);
    procedure PromptNewVersion;
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  translatted: boolean=false;


implementation

uses NewFormU, AboutFormU, ResultFormU, JudgeFormU,
  MessageFormU, OptionFormU, ManagerFormU, ExportFormUnit,
  CIFormU, PrintFormU, PropFormU, ojsort, DropDownFormU,
  jvgnugettext;

{$R *.dfm}

function HtmlHelpW(hwndCaller:HWND; pszfile:PWideChar; uCommand:UINT; dwData:PWideChar):HWND; stdcall; external 'hhctrl.ocx' name 'HtmlHelpW';  


var
  CurrentNode:pointer;
  CurrentProblem:TProblem absolute CurrentNode;
  CurrentTestCase:TTestCase absolute CurrentNode;

  NodesToDel:array of TTreeNode;

  DragAndDropOLE: TDragAndDropOLE;

constructor TDragAndDropOLE.Create;
begin
  FRefCount:=0;
  RegisterDragDrop(MainForm.lv1.Handle,self);//上文提到的函数
end;

destructor TDragAndDropOLE.Destroy;
begin
  RevokeDragDrop(MainForm.lv1.Handle);
  inherited;
end;

function TDragAndDropOLE._AddRef: integer;
begin
  result:=InterLockedDecrement(FRefCount);
  if Result=0 then Destroy;
end;

function TDragAndDropOLE._Release: integer;
begin
  result:=InterLockedIncrement(FRefCount);
end;



function TDragAndDropOLE.QueryInterface(const IID: TGUID;
  out Obj): HResult;
begin
 if GetInterface(IID,Obj) then
   result:=S_OK
 else
   result:=E_NOINTERFACE;
end;

function TDragAndDropOLE.DragEnter(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
begin
  result:=E_FAIL;
  CanDrop:=E_Fail;
  if assigned(dataObj) then begin
    with fe do begin
      cfFormat:=CF_HDROP;
      ptd:=nil;
      dwAspect:=DVASPECT_CONTENT;
      lindex:=-1;
      tymed:=TYMED_HGLOBAL;
    end;

  //大家从上面看到的fe是一种我们处理内存数据时常用的转换格式
  //这里它表示将数据格式作为文字（cfFormat），并将其存入一块
  //全局的内存区域（tymed:=TYMED_HGLOBAL），更多的格式请在win32
  //帮助中搜索TFormatEtc

//  CanDrop:=DATAOBJ.GetData(fe,StgMedium);
  CanDrop:=dataObj.QueryGetData(fe);//按照fe指定的格式检查数据

  result:=CanDrop;
  if Succeeded(result) then
    dwEffect:=DROPEFFECT_COPY
  else
    dwEffect:=DROPEFFECT_NONE;
  //注意这里我们设置了dwEffect,更多的取值请查看win32帮助
  end;

end;


function TDragAndDropOLE.DragLeave: HResult;
begin
  result:=S_OK;
end;

function TDragAndDropOLE.DragOver(grfKeyState: Integer; pt: TPoint;
  var dwEffect: Integer): HResult;
begin
  result:=S_OK;
  DWEFFECT:=DROPEFFECT_COPY;
 //我们不需要在这里做其余的操作，当然你可以根据自己的需要完成自己的方法
end;

function TDragAndDropOLE.Drop(const dataObj: IDataObject;
  grfKeyState: Integer; pt: TPoint; var dwEffect: Integer): HResult;
var
  medium:stgMedium;
  hData:HGLOBAL;
  pcFileName: PWideChar;
  i, iSize, iFileCount: integer;
  sFiles:widestring;
  sDest:widestring;
  fo:_SHFILEOPSTRUCTW;
begin
  result:=E_Fail;
  if Succeeded(CanDrop) then begin
    result:=dataObj.GetData(fe,medium);
    //按照fe的格式将数据存入内存的一块全局区域，注意medium
    hData:=HGLOBAL(GlobalLock(medium.hGlobal));
    //GlobalLock锁定这块区域，并返回指向它的指针

    iFileCount := DragQueryFile(hData, $FFFFFFFF, nil, 255);
    sFiles:='';  // Do not localize
    for i := 0 to iFileCount - 1 do begin
      iSize := DragQueryFileW(hData, i, nil, 0) + 1;
      pcFileName := AllocMem(iSize*sizeof(widechar));
      DragQueryFileW(hData, i, pcFileName, iSize);
      sFiles:=sFiles+pcFileName+#0;
      dispose(pcFileName);
    end;
    sFiles:=sFiles+#0;
    
//    GlobalUnlock(hData);//接触锁定
//    GlobalFree(hData);//释放
//    DragFinish(hData);
    GlobalUnlock(medium.hGlobal);
    GlobalFree(medium.hGlobal);
//    CloseHandle(hData);

    fo.Wnd:=MainForm.Handle;
    fo.wFunc:=FO_COPY;
    fo.pFrom:=@sFiles[1];
    fo.fFlags:=FOF_NOCONFIRMATION or FOF_NOCONFIRMMKDIR or FOF_NOERRORUI;
    sDest:=Judge.Contest.Path+'\src';  // Do not localize
    fo.pTo:=@sDest[1];
    shellapi.SHFileOperationW(fo);

    Judge.Contest.Peoples.Refresh;
    MainForm.LoadPeoples;

  end;
end;



procedure TMainForm.FormResize(Sender: TObject);
begin

  pgc1.Width:=self.ClientWidth-16;
  if stat1.Visible then
    pgc1.Height:=self.ClientHeight-16-stat1.Height
  else
    pgc1.Height:=self.ClientHeight-16;

  stat1.Width:=ClientWidth;
  stat1.Top:=ClientHeight-stat1.Height;

end;

procedure TMainForm.N5Click(Sender: TObject);
begin
  Application.CreateForm(TNewForm,NewForm);
  NewForm.ShowModal;
  NewForm.Destroy;
end;

procedure TMainForm.O3Click(Sender: TObject);
var
  newroot:widestring;

begin
  newroot:=BrowseforFile(Handle,'','judge.dir','');  // Do not localize
  if newroot<>'' then begin  // Do not localize
    Judge.Contest.Open(newroot);
  end;
end;

function s2dt(s:widestring):TDateTime;
begin
  if s='' then  // Do not localize
    result:=0
  else
    result:=StrToDateTime(s);
end;

function CustomSortProc(Item1, Item2: TListItem; ParamSort: integer): integer; stdcall;
begin
  if Item1.ListView=MainForm.lv1 then begin
//    用字符串：   0,[4,5,8,9]
//    用数字：     1,2,3
//    用日期时间： 6,7
    case ParamSort of
      0:
        result:=lstrcmp(pchar(Item1.Caption),pchar(Item2.Caption));
      4,5,8,9:
        result:=lstrcmp(pchar(Item1.SubItems.Strings[ParamSort-1]),pchar(Item2.SubItems.Strings[ParamSort-1]));
      1,2,3:
        result:=sign(strtofloat(Item1.SubItems.Strings[ParamSort-1])-strtofloat(Item2.SubItems.Strings[ParamSort-1]));
      else
        result:=sign(s2dt(Item1.SubItems.Strings[ParamSort-1])-s2dt(Item2.SubItems.Strings[ParamSort-1]));
    end;
    if MainForm.SortOrder1=1 then
      Result:=-Result;
  end
  else begin
//    用字符串：   0
//    用数字：     1,2,3
    case ParamSort of
      0:
        result:=lstrcmp(pchar(Item1.Caption),pchar(Item2.Caption));
      1,2,3:
        result:=sign(strtofloat(Item1.SubItems.Strings[ParamSort-1])-strtofloat(Item2.SubItems.Strings[ParamSort-1]));
      else
        result:=0;
    end;    
    if MainForm.SortOrder2=1 then
      Result:=-Result;
  end;
end;

procedure TMainForm.lv1ColumnClick(Sender: TObject; Column: TListColumn);
var
  i:integer;
begin
  SortOrder1:=1-SortOrder1;
  SortColumn1:=Column.Index;
  lv1.CustomSort(@CustomSortProc,Column.Index);
  for i:=0 to lv1.Columns.Count-1 do
    SetColumnImage(lv1,i,0,false);
  SetColumnImage(lv1,sortColumn1,3+SortOrder1,true);
end;

procedure TMainForm.X1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.A2Click(Sender: TObject);
begin
  Application.CreateForm(TAboutForm,AboutForm);
  AboutForm.ShowModal;
  AboutForm.Destroy;
end;

procedure TMainForm.ts2Resize(Sender: TObject);
begin
  lv1.Width:=ts2.Width-16;
  lv1.Height:=ts2.Height-398+353;
  pnl3.Top:=lv1.Top+lv1.Height+8;
end;

procedure TMainForm.tv1Change(Sender: TObject; Node: TTreeNode);
begin
  savebutton.Enabled:=false;
  if node=nil then begin
    pnl1.Hide;
    pnl2.Hide;
  end
  else begin
    CurrentNode:=node.Data;
    self.RestoreButtonClick(self);
    if node.Parent=nil then begin // it's a problem
      pnl1.Show;
      pnl2.Hide;
    end
    else begin
      pnl1.Hide;

      if tv1.SelectionCount=1 then begin
        t_in.Enabled:=true;
        t_out.Enabled:=true;
      end
      else begin
        t_in.Enabled:=false;
        t_out.Enabled:=false;
      end;

      pnl2.Show;
    end;
  end;

end;

procedure TMainForm.MenuItem1Click(Sender: TObject);
var
  node:TTreeNode;
begin
  tv1.ClearSelection(false);
  node:=tv1.Items.Add(nil,'');  // Do not localize
  node.Data:=Judge.Contest.Problems.Add;
  TProblem(node.Data).CompareType:=1;
  TProblem(node.Data).IsSubmit:=false;
  ProblemView.Items.AddChild(ProblemView.Items.Item[0],'');  // Do not localize

  node.Selected:=true;

  p_title.Text:=Format(_('Problem %d'),[node.Index+1]); 
  p_title.SetFocus;

  SaveButton.Enabled:=true;
end;

procedure TMainForm.p_cmChange(Sender: TObject);
begin
  lbl5.Enabled:=p_cm.ItemIndex=2;
  p_compare.Enabled:=lbl5.Enabled;
  p_nameChange(Sender);
end;

procedure TMainForm.RestoreButtonClick(Sender: TObject);
var
  i:integer;
  OldOnChange: TNotifyEvent;
begin
  if tv1.Selected.Parent=nil then begin
    p_title.Text:=CurrentProblem.Title;
    p_name.Text:=CurrentProblem.FileName;
    p_in.Lines.Clear;
    for i:=0 to CurrentProblem.Inputs.Count-1 do
      p_in.Lines.Add(CurrentProblem.Inputs.Items[i].FileName);
    p_out.Text:=CurrentProblem.Output.FileName;

    if CurrentProblem.CompareType in [0,1,2] then
      p_cm.ItemIndex:=CurrentProblem.CompareType;
    p_cm.OnChange(nil);

    p_compare.Text:=CurrentProblem.CustomCompareFile;
    
    p_add.Lines.Clear;
    for i:=0 to CurrentProblem.Libraries.Count-1 do
      p_add.Lines.Add(CurrentProblem.Libraries.Items[i].FileName);
  end
  else begin
    OldOnChange:=t_in.OnChange;
    t_in.OnChange:=nil;
    t_in.Lines.Clear;
    for i:=0 to CurrentTestCase.Inputs.Count-1 do
      t_in.Lines.Add(CurrentTestCase.Inputs.Items[i].FileName);
    t_in.OnChange:=OldOnChange;
    t_out.Text:=CurrentTestCase.Output.FileName;
    t_score.Text:=floattostr(CurrentTestCase.Score);
    t_time.Text:=floattostr(CurrentTestCase.TimeLimit);
    t_mem.Text:=floattostr(CurrentTestCase.MemoryLimit);
  end;
end;

procedure TMainForm.btn9Click(Sender: TObject);
begin
  if JudgeForm=nil then
    Application.CreateForm(TJudgeForm,JudgeForm);
  JudgeForm.Show;
//  JudgeForm.Destroy;
end;

procedure TMainForm.O2Click(Sender: TObject);
begin
  Application.CreateForm(TOptionForm,OptionForm);
  OptionForm.ShowModal;
  OptionForm.Destroy;
end;

procedure TMainForm.btn5Click(Sender: TObject);
begin
  GatherNow(lv1.SelCount>0);
end;

procedure WMDROPFILES(var Message: TMessage);
var 
  pcFileName: PWideChar; 
  i, iSize, iFileCount: integer; 
begin 
  pcFileName := '';  // Do not localize 
  iFileCount := DragQueryFileW(Message.wParam, $FFFFFFFF, pcFileName, 255); 
  for i := 0 to iFileCount - 1 do 
  begin 
    iSize := DragQueryFileW(Message.wParam, i, nil, 0) + 1;
    getmem(pcFileName, iSize * sizeof(widechar)); 
    DragQueryFileW(Message.wParam, i, pcFileName, iSize);
{
    if FileExists(pcFileName) then
      MessageBox(MainForm.Handle,pcFileName,'',0);  // Do not localize
}      
    freemem(pcFileName); 
  end;
  DragFinish(Message.wParam);
end;



procedure TMainForm.FormCreate(Sender: TObject);
var
  rStyle:longint;
  i: integer;
  OldCanResizeEvent: TCanResizeEvent;
begin

  JudgeThread:=TJudgeThread.Create(false);

  o4.ShortCut:=16384{ctrl} or 32768{alt} or VK_INSERT;

  OleInitialize(nil);
  DragAndDropOLE:=TDragAndDropOLE.Create;

  lv1.ControlStyle:=lv1.ControlStyle+[csDisplayDragImage];



  Judge.Contest.OnOpen:=ContestOpen;
  Judge.Contest.OnClose:=ContestClose;
  Judge.Settings.Load;
//  DragAcceptFiles(lv1.Handle,true);



  SetWindowLong(t_mem.Handle, GWL_STYLE, GetWindowLong(t_mem.Handle, GWL_STYLE) or ES_NUMBER);

  rStyle := SendMessage(lv1.Handle,$1000+55, 0, 0);
  rStyle := rStyle Or $10;
  SendMessage(lv1.Handle,$1000+54, 0, rStyle);

  rStyle := SendMessage(peopleview.Handle,$1000+55, 0, 0);
  rStyle := rStyle Or $10;
  SendMessage(peopleview.Handle,$1000+54, 0, rStyle);
{
  rStyle:=GetWindowLong(lv1.Handle, GWL_EXSTYLE);
  rStyle := (rStyle And Not WS_EX_CLIENTEDGE Or WS_EX_STATICEDGE);
  SetWindowLong(lv1.Handle, GWL_EXSTYLE, rStyle);
  SetWindowPos(lv1.Handle, 0, 0, 0, maxint, maxint, $1 Or $2 Or $4 Or $20);

  rStyle:=GetWindowLong(peopleview.Handle, GWL_EXSTYLE);
  rStyle := (rStyle And Not WS_EX_CLIENTEDGE Or WS_EX_STATICEDGE);
  SetWindowLong(peopleview.Handle, GWL_EXSTYLE, rStyle);
  SetWindowPos(peopleview.Handle, 0, 0, 0, maxint, maxint, $1 Or $2 Or $4 Or $20);
}

  {
  rStyle:=GetWindowLong(Handle, GWL_EXSTYLE);
  rStyle := (rStyle or WS_EX_NOACTIVATE);
  SetWindowLong(Handle, GWL_EXSTYLE, rStyle);
  SetWindowPos(Handle, 0, 0, 0, 0, 0, $1 Or $2 Or $4 Or $20);
}

  // 按照Setting里面的设置显示
  OldCanResizeEvent:=OnCanResize;
  OnCanResize:=nil;
  with Judge.Settings do begin
//      if WindowSet.Height=0 then WindowSet.Height:=540;
//      if WindowSet.Width=0 then WindowSet.Width:=750;
    Left:=WindowSet.Left;
    Top:=WindowSet.Top;
    Height:=WindowSet.Height;
    Width:=WindowSet.Width;
    if WindowSet.WinMaxSize then begin
      WindowState:=wsMaximized;
      ShowWindow(Handle,SW_SHOWMAXIMIZED); // avoid delphi's bug
    end;
    N18.Checked:=WindowSet.N18Checked;
    B1.Checked:=WindowSet.B1Checked;
    stat1.Visible:=WindowSet.B1Checked;
    for i:=0 to lv1.Columns.Count-1 do
      lv1.Column[i].Width:=WindowSet.Lv1ColWidth.Width[i];
    for i:=0 to PeopleView.Columns.Count-1 do
      PeopleView.Column[i].Width:=WindowSet.PeopleVColWidth.Width[i];
  end;
  OnCanResize:=OldCanResizeEvent;
  Resize;

  TranslateTo(Judge.Settings.NormalSet.Language);
  TP_GlobalIgnoreClass(TFont);
  TP_GlobalIgnoreClass(TWebBrowser);

  TranslateComponent(self);
end;

procedure TMainForm.SaveButtonClick(Sender: TObject);
var
  i:integer;
  Saved: integer;
begin

  if tv1.Selected=nil then
    exit;
  if tv1.Selected.Parent=nil then begin
    CurrentProblem.Title:=p_title.Text;
    CurrentProblem.FileName:=p_name.Text;
    CurrentProblem.Inputs.Count:=p_in.Lines.Count;
    for i:=0 to p_in.Lines.Count-1 do
      CurrentProblem.Inputs.Items[i].FileName:=p_in.Lines.Strings[i];
    CurrentProblem.Output.FileName:=p_out.Text;

    CurrentProblem.CompareType:=p_cm.ItemIndex;
    CurrentProblem.CustomCompareFile:=p_compare.Text;
    CurrentProblem.Libraries.Count:=p_add.Lines.Count;
    for i:=0 to p_add.Lines.Count-1 do
      CurrentProblem.Libraries.Items[i].FileName:=p_add.Lines.Strings[i];
  end
  else begin
    if tv1.SelectionCount=1 then begin
      CurrentTestCase.Inputs.Count:=t_in.Lines.Count;
      for i:=0 to t_in.Lines.Count-1 do
        CurrentTestCase.Inputs.Items[i].FileName:=t_in.Lines.Strings[i];
      CurrentTestCase.Output.FileName:=t_out.Text;
      CurrentTestCase.Score:=strtofloat(t_score.Text);
      CurrentTestCase.TimeLimit:=strtofloat(t_time.Text);
      CurrentTestCase.MemoryLimit:=strtoint(t_mem.Text);
    end
    else begin
      for i:=0 to tv1.SelectionCount-1 do begin
        TTestCase(tv1.Selections[i].Data).Score:=strtofloat(t_score.Text);
        TTestCase(tv1.Selections[i].Data).TimeLimit:=strtofloat(t_time.Text);
        TTestCase(tv1.Selections[i].Data).MemoryLimit:=strtoint(t_mem.Text);
      end;
    end;
  end;
  SaveButton.Enabled:=false;

  repeat
    Saved:=Judge.Contest.Save;
    if Saved<0 then
      if MessageBoxW(Handle,pwidechar(_('Unable to save the data configuration file.')+#13#10#13#10+Format(_('Error %d: %s'),[xmlGetLastError.code,xmlGetLastError.message])),pwidechar(_('Error')),MB_ICONERROR or MB_RETRYCANCEL)=IDCANCEL then
        exit
      else
    else
      exit;
  until false;
end;

procedure TMainForm.N2Click(Sender: TObject);
var
  node1,node2,added:TTreeNode;
begin

  if SaveButton.Enabled then
    SaveButton.Click;
  node1:=tv1.Selected;
  if node1=nil then
    exit;
  if node1.Parent<>nil then
    node1:=node1.Parent;
  node2:=tv1.Items.AddChild(node1,'');  // Do not localize
  node2.ImageIndex:=1;
  node2.SelectedIndex:=1;
  node2.Data:=TProblem(node1.Data).TestCases.Add;
  node2.Text:=inttostr(TProblem(node1.Data).TestCases.Count);
  TTestCase(node2.Data).AutoNext(node2.Parent.Data);
  node2.Selected:=true;

  added:=ProblemView.Items.AddChild(ProblemView.Items.Item[0].Item[node1.Index],node2.Text);
  added.ImageIndex:=1;
  SaveButton.Enabled:=true;  
end;

procedure TMainForm.MenuItem2Click(Sender: TObject);
var
  i:integer;
  node,p: TTreeNode;
  s: string;
begin

  if MessageBoxW(Handle,pwidechar(_('Are you sure to delete the selected items?')),pwidechar(_('Confirm')),MB_YESNO or MB_ICONQUESTION or MB_DEFBUTTON2)=IDNO then
    exit;

  SetLength(NodesToDel,tv1.SelectionCount);

  for i:=1 to tv1.SelectionCount do
    NodesToDel[i-1]:=tv1.Selections[i-1];

  node:=nil;

  for i:=0 to Length(NodesToDel)-1 do begin
    if NodesToDel[i].Parent=nil then begin
      Judge.Contest.Problems.Delete(TProblem(NodesToDel[i].Data));

      ProblemView.Items.Item[0].Item[NodesToDel[i].Index].Delete;
    end
    else begin
      node:=NodesToDel[i].Parent;
      TProblem(NodesToDel[i].Parent.Data).TestCases.Delete(TTestCase(NodesToDel[i].Data));

      ProblemView.Items.Item[0].Item[node.Index].Item[NodesToDel[i].Index].Delete;
    end;
    tv1.Items.Delete(NodesToDel[i]);
  end;

  if node<>nil then begin
    p:=node;
    node:=node.getFirstChild;
    i:=0;
    while node<>nil do begin
      inc(i);
      node.Text:=inttostr(i);

      s:=ProblemView.Items.Item[0].Item[p.Index].Item[node.Index].Text;
      ProblemView.Items.Item[0].Item[p.Index].Item[node.Index].Text:=node.Text+copy(s,Length(node.Text)+1,Length(s)-Length(node.Text)-1);

      node:=node.getNextSibling;
    end;
  end;

  SetLength(NodesToDel,0);

end;

procedure TMainForm.FormShow(Sender: TObject);
var
  DataToSend: TPacket;
begin
  SetFocus;
  try
    InitPacket(DataToSend);
    DataToSend.dwOperation:=PO_WHO_IS_ONLINE;
    udp.SendBuffer('255.255.255.255',12574,DataToSend,sizeof(DataToSend));  // Do not localize
//    udp.SendBuffer('127.0.0.1',12574,DataToSend,sizeof(DataToSend));  // Do not localize
  except
  end;
  ShowWindow(Handle, SW_SHOW);
  N5.Click;  
end;

procedure TMainForm.btn6Click(Sender: TObject);
begin
  JudgeNow(lv1.SelCount>0,false);
end;

procedure TMainForm.N3Click(Sender: TObject);
var
  f:TResultForm;
begin
  if lv1.SelCount=1 then
    if TPeople(lv1.Selected.Data).Status in [PS_JUDGED, PS_QUEUED_FOR_JUDGING] then begin
      if TPeople(lv1.Selected.Data).ResultWnd=nil then begin
        Application.CreateForm(TResultForm,f);
        TPeople(lv1.Selected.Data).ResultWnd:=f;
        f.ListItem:=lv1.Selected;
        f.PeopleName:=lv1.Selected.Caption;
        f.Caption:=Format(_('%s - Judge Result'),[lv1.Selected.Caption]); 
        f.Show;
      end
      else begin
        ShowWindow(TResultForm(TPeople(lv1.Selected.Data).ResultWnd).Handle,SW_RESTORE);
        SetForegroundWindow(TResultForm(TPeople(lv1.Selected.Data).ResultWnd).Handle);
      end;
    end;
end;

procedure TMainForm.RecentClick(Sender: TObject);
begin
  Judge.Contest.Open(Judge.Settings.Recents.Items[TMenuItem(Sender).Tag].FileName);
end;

procedure TMainForm.P1Click(Sender: TObject);
begin
  Application.CreateForm(TPrintForm,PrintForm);
  PrintForm.ShowModal;
  PrintForm.Destroy;
end;

procedure CountPageRefresh;
var
  i,j: integer;
  p,t,root: TTreeNode;
begin
{
  MainForm.PeopleView.Items.BeginUpdate;
  MainForm.PeopleView.Items.Clear;
  for i:=0 to Judge.Contest.Peoples.Count-1 do begin
    MainForm.PeopleView.AddItem(Judge.Contest.Peoples.Items[i].Name,nil);
    MainForm.PeopleView.Items.Item[i].ImageIndex:=2;
    MainForm.PeopleView.Items.Item[i].Checked:=true;

    for j:=0 to 3 do
      MainForm.PeopleView.Items.Item[i].SubItems.Add(' ');
  end;
  MainForm.PeopleView.Items.EndUpdate;
}
  MainForm.ProblemView.Items.BeginUpdate;
  MainForm.ProblemView.Items.Clear;
  root:=MainForm.ProblemView.Items.AddChildFirst(nil,Judge.Contest.Title);
  root.ImageIndex:=0;
  root.SelectedIndex:=0;
  for i:=Judge.Contest.Problems.Count-1 downto 0 do begin
    p:=MainForm.ProblemView.Items.AddChildFirst(root,Judge.Contest.Problems.Items[i].Title);
    p.ImageIndex:=0;
    p.SelectedIndex:=0;
    for j:=Judge.Contest.Problems.Items[i].TestCases.Count-1 downto 0 do begin
      t:=MainForm.ProblemView.Items.AddChildFirst(p,IntToStr(j+1));
      t.ImageIndex:=1;
      t.SelectedIndex:=1;
    end;
  end;
  MainForm.ProblemView.Items.EndUpdate;
end;


procedure TMainForm.ContestOpen(Sender: TObject);
var
  i,j:integer;
  node,sub:TTreeNode;
begin

  if not Judge.Contest.IsOpen then begin
    MessageBoxW(NewForm.Handle,pwidechar(_('Unable to open the contest.')+#13#10#13#10+Format(_('Error %d: %s'),[Judge.Contest.LastError,SysErrorMessage(Judge.Contest.LastError)])),pwidechar(_('Error')),MB_ICONERROR); 
    exit;
  end;

  Screen.Cursor:=crHourGlass;

  SaveButton.Enabled:=false;
  Caption:=ProductName+' - '+Judge.Contest.Title+' ['+Judge.Contest.Path+']';  // Do not localize
  Judge.Settings.Recents.Add(Judge.Contest.Path);
  tv1.Items.Clear;
  for i:=0 to Judge.Contest.Problems.Count-1 do begin
    node:=tv1.Items.Add(nil,Judge.Contest.Problems.Items[i].Title);

    node.ImageIndex:=0;
    node.SelectedIndex:=0;

    node.Data:=Judge.Contest.Problems.Items[i];
    for j:=0 to Judge.Contest.Problems.Items[i].TestCases.Count-1 do begin
      sub:=tv1.Items.AddChild(node,inttostr(j+1));

      sub.ImageIndex:=1;
      sub.SelectedIndex:=1;

      sub.Data:=Judge.Contest.Problems.Items[i].TestCases.Items[j];
    end;
  end;

  LoadPeoples;
  UpdatePlaces;
  pgc1.Show;
  CountPageRefresh;
  OpenBtns;

  for i:=0 to Judge.Plugins.Count-1 do begin
    Judge.Plugins.Items[i].ContestOpen(pwidechar(Judge.Contest.Path));
  end;

  Judge.Settings.Save;

  Screen.Cursor:=crDefault;
  UpdateLook;

end;

procedure TMainForm.ContestClose(Sender: TObject);
var
  i:integer;
begin
  if SaveButton.Enabled then
    SaveButton.Click;
  pgc1.Hide;
  tv1.Items.Clear;

  pnl1.Hide;
  pnl2.Hide;

{
  for i:=0 to Judge.Contest.Peoples.Count-1 do
    if Judge.Contest.Peoples.Items[i].ResultWnd<>nil then
      TResultForm(Judge.Contest.Peoples.Items[i].ResultWnd).Destroy;
}

{
  lv1.Clear;
  Judge.Contest.Peoples.Clear;
}
  PeopleView.Clear;
  ProblemView.Items.Clear;

  i:=0;
  while i<Judge.Contest.Peoples.Count do begin
    if Judge.Contest.Peoples.Items[i].ResultWnd<>nil then
      TResultForm(Judge.Contest.Peoples.Items[i].ResultWnd).Close;
    if Judge.Contest.Peoples.Items[i].PropWnd<>nil then
      TPropForm(Judge.Contest.Peoples.Items[i].PropWnd).Close;
    if Judge.Contest.Peoples.Items[i].Client=nil then begin
      TListItem(Judge.Contest.Peoples.Items[i].Data1).Delete;
      if Judge.Contest.Peoples.Items[i].PropWnd<>nil then
        TPropForm(Judge.Contest.Peoples.Items[i].PropWnd).Destroy;
      Judge.Contest.Peoples.Delete(Judge.Contest.Peoples.Items[i]);
    end
    else
      inc(i);
  end;

  for i:=0 to Judge.Plugins.Count-1 do
    Judge.Plugins.Items[i].ContestClose;


  CloseBtns;
  UpdateLook;

end;

procedure TMainForm.tv1Changing(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
begin
  if SaveButton.Enabled then
    SaveButton.Click;
end;

procedure TMainForm.C1Click(Sender: TObject);
begin
  if JudgeThread.Suspended then
    Judge.Contest.Close
  else
    MessageBoxW(Handle,pwidechar(_('Please stop judging first.')),pwidechar(_('Error')),MB_ICONERROR);
end;

procedure TMainForm.pgc1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  if SaveButton.Enabled then
    SaveButton.Click;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
//  Windows.ShowWindow(Application.Handle,SW_HIDE);
//  SetProcessWorkingSetSize(GetCurrentProcess,$ffffffff,$ffffffff);
end;

procedure TMainForm.udpUDPRead(Sender: TObject; AData: TStream;
  ABinding: TIdSocketHandle);
var
  DataReceived: TPacket;
  Client:TClient;
  People, People1 :TPeople;
  PropForm: TPropForm;
begin
//  writeln('IN');
  AData.ReadBuffer(DataReceived,min(sizeof(DataReceived),AData.Size));

  Client:=Judge.Clients.FindClientID(DataReceived.ClientInfo.ClientID);
  if Client=nil then
    Client:=Judge.Clients.FindName(DataReceived.ClientInfo.Name);

//  writeln;

  case DataReceived.dwOperation of
    PO_ONLINE:
      begin
//        writeln('po_online');
//        writeln('his name: ',Datareceived.clientinfo.name);
        if Client<>nil then begin  // 以前他上过线
//          writeln('以前他上过线');
          People:=Client.People;

//          writeln('pointer of people = ',integer(people));

          if not SameFileName(Client.Info.Name,DataReceived.ClientInfo.Name) then begin // 改了名称
//            writeln('改了名称');
            if not People.HasLocalFolder then begin // 本来无本地
//              writeln('本来无本地');

              People1:=Judge.Contest.Peoples.FindName(UTF8Decode(DataReceived.ClientInfo.Name));
              if People1=nil then begin   // 新名称没有对应的本地选手，直接改
//                writeln('新名称没有对应的本地选手，直接改');
                Client.Info:=DataReceived.ClientInfo;
                Client.IP:=ABinding.PeerIP;
                Client.LastActive:=GetTickCount;
                People.Name:=UTF8Decode(Client.Info.Name);
                RefProForm(People); // people名称修改了，刷新people的propform
              end
              else begin          // 新名称有对应的本地选手，删掉原来的纯网络选手
//                writeln('新名称有对应的本地选手，删掉原来的纯网络选手');
                DelProForm(People); // 把people删除之前，检查他的propform
                TListItem(People.Data1).Delete;
                Judge.Contest.Peoples.Delete(People);
                People:=People1;
                Client.Info:=DataReceived.ClientInfo;
                Client.IP:=ABinding.PeerIP;
                Client.LastActive:=GetTickCount;
                People.Name:=UTF8Decode(Client.Info.Name);

                Client.People:=People;
                People.Client:=Client;
                RefProForm(People); // people属性(Client<>nil)修改了，刷新people的propform
              end;
            end
            else begin                  // 本来有本地，删掉原来的链接，建立新的
//              writeln('本来有本地');
              People.Client:=nil;
              RefreshPeople(People);
              RefProForm(People); // people属性(Client=nil)修改了，刷新people的propform

              People:=judge.Contest.Peoples.FindName(UTF8Decode(DataReceived.ClientInfo.Name));
              if People=nil then begin  // 新名称没有对应的本地选手，建立一个
//                writeln('新名称没有对应的本地选手，建立一个');
                People:=Judge.Contest.Peoples.Add;
                People.Name:=UTF8Decode(DataReceived.ClientInfo.Name);
                Client.Info:=DataReceived.ClientInfo;
                Client.IP:=ABinding.PeerIP;
                Client.LastActive:=GetTickCount;
                Client.People:=People;
                People.Client:=Client;
              end
              else begin  // 新名称有对应的本地选手，链过去
//                writeln('新名称有对应的本地选手，链过去');
                Client.People:=People;
                People.Client:=Client;
                RefProForm(People); // people属性(Client<>nil)修改了，刷新people的propform
              end;
            end;
          end
          else begin
            Client.Info:=DataReceived.ClientInfo;
            Client.IP:=ABinding.PeerIP;
            Client.LastActive:=GetTickCount;
            Client.People:=People;
            People.Client:=Client;
          end;
        end
        else begin  // 以前他没上过线，加一项
//          writeln('以前他没上过线，加一项');
          Client:=Judge.Clients.Add;
          Client.Info:=DataReceived.ClientInfo;
          Client.IP:=ABinding.PeerIP;
          Client.LastActive:=GetTickCount;

          People:=judge.Contest.Peoples.FindName(Client.Info.Name);
          if People=nil then begin  // 没有对应的People
            People:=Judge.Contest.Peoples.Add;
            People.Name:=UTF8Decode(DataReceived.ClientInfo.Name);
            Client.People:=People;
            People.Client:=Client;
          end
          else begin            // 有对应的本地选手
            Client.People:=People;
            People.Client:=Client;
          end;
        end;

        RefreshPeople(People);
      end;
    PO_OFFLINE:
      begin
//        writeln('received po_offline, from ',abinding.peerip);

        if Client<>nil then begin
          People:=Client.People;
          if not People.HasLocalFolder then begin

            DelProForm(People); // 把people删除之前，检查他的propform
            TListItem(People.Data1).Delete;

            if People.PropWnd<>nil then begin
              PropForm:=People.PropWnd;
              People.PropWnd:=nil;
              PropForm.Show;
            end;

            Judge.Contest.Peoples.Delete(People);
          end
          else begin
            People.Client:=nil;
            RefreshPeople(People);
            RefProForm(People); // people属性(Client=nil)修改了，刷新people的propform
          end;
          Judge.Clients.Delete(Client);    
        end;
      end;
  end;
//  writeln('OUT');
  UpdateLook;
end;

procedure TMainForm.lv1DblClick(Sender: TObject);
begin
  N3.Click;
end;

procedure TMainForm.ts1Resize(Sender: TObject);
begin
  grp1.Height:=ts1.Height+409-432;
  det.Height:=ts1.Height+409-432;
  det.Width:=ts1.Width-680+473;
{
  pnl1.Width:=det.Width-20;
  pnl2.Width:=pnl1.Width;
}
  pnl4.Height:=grp1.Height-409+385;
{
  pnl1.Height:=pnl4.Height;
  pnl2.Height:=pnl4.Height;
}
end;

procedure TMainForm.pnl1Resize(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to pnl1.ControlCount-1 do
    if pnl1.Controls[i].Tag=1 then
      pnl1.Controls[i].Width:=pnl1.Width-469+329;
end;

procedure TMainForm.pnl2Resize(Sender: TObject);
var
  i:integer;
begin
  for i:=0 to pnl2.ControlCount-1 do
    case pnl2.Controls[i].Tag of
      1:
        pnl2.Controls[i].Width:=pnl2.Width-469+328;
      2:
        pnl2.Controls[i].Width:=pnl2.Width-469+328-32;
      3:
        pnl2.Controls[i].Left:=pnl2.Width-469+424;
    end;
end;

procedure TMainForm.p_titleChange(Sender: TObject);
begin
  tv1.Selected.Text:=p_title.Text;
  ProblemView.Items.Item[0].Item[tv1.Selected.Index].Text:=p_title.Text;
  self.p_nameChange(Sender);
end;

procedure dfs(dir,part:widestring);
var
  ffd:TWin32FindDataW;
  hFile:dword;
begin
  hFile:=FindFirstFileW(pwidechar(Judge.Contest.Path+'\data\'+dir+'*'),ffd);  // Do not localize
  if hFile<>INVALID_HANDLE_VALUE then begin
    repeat
      if ffd.cFileName[0]<>'.' then begin  // Do not localize
        if (ffd.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY>0) then
          dfs(dir+ffd.cFileName+'\',part)  // Do not localize
        else begin
          if (part='') or (pos(uppercase(part),uppercase(dir+ffd.cFileName))>0) then  // Do not localize
            DropDownForm.ListBox1.AddItem(dir+ffd.cFileName,nil);
        end;
      end;
    until not FindNextFileW(hFile,ffd);
    windows.FindClose(hFile);
  end;
end;

function lcs(s1,s2:widestring):integer; 
var
  f:array[0..1] of array of integer;
  i,j:integer;
begin
  fillchar(f,sizeof(f),0);
  setlength(f[0],length(s2)+1);
  setlength(f[1],length(s2)+1);

{
            f[i-1,j-1]+1, if s1[i]=s2[j];
 f[i,j] =   max(f[i-1,j],f[i,j-1]), else.
}

  for i:=1 to length(s1) do
    for j:=1 to length(s2) do
      if s1[i]=s2[j] then
        f[i and 1,j]:=f[1-i and 1,j-1]+1
      else
        f[i and 1,j]:=max(f[1-i and 1,j],f[i and 1,j-1]);


  result:=f[length(s1) and 1,length(s2)];

  setlength(f[0],0);
  setlength(f[1],0);

end;

function multilcs(st:widestring; part:array of widestring):integer;
var
  i:integer;
begin
  result:=0;
  for i:=low(part) to high(part) do
    inc(result,lcs(lowercase(st),lowercase(part[i])));
end;

procedure quicksort(l,r:integer; part: array of widestring);
var
  i,j:integer;
  x,y:widestring;
begin
  if l>r then
    exit;
  i:=l;
  j:=r;
  x:=DropDownForm.ListBox1.Items[(l+r) div 2];
  repeat
    while (multilcs(DropDownForm.ListBox1.Items[i],part)>multilcs(x,part)) do
      inc(i);
    while (multilcs(DropDownForm.ListBox1.Items[j],part)<multilcs(x,part)) do
      dec(j);
    if i<=j then begin
      y:=DropDownForm.ListBox1.Items[i];
      DropDownForm.ListBox1.Items[i]:=DropDownForm.ListBox1.Items[j];
      DropDownForm.ListBox1.Items[j]:=y;
      inc(i);
      dec(j);
    end;
  until i>j;
  if l<j then
    quicksort(l,j,part);
  if i<r then
    quicksort(i,r,part);
end;


procedure TMainForm.t_inKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin


  if DropDownForm.Visible then begin
    TMemo(Sender).WantReturns:=false;
    case Key of
      VK_UP:
        begin
          if DropDownForm.ListBox1.ItemIndex>0 then
            DropDownForm.ListBox1.ItemIndex:=DropDownForm.ListBox1.ItemIndex-1;
          key:=0;
        end;
      VK_DOWN:
        begin
          DropDownForm.ListBox1.ItemIndex:=DropDownForm.ListBox1.ItemIndex+1;
          key:=0;
        end;
      VK_RETURN:
        begin
          if DropDownForm.ListBox1.ItemIndex>=0 then begin
//            OldOnChange:=t_in.OnChange;
//            t_in.OnChange:=nil;
            TMemo(Sender).Lines.Strings[TMemo(Sender).Perform(EM_LINEFROMCHAR,TMemo(Sender).SelStart,0)]:=DropDownForm.ListBox1.Items[DropDownForm.ListBox1.ItemIndex];
//            t_in.OnChange:=OldOnChange;
            DropDownForm.Hide;
          end;
          key:=0;
        end;
      else
//        DropDownForm.Hide;
    end;
  end
  else begin
    TMemo(Sender).WantReturns:=true;


  end;
    
end;

procedure TMainForm.t_inClick(Sender: TObject);
begin
  t_inChange(Sender);
end;

procedure TMainForm.t_inExit(Sender: TObject);
begin
  DropDownForm.Hide;
end;



procedure TMainForm.t_inChange(Sender: TObject);
var
  OldOnChange: TNotifyEvent;
  P1,P2: TPoint;
  l: integer;
begin
  
  OldOnChange:=TMemo(Sender).OnChange;
  TMemo(Sender).OnChange:=nil;

  if Sender=t_in then begin
    while TMemo(Sender).Lines.Count>TProblem(tv1.Selected.Parent.Data).Inputs.Count do begin
      l:=TMemo(Sender).Perform(EM_LINEFROMCHAR,t_in.SelStart,0);
      if (TProblem(tv1.Selected.Parent.Data).Inputs.Count=0) or ((l<t_in.Lines.Count) and (t_in.Lines.Strings[l]='')) then  // Do not localize
        t_in.Lines.Delete(l)
      else if (l-1<t_in.Lines.Count) and (t_in.Lines.Strings[l-1]='') then  // Do not localize
        t_in.Lines.Delete(l-1)
      else
        t_in.Lines.Delete(t_in.Lines.Count-1);
    end;
    while t_in.Lines.Count<TProblem(tv1.Selected.Parent.Data).Inputs.Count do begin
      t_in.Lines.Text:=t_in.Lines.Text+#13#10;
    end;

    if TMemo(Sender).Perform(EM_LINEFROMCHAR,TMemo(Sender).SelStart,0)>=TProblem(tv1.Selected.Parent.Data).Inputs.Count then begin
      t_in.OnChange:=OldOnChange;
      DropDownForm.Hide;
      exit;
    end;
  end;

  p_nameChange(Sender);

  if TMemo(Sender).Focused then begin
    DropDownForm.ListBox1.Items.BeginUpdate;
    DropDownForm.ListBox1.Clear;
    dfs('',TMemo(Sender).Lines.Strings[TMemo(Sender).Perform(EM_LINEFROMCHAR,TMemo(Sender).SelStart,0)]);  // Do not localize
    if Sender=t_in then
      quicksort(0,DropDownForm.ListBox1.Items.Count-1,[TProblem(tv1.Selected.Parent.Data).FileName,tv1.Selected.Text,'.in']);  // Do not localize
    DropDownForm.ListBox1.Items.EndUpdate;

    if DropDownForm.ListBox1.Count>0 then begin
      DropDownForm.ListBox1.ItemIndex:=0;
      p1.Y:=TMemo(Sender).Top+TMemo(Sender).Height;
      p1.X:=TMemo(Sender).Left+10;
      p2:=pnl2.ClientToScreen(p1);
      DropDownForm.Top:=p2.Y;
      DropDownForm.Left:=p2.X;
      DropDownForm.Width:=TMemo(Sender).Width;
      DropDownForm.Target:=TMemo(Sender);
      DropDownForm.Show;
      SetFocus;
    end
    else
      DropDownform.Hide;
  end;
  
  TMemo(Sender).OnChange:=OldOnChange;
end;

procedure TMainForm.I1Click(Sender: TObject);
begin
  Screen.Cursor:=crHourGlass;
  if CIForm=nil then
    Application.CreateForm(TCIForm,CIForm);
  CIForm.Show;
  CIForm.SetFocus;
  Screen.Cursor:=crDefault;
end;

procedure TMainForm.D1Click(Sender: TObject);
var
  i,j,r: integer;
  fo: _SHFILEOPSTRUCT;
  NodesToDel: array of TListItem;
  sFiles: string;
begin
  case lv1.SelCount of
    0:
      exit;
    1:
      r:=MessageBoxW(Handle,@WideFormat(_('Are you sure to delete %s''s programs and judge result?'),[lv1.Selected.Caption])[1],pwidechar(_('Confirm')),MB_ICONWARNING or MB_YESNO or MB_DEFBUTTON2); 
    else
      r:=MessageBoxW(Handle,@WideFormat(
           ngettext('Are you sure to delete the programs and judge result of selected %d contestant?',
                    'Are you sure to delete the programs and judge result of selected %d contestants?',
                    lv1.SelCount),
                    [lv1.SelCount])[1],pwidechar(_('Confirm')),MB_ICONWARNING or MB_YESNO or MB_DEFBUTTON2);
  end;
  if r=IDYES then begin
    SetLength(NodesToDel,lv1.SelCount);

    i:=0;
    for j:=0 to lv1.Items.Count-1 do
      if lv1.Items[j].Selected then begin
        NodesToDel[i]:=lv1.Items[j];
        inc(i);
      end;

    sFiles:='';  // Do not localize
    for i:=0 to lv1.SelCount-1 do
      sFiles:=sFiles+TPeople(NodesToDel[i].Data).Path+#0;
    sFiles:=sFiles+#0;
    
    fillchar(fo,sizeof(fo),0);
    fo.Wnd:=Handle;
    fo.wFunc:=FO_DELETE;
    fo.fFlags:=FOF_NOCONFIRMATION;
    fo.pFrom:=@sFiles[1];
    if SHFileOperation(fo)<>0 then begin
    end;
    N10.Click;
  end;
end;

procedure TMainForm.N4Click(Sender: TObject);
begin
  btn6.Click;
end;

procedure TMainForm.lv1Edited(Sender: TObject; Item: TListItem;
  var S: String);
var
  i:integer;
  fo:_SHFILEOPSTRUCTW;
  sFrom, sTo: widestring;
begin
  fo.Wnd:=Handle;
  fo.wFunc:=FO_RENAME;
  sFrom:=Judge.Contest.Path+'\src\'+Item.Caption+#0#0;  // Do not localize
  fo.pFrom:=pwidechar(sFrom);
  sTo:=Judge.Contest.Path+'\src\'+S+#0#0;  // Do not localize
  fo.pTo:=pwidechar(sTo);
  fo.fFlags:=0;
  if SHFileOperationW(fo)=0 then begin
    TPeople(Item.Data).Name:=S; 
    RefreshPeople(Item.Data);
  end
  else
    S:=Item.Caption;
end;

procedure TMainForm.M1Click(Sender: TObject);
begin
  lv1.Selected.EditCaption;
end;

procedure TMainForm.D2Click(Sender: TObject);
begin
  D1.Click;
end;

procedure TMainForm.tv1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  node: TTreeNode;
begin
  node:=tv1.GetNodeAt(x,y);
  if node<>nil then
    node.Selected:=true;
end;

procedure TMainForm.Splitter1Moved(Sender: TObject);
begin
  Button2.Left:=Panel1.Left+PeopleView.Left;
  Button2.Top:=Panel1.Top+Panel1.Height+8;
  Button3.Left:=Panel1.Left+ProblemVIew.Left;
  Button3.Top:=Panel1.Top+Panel1.Height+8;
end;

procedure TMainForm.Splitter1CanResize(Sender: TObject;
  var NewSize: Integer; var Accept: Boolean);
begin
  if NewSize+Splitter1.Width+161>Panel1.Width then
    NewSize:=Panel1.Width-Splitter1.Width-161;
end;

procedure TMainForm.ts3Resize(Sender: TObject);
begin
  Panel1.Height:=ts3.Height-45;
  if PeopleView.Width+Splitter1.Width+161<=ts3.Width-16 then Panel1.Width:=ts3.Width-16
  else begin
    PeopleView.Width:=ts3.Width-16-161-Splitter1.Width;
    Panel1.Width:=ts3.Width-16;
  end;
  MainForm.Splitter1Moved(nil);
end;

procedure CheckNodeDown(p: TJvTreeNode);
var
  t: TTreeNode;
  huc: boolean;
begin
  t:=p.getFirstChild;
  while t<>nil do begin
    TJvTreeNode(t).Checked:=p.Checked;
    CheckNodeDown(TJvTreeNode(t));
    t:=t.getNextSibling;
  end;
end;

procedure CheckNodeUp(p: TJvTreeNode);
var
  t: TTreeNode;
  old,huc: boolean;
begin
  if p.Parent=nil then exit;
  huc:=false;
  old:=TJvTreeNode(p.Parent).Checked;
  t:=p.Parent.getFirstChild;
  while t<>nil do begin
    if not TJvTreeNode(t).Checked then begin
      huc:=true;  break;
    end;
    t:=t.getNextSibling;
  end;
  if not huc<>old then begin
    TJvTreeNode(p.Parent).Checked:=not huc;
    CheckNodeUp(TJvTreeNode(p.Parent));
  end;
end;

procedure TMainForm.ProblemViewClick(Sender: TObject);
var
  p: TJvTreeNode;
begin
  p:=TJvTreeNode(ProblemView.Selected);
  CheckNodeDown(p);
  CheckNodeUp(p);
end;

procedure TMainForm.ProblemViewKeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(key)=VK_SPACE then MainForm.ProblemViewClick(nil);
end;

procedure TMainForm.SetColumnImage(List: TListView; Column, Image: Integer;
  ShowImage: Boolean);
var
  Align,hHeader: integer;
  HD: HD_ITEM;

begin
  hHeader := SendMessage(List.Handle, LVM_GETHEADER, 0, 0);
  with HD do begin
    case List.Columns[Column].Alignment of
      taLeftJustify:  Align := HDF_LEFT;
      taCenter:       Align := HDF_CENTER;
      taRightJustify: Align := HDF_RIGHT;
    end;
     

     
    pszText := PChar(List.Columns[Column].Caption);

    if ShowImage then begin
      mask := HDI_IMAGE or HDI_FORMAT;
      fmt := HDF_STRING or HDF_IMAGE or HDF_BITMAP_ON_RIGHT
    end
    else begin
      mask := HDI_FORMAT;
      fmt := HDF_STRING or Align;
    end;

    iImage := Image;
  end;
  Header_SetItem(hHeader, Column,HD);
end;

procedure TMainForm.lv1AdvancedCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
  var DefaultDraw: Boolean);
const
  DLC_DT_TEXT=DT_LEFT or DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or DT_END_ELLIPSIS;
var
  bCtrlFocused:boolean;
  rect,rect2:TRect;
  i,j:integer;
  image:TBitMap;
  hHeader: HWND;
begin
  Sender.Canvas.Lock;
  DefaultDraw:=false;

  rect:=item.DisplayRect(drBounds);
{
  inc(rect.Top);
  dec(rect.Bottom);
}

  bCtrlFocused:=GetFocus=Sender.Handle;

  if item.Selected then begin

    if bCtrlFocused then
      Sender.Canvas.Brush.Color:=$dac8c2
    else
      Sender.Canvas.Brush.Color:=$ece4e0;

    inc(rect.Left);
    dec(rect.Right);
    Sender.Canvas.FillRect(rect);
    dec(rect.Left);
    inc(rect.Right);

  end
  else begin
    Sender.Canvas.Brush.Color:=clWhite;
    Sender.Canvas.FillRect(rect);

  end;

  if bCtrlFocused and item.Focused then begin
    Sender.Canvas.Pen.Color:=$6a240a;
    inc(rect.Left);
    dec(rect.Right);
    Sender.Canvas.Rectangle(rect);
    dec(rect.Left);
    inc(rect.Right);
  end;

  hHeader := SendMessage(Sender.Handle, LVM_FIRST+31, 0, 0);


  for i:=0 to (Sender as TListView).Columns.Count-1 do begin
    j:=Header_OrderToIndex(hHeader,i);
{
  function ListView_GetSubItemRect(hwndLV: HWND; iItem, iSubItem: Integer;
  code: DWORD; prc: PRect): BOOL;
}
    ListView_GetSubItemRect(lv1.Handle,Item.Index,j,LVIR_BOUNDS,@rect);

    if j=2 then begin
      if Judge.Contest.Score<>0 then begin
        inc(rect.Top,2);
        dec(rect.Bottom,2);      
        rect2:=rect;
        rect2.Right:=trunc((strtofloat(item.SubItems.Strings[1])/Judge.Contest.Score)*(rect2.Right-rect2.Left)+rect2.Left);
        Sender.Canvas.Brush.Color:=$bdbdbd;
        Sender.Canvas.FillRect(rect2);

        rect2:=rect;
        rect2.Left:=trunc(rect2.Right-(1-strtofloat(item.SubItems.Strings[1])/Judge.Contest.Score)*(rect2.Right-rect2.Left));
        Sender.Canvas.Brush.Color:=$f0f0f0;
        Sender.Canvas.FillRect(rect2);

        dec(rect.Top,2);
        inc(rect.Bottom,2);
      end;
    end;

    inc(rect.Left,4);
    dec(rect.Right,4);

    SetBkMode(Sender.Canvas.Handle,TRANSPARENT);
    if j=0 then begin

      image:=TBitmap.Create;

      image.Transparent:=true;
      image.HandleType:=bmDIB;
      il1.GetBitmap(item.ImageIndex,image);
      image.TransparentColor:=image.Canvas.Pixels[0,0];
      
      ListView_GetSubItemRect(lv1.Handle,Item.Index,0,LVIR_ICON,@rect);

      BitBlt(Sender.Canvas.Handle, rect.Left,rect.Top,image.Width,image.Height, image.Canvas.Handle,           0,0, SRCAND); 

      image.Destroy;

      ListView_GetSubItemRect(lv1.Handle,Item.Index,0,LVIR_LABEL,@rect);
      DrawText(Sender.Canvas.Handle,pchar(item.caption),length(item.Caption),rect,DLC_DT_TEXT);

    end
    else
      DrawText(Sender.Canvas.Handle,pchar(item.SubItems.strings[j-1]),length(item.SubItems.strings[j-1]),rect,DLC_DT_TEXT);
    dec(rect.Left,4);
    inc(rect.Right,4);
  end;
  Sender.Canvas.Unlock;

end;

procedure TMainForm.Button2Click(Sender: TObject);
var
  i,j,p,Pcount: integer;
  PeopleRes: TPeopleResult;
  res: TContestRes;
  pp,tt: TTreeNode;
begin
  Screen.Cursor:=crHourGlass;

  res.Count:=0;
  res.SetCount(Judge.Contest.Problems.Count);
  for i:=0 to res.Count-1 do
    res.Item[i].SetCount(Judge.Contest.Problems.Items[i].TestCases.Count);

  Pcount:=0;
  for p:=0 to PeopleView.Items.Count-1 do if PeopleView.Items.Item[p].Checked then begin
    inc(Pcount);

    PeopleRes:=TPeopleResult.Create;
    PeopleRes.Load(PeopleView.Items.Item[p].Caption); 
    PeopleRes.Adjust(Judge.Contest);

    for i:=0 to res.Count-1 do with PeopleRes.ProblemResults.Items[i] do with res.Item[i] do begin
      TotalScore:=TotalScore+Score;
      if Score>MaxScore then MaxScore:=Score;

      for j:=0 to res.Item[i].Count-1 do begin
        Item[j].TotalScore:=Item[j].TotalScore+TestCaseResults.Items[j].Score;
        if TestCaseResults.Items[j].Score>Item[j].MaxScore then
          Item[j].MaxScore:=TestCaseResults.Items[j].Score;
      end;
    end;

    PeopleRes.Destroy;
  end;
  if Pcount=0 then begin
    Screen.Cursor:=crDefault;  
    MessageBoxW(Handle,pwidechar(_('No contestants selected.')),pwidechar(_('Error')),MB_OK or MB_ICONWARNING);
    exit;
  end;

  for i:=0 to res.Count-1 do begin
    res.Item[i].AverageScore:=res.Item[i].TotalScore/Pcount;
    for j:=0 to res.Item[i].Count-1 do
      res.Item[i].Item[j].AverageScore:=res.Item[i].Item[j].TotalScore/Pcount;
  end;

  pp:=ProblemView.Items.Item[0];
  pp.Text:=WideFormat(_('%s (%d contestants)'),[Judge.Contest.Title,Pcount]);
  for i:=0 to res.Count-1 do begin
    with Judge.Contest.Problems.Items[i] do with res.Item[i] do
      pp.Item[i].Text:=WideFormat(_('%s --- Full Score: %f -- Average Score: %f -- Highest Score: %f'),[Title, Score, AverageScore, MaxScore]);

    for j:=0 to res.Item[i].Count-1 do begin
      tt:=pp.Item[i].Item[j];
      with Judge.Contest.Problems.Items[i].TestCases.Items[j] do with res.Item[i].Item[j] do
        tt.Text:=WideFormat(_('%d --- Full Score: %f -- Average Score: %f -- Highest Score: %f'),[j+1, Score, AverageScore, MaxScore]); 
    end;

  end;

  res.Destroy;

  Screen.Cursor:=crDefault;
end;

procedure TMainForm.Button3Click(Sender: TObject);
var
  NPeopleRes: TPeopleRes;
  PeopleRes: TPeopleResult;
  i,j,p: integer;
  tmp: TListItem;
begin
  Screen.Cursor:=crHourGlass;

  for p:=0 to PeopleView.Items.Count-1 do begin
    fillchar(NPeopleRes,sizeof(NPeopleRes),0);

    PeopleRes:=TPeopleResult.Create;
    PeopleRes.Load(PeopleView.Items.Item[p].Caption);
    PeopleRes.Adjust(Judge.Contest);

    for i:=0 to ProblemView.Items.GetFirstNode.Count-1 do
      for j:=0 to ProblemView.Items.GetFirstNode.Item[i].Count-1 do begin
        with TJvTreeNode(ProblemView.Items.GetFirstNode.Item[i].Item[j]) do
          if Checked then begin
            NPeopleRes.TotalScore:=NPeopleRes.TotalScore+PeopleRes.ProblemResults.Items[i].TestCaseResults.Items[j].Score;
            if (PeopleRes.ProblemResults.Items[i].TestCaseResults.Items[j].Status=ST_CORRECT)or
               (PeopleRes.ProblemResults.Items[i].TestCaseResults.Items[j].Status=ST_PART_CORRECT) then
              NPeopleRes.EffectiveTime:=NPeopleRes.EffectiveTime+PeopleRes.ProblemResults.Items[i].TestCaseResults.Items[j].Time;
          end;
      end;
    PeopleView.Items.Item[p].SubItems.Strings[1]:=FloatToStr(NPeopleRes.TotalScore);
    PeopleView.Items.Item[p].SubItems.Strings[2]:=FloatToStr(NPeopleRes.EffectiveTime);

    PeopleRes.Destroy;

  end;

  if PeopleView.Items.Count>0 then begin
    MainForm.SortOrder2:=1;
    PeopleViewColumnClick(Sender,PeopleView.Column[3]);
    PeopleViewColumnClick(Sender,PeopleView.Column[2]);
    p:=1;
    PeopleView.Items.Item[0].SubItems[0]:='1';  // Do not localize
    for i:=1 to PeopleView.Items.Count-1 do
      if (PeopleView.Items.Item[i].SubItems[1]=PeopleView.Items.Item[i-1].SubItems[1])and
         (PeopleView.Items.Item[i].SubItems[2]=PeopleView.Items.Item[i-1].SubItems[2]) then
        PeopleView.Items.Item[i].SubItems[0]:=IntToStr(p)
      else begin
        PeopleView.Items.Item[i].SubItems[0]:=IntToStr(i+1);
        p:=i+1;
      end;
  end;

  Screen.Cursor:=crDefault;
end;

procedure TMainForm.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
var
  i:integer;
begin

  if msg.message=522 then begin
    if DropDownForm.Visible then
      if msg.wParam>0 then begin
        DropDownForm.ListBox1.ItemIndex:=DropDownForm.ListBox1.ItemIndex-1;
      end
      else
        DropDownForm.ListBox1.ItemIndex:=DropDownForm.ListBox1.ItemIndex+1;

  end;

             {
  if Msg.hwnd=lv1.Handle then begin
    allocconsole;
    writeln(Msg.message);
  end;


{
  if (msg.hwnd=SendMessage(lv1.Handle, LVM_FIRST+31, 0, 0)) and (msg.message<>512) and (msg.message<>WM_TIMER) and (msg.message<>15)  then begin
    writeln(msg.message);
    if (Msg.hwnd=SendMessage(lv1.Handle, LVM_FIRST+31, 0, 0)) then begin
      writeln('to header');
    end;
  end;
}  
(*
  if (Msg.hwnd=SendMessage(lv1.Handle, LVM_FIRST+31, 0, 0)) {and (Msg.message=WM_PAINT)} then begin
    for i:=0 to lv1.Columns.Count-1 do
      SetColumnImage(lv1,i,2,false);
    SetColumnImage(lv1,sortColumn1,3+SortOrder1,true);
//    Handled:=true;
  end;
  *)
end;

procedure TMainForm.R1Click(Sender: TObject);
var
  f: TPropForm;
  i,j: integer;
begin
  if lv1.SelCount>1 then begin
    Application.CreateForm(TPropForm,f);
    SetLength(f.Peoples,lv1.SelCount);
    f.peoplesCount:=lv1.SelCount;
    j:=0;
    for i:=0 to lv1.Items.Count-1 do if lv1.Items.Item[i].Selected then
      if TPeople(lv1.Items.Item[i].Data).PropWnd=nil then begin
        inc(j);
        f.Peoples[j-1]:=TPeople(lv1.Items.Item[i].Data);
        TPeople(lv1.Items.Item[i].Data).PropWnd:=f;
      end;
    SetLength(f.Peoples,j);
    f.peoplesCount:=j;
    if j>0 then f.Show
    else f.Destroy;
  end else
  if lv1.SelCount=1 then
    if TPeople(lv1.Selected.Data).PropWnd<>nil then begin
      ShowWindow(TResultForm(TPeople(lv1.Selected.Data).PropWnd).Handle,SW_RESTORE);
      SetForegroundWindow(TResultForm(TPeople(lv1.Selected.Data).PropWnd).Handle);
    end else begin
      Application.CreateForm(TPropForm,f);
      SetLength(f.Peoples,1);
      f.peoplesCount:=1;
      f.Peoples[0]:=TPeople(lv1.Selected.Data);
      TPeople(lv1.Selected.Data).PropWnd:=f;
      f.Show;
    end;
end;

procedure TMainForm.LoadPeoples;
var
  i:integer;
  pr: TPeopleResult;
begin
  lv1.Clear;
  PeopleView.Clear;

  stat1.Panels[0].Text:=_('Loading...');

  lv1.Items.BeginUpdate;

  for i:=0 to Judge.Contest.Peoples.Count-1 do begin
    RefreshPeople(Judge.Contest.Peoples.Items[i]);

    if i and 7=0 then begin
      stat1.Panels[1].Text:=WideFormat('%d / %d',[i+1,Judge.Contest.Peoples.Count]);
      stat1.Refresh;
    end;

    pr:=TPeopleResult.Create;
    pr.Load(Judge.Contest.Peoples.Items[i]);
    if Judge.Contest.Peoples.Items[i].Data1<>nil then
      with TListItem(Judge.Contest.Peoples.Items[i].Data1) do begin
        if Judge.Contest.Peoples.Items[i].HasResult then begin
          SubItems.Strings[1]:=floattostr(pr.Score);
          SubItems.Strings[2]:=floattostr(pr.Time);
          try
            SubItems.Strings[6]:=DateTimeToStr(pr.JudgeTime);
          except
          end;
        end
        else begin
          SubItems.Strings[1]:='0';  // Do not localize
          SubItems.Strings[2]:='0';  // Do not localize
          SubItems.Strings[6]:='';  // Do not localize
        end;
    end;
    pr.Destroy;
  end;

  lv1.Items.EndUpdate;

  stat1.Panels[0].Text:=_('Idle');  
  stat1.Panels[1].Text:='';

end;

procedure TMainForm.N10Click(Sender: TObject);
begin
  Judge.Contest.Peoples.Refresh;
  LoadPeoples;
  UpdatePlaces;
end;

procedure TMainForm.G1Click(Sender: TObject);
var
  i,j:integer;
begin
  for i:=0 to lv1.Items.Count-1 do
    if ((lv1.SelCount=0) or lv1.Items.Item[i].Selected) and (TPeople(lv1.Items.Item[i].Data).Client<>nil) then begin
      if TPeople(lv1.Items.Item[i].Data).Status in [PS_NOT_GETTED,PS_NOT_JUDGED,PS_JUDGED] then begin
        TPeople(lv1.Items.Item[i].Data).Status:=PS_QUEUED_FOR_GETTING;
        RefreshPeople(lv1.Items.Item[i].Data);
        ClientsToGet.AddToRear(TPeople(lv1.Items.Item[i].Data).Client.Info.ClientID);
      end;
    end;
  for i:=1 to 5 do
    Threads[i]:=TCollectorThread.Create(false);
end;


function PeopleStatusToStr(Status: integer): widestring;
begin
  case Status of
    PS_NOT_GETTED          : result:=_('Not Gathered');
    PS_QUEUED_FOR_GETTING  : result:=_('Waiting for Gathering');
    PS_GETTING             : result:=_('Gathering');
    PS_NOT_JUDGED          : result:=_('Not Judged');
    PS_QUEUED_FOR_JUDGING  : result:=_('Waiting for Judging');
    PS_JUDGING             : result:=_('Judging');
    PS_JUDGED              : result:=_('Judged');
  end;
end;


procedure TMainForm.RefreshPeople(People: TPeople);
begin
//  writeln('refreshpeople, ',people.name);

  if not MainForm.N18.Checked and not People.HasLocalFolder then
    exit;

  if People.Data1=nil then 
    People.Data1:=lv1.Items.Add;

  with TListItem(People.Data1) do begin
//    writeln('item index=',index);
    Data:=People;
    while SubItems.Count<lv1.Columns.Count-1 do
      SubItems.Add('0');  // Do not localize
    Caption:=People.Name;
    SubItems.Strings[3]:=PeopleStatusToStr(People.Status);
    SubItems.Strings[4]:=People.LocationStr;
    if SubItems.Strings[4]='L-' then  // Do not localize
      ImageIndex:=2
    else if SubItems.Strings[4]='-R' then  // Do not localize
      ImageIndex:=5
    else
      ImageIndex:=6;
//    writeln('location str=',people.locationstr);    
    if People.HasLocalFolder then
      SubItems.Strings[5]:=datetimetostr(People.CollectTime)
    else
      SubItems.Strings[5]:='';  // Do not localize
    if People.Client<>nil then begin
      SubItems.Strings[7]:=People.Client.IP;
      SubItems.Strings[8]:=UTF8Decode(People.Client.Info.WorkDir);
    end
    else begin
      SubItems.Strings[7]:='';  // Do not localize
      SubItems.Strings[8]:='';  // Do not localize
    end;
  end;

  if People.HasResult then begin
    if People.Data2=nil then
      People.Data2:=PeopleView.Items.Add;
    with TListItem(People.Data2) do begin
      while SubItems.Count<PeopleView.Columns.Count-1 do
        SubItems.Add('');  // Do not localize
      Data:=People;

      ImageIndex:=2;
      Caption:=People.Name;
    end;
  end;
  
end;

procedure TMainForm.lv1Change(Sender: TObject; Item: TListItem;
  Change: TItemChange);
var
  ok:boolean;
  i:integer;
begin
  btn5.Enabled:=lv1.Items.Count>0;
  btn6.Enabled:=lv1.Items.Count>0;
  G1.Enabled:=false;
  if lv1.SelCount>0 then begin
    ok:=false;
    for i:=0 to lv1.Items.Count-1 do
      if lv1.Items[i].Selected and (TPeople(lv1.Items[i].Data).Client<>nil) then
        ok:=true;
    G1.Enabled:=ok;
  end;
  N4.Enabled:=lv1.SelCount>0;
  case lv1.SelCount of
    0:
      begin
        btn5.Caption:=_('&Gather All');
        btn6.Caption:=_('&Judge All');
      end;
    else
      begin
        btn5.Caption:=_('&Gather');
        btn6.Caption:=_('&Judge');
      end;
  end;
end;

procedure TMainForm.UpdatePlaces;
var
  List: TList;
  i:integer;
  p: pointer;
begin
  List:=TList.Create;
  List.Count:=lv1.Items.Count;
  for i:=0 to lv1.Items.Count-1 do begin
    GetMem(p,sizeof(TSortItem));
    List.Items[i]:=p;
    PSortItem(List.Items[i]).ListItem:=lv1.Items.Item[i];
    PSortItem(List.Items[i]).Score:=strtofloat(lv1.Items.Item[i].SubItems[1]);
    PSortItem(List.Items[i]).Time:=strtofloat(lv1.Items.Item[i].SubItems[2]);
  end;
  Sort(List);
  for i:=0 to List.Count-1 do begin
    PSortItem(List.Items[i]).ListItem.SubItems[0]:=inttostr(PSortItem(List.Items[i]).Place);
    p:=List.Items[i];
    FreeMem(p,sizeof(TSortItem));
  end;
  List.Destroy;
end;

procedure TMainForm.p_nameChange(Sender: TObject);
begin
  SaveButton.Enabled:=true;


end;

procedure TMainForm.tv1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=VK_INSERT then
    if Shift=[ssCtrl] then
      MenuItem1.Click
    else if Shift=[] then
      N2.Click
    else if Shift=[ssCtrl,ssAlt] then
      O4.Click
    else
  else if Key=VK_DELETE then
    MenuItem2.Click;
    
end;

procedure TMainForm.F2Click(Sender: TObject);
begin
  ShellExecuteW(Handle,'open',pwidechar(Judge.Contest.Path),'','',SW_SHOW);  // Do not localize
end;

procedure TMainForm.Timer2Timer(Sender: TObject);
var
  i:integer;
  PropForm: TPropForm;
begin
  i:=0;
  while i<Judge.Clients.Count do begin
    if (now-Judge.Clients.Items[i].LastActive)*86400>30 then begin 
      if not Judge.Clients.Items[i].People.HasLocalFolder then begin
        if Judge.Clients.Items[i].People.Data1<>nil then begin
          TListItem(Judge.Clients.Items[i].People.Data1).Delete;
          Judge.Clients.Items[i].People.Data1:=nil;
        end;
        if Judge.Clients.Items[i].People.PropWnd<>nil then begin
          PropForm:=Judge.Clients.Items[i].People.PropWnd;
          Judge.Clients.Items[i].People.PropWnd:=nil;
          PropForm.Show;
        end;

        Judge.Contest.Peoples.Delete(Judge.Clients.Items[i].People);
      end
      else begin
        Judge.Clients.Items[i].People.Client:=nil;
        RefreshPeople(Judge.Clients.Items[i].People);
      end;
      Judge.Clients.Delete(Judge.Clients.Items[i]);
      MainForm.UpdatePlaces;
    end
    else
      inc(i);
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Judge.Contest.IsOpen then begin
    C1.Click;
    if Judge.Contest.IsOpen then begin
      CanClose:=false;
      exit;
    end;
  end;
//  Hide;
  udp.Active:=false;
  SaveAllOptions;
  Judge.Settings.Save;
  TerminateProcess(GetCurrentProcess,0);

end;

procedure TMainForm.FormDeactivate(Sender: TObject);
begin
  if SaveButton.Enabled then
    SaveButton.Click;
//  DropDownForm.Hide;
end;

procedure TMainForm.t_inKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if t_in.Perform(EM_LINEFROMCHAR,t_in.SelStart,0)>=TProblem(tv1.Selected.Parent.Data).Inputs.Count then begin
    DropDownForm.Hide;
    exit;
  end;
end;

function allok(TestCase: TTestCase):boolean;
var
  i:integer;
  ok: boolean;
begin
  result:=false;
  ok:=false;
  for i:=0 to TestCase.Inputs.Count-1 do begin
    if not FileExistsW(Judge.Contest.Path+'\data\'+TestCase.Inputs.Items[i].FileName,true) then  // Do not localize
      exit;
    if TestCase.Inputs.Items[i].FileName<>'' then
      ok:=true;  
  end;
  if TestCase.Output.FileName<>'' then
    ok:=true;
  result:=ok and FileExistsW(Judge.Contest.Path+'\data\'+TestCase.Output.FileName,true);  // Do not localize
end;

procedure TMainForm.O4Click(Sender: TObject);
var
  node1,node2,added:TTreeNode;
  Count: integer;
begin

  if SaveButton.Enabled then
    SaveButton.Click;
  node1:=tv1.Selected;
  if node1=nil then
    exit;
  if node1.Parent<>nil then
    node1:=node1.Parent;

  if node1.getFirstChild=nil then begin
    MessageBoxW(Handle,pwidechar(_('Please add the first testcase manually.')),pwidechar(_('Error')),MB_ICONERROR);
    exit;
  end;


  Count:=0;

  tv1.Items.BeginUpdate;
  repeat
    node2:=tv1.Items.AddChild(node1,'');  // Do not localize
    node2.ImageIndex:=1;
    node2.SelectedIndex:=1;
    node2.Data:=TProblem(node1.Data).TestCases.Add;
    node2.Text:=inttostr(TProblem(node1.Data).TestCases.Count);
    TTestCase(node2.Data).AutoNext(node2.Parent.Data);
    node2.Selected:=true;
    added:=ProblemView.Items.AddChild(ProblemView.Items.Item[0].Item[node1.Index],node2.Text);
    added.ImageIndex:=1;
    inc(Count);
  until not allok(node2.Data);

  TProblem(node1.Data).TestCases.Delete(TTestCase(node2.Data));
  node2.Delete;
  added.Delete;
  tv1.Items.EndUpdate;  
  node1.GetLastChild.Selected:=true;

//  if Count=1 then
//    MessageBoxW(Handle,pwidechar('Unable to find other suitable files.'
  SaveButton.Enabled:=true;
end;

procedure TMainForm.t_outChange(Sender: TObject);
var
  p1,p2: tpoint;
  OldOnChange: TNotifyEvent;
  node: TTreeNode;
begin

  OldOnChange:=TEdit(Sender).OnChange;
  TEdit(Sender).OnChange:=nil;

  p_nameChange(Sender);

  
  if TEdit(Sender).Focused then begin
    DropDownForm.ListBox1.Items.BeginUpdate;
    DropDownForm.ListBox1.Clear;
    dfs('',TEdit(Sender).Text);  // Do not localize
    Node:=tv1.Selected;
    if Node.Parent<>nil then
      Node:=Node.Parent;
    if Sender<>p_cm then
      quicksort(0,DropDownForm.ListBox1.Items.Count-1,[TProblem(Node.Data).FileName+tv1.Selected.Text+'.out']);  // Do not localize
    DropDownForm.ListBox1.Items.EndUpdate;



    if DropDownForm.ListBox1.Count>0 then begin
      DropDownForm.ListBox1.ItemIndex:=0;
      p1.Y:=TEdit(Sender).Top+TEdit(Sender).Height;
      p1.X:=TEdit(Sender).Left+10;
      p2:=pnl2.ClientToScreen(p1);
      DropDownForm.Top:=p2.Y;
      DropDownForm.Left:=p2.X;
      DropDownForm.Width:=TEdit(Sender).Width;
      DropDownForm.Target:=TControl(Sender);
      DropDownForm.Show;
      SetFocus;
    end
    else
      DropDownForm.Hide;
  end;

  TEdit(Sender).OnChange:=OldOnChange;
end;

procedure TMainForm.t_outKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if DropDownForm.Visible then begin
    case Key of
      VK_UP:
        begin
          if DropDownForm.ListBox1.ItemIndex>0 then
            DropDownForm.ListBox1.ItemIndex:=DropDownForm.ListBox1.ItemIndex-1;
          key:=0;
        end;
      VK_DOWN:
        begin
          DropDownForm.ListBox1.ItemIndex:=DropDownForm.ListBox1.ItemIndex+1;
          key:=0;
        end;
      VK_RETURN:
        begin
          if DropDownForm.ListBox1.ItemIndex>=0 then begin
//            OldOnChange:=TEdit(Sender).OnChange;
//            TEdit(Sender).OnChange:=nil;
            TEdit(Sender).Text:=DropDownForm.ListBox1.Items[DropDownForm.ListBox1.ItemIndex];
//            TEdit(Sender).OnChange:=OldOnChange;
            DropDownForm.Hide;
          end;
          key:=0;
        end;
      else
//        DropDownForm.Hide;
    end;
  end;

end;



procedure TMainForm.lv1Editing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  AllowEdit:=TPeople(Item.Data).HasLocalFolder;
end;

procedure TMainForm.tv1Addition(Sender: TObject; Node: TTreeNode);
begin
  ts1.Caption:=Format(_('Problems')+' (%d)',[Judge.Contest.Problems.Count]);
end;

procedure TMainForm.PeopleViewColumnClick(Sender: TObject;
  Column: TListColumn);
var
  i:integer;
begin
  SortOrder2:=1-SortOrder2;
  SortColumn2:=Column.Index;
  PeopleView.CustomSort(@CustomSortProc,Column.Index);
  for i:=0 to PeopleView.Columns.Count-1 do
    SetColumnImage(PeopleView,i,2,false);
  SetColumnImage(PeopleView,SortColumn2,3+SortOrder2,true);

end;

procedure TMainForm.C7Click(Sender: TObject);
var
  i:integer;
  Task:TTask;
begin
  for i:=0 to lv1.Items.Count-1 do
    if (lv1.SelCount=0) or lv1.Items.Item[i].Selected then begin
      if TPeople(lv1.Items[i].Data).Status in [PS_NOT_JUDGED,PS_JUDGED] then begin
        Task:=TTask.Create;
        Task.People:=lv1.Items[i].Data;
        Task.ProblemID:=-1;
        Task.OnlyJudgeChanged:=true; 
        TaskQueue.Add(Task);
        TPeople(lv1.Items[i].Data).Status:=PS_QUEUED_FOR_JUDGING;
        RefreshPeople(lv1.Items[i].Data);
      end;
    end;
  JudgeThread.Resume;
end;

procedure TMainForm.B1Click(Sender: TObject);
begin
  stat1.Visible:=not stat1.Visible;
  b1.Checked:=stat1.Visible;
  Resize;
end;

procedure TMainForm.A1Click(Sender: TObject);
begin
  PeopleView.SelectAll;
end;

procedure TMainForm.V3Click(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to PeopleView.Items.Count-1 do
    PeopleView.Items.Item[i].Selected:=not PeopleView.Items.Item[i].Selected;
end;

procedure TMainForm.C3Click(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to PeopleView.Items.Count-1 do
    if PeopleView.Items.Item[i].Selected then PeopleView.Items.Item[i].Checked:=true;
end;

procedure TMainForm.C4Click(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to PeopleView.Items.Count-1 do
    if PeopleView.Items.Item[i].Selected then PeopleView.Items.Item[i].Checked:=false;
end;

procedure TMainForm.V4Click(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to PeopleView.Items.Count-1 do
    PeopleView.Items.Item[i].Checked:=true;
end;

procedure TMainForm.B2Click(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to PeopleView.Items.Count-1 do
    PeopleView.Items.Item[i].Checked:=false;
end;

procedure TMainForm.N18Click(Sender: TObject);
var
  i:integer;
begin
  lv1.Items.BeginUpdate;
  for i:=0 to Judge.Contest.Peoples.Count-1 do
    if N18.Checked then
      RefreshPeople(Judge.Contest.Peoples.Items[i])
    else if (Judge.Contest.Peoples.Items[i].Data1<>nil) and not Judge.Contest.Peoples.Items[i].HasLocalFolder then begin
      TListItem(Judge.Contest.Peoples.Items[i].Data1).Delete;
      Judge.Contest.Peoples.Items[i].Data1:=nil;
    end;
  lv1.Items.EndUpdate;
  UpdateLook;      
end;

procedure TMainForm.PeopleViewDblClick(Sender: TObject);
var
  Node:TListItem;
  p: tpoint;
begin
  GetCursorPos(p);
  p:=PeopleView.ScreenToClient(p);
  Node:=PeopleView.GetItemAt(p.X,p.Y);
  if Node<>nil then 
    Node.Checked:=not Node.Checked;
end;

procedure TMainForm.SaveAllOptions;
var
  i: integer;
begin
  with Judge.Settings do begin
    WindowSet.WinMaxSize:=WindowState=wsMaximized;
    if WindowState<>wsMaximized then begin
      WindowSet.Height:=Height;
      WindowSet.Width:=Width;
      WindowSet.Left:=Left;
      WindowSet.Top:=Top;
    end;
    WindowSet.N18Checked:=N18.Checked;
    WindowSet.B1Checked:=B1.Checked;
    for i:=0 to lv1.Columns.Count-1 do
      WindowSet.Lv1ColWidth.Width[i]:=lv1.Column[i].Width;
    for i:=0 to PeopleView.Columns.Count-1 do
      WindowSet.PeopleVColWidth.Width[i]:=PeopleView.Column[i].Width;
  end;
end;

procedure TMainForm.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  if (NewWidth<>Width) or (NewHeight<>Height) then
    with Judge.Settings do
      if WindowState<>wsMaximized then begin
        WindowSet.Left:=Left;
        WindowSet.Top:=Top;
        WindowSet.Height:=Height;
        WindowSet.Width:=Width;
      end;
end;

procedure TMainForm.DelProForm(People: TPeople);
var
  i: integer;
begin
  if People.PropWnd<>nil then begin
    for i:=0 to TPropForm(People.PropWnd).peoplesCount-1 do
      if TPropForm(People.PropWnd).Peoples[i]=People then
        TPropForm(People.PropWnd).Peoples[i]:=nil;
    TPropForm(People.PropWnd).FormShow(nil);
  end;
end;

procedure TMainForm.RefProForm(People: TPeople);
begin
  if People.PropWnd<>nil then begin
//    TPropForm(People.PropWnd).Show;
    TPropForm(People.PropWnd).FormShow(nil);
  end;
end;

procedure TMainForm.OpenBtns;
begin
  C1.Enabled:=true;
  F2.Enabled:=true;
  P1.Enabled:=true;

  N11.Enabled:=true;
  N26.Enabled:=true;
  S1.Enabled:=true;
  N24.Enabled:=true;
  N23.Enabled:=true;
  N25.Enabled:=true;
  V2.Enabled:=true;
  D1.Enabled:=true;

  N18.Enabled:=true;
end;

procedure TMainForm.CloseBtns;
begin
  C1.Enabled:=false;
  F2.Enabled:=false;
  P1.Enabled:=false;

  N11.Enabled:=false;
  N26.Enabled:=false;
  S1.Enabled:=false;
  N24.Enabled:=false;
  N23.Enabled:=false;
  N25.Enabled:=false;
  V2.Enabled:=false;
  D1.Enabled:=false;

  N18.Enabled:=false;
end;

procedure TMainForm.t_scoreChange(Sender: TObject);
begin
  TEdit(Sender).Text:=FloatNum(TEdit(Sender).Text);

  p_nameChange(sender);
end;

procedure TMainForm.UpdateLook;
begin
  if Judge.Contest.IsOpen then
    Caption:=ProductName+' - '+Judge.Contest.Title+' ['+Judge.Contest.Path+']' 
  else
    Caption:=ProductName+' - '+_('(No Contest Open)');
    
  ts1.Caption:=WideFormat(_('Problems')+' (%d)',[Judge.Contest.Problems.Count]);
  ts2.Caption:=WideFormat(_('Contestants')+' (%d)',[lv1.Items.Count]);

  lv1Change(nil,nil,TItemChange(0));

end;



procedure TMainForm.N19Click(Sender: TObject);
begin
  TranslateTo('zh_CN');
end;

procedure TMainForm.N20Click(Sender: TObject);
begin
  TranslateTo('en');
end;

procedure TMainForm.z1Click(Sender: TObject);
begin
  TranslateTo('');
end;

procedure TMainForm.N11Click(Sender: TObject);
begin
  GatherNow(true);
end;

procedure TMainForm.N26Click(Sender: TObject);
begin
  GatherNow(false);
end;

procedure TMainForm.S1Click(Sender: TObject);
begin
  JudgeNow(true,false);
end;

procedure TMainForm.N24Click(Sender: TObject);
begin
  JudgeNow(false,false);
end;

procedure TMainForm.P3Click(Sender: TObject);
begin
  P1.Click;
end;

procedure TMainForm.JudgeNow(OnlySelected, OnlyModified: boolean);
var
  i:integer;
  Task:TTask;
  ok:boolean;
begin
  Screen.Cursor:=crHourGlass;
  if Judge.Contest.Problems.Count=0 then
    MessageBoxW(Handle,pwidechar(_('Test data is not configured.')),pwidechar(_('Error')),MB_ICONERROR)
  else begin
    ok:=false;
    for i:=0 to lv1.Items.Count-1 do
      if (not OnlySelected)or lv1.Items.Item[i].Selected then begin
        if TPeople(lv1.Items[i].Data).HasLocalFolder and (TPeople(lv1.Items[i].Data).Status in [PS_NOT_JUDGED,PS_JUDGED]) then begin
          Task:=TTask.Create;
          Task.People:=lv1.Items[i].Data;
          Task.ProblemID:=-1;
          Task.OnlyJudgeChanged:=OnlyModified;
          TaskQueue.Add(Task);
          TPeople(lv1.Items[i].Data).Status:=PS_QUEUED_FOR_JUDGING;
          RefreshPeople(lv1.Items[i].Data);
          ok:=true;
        end;
      end;
    if ok {and JudgeThread.Suspended} then
      JudgeThread.Resume;
  end;
  Screen.Cursor:=crDefault;  
end;

procedure TMainForm.N23Click(Sender: TObject);
begin
  JudgeNow(true,true);
end;

procedure TMainForm.N25Click(Sender: TObject);
begin
  JudgeNow(false,true);
end;

procedure TMainForm.V2Click(Sender: TObject);
begin
  N3.Click;
end;

procedure TMainForm.TranslateTo(Lang: string);
var
  i,old:integer;
begin

  Screen.Cursor:=crHourGlass;

  old:=p_cm.ItemIndex;
  UseLanguage(Lang);
  if not translatted then begin
    TranslateComponent(self);
    translatted:=true;
  end
  else
    RetranslateComponent(self);
  UpdateLook;

  MainForm.Refresh;  
  
  p_cm.ItemIndex:=old;
{
  for i:=0 to Judge.Contest.Peoples.Count-1 do
    if Judge.Contest.Peoples.Items[i].PropWnd<>nil then
      TranslateComponent(Judge.Contest.Peoples.Items[i].PropWnd);
}
  for i:=0 to lv1.Items.Count-1 do
    RefreshPeople(lv1.Items[i].Data);
{
  if MessageForm<>nil then
    TranslateComponent(MessageForm);
}
  Judge.Settings.NormalSet.Language:=Lang;

  Screen.Cursor:=crDefault;  

end;

procedure TMainForm.N29Click(Sender: TObject);
var
  s: widestring;
begin
  Screen.Cursor:=crHourGlass;
  ShellExecuteW(Handle,'open',HomepageURL,'','',SW_SHOW);  // Do not localize
  Screen.Cursor:=crDefault;
end;

procedure TMainForm.GatherNow(OnlySelected: boolean);
var
  i:integer;
begin
  for i:=0 to Judge.Clients.Count-1 do
    if (not OnlySelected) or ((Judge.Clients.Items[i].People.Data1<>nil) and (TListItem(Judge.Clients.Items[i].People.Data1).Selected)) then begin
      if Judge.Clients.Items[i].People.Status in [PS_NOT_GETTED,PS_NOT_JUDGED,PS_JUDGED] then begin
        Judge.Clients.Items[i].People.Status:=PS_QUEUED_FOR_GETTING;
        RefreshPeople(Judge.Clients.Items[i].People);
        ClientsToGet.AddToRear(Judge.Clients.Items[i].Info.ClientID);
      end;
    end;
  for i:=1 to 5 do
    Threads[i]:=TCollectorThread.Create(false);
end;

procedure TMainForm.C6Click(Sender: TObject);
begin
  HtmlHelpW(handle,pwidechar(Judge.Path+'\cena.chm'),0,nil)
end;

procedure TMainForm.p_addExit(Sender: TObject);
begin
  DropDownForm.Hide;
end;

procedure TMainForm.tv1Deletion(Sender: TObject; Node: TTreeNode);
begin
  if tv1.SelectionCount=0 then begin
    pnl1.Hide;
    pnl2.Hide;
  end;
end;

procedure TMainForm.N31Click(Sender: TObject);
begin
  TranslateTo('zh_TW');
end;

procedure TMainForm.Timer3Timer(Sender: TObject);
var
  i:integer;
  Task:TTask;
  ok:boolean;
begin
  if Judge.Contest.IsOpen then begin
    Screen.Cursor:=crHourGlass;
    ok:=false;
    if Judge.Contest.Problems.Count>0 then begin
      for i:=0 to Judge.Contest.Peoples.Count-1 do
        if Judge.Contest.Peoples.Items[i].Status=PS_NOT_JUDGED then begin
          Task:=TTask.Create;
          Task.People:=Judge.Contest.Peoples.Items[i];
          Task.ProblemID:=-1;
          Task.OnlyJudgeChanged:=false;
          TaskQueue.Add(Task);
          Judge.Contest.Peoples.Items[i].Status:=PS_QUEUED_FOR_JUDGING;
          RefreshPeople(Judge.Contest.Peoples.Items[i]);
          ok:=true;
        end;
        if ok {and JudgeThread.Suspended} then
          JudgeThread.Resume;
    end;
    Screen.Cursor:=crDefault;
  end;
end;

procedure TMainForm.CheckBox1Click(Sender: TObject);
begin
  Timer3.Enabled:=CheckBox1.Checked;
end;

procedure TMainForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
//  Params.WndParent:=GetDesktopWindow;
end;

procedure TMainForm.tv1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  accept:=false;
  exit;
  if Source is TTreeView then
    with TTreeView(Source) do
      if assigned(GetNodeAt(X,Y)) and (SelectionCount=1) then
        Accept:=true;
end;

procedure TMainForm.tv1DragDrop(Sender, Source: TObject; X, Y: Integer);
var
  dstNode:TTreeNode;
begin
  if Source is TTreeView then begin
    dstNode := TTreeView(Sender).GetNodeAt(X,Y);
    TTreeView(Source).Selected.MoveTo(dstNode,naInsert);
  end;
end;

procedure TMainForm.A3Click(Sender: TObject);
var
  node:TTreeNode;
begin
  tv1.ClearSelection(false);
  node:=tv1.Items.Add(nil,'');  // Do not localize
  node.Data:=Judge.Contest.Problems.Add;
  TProblem(node.Data).IsSubmit:=true;
  TProblem(node.Data).CompareType:=1;
  ProblemView.Items.AddChild(ProblemView.Items.Item[0],'');  // Do not localize


  node.Selected:=true;

  p_title.Text:=Format(_('提交答案式试题 %d'),[node.Index+1]); 
  p_title.SetFocus;

  SaveButton.Enabled:=true;
end;

procedure TMainForm.PromptNewVersion;
begin
  if MessageBoxW(0, pwidechar(_('A newer version of Cena is available. Would you like to download it now?')), ProductName, MB_YESNO or MB_ICONINFORMATION)=IDYES then
    N29Click(nil);
end;

procedure TMainForm.t_outClick(Sender: TObject);
begin
  t_outChange(Sender);
end;

end.


