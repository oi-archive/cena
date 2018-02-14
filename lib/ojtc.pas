unit ojtc;

interface

uses
  sysutils, classes, libxml2, windows, myutils, libojcd, ojconst, jvgnugettext,
  registry;          
                  
type

  TProblemType=(ptNormal,ptSubmit);
  TCompareType=(ctText,ctBinary,ctCustom);

  TPeople=class;
  TProblem=class;

  TClient=class
  private
    FNextClient, FPreviousClient: TClient;
    FIP: string;
    FInfo: TClientInfo;
    FLastActive: Cardinal;
    FData: pointer;
    FPeople: TPeople;
  public
    property IP: string read FIP write FIP;
    property Info: TClientInfo read FInfo write FInfo;
    property LastActive: Cardinal read FLastActive write FLastActive;
    property People: TPeople read FPeople write FPeople;
    property Data: pointer read FData write FData;
  end;

  TFile=class
  private
    FNextFile,FPreviousFile:TFile;
    FFileName:widestring;
  public
    property FileName:widestring read FFileName write FFileName;
    destructor Destroy; override;
  end;

  TFiles=class
  private
    FFirstFile,FLastFile:TFile;
    FCount:integer;
    procedure SetCount(ACount: integer);
    function GetItem(index: integer): TFile;
  public
    property Count:integer read FCount write SetCount;
    property Items[index: integer]: TFile read GetItem; default;
    function Add: TFile;
    destructor Destroy; override;
    procedure Delete(node: TFile);
  end;

  TArrInteger=class
  private
    FCount: integer;
    procedure SetCount(ACount: integer);
  public
    Items: array of integer;
    property Count: integer read FCount write SetCount;
    destructor Destroy; override;
  end;


  TClientIDNode=class
    ClientID: TClientID;
    Next,Previous: TClientIDNode;
  end;

  TClientIDList=class
  private
    FCount: integer;
  public
    Head,Rear: TClientIDNode;
    property Count: integer read FCount;
    procedure DeleteHead;
    procedure AddToRear(AClientID: TClientID);
    destructor Destroy; override;
  end;

  TTestCase=class
  private
    FPreviousTestCase,FNextTestCase: TTestCase;
    FInputs: TFiles;
    FOutput: TFile;
    FTimeLimit: double;
    FMemoryLimit: Cardinal;
    FScore: double;
  public
    property PreviousTestCase: TTestCase read FPreviousTestCase;
    property NextTestCase: TTestCase read FNextTestCase;
    property Inputs: TFiles read FInputs;
    property Output: TFile read FOutput write FOutput;
    property TimeLimit: double read FTimeLimit write FTimeLimit;
    property MemoryLimit: cardinal read FMemoryLimit write FMemoryLimit;
    property Score: double read FScore write FScore;
    constructor Create;
    procedure AutoNext(Problem: TProblem);
    destructor Destroy; override;
  end;

  TTestCases=class
  private
    FFirstTestCase,FLastTestCase: TTestCase;
    FCount: integer;
    procedure SetCount(ACount: integer);
    function GetItem(index: integer): TTestCase;
  public
//    property FirstTestCase: TTestCase read FFirstTestCase;
//    property LastTestCase: TTestCase read FLastTestCase;
    property Count: integer read FCount write SetCount; // !!!
    property Items[index: integer]: TTestCase read GetItem; default;
    function Add: TTestCase;
    procedure Delete(index: integer); overload;
    procedure Delete(node: TTestCase); overload;
    destructor Destroy; override;
  end;

  TProblem=class
  private
//    FProblemType: TProblemType;
    FTitle,FFileName: string;
    FInputs: TFiles;
    FOutput: TFile;
    FCompareType: integer;
    FCustomCompareFile: TFileName;
    FLibraries: TFiles;
    FPreviousProblem,FNextProblem: TProblem;
    FTestCases:TTestCases;
    FIsSubmit:boolean;
    function GetTotalScore: double;
//    function GetTotalTime: cardinal;
  public
//    property ProblemType:TProblemType read FProblemType write FProblemType default ptNormal;
    property PreviousProblem: TProblem read FPreviousProblem;
    property NextProblem: TProblem read FNextProblem;
    property TestCases:TTestCases read FTestCases;
    property Title: string read FTitle write FTitle;
    property FileName: string read FFileName write FFileName;
    property Inputs: TFiles read FInputs write FInputs;
    property Output: TFile read FOutput write FOutput;
    property CompareType: integer read FCompareType write FCompareType;
    property CustomCompareFile: TFileName read FCustomCompareFile write FCustomCompareFile;
    property Libraries: TFiles read FLibraries write FLibraries;
    property Score: double read GetTotalScore;
    property IsSubmit: boolean read FIsSubmit write FIsSubmit;
