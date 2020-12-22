object fFormMain: TfFormMain
  Left = 648
  Top = 391
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 392
  ClientWidth = 336
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Group1: TGroupBox
    Left = 8
    Top = 8
    Width = 320
    Height = 81
    Caption = #26381#21153#22120
    TabOrder = 0
    object EditIP: TLabeledEdit
      Left = 48
      Top = 24
      Width = 121
      Height = 20
      EditLabel.Width = 30
      EditLabel.Height = 12
      EditLabel.Caption = #22320#22336':'
      LabelPosition = lpLeft
      TabOrder = 0
      Text = '127.0.0.1'
    end
    object EditPort: TLabeledEdit
      Left = 48
      Top = 48
      Width = 121
      Height = 20
      EditLabel.Width = 30
      EditLabel.Height = 12
      EditLabel.Caption = #31471#21475':'
      LabelPosition = lpLeft
      TabOrder = 1
      Text = '8080'
    end
    object Check1: TCheckBox
      Left = 184
      Top = 49
      Width = 65
      Height = 17
      Caption = #36830#25509
      TabOrder = 2
      OnClick = Check1Click
    end
  end
  object Group2: TGroupBox
    Left = 8
    Top = 96
    Width = 320
    Height = 65
    Caption = #25805#20316
    TabOrder = 1
    object BtnSend: TButton
      Left = 120
      Top = 24
      Width = 75
      Height = 25
      Caption = #19978#20256#25968#25454
      TabOrder = 0
      OnClick = BtnSendClick
    end
    object BtnQuery: TButton
      Left = 200
      Top = 24
      Width = 75
      Height = 25
      Caption = #26597#35810#25968#25454
      TabOrder = 1
      OnClick = BtnQueryClick
    end
    object EditID: TLabeledEdit
      Left = 48
      Top = 27
      Width = 65
      Height = 20
      EditLabel.Width = 18
      EditLabel.Height = 12
      EditLabel.Caption = 'ID:'
      LabelPosition = lpLeft
      TabOrder = 2
      Text = '1010'
    end
  end
  object Memo1: TMemo
    Left = 8
    Top = 170
    Width = 321
    Height = 209
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object IdClient1: TIdTCPClient
    OnStatus = IdClient1Status
    OnDisconnected = IdClient1Disconnected
    OnConnected = IdClient1Connected
    ConnectTimeout = 3000
    IPVersion = Id_IPv4
    Port = 0
    ReadTimeout = -1
    Left = 272
    Top = 40
  end
end
