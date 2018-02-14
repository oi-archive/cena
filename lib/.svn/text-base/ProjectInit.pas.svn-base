unit ProjectInit;

interface

procedure Init_Compilers;

implementation

uses
  ojtc, MainFormU;

procedure Init_Compilers;
var
  cpPath: WideString;
begin

  Judge.Settings.Load;
{
  if not Judge.Settings.Opened then
    halt;
}
  Judge.Settings.Recents.Add(Judge.Path+'\example');

  Judge.Settings.Compilers.Clear;
  cpPath:=Judge.Path+'\compilers\';
  with Judge.Settings.Compilers.Add do begin
    Active:=true;
    Title:='FPC (win32)';
    Extension:='pas';
    commandLine:=cpPath+'bin\ppc386.exe -Sg %s.pas';
    Executable:='%s.exe';
  end;
  with Judge.Settings.Compilers.Add do begin
    Active:=true;
    Title:='TPC (DOS)';
    Extension:='pas';
    commandLine:=cpPath+'bin\tpc.exe %s.pas';
    Executable:='%s.exe';
  end;
  with Judge.Settings.Compilers.Add do begin
    Active:=true;
    Title:='GCC (mingw32)';
    Extension:='c';
    commandLine:=cpPath+'bin\gcc.exe %s.c -o %s.exe';
    Executable:='%s.exe';
  end;
  with Judge.Settings.Compilers.Add do begin
    Active:=true;
    Title:='G++ (mingw32)';
    Extension:='cpp';
    commandLine:=cpPath+'bin\g++.exe %s.cpp -o %s.exe';
    Executable:='%s.exe';
  end;
  with Judge.Settings.Compilers.Add do begin
    Active:=true;
    Title:='EXE';
    Extension:='exe';
    commandLine:='';
    Executable:='%s.exe';
  end;

  Judge.Settings.Save;
end;

end.