//    property Time: cardinal read GetTotalTime;
//    procedure Clear;
    constructor Create;
    destructor Destroy; override;
  end;

  TProblems=class
  private
    FFirstProblem,FLastProblem:TProblem;
    FCount:integer;
    function GetItem(index:integer):TProblem;
    procedure SetCount(ACount:integer);
  public
    property Items[index: integer]: TProblem read GetItem; default;
    property Count:integer read FCount write SetCount;
    function Add: TProblem;
    procedure Delete(index: integer); overload;
    procedure Delete(node: TProblem); overload;
    procedure Clear;
    destructor Destroy; override;
  end;

  TPeople=class
  private
    FPreviousPeople,FNextPeople: TPeople;
    FName: widestring;
    FStatus: integer;
    FResultWnd: pointer;
    FPropWnd: pointer;
    FData1, FData2: pointer;
    FClient: TClient;
    FPercent: integer;
    function GetStatus: integer;
    function GetPath: widestring;
    function GetLocationStr: string;
  public
    property Name: widestring read FName write FName;
    property Data1: pointer read FData1 write FData1;
    property Data2: pointer read FData2 write FData2;
    property Status: integer read GetStatus write FStatus;
    property LocationStr: string read GetLocationStr;
    property ResultWnd: pointer read FResultWnd write FResultWnd;
    property PropWnd: pointer read FPropWnd write FPropWnd;
    property Percent: integer read FPercent write FPercent;
    property Client: TClient read FClient write FClient;
    property Path: widestring read GetPath;
    function HasLocalFolder: boolean;
    function HasResult: boolean;
    function CollectTime: TDateTime;
  end;

  TPeoples=class
  private
    FFirstPeople,FLastPeople: TPeople;
    FCount: integer;
    FData: pointer;
    function GetItem(index: integer): TPeople;
  public
    property Count: integer read FCount write FCount;
    property Items[index: integer]:TPeople read GetItem;
    property Data:pointer read FData write FData;
    function Add: TPeople;
    procedure Delete(node: TPeople);
    procedure ClearLocal;
    procedure Refresh;
    function FindName(APeopleName: widestring): TPeople;
    destructor Destroy; override;
    procedure Clear;
  end;


  TContest=class
  private
    FLastError: cardinal;
    FTitle,FJuror: widestring;
    FPath:widestring;
    FProblems:TProblems;
    FPeoples:TPeoples;
    FIsOpen:boolean;
    FOnOpening:TNotifyEvent;
    FOnOpen:TNotifyEvent;
    FOnClose:TNotifyEvent;
    function GetScore: double;
  public
    property LastError: cardinal read FLastError;
    property Title: widestring read FTitle write FTitle;
    property Juror: widestring read FJuror write FJuror;
    property Path: widestring read FPath;
    property Problems:TProblems read FProblems write FProblems;
    property Peoples:TPeoples read FPeoples write FPeoples;
    property Score:double read GetScore;
    property IsOpen:boolean read FIsOpen write FIsOpen;
    property OnOpening:TNotifyEvent read FOnOpening write FOnOpening;
    property OnOpen: TNotifyEvent read FOnOpen write FOnOpen;
    property OnClose: TNotifyEvent read FOnClose write FOnClose;
    constructor Create;
    function LoadFromFile(FileName: TFileName):cardinal;
    function SaveToFile(FileName:  TFileName):cardinal;
    function New(APath, ATitle, AJuror:string): cardinal;
    procedure Open(APath:string);
    procedure Close;
    destructor Destroy; override;
    function Save:cardinal;
  end;

  ptagCompiler=^tagCompiler;
  tagCompiler=record
    Active:boolean;
    Title,Extension:string;
    CommandLine:TFileName;
    Executable:TFileName;
  end;

  TCompiler=class
  private
    FNextCompiler,FPreviousCompiler:TCompiler;
    FActive:boolean;
    FTitle:string;
    FCommandLine:TFileName;
    FExecutable:TFileName;
    FExtension:string;
  public
    property Active:boolean read FActive write FActive;
    property Title:string read FTitle write FTitle;
    property Extension: string read FExtension write FExtension;
    property CommandLine:TFileName read FCommandLine write FCommandLine;
    property Executable:TFileName read FExecutable write FExecutable;
    procedure MoveFrom(P: ptagCompiler);
    function CopyTo: ptagCompiler;
  end;

  TCompilers=class
  private
    FFirstCompiler,FLastCompiler:TCompiler;
    FCount: integer;
    function GetItem(index: integer): TCompiler;

  public
    procedure Save(node: xmlNodePtr);
    procedure Load(node: xmlNodePtr);
    property Count:integer read FCount;
    procedure Clear;
    function Add: TCompiler;
    property Items[index:integer]:TCompiler read GetItem;
    destructor Destroy; override;
  end;

  TFileNameArray=array[0..7] of TFileName;
{
  TRecents=class
  private
    FItems:TFileNameArray;
    FCount:integer;
  public
    property Items:TFileNameArray read FItems write FItems;
    property Count:integer read FCount;
    procedure Add(APath: TFileName);
  end;
}
  TClients=class
  private
    FFirstClient,FLastClient: TClient;
    FCount: integer;
    function GetItem(index: integer): TClient;
  public
    property Items[index: integer]:TClient read GetItem;
    property Count:integer read FCount;
    function Add: TClient;                                 // add to the rear
    function FindIP(const IP: string): TClient;
    procedure Delete(node: TClient);
    function FindName(const Name: string): TClient;
    function FindClientID(const ClientID: TClientID): TClient;
    destructor Destroy; override;
  end;

  TRecents=class(TFiles)
  private
    FMaxCount: integer;
    procedure SetMaxCount(AMaxCount: integer);
  public
    procedure Load(node: xmlNodePtr);
    procedure Save(node: xmlNodePtr);
    procedure Add(APath: widestring); overload;
    property MaxCount: integer read FMaxCount write SetMaxCount;
    procedure Delete(Index: integer); overload;
    constructor Create;
  end;

  TNormalSetting=class
  private
    FCollectFileCorrelative,FCollectExtCorrelative: boolean;
    FFileSizeLimitB: boolean;
    FFileSizeLimit: int64;  // 单位 字节
    FDefaultScore: integer; // 单位 分
    FDefaultMemL: int64;    // 单位 K字节
    FDefaultTimeL: double;  // 单位 秒
    FLanguage: string;
  public
    procedure SetDefaultData;
    procedure Save(node: xmlNodePtr);
    procedure Load(node: xmlNodePtr);
    property CollectFileCorrelative: boolean read FCollectFileCorrelative write FCollectFileCorrelative;
    property CollectExtCorrelative: boolean read FCollectExtCorrelative write FCollectExtCorrelative;
    property FileSizeLimitB: boolean read FFileSizeLimitB write FFileSizeLimitB;
    property FileSizeLimit: int64 read FFileSizeLimit write FFileSizeLimit;
    property DefaultScore: integer read FDefaultScore write FDefaultScore;
    property DefaultMemL: int64 read FDefaultMemL write FDefaultMemL;
    property DefaultTimeL: double read FDefaultTimeL write FDefaultTimeL;
    property Language: string read FLanguage write FLanguage;
    procedure AdJust;
    constructor Create;
  end;

  TColWidth=class
  private
    FCount: integer;
    FWidth: array of integer;
    procedure SetCount(ACount: integer);
    function ReadWidth(Index: integer): integer;
    procedure WriteWidth(Index: integer;  AWidth: integer);
  public
    DefaultWidth: integer;
    procedure Save(node: xmlNodePtr);
    procedure Load(node: xmlNodePtr);
    property Width[Index: integer]: integer read ReadWidth write WriteWidth;
    property Count: integer read FCount write SetCount;
    procedure AdJust;
    constructor Create(ColCount: integer);
  end;


  TWindowSetting=class
  private
    FN18Checked: boolean;
    FB1Checked: boolean;
    FLeft,FTop,FHeight,FWidth,FNWidth,FNHeight: integer;
    FLv1ColWidth,FPeopleVColWidth,FNLv1ColWidth: TColWidth;
    FWinMaxSize: boolean;
  public
    procedure SetDefaultData;
    procedure Save(node: xmlNodePtr);
    procedure Load(node: xmlNodePtr);
    property N18Checked: boolean read FN18Checked write FN18Checked;
    property B1Checked: boolean read FB1Checked write FB1Checked;
    property Left: integer read FLeft write FLeft;
    property Top: integer read FTop write FTop;
    property Height: integer read FHeight write FHeight;
    property Width: integer read FWidth write FWidth;
    property NHeight: integer read FNHeight write FNHeight;
    property NWidth: integer read FNWidth write FNWidth;
    property WinMaxSize: boolean read FWinMaxSize write FWinMaxSize;
    property Lv1ColWidth: TColWidth read FLv1ColWidth write FLv1ColWidth;
    property NLv1ColWidth: TColWidth read FNLv1ColWidth write FNLv1ColWidth;
    property PeopleVColWidth: TColWidth read FPeopleVColWidth write FPeopleVColWidth;
    procedure Adjust;
    constructor Create;
  end;

  TSettings=class
  private
    FRecents: TRecents;
    FCompilers: TCompilers;
    FNormalSet: TNormalSetting;
    FWindowSet: TWindowSetting;
    FOpened: boolean;
  public
    Path: string;
    property Opened: boolean read FOpened write FOpened;
    property NormalSet: TNormalSetting read FNormalSet write FNormalSet;
    property WindowSet: TWindowSetting read FWindowSet write FWindowSet;
    property Recents:TRecents read FRecents write FRecents;
    property Compilers:TCompilers read FCompilers write FCompilers;

    constructor Create;
    destructor Destroy; override;
    procedure Load;
    procedure Save;
  end;

  TPlugin=class
  private
    FNextPlugin, FPreviousPlugin: TPlugin;  
    FFileName: widestring;
    FDllHandle: cardinal;
  public
    BeforePerson: procedure (Name: PWideChar);
    AfterTestCase: procedure (Name: PWideChar; ProblemID, TestCaseID,
      Status: integer; Score, Time: double; Memory, ExitCode: integer);
    ContestOpen: procedure (Path: PWideChar);
    ContestClose: procedure;
    GetPluginTitle: function : PWideChar;
    GetPluginDescription: function : PWideChar;
    
    procedure InitPlugin(DllFile: widestring);
  end;

  TPlugins=class
  private
    FFirstPlugin,FLastPlugin: TPlugin;
    FCount: integer;
  public
    function GetItem(index: integer): TPlugin;
    property Count: integer read FCount write FCount;
    property Items[index: integer]: TPlugin read GetItem;
    function Add: TPlugin;
    procedure InitAll;

    
  end;

  TJudge=class
  private
    FPath: widestring;
    FContest: TContest;
    FSettings: TSettings;
    FPlugins: TPlugins;
    FClients:TClients;
  public
    property Path: widestring read FPath;
    property Contest:TContest read FContest write FContest;
    property Settings:TSettings read FSettings write FSettings;
    property Plugins: TPlugins read FPlugins write FPlugins;
    property Clients:TClients read FClients write FClients;
    constructor Create;
    destructor Destroy; override;
  end;

