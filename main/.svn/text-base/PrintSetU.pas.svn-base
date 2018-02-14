unit PrintSetU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls, Printers, jvgnugettext;

type
  TPrintSetForm = class(TForm)
    Label1: TLabel;
    Bevel1: TBevel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Button5: TButton;
    Button3: TButton;
    Edit5: TEdit;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    SpinEdit4: TSpinEdit;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    Label7: TLabel;
    FontDlg: TFontDialog;
    PSDlg: TPrinterSetupDialog;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Bevel4: TBevel;
    Button1: TButton;
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure RadioButton3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PrintSetForm: TPrintSetForm;

implementation

{$R *.dfm}

procedure TPrintSetForm.Button3Click(Sender: TObject);
begin
  if printer.Printers.Count=0 then
    MessageBox(Handle,'没有打印机！','错误',MB_ICONERROR)
  else
    PSDlg.Execute;
end;

procedure TPrintSetForm.Button5Click(Sender: TObject);
begin
  FontDlg.Execute;
end;

procedure TPrintSetForm.RadioButton3Click(Sender: TObject);
begin
  if RadioButton5.Checked then begin
    Edit5.Color:=clWindow;
    Edit5.Enabled:=true;
  end else begin
    Edit5.Color:=clBtnFace;
    Edit5.Enabled:=false;
  end;
end;

procedure TPrintSetForm.Button1Click(Sender: TObject);
begin
  Close;
end;

procedure TPrintSetForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

end.
