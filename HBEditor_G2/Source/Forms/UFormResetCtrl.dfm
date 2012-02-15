object fFormResetCtrl: TfFormResetCtrl
  Left = 461
  Top = 346
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 142
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
    142)
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 12
    Top = 12
    Width = 264
    Height = 92
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = #22797#20301#35774#32622
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
      Left = 50
      Top = 26
      Width = 200
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 0
      OnChange = EditScreenChange
    end
    object EditDevice: TComboBox
      Left = 50
      Top = 55
      Width = 200
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 1
    end
  end
  object BtnTest: TButton
    Left = 143
    Top = 109
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #22797#20301
    TabOrder = 1
    OnClick = BtnTestClick
  end
  object BtnExit: TButton
    Left = 211
    Top = 109
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #21462#28040
    TabOrder = 2
    OnClick = BtnExitClick
  end
end
