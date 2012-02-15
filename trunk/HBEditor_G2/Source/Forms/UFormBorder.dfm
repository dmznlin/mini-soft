object fFormBorder: TfFormBorder
  Left = 261
  Top = 136
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 261
  ClientWidth = 330
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    330
    261)
  PixelsPerInch = 96
  TextHeight = 12
  object BtnSend: TButton
    Left = 10
    Top = 225
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #21457#36865
    TabOrder = 0
    OnClick = BtnSendClick
  end
  object BtnOK: TButton
    Left = 183
    Top = 225
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #30830#23450
    TabOrder = 1
    OnClick = BtnOKClick
  end
  object BtnExit: TButton
    Left = 253
    Top = 225
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #21462#28040
    ModalResult = 2
    TabOrder = 2
  end
  object Group1: TGroupBox
    Left = 12
    Top = 102
    Width = 306
    Height = 116
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = #36793#26694#35774#32622
    TabOrder = 3
    object Label3: TLabel
      Left = 15
      Top = 45
      Width = 30
      Height = 12
      Caption = #31867#22411':'
    end
    object Label4: TLabel
      Left = 15
      Top = 68
      Width = 30
      Height = 12
      Caption = #29305#25928':'
    end
    object Label5: TLabel
      Left = 15
      Top = 91
      Width = 30
      Height = 12
      Caption = #36895#24230':'
    end
    object Label6: TLabel
      Left = 178
      Top = 91
      Width = 114
      Height = 12
      Caption = #27880':'#36895#24230'0-15,0'#20026#26368#24555
    end
    object Label7: TLabel
      Left = 165
      Top = 45
      Width = 30
      Height = 12
      Caption = #39068#33394':'
    end
    object Check1: TCheckBox
      Left = 15
      Top = 20
      Width = 97
      Height = 17
      Caption = #20351#29992#36793#26694
      TabOrder = 0
    end
    object EditWidth: TComboBox
      Left = 52
      Top = 42
      Width = 105
      Height = 20
      DropDownCount = 12
      ItemHeight = 12
      TabOrder = 1
      Items.Strings = (
        '1.'#21333#28857#34394#32447
        '2.'#20004#28857#34394#32447
        '3.'#19977#28857#34394#32447
        '4.'#22235#28857#34394#32447
        '5.'#20116#28857#34394#32447
        '6.'#20845#28857#34394#32447
        '7.'#19971#28857#34394#32447
        '8.'#20843#28857#23454#32447
        '9.'#20004#28857#38388#38548
        '0.'#19977#28857#38388#38548)
    end
    object EditEffect: TComboBox
      Left = 52
      Top = 65
      Width = 240
      Height = 20
      DropDownCount = 12
      ItemHeight = 12
      TabOrder = 2
      Items.Strings = (
        #39034#26102#38024#28378#21160
        #36870#26102#38024#28378#21160
        #38745#27490#26174#31034
        #38378#28865#26174#31034)
    end
    object EditSpeed: TEdit
      Left = 52
      Top = 88
      Width = 105
      Height = 20
      TabOrder = 3
    end
    object EditColor: TComboBox
      Left = 202
      Top = 42
      Width = 90
      Height = 18
      Style = csOwnerDrawFixed
      ItemHeight = 12
      TabOrder = 4
      OnDrawItem = EditColorDrawItem
    end
  end
  object GroupBox1: TGroupBox
    Left = 12
    Top = 12
    Width = 306
    Height = 88
    Anchors = [akLeft, akTop, akRight]
    Caption = #36830#25509#35774#32622
    TabOrder = 4
    object Label1: TLabel
      Left = 15
      Top = 28
      Width = 30
      Height = 12
      Alignment = taRightJustify
      Caption = #23631#24149':'
    end
    object Label2: TLabel
      Left = 15
      Top = 57
      Width = 30
      Height = 12
      Alignment = taRightJustify
      Caption = #35774#22791':'
    end
    object EditScreen: TComboBox
      Left = 52
      Top = 26
      Width = 240
      Height = 20
      Style = csDropDownList
      DropDownCount = 12
      ItemHeight = 12
      TabOrder = 0
    end
    object EditDevice: TComboBox
      Left = 52
      Top = 55
      Width = 240
      Height = 20
      Style = csDropDownList
      DropDownCount = 12
      ItemHeight = 12
      TabOrder = 1
    end
  end
end
