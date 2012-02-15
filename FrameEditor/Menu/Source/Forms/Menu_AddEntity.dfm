object FrmEntity: TFrmEntity
  Left = 570
  Top = 306
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 203
  ClientWidth = 322
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object BtnSave: TButton
    Left = 136
    Top = 167
    Width = 72
    Height = 22
    Caption = #20445#23384
    TabOrder = 1
    OnClick = BtnSaveClick
  end
  object Button2: TButton
    Left = 233
    Top = 167
    Width = 72
    Height = 22
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 12
    Top = 12
    Width = 293
    Height = 141
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object Label1: TLabel
      Left = 14
      Top = 114
      Width = 216
      Height = 12
      Caption = #25552#31034': "'#23454#20307#26631#35782'"'#20026#31354#26102#34920#31034'"'#31243#24207#26631#35782'"'
    end
    object Edit_Entity: TLabeledEdit
      Left = 70
      Top = 50
      Width = 200
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      CharCase = ecUpperCase
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #23454#20307#26631#35782':'
      LabelPosition = lpLeft
      MaxLength = 15
      TabOrder = 1
      OnKeyPress = Edit_ProgKeyPress
    end
    object Edit_Prog: TLabeledEdit
      Left = 70
      Top = 16
      Width = 200
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      CharCase = ecUpperCase
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #31243#24207#26631#35782':'
      LabelPosition = lpLeft
      MaxLength = 15
      TabOrder = 0
      OnKeyPress = Edit_ProgKeyPress
    end
    object Edit_Desc: TLabeledEdit
      Left = 70
      Top = 80
      Width = 200
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #26631#35782#25551#36848':'
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 2
      OnKeyPress = Edit_ProgKeyPress
    end
  end
end
