unit PrintFormU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Printers, ComCtrls, ImgList, JvComCtrls, ExtCtrls,
  ojconst, ojrc, ojtc, Spin, Menus, MyUtils, jvgnugettext;

type
  TPrintForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    gb3: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    lv1: TListView;
    Panel1: TPanel;
    Panel2: TPanel;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    Button4: TButton;
    PopupMenu1: TPopupMenu;
    N1: TMenuItem;
    B1: TMenuItem;
    Button6: TButton;
    SaveDlg: TSaveDialog;
    Button3: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure B1Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
  published
    procedure PrintNow;
    procedure PrintList_Detail;
    procedure PrintList_Simple;
    procedure PrintReport(PeoName: string);
    procedure DrawTableLine(AtTop,AtBottom: boolean; NowTop,cw1,cw2,cw3,cw4: integer; col1,col2,col3,col4: string);
    
    procedure ExportNow;
    procedure ExportList_Detail(FileName: string);
    procedure ExportList_Simple(FileName: string);
    procedure ExportReport(FileName,PeoName: string);
    procedure LoadPrintSet;
    { Public declarations }
  end;

{
  TOjBitmap=class(TBitmap)
    Next,Previous: TOjBitmap;
  end;

  TBitmapList=class
  private
    First,Last: TOjBitmap;
  public
    function Add: TOjBitmap;

  end;
}

var
  PrintForm: TPrintForm;
  BitmapList: TList;

implementation

uses MainFormU, PrintSetU;

const
  Remark: array[0..16]of char=
  (' ',' ','R','T','M','Y','B','A','W','P','*',' ','[',']','?','^','-');
  VeryThickLineWidth=6;
  ThickLineWidth=5;
  ThinLineWidth=1;
  BrokenLineWidth=4;
  LeftFormat=DT_LEFT or DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or DT_END_ELLIPSIS;
  RightFormat=DT_RIGHT or DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or DT_END_ELLIPSIS;
  TableFormat=DT_CENTER or DT_SINGLELINE or DT_VCENTER or DT_NOPREFIX or DT_END_ELLIPSIS;

var
  MyCanvas: TCanvas;
  EditBitmap: TBitmap;
  PEmpty,PLeft,PRight,PUp,PDown,PHeight,CharHeight: integer;
  UseBitmap: boolean;
  Footer: string;

{$R *.dfm}

procedure TPrintForm.FormShow(Sender: TObject);
var
  i: integer;
begin
  Application.CreateForm(TPrintSetForm,PrintSetForm);
// 计算最大号字体
  PrintSetForm.FontDlg.Font.Name:='Courier New';
  PrintSetForm.FontDlg.Font.Size:=10;
{
  PrintSetForm.RadioButton3.Caption:=DateTimeToStr(Now);
  PrintSetForm.RadioButton4.Caption:='--'+Judge.Contest.Title+'---'+Judge.Contest.Juror+'--';
}
  PrintForm.RadioButton2Click(nil);
  PrintSetForm.RadioButton3Click(nil);


  for i:=0 to MainForm.lv1.Items.Count-1 do if TPeople(MainForm.lv1.Items.Item[i].Data).HasResult then
    with lv1.Items.Add do begin
      Caption:=MainForm.lv1.Items.Item[i].Caption;
      SubItems.Add(MainForm.lv1.Items.Item[i].SubItems[0]);
      SubItems.Add(MainForm.lv1.Items.Item[i].SubItems[1]);
      SubItems.Add(MainForm.lv1.Items.Item[i].SubItems[2]);
    end;
end;

procedure TPrintForm.RadioButton2Click(Sender: TObject);
begin
  if RadioButton2.Checked then begin
    RadioButton7.Caption:=_('&Crowd Style');
    RadioButton8.Caption:=_('&Detailed Style');
  end else begin
    RadioButton7.Caption:=_('&Crowd Style');
    RadioButton8.Caption:=_('&Simple Style');
  end;
end;

procedure TPrintForm.PrintNow;
var
  i: integer;
