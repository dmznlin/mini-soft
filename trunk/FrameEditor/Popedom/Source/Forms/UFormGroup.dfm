object fFormGroup: TfFormGroup
  Left = 341
  Top = 294
  Width = 262
  Height = 180
  BorderIcons = [biSystemMenu, biMinimize]
  Color = clBtnFace
  Constraints.MinHeight = 180
  Constraints.MinWidth = 262
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    254
    153)
  PixelsPerInch = 96
  TextHeight = 12
  object Edit_Name: TLabeledEdit
    Left = 12
    Top = 25
    Width = 226
    Height = 20
    Anchors = [akLeft, akTop, akRight]
    BevelKind = bkTile
    BorderStyle = bsNone
    EditLabel.Width = 42
    EditLabel.Height = 12
    EditLabel.Caption = #32452#21517#31216':'
    MaxLength = 20
    TabOrder = 0
  end
  object Edit_Desc: TLabeledEdit
    Left = 12
    Top = 65
    Width = 226
    Height = 20
    Anchors = [akLeft, akTop, akRight]
    BevelKind = bkTile
    BorderStyle = bsNone
    EditLabel.Width = 42
    EditLabel.Height = 12
    EditLabel.Caption = #32452#25551#36848':'
    MaxLength = 50
    TabOrder = 1
  end
  object BtnOK: TButton
    Left = 100
    Top = 121
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #20445#23384
    Default = True
    TabOrder = 3
    OnClick = BtnOKClick
  end
  object BtnExit: TButton
    Left = 173
    Top = 121
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 4
  end
  object Box_CanDel: TCheckBox
    Left = 13
    Top = 95
    Width = 85
    Height = 17
    Caption = #20801#35768#21024#38500
    Checked = True
    State = cbChecked
    TabOrder = 2
  end
end
