object fFormAdjustTime: TfFormAdjustTime
  Left = 316
  Top = 270
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 168
  ClientWidth = 335
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
    335
    168)
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 12
    Top = 12
    Width = 313
    Height = 118
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = #26102#38388#35774#32622
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
      Caption = #26102#38388':'
    end
    object EditScreen: TComboBox
      Left = 55
      Top = 26
      Width = 242
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 0
      OnChange = EditScreenChange
    end
    object EditDevice: TComboBox
      Left = 55
      Top = 55
      Width = 242
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 1
    end
    object EditTime: TMaskEdit
      Left = 55
      Top = 85
      Width = 242
      Height = 20
      EditMask = '00'#24180'00'#26376'00'#26085'  '#26143#26399':0  '#26102#38388':00'#26102'00'#20998'00'#31186';1;_'
      MaxLength = 39
      TabOrder = 2
      Text = '  '#24180'  '#26376'  '#26085'  '#26143#26399':   '#26102#38388':  '#26102'  '#20998'  '#31186
    end
  end
  object BtnTest: TButton
    Left = 192
    Top = 135
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #26657#20934
    TabOrder = 1
    OnClick = BtnTestClick
  end
  object BtnExit: TButton
    Left = 260
    Top = 135
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #21462#28040
    TabOrder = 2
    OnClick = BtnExitClick
  end
end
