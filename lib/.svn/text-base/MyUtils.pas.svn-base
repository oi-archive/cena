unit MyUtils;

interface

uses
  Windows, Classes, ShlObj, math, SysUtils;


function RandomString(Len:integer):string;

function BrowseforFile(Handle : THandle; Title : String; Filename : String;  DefaultPath : string) : String;
//function CustomSortProc(Item1, Item2: TListItem; ParamSort: Integer): Integer; stdcall;
function TrimW(S: string): string;

procedure DelDir(APath: widestring; RemoveSelf: boolean);
function FloatNum(s: string): string;
function ExtractFileNameW(const FileName: widestring): widestring;

implementation

function ExtractFileNameW(const FileName: widestring): widestring;
var
  i:integer;
begin
  i:=length(FileName);
  while (i>0) and (FileName[i]<>'\') do
    dec(i);
  Result:=copy(FileName,i+1,maxint);
end;


procedure DelDir(APath: widestring; RemoveSelf: boolean);
var
  ffd:TWin32FindDataW;
  FileName: widestring;
  hFile:dword;
begin
  hFile:=FindFirstFileW(pwidechar(APath+'\*'),ffd);
  if hFile<>INVALID_HANDLE_VALUE then begin
    repeat
      FileName:=ffd.cFileName;
      if (FileName<>'.') and (FileName<>'..') then begin
        if (ffd.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY>0) then
          deldir(APath+'\'+ffd.cFileName,true)
        else begin
          SetFileAttributesW(pwidechar(APath+'\'+FileName),FILE_ATTRIBUTE_ARCHIVE);
          windows.DeleteFileW(pwidechar(APath+'\'+FileName));
        end;
      end;
    until not FindNextFileW(hFile,ffd);
    windows.FindClose(hFile);
  end;
  if RemoveSelf then
    RemoveDirectoryW(pwidechar(APath));
end;



function TrimW(S: string): string;
begin
  Result:=S;
  while (Result<>'') and (Result[1]=' ') do
    Delete(Result,1,1);
  while (Result<>'') and (Result[length(result)]=' ') do
    Delete(Result,length(result),1);
end;



function BrowseCallBack ( Hwnd : THandle; uMsg : UINT; lpParam, lpData : LPARAM): integer; stdcall;
var
  Buffer : Array[0..255] of char;
  Buffer2 : Array[0..255] of char;
begin
  // Initialize buffers
  FillChar(Buffer,SizeOf(Buffer),#0);
  FillChar(Buffer2,SizeOf(Buffer2),#0);

  // Statusline text
//  TmpStr := 'Locate folder containing '+StrPas(PChar(lpData));

  // Copy statustext to pchar
//  StrPCopy(Buffer2,TmpStr);

  // Send message to BrowseForDlg that
  // the status text has changed
  SendMessage(hwnd,BFFM_SETSTATUSTEXT,0,Integer(@Buffer2));

  // If directory in BrowswForDlg has changed ?
  if uMsg = BFFM_SELCHANGED then begin
    // Get the new folder name
    SHGetPathFromIDList(PItemIDList(lpParam),Buffer);
    // And check for existens of our file.
      if StrLen(Buffer) <> 0 then
        if Buffer[StrLen(Buffer)-1] = '\' then
          Buffer[StrLen(Buffer)-1] := #0;
      if (StrLen(Buffer)>0) and (FileExists(StrPas(@Buffer)+'\'+StrPas(PChar(lpData))) or
         (StrLen(PChar(lpData)) = 0)) then
      // found : Send message to enable OK-button
      SendMessage(hwnd,BFFM_ENABLEOK,1,1)
    else
      // Send message to disable OK-Button
      SendMessage(Hwnd,BFFM_ENABLEOK,0,0);
  end;
  result := 0;
end;


function BrowseforFile(Handle : THandle; Title : String; Filename : String;  DefaultPath : string) : String;
var
  BrowseInfo : TBrowseInfo;
  RetBuffer,
  FName,
  ResultBuffer : Array[0..255] of char;
  PIDL : PItemIDList;
begin
  StrPCopy(Fname,FileName);

  //Initialize buffers
  FillChar(BrowseInfo,SizeOf(TBrowseInfo),#0);
  Fillchar(RetBuffer,SizeOf(RetBuffer),#0);
  FillChar(ResultBuffer,SizeOf(ResultBuffer),#0);

  BrowseInfo.hwndOwner := Handle;
  BrowseInfo.pszDisplayName := @Retbuffer;
  if Title='' then
    BrowseInfo.lpszTitle:=nil
  else
    BrowseInfo.lpszTitle := @Title[1];

  BrowseInfo.ulFlags := BIF_RETURNONLYFSDIRS or BIF_NEWDIALOGSTYLE {or $0200};

  // Our call-back function cheching for fileexist
  BrowseInfo.lpfn := @BrowseCallBack;
  BrowseInfo.lParam := Integer(@FName);

//  browseinfo.pidlRoot:=SHSimpleIDListFromPath('c:\');
  // Show BrowseForDlg
  PIDL := SHBrowseForFolder(BrowseInfo);

  // Return fullpath to file
  if SHGetPathFromIDList(PIDL,ResultBuffer) then
    result := StrPas(ResultBuffer)
  else
    Result := '';

  GlobalFreePtr(PIDL);  //Clean up
end;

function RandomString(Len:integer):string;
var
  i:integer;
begin
  Result:='';
  for i:=1 to Len do
    Result:=Result+chr(Random(26)+65);
end;


function FloatNum(s: string): string;
var
  i: integer;
  x: integer;
begin
  x:=0;
  for i:=Length(s) downto 1 do
    if (s[i]<'0')or(s[i]>'9') then
      if s[i]='.' then
        if x=0 then inc(x)
        else delete(s,i,1)
      else delete(s,i,1);
  Result:=s;
end;


end.

