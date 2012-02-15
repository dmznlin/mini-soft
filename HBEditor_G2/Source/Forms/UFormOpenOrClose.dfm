object fFormOpenOrClose: TfFormOpenOrClose
  Left = 316
  Top = 270
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 160
  ClientWidth = 286
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
    286
    160)
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 12
    Top = 12
    Width = 264
    Height = 110
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = #24320'/'#20851#35774#32622
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
    object Label3: TLabel
      Left = 15
      Top = 87
      Width = 30
      Height = 12
      Caption = #25805#20316':'
    end
    object EditScreen: TComboBox
      Left = 52
      Top = 26
      Width = 190
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 0
      OnChange = EditScreenChange
    end
    object EditDevice: TComboBox
      Left = 52
      Top = 55
      Width = 190
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 1
    end
    object Radio1: TRadioButton
      Left = 50
      Top = 85
      Width = 55
      Height = 17
      Caption = #25171#24320
      TabOrder = 2
    end
    object Radio2: TRadioButton
      Left = 108
      Top = 85
      Width = 55
      Height = 17
      Caption = #20851#38381
      Checked = True
      TabOrder = 3
      TabStop = True
    end
  end
  object BtnTest: TButton
    Left = 143
    Top = 127
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #30830#23450
    TabOrder = 1
    OnClick = BtnTestClick
  end
  object BtnExit: TButton
    Left = 211
    Top = 127
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #21462#28040
    TabOrder = 2
    OnClick = BtnExitClick
  end
end
