object fFormSetWH: TfFormSetWH
  Left = 307
  Top = 289
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 184
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
    184)
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 12
    Top = 12
    Width = 264
    Height = 134
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = #23631#24149#35774#32622
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
      Caption = #23485#24230':'
    end
    object Label4: TLabel
      Left = 146
      Top = 89
      Width = 30
      Height = 12
      Alignment = taRightJustify
      Caption = #39640#24230':'
    end
    object Label5: TLabel
      Left = 20
      Top = 112
      Width = 186
      Height = 12
      Caption = #25552#31034': "'#23485#24230','#39640#24230'"'#20540#20026'8'#30340#25972#25968#20493'.'
    end
    object EditScreen: TComboBox
      Left = 55
      Top = 26
      Width = 190
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 0
      OnChange = EditScreenChange
    end
    object EditDevice: TComboBox
      Left = 55
      Top = 55
      Width = 190
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 1
    end
    object EditW: TEdit
      Left = 55
      Top = 85
      Width = 65
      Height = 20
      TabOrder = 2
    end
    object EditH: TEdit
      Left = 180
      Top = 85
      Width = 65
      Height = 20
      TabOrder = 3
    end
  end
  object BtnTest: TButton
    Left = 143
    Top = 151
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #30830#23450
    TabOrder = 1
    OnClick = BtnTestClick
  end
  object BtnExit: TButton
    Left = 211
    Top = 151
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #21462#28040
    TabOrder = 2
    OnClick = BtnExitClick
  end
end
