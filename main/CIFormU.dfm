object CIForm: TCIForm
  Left = 165
  Top = 249
  BorderStyle = bsDialog
  Caption = 'Distribute Clients'
  ClientHeight = 287
  ClientWidth = 337
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 24
    Width = 69
    Height = 13
    Caption = '&Listening Port:'
  end
  object Edit1: TEdit
    Left = 96
    Top = 22
    Width = 57
    Height = 21
    TabOrder = 0
    Text = '80'
  end
  object Button1: TButton
    Left = 208
    Top = 22
    Width = 113
    Height = 21
    Caption = '&Start Service'
    Default = True
    TabOrder = 1
    OnClick = Button1Click
  end
  object mmo1: TMemo
    Left = 16
    Top = 56
    Width = 305
    Height = 209
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object hs1: TIdHTTPServer
    Bindings = <>
    CommandHandlers = <>
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    OnCommandGet = hs1CommandGet
    Left = 160
    Top = 8
  end
end
