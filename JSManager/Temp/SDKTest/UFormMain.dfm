object Form1: TForm1
  Left = 489
  Top = 217
  Width = 869
  Height = 580
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 120
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 861
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Button1: TButton
      Left = 90
      Top = 8
      Width = 75
      Height = 25
      Caption = 'config'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Logs'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Tag = 10
      Left = 517
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Start'
      Enabled = False
      TabOrder = 2
      OnClick = Button3Click
    end
    object Edit1: TEdit
      Left = 281
      Top = 10
      Width = 70
      Height = 23
      TabOrder = 3
      Text = 'ZT001'
    end
    object Edit3: TEdit
      Left = 437
      Top = 10
      Width = 65
      Height = 23
      TabOrder = 4
      Text = '10'
    end
    object Button4: TButton
      Tag = 10
      Left = 597
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Stop'
      Enabled = False
      TabOrder = 5
      OnClick = Button4Click
    end
    object Button5: TButton
      Tag = 10
      Left = 677
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Status'
      Enabled = False
      TabOrder = 6
      OnClick = Button5Click
    end
    object Edit2: TEdit
      Left = 359
      Top = 10
      Width = 70
      Height = 23
      TabOrder = 7
      Text = #35947'A123'
    end
    object CheckBox1: TCheckBox
      Left = 180
      Top = 14
      Width = 97
      Height = 17
      Caption = #26381#21153#29366#24577
      TabOrder = 8
      OnClick = CheckBox1Click
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 41
    Width = 861
    Height = 507
    Align = alClient
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
