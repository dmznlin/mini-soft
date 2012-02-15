object fFormDict: TfFormDict
  Left = 379
  Top = 160
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 437
  ClientWidth = 491
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    491
    437)
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 12
    Top = 12
    Width = 467
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    Caption = #22522#26412#23646#24615
    TabOrder = 0
    object Label1: TLabel
      Left = 242
      Top = 48
      Width = 54
      Height = 12
      Caption = #26159#21542#21487#35265':'
    end
    object Label2: TLabel
      Left = 242
      Top = 21
      Width = 54
      Height = 12
      Caption = #23545#40784#26041#24335':'
    end
    object Edit_Title: TLabeledEdit
      Left = 68
      Top = 18
      Width = 150
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #26174#31034#26631#39064':'
      LabelPosition = lpLeft
      MaxLength = 30
      TabOrder = 0
      OnDblClick = Edit_TitleDblClick
      OnKeyUp = Edit_FteDisplayKeyUp
    end
    object Edit_Width: TLabeledEdit
      Left = 68
      Top = 45
      Width = 150
      Height = 20
      HelpType = htKeyword
      HelpKeyword = 'D'
      BevelKind = bkTile
      BorderStyle = bsNone
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #26631#39064#23485#24230':'
      LabelPosition = lpLeft
      MaxLength = 8
      TabOrder = 1
      Text = '0'
      OnKeyUp = Edit_FteDisplayKeyUp
    end
    object Edit_Index: TLabeledEdit
      Left = 68
      Top = 72
      Width = 150
      Height = 20
      HelpType = htKeyword
      HelpKeyword = 'D'
      BevelKind = bkTile
      BorderStyle = bsNone
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #26631#39064#39034#24207':'
      LabelPosition = lpLeft
      MaxLength = 8
      TabOrder = 2
      Text = '0'
      OnKeyUp = Edit_FteDisplayKeyUp
    end
    object Edit_Align: TComboBox
      Left = 300
      Top = 18
      Width = 150
      Height = 20
      HelpType = htKeyword
      HelpKeyword = 'D'
      BevelKind = bkTile
      ItemHeight = 12
      TabOrder = 3
      OnKeyUp = Edit_FteDisplayKeyUp
    end
    object Edit_Visible: TComboBox
      Left = 300
      Top = 45
      Width = 150
      Height = 20
      HelpType = htKeyword
      HelpKeyword = 'D'
      BevelKind = bkTile
      ItemHeight = 12
      TabOrder = 4
      OnKeyUp = Edit_FteDisplayKeyUp
      Items.Strings = (
        '1=1.'#21487#35265
        '2=2.'#38544#34255)
    end
  end
  object GroupBox2: TGroupBox
    Left = 12
    Top = 121
    Width = 467
    Height = 105
    Anchors = [akLeft, akTop, akRight]
    Caption = #25968#25454#24211
    TabOrder = 1
    object Label3: TLabel
      Left = 242
      Top = 48
      Width = 54
      Height = 12
      Caption = #25968#25454#31867#22411':'
    end
    object Label4: TLabel
      Left = 242
      Top = 75
      Width = 54
      Height = 12
      Caption = #26159#21542#20027#38190':'
    end
    object Edit_Table: TLabeledEdit
      Left = 68
      Top = 18
      Width = 150
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      EditLabel.Width = 42
      EditLabel.Height = 12
      EditLabel.Caption = #34920#21517#31216':'
      LabelPosition = lpLeft
      MaxLength = 32
      TabOrder = 0
      OnDblClick = Edit_TitleDblClick
      OnKeyUp = Edit_FteDisplayKeyUp
    end
    object Edit_Field: TLabeledEdit
      Left = 68
      Top = 45
      Width = 150
      Height = 20
      BevelKind = bkTile
      BorderStyle = bsNone
      EditLabel.Width = 42
      EditLabel.Height = 12
      EditLabel.Caption = #23383#27573#21517':'
      LabelPosition = lpLeft
      MaxLength = 32
      TabOrder = 1
      OnDblClick = Edit_TitleDblClick
      OnKeyUp = Edit_FteDisplayKeyUp
    end
    object Edit_FWidth: TLabeledEdit
      Left = 68
      Top = 72
      Width = 150
      Height = 20
      HelpType = htKeyword
      HelpKeyword = 'D'
      BevelKind = bkTile
      BorderStyle = bsNone
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #23383#27573#23485#24230':'
      LabelPosition = lpLeft
      MaxLength = 4
      TabOrder = 2
      Text = '0'
      OnKeyUp = Edit_FteDisplayKeyUp
    end
    object Edit_Decimal: TLabeledEdit
      Left = 300
      Top = 18
      Width = 150
      Height = 20
      HelpType = htKeyword
      HelpKeyword = 'D'
      BevelKind = bkTile
      BorderStyle = bsNone
      EditLabel.Width = 42
      EditLabel.Height = 12
      EditLabel.Caption = #23567#25968#20301':'
      LabelPosition = lpLeft
      MaxLength = 4
      TabOrder = 3
      Text = '0'
      OnKeyUp = Edit_FteDisplayKeyUp
    end
    object Edit_Type: TComboBox
      Left = 300
      Top = 45
      Width = 150
      Height = 20
      HelpType = htKeyword
      HelpKeyword = 'D'
      BevelKind = bkTile
      ItemHeight = 12
      TabOrder = 4
      OnKeyUp = Edit_FteDisplayKeyUp
    end
    object Edit_IsKey: TComboBox
      Left = 300
      Top = 72
      Width = 150
      Height = 20
      HelpType = htKeyword
      HelpKeyword = 'D'
      BevelKind = bkTile
      ItemHeight = 12
      TabOrder = 5
      OnKeyUp = Edit_FteDisplayKeyUp
      Items.Strings = (
        '1=1.'#26159
        '2=2.'#21542)
    end
  end
  object BtnOK: TButton
    Left = 307
    Top = 398
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #20445#23384
    TabOrder = 4
    OnClick = BtnOKClick
  end
  object BtnExit: TButton
    Left = 404
    Top = 398
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #20851#38381
    TabOrder = 5
    OnClick = BtnExitClick
  end
  object GroupBox3: TGroupBox
    Left = 12
    Top = 231
    Width = 467
    Height = 75
    Anchors = [akLeft, akTop, akRight]
    Caption = #26684#24335#21270
    TabOrder = 2
    object Label5: TLabel
      Left = 32
      Top = 24
      Width = 30
      Height = 12
      Caption = #26041#24335':'
    end
    object Edit_FmtData: TLabeledEdit
      Left = 68
      Top = 45
      Width = 150
      Height = 20
      HelpType = htKeyword
      BevelKind = bkTile
      BorderStyle = bsNone
      EditLabel.Width = 30
      EditLabel.Height = 12
      EditLabel.Caption = #25968#25454':'
      LabelPosition = lpLeft
      MaxLength = 200
      TabOrder = 1
      OnDblClick = Edit_TitleDblClick
      OnKeyUp = Edit_FteDisplayKeyUp
    end
    object Edit_Format: TLabeledEdit
      Left = 300
      Top = 18
      Width = 150
      Height = 20
      HelpType = htKeyword
      BevelKind = bkTile
      BorderStyle = bsNone
      EditLabel.Width = 30
      EditLabel.Height = 12
      EditLabel.Caption = #20869#23481':'
      LabelPosition = lpLeft
      MaxLength = 100
      TabOrder = 2
      OnDblClick = Edit_TitleDblClick
      OnKeyUp = Edit_FteDisplayKeyUp
    end
    object Edit_FmtExt: TLabeledEdit
      Left = 300
      Top = 45
      Width = 150
      Height = 20
      HelpType = htKeyword
      BevelKind = bkTile
      BorderStyle = bsNone
      EditLabel.Width = 30
      EditLabel.Height = 12
      EditLabel.Caption = #25193#23637':'
      LabelPosition = lpLeft
      MaxLength = 100
      TabOrder = 3
      OnDblClick = Edit_TitleDblClick
      OnKeyUp = Edit_FteDisplayKeyUp
    end
    object Edit_Style: TComboBox
      Left = 68
      Top = 18
      Width = 150
      Height = 20
      HelpType = htKeyword
      HelpKeyword = 'D'
      BevelKind = bkTile
      ItemHeight = 12
      TabOrder = 0
      OnKeyUp = Edit_FteDisplayKeyUp
    end
  end
  object GroupBox4: TGroupBox
    Left = 12
    Top = 310
    Width = 467
    Height = 75
    Anchors = [akLeft, akTop, akRight]
    Caption = #21512#35745#20998#32452
    TabOrder = 3
    object Label6: TLabel
      Left = 242
      Top = 21
      Width = 54
      Height = 12
      Caption = #21512#35745#31867#22411':'
    end
    object Label7: TLabel
      Left = 242
      Top = 48
      Width = 54
      Height = 12
      Caption = #21512#35745#20301#32622':'
    end
    object Edit_FteFormat: TLabeledEdit
      Left = 68
      Top = 45
      Width = 150
      Height = 20
      HelpType = htKeyword
      BevelKind = bkTile
      BorderStyle = bsNone
      EditLabel.Width = 42
      EditLabel.Height = 12
      EditLabel.Caption = #26684#24335#21270':'
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 1
      OnDblClick = Edit_TitleDblClick
      OnKeyUp = Edit_FteDisplayKeyUp
    end
    object Edit_FteDisplay: TLabeledEdit
      Left = 68
      Top = 18
      Width = 150
      Height = 20
      HelpType = htKeyword
      BevelKind = bkTile
      BorderStyle = bsNone
      EditLabel.Width = 54
      EditLabel.Height = 12
      EditLabel.Caption = #26174#31034#25991#26412':'
      LabelPosition = lpLeft
      MaxLength = 50
      TabOrder = 0
      OnDblClick = Edit_TitleDblClick
      OnKeyUp = Edit_FteDisplayKeyUp
    end
    object Edit_FteKind: TComboBox
      Left = 300
      Top = 18
      Width = 150
      Height = 20
      HelpType = htKeyword
      HelpKeyword = 'D'
      BevelKind = bkTile
      ItemHeight = 12
      TabOrder = 2
      OnKeyUp = Edit_FteDisplayKeyUp
    end
    object Edit_FtePosition: TComboBox
      Left = 300
      Top = 45
      Width = 150
      Height = 20
      HelpType = htKeyword
      HelpKeyword = 'D'
      BevelKind = bkTile
      ItemHeight = 12
      TabOrder = 3
      OnKeyUp = Edit_FteDisplayKeyUp
    end
  end
end
