object fFormOCTime: TfFormOCTime
  Left = 377
  Top = 294
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 222
  ClientWidth = 325
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    325
    222)
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 12
    Top = 12
    Width = 303
    Height = 88
    Anchors = [akLeft, akTop, akRight]
    Caption = #36830#25509#35774#32622
    TabOrder = 0
    object Label1: TLabel
      Left = 18
      Top = 28
      Width = 30
      Height = 12
      Alignment = taRightJustify
      Caption = #23631#24149':'
    end
    object Label2: TLabel
      Left = 18
      Top = 57
      Width = 30
      Height = 12
      Alignment = taRightJustify
      Caption = #35774#22791':'
    end
    object EditScreen: TComboBox
      Left = 52
      Top = 26
      Width = 240
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 0
      OnChange = EditScreenChange
    end
    object EditDevice: TComboBox
      Left = 52
      Top = 55
      Width = 240
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 1
    end
  end
  object BtnTest: TButton
    Left = 182
    Top = 189
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #30830#23450
    TabOrder = 1
    OnClick = BtnTestClick
  end
  object BtnExit: TButton
    Left = 250
    Top = 189
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #21462#28040
    TabOrder = 2
    OnClick = BtnExitClick
  end
  object GroupBox2: TGroupBox
    Left = 12
    Top = 105
    Width = 303
    Height = 78
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = #24320#20851#35774#32622
    TabOrder = 3
    object Label3: TLabel
      Left = 10
      Top = 47
      Width = 54
      Height = 12
      Caption = #24320#22987#26102#38388':'
    end
    object Label4: TLabel
      Left = 155
      Top = 47
      Width = 54
      Height = 12
      Alignment = taRightJustify
      Caption = #32467#26463#26102#38388':'
    end
    object Check1: TCheckBox
      Left = 10
      Top = 20
      Width = 165
      Height = 17
      Caption = #21551#29992#33258#21160#24320#20851#26426
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = Check1Click
    end
    object EditStart: TMaskEdit
      Left = 66
      Top = 45
      Width = 75
      Height = 20
      EditMask = '00:00;1;_'
      MaxLength = 5
      TabOrder = 1
      Text = '  :  '
    end
    object EditEnd: TMaskEdit
      Left = 212
      Top = 45
      Width = 75
      Height = 20
      EditMask = '00:00;1;_'
      MaxLength = 5
      TabOrder = 2
      Text = '  :  '
    end
  end
end
