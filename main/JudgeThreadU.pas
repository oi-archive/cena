unit JudgeThreadU;

interface

uses
  Windows, Forms, Messages, Classes, SysUtils, MyTypes, MyUtils, Dialogs,
  comobj, Graphics, crc32, shellapi, ojtc, ojrc, ojconst, jvgnugettext, 
  IdTCPClient, ojwin32, IdHTTP, comctrls, diffu, psapi, tlhelp32, math;

type
  TJudgeThread = class(TThread)
  private

    si: STARTUPINFO;
    BinaryType: cardinal;
    LastIdleTime:int64;

    FText:string;
    FColor:TColor;
    FBold:boolean;
    FName:widestring;
    FTask:TTask;
    FPeopleResult: TPeopleResult;
    FTestCase: TTestCase;
    FTime: double;

    FProblemID,FTestCaseID:integer;
    procedure Exec(AppName, WorkPath: widestring; TestCase: TTestCase;
      TestCaseResult: TTestCaseResult);
    procedure Sync(Method: TThreadMethod);
    procedure CheckLimits(Final: boolean; TestCase: TTestCase; TestCaseResult: TTestCaseResult);
  protected
    procedure Execute; override;
    procedure AddText;
    procedure SetStatus; overload;
    procedure AfterPeople;
    procedure StartJudge;
    procedure Complete;
    procedure ShowProgress;
    procedure ShowTestCaseTime;
    procedure BeforePeople;
    procedure GetPeople;
  public
    Judging: boolean;
    pi: PROCESS_INFORMATION;
    pr: TPeopleResult;
    procedure SetStatus(Text:string); overload;
  end;

var
  TaskQueue:TQueue;
  Stopped:boolean;
  JudgeThread:TJudgeThread;

implementation

uses
  MainFormU, JudgeFormU, ResultFormU, GatherThreadU;

{ Important: Methods and properties of objects in visual components can only be
  used in a method called using Synchronize, for example,

      Synchronize(UpdateCaption);

  and UpdateCaption could look like,

    procedure TJudgeThread.UpdateCaption;
    begin
      Form1.Caption := 'Updated in a thread';
    end; }                                   

const
  DesktopName:widestring='Cena Desktop';
  Title:widestring=#0#0;

//function Compare(fn1,fn2: pchar;  Report: ppchar): integer; stdcall; external '..\diff\pascal\diffu.dll' name 'Check';


procedure TJudgeThread.StartJudge;
begin
  Judging:=true;
  MainForm.pnl1.Enabled:=false;
  MainForm.pnl2.Enabled:=false;

  MainForm.MenuItem1.Enabled:=false;
  MainForm.MenuItem2.Enabled:=false;
  MainForm.N2.Enabled:=false;
  MainForm.O4.Enabled:=false;

  Application.CreateForm(TJudgeForm,JudgeForm);
  JudgeForm.redt1.Clear;
{
  for i:=0 to MainForm.lv1.Items.Count-1 do
    if MainForm.lv1.Items.Item[i].Data<>nil then begin
      TResultForm(MainForm.lv1.Items.Item[i].Data).Destroy;
      MainForm.lv1.Items.Item[i].Data:=nil;
    end;
}    
  JudgeForm.Show;

  if ActiveCollectorThreads>0 then
    MainForm.stat1.Panels[0].Text:=_('Gathering and Judging...')
  else
    MainForm.stat1.Panels[0].Text:=_('Judging...');

end;

procedure TJudgeThread.Complete;
begin
  Judging:=false;
  if JudgeForm<>nil then begin
    JudgeForm.CanCloseNow:=true;
    JudgeForm.Close;
    JudgeForm.Destroy;
    JudgeForm:=nil;
  end;

  if MainForm<>nil then begin // 为什么 MainForm=nil ?!!!
    MainForm.pnl1.Enabled:=true;
    MainForm.pnl2.Enabled:=true;

    MainForm.MenuItem1.Enabled:=true;
    MainForm.MenuItem2.Enabled:=true;
    MainForm.N2.Enabled:=true;
    MainForm.O4.Enabled:=true;

    if ActiveCollectorThreads=0 then
      MainForm.stat1.Panels[0].Text:=_('Idle')
    else
      MainForm.stat1.Panels[0].Text:=_('Gathering...');
      
  end;
  
end;

procedure TJudgeThread.ShowProgress;
begin
  JudgeForm.pb2.Position:=FTestCaseID;
  JudgeForm.pb2.Max:=Judge.Contest.Problems.Items[FProblemID].TestCases.Count;

  JudgeForm.pb3.Position:=FProblemID;
  JudgeForm.pb3.Max:=Judge.Contest.Problems.Count;
end;

function Short(Path:widestring):widestring;
var
  buf:array[0..MAX_PATH-1] of widechar;
begin
  fillchar(buf,sizeof(buf),0);
  windows.GetShortPathNameW(PwideChar(Path),@buf,sizeof(buf));
  result:=buf;
end;




procedure Compile(FileName:widestring; Compiler:TCompiler; ProblemResult:TProblemResult; NewExe: widestring);
var
  Par:widestring;