var
  Judge:TJudge;

//function PeopleStatusToStr(Status: integer): widestring;
function IsContest(APath: widestring): boolean;
function FileExistsW(FileName: widestring; IncludeDir: boolean):boolean;

implementation

procedure TFiles.SetCount(ACount: integer);
var
  i: integer;
begin
  if ACount>FCount then begin
    for i:=1 to ACount-FCount do begin
      if assigned(FLastFile) then begin
        FLastFile.FNextFile:=TFile.Create;
        FLastFile.FNextFile.FPreviousFile:=FLastFile;
        FLastFile:=FLastFile.FNextFile;
      end
      else begin
        FFirstFile:=TFile.Create;
        FLastFile:=FFirstFile;
      end;
    end;
  end
  else if ACount<FCount then begin
    while ACount<FCount do
      Delete(FLastFile);
  end;
  FCount:=ACount;
end;

function TFiles.GetItem(index: integer): TFile;
begin
  result:=self.FFirstFile;
  while index>0 do begin
    dec(index);
    Result:=Result.FNextFile;
  end;
end;

procedure Next_File(var s: widestring);
var i,j: integer;
    t: widestring;
    Found: boolean;
begin
  {
    找到 s 最靠后的一段数字，自增值1，插回到原串中
    样例：
       '1.i05'
       --> 找到最后一段数字：'05'
       --> 转为数字：5
       --> 自增值为：6
       --> 插回原串：'1.i06'  (数位总数不减少，但可以增加)

       '1.i9'
       --> 找到最后一段数字：'9'
       --> 转为数字：9
       --> 自增值为：10
       --> 插回原串：'1.i10'  (数位增加一位)
  }
  Found:=false;
  for i:=Length(s) downto 1 do
    if (s[i]>='0')and(s[i]<='9') then begin
      Found:=true;
      break;
    end;
  if Found then begin
    j:=i;
    while (j>0)and(s[j]>='0')and(s[j]<='9') do dec(j);
    inc(j);
    // s[j] -- s[i]
    t:=copy(s,j,i-j+1);
    t:=IntToStr(StrToInt(t)+1);
    while Length(t)<i-j+1 do t:='0'+t;
    s:=copy(s,1,j-1)+t+copy(s,i+1,Length(s)-i);
  end else
    if s<>'' then s:=s+'1';
end;

procedure TTestCase.AutoNext(Problem: TProblem);
var
  i:integer;
begin
  if assigned(self.FPreviousTestCase) then begin
    for i:=0 to self.FPreviousTestCase.FInputs.Count-1 do begin
      self.FInputs.Add.FFileName:=self.FPreviousTestCase.FInputs.Items[i].FFileName;
      next_file(self.FInputs.Items[i].FFileName);
    end;

    self.FOutput.FFileName:=FPreviousTestCase.FOutput.FFileName;
    next_file(self.FOutput.FFileName);


    self.FScore:=FPreviousTestCase.FScore;
    self.FTimeLimit:=FPreviousTestCase.FTimeLimit;
    self.FMemoryLimit:=FPreviousTestCase.FMemoryLimit;

  end
  else begin
    self.FScore:=Judge.Settings.NormalSet.DefaultScore;
    self.FTimeLimit:=Judge.Settings.NormalSet.DefaultTimeL;
    self.FMemoryLimit:=Judge.Settings.NormalSet.DefaultMemL;
  end;
  
end;

constructor TTestCase.Create;
begin
  inherited Create;
  FInputs:=TFiles.Create;
  FOutput:=TFile.Create;
end;

destructor TTestCase.Destroy;
begin
  FInputs.Destroy;
  FOutput.Destroy;
  inherited Destroy;
end;



procedure TTestCases.SetCount(ACount: integer);
var
  i: integer;
begin
  if ACount>FCount then begin
    for i:=1 to ACount-FCount do begin
      if assigned(FLastTestCase) then begin
        FLastTestCase.FNextTestCase:=TTestCase.Create;
        FLastTestCase.FNextTestCase.FPreviousTestCase:=FLastTestCase;
        FLastTestCase:=FLastTestCase.FNextTestCase;
      end
      else begin
        FFirstTestCase:=TTestCase.Create;
        FLastTestCase:=FFirstTestCase;
      end;
    end;
  end
  else if ACount<FCount then begin
    while ACount<FCount do
      Delete(FLastTestCase);
  end;
  FCount:=ACount;
end;

constructor TProblem.Create;
begin
  inherited Create;
  FTestCases:=TTestCases.Create;
  FInputs:=TFiles.Create;
  FOutput:=TFile.Create;
  FLibraries:=TFiles.Create;
end;

destructor TProblem.Destroy;
begin
  FTestCases.Destroy;
  FInputs.Destroy;
  FOutput.Destroy;
  FLibraries.Destroy;
  inherited Destroy;
end;

function TProblem.GetTotalScore:double;
var
  node: TTestCase;
begin
  result:=0;
  node:=TestCases.FFirstTestCase;
  while assigned(node) do begin
    result:=result+node.Score;
    node:=node.NextTestCase;
  end;
end;
{
function TProblem.GetTotalTime;
var
  node: TTestCase;
begin
  result:=0;
  node:=FirstTestCase;
  while assigned(node) do begin
    inc(result,node.);
    node:=node.NextTestCase;
  end;
end;
}
function TTestCases.GetItem(index: integer): TTestCase;
begin
  Result:=FFirstTestCase;
  while index>0 do begin
    dec(index);
    Result:=Result.NextTestCase;
  end;
end;

procedure TProblems.SetCount(ACount: integer);
var
  i: integer;
begin
  if ACount>FCount then begin
    for i:=1 to ACount-FCount do begin
      if assigned(FLastProblem) then begin
        FLastProblem.FNextProblem:=TProblem.Create;
        FLastProblem.FNextProblem.FPreviousProblem:=FLastProblem;
        FLastProblem:=FLastProblem.FNextProblem;
      end
      else begin
        FFirstProblem:=TProblem.Create;
        FLastProblem:=FFirstProblem;
      end;
    end;
  end
  else if ACount<FCount then begin
    while ACount<FCount do
      Delete(FLastProblem);
  end;
  FCount:=ACount;
end;



function TProblems.GetItem(index: integer): TProblem;
begin
  Result:=FFirstProblem;
  while index>0 do begin
    dec(index);
    Result:=Result.FNextProblem;
  end;
end;

function TContest.LoadFromFile(FileName: TFileName):cardinal;
var
  doc: xmlDocPtr;
  root, cont, prob, node, node2, test: xmlNodePtr;
  prop: xmlAttrPtr;
  i, j, k: integer;
