unit JudgeFormU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Buttons, ExtCtrls, ImgList, JudgeThreadU,
  mytypes, ojconst, jvgnugettext, JvExControls, JvComponent,
  JvAnimatedImage, JvGIFCtrl;

type
  TJudgeForm = class(TForm)
    btn1: TButton;
    btn2: TButton;
    pb1: TProgressBar;
    pb2: TProgressBar;
    pb3: TProgressBar;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lbl6: TLabel;
    redt1: TRichEdit;
    Label1: TLabel;
    gif: TJvGIFAnimator;
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    CanCloseNow: boolean;
    procedure CreateParams(var Params: TCreateParams); override;
    { Public declarations }
  end;

var
  JudgeForm: TJudgeForm;

implementation

uses MainFormU;

{$R *.dfm}

procedure TJudgeForm.btn1Click(Sender: TObject);
begin
  if JudgeThread.Suspended then begin
    gif.Animate:=true;
    JudgeThread.Resume;
    JudgeThread.Suspended:=false;
    btn1.Caption:=_('&Pause');
  end
  else begin
    gif.Animate:=false;
    JudgeThread.Suspend;
    JudgeThread.Suspended:=true;
    btn1.Caption:=_('&Resume');
  end;
end;

procedure TJudgeForm.btn2Click(Sender: TObject);
var
  Task: TTask;
begin
  while not TaskQueue.Empty do begin
    Task:=TaskQueue.FirstNode.Data;
    TaskQueue.DeleteFirstNode;
    Task.People.Status:=PS_UNKNOWN;
    MainForm.RefreshPeople(Task.People);
  end;
  Stopped:=true;
  TerminateProcess(JudgeThread.pi.hProcess,1);
  JudgeThread.Resume;
end;

procedure TJudgeForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  btn2.Click;
  CanClose:=CanCloseNow;
  OutputDebugString(pchar(booltostr(canclosenow)));
end;

procedure TJudgeForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//  image1.Picture:=nil;
  caption:=caption;
end;

procedure TJudgeForm.FormCreate(Sender: TObject);
begin
  CanCloseNow:=false;
  TranslateComponent(self);
end;

procedure TJudgeForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent:=GetDesktopWindow;
end;

end.
