unit ojcount;

interface

type

  TTestcaseRes = class
    MaxScore: double;
    AverageScore: double;
    TotalScore: double;
  end;


  TProblemRes = class
    MaxScore: double;
    AverageScore: double;
    TotalScore: double;

    Count: integer;
    Item: array of TTestCaseRes;
    procedure SetCount(NCount: integer);
    destructor Destroy; override;
  end;


  TContestRes = object
    Count: integer;
    Item: array of TProblemRes;
    procedure SetCount(NCount: integer);
    procedure Destroy;
  end;

  TPeopleRes = object
    TotalScore: double;
    EffectiveTime: double;
  end;


implementation

procedure TProblemRes.SetCount(NCount: integer);
var
  i: integer;
begin
  for i:=0 to Count-1 do Item[i].Destroy;
  FreeMem(Item);
  Count:=NCount;
  SetLength(Item,NCount);
  for i:=0 to NCount-1 do begin
    Item[i]:=TTestcaseRes.Create;
  end;
end;

destructor TProblemRes.Destroy;
var
  i: integer;
begin
  for i:=0 to Count-1 do
    Item[i].Destroy;
  SetLength(Item,0);
  Count:=0;
  inherited Destroy;
end;


procedure TContestRes.SetCount(NCount: integer);
var
  i: integer;
begin
  for i:=0 to Count-1 do Item[i].Destroy;
  FreeMem(Item);
  Count:=NCount;
  SetLength(Item,NCount);
  for i:=0 to NCount-1 do begin
    Item[i]:=TProblemRes.Create;
  end;
end;

procedure TContestRes.Destroy;
var
  i: integer;
begin
  for i:=0 to Count-1 do
    Item[i].Destroy;
  SetLength(Item,0);
  Count:=0;
end;


end.
