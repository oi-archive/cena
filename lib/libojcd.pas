unit libojcd;

interface

uses
  windows, sysutils, Forms, Graphics, myutils, classes, IdTCPConnection, registry;
                                                               
const

  FILEPART_SIZE                                =  16384;

  PO_WHO_IS_ONLINE                             =  0   ;   //  广播
  PO_ONLINE                                    =  1   ;   //  上线
  PO_CHANGESETTING                             =  2   ;   //  修改设置
  PO_OFFLINE                                   =  3   ;   //  下线
  PO_NAME_CONF                                 =  4   ;   //  名称冲突
//  PO_ONLINE_TO_CLIENT                          =  5   ;   //  告诉别的客户端 上线
  PO_SHOW_TEST_MESSAGE                         =  6   ;   //  测试客户端连接
{
  PO_FETCH_REQUEST                             =  7   ;   //  请求收程序
  PO_FETCH_REPLY                               =  8   ;   //  收程序的回应。

  PO_FILE_INFO                                 =  12  ;   //  文件的信息

  PO_SEND_RESULT                               =  9   ;   //  发送结果

  PO_UPDATE_REQUEST                            =  10  ;   //  请求自动更新
  PO_UPDATE_REPLY                              =  11  ;   //  回复自动更新
}


  PO_OK                                        =  0   ;   // 这个文件片段正常
  PO_ERROR                                     =  1   ;   // 发生错误


  PO_BEGIN_SEND                                =  13  ;


  PO_COMMAND_EC                                =  100 ;


  CS_OK                                        =  0   ;
  CS_NAME_CONF                                 =  1   ;


  ClientPort                                   =  12574;
  ServerPort                                   =  12575;


type

  TName=array[0..63] of char;
  TClientID=array[0..31] of byte;

  TClientInfo=record
    Version: integer;
    ClientID: TClientID;      // 维一标识一个客户端，客户端每次运行时随机生成
    Name: TName;
    WorkDir: array[0..255] of char;
    AutoStartUp: boolean;
    Status: integer;
    OperatingSystem: array[0..255] of char;
    Permissions: cardinal;
    UsesComputerName: boolean;
  end;

  TPacket=record
//    cb: cardinal;
    dwProtocolVersion: cardinal;
    case dwOperation:cardinal of
      PO_ONLINE, PO_CHANGESETTING:
        (ClientInfo: TClientInfo);
{      PO_FETCH_REPLY:
        (FileCount: integer);}
  end;

  TTCPPacket=record
    dwOperation:cardinal;
    FileCount: integer;
    FileName: string;
    FileSize: integer;
  end;

  TPropertyList=class(TStringList)
  private
    function GetName(index: integer): string;
    procedure SetName(index: integer; ANewName: string);
    function GetValue(index: integer): string;
    procedure SetValue(index: integer; ANewValue: string);
  public
    property Name[index: integer]:string read GetName write SetName;
    property Value[index: integer]:string read GetValue write SetValue;
  end;

  THeader=object
    Command: string;
    Properties: TPropertyList;
    procedure ReadFrom(Connection: TIdTCPConnection);
    procedure WriteTo(Connection: TIdTCPConnection);
  end;
{
  TFilePart=record
    Status: integer;
    Data: array[0..65535] of byte;
  end;
}
var
  ClientInfo: TClientInfo;

procedure InitPacket(var APacket: TPacket);
procedure ShowTestMessage(AMsg: string);
function ClientToStr(AClientID: TClientID):string;
function CheckClientInfo(var ClientInfo: TClientInfo): boolean;
function ComputerName: string;

procedure ReadMySet(var ClientInfo: TClientInfo);
procedure WriteMySet(var ClientInfo: TClientInfo);



implementation

procedure InitPacket(var APacket: TPacket);
begin
  APacket.dwProtocolVersion:=1;
  APacket.ClientInfo:=ClientInfo;
end;

function ClientToStr(AClientID: TClientID):string;
var
  i:integer;
begin
  result:='';
  for i:=0 to 15 do
    result:=result+IntToHex(AClientID[i],2);
end;

function TPropertyList.GetName(index: integer): string;
begin
  Result:=trim(copy(Strings[index],1,pos(':',Strings[index])-1));
end;

procedure TPropertyList.SetName(index: integer; ANewName: string);
begin
  Strings[index]:=ANewName+': '+Value[index];

end;

function TPropertyList.GetValue(index: integer): string;
begin
  Result:=trim(copy(Strings[index],pos(':',Strings[index])+1,maxint));
end;

procedure TPropertyList.SetValue(index: integer; ANewValue: string);
begin
  Strings[index]:=Name[index]+': '+ANewValue;

end;

procedure THeader.ReadFrom(Connection: TIdTCPConnection);
var
  s: string;
