program cena;

uses
//  fastmm4,
  Windows, Forms in '..\lib\Forms.pas',
  sysutils, Graphics,
  MainFormU in 'MainFormU.pas' {MainForm},
  AboutFormU in 'AboutFormU.pas' {AboutForm},
  MessageFormU in 'MessageFormU.pas' {MessageForm},
  NewFormU in 'NewFormU.pas' {NewForm},
  JudgeFormU in 'JudgeFormU.pas' {JudgeForm},
  JudgeThreadU in 'JudgeThreadU.pas',
  ResultFormU in 'ResultFormU.pas' {ResultForm},
  OptionFormU in 'OptionFormU.pas' {OptionForm},
  GatherThreadU in 'GatherThreadU.pas',
  CIFormU in 'CIFormU.pas' {CIForm},
  PrintFormU in 'PrintFormU.pas' {PrintForm},
  PropFormU in 'PropFormU.pas' {PropForm},
  DropDownFormU in 'DropDownFormU.pas' {DropDownForm},
  PrintSetU in 'PrintSetU.pas' {PrintSetForm},
  CRC32 in '..\lib\crc32.pas',
  diffu in '..\lib\diffu.pas',
  libxml2 in '..\lib\libxml2.pas',
  ojwin32 in '..\lib\ojwin32.pas',
  libojcd in '..\lib\libojcd.pas',
  MyTypes in '..\lib\MyTypes.pas',
  MyUtils in '..\lib\MyUtils.pas',
  ojconst in '..\lib\ojconst.pas',
  ojcount in '..\lib\ojcount.pas',
  ojrc in '..\lib\ojrc.pas',
  ojsort in '..\lib\ojsort.pas',
  ojtc in '..\lib\ojtc.pas',
  AutoUpdateU,
  ProjectInit in '..\lib\ProjectInit.pas';

{$R *.res}

//function IsDebuggerPresent:boolean; stdcall; external 'kernel32.dll' name 'IsDebuggerPresent';

begin
  
  if WaitForSingleObject(CreateMutex(nil,false,'Cena is running'),0)=WAIT_TIMEOUT then
    halt;


  if (ParamCount>0) and (Paramstr(1)='--init') then begin
    Init_Compilers;
    halt;
  end;

  randomize; // use for randomstring;

  Application.Initialize;

  {$ifdef jdlkjflkajsdlkjflk}
  Application.Title := 'Cena';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TMessageForm, MessageForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TNewForm, NewForm);
  Application.CreateForm(TJudgeForm, JudgeForm);
  Application.CreateForm(TResultForm, ResultForm);
  Application.CreateForm(TSelectForm, SelectForm);
  Application.CreateForm(TOptionForm, OptionForm);
  Application.CreateForm(TCIForm, CIForm);
  Application.CreateForm(TPrintForm, PrintForm);
  Application.CreateForm(TPropForm, PropForm);
  Application.CreateForm(TPreViewForm, PreViewForm);
  Application.CreateForm(TDropDownForm, DropDownForm);
  Application.CreateForm(TPrintSetForm, PrintSetForm);
  {$endif}
  Application.CreateForm(TMainForm,MainForm);

  Application.CreateForm(TDropDownForm,DropDownForm);
  Application.CreateForm(TMessageForm,MessageForm);

  Application.Run;
end.
