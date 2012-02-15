object fFormPlayDays: TfFormPlayDays
  Left = 316
  Top = 270
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 181
  ClientWidth = 288
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
    288
    181)
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 12
    Top = 12
    Width = 266
    Height = 131
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = #22825#25968#35774#32622
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
      Caption = #22825#25968':'
    end
    object Label4: TLabel
      Left = 20
      Top = 110
      Width = 162
      Height = 12
      Caption = #25552#31034': "'#22825#25968'"'#20540#20026'0-9999'#20043#38388'.'
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
    object EditDays: TEdit
      Left = 55
      Top = 84
      Width = 85
      Height = 20
      TabOrder = 2
      Text = '9999'
    end
    object Check1: TCheckBox
      Left = 150
      Top = 85
      Width = 97
      Height = 17
      Caption = #26080#38480#26399#25773#25918
      Checked = True
      State = cbChecked
      TabOrder = 3
    end
  end
  object BtnTest: TButton
    Left = 145
    Top = 148
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #30830#23450
    TabOrder = 1
    OnClick = BtnTestClick
  end
  object BtnExit: TButton
    Left = 213
    Top = 148
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #21462#28040
    TabOrder = 2
    OnClick = BtnExitClick
  end
end