//  ExecuteResult: tagExecuteResult;
  si: STARTUPINFO;
//  pi: PROCESS_INFORMATION;
  ExitCode: cardinal;
  sa: SECURITY_ATTRIBUTES;
  hRead, hWrite: Cardinal;
  buffer: array[0..65535] of char;
  bytesRead: DWORD;
  ok: boolean;
begin
  sa.nLength := sizeof(sa);
  sa.lpSecurityDescriptor := nil;
  sa.bInheritHandle := true;
  CreatePipe(hRead, hWrite, @sa, 0);

  fillchar(si,sizeof(si),0);
  si.cb:=sizeof(si);
  si.lpDesktop:=@DesktopName[1];
  si.dwFlags:=STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
  si.wShowWindow:=SW_HIDE;
  si.hStdOutput := hWrite;
  si.hStdError := hWrite;

  Par:=StringReplace(Compiler.CommandLine,'%s',FileName,[rfReplaceAll]);
//  Par:=Par+' >c:\123.txt';

  ProblemResult.Detail := '';

  ok := CreateProcessW(nil,PWideChar(Par),nil,nil,true,CREATE_NEW_CONSOLE,nil,pwidechar(Judge.Contest.Path+'\tmp'),si,JudgeThread.pi);
  CloseHandle(hWrite);
  
  if ok then begin
   	while (ReadFile(hRead,buffer,sizeof(buffer)-1,bytesRead,nil)) do begin
	  	buffer[bytesRead] := chr(0);
      ProblemResult.Detail := ProblemResult.Detail + buffer;
    end;

    WaitForSingleObject(JudgeThread.pi.hProcess, INFINITE);

    GetExitCodeProcess(JudgeThread.pi.hProcess,ExitCode);
    ProblemResult.ExitCode:=ExitCode;
    CloseHandle(JudgeThread.pi.hProcess);
    CloseHandle(JudgeThread.pi.hThread);
    if ExitCode=0 then begin
      ProblemResult.Status:=ST_OK;
    end
    else
      ProblemResult.Status:=ST_COMPILATION_ERROR;
  end
  else
    ProblemResult.Status:=ST_COMPILATION_ERROR;
  CloseHandle(hRead);
end;

procedure TJudgeThread.AddText;
begin

  JudgeForm.redt1.SelStart:=length(JudgeForm.redt1.Text)-1;
  JudgeForm.redt1.SelLength:=5;
  JudgeForm.redt1.Paragraph.LeftIndent:=10;

  JudgeForm.redt1.SelAttributes.Color:=FColor;
  if FBold then
    JudgeForm.redt1.SelAttributes.Style:=[fsbold]
  else
    JudgeForm.redt1.SelAttributes.Style:=[];
  JudgeForm.redt1.Lines.Add(FText);
  JudgeForm.redt1.Perform(EM_SCROLLCARET,0,0);
  FColor:=clBlack;
  FBold:=false;

end;

procedure TJudgeThread.SetStatus;
begin
  JudgeForm.lbl4.Caption:=FText;
//  Status(FText);
end;

procedure TJudgeThread.AfterPeople;
begin
  FTask.People.Status:=PS_UNKNOWN;

  if not Stopped then begin
    PR.JudgeTime:=now;

    TListItem(FTask.People.Data1).SubItems[1]:=floattostr(FPeopleResult.Score);
    TListItem(FTask.People.Data1).SubItems[2]:=Format('%f',[FPeopleResult.Time]);
    TListItem(FTask.People.Data1).SubItems[6]:=datetimetostr(FPeopleResult.JudgeTime);

    MainForm.UpdatePlaces;

    PR.Save(FTask.People.Name);
  end
  else
    PR.Load(FTask.People.Name);

  MainForm.RefreshPeople(FTask.People);
  
  if FTask.People.ResultWnd<>nil then begin
    if not Stopped then
      TResultForm(FTask.People.ResultWnd).LoadResult(pr);
    TResultForm(FTask.People.ResultWnd).wb.Show;
  end
  else
    pr.Destroy;
    
  FTask.Destroy;

end;

function FullPath(Path:widestring):widestring;
begin
  if (length(path)<2) or (path[2]=':') then
    result:=path
  else
    result:=judge.Contest.Path+'\data\'+path;
end;





procedure CustomCompare(TestCase:TTestCase;Compare:widestring; TestCaseResult: TTestCaseResult);
var
  Score: double;
  Report: string;
  si: STARTUPINFO;
//  pi: PROCESS_INFORMATION;
  f: textfile;
  hFile, FileSize, mapi, ExitCode: cardinal;
begin

  TestCaseResult.Score:=0;
  TestCaseResult.Detail:='';
  TestCaseResult.Status:=ST_CUSTOM_COMPARE_ERROR;


//  if FileExists(Compare) then begin
    fillchar(si,sizeof(si),0);
    si.cb:=sizeof(si);
    si.lpDesktop:=@DesktopName[1];
    si.dwFlags:=0;
//    si.dwFlags:=STARTF_USESHOWWINDOW;
//    si.wShowWindow:=SW_HIDE;

