object fFormUser: TfFormUser
  Left = 585
  Top = 319
  Width = 285
  Height = 300
  BorderIcons = [biSystemMenu, biMinimize]
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 285
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    277
    273)
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 32
    Top = 182
    Width = 30
    Height = 12
    Caption = #22791#27880':'
  end
  object Label2: TLabel
    Left = 20
    Top = 138
    Width = 42
    Height = 12
    Caption = #25152#22312#32452':'
  end
  object Edit_Name: TLabeledEdit
    Left = 65
    Top = 15
    Width = 200
    Height = 20
    Anchors = [akLeft, akTop, akRight]
    BevelKind = bkTile
    BorderStyle = bsNone
    EditLabel.Width = 42
    EditLabel.Height = 12
    EditLabel.Caption = #29992#25143#21517':'
    LabelPosition = lpLeft
    MaxLength = 32
    TabOrder = 0
    OnKeyDown = Edit_NameKeyDown
  end
  object Edit_Pwd: TLabeledEdit
    Left = 65
    Top = 45
    Width = 200
    Height = 20
    Anchors = [akLeft, akTop, akRight]
    BevelKind = bkTile
    BorderStyle = bsNone
    EditLabel.Width = 54
    EditLabel.Height = 12
    EditLabel.Caption = #29992#25143#23494#30721':'
    LabelPosition = lpLeft
    MaxLength = 16
    PasswordChar = '*'
    TabOrder = 1
    OnKeyDown = Edit_NameKeyDown
  end
  object Edit_Phone: TLabeledEdit
    Left = 65
    Top = 105
    Width = 200
    Height = 20
    Anchors = [akLeft, akTop, akRight]
    BevelKind = bkTile
    BorderStyle = bsNone
    EditLabel.Width = 54
    EditLabel.Height = 12
    EditLabel.Caption = #32852#31995#30005#35805':'
    LabelPosition = lpLeft
    MaxLength = 15
    TabOrder = 3
    OnKeyDown = Edit_NameKeyDown
  end
  object Edit_Mail: TLabeledEdit
    Left = 65
    Top = 75
    Width = 200
    Height = 20
    Anchors = [akLeft, akTop, akRight]
    BevelKind = bkTile
    BorderStyle = bsNone
    EditLabel.Width = 54
    EditLabel.Height = 12
    EditLabel.Caption = #30005#23376#37038#20214':'
    LabelPosition = lpLeft
    MaxLength = 25
    TabOrder = 2
    OnKeyDown = Edit_NameKeyDown
  end
  object Edit_Memo: TMemo
    Left = 65
    Top = 182
    Width = 200
    Height = 51
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelKind = bkTile
    BorderStyle = bsNone
    MaxLength = 50
    TabOrder = 7
    OnKeyDown = Edit_NameKeyDown
  end
  object BtnSave: TButton
    Left = 102
    Top = 242
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #20445#23384
    TabOrder = 8
    OnClick = BtnSaveClick
  end
  object BtnExit: TButton
    Left = 200
    Top = 242
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 9
  end
  object Box_Admin: TCheckBox
    Left = 65
    Top = 160
    Width = 60
    Height = 17
    Caption = #31649#29702#21592
    TabOrder = 5
  end
  object Box_Valid: TCheckBox
    Left = 130
    Top = 160
    Width = 60
    Height = 17
    Caption = #26377#25928
    Checked = True
    State = cbChecked
    TabOrder = 6
  end
  object Edit_Group: TComboBox
    Left = 65
    Top = 135
    Width = 200
    Height = 20
    BevelKind = bkTile
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 12
    TabOrder = 4
    OnKeyDown = Edit_NameKeyDown
  end
end