begin
  if RadioButton1.Checked then // 打印排名表
    if RadioButton7.Checked then begin
      lv1.SelectAll;
      PrintList_Detail;                                  // 紧凑型 包括每个测试点的结果，但都在同一行
    end else begin
      lv1.SelectAll;
      PrintList_Simple;                                  // 简单型 只有排名、总分和有效用时
    end
  else                         // 打印成绩单
    if RadioButton7.Checked then
      PrintList_Detail                            // 紧凑型 包括每个测试点的结果，但都在同一行
    else
      for i:=0 to lv1.Items.Count-1 do
        if lv1.Items.Item[i].Selected then
          PrintReport(lv1.Items.Item[i].Caption); // 详细型 一道题一个表格
end;

procedure TPrintForm.Button1Click(Sender: TObject);
begin
  if printer.Printers.Count=0 then
    MessageBoxW(Handle,pwidechar(_('No Printers Installed.')),pwidechar(_('Error')),MB_ICONERROR)
  else
    if (RadioButton1.Checked=false) and (lv1.SelCount=0) then
      MessageBoxW(Handle,pwidechar(_('No Selected Contestants.')),pwidechar(_('Error')),MB_ICONERROR)
    else begin
      screen.Cursor:=crHourGlass;
      Printer.BeginDoc;
      MyCanvas:=printer.Canvas;
      UseBitmap:=false;
      PrintNow;
      Printer.EndDoc;
      screen.Cursor:=crDefault;
    end;
end;

function GetReport(Name: string;  mid: char): string;
var
  p: TPeopleResult;
  i,j: integer;
begin
  p:=TPeopleResult.Create;
  p.Load(Name);
  Result:='';
  for i:=0 to p.ProblemResults.Count-1 do begin
    for j:=0 to p.ProblemResults.Items[i].TestCaseResults.Count-1 do
      with p.ProblemResults.Items[i].TestCaseResults.Items[j] do
        Result:=Result+Remark[Status];
    Result:=Result+mid;
  end;
  Result:=Result+FloatToStr(p.Score);
  p.Destroy;
end;

function MakeFooterForPrint: string;
var
  i: integer;
  this,thisline: string;
begin
  Result:='';
  thisline:='备注：';
  for i:=0 to 16 do if Remark[i]<>' ' then begin
    this:=Remark[i]+'='+ResultRemark[i];
    if i<16 then this:=this+' ';
    if MyCanvas.TextWidth(thisline+this)>Printer.PageWidth-PRight-PLeft-40 then begin
      Result:=Result+thisline+#13#10;
      thisline:='      ';
    end;
    thisline:=thisline+this;
  end;
  if thisline[Length(thisline)]<>' ' then Result:=Result+thisline;
end;

function MakeFooterForExport: string;
var
  i: integer;
begin
  Result:='';
  for i:=0 to 16 do if Remark[i]<>' ' then begin
    Result:=Result+Remark[i]+'='+ResultRemark[i];
    if i<16 then Result:=Result+#13#10;
  end;
end;


function LinesCount(s: string): integer;
var
  i: integer;
