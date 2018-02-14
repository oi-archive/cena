unit ResultFormU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, StdCtrls, ExtCtrls, Buttons, OleCtrls, SHDocVw,
  ojtc, ojrc, ojconst, AppEvnts, commctrl, mshtml, activex, mytypes,
  jvgnugettext, ojwin32;

type
  TResultForm = class(TForm)
    PopupMenu1: TPopupMenu;
    E1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    wb: TWebBrowser;
    ApplicationEvents1: TApplicationEvents;
    Label1: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure wbBeforeNavigate2(Sender: TObject; const pDisp: IDispatch;
      var URL, Flags, TargetFrameName, PostData, Headers: OleVariant;
      var Cancel: WordBool);
    procedure ApplicationEvents1Message(var Msg: tagMSG;
      var Handled: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure E1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    PeopleName:string;
    ListItem:TListItem;
    ppr:TPeopleResult;
    procedure CreateParams(var Params: TCreateParams); override;
  published
    procedure LoadResult(ppr: TPeopleResult);
  end;

var
  ResultForm: TResultForm;
  HookID: THandle;

implementation

uses JudgeThreadU, MainFormU;

{$R *.dfm}



const 
  TTS_BALLOON    = $40;
  TTM_SETTITLE = (WM_USER + 32);

var 
  hTooltip: Cardinal; 
  ti: TToolInfo; 
  buffer : array[0..255] of char;   


procedure TResultForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if TPeople(ListItem.Data).Status<>PS_JUDGING then
    ppr.Destroy;
  TPeople(ListItem.Data).ResultWnd:=nil;
  Action:=caFree;
end;

function hs(x:integer):string;
var
  i:integer;
begin
  result:='';
  for i:=1 to x do
    result:=result+'&nbsp;';
end;

procedure TResultForm.FormShow(Sender: TObject);
begin
  ppr:=TPeopleResult.Create;
  ppr.Load(PeopleName);
  LoadResult(ppr);
end;

procedure TResultForm.FormResize(Sender: TObject);
begin
  wb.Width:=ClientWidth;
  wb.Height:=ClientHeight;
end;

procedure CreateToolTips(hWnd: Cardinal); 
begin
  hToolTip := CreateWindowEx(0, 'Tooltips_Class32', nil, TTS_ALWAYSTIP or TTS_BALLOON, 
    Integer(CW_USEDEFAULT), Integer(CW_USEDEFAULT), Integer(CW_USEDEFAULT), 
    Integer(CW_USEDEFAULT), hWnd, 0, hInstance, nil); 
  if hToolTip <> 0 then 
  begin 
    SetWindowPos(hToolTip, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOMOVE or 
      SWP_NOSIZE or SWP_NOACTIVATE); 
    ti.cbSize := SizeOf(TToolInfo); 
    ti.uFlags := TTF_SUBCLASS; 
    ti.hInst  := hInstance; 
  end; 
end;

procedure AddToolTip(hwnd: DWORD; lpti: PToolInfo; IconType: Integer; 
  Text, Title: PChar); 
var 
  Item: THandle; 
  Rect: TRect; 
begin 
  Item := hWnd; 
  if (Item <> 0) and (GetClientRect(Item, Rect)) then 
  begin 
    lpti.hwnd := Item; 
    lpti.Rect := Rect; 
    lpti.lpszText := Text; 
    SendMessage(hToolTip, TTM_ADDTOOL, 0, Integer(lpti));
    FillChar(buffer, SizeOf(buffer), #0); 
    lstrcpy(buffer, Title); 
    if (IconType > 3) or (IconType < 0) then IconType := 0; 
    SendMessage(hToolTip, TTM_SETTITLE, IconType, Integer(@buffer)); 
  end;
end;

procedure TResultForm.wbBeforeNavigate2(Sender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
var
  s:widestring;
  p,t: integer;
  People: TPeople;
  Task: TTask;
begin
  s:=url;
  if s='about:blank' then
    exit;
  if copy(s,1,6)='about:' then begin
    case s[7] of
      't':       // about:t/1/2/
        begin
          s:=copy(s,9,maxint);
          p:=strtoint(copy(s,1,pos('/',s)-1));
          s:=copy(s,pos('/',s)+1,maxint);
          t:=strtoint(copy(s,1,pos('/',s)-1));
          MessageBox(Handle,
            @ppr.ProblemResults.Items[p].TestCaseResults.Items[t].Detail[1],
            '详细信息',
            MB_ICONINFORMATION);
        end;
      'r':      //  about:r/1/
        begin
          s:=copy(s,9,maxint);
          p:=strtoint(copy(s,1,pos('/',s)-1));
          People:=Judge.Contest.Peoples.FindName(PeopleName);
          if People<>nil then begin
            Task:=TTask.Create;
            Task.People:=People;
            Task.ProblemID:=p;
            Task.OnlyJudgeChanged:=false;
            TaskQueue.Add(Task);
            if JudgeThread.Suspended then
              JudgeThread.Resume;
          end;
        end;
      'c':      //   about:c/1/
        begin
          s:=copy(s,9,maxint);
          p:=strtoint(copy(s,1,pos('/',s)-1));
          MessageBoxW(Handle, PWideChar(ppr.ProblemResults.Items[p].Detail), PWideChar(_('编译信息')), 0); 
        end;
      'q':
        begin
          Close;
        end;  
    end;
    cancel:=true;
  end;
end;

procedure TResultForm.ApplicationEvents1Message(var Msg: tagMSG;
  var Handled: Boolean);
var
  p: TPoint;
begin
  case msg.message of
    WM_RBUTTONDOWN, WM_RBUTTONDBLCLK, WM_RBUTTONUP, WM_MOUSEMOVE, WM_LBUTTONDBLCLK,
    WM_KEYDOWN, WM_SETCURSOR, 257, 280, 123:
      begin
        if GetParent(GetParent(GetParent(msg.hwnd)))=Handle then begin
          handled:=true;
          case msg.message of
            WM_RBUTTONUP, 123:
              begin
                GetCursorPos(p);
                popupmenu1.Popup(p.X,p.Y);
              end;
          end;
        end;
      end;
    WM_LBUTTONUP:;
  end;
end;

procedure TResultForm.LoadResult(ppr: TPeopleResult);
var
  s:string;
  i,j:integer;
  f:textfile;
  sl: TStringList;
  ms: TMemoryStream;



procedure write(var f:textfile;x:string);
begin
  s:=s+x;
end;



begin
  write(f,'<!DOCTYPE html>');
  write(f,'<html><head>');
  write(f,'<meta http-equiv="Content-Type" content="text/html; charset=gb2312">');
  write(f,'<style>a { color: #55f; text-decoration: none } body { font-family: Consolas,Lucida Console, Courier New,"宋体",sans-serif; cursor:default }</style>');
  write(f,'</head><body>');
  for i:=0 to ppr.ProblemResults.Count-1 do
    with ppr.ProblemResults.Items[i] do begin
      write(f,'<table border="0" width="100%" id="table2" cellpadding="0" cellspacing="0"><tr><td><b><span style="font-size: 14px">');
      write(f,WideFormat(_('Problem: %s'),[Title]));
      if FileName<>'' then
        write(f,hs(2)+WideFormat(_('File Name: %s'),[FileName]));
      write(f,'</span></b></td><td><p align="right"><span style="font-size: 14px"><b>');
      if ppr.ProblemResults.Items[i].Status=ST_NO_SOURCE_FILE then
        write(f,wideFormat(_('Program not found.')+'%s<a href=about:r/%d/>'+_('Rejudge')+'</a>',[hs(1),i]))
      else begin
        if ppr.ProblemResults.Items[i].Status=ST_COMPILATION_ERROR then
          write(f,_('Unable to compile the program')+hs(1));
        write(f,Format('<a href=about:r/%d/>'+_('Rejudge')+'</a> ',[i]));
        if ppr.ProblemResults.Items[i].Detail<>'' then
          write(f,Format('<a href=about:c/%d/>'+_('编译信息')+'</a>',[i]));
      end;
      write(f,'</b></span></td></tr></table>');
      if ppr.ProblemResults.Items[i].Status=ST_OK then begin
        write(f,'<div align="center">');
        write(f,'<table border="1" width="100%" id="table1" cellpadding="3" style="border-collapse: collapse" bgcolor="#DBEAF5" bordercolor="#7F91BD">');
        write(f,'<tr>');
        write(f,'<td align="center" width="13%" bgcolor="#7F91BD"><font color="#FFFFFF"><b><span style="font-size: 14px">'+_('Testcase')+'</span></b></td>');
        write(f,'<td align="center" width="27%" bgcolor="#7F91BD"><font color="#FFFFFF"><b><span style="font-size: 14px">'+_('Result')+'</span></b></td>');
        write(f,'<td align="center" width="13%" bgcolor="#7F91BD"><font color="#FFFFFF"><b><span style="font-size: 14px">'+_('Score')+'</span></b></td>');
        write(f,'<td align="center" width="22%" bgcolor="#7F91BD"><font color="#FFFFFF"><b><span style="font-size: 14px">'+_('Time')+'</span></b></td>');
        write(f,'<td align="center" width="20%" bgcolor="#7F91BD"><font color="#FFFFFF"><b><span style="font-size: 14px">'+_('Memory')+'</span></b></td>');
        write(f,'</tr>');
        for j:=0 to TestCaseResults.Count-1 do
          with TestCaseResults.Items[j] do begin
            write(f,'<tr>');
            write(f,'<td align="center" width="13%"><span style="font-size: 14px">'+inttostr(j+1)+'</span></td>');
            write(f,'<td align="center" width="27%"><span style="font-size: 14px">');

            case Status of
              ST_CANNOT_EXECUTE:
                write(f,_('Unable to Execute'));
              ST_TIME_LIMIT_EXCEEDED:
                write(f,_('Time Limit Exceeded'));
              ST_MEMORY_LIMIT_EXCEEDED:
                write(f,_('Memory Limit Exceeded'));
              ST_RUNTIME_ERROR:
                write(f,Format(_('Runtime Error %d'),[ExitCode]));
              ST_CRASH:
                write(f,_('Crash')+WideFormat(' (%s)', [GetException(ExitCode)]));
              ST_CORRECT:
                write(f,_('Correct'));
              ST_WRONG_ANSWER:
                write(f,_('Wrong Answer'));
              ST_PART_CORRECT:
                write(f,_('Partly Correct'));
              ST_PROGRAM_NO_OUTPUT:
                write(f,_('No Output'));
              ST_ILLEGALITY:
                write(f,_('Illegality'));
              ST_NO_STANDARD_INPUT:
                write(f,_('Missing Standard Input'));
              ST_NO_STANDARD_OUTPUT:
                write(f,_('Missing Standard Output'));
              ST_CUSTOM_COMPARE_ERROR:
                write(f,_('Custom Checker Error'));
            end;
            if Detail<>'' then
              write(f,Format(' <a href=about:t/%d/%d/>(?)</a>',[i,j]));

            write(f,'</span></td>');
            write(f,'<td align="center" width="13%"><span style="font-size: 14px">'+floattostr(Score)+'</span></td>');
            write(f,'<td align="center" width="22%"><span style="font-size: 14px">');
    //        if ppr.ProblemResults.Items[i].TestCaseResults.Items[j].Status in [3,5,7,8,9,10,11,12] then
              write(f,Format('%f',[Time])+'s</span></td>');
            write(f,'<td align="center" width="20%"><span style="font-size: 14px">');
            if Memory<>-1 then
              write(f,inttostr(Memory)+'KB</span></td>')
            else
              write(f,'N/A</span></td>');
            write(f,'</tr>');
          end;
        write(f,'</table>');
        write(f,'</div>');
        write(f,Format('<span style="font-size: 14px">'+_('Score: %s')+hs(2)+_('Time: %fs')+'</span><br>',[floattostr(Score),Time]));
    end;
    write(f,'</b><hr size="1">');
  end;
  write(f,'</body></html>');
  wb.Navigate('about:blank');
  while wb.ReadyState=1 do
    Application.ProcessMessages;
  if Assigned(wb.Document) then begin
    sl:=TStringList.Create;
    try
      ms:=TMemoryStream.Create;
      try 
        sl.Text := s;
        sl.SaveToStream(ms); 
        ms.Seek(0, 0); 
        (wb.Document as IPersistStreamInit).Load(TStreamAdapter.Create(ms));
      finally
        ms.Free;
      end;
    finally
      sl.Free;
    end;
  end;


end;


procedure TResultForm.N2Click(Sender: TObject);
begin
  Close;
end;

procedure TResultForm.E1Click(Sender: TObject);
begin
  MainForm.P1.Click;
end;

procedure TResultForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

procedure TResultForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent:=GetDesktopWindow;
end;

end.