begin
  doc:=xmlParseFile(pchar(FileName));
  if doc=nil then
    doc:=xmlNewDoc('1.0')
  else begin
    root:=xmlDocGetRootElement(doc);
    if root.name='cena' then begin
      cont:=root.children;
      while cont<>nil do begin
        if cont.name='contest' then begin
          Title:=UTF8Decode(libxml2.xmlGetProp(cont,'title'));
          Juror:=UTF8Decode(libxml2.xmlGetProp(cont,'juror'));

          prob:=cont.children;
          while prob<>nil do
            if prob.name='problem' then begin
              with Problems.Add do begin
                Title:=UTF8Decode(libxml2.xmlGetProp(prob,'title'));
                FileName:=UTF8Decode(libxml2.xmlGetProp(prob,'filename'));

                node:=prob.children;
                while node<>nil do begin
                  if node.name='testcase' then begin
                    with TestCases.Add do begin
                      node2:=node.children;
                      while node2<>nil do begin
                        if node2.name='input' then
                          with Inputs.Add do
                            FileName:=UTF8Decode(xmlGetProp(node2,'filename'));
                        if node2.name='output' then
                          Output.FileName:=UTF8Decode(xmlGetProp(node2,'filename'));
                        node2:=node2.next;
                      end;
                      Score:=strtofloat(libxml2.xmlGetProp(node,'score'));
                      TimeLimit:=strtofloat(libxml2.xmlGetProp(node,'timelimit'));
                      MemoryLimit:=strtoint(libxml2.xmlGetProp(node,'memorylimit'));
                    end;
                  end;
                  if node.name='input' then
                    with Inputs.Add do
                      FileName:=UTF8Decode(xmlGetProp(node,'filename'));
                  if node.name='output' then
                    Output.FileName:=UTF8Decode(xmlGetProp(node,'filename'));
                  if node.name='library' then
                    with Libraries.Add do
                      FileName:=UTF8Decode(xmlGetProp(node,'filename'));
                  node:=node.next;
                end;

                CompareType:=strtoint(xmlGetProp(prob,'comparetype'));
                CustomCompareFile:=UTF8Encode(xmlGetProp(prob, 'customchecker'));

              end;
            prob:=prob.next;
          end;

        end;
        cont:=cont.next;
      end;
    end;
  end;
  xmlFreeDoc(doc);
  result:=0;

end;

function TContest.SaveToFile(FileName: TFileName):cardinal;
var
  doc: xmlDocPtr;
  root, cont, curprob, curfile, curtest: xmlNodePtr;
  i, j, k: integer;
begin
  doc:=xmlNewDoc('1.0');
  doc.compression:=9;
//  doc.encoding:='utf-8';
  root:=xmlNewNode(nil, 'cena');
  xmlDocSetRootElement(doc, root);

  xmlNewProp(root,'version',ProductVersion);

  cont:=xmlNewChild(root, nil, 'contest', nil);
  xmlNewProp(cont, 'title', pchar(UTF8Encode(Title)));

  for i:=0 to Problems.Count-1 do
    with Problems.Items[i] do begin
      curprob:=xmlNewChild(cont, nil, 'problem', nil);
      xmlNewProp(curprob, 'title', pchar(UTF8Encode(Title)));
      xmlNewProp(curprob, 'filename', pchar(UTF8Encode(FileName)));
      for j:=0 to Inputs.Count-1 do begin
        curfile:=xmlNewChild(curprob, nil, 'input', nil);
        xmlNewProp(curfile, 'filename', pchar(UTF8Encode(Inputs.Items[j].FileName)));
      end;
      curfile:=xmlNewChild(curprob, nil, 'output', nil);
      xmlNewProp(curfile, 'filename', pchar(UTF8Encode(Output.FileName)));

      for j:=0 to TestCases.Count-1 do
        with TestCases.Items[j] do begin
          curtest:=xmlNewChild(curprob, nil, 'testcase', nil);

          for k:=0 to Inputs.Count-1 do begin
            curfile:=xmlNewChild(curtest, nil, 'input', nil);
            xmlNewProp(curfile, 'filename', pchar(UTF8Encode(Inputs.Items[k].FileName)));
          end;
          curfile:=xmlNewChild(curtest, nil, 'output', nil);
          xmlNewProp(curfile, 'filename', pchar(UTF8Encode(Output.FileName)));

          xmlNewProp(curtest, 'timelimit', pchar(floattostr(TimeLimit)));
          xmlNewProp(curtest, 'memorylimit', pchar(floattostr(MemoryLimit)));
          xmlNewProp(curtest, 'score', pchar(floattostr(Score)));

        end;

      xmlNewProp(curprob, 'comparetype', pchar(inttostr(CompareType)));
      xmlNewProp(curprob, 'customchecker', pchar(UTF8Encode(CustomCompareFile)));

      for j:=0 to Libraries.Count-1 do begin
        curfile:=xmlNewChild(curprob, nil, 'library', nil);
        xmlNewProp(curfile, 'filename', pchar(UTF8Encode(Libraries.Items[j].FileName)));
      end;

  end;

  result:=xmlSaveFile(pchar(FileName), doc);
  xmlFreeDoc(doc);
end;

function TContest.New(APath, ATitle, AJuror:string): cardinal;
var
  i:integer;
  f:text;
