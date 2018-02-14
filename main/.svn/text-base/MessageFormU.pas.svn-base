unit MessageFormU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, ComCtrls, MyUtils, IdBaseComponent, IdComponent,
  IdUDPBase, IdUDPServer, MyTypes, ExtCtrls, IdTCPServer, IdUDPClient, IdSocketHandle,
  IdTCPConnection, IdTCPClient, GatherThreadU, ojtc, jvgnugettext;

type
  TMessageForm = class(TForm)
    lb: TListBox;
    procedure FormResize(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    procedure CreateParams(var Params: TCreateParams); override;
  public
    { Public declarations }
  end;

var
  MessageForm: TMessageForm;

implementation

uses MainFormU;

{$R *.dfm}

procedure TMessageForm.FormResize(Sender: TObject);
begin
  lb.Width:=ClientWidth;
  lb.Height:=ClientHeight;
end;

procedure TMessageForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  lb.Clear;
end;

procedure TMessageForm.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
end;

procedure TMessageForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WndParent:=MainForm.Handle;
end;

end.

