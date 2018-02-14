unit AutoUpdateU;

interface

uses
  Windows, Forms, Messages, Classes, SysUtils, IdHTTP, ojconst, JvGnugettext,
  MainFormU, shellapi, JvCipher;

type
  TAutoUpdateThread = class(TThread)
  protected
    procedure Execute; override;
  end;
    
implementation

procedure TAutoUpdateThread.Execute;
var
  http: TIdHTTP;
  s: string;
  ok: boolean;
  sleeptime: integer;
begin
  sleeptime := 1000;
  while true do begin
    http:=TIdHTTP.Create(nil);
    ok:=false;
    try
      s:=http.Get(AutoUpdateScript[random(2)]+'?version='+ProductVersion+'&lang='+GetCurrentLanguage);
      ok:=true;
    except
    end;
    http.Free;
    if ok and (pos('CENA_AUTOUPDATE_BEGIN', s)>0) and (pos('CENA_AUTOUPDATE_END', s)>0) then
      break;
    Sleep(sleeptime);
    if sleeptime < 30000 then
      inc(sleeptime, 1000);
  end;
  if pos(ProductVersionCode8, s)=0 then
    {Synchronize(}MainForm.PromptNewVersion;
end;


var
  autoupdatethread: TAutoUpdateThread;

initialization
  autoupdatethread:=TAutoUpdateThread.Create(false);
end.
