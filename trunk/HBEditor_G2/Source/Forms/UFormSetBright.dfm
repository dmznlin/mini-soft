object fFormSetBright: TfFormSetBright
  Left = 316
  Top = 270
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 168
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
    168)
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 12
    Top = 12
    Width = 264
    Height = 118
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = #20142#24230#35774#32622
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
      Left = 20
      Top = 87
      Width = 30
      Height = 12
      Alignment = taRightJustify
      Caption = #20142#24230':'
    end
    object EditScreen: TComboBox
      Left = 55
      Top = 26
      Width = 192
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 0
      OnChange = EditScreenChange
    end
    object EditDevice: TComboBox
      Left = 55
      Top = 55
      Width = 192
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 1
    end
    object EditBright: TComboBox
      Left = 55
      Top = 85
      Width = 192
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      ItemIndex = 0
      TabOrder = 2
      Text = '0'
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
  object BtnTest: TButton
    Left = 143
    Top = 135
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #30830#23450
    TabOrder = 1
    OnClick = BtnTestClick
  end
  object BtnExit: TButton
    Left = 211
    Top = 135
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #21462#28040
    TabOrder = 2
    OnClick = BtnExitClick
  end
end