//    allocconsole;
//    writeln(pwidechar(short(compare)+' '+floattostr(TestCase.Score)+' '+Short(FullPath(testcase.Output.FileName))));

    if CreateProcessW(nil,pwidechar(short(compare)+' '+floattostr(TestCase.Score)+' '+Short(FullPath(testcase.Output.FileName))),nil,nil,false,CREATE_NEW_CONSOLE,nil,pwidechar(Judge.Contest.Path+'\tmp'),si,JudgeThread.pi) then begin
      WaitForSingleObject(JudgeThread.pi.hProcess,maxint);

      GetExitCodeProcess(JudgeThread.pi.hProcess,ExitCode);

      CloseHandle(JudgeThread.pi.hProcess);
      CloseHandle(JudgeThread.pi.hThread);

      TestCaseResult.ExitCode:=ExitCode;
      if ExitCode=0 then begin
        assign(f,'score.log');
        try
          reset(f);
        except
          exit;
        end;
        try
          readln(f,score);
        except
          closefile(f);
          exit;
        end;
        closefile(f);
        Report:='';
        hFile:=CreateFileW('report.log',GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,FILE_ATTRIBUTE_ARCHIVE,0);
        if hFile<>INVALID_HANDLE_VALUE then begin
          FileSize:=GetFileSize(hFile,nil);
          SetLength(Report,FileSize);
          ReadFile(hFile,Report[1],FileSize,mapi,nil);
          CloseHandle(hFile);
        end;

        TestCaseResult.Score:=Score;
        TestCaseResult.Detail:=Report;

        if TestCaseResult.Score=TestCase.Score then
          TestCaseResult.Status:=ST_CORRECT
        else if TestCaseResult.Score=0 then
          TestCaseResult.Status:=ST_WRONG_ANSWER
        else
          TestCaseResult.Status:=ST_PART_CORRECT;
      end
      else
        TestCaseResult.Status:=ST_CUSTOM_COMPARE_ERROR;
    end
    else begin
      TestCaseResult.ExitCode:=GetLastError;
      TestCaseResult.Status:=ST_CUSTOM_COMPARE_ERROR;
    end;
{
  end
  else begin
    TestCaseResult.ExitCode:=GetLastError;
    TestCaseResult.Status:=ST_CUSTOM_COMPARE_ERROR;
  end;}
end;

function FindFile(FileName:widestring):TCompiler; 
var
  i:integer;
begin
  for i:=0 to Judge.Settings.Compilers.Count-1 do
    if Judge.Settings.Compilers.Items[i].Active and
       FileExists(FileName+'.'+Judge.Settings.Compilers.Items[i].Extension) then begin
         result:=Judge.Settings.Compilers.Items[i];
         exit;
       end;
  result:=nil;
end;

procedure TJudgeThread.Execute;
var
  i,j,k:integer;

  hash:cardinal;
  CompareFileName:widestring;

//  cplid:integer;             // compiler id
  Compiler: TCompiler;

  oldname:widestring;            // d:\judge\2\a01\network
  oldnamewithext:widestring;     // d:\judge\2\a01\network.pas
  newnamenodir: widestring;      // asdfasdf;
  newname:widestring;            // d:\judge\work\asdfasdf
  newnamewithext:widestring;     // d:\judge\work\asdfasdf.pas
  newexe:widestring;             // d:\judge\work\asdfasdf.exe

  tcpc:TIdTCPClient;
  cl:TClient;

  Report: widestring;

