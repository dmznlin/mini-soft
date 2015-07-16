object FrmNew: TFrmNew
  Left = 531
  Top = 273
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 401
  ClientWidth = 372
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    372
    401)
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 14
    Top = 350
    Width = 246
    Height = 12
    Anchors = [akLeft, akBottom]
    Caption = #25552#31034': '#25353'Shift'#38190#28155#21152'"'#31243#24207#26631#35782'"'#25110'"'#23454#20307#26631#35782'"'
  end
  object BtnSave: TButton
    Left = 189
    Top = 369
    Width = 72
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #20445#23384
    TabOrder = 1
    OnClick = BtnSaveClick
  end
  object BtnExit: TButton
    Left = 284
    Top = 369
    Width = 72
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 2
  end
  object Panel1: TPanel
    Left = 12
    Top = 12
    Width = 344
    Height = 325
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    DesignSize = (
      344
      325)
    object Label2: TLabel
      Left = 18
      Top = 20
      Width = 54
      Height = 12
      Caption = #31243#24207#26631#35782':'
    end
    object Label3: TLabel
      Left = 18
      Top = 46
      Width = 54
      Height = 12
      Caption = #23454#20307#26631#35782':'
    end
    object Label4: TLabel
      Left = 17
      Top = 98
      Width = 54
      Height = 12
      Caption = #19978#32423#33756#21333':'
    end
    object Edit_Menu: TLabeledEdit
      Left = 76
      Top = 69
      Width = 247
      Height = 20
      Hint = 'Menu.M_MenuID'
      HelpType = htKeyword
      HelpKeyword = 'NU'
      HelpContext = 1
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      CharCase = ecUpperCase
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #33756#21333#26631#35782':'
      LabelPosition = lpLeft
      MaxLength = 15
      TabOrder = 2
      OnKeyDown = Edit_MenuKeyDown
    end
    object Edit_ProgID: TComboBox
      Left = 76
      Top = 15
      Width = 247
      Height = 20
      Hint = 'Menu.M_ProgID'
      HelpType = htKeyword
      HelpKeyword = 'C|NU'
      HelpContext = 1
      BevelKind = bkTile
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 12
      TabOrder = 0
      OnChange = Edit_ProgIDChange
      OnKeyDown = Edit_MenuKeyDown
      Items.Strings = (
        'M_ProgID=Select M_ProgID,M_Title From $Menu Where M_Entity='#39#39)
    end
    object Edit_Entity: TComboBox
      Left = 76
      Top = 42
      Width = 247
      Height = 20
      Hint = 'Menu.M_Entity'
      HelpType = htKeyword
      HelpKeyword = 'NU'
      HelpContext = 1
      BevelKind = bkTile
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 12
      TabOrder = 1
      OnChange = Edit_EntityChange
      OnKeyDown = Edit_MenuKeyDown
    end
    object Edit_PMenu: TComboBox
      Left = 76
      Top = 97
      Width = 247
      Height = 20
      Hint = 'Menu.M_PMenu'
      BevelKind = bkTile
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 12
      TabOrder = 3
      OnKeyDown = Edit_MenuKeyDown
    end
    object Edit_Title: TLabeledEdit
      Left = 76
      Top = 124
      Width = 247
      Height = 20
      Hint = 'Menu.M_Title'
      HelpContext = 1
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      CharCase = ecUpperCase
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #33756#21333#26631#39064':'
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 4
      OnKeyDown = Edit_MenuKeyDown
    end
    object Edit_Img: TLabeledEdit
      Left = 76
      Top = 151
      Width = 247
      Height = 20
      Hint = 'Menu.M_ImgIndex'
      HelpKeyword = 'D'
      HelpContext = 1
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      CharCase = ecUpperCase
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #22270#26631#32034#24341':'
      LabelPosition = lpLeft
      MaxLength = 5
      TabOrder = 5
      Text = '-1'
      OnKeyDown = Edit_MenuKeyDown
    end
    object Edit_Flag: TLabeledEdit
      Left = 76
      Top = 178
      Width = 247
      Height = 20
      Hint = 'Menu.M_Flag'
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      CharCase = ecUpperCase
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #38468#21152#21442#25968':'
      LabelPosition = lpLeft
      MaxLength = 20
      TabOrder = 6
      OnKeyDown = Edit_MenuKeyDown
    end
    object Edit_Action: TLabeledEdit
      Left = 76
      Top = 206
      Width = 247
      Height = 20
      Hint = 'Menu.M_Action'
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      CharCase = ecUpperCase
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #33756#21333#21160#20316':'
      LabelPosition = lpLeft
      MaxLength = 100
      TabOrder = 7
      OnKeyDown = Edit_MenuKeyDown
    end
    object Edit_Filter: TLabeledEdit
      Left = 76
      Top = 233
      Width = 247
      Height = 20
      Hint = 'Menu.M_Filter'
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      CharCase = ecUpperCase
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #36807#28388#26465#20214':'
      LabelPosition = lpLeft
      MaxLength = 100
      TabOrder = 8
      OnKeyDown = Edit_MenuKeyDown
    end
    object Edit_Order: TLabeledEdit
      Left = 76
      Top = 260
      Width = 247
      Height = 20
      Hint = 'Menu.M_NewOrder'
      HelpKeyword = 'D'
      HelpContext = 1
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      CharCase = ecUpperCase
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #21019#24314#24207#21015':'
      LabelPosition = lpLeft
      MaxLength = 7
      TabOrder = 9
      Text = '0'
      OnKeyDown = Edit_MenuKeyDown
    end
    object Edit_Lang: TLabeledEdit
      Left = 76
      Top = 288
      Width = 247
      Height = 20
      Hint = 'Menu.M_LangID'
      Anchors = [akLeft, akTop, akRight]
      BevelKind = bkTile
      BorderStyle = bsNone
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #35821#35328#26631#35782':'
      LabelPosition = lpLeft
      MaxLength = 12
      TabOrder = 10
      OnKeyDown = Edit_MenuKeyDown
    end
  end
end