begin
  if IsOpen then
    Close;

  FPath:=APath+'\';
  try
    for i:=1 to length(FPath) do
      if FPath[i]='\' then
        if not DirectoryExists(copy(FPath,1,i-1)) then
          MkDir(copy(FPath,1,i-1));
    if not DirectoryExists(FPath+'\data\') then
      MkDir(FPath+'\data\');
    if not DirectoryExists(FPath+'\src\') then
      MkDir(FPath+'\src\');
    if not FileExists(FPath+'\.cena') then begin
      assign(f,FPath+'\.cena');
      rewrite(f);
      closefile(f);
    end;

    self.LoadFromFile(FPath+'\data\dataconf.xml');
    FTitle:=ATitle;
    FJuror:=AJuror;
    FIsOpen:=true;

    Peoples.Refresh;

    if Assigned(FOnOpen) then
      FOnOpen(self);
    Result:=0;
  except
    Result:=GetLastError;
  end;
end;

procedure TContest.Open(APath:string);
begin

  if IsOpen then
    Close;
  if IsContest(APath) then begin
    FPath:=APath;
    if not DirectoryExists(FPath+'\src\') then
      MkDir(FPath+'\src\');
    if not DirectoryExists(FPath+'\data\') then
      MkDir(FPath+'\data\');

    if assigned(FOnOpening) then
      FOnOpening(self);
    Problems.Clear;

    FLastError:=self.LoadFromFile(FPath+'\data\dataconf.xml');
    FIsOpen:=true;
    Peoples.Refresh;
  end
  else
    FLastError:=2;

  if assigned(FOnOpen) then
    FOnOpen(self);
end;

procedure TContest.Close;
begin
  if IsOpen then begin
    FIsOpen:=false;
    if assigned(FOnClose) then
      FOnClose(self);
    if not DirectoryExists(FPath+'\data\') then
      MkDir(FPath+'\data\');
    if not DirectoryExists(FPath+'\src\') then
      MkDir(FPath+'\src\');
    if DirectoryExists(FPath+'\tmp\') then
      DelDir(FPath+'\tmp\',true);
    self.SaveToFile(FPath+'\data\dataconf.xml');
//    Peoples.ClearLocal; // i will clear on MainForm.ContestClose !!

//    FNodeFile.Destroy;
    FProblems.Count:=0;
    FPath:='';
  end;
end;

constructor TContest.Create;
begin
  inherited Create;
  Problems:=TProblems.Create;
  Peoples:=TPeoples.Create;
end;

constructor TJudge.Create;
var
  buf:array[0..MAX_PATH] of widechar;
  i:integer;
begin
  Judge:=inherited Create;
  windows.GetModuleFileNameW(0,buf,sizeof(buf));
  FPath:=buf;
  for i:=length(FPath) downto 1 do
    if FPath[i]='\' then begin
      Delete(FPath,i,maxint);
      break;
    end;
  FContest:=TContest.Create;
  FSettings:=TSettings.Create;
  FPlugins:=TPlugins.Create;
  FPlugins.InitAll;
  FClients:=TClients.Create;
end;

function TProblems.Add: TProblem;
begin
  Result:=TProblem.Create;
  if assigned(FLastProblem) then begin
    Result.FPreviousProblem:=FLastProblem;
    FLastProblem.FNextProblem:=Result;
    FLastProblem:=Result;
  end
  else begin
    FFirstProblem:=Result;
    FLastProblem:=Result;
  end;
  inc(FCount);
end;

procedure TProblems.Delete(index: integer);
begin
  Delete(Items[index]);
end;
               {
function dfs(dir:widestring):widestring;
var
  ffd:TWin32FindDataW;
  hFile:dword;
begin
  hFile:=FindFirstFileW(pwidechar(dir+'\*'),ffd);
  if hFile<>INVALID_HANDLE_VALUE then
    repeat
      if ffd.cFileName[0]<>'.' then begin
        if (ffd.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY>0) then
          dfs(dir+'\'+ffd.cFileName)
        else begin
          result:=dir+'\'+ffd.cFileName;
        end;
      end;
    until not FindNextFileW(hFile,ffd);
  Windows.FindClose(hFile);
end;
                }
function TTestCases.Add: TTestCase;
begin
  Result:=TTestCase.Create;
  if assigned(FLastTestCase) then begin
    Result.FPreviousTestCase:=FLastTestCase;
    FLastTestCase.FNextTestCase:=Result;
    FLastTestCase:=Result;
  end
  else begin
    FFirstTestCase:=Result;
    FLastTestCase:=Result;
  end;
  inc(FCount);
end;

procedure TTestCases.Delete(index: integer);
begin
  Delete(Items[index]);
end;

procedure TProblems.Delete(node: TProblem);
begin
  if node.FPreviousProblem=nil then
    FFirstProblem:=node.FNextProblem;
  if node.FNextProblem=nil then
    FLastProblem:=node.FPreviousProblem;
  if node.FPreviousProblem<>nil then
    node.FPreviousProblem.FNextProblem:=node.FNextProblem;
  if node.FNextProblem<>nil then
    node.FNextProblem.FPreviousProblem:=node.FPreviousProblem;
  node.Destroy;
  dec(FCount);
end;

procedure TTestCases.Delete(node: TTestCase);
begin
  if node.FPreviousTestCase=nil then
    FFirstTestCase:=node.FNextTestCase;
  if node.FNextTestCase=nil then
    FLastTestCase:=node.FPreviousTestCase;
  if node.FPreviousTestCase<>nil then
    node.FPreviousTestCase.FNextTestCase:=node.FNextTestCase;
  if node.FNextTestCase<>nil then
    node.FNextTestCase.FPreviousTestCase:=node.FPreviousTestCase;
  node.Destroy;
  dec(FCount);
end;

function TCompilers.Add: TCompiler;
begin
  Result:=TCompiler.Create;
  if assigned(FLastCompiler) then begin
    Result.FPreviousCompiler:=FLastCompiler;
    FLastCompiler.FNextCompiler:=Result;
    FLastCompiler:=Result;
  end
  else begin
    FFirstCompiler:=Result;
    FLastCompiler:=Result;
  end;
  inc(FCount);
end;

procedure TCompilers.Clear;
var
  node: TCompiler;
begin
  while self.FFirstCompiler<>nil do begin
    node:=FFirstCompiler;
    FFirstCompiler:=FFirstCompiler.FNextCompiler;
    node.Destroy;
  end;
  FLastCompiler:=nil;
  FCount:=0;
end;

function TCompiler.CopyTo: ptagCompiler;
begin
  new(Result);
  Result.Active:=self.FActive;
  Result.Title:=self.FTitle;
  Result.Extension:=self.FExtension;
  Result.CommandLine:=self.FCommandLine;
  Result.Executable:=self.FExecutable;
end;


procedure TCompiler.MoveFrom(P: ptagCompiler);
begin
  self.FActive:=P.Active;
  self.FTitle:=P.Title;
  self.FExtension:=P.Extension;
  self.FCommandLine:=P.CommandLine;
  self.FExecutable:=P.Executable;
  dispose(P);
end;

destructor TCompilers.Destroy;
var
  node: TCompiler;
begin
  while self.FFirstCompiler<>nil do begin
    node:=FFirstCompiler;
    FFirstCompiler:=FFirstCompiler.FNextCompiler;
    node.Destroy;
  end;
  FLastCompiler:=nil;
  FCount:=0;
  inherited Destroy;
end;

function TCompilers.GetItem(index: integer): TCompiler;
begin
  Result:=FFirstCompiler;
  while index>0 do begin
    dec(index);
    Result:=Result.FNextCompiler;
  end;
end;

constructor TSettings.Create;
begin
  inherited Create;
  FCompilers:=TCompilers.Create;
  FRecents:=TRecents.Create;
  FNormalSet:=TNormalSetting.Create;
  FWindowSet:=TWindowSetting.Create;
  Path:=Judge.Path+'\cena.xml';
end;

procedure TProblems.Clear;
begin
  while FCount>0 do
    Delete(FFirstProblem);
end;

destructor TSettings.Destroy;
begin
  FCompilers.Destroy;
  FRecents.Destroy;
  inherited Destroy;
end;

function TFiles.Add: TFile;
begin
  Result:=TFile.Create;
  if assigned(FLastFile) then begin
    Result.FPreviousFile:=FLastFile;
    FLastFile.FNextFile:=Result;
    FLastFile:=Result;
  end
  else begin
    FFirstFile:=Result;
    FLastFile:=Result;
  end;
  inc(FCount);
end;

function TClients.Add: TClient;
begin
  Result:=TClient.Create;
  if assigned(FLastClient) then begin
    Result.FPreviousClient:=FLastClient;
    FLastClient.FNextClient:=Result;
    FLastClient:=Result;
  end
  else begin
    FFirstClient:=Result;
    FLastClient:=Result;
  end;
  inc(FCount);
end;

procedure TClients.Delete(node: TClient);
begin
  if node.FPreviousClient=nil then
    FFirstClient:=node.FNextClient;
  if node.FNextClient=nil then
    FLastClient:=node.FPreviousClient;
  if node.FPreviousClient<>nil then
    node.FPreviousClient.FNextClient:=node.FNextClient;
  if node.FNextClient<>nil then
    node.FNextClient.FPreviousClient:=node.FPreviousClient;
  node.Destroy;
  dec(FCount);
end;

destructor TClients.Destroy;
begin
  while FFirstClient<>nil do
    Delete(FFirstClient);
  inherited Destroy;
end;

function TClients.FindClientID(const ClientID: TClientID): TClient;
begin
//  writeln('finding ',libojcd.ClientToStr(clientid));
  result:=FFirstClient;
  while (result<>nil) and not CompareMem(@result.Info.ClientID[0],@ClientID[0],sizeof(TClient)) do
    result:=result.FNextClient;
end;

function TClients.FindIP(const IP: string): TClient;
begin
  result:=FFirstClient;
  while (result<>nil) and (result.IP<>IP) do
    result:=result.FNextClient;
end;

function TClients.FindName(const Name: string): TClient;
begin
  result:=FFirstClient;
  while (result<>nil) and (result.Info.Name<>Name) do
    result:=result.FNextClient;
end;

function TClients.GetItem(index: integer): TClient;
begin
  Result:=FFirstClient;
  while index>0 do begin
    dec(index);
    Result:=Result.FNextClient;
  end;
end;

destructor TFiles.Destroy;
var
  p, x : TFile;
begin
  p:=self.FFirstFile;
  while p<>nil do begin
    x:=p;
    p:=p.FNextFile;
    x.Destroy;
  end;
  inherited Destroy;
end;

procedure TFiles.Delete(node: TFile);
begin
  if node.FPreviousFile=nil then
    FFirstFile:=node.FNextFile;
  if node.FNextFile=nil then
    FLastFile:=node.FPreviousFile;
  if node.FPreviousFile<>nil then
    node.FPreviousFile.FNextFile:=node.FNextFile;
  if node.FNextFile<>nil then
    node.FNextFile.FPreviousFile:=node.FPreviousFile;
  node.Destroy;
  dec(FCount);
end;

destructor TProblems.Destroy;
begin
  while Count>0 do
    Delete(Items[0]);
  inherited Destroy;  
end;

destructor TTestCases.Destroy;
begin
  while Count>0 do
    Delete(Items[0]);
  inherited Destroy;
end;

function TPeoples.Add: TPeople;
begin
  Result:=TPeople.Create;
  if assigned(FLastPeople) then begin
    Result.FPreviousPeople:=FLastPeople;
    FLastPeople.FNextPeople:=Result;
    FLastPeople:=Result;
  end
  else begin
    FFirstPeople:=Result;
    FLastPeople:=Result;
  end;
  inc(FCount);
end;

procedure TPeoples.Clear;
begin
  while Count>0 do
    Delete(FFirstPeople);
end;

procedure TPeoples.ClearLocal;
var
  i:integer;
begin
  i:=0;
  while i<Count do begin
    if not Items[i].HasLocalFolder then
      Delete(Items[i])
    else
      inc(i);
  end;
end;

procedure TPeoples.Delete(node: TPeople);
begin
  if node.FPreviousPeople=nil then
    FFirstPeople:=node.FNextPeople;
  if node.FNextPeople=nil then
    FLastPeople:=node.FPreviousPeople;
  if node.FPreviousPeople<>nil then
    node.FPreviousPeople.FNextPeople:=node.FNextPeople;
  if node.FNextPeople<>nil then
    node.FNextPeople.FPreviousPeople:=node.FPreviousPeople;
  if node.Client<>nil then
    node.Client.People:=nil;
  node.Destroy;
  dec(FCount);
end;

destructor TPeoples.Destroy;
begin
  while FFirstPeople<>nil do
    Delete(FFirstPeople);
  inherited Destroy;
end;

function TPeoples.FindName(APeopleName: widestring): TPeople;
begin
  result:=FFirstPeople;
  while (result<>nil) and not SameFileName(result.Name,APeopleName) do
    result:=result.FNextPeople;
end;

function TPeoples.GetItem(index: integer): TPeople;
begin
  Result:=FFirstPeople;
  while index>0 do begin
    dec(index);
    Result:=Result.FNextPeople;
  end;
end;

procedure TPeoples.Refresh;
var
  ffd:TWin32FindDataW;
  hFile: cardinal;
  s:widestring;
  i:integer;
  People: TPeople;
begin
  Clear;
  s:=Judge.Contest.Path+'\src\*';
  hFile:=FindFirstFileW(@s[1],ffd);
  if hFile<>INVALID_HANDLE_VALUE then begin
    repeat
      if (ffd.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY>0) and (ffd.cFileName[0]<>'.') then begin
        with Add do begin
          Name:=ffd.cFileName;
        end;
      end;
    until not FindNextFileW(hFile,ffd);
    Windows.FindClose(hFile);
  end;
  for i:=0 to Judge.Clients.Count-1 do begin
    People:=FindName(UTF8Decode(Judge.Clients.Items[i].Info.Name));
    if People=nil then begin
      People:=Add;
      People.Name:=UTF8Decode(Judge.Clients.Items[i].FInfo.Name);
    end;
    People.Client:=Judge.Clients.Items[i];
    Judge.Clients.Items[i].People:=People;
  end;
end;

function TContest.GetScore: double;
var
  node: TProblem;
begin
  result:=0;
  node:=Problems.FFirstProblem;
  while assigned(node) do begin
    result:=result+node.Score;
    node:=node.NextProblem;
  end;
end;

destructor TFile.Destroy;
begin
//  FFileNameNode.Destroy;
  inherited Destroy;
end;

procedure TRecents.Add(APath: widestring);
var
  NFile,ToDel: TFile;
begin
  while (APath<>'') and (APath[length(APath)]='\') do
    system.Delete(APath,length(APath),1);
  NFile:=Add;
  NFile.FileName:=APath;
  NFile:=NFile.FPreviousFile;
  while NFile<>nil do
    if NFile.FFileName=APath then begin
      ToDel:=NFile;
      NFile:=NFile.FPreviousFile;
      Delete(ToDel);
    end else NFile:=NFile.FPreviousFile;
  while Count>MaxCount do begin
//    FFirstFile.FFileNameNode.Destroy;
    Delete(FFirstFile);
  end;
end;

function TPeople.CollectTime: TDateTime;
var
  ffd:TWin32FindDataW;
  hFile: cardinal;
  SystemTime: TSystemTime;
begin
  hFile:=FindFirstFileW(pwidechar(Path),ffd);
  if hFile<>INVALID_HANDLE_VALUE then begin
    windows.FileTimeToLocalFileTime(ffd.ftCreationTime,ffd.ftCreationTime);
    windows.FileTimeToSystemTime(ffd.ftCreationTime,SystemTime);
    Result:=sysutils.SystemTimeToDateTime(SystemTime);
    Windows.FindClose(hFile);
  end else Result:=0;
end;

function TPeople.GetLocationStr: string;
begin
  Result:='--';
  if HasLocalFolder then
    Result[1]:='L';
  if Client<>nil then
    Result[2]:='R';
end;

function TPeople.GetPath: widestring;
begin
  Result:=Judge.Contest.Path+'\src\'+Name;
end;


procedure TRecents.SetMaxCount(AMaxCount: integer);
begin
  while FCount>AMaxCount do Delete(FFirstFile);
  FMaxCount:=AMaxCount;
end;

constructor TRecents.Create;
begin
  inherited Create;
  MaxCount:=maxint;
end;

destructor TContest.Destroy;
begin
  Problems.Destroy;
  Peoples.Destroy;
  inherited Destroy;
end;

destructor TJudge.Destroy;
begin
  FContest.Destroy;
  FSettings.Destroy;
  FClients.Destroy;
  inherited Destroy;
end;

function TPeople.GetStatus: integer;
begin
  if FStatus=PS_UNKNOWN then begin
    if HasLocalFolder then begin
      if HasResult then
        Result:=PS_JUDGED
      else
        Result:=PS_NOT_JUDGED;
    end
    else
      Result:=PS_NOT_GETTED;

  end
  else
    Result:=FStatus;
end;

function DirectoryExistsW(Directory: widestring): boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributesW(PWideChar(Directory));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;


function TPeople.HasLocalFolder: boolean;
begin

  Result:=DirectoryExistsW(Path);
end;

procedure TArrInteger.SetCount(ACount: integer);
begin
  FCount:=ACount;
  SetLength(Items,FCount);
end;

destructor TArrInteger.Destroy;
begin
  SetLength(Items,0);
  inherited Destroy;
end;

function TPeople.HasResult: boolean;
begin
  Result:=HasLocalFolder and FileExists(Path+'\result.xml');
end;

procedure TClientIDList.AddToRear(AClientID: TClientID);
var
  Node: TClientIDNode;
begin
  Node:=TClientIDNode.Create;
  Node.ClientID:=AClientID;
  if Head=nil then begin
    Head:=Node;
    Rear:=Node;
  end else begin
    Rear.Next:=Node;
    Node.Previous:=Rear;
    Rear:=Node;
  end;
  inc(FCount);
end;

procedure TClientIDList.DeleteHead;
var
  Node: TClientIDNode;
begin
  if FCount=1 then begin
    Head.Destroy;
    Head:=nil;
    Rear:=nil;
  end else begin
    Node:=Head;
    Head:=Head.Next;
    Head.Previous:=nil;
    Node.Destroy;
  end;
  dec(FCount);
end;

destructor TClientIDList.Destroy;
begin
  while Head<>nil do DeleteHead;
  inherited Destroy;
end;

function TContest.Save: cardinal;
begin
  Result:=SaveToFile(Path+'\data\dataconf.xml');
end;

constructor TWindowSetting.Create;
begin
  SetDefaultData;
  FLv1ColWidth:=TColWidth.Create(10);
  FNLv1ColWidth:=TColWidth.Create(3);
  FPeopleVColWidth:=TColWidth.Create(4);
end;

constructor TColWidth.Create(ColCount: integer);
var
  i: integer;
begin
  inherited Create;
  DefaultWidth:=50;
  Count:=ColCount;
  for i:=0 to ColCount-1 do Width[i]:=DefaultWidth;
end;

procedure TColWidth.Adjust;
begin
end;

procedure TNormalSetting.Adjust;
begin
end;

procedure TWindowSetting.Adjust;
begin
end;

procedure TColWidth.SetCount(ACount: integer);
var
  i: integer;
begin
  SetLength(FWidth,ACount);
  for i:=FCount to ACount-1 do FWidth[i]:=DefaultWidth;
  FCount:=ACount;
end;

function TColWidth.ReadWidth(Index: integer): integer;
begin
  if Index<FCount then Result:=FWidth[Index]
  else Result:=DefaultWidth;
end;

procedure TColWidth.WriteWidth(Index: integer;  AWidth: integer);
begin
  if Index<FCount then FWidth[Index]:=AWidth;
end;

function FileExistsW(FileName: widestring; IncludeDir: boolean):boolean;
var
  hFindFile: cardinal;
  ffd: _WIN32_FIND_DATAW;
begin

  // make it to find the file 'c:\abc\data\', without file name.
  while FileName[Length(FileName)]='\' do
    Delete(FileName,length(filename),1);

  if FileName='' then begin
    Result:=true;
    exit;
  end;
  hFindFile:=FindFirstFileW(pwidechar(FileName),ffd);
  if hFindFile<>INVALID_HANDLE_VALUE then begin
    if not IncludeDir and (ffd.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY>0) then
      Result:=false
    else
      Result:=true;
    FindClose(hFindFile);
  end
  else
    Result:=false;
end;

function IsContest(APath: widestring): boolean;
begin
  if FileExistsW(APath+'\judge.dir',false) then begin
    MoveFileW(pwidechar(APath+'\judge.dir'),pwidechar(APath+'\.cena'));
    Result:=true;
  end
  else
    Result:=FileExistsW(APath+'\.cena',false);
end;

constructor TNormalSetting.Create;
begin
  SetDefaultData;
end;

procedure TPlugin.InitPlugin(DllFile: widestring);
begin
  FDllHandle:=LoadLibraryW(pwidechar(DllFile));

  BeforePerson:=GetProcAddress(FDllHandle,'BeforePerson');
  AfterTestCase:=GetProcAddress(FDllHandle,'AfterTestCase');
  ContestOpen:=GetProcAddress(FDllHandle,'ContestOpen');
  ContestClose:=GetProcAddress(FDllHandle,'ContestClose');
  GetPluginTitle:=GetProcAddress(FDllHandle,'GetPluginTitle');
  GetPluginDescription:=GetProcAddress(FDllHandle,'GetPluginDescription');

end;

function TPlugins.Add: TPlugin;
begin
  Result:=TPlugin.Create;
  if assigned(FLastPlugin) then begin
    Result.FPreviousPlugin:=FLastPlugin;
    FLastPlugin.FNextPlugin:=Result;
    FLastPlugin:=Result;
  end
  else begin
    FFirstPlugin:=Result;
    FLastPlugin:=Result;
  end;
  inc(FCount);
end;

procedure TPlugins.InitAll;
var
  ffd:TWin32FindDataW;
  hFile: cardinal;
  s:widestring;
  i:integer;
  People: TPeople;
begin
{
  s:=Judge.Path+'/plugins/*.dll';
  hFile:=FindFirstFileW(@s[1],ffd);
  if hFile<>INVALID_HANDLE_VALUE then begin
    repeat
      if (ffd.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY=0) then begin
        with Add do begin
          InitPlugin(Judge.Path+'/plugins/'+ffd.cFileName);
        end;
      end;
    until not FindNextFileW(hFile,ffd);
    Windows.FindClose(hFile);
  end;
  }
end;

function TPlugins.GetItem(index: integer): TPlugin;
begin
  Result:=FFirstPlugin;
  while index>0 do begin
    dec(index);
    Result:=Result.FNextPlugin;
  end;
end;

procedure TSettings.Load;
var
  doc: xmlDocPtr;
  sett, child: xmlNodePtr;
  prop: xmlAttrPtr;
  i, j, k: integer;
begin
  doc:=xmlParseFile(pchar(Path));
  if doc=nil then
    doc:=xmlNewDoc('1.0')
  else begin
    sett:=xmlDocGetRootElement(doc).children;
    while sett<>nil do begin
      if sett.name='Settings' then begin
        child:=sett.children;
        while child<>nil do begin
          if child.name='Compilers' then Compilers.Load(child);
          if child.name='Normal'    then NormalSet.Load(child);
          if child.name='Recents'   then Recents.Load(child);
          if child.name='Window'    then WindowSet.Load(child);
          child:=child.next;
        end;
      end;
      sett:=sett.next;
    end;
  end;
  xmlFreeDoc(doc);
end;

procedure TSettings.Save;
var
  doc: xmlDocPtr;
  root, sett, child: xmlNodePtr;
  i, j, k: integer;
begin
  doc:=xmlNewDoc('1.0');
//  doc.compression:=9;
//  doc.encoding:='utf-8';
  root:=xmlNewNode(nil, 'cena');
  xmlDocSetRootElement(doc, root);
  xmlNewProp(root,'version',ProductVersion);

  sett:=xmlNewChild(root,nil,'Settings',nil);

  Recents.Save(xmlNewChild(sett,nil,'Recents',nil));
  Compilers.Save(xmlNewChild(sett,nil,'Compilers',nil));
  NormalSet.Save(xmlNewChild(sett,nil,'Normal',nil));
  WindowSet.Save(xmlNewChild(sett,nil,'Window',nil));
                                                   
  xmlSaveFile(pchar(self.Path), doc);
  xmlFreeDoc(doc);
end;

procedure TCompilers.Load(node: xmlNodePtr);
var
  child: xmlNodePtr;
begin
  Clear;
  child:=node.children;
  while child<>nil do begin
    if child.name='Compiler' then
      with Add do begin
        Active:=strtobooldef(xmlGetProp(child,'Active'),true);
        Title:=UTF8Decode(xmlGetProp(child,'Title'));
        CommandLine:=UTF8Decode(xmlGetProp(child,'CommandLine'));
        Extension:=UTF8Decode(xmlGetProp(child,'Extension'));
        Executable:=UTF8Decode(xmlGetProp(child, 'Executable'));
      end;
    child:=child.next;
  end;
end;

procedure TCompilers.Save(node: xmlNodePtr);
var
  i: integer;
  child: xmlNodePtr;
begin
  for i:=0 to Count-1 do
    with Items[i] do begin
      child:=xmlNewChild(node, nil, 'Compiler', nil);
      xmlNewProp(child,'Active', pchar(booltostr(Active)));
      xmlNewProp(child,'Title', pchar(UTF8Encode(Title)));
      xmlNewProp(child,'Extension', pchar(UTF8Encode(Extension)));
      xmlNewProp(child,'CommandLine', pchar(UTF8Encode(CommandLine)));
      xmlNewProp(child,'Executable', pchar(UTF8Encode(Executable)));
    end;
end;

procedure TNormalSetting.Load(node: xmlNodePtr);
begin
  CollectExtCorrelative:=strtobooldef(xmlGetProp(node,'CollectExtensionCorrelative'),false);
  CollectFileCorrelative:=strtobooldef(xmlGetProp(node,'CollectFileNameCorrelative'),false);
  FileSizeLimitB:=strtobooldef(xmlGetProp(node,'LimitFileSize'),false);
  FileSizeLimit:=strtointdef(xmlGetProp(node,'FileSizeLimit'),0);
  DefaultMemL:=strtointdef(xmlGetProp(node,'DefaultMemLimit'),2056);
  DefaultScore:=strtointdef(xmlGetProp(node,'DefaultScore'),10);
  DefaultTimeL:=strtofloatdef(xmlGetProp(node,'DefaultTimeLimit'),1);
  Language:=xmlGetProp(node,'Language');
end;

procedure TNormalSetting.Save(node: xmlNodePtr);
begin
  xmlNewProp(node,'CollectExtensionCorrelative',pchar(booltostr(CollectExtCorrelative)));
  xmlNewProp(node,'CollectFileNameCorrelative',pchar(booltostr(CollectFileCorrelative)));
  xmlNewProp(node,'LimitFileSize',pchar(booltostr(FileSizeLimitB)));
  xmlNewProp(node,'FileSizeLimit',pchar(inttostr(FileSizeLimit)));
  xmlNewProp(node,'DefaultMemLimit',pchar(inttostr(DefaultMemL)));
  xmlNewProp(node,'DefaultScore',pchar(inttostr(DefaultScore)));
  xmlNewProp(node,'DefaultTimeLimit',pchar(floattostr(DefaultTimeL)));
  xmlNewProp(node,'Language',pchar(Language));
end;

procedure TNormalSetting.SetDefaultData;
begin
  CollectExtCorrelative:=false;
  CollectFileCorrelative:=false;
  FileSizeLimitB:=false;
  FileSizeLimit:=0;
  DefaultMemL:=2560;
  DefaultScore:=10;
  DefaultTimeL:=1;
  Language:='';
end;

procedure TRecents.Load(node: xmlNodePtr);
var
  child: xmlNodePtr;
begin
  child:=node.children;
  while child<>nil do begin
    if child.name='Recent' then
      Add(UTF8Decode(xmlGetProp(child,'Path')));
    child:=child.next;
  end;
end;

procedure TRecents.Save(node: xmlNodePtr);
var
  i: integer;
  child: xmlNodePtr;
begin
  for i:=0 to Count-1 do begin
    child:=xmlNewChild(node,nil,'Recent',nil);
    xmlNewProp(child,'Path',pchar(UTF8Encode(Items[i].FileName)));
  end; 
end;

procedure TWindowSetting.SetDefaultData;
begin
  B1Checked:=true;
  N18Checked:=true;
  Height:=540;
  Width:=730;
  Left:=10;
  Top:=10;
  NHeight:=430;
  NWidth:=530;
  WinMaxSize:=false;
end;

procedure TWindowSetting.Load(node: xmlNodePtr);
var
  child: xmlNodePtr;
begin
  B1Checked:=strtobooldef(xmlGetProp(node,'ShowStatus'),true);
  N18Checked:=strtobooldef(xmlGetProp(node,'ShowClients'),true);
  Height:=strtointdef(xmlGetProp(node,'MainFormHeight'),540);
  Width:=strtointdef(xmlGetProp(node,'MainFormWidth'),730);
  Left:=strtointdef(xmlGetProp(node,'MainFormLeft'),10);
  Top:=strtointdef(xmlGetProp(node,'MainFormTop'),10);
  NHeight:=strtointdef(xmlGetProp(node,'NewFormHeight'),430);
  NWidth:=strtointdef(xmlGetProp(node,'NewFormWidth'),530);
  WinMaxSize:=strtobooldef(xmlGetProp(node,'MainFormMaxSize'),false);
  child:=node.children;
  while child<>nil do begin
    if child.name='ContestantsList' then Lv1ColWidth.Load(child);
    if child.name='RecentList'      then NLv1ColWidth.Load(child);
    if child.name='PeopleViewList'  then PeopleVColWidth.Load(child);
    child:=child.next;
  end;
end;

procedure TWindowSetting.Save(node: xmlNodePtr);
var
  child: xmlNodePtr;
begin
  xmlNewProp(node,'ShowStatus',pchar(booltostr(B1Checked)));
  xmlNewProp(node,'ShowClients',pchar(booltostr(N18Checked)));
  xmlNewProp(node,'MainFormMaxSize',pchar(booltostr(WinMaxSize)));
  xmlNewProp(node,'MainFormHeight',pchar(inttostr(Height)));
  xmlNewProp(node,'MainFormWidth',pchar(inttostr(Width)));
  xmlNewProp(node,'MainFormLeft',pchar(inttostr(Left)));
  xmlNewProp(node,'MainFormTop',pchar(inttostr(Top)));
  xmlNewProp(node,'NewFormHeight',pchar(inttostr(NHeight)));
  xmlNewProp(node,'NewFormWidth',pchar(inttostr(NWidth)));
 
  Lv1ColWidth.Save(xmlNewChild(node,nil,'ContestantsList',nil));
  NLv1ColWidth.Save(xmlNewChild(node,nil,'RecentList',nil));
  PeopleVColWidth.Save(xmlNewChild(node,nil,'PeopleViewList',nil));
end;

procedure TColWidth.Load(node: xmlNodePtr);
var
  child: xmlNodePtr;
  i: integer;
begin
  child:=node.children;
  i:=0;
  while child<>nil do begin
    if child.name='Column' then begin
      Width[i]:=strtointdef(xmlGetProp(child,'Width'),DefaultWidth);
      inc(i);
      if i=Count then exit;
    end;
    child:=child.next;      
  end;
end;

procedure TColWidth.Save(node: xmlNodePtr);
var
  child: xmlNodePtr;
  i: integer;
begin
  for i:=0 to Count-1 do
    xmlNewProp(xmlNewChild(node,nil,'Column',nil),'Width',pchar(inttostr(Width[i])));
    

end;

procedure TRecents.Delete(Index: integer);
begin
  Delete(Items[Index]);
end;

initialization
  Judge:=TJudge.Create;

finalization
  Judge.Destroy;

end.