begin
//  writeln('======== RECV ========');
  Properties.Clear;
  Command:=Connection.ReadLn;
//  writeln(command);
  repeat
    s:=Connection.ReadLn;
//    writeln(s);
    if s='' then
      break;
    Properties.Add(s);
   until false;
//  writeln('======================');
end;


procedure THeader.WriteTo(Connection: TIdTCPConnection);
var
  i:integer;
begin
//  writeln('======== SEND ========');
//  writeln(command);
  Connection.WriteLn(Command);
  for i:=0 to Properties.Count-1 do begin
    Connection.WriteLn(Properties.Strings[i]);
//    writeln(Properties.Strings[i]);
  end;
//  writeln;
  Connection.WriteLn;
//  writeln('======================');
end;

function CheckClientInfo(var ClientInfo: TClientInfo): boolean;
var
  p: pansichar;
  size: cardinal;
begin
  Result:=false;
  if ClientInfo.Name='' then begin
    p:='CannotGetComputerName';
    GetComputerNameA(p,size);
    strplcopy(@ClientInfo.Name,strpas(p),size);
    Result:=true;
  end;
end;

procedure ReadMySet(var ClientInfo: TClientInfo);
var f: TReginifile;
    s: string;
begin
  f:=treginifile.Create;
  f.RootKey:=HKEY_CURRENT_USER;

  ClientInfo.UsesComputerName:=f.ReadBool('Software\Judge\Client','UsesComputerName',true);

  if ClientInfo.UsesComputerName then
    s:=ComputerName
  else
    s:=f.ReadString('Software\Judge\Client','Name',ComputerName);
  StrLCopy(@ClientInfo.Name,pchar(UTF8Encode(s)),sizeof(ClientInfo.Name));

  s:=f.ReadString('Software\Judge\Client','WorkDir','D:\TEST');
  s:=trim(s);
  StrLCopy(@ClientInfo.WorkDir,pchar(UTF8Encode(s)),sizeof(ClientInfo.WorkDir));

  ClientInfo.AutoStartUp:=f.ReadBool('Software\Judge\Client','AutoStartUp',true);

  ClientInfo.Permissions:=f.ReadInteger('Software\Judge\Client','Permissions',1);


  f.Free;

end;

procedure WriteMySet(var ClientInfo: TClientInfo);
var f: TReginifile;
begin
  f:=treginifile.Create;
  f.RootKey:=HKEY_CURRENT_USER;
  f.WriteBool('Software\Judge\Client','UsesComputerName',ClientInfo.UsesComputerName);
  f.WriteString('Software\Judge\Client','Name',UTF8Decode(ClientInfo.Name));
  f.WriteString('Software\Judge\Client','WorkDir',UTF8Decode(ClientInfo.WorkDir));
  f.WriteBool('Software\Judge\Client','AutoStartUp',ClientInfo.AutoStartUp);
  f.WriteInteger('Software\Judge\Client','Permissions',ClientInfo.Permissions);
  if ClientInfo.AutoStartUp then begin
    f.WriteString('Software\Microsoft\Windows\CurrentVersion\Run','Client',paramstr(0)+' -a');
  end else begin
    f.DeleteKey('Software\Microsoft\Windows\CurrentVersion\Run','Client');
  end;
  f.Free;

end;



function ComputerName: string;
var
  size:cardinal;
  buf:array[0..127] of char;
begin
  size:=sizeof(buf);
  GetComputerName(@buf[0],size);
  Result:=strpas(buf);
end;

procedure ShowTestMessage(AMsg: string);
var
  MyHand: HWND;
  MyDc: HDC;
  MyCanvas: TCanvas;
begin

  MyHand   := GetDesktopWindow;
  MyDc     := GetWindowDC(MyHand);
  MyCanvas := TCanvas.Create;
  MyCanvas.Handle := MyDC;
  BeginPath(MyCanvas.Handle);
  MyCanvas.Font.Color := clRed;
//  MyCanvas.Font.Name  := 'Courier New';
  MyCanvas.Font.Name  := 'Tahoma';
  MyCanvas.Font.Size  := 1000;

  while (myCanvas.TextHeight(AMsg)>Screen.Height*0.9) or (MyCanvas.TextWidth(AMsg)>Screen.Width*0.9) do
    MyCanvas.Font.Size:=MyCanvas.Font.Size-2;

  RedrawWindow(MyHand,nil,0,RDW_ERASE or RDW_INVALIDATE or RDW_ALLCHILDREN);

  SetBkMode(MyCanvas.Handle, TRANSPARENT);
  EndPath(MyCanvas.Handle);

  MyCanvas.TextOut((screen.Width-mycanvas.TextWidth(amsg)) div 2,
    (screen.Height-mycanvas.TextHeight(amsg)) div 2 , amsg);

end;

initialization
  ClientInfo.Version:=95;
end.
