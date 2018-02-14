unit MyTypes;

interface

uses
  ComObj, sysutils, Windows, MyUtils, Variants, Classes, inifiles,
  ComCtrls, Forms, Menus, ojtc, ojrc, ojconst;

type

  TTask=class
    People: TPeople;
    ProblemID:integer;    // -1 is all
    OnlyJudgeChanged:boolean;
  end;

  TQueueNode=class
  private
    FNext:TQueueNode;
    FData:Pointer;
    function GetNextNode:TQueueNode;
  public
    property Next:TQueueNode read GetNextNode write FNext;
    property Data:Pointer read FData write FData;
  end;

  TQueue=class
  private
    FFirst,FLast:TQueueNode;
    FCount: integer;
    function FIsEmpty:boolean;
  public
    property FirstNode:TQueueNode read FFirst;
    property Empty:boolean read FIsEmpty;
    property Count:integer read FCount;
    procedure Add(Data:Pointer);
    procedure DeleteFirstNode;
    procedure Clear;
    destructor Destroy; override;
  end;

implementation

//uses MainFormU;


procedure Next_File(var s: string);
var i,j,k: integer;
    t,t1,head: string;
begin
  for i:=Length(s) downto 1 do if s[i]='\' then break;
  head:=copy(s,1,i);
  system.Delete(s,1,i);

  for i:=Length(s) downto 1 do
    if s[i] in ['0'..'9'] then begin
      for j:=i downto 1 do
        if not(s[j] in['0'..'9']) then break;
      if j<1 then j:=1;
      if not(s[j] in['0'..'9']) then inc(j);
      t:=copy(s,j,i-j+1);
      k:=strtoint(t);
      inc(k);
      t1:=inttostr(k);
      while length(t1)<length(t) do t1:='0'+t1;
      s:=copy(s,1,j-1)+t1+copy(s,i+1,Length(s)-i);
      s:=head+s;
      exit;
    end;

  for i:=Length(s) downto 1 do if s[i]='.' then break;
  if (i>=1)and(Length(s)-i>=3) then system.Delete(s,Length(s),1);
  s:=s+'1';
  s:=head+s;
end;

procedure NextFiles(var s: string);
var t,p: string;
    i: integer;
begin
  s:=s+#13#10;
  t:='';
  while Length(s)>0 do begin
    i:=pos(#13#10,s);
    p:=copy(s,1,i-1);
    delete(s,1,i+1);
    Next_File(p);
    t:=t+#13#10+p;
  end;
  system.Delete(t,1,2);
  s:=t;
end;



function TQueueNode.GetNextNode:TQueueNode;
begin
  if not Assigned(FNext) then
    FNext:=TQueueNode.Create;
  Result:=FNext;
end;

procedure TQueue.Add(Data:Pointer);
begin
  if not Assigned(FFirst) then begin
    FFirst:=TQueueNode.Create;
    FLast:=FFirst;
  end
  else
    FLast:=FLast.Next;
  FLast.Data:=Data;
  inc(FCount);
end;

function TQueue.FIsEmpty;
begin
  Result:=not Assigned(FFirst);
end;

procedure TQueue.DeleteFirstNode;
var
  P:TQueueNode;
begin
  P:=FFirst;
  FFirst:=FFirst.FNext;
  P.Free;
  dec(FCount)
end;

procedure TQueue.Clear;
begin
  while Assigned(FFirst) do begin
    TTask(FFirst.FData).People.Status:=PS_UNKNOWN;
///    MainForm.RefreshPeople(TTask(FFirst.FData).People);
    DeleteFirstNode;
  end;
  FCount:=0;
end;

destructor TQueue.Destroy;
begin
  Clear;
  inherited Destroy;
end;

end.

