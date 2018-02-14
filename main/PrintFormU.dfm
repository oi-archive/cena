object PrintForm: TPrintForm
  Left = 361
  Top = 126
  BorderStyle = bsDialog
  Caption = 'Print or Export'
  ClientHeight = 243
  ClientWidth = 477
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 278
    Top = 216
    Width = 85
    Height = 21
    Caption = '&Print'
    Default = True
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 378
    Top = 216
    Width = 85
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 4
    OnClick = Button2Click
  end
  object gb3: TGroupBox
    Left = 14
    Top = 8
    Width = 449
    Height = 201
    Caption = 'Content'
    TabOrder = 0
    object lv1: TListView
      Left = 16
      Top = 40
      Width = 417
      Height = 126
      Columns = <
        item
          Caption = 'Name'
          Width = 100
        end
        item
          Caption = 'Rank'
          Width = 40
        end
        item
          Caption = 'Score'
          Width = 100
        end
        item
          Caption = 'Time'
          Width = 100
        end>
      ColumnClick = False
      HideSelection = False
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      PopupMenu = PopupMenu1
      TabOrder = 1
      ViewStyle = vsReport
    end
    object Panel1: TPanel
      Left = 16
      Top = 16
      Width = 345
      Height = 17
      BevelOuter = bvNone
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 0
      object RadioButton1: TRadioButton
        Left = 0
        Top = 0
        Width = 73
        Height = 17
        Caption = '&Rank List'
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = RadioButton2Click
      end
      object RadioButton2: TRadioButton
        Left = 144
        Top = 0
        Width = 73
        Height = 17
        Caption = 'R&eport'
        TabOrder = 1
        OnClick = RadioButton2Click
      end
    end
    object Panel2: TPanel
      Left = 16
      Top = 176
      Width = 321
      Height = 17
      BevelOuter = bvNone
      Ctl3D = False
      ParentCtl3D = False
      TabOrder = 2
      object RadioButton7: TRadioButton
        Left = 0
        Top = 0
        Width = 137
        Height = 17
        Checked = True
        TabOrder = 0
        TabStop = True
        OnClick = RadioButton2Click
      end
      object RadioButton8: TRadioButton
        Left = 144
        Top = 0
        Width = 177
        Height = 17
        TabOrder = 1
        OnClick = RadioButton2Click
      end
    end
  end
  object Button4: TButton
    Left = -38
    Top = 224
    Width = 85
    Height = 21
    Enabled = False
    TabOrder = 5
    Visible = False
    OnClick = Button4Click
  end
  object Button6: TButton
    Left = 86
    Top = 216
    Width = 85
    Height = 21
    Caption = '&Export'
    TabOrder = 1
    OnClick = Button6Click
  end
  object Button3: TButton
    Left = 184
    Top = 216
    Width = 87
    Height = 21
    Caption = 'Page &Settings...'
    TabOrder = 2
    OnClick = Button3Click
  end
  object PopupMenu1: TPopupMenu
    Left = 190
    Top = 112
    object N1: TMenuItem
      Caption = 'Select &All'
      OnClick = N1Click
    end
    object B1: TMenuItem
      Caption = '&Invert Selection'
      OnClick = B1Click
    end
  end
  object SaveDlg: TSaveDialog
    DefaultExt = 'csv'
    Filter = 'Table (*.csv)|*.csv'
    Title = 'Export'
    Left = 328
  end
end
