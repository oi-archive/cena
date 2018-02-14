unit DropDownFormU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AppEvnts;

type
  TDropDownForm = class(TForm)
    ListBox1: TListBox;
    procedure ListBox1Click(Sender: TObject);
  private
    procedure WMMouseActivate(var Message: TMessage); message WM_MOUSEACTIVATE;
    procedure CreateParams(var Params: TCreateParams); override;
  public
//    TargetType: TClassType;
    Target: TControl;
  end;

var
  DropDownForm: TDropDownForm;

implementation

uses MainFormU;

{$R *.dfm}


procedure TDropDownForm.WMMouseActivate(var Message: TMessage);
begin
  inherited;
  Message.Result := MA_NOACTIVATE;
end;

procedure TDropDownForm.ListBox1Click(Sender: TObject);
begin
  if Target is TMemo then
    (Target as TMemo).Lines.Strings[(Target as TMemo).Perform(EM_LINEFROMCHAR,(Target as TMemo).SelStart,0)]:=listbox1.Items.Strings[listbox1.ItemIndex]
  else
    (Target as TEdit).Text:=listbox1.Items.Strings[listbox1.ItemIndex];
  close;
end;

procedure TDropDownForm.CreateParams(var Params: TCreateParams);
begin
  inherited;
  with Params do begin
    WndParent:=MainForm.Handle;
  end;
end;

end.
