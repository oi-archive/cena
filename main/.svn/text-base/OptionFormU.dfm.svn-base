object OptionForm: TOptionForm
  Left = 239
  Top = 252
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 455
  ClientWidth = 426
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 342
    Top = 426
    Width = 75
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 254
    Top = 426
    Width = 75
    Height = 21
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = Button2Click
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 409
    Height = 409
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'General'
      ImageIndex = 1
      object Bevel1: TBevel
        Left = 56
        Top = 16
        Width = 337
        Height = 17
        Shape = bsTopLine
      end
      object Label6: TLabel
        Left = 8
        Top = 8
        Width = 55
        Height = 13
        Caption = 'Gather files'
      end
      object Bevel2: TBevel
        Left = 32
        Top = 108
        Width = 337
        Height = 17
        Shape = bsTopLine
      end
      object Bevel4: TBevel
        Left = 64
        Top = 198
        Width = 337
        Height = 17
        Shape = bsTopLine
      end
      object Label14: TLabel
        Left = 8
        Top = 192
        Width = 91
        Height = 13
        Caption = 'Data Configuration'
      end
      object Panel1: TPanel
        Left = 32
        Top = 24
        Width = 361
        Height = 81
        BevelOuter = bvNone
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 0
        object Label7: TLabel
          Left = 0
          Top = 8
          Width = 89
          Height = 13
          Caption = 'File Name Limitions'
        end
        object CheckBox2: TCheckBox
          Left = 16
          Top = 32
          Width = 281
          Height = 17
          Caption = 'Only gather files whose &name is in the current contest'
          TabOrder = 0
        end
        object CheckBox3: TCheckBox
          Left = 16
          Top = 56
          Width = 281
          Height = 17
          Caption = 'Only gather files whose &extension is in the compiler list'
          TabOrder = 1
        end
      end
      object Panel2: TPanel
        Left = 32
        Top = 112
        Width = 361
        Height = 81
        BevelOuter = bvNone
        TabOrder = 1
        object Label8: TLabel
          Left = 0
          Top = 8
          Width = 81
          Height = 13
          Caption = 'File Size Limitions'
        end
        object Label9: TLabel
          Left = 16
          Top = 56
          Width = 23
          Height = 13
          Caption = 'Size:'
          FocusControl = Edit1
        end
        object Label10: TLabel
          Left = 232
          Top = 56
          Width = 12
          Height = 13
          Caption = 'KB'
        end
        object Edit1: TEdit
          Left = 64
          Top = 52
          Width = 153
          Height = 21
          TabOrder = 1
          Text = '0'
        end
        object CheckBox1: TCheckBox
          Left = 16
          Top = 32
          Width = 233
          Height = 17
          Caption = '&Limit file sizes (for single file)'
          TabOrder = 0
          OnClick = CheckBox1Click
        end
      end
      object Panel3: TPanel
        Left = 32
        Top = 208
        Width = 361
        Height = 97
        BevelOuter = bvNone
        TabOrder = 2
        object Label11: TLabel
          Left = 0
          Top = 8
          Width = 84
          Height = 13
          Caption = 'Default Full &Score'
          FocusControl = Edit2
        end
        object Label12: TLabel
          Left = 0
          Top = 56
          Width = 84
          Height = 13
          Caption = 'Default &Time Limit'
          FocusControl = Edit3
        end
        object Label13: TLabel
          Left = 160
          Top = 8
          Width = 100
          Height = 13
          Caption = 'Default &Memory Limit'
          FocusControl = Edit4
        end
        object Label16: TLabel
          Left = 296
          Top = 28
          Width = 12
          Height = 13
          Caption = 'KB'
        end
        object Label17: TLabel
          Left = 136
          Top = 76
          Width = 20
          Height = 13
          Caption = 'sec.'
        end
        object Edit2: TEdit
          Left = 16
          Top = 24
          Width = 113
          Height = 21
          TabOrder = 0
          Text = '10'
        end
        object Edit3: TEdit
          Left = 16
          Top = 72
          Width = 113
          Height = 21
          TabOrder = 2
          Text = '1'
        end
        object Edit4: TEdit
          Left = 176
          Top = 24
          Width = 113
          Height = 21
          TabOrder = 1
          Text = '2560'
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Programming Languages'
      ImageIndex = 1
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 256
        Height = 13
        Caption = '&Judge programs using these programming languages:'
      end
      object Button3: TButton
        Left = 312
        Top = 24
        Width = 81
        Height = 21
        Caption = '&Add'
        TabOrder = 1
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 312
        Top = 48
        Width = 81
        Height = 21
        Caption = '&Remove'
        TabOrder = 2
        OnClick = Button4Click
      end
      object Button8: TButton
        Left = 312
        Top = 88
        Width = 81
        Height = 21
        Caption = 'Move &Up'
        TabOrder = 3
        OnClick = Button8Click
      end
      object Button9: TButton
        Left = 312
        Top = 112
        Width = 81
        Height = 21
        Caption = 'Move &Down'
        TabOrder = 4
        OnClick = Button9Click
      end
      object grp1: TGroupBox
        Left = 8
        Top = 152
        Width = 385
        Height = 217
        Caption = 'Detail'
        TabOrder = 5
        Visible = False
        object lbl1: TLabel
          Left = 16
          Top = 72
          Width = 103
          Height = 13
          Caption = '&Compilaton Command'
          FocusControl = _commandline
        end
        object lbl3: TLabel
          Left = 16
          Top = 24
          Width = 20
          Height = 13
          Caption = '&Title'
          FocusControl = _title
        end
        object lbl4: TLabel
          Left = 16
          Top = 48
          Width = 47
          Height = 13
          Caption = '&Extension'
          FocusControl = _extension
        end
        object lbl5: TLabel
          Left = 136
          Top = 120
          Width = 227
          Height = 13
          Caption = '%s = Problem'#39's file name (excluding extension)'
        end
        object Label5: TLabel
          Left = 16
          Top = 99
          Width = 97
          Height = 13
          Caption = 'E&xecution Command'
          FocusControl = _executable
        end
        object _commandline: TEdit
          Left = 136
          Top = 72
          Width = 201
          Height = 21
          TabOrder = 2
        end
        object _title: TEdit
          Left = 136
          Top = 24
          Width = 201
          Height = 21
          TabOrder = 0
          OnChange = _titleChange
        end
        object _extension: TEdit
          Left = 136
          Top = 48
          Width = 153
          Height = 21
          TabOrder = 1
          OnChange = _extensionChange
        end
        object _executable: TEdit
          Left = 136
          Top = 96
          Width = 201
          Height = 21
          TabOrder = 3
        end
      end
      object lv1: TListView
        Left = 8
        Top = 24
        Width = 289
        Height = 113
        Checkboxes = True
        Columns = <
          item
            Caption = 'Title'
            Width = 150
          end
          item
            Caption = 'Extension'
            Width = 80
          end>
        ColumnClick = False
        HideSelection = False
        MultiSelect = True
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = lv1Change
        OnChanging = lv1Changing
        OnClick = lv1Click
        OnDblClick = lv1DblClick
      end
    end
  end
end
