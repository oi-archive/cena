unit ManagerFormU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, IdBaseComponent, IdComponent, ShlObj,
  IdTCPConnection, IdTCPClient, IdUDPBase, IdUDPServer, IdSocketHandle, ojtc,libojcd;

type
  TManagerForm = class(TForm)
    Label1: TLabel;
    lv: TListView;
    tcp: TIdTCPClient;
    GroupBox1: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ManagerForm: TManagerForm;

implementation

uses MainFormU;

{$R *.dfm}

procedure TManagerForm.Button1Click(Sender: TObject);
var
  cl:TClient;
begin

  cl:=lv.Selected.Data;

  tcp.Host:=cl.IP;
  tcp.Port:=12574;

  Screen.Cursor:=crHourGlass;
  try
    tcp.Connect;
  except
    messagebox(Handle,pchar('无法修改客户端上的设置。'#13#10#13#10+Format('错误 %d: %s',[GetLastError,SysErrorMessage(GetLastError)])),'错误',MB_ICONERROR);
    exit;
  end;

  try
    tcp.WriteLn('SET');
  except
    messagebox(Handle,pchar('无法修改客户端上的设置。'#13#10#13#10+Format('错误 %d: %s',[GetLastError,SysErrorMessage(GetLastError)])),'错误',MB_ICONERROR);
    tcp.Disconnect;
    exit;
  end;
  tcp.Disconnect;
  Screen.Cursor:=crDefault;
end;

procedure TManagerForm.FormShow(Sender: TObject);
var
  i:integer;
  item:TListItem;
begin
  for i:=0 to Judge.Clients.Count-1 do begin
    item:=lv.Items.Add;
    item.Caption:=Judge.Clients.Items[i].Info.Name;
    item.Data:=Judge.Clients.Items[i];
    Judge.Clients.Items[i].Data:=item;
  end;
end;

procedure TManagerForm.lvSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  case lv.SelCount of
    0:
      begin
        groupbox1.Hide;
      end;
    1:
      begin
        edit1.Text:=TClient(Item.Data).Info.Name;
        edit2.Text:=TClient(Item.Data).Info.WorkDir;
        groupbox1.Show;
      end;
    else begin


    end;

  end;
end;

procedure TManagerForm.Button2Click(Sender: TObject);
var
  DataToSend: TPacket;
begin
  InitPacket(DataToSend);
  DataToSend.dwOperation:=PO_SHOW_TEST_MESSAGE;
  mainform.udp.SendBuffer('255.255.255.255',12574,DataToSend,sizeof(DataToSend));
end;

procedure TManagerForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i:integer;
begin
  for i:=0 to lv.Items.Count-1 do
    TClient(lv.Items.Item[i].Data).Data:=nil;
end;

end.
