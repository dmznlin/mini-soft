object fFormMain: TfFormMain
  Left = 261
  Top = 136
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #24211#20989#25968#28436#31034
  ClientHeight = 373
  ClientWidth = 323
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  DesignSize = (
    323
    373)
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 12
    Top = 10
    Width = 298
    Height = 115
    Anchors = [akLeft, akTop, akRight]
    Caption = '1.'#20018#21475#35774#32622
    TabOrder = 0
    object Edit1: TLabeledEdit
      Left = 12
      Top = 40
      Width = 165
      Height = 20
      EditLabel.Width = 30
      EditLabel.Height = 12
      EditLabel.Caption = #31471#21475':'
      TabOrder = 0
      Text = 'COM4'
    end
    object Edit2: TLabeledEdit
      Left = 12
      Top = 80
      Width = 165
      Height = 20
      EditLabel.Width = 42
      EditLabel.Height = 12
      EditLabel.Caption = #27874#29305#29575':'
      TabOrder = 1
      Text = '38400'
    end
    object BtnConn: TButton
      Left = 200
      Top = 38
      Width = 75
      Height = 25
      Caption = #36830#25509
      TabOrder = 2
      OnClick = BtnConnClick
    end
    object BtnClose: TButton
      Left = 200
      Top = 76
      Width = 75
      Height = 25
      Caption = #26029#24320
      TabOrder = 3
      OnClick = BtnCloseClick
    end
  end
  object GroupBox2: TGroupBox
    Left = 12
    Top = 138
    Width = 298
    Height = 223
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = '2.'#21457#36865#20869#23481
    TabOrder = 1
    object EditType: TLabeledEdit
      Left = 12
      Top = 40
      Width = 135
      Height = 20
      EditLabel.Width = 60
      EditLabel.Height = 12
      EditLabel.Caption = #21345#31867#22411':0-5'
      TabOrder = 0
      Text = '2'
    end
    object EditNum: TLabeledEdit
      Left = 154
      Top = 40
      Width = 130
      Height = 20
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #21306#22495#25968#30446':'
      TabOrder = 1
      Text = '1'
    end
    object EditArea: TLabeledEdit
      Left = 12
      Top = 80
      Width = 135
      Height = 20
      EditLabel.Width = 120
      EditLabel.Height = 12
      EditLabel.Caption = #21306#22495#22823#23567':'#24038','#19978','#23485','#39640
      TabOrder = 2
      Text = '0,0,32,16'
    end
    object EditFont: TLabeledEdit
      Left = 154
      Top = 80
      Width = 130
      Height = 20
      EditLabel.Width = 108
      EditLabel.Height = 12
      EditLabel.Caption = #23383#20307#20449#24687':'#21517#31216','#22823#23567
      TabOrder = 3
      Text = #23435#20307',9'
    end
    object EditMode: TLabeledEdit
      Left = 12
      Top = 120
      Width = 272
      Height = 20
      EditLabel.Width = 276
      EditLabel.Height = 12
      EditLabel.Caption = #36827#20986#27169#24335':'#20837','#20837#36895#24230','#20572#30041','#20986','#20986#36895#24230','#36319#38543',1('#21333#33394')'
      TabOrder = 4
      Text = '0,5,0,2,0,1,1'
    end
    object EditText: TLabeledEdit
      Left = 12
      Top = 160
      Width = 272
      Height = 20
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #25991#26412#20869#23481':'
      TabOrder = 5
      Text = 'this is the text'
    end
    object BtnSend: TButton
      Left = 211
      Top = 186
      Width = 75
      Height = 25
      Caption = #21457#36865
      TabOrder = 6
      OnClick = BtnSendClick
    end
  end
end
