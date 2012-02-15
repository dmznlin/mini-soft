object fFormSetBrightTime: TfFormSetBrightTime
  Left = 345
  Top = 336
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 230
  ClientWidth = 328
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
    328
    230)
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 12
    Top = 12
    Width = 306
    Height = 90
    Anchors = [akLeft, akTop, akRight]
    Caption = #36830#25509#35774#32622
    TabOrder = 0
    object Label1: TLabel
      Left = 20
      Top = 28
      Width = 30
      Height = 12
      Alignment = taRightJustify
      Caption = #23631#24149':'
    end
    object Label2: TLabel
      Left = 20
      Top = 57
      Width = 30
      Height = 12
      Alignment = taRightJustify
      Caption = #35774#22791':'
    end
    object EditScreen: TComboBox
      Left = 55
      Top = 26
      Width = 235
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 0
      OnChange = EditScreenChange
    end
    object EditDevice: TComboBox
      Left = 55
      Top = 55
      Width = 235
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 1
    end
  end
  object BtnTest: TButton
    Left = 185
    Top = 197
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #30830#23450
    TabOrder = 1
    OnClick = BtnTestClick
  end
  object BtnExit: TButton
    Left = 253
    Top = 197
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #21462#28040
    TabOrder = 2
    OnClick = BtnExitClick
  end
  object GroupBox2: TGroupBox
    Left = 12
    Top = 107
    Width = 306
    Height = 81
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = #23631#24149#20142#24230
    TabOrder = 3
    object Label5: TLabel
      Left = 10
      Top = 25
      Width = 54
      Height = 12
      Alignment = taRightJustify
      Caption = #24320#22987#26102#38388':'
    end
    object Label6: TLabel
      Left = 147
      Top = 27
      Width = 54
      Height = 12
      Alignment = taRightJustify
      Caption = #32467#26463#26102#38388':'
    end
    object Label7: TLabel
      Left = 8
      Top = 54
      Width = 54
      Height = 12
      Caption = #23631#24149#20142#24230':'
    end
    object EditStart: TMaskEdit
      Left = 66
      Top = 23
      Width = 65
      Height = 20
      EditMask = '00:00;1;_'
      MaxLength = 5
      TabOrder = 0
      Text = '  :  '
    end
    object EditEnd: TMaskEdit
      Left = 206
      Top = 25
      Width = 65
      Height = 20
      EditMask = '00:00;1;_'
      MaxLength = 5
      TabOrder = 1
      Text = '  :  '
    end
    object EditBright: TComboBox
      Left = 66
      Top = 50
      Width = 205
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 2
      Text = '0'
      OnChange = EditScreenChange
      Items.Strings = (
        '0'
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7')
    end
  end
end
