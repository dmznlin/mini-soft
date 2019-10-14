object Form1: TForm1
  Left = 503
  Top = 389
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #22522#20110#22270#20687#35782#21035#30340#22320#30917#26080#20154#20540#23432#26381#21153
  ClientHeight = 437
  ClientWidth = 627
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 7
    Top = 8
    Width = 385
    Height = 200
    Caption = #22320#30917#19994#21153
    TabOrder = 0
    object EditTruck: TLabeledEdit
      Left = 12
      Top = 40
      Width = 135
      Height = 20
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #22320#30917#26631#35782':'
      ReadOnly = True
      TabOrder = 0
    end
    object LabeledEdit1: TLabeledEdit
      Left = 12
      Top = 83
      Width = 135
      Height = 20
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #22320#30917#21517#31216':'
      ReadOnly = True
      TabOrder = 1
    end
    object LabeledEdit2: TLabeledEdit
      Left = 12
      Top = 125
      Width = 135
      Height = 20
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #24403#21069#36710#36742':'
      ReadOnly = True
      TabOrder = 2
    end
    object LabeledEdit3: TLabeledEdit
      Left = 12
      Top = 168
      Width = 135
      Height = 20
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #36710#36742#29366#24577':'
      ReadOnly = True
      TabOrder = 3
    end
    object LabeledEdit4: TLabeledEdit
      Left = 230
      Top = 40
      Width = 135
      Height = 20
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #22320#30917#26631#35782':'
      ReadOnly = True
      TabOrder = 4
    end
    object LabeledEdit5: TLabeledEdit
      Left = 230
      Top = 83
      Width = 135
      Height = 20
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #22320#30917#21517#31216':'
      ReadOnly = True
      TabOrder = 5
    end
    object LabeledEdit6: TLabeledEdit
      Left = 230
      Top = 125
      Width = 135
      Height = 20
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #24403#21069#36710#36742':'
      ReadOnly = True
      TabOrder = 6
    end
    object LabeledEdit7: TLabeledEdit
      Left = 230
      Top = 168
      Width = 135
      Height = 20
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #36710#36742#29366#24577':'
      ReadOnly = True
      TabOrder = 7
    end
  end
  object GroupBox2: TGroupBox
    Left = 399
    Top = 8
    Width = 145
    Height = 200
    Caption = #25968#25454#19978#25253
    TabOrder = 1
    object Check1: TCheckBox
      Left = 12
      Top = 29
      Width = 97
      Height = 17
      Caption = #36710#29260#35782#21035
      TabOrder = 0
      OnClick = Check1Click
    end
    object Check2: TCheckBox
      Left = 12
      Top = 56
      Width = 97
      Height = 17
      Caption = #36807#30917#26816#27979
      TabOrder = 1
      OnClick = Check1Click
    end
    object EditIP: TLabeledEdit
      Left = 12
      Top = 109
      Width = 121
      Height = 20
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #19978#25253#22320#22336':'
      TabOrder = 2
      Text = '127.0.0.1'
    end
    object EditPort: TLabeledEdit
      Left = 12
      Top = 149
      Width = 121
      Height = 20
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #19978#25253#31471#21475':'
      TabOrder = 3
      Text = '8080'
    end
  end
  object Memo1: TMemo
    Left = 7
    Top = 216
    Width = 610
    Height = 209
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 16
    Top = 224
  end
  object UDP1: TIdUDPServer
    Bindings = <>
    DefaultPort = 0
    Left = 44
    Top = 224
  end
end
