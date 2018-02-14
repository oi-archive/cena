unit ojwin32;

interface

uses
  windows, classes, sysutils, jclsysinfo;

const
  SystemPerformanceInformation = 2;

type
  TSystem_Performance_Information  =  packed  record
      liIdleTime:  LARGE_INTEGER;
      dwSpare:  array[0..75]  of  DWORD;
  end;

  TException=record
    Code: cardinal;
    ErrorMsg: string;
  end;

type
  TGetSystemTimes = function (var lpIdleTime, lpKernelTime, lpUserTime: TFileTime): BOOL; stdcall;

var
  GetSystemTimes: TGetSystemTimes; 

var
  Exceptions:TList;
  SystemInfo: TSystemInfo;

function GetIdleTime:int64;
function GetException(Code: cardinal): string;

implementation

function NtQuerySystemInformation(infoClass: DWORD; buffer: Pointer;
  bufSize: DWORD; returnSize: PDword):DWORD; stdcall external 'ntdll.dll';

var
  last_idle_time:int64 = 0;
  last_time: extended = 0;
  pf_freq: int64;
  sum_idle_time: int64 = 0;

function GetIdleTime:int64;
var
  spi:TSystem_Performance_Information;
  lpIdleTime, lpKernelTime, lpUserTime: TFileTime;
  idle_time: int64;
  pf: int64;
  cur_time, idle, other_cpu_idle: extended;
  c: extended;
begin
  QueryPerformanceCounter(pf);

  cur_time := pf / pf_freq;
  
  if Assigned(GetSystemTimes) then begin
    GetSystemTimes(lpIdleTime, lpKernelTime, lpUserTime);
    idle_time := lpIdleTime.dwHighDateTime;
    idle_time := idle_time shl 32;
    inc(idle_time, lpIdleTime.dwLowDateTime);

    idle := (idle_time - last_idle_time) / 10000000;
    other_cpu_idle := (SystemInfo.dwNumberOfProcessors - 0.5) * (cur_time - last_time);

//    writeln(pf-last_pf);

    c := idle - other_cpu_idle;
    if c < 0 then
      c := 0;
    inc(sum_idle_time, round(c * 10000000));
    Result := sum_idle_time;

    last_time := cur_time;
    last_idle_time := idle_time;
    exit;
  end;
  NtQuerySystemInformation(SystemPerformanceInformation,@spi,sizeof(spi),nil);
  Result:=spi.liIdleTime.QuadPart;
end;

procedure InsertException(Code: Cardinal; ErrorMsg: string);
var
  p: ^TException;
begin
  new(p);
  p.Code:=Code;
  p.ErrorMsg:=ErrorMsg;
  Exceptions.Add(p);
end;

function GetException(Code: cardinal): string;
var
  i:integer;
begin
  for i:=0 to Exceptions.Count-1 do
    if TException(Exceptions.Items[i]^).Code=Code then begin
      Result:=TException(Exceptions.Items[i]^).ErrorMsg;
      exit;
    end;
  Result:='0x'+IntToHex(Code, 8);
end;

procedure InitExceptions;
begin
  Exceptions:=TList.Create;

//  STATUS_GUARD_PAGE_VIOLATION     = DWORD($80000001);
//  STATUS_DATATYPE_MISALIGNMENT    = DWORD($80000002);
//  STATUS_BREAKPOINT               = DWORD($80000003);
//  STATUS_SINGLE_STEP              = DWORD($80000004);
  InsertException(STATUS_ACCESS_VIOLATION, '访问无效内存');
  InsertException(STATUS_IN_PAGE_ERROR, 'IN_PAGE_ERROR');
  InsertException(STATUS_INVALID_HANDLE, '无效的句柄');
  InsertException(STATUS_NO_MEMORY, '无内存');
  InsertException(STATUS_ILLEGAL_INSTRUCTION, '无效的指令');
  InsertException(STATUS_NONCONTINUABLE_EXCEPTION, '不可继续的异常');
  InsertException(STATUS_INVALID_DISPOSITION, '无效的内存释放');
  InsertException(STATUS_ARRAY_BOUNDS_EXCEEDED, '数组越界');
  InsertException(STATUS_FLOAT_DENORMAL_OPERAND, '无效的操作符');
  InsertException(STATUS_FLOAT_DIVIDE_BY_ZERO, '浮点数被零除');
  InsertException(STATUS_FLOAT_INEXACT_RESULT, '浮点数结果不精确');
  InsertException(STATUS_FLOAT_INVALID_OPERATION, '浮点数无效操作');
  InsertException(STATUS_FLOAT_OVERFLOW, '浮点数上溢');
  InsertException(STATUS_FLOAT_STACK_CHECK, '浮点数栈溢出');
  InsertException(STATUS_FLOAT_UNDERFLOW, '浮点数下溢');
  InsertException(STATUS_INTEGER_DIVIDE_BY_ZERO, '整数被零除');
  InsertException(STATUS_INTEGER_OVERFLOW, '整数溢出');
  InsertException(STATUS_PRIVILEGED_INSTRUCTION, '特权指令');
  InsertException(STATUS_STACK_OVERFLOW, '栈溢出');
  InsertException(STATUS_CONTROL_C_EXIT, 'Ctrl+C 退出');
end;


initialization
  InitExceptions;
  GetNativeSystemInfo(SystemInfo);
  QueryPerformanceFrequency(pf_freq);

  GetSystemTimes := GetProcAddress(GetModuleHandle('kernel32.dll'), 'GetSystemTimes');
end.





