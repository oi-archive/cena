unit ojrc;

interface

uses
  ojtc, sysutils, ojconst, windows, libxml2;

type

  TTestCaseResult=class
  private
    FPreviousTestCaseResult,FNextTestCaseResult: TTestCaseResult;
    FStatus:integer;
    FScore:double;
//    FFullScore:double;
    FTimeLimit:double;
    FMemoryLimit:integer;
    FTime:double;
    FMemory:integer;
    FExitCode:cardinal;
    FDetail:string;

  public
    property Status:integer read FStatus write FStatus;
    property Score:double read FScore write FScore;
    property TimeLimit:double read FTimeLimit write FTimeLimit;
    property MemoryLimit:integer read FMemoryLimit write FMemoryLimit;
    property Time:double read FTime write FTime;
    property Memory:integer read FMemory write FMemory;
    property ExitCode:Cardinal read FExitCode write FExitCode;
    property Detail:string read FDetail write FDetail;
  end;

  TTestCaseResults=class
  private
    FFirstTestCaseResult,FLastTestCaseResult: TTestCaseResult;
    FCount: integer;
    function GetItem(index: integer): TTestCaseResult;
//    procedure SetCount(ACount: integer);
  public
    property Items[index: integer]: TTestCaseResult read GetItem;
    property Count: integer read FCount{ write SetCount};
    procedure Delete(node: TTestCaseResult);
    function Add: TTestCaseResult;
    destructor Destroy; override;
  end;  

  TProblemResult=class
  private
    FPreviousProblemResult,FNextProblemResult: TProblemResult;
    FStatus:integer;
    FExitCode:integer;
    FTitle:widestring;
    FFileName:TFileName;
    FHash: cardinal;
    FDetail:widestring;

    FTestCaseResults:TTestCaseResults;
    function GetScore:double;
    function GetTime:double;
  public
    property Title:widestring read FTitle write FTitle;
    property FileName:TFileName read FFileName write FFileName;
    property Status:integer read FStatus write FStatus;
    property ExitCode:integer read FExitCode write FExitCode;
    property Hash:cardinal read FHash write FHash;
    property Detail:widestring read FDetail write FDetail;
    property Score:double read GetScore;
    property Time:double read GetTime;
    property TestCaseResults:TTestCaseResults read FTestCaseResults write FTestCaseResults;
    constructor Create;
    destructor Destroy; override;
  end;

  TProblemResults=class
  private
    FFirstProblemResult,FLastProblemResult:TProblemResult;
    FCount:integer;
    function GetItem(index: integer): TProblemResult;
//    procedure SetCount(ACount: integer);
  public
    property Items[index: integer]: TProblemResult read GetItem;
    property Count: integer read FCount{ write SetCount};
    procedure Delete(node: TProblemResult);
    function Add: TProblemResult;
    destructor Destroy; override;
  end;

  TPeopleResult=class
  private
    FName:widestring;
    FProblemResults:TProblemResults;
    FJudgeTime:TDateTime;
    function GetScore:double;
    function GetTime:double;
  public
    property Name: widestring read FName write FName;
    property JudgeTime: TDateTime read FJudgeTime write FJudgeTime;
    property ProblemResults:TProblemResults read FProblemResults write FProblemResults;
    property Score:double read GetScore;
    property Time:double read GetTime;
    procedure LoadFromFile(FileName:string);
    procedure SaveToFile(FileName:string);
    procedure Adjust(Contest:TContest);
    constructor Create;
    destructor Destroy; override;
    procedure Load(PeopleName: widestring); overload;
    procedure Save(PeopleName: widestring);
    procedure Load(People: TPeople); overload;
  end;

implementation


constructor TProblemResult.Create;
begin
  inherited Create;
  TestCaseResults:=TTestCaseResults.Create;
end;

destructor TProblemResult.Destroy;
begin
  TestCaseResults.Destroy;
  inherited Destroy;
end;

function TProblemResult.GetScore;
var
  i:integer;
begin
  result:=0;
  for i:=0 to self.TestCaseResults.Count-1 do
    Result:=Result+self.TestCaseResults.Items[i].Score;
end;


function TProblemResult.GetTime;
var
  i:integer;
begin
  result:=0;
  for i:=0 to self.TestCaseResults.Count-1 do
    if TestCaseResults.Items[i].Status in [ST_CORRECT,ST_PART_CORRECT] then
      Result:=Result+self.TestCaseResults.Items[i].Time;
end;

function TPeopleResult.GetScore:double;
var
  i:integer;
begin
  result:=0;
  for i:=0 to self.ProblemResults.Count-1 do
    result:=result+self.ProblemResults.Items[i].Score;
end;

