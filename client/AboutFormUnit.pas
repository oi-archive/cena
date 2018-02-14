unit AboutFormUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, libojcd, ojconst;

type
  TAboutForm = class(TForm)
    btn1: TButton;
    img2: TImage;
    lbl3: TLabel;
    bvl1: TBevel;
    Label1: TLabel;
    procedure btn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

uses MainFormUnit, jvgnugettext;

{$R *.dfm}

procedure TAboutForm.btn1Click(Sender: TObject);
begin
  Close;
end;

procedure TAboutForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
  AboutForm:=nil;
end;

procedure TAboutForm.FormShow(Sender: TObject);
begin
  label1.Caption:='Cena Client '+ProductVersion+'.'+IntToStr(ClientInfo.Version);
end;

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  jvgnugettext.TranslateComponent(self);
end;

end.
