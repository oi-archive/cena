object MainForm: TMainForm
  Left = 195
  Top = 516
  BorderIcons = []
  BorderStyle = bsToolWindow
  Caption = 'Cena Client'
  ClientHeight = 153
  ClientWidth = 202
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object UDP: TIdUDPServer
    Active = True
    BroadcastEnabled = True
    Bindings = <>
    DefaultPort = 12574
    OnUDPRead = UDPUDPRead
    Left = 32
    Top = 24
  end
  object PopupMenu1: TPopupMenu
    Left = 32
    Top = 56
    object V1: TMenuItem
      Caption = '&View Judge Result...'
      Default = True
      Visible = False
      OnClick = V1Click
    end
    object N1: TMenuItem
      Caption = '-'
      Visible = False
    end
    object U1: TMenuItem
      Caption = 'UI &Language'
      Visible = False
      object N2: TMenuItem
        Caption = '&Default'
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object N4: TMenuItem
        Caption = #31616#20307#20013#25991'(&S)'
      end
      object N5: TMenuItem
        Caption = '&English'
      end
    end
    object O1: TMenuItem
      Caption = #36873#39033'(&O)...'
      OnClick = O1Click
    end
    object N21: TMenuItem
      Caption = '-'
    end
    object A1: TMenuItem
      Caption = #20851#20110'(&A)...'
      OnClick = A1Click
    end
    object X1: TMenuItem
      Caption = #36864#20986'(&X)'
      OnClick = X1Click
    end
  end
  object IdTCPServer1: TIdTCPServer
    Active = True
    Bindings = <>
    CommandHandlers = <
      item
        CmdDelimiter = ' '
        Disconnect = False
        Name = 'TIdCommandHandler0'
        ParamDelimiter = ' '
        ReplyExceptionCode = 0
        ReplyNormal.NumericCode = 0
        Tag = 0
      end>
    CommandHandlersEnabled = False
    DefaultPort = 12574
    Greeting.NumericCode = 0
    MaxConnectionReply.NumericCode = 0
    OnConnect = IdTCPServer1Connect
    ReplyExceptionCode = 0
    ReplyTexts = <>
    ReplyUnknownCommand.NumericCode = 0
    Left = 72
    Top = 24
  end
  object Timer1: TTimer
    Interval = 10
    OnTimer = Timer1Timer
    Left = 72
    Top = 56
  end
  object Timer2: TTimer
    Interval = 10000
    OnTimer = Timer2Timer
    Left = 152
    Top = 56
  end
end
