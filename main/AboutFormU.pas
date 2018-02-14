unit AboutFormU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ojconst, jvgnugettext, shellapi,
  JvExControls, JvLinkLabel, JvExStdCtrls, JvHtControls;

type
  TAboutForm = class(TForm)
    btn1: TButton;
    img2: TImage;
    Label2: TLabel;
    Label1: TLabel;
    bvl1: TBevel;
    Label3: TLabel;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.dfm}

procedure TAboutForm.FormCreate(Sender: TObject);
begin
  label1.Caption:=ProductName+' '+ProductVersion;
  TranslateComponent(self);
end;

end.

