object PropForm: TPropForm
  Left = 244
  Top = 55
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Properties'
  ClientHeight = 364
  ClientWidth = 338
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 188
    Top = 338
    Width = 63
    Height = 18
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 262
    Top = 338
    Width = 64
    Height = 18
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 1
    OnClick = Button2Click
  end
  object PageControl1: TPageControl
    Left = 10
    Top = 7
    Width = 316
    Height = 326
    ActivePage = tsRemotePage
    TabOrder = 2
    object tsLocalPage: TTabSheet
      Caption = 'Local'
      object Label8: TLabel
        Left = 7
        Top = 14
        Width = 31
        Height = 13
        Caption = 'Label8'
      end
      object bvl1: TBevel
        Left = 7
        Top = 34
        Width = 292
        Height = 7
        Shape = bsTopLine
      end
      object lblTotalFileSize: TLabel
        Left = 129
        Top = 54
        Width = 72
        Height = 13
        Caption = 'Total File Size: '
        Visible = False
      end
      object lblHighestScore: TLabel
        Left = 14
        Top = 81
        Width = 73
        Height = 13
        Caption = 'Highest Score: '
      end
      object lblLowestScore: TLabel
        Left = 14
        Top = 108
        Width = 71
        Height = 13
        Caption = 'Lowest Score: '
      end
      object lblLowestRank: TLabel
        Left = 14
        Top = 169
        Width = 68
        Height = 13
        Caption = 'Lowest Rank: '
      end
      object lblHighestRank: TLabel
        Left = 14
        Top = 142
        Width = 70
        Height = 13
        Caption = 'Highest Rank: '
      end
    end
    object tsRemotePage: TTabSheet
      Caption = 'Remote'
      ImageIndex = 1
      object Label1: TLabel
        Left = 7
        Top = 14
        Width = 3
        Height = 13
      end
      object Bevel1: TBevel
        Left = 7
        Top = 34
        Width = 292
        Height = 7
        Shape = bsTopLine
      end
      object GroupBox1: TGroupBox
        Left = 7
        Top = 44
        Width = 292
        Height = 248
        Caption = 'Client Info'
        TabOrder = 0
        object Label2: TLabel
          Left = 14
          Top = 50
          Width = 86
          Height = 13
          Caption = 'Operation System'
        end
        object Label3: TLabel
          Left = 14
          Top = 16
          Width = 52
          Height = 13
          Caption = 'IP Address'
        end
        object Label4: TLabel
          Left = 14
          Top = 84
          Width = 27
          Height = 13
          Caption = 'Name'
        end
        object Label5: TLabel
          Left = 14
          Top = 118
          Width = 86
          Height = 13
          Caption = 'Working Directory'
        end
        object Label6: TLabel
          Left = 68
          Top = 10
          Width = 38
          Height = 13
          Caption = 'ClientID'
          Visible = False
        end
        object _address: TEdit
          Left = 14
          Top = 27
          Width = 264
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 1
        end
        object _os: TEdit
          Left = 14
          Top = 61
          Width = 264
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 2
        end
        object _name: TEdit
          Left = 14
          Top = 95
          Width = 264
          Height = 21
          MaxLength = 63
          TabOrder = 3
        end
        object _workdir: TEdit
          Left = 14
          Top = 129
          Width = 264
          Height = 21
          MaxLength = 255
          TabOrder = 4
        end
        object _id: TEdit
          Left = 108
          Top = 7
          Width = 197
          Height = 21
          Color = clBtnFace
          ReadOnly = True
          TabOrder = 0
          Visible = False
        end
        object Button3: TButton
          Left = 149
          Top = 216
          Width = 129
          Height = 18
          Caption = '&Test Network Connections'
          TabOrder = 7
          OnClick = Button3Click
        end
        object _perm: TCheckBox
          Left = 14
          Top = 176
          Width = 258
          Height = 14
          Caption = '&Allow changing settings or exiting from clients'
          TabOrder = 6
        end
        object _usescomputername: TCheckBox
          Left = 14
          Top = 155
          Width = 258
          Height = 14
          Caption = 'Use the computer names as the names of clients'
          TabOrder = 5
        end
        object _autorun: TCheckBox
          Left = 14
          Top = 196
          Width = 258
          Height = 15
          Caption = '&Start automatically at bootup'
          TabOrder = 8
        end
      end
    end
  end
end
