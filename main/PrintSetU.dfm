object PrintSetForm: TPrintSetForm
  Left = 386
  Top = 163
  BorderStyle = bsDialog
  Caption = 'Page Settings'
  ClientHeight = 380
  ClientWidth = 438
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 10
    Top = 28
    Width = 417
    Height = 5
    Shape = bsTopLine
  end
  object Label5: TLabel
    Left = 152
    Top = 136
    Width = 38
    Height = 13
    Caption = '&Buttom:'
  end
  object Label4: TLabel
    Left = 152
    Top = 48
    Width = 22
    Height = 13
    Caption = '&Top:'
  end
  object Label3: TLabel
    Left = 272
    Top = 88
    Width = 29
    Height = 13
    Caption = '&Right:'
  end
  object Label2: TLabel
    Left = 24
    Top = 88
    Width = 23
    Height = 13
    Caption = '&Left:'
  end
  object Label1: TLabel
    Left = 8
    Top = 22
    Width = 32
    Height = 13
    Caption = 'Margin'
  end
  object Bevel2: TBevel
    Left = 10
    Top = 284
    Width = 417
    Height = 13
    Shape = bsTopLine
  end
  object Bevel3: TBevel
    Left = 10
    Top = 172
    Width = 417
    Height = 13
    Shape = bsTopLine
  end
  object Bevel4: TBevel
    Left = 10
    Top = 336
    Width = 417
    Height = 13
    Shape = bsTopLine
  end
  object Label6: TLabel
    Left = 8
    Top = 166
    Width = 32
    Height = 13
    Caption = 'Footer'
  end
  object Label7: TLabel
    Left = 8
    Top = 278
    Width = 28
    Height = 13
    Caption = 'Other'
  end
  object SpinEdit4: TSpinEdit
    Left = 192
    Top = 132
    Width = 105
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 100
  end
  object SpinEdit3: TSpinEdit
    Left = 312
    Top = 84
    Width = 105
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 3
    Value = 100
  end
  object SpinEdit2: TSpinEdit
    Left = 64
    Top = 84
    Width = 105
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 2
    Value = 100
  end
  object SpinEdit1: TSpinEdit
    Left = 192
    Top = 44
    Width = 105
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 0
    Value = 100
  end
  object RadioButton5: TRadioButton
    Left = 40
    Top = 232
    Width = 97
    Height = 17
    Caption = '&Custom'
    TabOrder = 6
    OnClick = RadioButton3Click
  end
  object RadioButton4: TRadioButton
    Left = 40
    Top = 208
    Width = 361
    Height = 17
    Caption = 'C&ontest Title'
    TabOrder = 5
    OnClick = RadioButton3Click
  end
  object RadioButton3: TRadioButton
    Left = 40
    Top = 184
    Width = 353
    Height = 17
    Caption = 'Current &Date and Time'
    Checked = True
    TabOrder = 4
    TabStop = True
    OnClick = RadioButton3Click
  end
  object Edit5: TEdit
    Left = 152
    Top = 232
    Width = 265
    Height = 21
    TabOrder = 7
  end
  object Button5: TButton
    Left = 168
    Top = 300
    Width = 120
    Height = 21
    Caption = 'Print &Font...'
    TabOrder = 9
    OnClick = Button5Click
  end
  object Button3: TButton
    Left = 40
    Top = 300
    Width = 120
    Height = 21
    Caption = '&Printer Setup...'
    TabOrder = 8
    OnClick = Button3Click
  end
  object Button1: TButton
    Left = 340
    Top = 348
    Width = 85
    Height = 21
    Caption = 'OK'
    Default = True
    TabOrder = 10
    OnClick = Button1Click
  end
  object FontDlg: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 384
    Top = 40
  end
  object PSDlg: TPrinterSetupDialog
    Left = 352
    Top = 40
  end
end
