unit ResultFormU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus, StdCtrls, ExtCtrls, Buttons, OleCtrls, SHDocVw,
  ojtc, ojrc, ojconst, AppEvnts;

type
  TResultForm = class(TForm)
    PopupMenu1: TPopupMenu;
    E1: TMenuItem;
    P1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    wb: TWebBrowser;
    Label1: TLabel;
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    PeopleName:string;
    ListItem:TListItem;
  end;

var
  ResultForm: TResultForm;

implementation

{$R *.dfm}

procedure TResultForm.FormResize(Sender: TObject);
begin
  wb.Width:=ClientWidth;
  wb.Height:=ClientHeight;
end;

procedure TResultForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
  ResultForm:=nil;
end;

end.