begin
  Result:=1;
  while pos(#13#10,s)>0 do begin 
    i:=pos(#13#10,s);
    Delete(s,1,i+1);
    inc(Result);
  end;
end;

function FirstLine(s: string): string;
var
  j: integer;
begin
  j:=pos(#13#10,s);
  if j=0 then j:=Length(s)+1;
  Result:=copy(s,1,j-1);
end;

procedure DeleteFirstLine(var s: string);
var
  j: integer;
begin
  j:=pos(#13#10,s);
  if j=0 then j:=Length(s)-1;
  Delete(s,1,j+1);
end;

procedure PrintFooter(NowTop: integer);
var
  t: string;
  j: integer;
  Rects: TRect;
begin
  t:=Footer;
  for j:=1 to LinesCount(Footer) do begin
    Rects.Top:=NowTop+(PEmpty+CharHeight)*(j-1);
    Rects.Left:=PLeft;
    Rects.Right:=Printer.PageWidth-PRight;
    Rects.Bottom:=NowTop+(PEmpty+CharHeight)*j;
    DrawText(Printer.Handle,pchar(FirstLine(t)),Length(FirstLine(t)),Rects,LeftFormat);
    DeleteFirstLine(t);
  end;
end;

procedure CanvasNewPage(Top: integer;  DrawLine,DrawFooter,NewPage: boolean);
begin
  if Top=0 then Top:=Printer.PageHeight-PDown;
  if DrawLine then begin
    MyCanvas.Pen.Width:=VeryThickLineWidth;
    MyCanvas.MoveTo(PLeft,Top);
    MyCanvas.LineTo(Printer.PageWidth-PRight,Top);
  end;
  if DrawFooter then PrintFooter(Top);
  if UseBitmap then begin
    BitmapList.Add(EditBitmap);
    EditBitmap:=TBitmap.Create;
    EditBitmap.Height:=printer.PageHeight;
    EditBitmap.Width:=printer.PageWidth;
  end
  else
    if NewPage then Printer.NewPage;
end;

procedure TPrintForm.PrintList_Detail;  // 紧凑型 包括每个测试点的结果
var
  i,t,NowTop,NameW: integer;
  report,pname: string;
  Rects: TRect;
begin
  if lv1.Items.Count=0 then exit;
  LoadPrintSet;
  Footer:=MakeFooterForPrint;

  CharHeight:=MyCanvas.TextHeight('测');
  PHeight:=CharHeight+PEmpty*2;
  PDown:=(CharHeight+PEmpty)*LinesCount(Footer)+PEmpty;

  NameW:=0;
  for i:=0 to lv1.Items.Count-1 do if lv1.Items.Item[i].Selected then
    if MyCanvas.TextWidth(lv1.Items.Item[i].Caption+' ')>NameW then
      NameW:=MyCanvas.TextWidth(lv1.Items.Item[i].Caption+' ');
  for i:=0 to lv1.Items.Count-1 do if lv1.Items.Item[i].Selected then begin
    t:=MyCanvas.TextWidth(GetReport(lv1.Items.Item[i].Caption,' ')+' ');
    if Printer.PageWidth-PLeft-PRight-t<0 then begin
      MessageBox(self.Handle,'字体太大，选手名称显示不出来。','错误',MB_OK);
      exit;
    end;
    if Printer.PageWidth-PLeft-PRight-t<NameW then NameW:=Printer.PageWidth-PLeft-PRight-t;
  end;

  NowTop:=0;
  for i:=0 to lv1.Items.Count-1 do if lv1.Items.Item[i].Selected then begin
    if lv1.Items.Count-1=i then begin
      NowTop:=NowTop;
    end;
    if printer.PageHeight-NowTop-PDown<PHeight then begin
      CanvasNewPage(NowTop,false,true,true);
      NowTop:=0;
    end;
    pname:=lv1.Items.Item[i].Caption;
    report:=GetReport(lv1.Items.Item[i].Caption,' ');

    Rects.Top:=NowTop;
    Rects.Left:=PLeft;
    Rects.Right:=PLeft+NameW;
    Rects.Bottom:=NowTop+PHeight;
    DrawText(MyCanvas.Handle,pchar(pname),Length(pname),Rects,LeftFormat);

    Rects.Top:=NowTop;
    Rects.Left:=PLeft+NameW;
    Rects.Right:=Printer.PageWidth-PRight;
    Rects.Bottom:=NowTop+PHeight;
    DrawText(MyCanvas.Handle,pchar(report),Length(report),Rects,LeftFormat);

//    MyCanvas.TextOut(PLeft+NameW,NowTop+PEmpty,report);

    MyCanvas.Pen.Style:=psDashDot;
    MyCanvas.Pen.Width:=BrokenLineWidth;
    MyCanvas.MoveTo(0,NowTop+PHeight);
    MyCanvas.LineTo(Printer.PageWidth,NowTop+PHeight);
    MyCanvas.Pen.Style:=psSolid;
    inc(NowTop,PHeight);
  end;
  CanvasNewPage(NowTop,false,true,false);
end;



procedure TPrintForm.PrintList_Simple; // 简单型 只有排名、总分和有效用时
var
  i,NowTop,t,many: integer;
  NameW,OrderW,ScoreW,TimeW: integer;
begin
  LoadPrintSet;
  if PrintSetForm.RadioButton3.Checked then Footer:=DateTimeToStr(Now);
  if PrintSetForm.RadioButton4.Checked then Footer:=Judge.Contest.Title;
  if PrintSetForm.RadioButton5.Checked then Footer:=PrintSetForm.Edit5.Text;


  CharHeight:=MyCanvas.TextHeight('测');

  PHeight:=CharHeight+PEmpty*2;
  many:=trunc((printer.PageHeight-PUp-PDown)/PHeight);
  PHeight:=(printer.PageHeight-PUp-PDown)div many;
  PEmpty:=(PHeight-CharHeight)div 2;

  NameW:=MyCanvas.TextWidth('选手名称  ');
  OrderW:=MyCanvas.TextWidth('排名  ');;
  ScoreW:=MyCanvas.TextWidth('总得分  ');;
  TimeW:=MyCanvas.TextWidth('有效用时  ');;
  for i:=0 to lv1.Items.Count-1 do if lv1.Items.Item[i].Selected then begin
    if MyCanvas.TextWidth(lv1.Items.Item[i].Caption)>NameW then
      NameW:=MyCanvas.TextWidth(lv1.Items.Item[i].Caption+'  ');
    if MyCanvas.TextWidth(lv1.Items.Item[i].SubItems[0])>OrderW then
      OrderW:=MyCanvas.TextWidth(lv1.Items.Item[i].SubItems[0]+'  ');
    if MyCanvas.TextWidth(lv1.Items.Item[i].SubItems[1])>ScoreW then
      ScoreW:=MyCanvas.TextWidth(lv1.Items.Item[i].SubItems[1]+'  ');
    if MyCanvas.TextWidth(lv1.Items.Item[i].SubItems[2])>TimeW then
      TimeW:=MyCanvas.TextWidth(lv1.Items.Item[i].SubItems[2]+'  ');
  end;
  t:=NameW+OrderW+ScoreW+TimeW;
  if t>printer.PageWidth-PLeft-PRight then begin
    NameW:=NameW-(t-(printer.PageWidth-PLeft-PRight));
    t:=NameW+OrderW+ScoreW+TimeW;
  end;
  NameW :=trunc( NameW*(printer.PageWidth-PLeft-PRight)/t);
  OrderW:=trunc(OrderW*(printer.PageWidth-PLeft-PRight)/t);
  ScoreW:=trunc(ScoreW*(printer.PageWidth-PLeft-PRight)/t);
  TimeW :=trunc( TimeW*(printer.PageWidth-PLeft-PRight)/t);

  NowTop:=0;
  for i:=0 to lv1.Items.Count-1 do if lv1.Items.Item[i].Selected then begin
    if NowTop=0 then begin
      DrawTableLine(true,false,PUp,NameW,OrderW,ScoreW,TimeW,'选手名称','排名','总得分','有效用时');
      NowTop:=PUp+PHeight;
    end;

    with lv1.Items.Item[i] do 
      DrawTableLine(false,false,NowTop,NameW,OrderW,ScoreW,TimeW,Caption,SubItems[0],SubItems[1],SubItems[2]);
    inc(NowTop,PHeight);

    if Printer.PageHeight-NowTop-PHeight<PDown then begin
      MyCanvas.Pen.Width:=ThickLineWidth;
      MyCanvas.MoveTo(PLeft,NowTop);
      MyCanvas.LineTo(printer.PageWidth-PRight,NowTop);
      NowTop:=0;
      CanvasNewPage(NowTop,false,true,true);
    end;
  end;
  if NowTop>0 then begin
    MyCanvas.Pen.Width:=ThickLineWidth;
    MyCanvas.MoveTo(PLeft,NowTop);
    MyCanvas.LineTo(printer.PageWidth-PRight,NowTop);
    CanvasNewPage(NowTop,false,true,false);
  end;
end;

procedure TPrintForm.DrawTableLine(AtTop,AtBottom: boolean; NowTop,cw1,cw2,cw3,cw4: integer; col1,col2,col3,col4: string);
var
  Rects: TRect;
begin
  MyCanvas.Pen.Width:=ThinLineWidth;
  MyCanvas.Rectangle(PLeft,NowTop,printer.PageWidth-PRight,NowTop+PHeight);
  MyCanvas.MoveTo(PLeft+cw1,NowTop);
  MyCanvas.LineTo(PLeft+cw1,NowTop+PHeight);
  MyCanvas.MoveTo(PLeft+cw1+cw2,NowTop);
  MyCanvas.LineTo(PLeft+cw1+cw2,NowTop+PHeight);
  MyCanvas.MoveTo(PLeft+cw1+cw2+cw3,NowTop);
  MyCanvas.LineTo(PLeft+cw1+cw2+cw3,NowTop+PHeight);

  MyCanvas.Pen.Width:=ThickLineWidth;
  MyCanvas.MoveTo(PLeft,NowTop);
  MyCanvas.LineTo(PLeft,NowTop+PHeight);
  MyCanvas.MoveTo(Printer.PageWidth-PRight,NowTop);
  MyCanvas.LineTo(Printer.PageWidth-PRight,NowTop+PHeight);
  if AtTop then begin
    MyCanvas.MoveTo(PLeft,NowTop);
    MyCanvas.LineTo(Printer.PageWidth-PRight,NowTop);
  end;
  if AtBottom then begin
    MyCanvas.MoveTo(PLeft,NowTop+PHeight);
    MyCanvas.LineTo(Printer.PageWidth-PRight,NowTop+PHeight);
  end;

  Rects.Top:=NowTop;
  Rects.Bottom:=NowTop+PHeight;

  Rects.Left:=PLeft+20;
  Rects.Right:=PLeft+cw1-20;
  DrawText(MyCanvas.Handle,pchar(col1),Length(col1),Rects,TableFormat);

  inc(Rects.Left,cw1);
  inc(Rects.Right,cw2);
  DrawText(MyCanvas.Handle,pchar(col2),Length(col2),Rects,TableFormat);

  inc(Rects.Left,cw2);
  inc(Rects.Right,cw3);
  DrawText(MyCanvas.Handle,pchar(col3),Length(col3),Rects,TableFormat);

  inc(Rects.Left,cw3);
  inc(Rects.Right,cw4);
  DrawText(MyCanvas.Handle,pchar(col4),Length(col4),Rects,TableFormat);
end;


procedure TPrintForm.PrintReport(PeoName: string); // 详细型 一道题一个表格
var
  i,j,NowTop,t,last: integer;
  NameW,OrderW,ResultW,ScoreW,TimeW: integer;
  Rects: TRect;
  ThisLine: string;
  p: TPeopleResult;
  PageCount: integer;

  procedure PrintTitle;
  begin
    NameW:=MyCanvas.TextWidth('名称：'+PeoName);
    ThisLine:=Format('    总得分：%f    有效用时：%f    第%d页',[p.Score,p.Time,PageCount]);
    if Printer.PageWidth-PLeft-PRight-MyCanvas.TextWidth(ThisLine)<NameW then
      NameW:=Printer.PageWidth-PLeft-PRight-MyCanvas.TextWidth(ThisLine);
    Rects.Top   :=PUp;
    Rects.Bottom:=PUp+PHeight;
    Rects.Left  :=PLeft;
    Rects.Right :=PLeft+NameW;
    DrawText(MyCanvas.Handle,pchar('名称：'+PeoName),Length('名称：'+PeoName),Rects,LeftFormat);
    Rects.Left  :=PLeft+NameW;
    Rects.Right :=Printer.PageWidth-PRight;
    DrawText(MyCanvas.Handle,pchar(ThisLine),Length(ThisLine),Rects,RightFormat);
    MyCanvas.Pen.Width:=VeryThickLineWidth;
    MyCanvas.MoveTo(PLeft,PUp+PHeight);
    MyCanvas.LineTo(printer.PageWidth-PRight,PUp+PHeight);
    NowTop:=PUp+PHeight+PEmpty;
  end;

begin
  LoadPrintSet;
  if PrintSetForm.RadioButton3.Checked then Footer:=DateTimeToStr(Now);
  if PrintSetForm.RadioButton4.Checked then Footer:=Judge.Contest.Title;
  if PrintSetForm.RadioButton5.Checked then Footer:=PrintSetForm.Edit5.Text;

  CharHeight:=MyCanvas.TextHeight('测');
  PHeight:=CharHeight+PEmpty*2;

  OrderW:=MyCanvas.TextWidth('编号 ');
  ResultW:=MyCanvas.TextWidth('结果            ');                               
  ScoreW:=MyCanvas.TextWidth('得分 ');
  TimeW:=MyCanvas.TextWidth('有效用时');
  t:=OrderW+ResultW+ScoreW+TimeW;
  OrderW :=trunc( OrderW*(printer.PageWidth-PLeft-PRight)/t);
  ResultW:=trunc(ResultW*(printer.PageWidth-PLeft-PRight)/t);
  ScoreW :=trunc( ScoreW*(printer.PageWidth-PLeft-PRight)/t);
  TimeW  :=trunc(  TimeW*(printer.PageWidth-PLeft-PRight)/t);

  PageCount:=1;

  p:=TPeopleResult.Create;
  p.Load(PeoName);

  PrintTitle;

  for i:=0 to p.ProblemResults.Count-1 do with p.ProblemResults.Items[i] do begin
    if NowTop+PHeight+PDown>printer.PageHeight then begin
      CanvasNewPage(0,true,true,true);
      NowTop:=PUp;   // 万一 PUp+PDown+PHeight>printer.PageHeight 呢？
      inc(PageCount);
      PrintTitle;
    end;
    ThisLine:=Format('标题：%s   文件名：%s',[p.ProblemResults.Items[i].Title,p.ProblemResults.Items[i].FileName]);
    Rects.Left  :=PLeft;
    Rects.Top   :=NowTop;
    Rects.Right :=Printer.PageWidth-PRight;
    Rects.Bottom:=NowTop+PHeight;
    DrawText(MyCanvas.Handle,pchar(ThisLine),Length(ThisLine),Rects,LeftFormat);
    inc(NowTop,PHeight);

    if (Status=ST_NO_SOURCE_FILE) or (Status=ST_COMPILATION_ERROR) then begin
      if NowTop+PHeight*2+PDown>printer.PageHeight then begin
        CanvasNewPage(0,true,true,true);
        NowTop:=PUp;   // 万一 PUp+PDown+PHeight>printer.PageHeight 呢？
        inc(PageCount);
        PrintTitle;
      end;

      ThisLine:=ResultRemark[Status];
      Rects.Left  :=PLeft;
      Rects.Top   :=NowTop;
      Rects.Right :=Printer.PageWidth-PRight;
      Rects.Bottom:=NowTop+PHeight;
      DrawText(MyCanvas.Handle,pchar(ThisLine),Length(ThisLine),Rects,LeftFormat);
      inc(NowTop,PHeight);

    end
    else begin

      if NowTop+PHeight+PDown>printer.PageHeight then begin
        CanvasNewPage(0,true,true,true);
        NowTop:=PUp;   // 万一 PUp+PDown+PHeight>printer.PageHeight 呢？
        inc(PageCount);
        PrintTitle;
      end;

      DrawTableLine(true,false,NowTop,OrderW,ResultW,ScoreW,TimeW,'编号','结果','得分','有效用时');
      inc(NowTop,PHeight);

      for j:=0 to p.ProblemResults.Items[i].TestCaseResults.Count-1 do begin
        last:=NowTop+PHeight+PDown;
        if j=p.ProblemResults.Items[i].TestCaseResults.Count-1 then inc(last,PHeight);
        if last>Printer.PageHeight then begin
          CanvasNewPage(0,true,true,true);
          NowTop:=PUp;
          inc(PageCount);
          PrintTitle;
        end;

        if TestCaseResults.Items[j].Status=ST_RUNTIME_ERROR then
          DrawTableLine(false,(j=p.ProblemResults.Items[i].TestCaseResults.Count-1),
          NowTop,OrderW,ResultW,ScoreW,TimeW,
          IntToStr(j+1),
          ResultRemark[TestCaseResults.Items[j].Status]+' '+IntToStr(TestCaseResults.Items[j].ExitCode),
          FloatToStr(TestCaseResults.Items[j].Score),
          Format('%f',[TestCaseResults.Items[j].Time])
          )
        else
          DrawTableLine(false,(j=p.ProblemResults.Items[i].TestCaseResults.Count-1),
          NowTop,OrderW,ResultW,ScoreW,TimeW,
          IntToStr(j+1),
          ResultRemark[TestCaseResults.Items[j].Status],
          FloatToStr(TestCaseResults.Items[j].Score),
          Format('%f',[TestCaseResults.Items[j].Time])
          );
        inc(NowTop,PHeight);
      end;
    end;

    ThisLine:='总分：'+FloatToStr(Score)+Format('    有效用时：%f',[Time]);
    Rects.Left  :=PLeft;
    Rects.Top   :=NowTop;
    Rects.Right :=Printer.PageWidth-PRight;
    Rects.Bottom:=NowTop+PHeight;
    DrawText(MyCanvas.Handle,pchar(ThisLine),Length(ThisLine),Rects,LeftFormat);
    inc(NowTop,PHeight);

    if (NowTop+PEmpty*2+PHeight+PDown<=Printer.PageHeight)and(i<p.ProblemResults.Count-1) then begin
      MyCanvas.Pen.Width:=ThickLineWidth;
      MyCanvas.MoveTo(PLeft,NowTop+PEmpty);
      MyCanvas.LineTo(printer.PageWidth-PRight,NowTop+PEmpty);
    end;
    inc(NowTop,PEmpty*2);
  end;
  CanvasNewPage(0,true,true,false);

  p.Destroy;
end;


procedure TPrintForm.Button4Click(Sender: TObject);
{var
  i: integer;}
begin
 { EditBitmap:=TBitmap.Create;
  EditBitmap.Height:=printer.PageHeight;
  EditBitmap.Width:=printer.PageWidth;
  BitmapList:=TList.Create;

  MyCanvas:=EditBitmap.Canvas;
  UseBitmap:=true;
  PrintNow;
  // show it
  PreViewForm:=TPreViewForm.Create(self);
  PreViewForm.ShowModal;
  PreViewForm.Close;
  EditBitmap.Destroy;
  for i:=0 to BitmapList.Count-1 do
    TBitmap(BitmapList.Items[i]).Destroy;
  BitmapList.Destroy;  }
end;

procedure TPrintForm.N1Click(Sender: TObject);
begin
  lv1.SelectAll;
end;

procedure TPrintForm.B1Click(Sender: TObject);
var
  i: integer;
begin
  for i:=0 to lv1.Items.Count-1 do
    lv1.Items.Item[i].Selected:=not lv1.Items.Item[i].Selected;
end;

procedure TPrintForm.Button6Click(Sender: TObject);
begin
  ExportNow;
end;

function AskFileName(DefaultPath,DefaultFileName: string): string;
begin
  PrintForm.SaveDlg.InitialDir:=DefaultPath;
  PrintForm.SaveDlg.FileName:=DefaultFileName;
  if PrintForm.SaveDlg.Execute then
    Result:=PrintForm.SaveDlg.FileName
  else
    Result:='';
end;

function AskDir(DefaultPath: string): string;  // end with '\'
begin
  Result:=BrowseforFile(PrintForm.Handle,'您选择了多个选手，请选择导出的文件存放的文件夹。','',DefaultPath);
end;

procedure TPrintForm.ExportNow;
var
  i: integer;
  Path: string;
begin
  if RadioButton1.Checked then begin // 排名表
    Path:=AskFileName(judge.Contest.Path,judge.Contest.Title);
    if Path='' then exit;
    if RadioButton7.Checked then begin
      lv1.SelectAll;
      ExportList_Detail(Path);                                  // 紧凑型 包括每个测试点的结果，但都在同一行
    end else begin
      lv1.SelectAll;
      ExportList_Simple(Path);                                  // 简单型 只有排名、总分和有效用时
    end;
  end else                           // 成绩单
    if RadioButton8.Checked then begin
      if lv1.SelCount=0 then exit;
      if lv1.SelCount=1 then begin
        Path:=AskFileName(judge.Contest.Path,lv1.Selected.Caption);
        if Path='' then exit;
        ExportReport(Path,lv1.Selected.Caption); // 详细型 一道题一个表格
      end else begin
        Path:=AskDir(judge.Contest.Path);
        if Path='' then exit;
        for i:=0 to lv1.Items.Count-1 do
          if lv1.Items.Item[i].Selected then
            ExportReport(Path+'\'+lv1.Items.Item[i].Caption+'.csv',lv1.Items.Item[i].Caption); // 详细型 一道题一个表格
      end;
    end else begin
      Path:=AskFileName(judge.Contest.Path,judge.Contest.Title);
      if Path='' then exit;
      ExportList_Detail(Path); 
    end;
end;

function WritelnStr(f: cardinal;  s: string): boolean;
var
  mapi: cardinal;
begin
  s:=s+#13#10;
  Result:=WriteFile(f,s[1],Length(s),mapi,nil);
end;

function Check(s: string): string;
var
  i: integer;
begin
  for i:=Length(s) downto 1 do
    if s[i]='"' then s:=copy(s,1,i)+'"'+copy(s,i+1,Length(s)-i);
  s:='"'+s+'"';
  Result:=s;
end;

procedure TPrintForm.ExportList_Detail(FileName: string);
var
  i: integer;
  f: cardinal;
  pname: string;
begin
  f:=CreateFile(Pchar(FileName),GENERIC_WRITE,FILE_SHARE_WRITE,nil,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0);
  for i:=0 to lv1.Items.Count-1 do if lv1.Items.Item[i].Selected then begin
    pname:=lv1.Items.Item[i].Caption;
    WritelnStr(f,Check(pname)+','+GetReport(pname,','));
  end;
  WritelnStr(f,'');
  WritelnStr(f,Check(MakeFooterForExport));
  CloseHandle(f);
end;

procedure TPrintForm.ExportList_Simple(FileName: string);
var
  i: integer;
  f: cardinal;
begin
  f:=CreateFile(Pchar(FileName),GENERIC_WRITE,FILE_SHARE_WRITE,nil,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0);
  if judge.Contest.Title<>'' then WritelnStr(f,Check(judge.Contest.Title));
  if judge.Contest.Juror<>'' then WritelnStr(f,Check(judge.Contest.Juror));
  WritelnStr(f,'');
  WritelnStr(f,'名称,排名,总得分,有效用时');
  for i:=0 to lv1.Items.Count-1 do if lv1.Items.Item[i].Selected then begin
    with lv1.Items.Item[i] do
      WritelnStr(f,Check(Caption)+','+SubItems[0]+','+SubItems[1]+','+SubItems[2]);
  end;
  WritelnStr(f,'');
  WritelnStr(f,Check(' '+DateTimeToStr(Now)));
  CloseHandle(f);
end;

procedure TPrintForm.ExportReport(FileName,PeoName: string);
var
  i,j: integer;
  f: cardinal;
  p: TPeopleResult;
begin
  f:=CreateFile(Pchar(FileName),GENERIC_WRITE,FILE_SHARE_WRITE,nil,CREATE_ALWAYS,FILE_ATTRIBUTE_ARCHIVE,0);
  p:=TpeopleResult.Create;
  p.Load(PeoName);

  if judge.Contest.Title<>'' then WritelnStr(f,Check(judge.Contest.Title));
  if judge.Contest.Juror<>'' then WritelnStr(f,Check(judge.Contest.Juror));
  WritelnStr(f,'');
  WritelnStr(f,Check('名称：'+PeoName));
  WritelnStr(f,'总得分：'+FloatToStr(p.Score));
  WritelnStr(f,'有效用时：'+Format('%f',[p.Time]));
  WritelnStr(f,'');

  for i:=0 to p.ProblemResults.Count-1 do begin
    WritelnStr(f,'');
    WritelnStr(f,'');
    WritelnStr(f,Check('标题：'+p.ProblemResults.Items[i].Title));
    WritelnStr(f,Check('文件名：'+p.ProblemResults.Items[i].FileName));

    WritelnStr(f,'');
    WritelnStr(f,'编号,结果,得分,有效用时');
    for j:=0 to p.ProblemResults.Items[i].TestCaseResults.Count-1 do begin
      with p.ProblemResults.Items[i].TestCaseResults.Items[j] do
        if Status=ST_RUNTIME_ERROR then
          WritelnStr(f,IntToStr(j+1)+','+ResultRemark[Status]+' '+IntToStr(ExitCode)+','+FloatToStr(Score)+','+Format('%f',[Time]))
        else
          WritelnStr(f,IntToStr(j+1)+','+ResultRemark[Status]+','+FloatToStr(Score)+','+Format('%f',[Time]));
    end;
    WritelnStr(f,'');
    WritelnStr(f,'总分：'+FloatToStr(p.ProblemResults.Items[i].Score));
    WritelnStr(f,'有效用时：'+Format('%f',[p.ProblemResults.Items[i].Time]));
    WritelnStr(f,'');
  end;
  WritelnStr(f,Check(' '+DateTimeToStr(Now)));
  CloseHandle(f);
end;

procedure TPrintForm.LoadPrintSet;
begin
  MyCanvas.Font.Name:=PrintSetForm.FontDlg.Font.Name;
  MyCanvas.Font.Size:=PrintSetForm.FontDlg.Font.Size;
  PEmpty:=40;
  PLeft :=PrintSetForm.SpinEdit2.Value;
  PRight:=PrintSetForm.SpinEdit3.Value;
  PUp   :=PrintSetForm.SpinEdit1.Value;
  PDown :=PrintSetForm.SpinEdit4.Value;
end;

procedure TPrintForm.Button3Click(Sender: TObject);
begin
  PrintSetForm.ShowModal;
end;

procedure TPrintForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

procedure TPrintForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  PrintSetForm.Destroy;
end;

procedure TPrintForm.Button2Click(Sender: TObject);
begin
  Close;
end;

end.

