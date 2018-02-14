object NewForm: TNewForm
  Left = 204
  Top = 252
  Width = 525
  Height = 434
  BorderIcons = [biSystemMenu]
  Caption = 'New or Open'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Shell Dlg 2'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TButton
    Left = 324
    Top = 378
    Width = 85
    Height = 21
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 420
    Top = 378
    Width = 85
    Height = 21
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object pgc1: TPageControl
    Left = 8
    Top = 8
    Width = 497
    Height = 361
    ActivePage = ts2
    TabOrder = 0
    OnChange = pgc1Change
    object ts1: TTabSheet
      Caption = 'New'
      OnResize = ts1Resize
      object Label1: TLabel
        Left = 16
        Top = 23
        Width = 72
        Height = 13
        Caption = '&Contest Title'
        FocusControl = _title
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Shell Dlg 2'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object Label2: TLabel
        Left = 16
        Top = 82
        Width = 41
        Height = 13
        Caption = '&Save in'
        FocusControl = _root
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'MS Shell Dlg 2'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object SpeedButton1: TSpeedButton
        Left = 440
        Top = 98
        Width = 25
        Height = 20
        Caption = '...'
        OnClick = SpeedButton1Click
      end
      object _title: TEdit
        Left = 16
        Top = 40
        Width = 449
        Height = 21
        TabOrder = 0
        OnChange = _titleChange
      end
      object _root: TEdit
        Left = 16
        Top = 98
        Width = 417
        Height = 21
        TabOrder = 2
        OnChange = _rootChange
      end
      object _juror: TEdit
        Left = 112
        Top = 162
        Width = 249
        Height = 21
        Enabled = False
        TabOrder = 1
        Visible = False
      end
    end
    object ts2: TTabSheet
      Caption = 'Recent'
      ImageIndex = 1
      OnResize = ts2Resize
      object lv1: TListView
        Left = 8
        Top = 8
        Width = 473
        Height = 313
        Columns = <
          item
            Caption = 'Title'
            Width = 100
          end
          item
            Caption = 'Folder'
            Width = 200
          end
          item
            Caption = 'Problems'
            Width = 150
          end>
        ReadOnly = True
        RowSelect = True
        PopupMenu = PopupMenu1
        TabOrder = 0
        ViewStyle = vsReport
        OnChange = lv1Change
        OnDblClick = lv1DblClick
      end
    end
    object ts3: TTabSheet
      Caption = 'Specified'
      ImageIndex = 2
      OnResize = ts3Resize
      object ShellTreeView1: TShellTreeView
        Left = 8
        Top = 8
        Width = 473
        Height = 281
        ObjectTypes = [otFolders]
        Root = 'rfDesktop'
        UseShellImages = True
        AutoRefresh = False
        HideSelection = False
        Indent = 19
        ParentColor = False
        RightClickSelect = True
        ShowRoot = False
        TabOrder = 0
        OnChange = ShellTreeView1Change
      end
      object edt1: TEdit
        Left = 8
        Top = 301
        Width = 473
        Height = 21
        TabOrder = 1
        OnChange = edt1Change
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 184
    Top = 376
    object Deletefromlist1: TMenuItem
      Caption = '&Delete from list'
      OnClick = Deletefromlist1Click
    end
  end
end
