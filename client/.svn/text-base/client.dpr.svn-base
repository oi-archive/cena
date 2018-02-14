program Client;

uses
  Forms in '..\lib\forms.pas',
  Windows,
  SysUtils,
  Messages,
  jvgnugettext,
  MainFormUnit in 'MainFormUnit.pas' {MainForm},
  AboutFormUnit in 'AboutFormUnit.pas' {AboutForm},
  OptionFormUnit in 'OptionFormUnit.pas' {OptionForm},
  ResultFormU in 'ResultFormU.pas' {ResultForm},
  AutoUpdateThreadU in 'AutoUpdateThreadU.pas',
  libxml2 in '..\lib\libxml2.pas',
  libojcd in '..\lib\libojcd.pas',
  ojtc in '..\lib\ojtc.pas',
  MyTypes in '..\lib\MyTypes.pas',
  MyUtils in '..\lib\MyUtils.pas',
  ojcount in '..\lib\ojcount.pas',
  ojconst in '..\lib\ojconst.pas',
  ojrc in '..\lib\ojrc.pas';

{$R *.res}

var
  buf: array[0..MAX_PATH] of char;
  newexe: string;
  h: cardinal;



procedure geiwozhuang(update, showerror: boolean);
var
  LastError: cardinal;
begin
  Windows.GetSystemDirectory(@buf,sizeof(buf));
  newexe:=buf+'\cenaclnt.exe';
  Windows.DeleteFile(pchar(buf+'\ojcd.exe'));

  while not CopyFile(@Application.ExeName[1],@newexe[1],false) do begin
    LastError:=GetLastError;
    if MessageBoxW(0,pwidechar('Unable to install Cena Client.'#13#10#13#10+WideFormat(_('Error %d: %s'),[LastError,SysErrorMessage(LastError)])),pwidechar(_('Error')),MB_ICONERROR or MB_RETRYCANCEL)=IDCANCEL then
      halt;
  end;
  if update then
    newexe:=newexe+' -fu'
  else
    newexe:=newexe+' -f';
  winexec(@newexe[1],SW_SHOW);
  halt;
end;



begin
  UseLanguage('');
     
//  allocconsole;
//  writeln('my version is ',ClientInfo.Version);

  randomize;
{
  for i:=0 to 3 do begin
    h:=FindWindow(nil,'OpenJudge client daemon');
    writeln(h);
    SendMessage(h,WM_CLOSE,0,0);
    sleep(100);
  end;
}
  // Now doing installation......

//  writeln(paramstr(1));
//  writeln(paramstr(2));

  case ParamCount of
    0:
      begin
        geiwozhuang(false,true);
      end;
    1:;
    2:
      begin
        if ParamStr(1)='-u' then begin
          h:=strtoint(paramstr(2));
//          writeln('hwnd=',h);

          if h<>0 then
            SendMessage(h,WM_CLOSE,0,0);
          Windows.Beep(220,200);
          Windows.Beep(2200,200);
          Windows.Beep(220,200);
          Windows.Beep(2200,200);
          Sleep(1000);
//          windows.WaitForSingleObject(hProcess,maxint);
          geiwozhuang(true,false);
        end;
      end;
  end;

  if WaitForSingleObject(CreateMutex(nil,false,'Cena client is running'),0)=WAIT_TIMEOUT then
    halt;

  Randomize;

  Application.Initialize;
  {$IFDEF JIASDFJIADF}
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TOptionForm, OptionForm);
  Application.CreateForm(TAboutForm, AboutForm);
  Application.CreateForm(TResultForm, ResultForm);
  {$ENDIF}
//  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TMainForm,MainForm);

  MainForm.Width:=0;
  MainForm.Height:=0;

  MainForm.Left:=-10000;
  MainForm.Show;
  MainForm.Hide;
  Application.ShowMainForm:=false;
  Application.Run;
end.