function TPeopleResult.GetTime:double;
var
  i:integer;
begin
  result:=0;
  for i:=0 to self.ProblemResults.Count-1 do
    result:=result+self.ProblemResults.Items[i].Time;
end;

procedure TPeopleResult.LoadFromFile(FileName:string);
var
  doc: xmlDocPtr;
  root, cont, prob, node, node2, test: xmlNodePtr;
  prop: xmlAttrPtr;
  i, j, k: integer;
begin
  doc:=xmlParseFile(pchar({UTF8Encode}(FileName)));
  if doc=nil then
    doc:=xmlNewDoc('1.0')
  else begin
    root:=xmlDocGetRootElement(doc);
    if root.name='cena' then begin
      cont:=root.children;
      while cont<>nil do begin
        if cont.name='result' then begin
          JudgeTime:=strtofloat(libxml2.xmlGetProp(cont,'judgetime'));

          prob:=cont.children;
          while prob<>nil do
            if prob.name='problem' then begin
              with ProblemResults.Add do begin
                Title:=UTF8Decode(libxml2.xmlGetProp(prob,'title'));
                FileName:=UTF8Decode(libxml2.xmlGetProp(prob,'filename'));
                Status:=StrToIntDef(xmlGetProp(prob,'status'),0);
                Hash:=StrToInt64Def(xmlGetProp(prob,'hash'),0);
                Detail:=UTF8Decode(xmlGetProp(prob,'detail'));
                node:=prob.children;
                while node<>nil do begin
                  if node.name='testcase' then begin
                    with TestCaseResults.Add do begin
                      node2:=node.children;
                      Status:=StrToIntDef(xmlGetProp(node,'status'),0);
                      ExitCode:=StrToInt64Def(xmlGetProp(node,'exitcode'),0);
                      Detail:=utf8decode(xmlGetProp(node,'detail'));
                      Score:=strtofloat(xmlGetProp(node,'score'));
                      Time:=strtofloat(xmlGetProp(node,'time'));
                      Memory:=StrToIntDef(xmlGetProp(node,'memory'),0);
                    end;
                  end;
                  node:=node.next;
                end;
              end;
            prob:=prob.next;
          end;
        end;
        cont:=cont.next;
      end;
    end;
  end;
  xmlFreeDoc(doc);
end;

procedure TPeopleResult.SaveToFile(FileName:string);
var
  doc: xmlDocPtr;
  root, cont, curprob, curfile, curtest: xmlNodePtr;
  i, j, k: integer;
begin
  doc:=xmlNewDoc('1.0');
//  doc.compression:=9;
//  doc.encoding:='utf-8';
  root:=xmlNewNode(nil, 'cena');
  xmlDocSetRootElement(doc, root);

  xmlNewProp(root,'version',ProductVersion);

  cont:=xmlNewChild(root, nil, 'result', nil);
  xmlNewProp(cont, 'judgetime', pchar(UTF8Encode(floattostr(JudgeTime))));

  for i:=0 to ProblemResults.Count-1 do
    with ProblemResults.Items[i] do begin
      curprob:=xmlNewChild(cont, nil, 'problem', nil);
      xmlNewProp(curprob, 'title', pchar(UTF8Encode(Title)));
      xmlNewProp(curprob, 'filename', pchar(UTF8Encode(FileName)));
      xmlNewProp(curprob, 'status', pchar(inttostr(Status)));
      xmlNewProp(curprob, 'hash', pchar(inttostr(Hash)));
      xmlNewProp(curprob, 'detail', pchar(UTF8Encode(Detail)));

      for j:=0 to TestCaseResults.Count-1 do
        with TestCaseResults.Items[j] do begin
          curtest:=xmlNewChild(curprob, nil, 'testcase', nil);
          xmlNewProp(curtest, 'status', pchar(inttostr(Status)));
          xmlNewProp(curtest, 'exitcode', pchar(inttostr(ExitCode)));
          xmlNewProp(curtest, 'detail', pchar(utf8encode(Detail)));
          xmlNewProp(curtest, 'time', pchar(floattostr(Time)));
          xmlNewProp(curtest, 'memory', pchar(floattostr(Memory)));
          xmlNewProp(curtest, 'score', pchar(floattostr(Score)));
        end;
  end;
  xmlSaveFile(pchar({UTF8Encode}(FileName)), doc);
  xmlFreeDoc(doc);
end;

procedure TPeopleResult.Adjust(Contest:TContest);
var
  i:integer;
begin

  while ProblemResults.Count<Contest.Problems.Count do
    ProblemResults.Add;
  while ProblemResults.Count>Contest.Problems.Count do
    ProblemResults.Delete(ProblemResults.FLastProblemResult);

  for i:=0 to Contest.Problems.Count-1 do begin
    with ProblemResults.Items[i] do begin