begin

  fillchar(si,sizeof(si),0);

  with si do begin
    cb:=sizeof(si);
    lpDesktop:=@DesktopName[1];
    lpTitle:=@Title[1];
    dwFlags:=STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
    wShowWindow:=SW_HIDE;
  end;

  try

  repeat

    while TaskQueue.Empty do begin
      Sync(Complete);
      Suspend;
      Stopped:=false;
      Sync(StartJudge);
    end;

    if not DirectoryExists(Judge.Contest.Path+'\tmp\') then
      MkDir(Judge.Contest.Path+'\tmp\');

    SetStatus(_('Loading contestant''s information...'));
    Sync(GetPeople);

    Sync(BeforePeople);
    for i:=0 to Judge.Contest.Problems.Count-1 do begin   // the ith problem
      sleep(1);

      FProblemID:=i;
      FTestCaseID:=0;

      Sync(ShowProgress);

      if (FTask.ProblemID<>-1) and (FTask.ProblemID<>i) then
        continue;

      PR.ProblemResults.Items[i].Title:=Judge.Contest.Problems.Items[i].Title;
      PR.ProblemResults.Items[i].FileName:='';

      FText:=Format(_('Judging %s (%s) :'),[Judge.Contest.Problems.Items[i].Title,Judge.Contest.Problems.Items[i].FileName]);
      FBold:=true;
      Sync(AddText);
      OldName:=Judge.Contest.Path+'\src\'+FTask.People.Name+'\'+Judge.Contest.Problems.Items[i].FileName;

      Compiler:=FindFile(OldName);
      if Compiler<>nil then begin
        pr.ProblemResults.Items[i].FileName:=Judge.Contest.Problems.Items[i].FileName+'.'+Compiler.Extension;
        FText:='   '+_('Found file')+#9+pr.ProblemResults.Items[i].FileName;
        Sync(AddText);
        OldNameWithExt:=OldName+'.'+Compiler.Extension;

        hash:=crc32file(OldNameWithExt);

        if not (FTask.OnlyJudgeChanged and (hash=PR.ProblemResults.Items[i].Hash)) then begin
          SetStatus(_('Compiling...'));

//          PR.Problem[i].Clear;

          NewNameNoDir:=RandomString(8);
          NewName:=Judge.Contest.Path+'\tmp\'+NewNameNoDir;
          NewNameWithExt:=NewName+'.'+Compiler.Extension;

          CopyFileW(@OldNameWithExt[1],@NewNameWithExt[1],false);

           

          for j:=0 to Judge.Contest.Problems[i].Libraries.Count-1 do 
            if CopyFileW(pwidechar(fullpath(Judge.Contest.Problems[i].Libraries[j].FileName)),
               pwidechar(Judge.Contest.Path+'\tmp\'+ExtractFileName(Judge.Contest.Problems[i].Libraries[j].FileName)),false) then
               SetFileAttributesW(pwidechar(Judge.Contest.Path+'\tmp\'+ExtractFileName(Judge.Contest.Problems[i].Libraries[j].FileName)),FILE_ATTRIBUTE_ARCHIVE);

          NewExe:=StringReplace(Compiler.Executable,'%s',NewNameNoDir,[rfReplaceAll]);

          if Compiler.CommandLine<>'' then
            Compile(NewNameNoDir,Compiler,PR.ProblemResults.Items[i],NewExe)
          else
            PR.ProblemResults.Items[i].Status:=ST_OK; // 解释或直接运行

          if PR.ProblemResults.Items[i].Status=ST_OK then begin

            for j:=0 to Judge.Contest.Problems.Items[i].TestCases.Count-1 do begin { the jth testcase }
              FTestCaseID:=j;
              Sync(ShowProgress);

//              allocconsole;
//              writeln(i,' ',j,' ',k);
              SetStatus(_('Deleting previous input files...'));
              for k:=0 to Judge.Contest.Problems.Items[i].Inputs.Count-1 do
                while FileExistsW(Judge.Contest.Path+'\tmp\'+Judge.Contest.Problems.Items[i].Inputs.Items[k].FileName,false) do begin
                  SetFileAttributesW(pwidechar(Judge.Contest.Path+'\tmp\'+Judge.Contest.Problems.Items[i].Inputs.Items[k].FileName),FILE_ATTRIBUTE_ARCHIVE);
                  DeleteFileW(pwidechar(Judge.Contest.Path+'\tmp\'+Judge.Contest.Problems.Items[i].Inputs.Items[k].FileName));
//                  writeln('delete ',pwidechar(Judge.Contest.Path+'\tmp\'+Judge.Contest.Problems.Items[i].Inputs.Items[k].FileName));
                  if Stopped then break;
                  Sleep(20);
                end;
//              writeln('done');
//              writeln;

              if Stopped then break;


              SetStatus(_('Copying input files...'));

              for k:=0 to min(Judge.Contest.Problems.Items[i].TestCases.Items[j].Inputs.Count,Judge.Contest.Problems.Items[i].Inputs.Count)-1 do
                if CopyFileW(pwidechar(fullpath(Judge.Contest.Problems.Items[i].TestCases.Items[j].Inputs.Items[k].FileName)),
                         pwidechar(Judge.Contest.Path+'\tmp\'+Judge.Contest.Problems.Items[i].Inputs.Items[k].FileName),false) then
                    SetFileAttributesW(pwidechar(Judge.Contest.Path+'\tmp\'+Judge.Contest.Problems.Items[i].Inputs.Items[k].FileName),FILE_ATTRIBUTE_ARCHIVE)
                else{ begin
                  writeln('failed to copy ');
                  writeln(Judge.Contest.Problems.Items[i].TestCases.Items[j].Inputs.Items[k].FileName);
                  writeln(pwidechar(fullpath(Judge.Contest.Problems.Items[i].TestCases.Items[j].Inputs.Items[k].FileName)));
                  writeln(pwidechar(Judge.Contest.Path+'\tmp\'+Judge.Contest.Problems.Items[i].Inputs.Items[k].FileName));
                end  }
                  ; // !!!

              if Stopped then break;

              SetStatus(_('Deleting previous output file...'));
              while FileExists(Judge.Contest.Path+'\tmp\'+Judge.Contest.Problems.Items[i].Output.FileName) do begin
                SetFileAttributesW(pwidechar(Judge.Contest.Path+'\tmp\'+Judge.Contest.Problems.Items[i].Output.FileName),FILE_ATTRIBUTE_ARCHIVE);
                DeleteFileW(pwidechar(Judge.Contest.Path+'\tmp\'+Judge.Contest.Problems.Items[i].Output.FileName));
                if Stopped then break;
                Sleep(20);
              end;

              if Stopped then break;

              FText:=_('Running...');    
              Sync(SetStatus);

              Exec(NewExe,Judge.Contest.Path+'\tmp\',
                Judge.Contest.Problems.Items[i].TestCases.Items[j],
                PR.ProblemResults.Items[i].TestCaseResults.Items[j]);



              if Stopped then break;

              pr.ProblemResults.Items[i].TestCaseResults.Items[j].Detail:='';
              Report:='';

              if PR.ProblemResults.Items[i].TestCaseResults.Items[j].Status=ST_OK then begin

                FText:=_('Comparing output files...');
                Sync(SetStatus);

                Sleep(20);
                
                case Judge.Contest.Problems.Items[i].CompareType of
                  COMPARE_CUSTOM:
                    begin
                      CompareFileName:=RandomString(8);
                      CopyFileW(pwidechar(FullPath(Judge.Contest.Problems.Items[i].CustomCompareFile)),
                                pwidechar(Judge.Contest.Path+'\tmp\'+CompareFileName+'.exe'),false);
                      windows.DeleteFileW('score.log');
                      windows.DeleteFileW('report.log');

                      CustomCompare(Judge.Contest.Problems.Items[i].TestCases.Items[j],
                                    Judge.Contest.Path+'\tmp\'+CompareFileName+'.exe',PR.ProblemResults.Items[i].TestCaseResults.Items[j]);
                    end;
                  COMPARE_TEXT:
                    begin
                      { student, standard }
                      PR.ProblemResults.Items[i].TestCaseResults.Items[j].Status:=
                      Compare(@(Judge.Contest.Path+'\tmp\'+Judge.Contest.Problems.Items[i].Output.FileName)[1],
                              @fullpath(Judge.Contest.Problems.Items[i].TestCases.Items[j].Output.FileName)[1],
                              Report);
                      PR.ProblemResults.Items[i].TestCaseResults.Items[j].Detail:=Report;

                      if PR.ProblemResults.Items[i].TestCaseResults.Items[j].Status=ST_CORRECT then
                        PR.ProblemResults.Items[i].TestCaseResults.Items[j].Score:=
                          Judge.Contest.Problems.Items[i].TestCases.Items[j].Score
                      else
                        PR.ProblemResults.Items[i].TestCaseResults.Items[j].Score:=0;

                    end;
                  COMPARE_BINARY:
                    begin
                      PR.ProblemResults.Items[i].TestCaseResults.Items[j].Status:=
                      CompareBin(@(Judge.Contest.Path+'\tmp\'+Judge.Contest.Problems.Items[i].Output.FileName)[1],
                              @fullpath(Judge.Contest.Problems.Items[i].TestCases.Items[j].Output.FileName)[1],
                              Report);
                      PR.ProblemResults.Items[i].TestCaseResults.Items[j].Detail:=Report;
                      if PR.ProblemResults.Items[i].TestCaseResults.Items[j].Status=ST_CORRECT then
                        PR.ProblemResults.Items[i].TestCaseResults.Items[j].Score:=
                          Judge.Contest.Problems.Items[i].TestCases.Items[j].Score
                      else
                        PR.ProblemResults.Items[i].TestCaseResults.Items[j].Score:=0;

                    end;
                end;
              end
              else begin
                PR.ProblemResults.Items[i].TestCaseResults.Items[j].Score:=0;
              end;

              if Stopped then break;

              if (PR.ProblemResults.Items[i].TestCaseResults.Items[j].Status=ST_PROGRAM_NO_OUTPUT)
                  and (PR.ProblemResults.Items[i].TestCaseResults.Items[j].ExitCode<>0) then
                      PR.ProblemResults.Items[i].TestCaseResults.Items[j].Status:=ST_RUNTIME_ERROR;

              case PR.ProblemResults.Items[i].TestCaseResults.Items[j].Status of


                ST_CANNOT_EXECUTE:
                  begin
                    FText:=_('Unable to Execute');
                  end;
                ST_CORRECT:
                  begin
                    if PR.ProblemResults.Items[i].TestCaseResults.Items[j].Memory<>-1 then
                      FText:=Format(_('Correct ( %fs , %dKB )'),[PR.ProblemResults.Items[i].TestCaseResults.Items[j].Time,PR.ProblemResults.Items[i].TestCaseResults.Items[j].Memory])
                    else
                      FText:=Format(_('Correct ( %fs )'),[PR.ProblemResults.Items[i].TestCaseResults.Items[j].Time]);

                    FColor:=clGreen;
                  end;
                ST_WRONG_ANSWER:
                  begin
                    FText:=_('Wrong Answer');
                    FColor:=clRed;
                  end;
                ST_TIME_LIMIT_EXCEEDED:
                  begin
                    FText:=_('Time Limit Exceeded');
                    FColor:=$2F7fff;
                  end;
                ST_MEMORY_LIMIT_EXCEEDED:
                  begin
                    FText:=_('Memory Limit Exceeded');
                    FColor:=$2F7fff;
                  end;
                ST_RUNTIME_ERROR:
                  begin
                    FText:=Format(_('Runtime Error %d'),[PR.ProblemResults.Items[i].TestCaseResults.Items[j].ExitCode]);
                    FColor:=clFuchsia;
                  end;
                ST_CRASH:
                  begin
                    FText:=_('Crash')+WideFormat(' (%s)', [GetException(PR.ProblemResults.Items[i].TestCaseResults.Items[j].ExitCode)]);
                    FColor:=clFuchsia;
                  end;
                ST_PROGRAM_NO_OUTPUT:
                  begin
                    FText:=_('No Output');
                    FColor:=$7f7f7f;
                  end;
                ST_PART_CORRECT:
                  begin
                    if PR.ProblemResults.Items[i].TestCaseResults.Items[j].Memory<>-1 then
                      FText:=Format(_('Partly Correct ( %fs , %dKB , %s/%s )'),[PR.ProblemResults.Items[i].TestCaseResults.Items[j].Time,PR.ProblemResults.Items[i].TestCaseResults.Items[j].Memory,floattostr(PR.ProblemResults.Items[i].TestCaseResults.Items[j].Score),floattostr(Judge.Contest.Problems[i].TestCases[j].Score)])
                    else
                      FText:=Format(_('Partly Correct ( %fs , %s/%s )'),[PR.ProblemResults.Items[i].TestCaseResults.Items[j].Time,floattostr(PR.ProblemResults.Items[i].TestCaseResults.Items[j].Score),floattostr(Judge.Contest.Problems[i].TestCases[j].Score)]);

                    FColor:=0;
                  end;
                ST_CUSTOM_COMPARE_ERROR:
                  begin
                    FText:=_('Custom Checker Error');
                    FColor:=0;
                  end;
                ST_NO_STANDARD_OUTPUT:
                  begin
                    FText:=_('Missing Standard Output');
                    FColor:=0;
                  end;
                ST_ILLEGALITY:
                  begin
                    FText:=_('Illegality');
                    FColor:=0;
                  end;
                else
                  begin
                    FText:=WideFormat(_('Unknown Error %d'),[PR.ProblemResults.Items[i].TestCaseResults.Items[j].Status]);
                    FColor:=0;
                  end;
              end;
              FText:='   '+WideFormat(_('Testcase %d'),[j+1])+#9+FText;
              Sync(AddText);

              for k:=0 to Judge.Plugins.Count-1 do
                with PR.ProblemResults.Items[i].TestCaseResults.Items[j] do
                  Judge.Plugins.Items[k].AfterTestCase(pwidechar(FTask.People.Name), i, j, Status, Score, Time, Memory, ExitCode);

            end;

          end
          else begin
            FText:=Format('   '+_('Unable to compile the program, %d'),[PR.ProblemResults.Items[i].ExitCode]);
            Sync(AddText);
          end;

          if Stopped then break;

          PR.ProblemResults.Items[i].Hash:=hash;

          FText:=WideFormat(_('Finish judging this problem. Score %s.'),[floattostr(PR.ProblemResults.Items[i].Score)]);
          FBold:=true;
          Sync(AddText);

        end
        else begin
          FText:='   '+_('The program hasn''t been modified. No need to judge.');
          Sync(AddText);
        end;
      end
      else begin
        FText:='   '+_('Program not found.');
        Sync(AddText);
        PR.ProblemResults.Items[i].Status:=ST_NO_SOURCE_FILE;
      end;
      if Stopped then break;

      FText:='';
      Sync(AddText);

      if pr.ProblemResults.Items[i].Status<>ST_OK then
        for j:=0 to pr.ProblemResults.Items[i].TestCaseResults.Count-1 do begin
          with pr.ProblemResults.Items[i] do begin
            TestCaseResults.Items[j].Status:=Status;
            TestCaseResults.Items[j].Score:=0;
            TestCaseResults.Items[j].Time:=0;
            TestCaseResults.Items[j].Memory:=0;
            TestCaseResults.Items[j].ExitCode:=ExitCode;
            TestCaseResults.Items[j].Detail:='';
          end;
        end;


    end;

    FName:=FTask.People.Name;
    FPeopleResult:=PR;

    Sync(AfterPeople);

    SetStatus(_('Compileting Judge...'));
    sleep(200); // win7 workaround

    windows.SetCurrentDirectoryW(pwidechar(Judge.Path));
    deldir(Judge.Contest.Path+'\tmp',false);


  until false;
  except
    MessageBoxW(MainForm.Handle,pwidechar(WideFormat(_('A fetal error has occurred. Please restart %s.'),[_(ProductName)])),nil,0);

    try
      MainForm.SaveAllOptions;
      Judge.Settings.Save;
    except
    end;
    TerminateProcess(GetCurrentProcess,1);
  end;
end;

procedure TJudgeThread.SetStatus(Text:string);
begin
  FText:=Text;
  Sync(SetStatus);
end;

function GetProcessIdFileName(dwProcessId: cardinal):string;
var 
  IsLoopContinue:BOOL;
  FSnapshotHandle:THandle;
  FProcessEntry32:TProcessEntry32;
begin
  Result:='';
  FSnapshotHandle:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0); // 创建系统快照
  FProcessEntry32.dwSize:=Sizeof(FProcessEntry32); // 必须先设置结构的大小
  IsLoopContinue:=Process32First(FSnapshotHandle,FProcessEntry32); //得到第一个进程信息
  while integer(IsLoopContinue)<>0 do begin
    if FProcessEntry32.th32ProcessID=dwProcessId then begin
      result:=FProcessEntry32.szExeFile;
      break;
    end;
    IsLoopContinue:=Process32Next(FSnapshotHandle,FProcessEntry32); // 继续枚举
  end;
  CloseHandle(FSnapshotHandle); // 释放快照句柄 
end;

procedure TJudgeThread.Exec(AppName, WorkPath: widestring; TestCase: TTestCase;
  TestCaseResult: TTestCaseResult);
var
  de:_DEBUG_EVENT;
  ExitCode: cardinal;

  ProcessRunning:boolean;

begin

  with si do begin
    hStdOutput := 0;
    hStdInput := 0;  // this handle is not for input.
    hStdError := 0;
  end;

  FTestCase:=TestCase;

  windows.SetCurrentDirectoryW(pwidechar(WorkPath)); // !!! 暂时这么搞

  if CreateProcessW(nil,pwidechar(AppName),nil,nil,true,DEBUG_PROCESS or DEBUG_ONLY_THIS_PROCESS or CREATE_NEW_CONSOLE,nil,nil,si,pi) then begin
    if UpperCase(GetProcessIdFileName(pi.dwProcessId))='NTVDM.EXE' then
      BinaryType:=SCS_DOS_BINARY
    else
      BinaryType:=SCS_32BIT_BINARY;

    TestCaseResult.Status:=ST_UNKNOWN;
    LastIdleTime:=GetIdleTime;
    ProcessRunning:=true;
    repeat
      while WaitForDebugEvent(de,200) do begin
        ContinueDebugEvent(de.dwProcessId,de.dwThreadId,DBG_CONTINUE);
        case de.dwDebugEventCode of
          EXCEPTION_DEBUG_EVENT:
            begin
              case de.Exception.ExceptionRecord.ExceptionCode of
                STATUS_ACCESS_VIOLATION, STATUS_ILLEGAL_INSTRUCTION,
                STATUS_IN_PAGE_ERROR, STATUS_INVALID_HANDLE, STATUS_PRIVILEGED_INSTRUCTION:   // !!! any other possible statuses?
                  begin
                    TestCaseResult.Status:=ST_CRASH;
                    TerminateProcess(pi.hProcess,de.Exception.ExceptionRecord.ExceptionCode);
                  end;
                STATUS_FLOAT_DIVIDE_BY_ZERO, STATUS_INTEGER_OVERFLOW,
                STATUS_FLOAT_OVERFLOW, STATUS_STACK_OVERFLOW, STATUS_INTEGER_DIVIDE_BY_ZERO:
                  begin
                    TestCaseResult.Status:=ST_CRASH;
                    TerminateProcess(pi.hProcess,de.Exception.ExceptionRecord.ExceptionCode);
                  end;
//                STATUS_SINGLE_STEP:;
                STATUS_BREAKPOINT:; {Every program will have a breakpoint at starting}
                STATUS_SEGMENT_NOTIFICATION:; {only 16bit DOS want this}
                else {if (BinaryType=SCS_32BIT_BINARY) then} begin
                    TestCaseResult.Status:=ST_CRASH;
                    TerminateProcess(pi.hProcess,de.Exception.ExceptionRecord.ExceptionCode)
                end;
              end;
            end;
          CREATE_THREAD_DEBUG_EVENT:;
          CREATE_PROCESS_DEBUG_EVENT:
            begin
              CloseHandle(de.CreateProcessInfo.hFile);
            end;
          EXIT_THREAD_DEBUG_EVENT:;
          EXIT_PROCESS_DEBUG_EVENT:
            begin
              if de.dwProcessId=pi.dwProcessId then begin
                if TestCaseResult.Status=ST_UNKNOWN then
                  TestCaseResult.Status:=ST_OK;

                ExitCode:=de.ExitProcess.dwExitCode;

                ProcessRunning:=false;
              end;
            end;
          LOAD_DLL_DEBUG_EVENT:
            begin
              CloseHandle(de.LoadDll.hFile);
            end;
          UNLOAD_DLL_DEBUG_EVENT:;
          OUTPUT_DEBUG_STRING_EVENT:;
          RIP_EVENT:;
        end;

        if not ProcessRunning then
          break;

        if random(100)=1 then
          CheckLimits(false, TestCase, TestCaseResult);

      end;

      if not ProcessRunning then
        break;

      CheckLimits(false, TestCase, TestCaseResult);

    until false;

{

    WaitForSingleObject(pi.hProcess,100); // remove it !!!
    TerminateProcess(pi.hProcess,1);
    TestCaseResult.Status:=ST_OK;
    ExitCode:=0;
}


//!!!
    if TestCaseResult.Status=ST_TIME_LIMIT_EXCEEDED then
      CheckLimits(false, TestCase, TestCaseResult)
    else
      CheckLimits(true, TestCase, TestCaseResult);

    TestCaseResult.ExitCode:=ExitCode;

  end
  else begin
    TestCaseResult.Status:=ST_CANNOT_EXECUTE;
    TestCaseResult.ExitCode:=GetLastError;
  end;

  CloseHandle(pi.hProcess);
  CloseHandle(pi.hThread);

end;

procedure TJudgeThread.ShowTestCaseTime;
begin
  try // !!!
    JudgeForm.pb1.Max:=trunc(FTestCase.TimeLimit*1000);
    JudgeForm.pb1.Position:=trunc(FTime*1000);
  except
  end;
end;

procedure TJudgeThread.BeforePeople;
var
  i:integer;
begin
  FTask.People.Status:=PS_JUDGING;
  MainForm.RefreshPeople(FTask.People);

  SetStatus('读取选手评测结果...');

  for i:=0 to Judge.Plugins.Count-1 do
    Judge.Plugins.Items[i].BeforePerson(pwidechar(FTask.People.Name));

  if FTask.People.ResultWnd<>nil then begin
    TResultForm(FTask.People.ResultWnd).wb.Hide;
    pr:=TResultForm(FTask.People.ResultWnd).ppr;
  end
  else begin
    PR:=TPeopleResult.Create;
    PR.Load(FTask.People.Name);
  end;

  PR.Adjust(Judge.Contest);  // !!!

  JudgeForm.lbl6.Caption:=Format(_('Judging %s''s programs...'),[FTask.People.Name]);
  JudgeForm.lbl5.Caption:=Format(_('%d contestants left.'),[TaskQueue.Count+1]);
end;

procedure TJudgeThread.Sync(Method: TThreadMethod);
begin
  Synchronize(Method);
end;

procedure TJudgeThread.GetPeople;
begin
  FTask:=TaskQueue.FirstNode.Data;
  TaskQueue.DeleteFirstNode;
end;

procedure TJudgeThread.CheckLimits(Final: boolean; TestCase: TTestCase; TestCaseResult: TTestCaseResult);
var
  pszText: PChar;
  hCurrentWindow, hClose : hwnd;
  pmc:_PROCESS_MEMORY_COUNTERS;
  ct,et,kt,ut:FILETIME;

begin
  hCurrentWindow:=GetWindow(GetDesktopWindow,GW_CHILD);

  pszText:=StrAlloc(256);
  while hCurrentWindow<>0 do begin
    GetWindowModuleFileName(hCurrentWindow,pszText,256);
    if (SameFileName(ExtractFileName(pszText),'user32.dll')) then begin
      GetWindowText(hCurrentWindow,pszText,256);
      if (pos('16',pszText)>0) and (pos('MS-DOS',pszText)>0) then begin
        hClose:=GetWindow(hCurrentWindow,GW_CHILD);
        SendMessage(hClose,WM_LBUTTONDOWN,0,0);
        SendMessage(hClose,WM_LBUTTONUP,0,0);
      end;
    end;
    hCurrentWindow:=GetWindow(hCurrentWindow,GW_HWNDNEXT);
  end;
  StrDispose(pszText);

  if BinaryType=SCS_32BIT_BINARY then begin
    ZeroMemory(@pmc,sizeof(pmc));
    pmc.cb:=sizeof(pmc);
    GetProcessMemoryInfo(pi.hProcess,@pmc,sizeof(pmc));
    TestCaseResult.Memory:=pmc.PeakPagefileUsage shr 10;
    if TestCaseResult.Memory>TestCase.MemoryLimit then begin
      TestCaseResult.Status:=ST_MEMORY_LIMIT_EXCEEDED;
      TerminateProcess(pi.hProcess,1);
    end;
  end
  else
    TestCaseResult.Memory:=-1;

  GetProcessTimes(pi.hProcess,ct,et,kt,ut);
  if Final then
    TestCaseResult.Time:=trunc(({int64(kt)+}int64(ut))/100000)/100
  else
    TestCaseResult.Time:=({int64(kt)+}int64(ut)+GetIdleTime-LastIdleTime)/10000000;

  FTime:=TestCaseResult.Time;
  Sync(ShowTestCaseTime);
  if (TestCaseResult.Time > TestCase.TimeLimit) then begin
    TestCaseResult.Status:=ST_TIME_LIMIT_EXCEEDED;
    TerminateProcess(pi.hProcess,1);
  end
  else if ((not Final) and (TestCaseResult.Time+GetIdleTime-LastIdleTime>(TestCase.TimeLimit+5)*10000000)) then begin
     TestCaseResult.Time := ({int64(kt)+}int64(ut)+GetIdleTime-LastIdleTime)/10000000;
     TestCaseResult.Status:=ST_TIME_LIMIT_EXCEEDED;
     TerminateProcess(pi.hProcess,1);
  end;
end;

initialization
  CreateDesktopW(@DesktopName[1],nil,nil,0,DESKTOP_CREATEWINDOW,nil);
  TaskQueue:=TQueue.Create;

finalization
  TaskQueue.Destroy;
end.