//      FTitle:=Contest.Problems.Items[i].Title;
//      FFileName:=Contest.Problems.Items[i].FileName;

      while TestCaseResults.Count<Contest.Problems.Items[i].TestCases.Count do
        TestCaseResults.Add;
      while TestCaseResults.Count>Contest.Problems.Items[i].TestCases.Count do
        TestCaseResults.Delete(TestCaseResults.FLastTestCaseResult);

    end;
  end;
end;

function TProblemResults.Add: TProblemResult;
begin
  Result:=TProblemResult.Create;
  if assigned(FLastProblemResult) then begin
    Result.FPreviousProblemResult:=FLastProblemResult;
    FLastProblemResult.FNextProblemResult:=Result;
    FLastProblemResult:=Result;
  end
  else begin
    FFirstProblemResult:=Result;
    FLastProblemResult:=Result;
  end;
  inc(FCount);
end;

procedure TProblemResults.Delete(node: TProblemResult);
begin
  if node.FPreviousProblemResult=nil then
    FFirstProblemResult:=node.FNextProblemResult;
  if node.FNextProblemResult=nil then
    FLastProblemResult:=node.FPreviousProblemResult;
  if node.FPreviousProblemResult<>nil then
    node.FPreviousProblemResult.FNextProblemResult:=node.FNextProblemResult;
  if node.FNextProblemResult<>nil then
    node.FNextProblemResult.FPreviousProblemResult:=node.FPreviousProblemResult;
  node.Destroy;
  dec(FCount);
end;

destructor TProblemResults.Destroy;
begin
  while Count>0 do
    Delete(Items[0]);
  inherited Destroy;
end;

function TProblemResults.GetItem(index: integer): TProblemResult;
begin
  Result:=FFirstProblemResult;
  while index>0 do begin
    dec(index);
    Result:=Result.FNextProblemResult;
  end;
end;

function TTestCaseResults.Add: TTestCaseResult;
begin
  Result:=TTestCaseResult.Create;
  if assigned(FLastTestCaseResult) then begin
    Result.FPreviousTestCaseResult:=FLastTestCaseResult;
    FLastTestCaseResult.FNextTestCaseResult:=Result;
    FLastTestCaseResult:=Result;
  end
  else begin
    FFirstTestCaseResult:=Result;
    FLastTestCaseResult:=Result;
  end;
  inc(FCount);
end;

procedure TTestCaseResults.Delete(node: TTestCaseResult);
begin
  if node.FPreviousTestCaseResult=nil then
    FFirstTestCaseResult:=node.FNextTestCaseResult;
  if node.FNextTestCaseResult=nil then
    FLastTestCaseResult:=node.FPreviousTestCaseResult;
  if node.FPreviousTestCaseResult<>nil then
    node.FPreviousTestCaseResult.FNextTestCaseResult:=node.FNextTestCaseResult;
  if node.FNextTestCaseResult<>nil then
    node.FNextTestCaseResult.FPreviousTestCaseResult:=node.FPreviousTestCaseResult;
  node.Destroy;
  dec(FCount);
end;

destructor TTestCaseResults.Destroy;
begin
  while Count>0 do
    Delete(Items[0]);
  inherited Destroy;
end;

function TTestCaseResults.GetItem(index: integer): TTestCaseResult;
begin
  Result:=FFirstTestCaseResult;
  while index>0 do begin
    dec(index);
    Result:=Result.FNextTestCaseResult;
  end;
end;
{
procedure TProblemResults.SetCount(ACount: integer);
begin
  while Count<ACount do
    Add;
  while Count>ACount do
    Delete(FLastProblemResult);
end;

procedure TTestCaseResults.SetCount(ACount: integer);
begin
  while Count<ACount do
    Add;
  while Count>ACount do
    Delete(FLastTestCaseResult);
end;
}
constructor TPeopleResult.Create;
begin
  inherited Create;
  ProblemResults:=TProblemResults.Create;
end;

destructor TPeopleResult.Destroy;
begin
  ProblemResults.Destroy;
  inherited Destroy;
end;

procedure TPeopleResult.Load(PeopleName: widestring);
begin
  LoadFromFile(Judge.Contest.Path+'\src\'+PeopleName+'\result.xml');
end;

procedure TPeopleResult.Save(PeopleName: widestring);
begin
  SaveToFile(Judge.Contest.Path+'\src\'+PeopleName+'\result.xml');
end;

procedure TPeopleResult.Load(People: TPeople);
begin
  LoadFromFile(People.Path+'\result.xml');
end;

end.

