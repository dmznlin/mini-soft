object fFormStatus: TfFormStatus
  Left = 373
  Top = 245
  Width = 345
  Height = 380
  BorderIcons = [biSystemMenu, biMinimize]
  Color = clBtnFace
  Constraints.MinHeight = 380
  Constraints.MinWidth = 345
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PopupMenu = PMenu1
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    337
    346)
  PixelsPerInch = 96
  TextHeight = 12
  object Label3: TLabel
    Left = 12
    Top = 112
    Width = 54
    Height = 12
    Caption = #29366#24577#20449#24687':'
  end
  object GroupBox1: TGroupBox
    Left = 12
    Top = 12
    Width = 312
    Height = 88
    Anchors = [akLeft, akTop, akRight]
    Caption = #36830#25509#35774#32622
    TabOrder = 0
    DesignSize = (
      312
      88)
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
    object BtnRead: TButton
      Left = 250
      Top = 55
      Width = 55
      Height = 20
      Anchors = [akRight, akBottom]
      Caption = #35835#21462
      TabOrder = 2
      OnClick = BtnReadClick
    end
  end
  object BtnExit: TButton
    Left = 262
    Top = 313
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #20851#38381
    TabOrder = 1
    OnClick = BtnExitClick
  end
  object ListInfo: TListBox
    Left = 12
    Top = 127
    Width = 312
    Height = 117
    Style = lbOwnerDrawFixed
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 17
    TabOrder = 2
  end
  object Group1: TGroupBox
    Left = 12
    Top = 250
    Width = 312
    Height = 58
    Caption = #30005#24179#21644#25195#25551
    TabOrder = 3
    object BtnSwitchELevel: TButton
      Tag = 10
      Left = 8
      Top = 20
      Width = 65
      Height = 22
      Caption = #20999#25442#30005#24179
      TabOrder = 0
      OnClick = BtnSwitchELevelClick
    end
    object BtnSaveLevel: TButton
      Tag = 20
      Left = 72
      Top = 20
      Width = 65
      Height = 22
      Caption = #20445#23384#30005#24179
      TabOrder = 1
      OnClick = BtnSwitchELevelClick
    end
    object BtnSaveMode: TButton
      Tag = 20
      Left = 240
      Top = 20
      Width = 65
      Height = 22
      Caption = #20445#23384#27169#24335
      TabOrder = 2
      OnClick = BtnSwitchModeClick
    end
    object BtnSwitchMode: TButton
      Tag = 10
      Left = 175
      Top = 20
      Width = 65
      Height = 22
      Caption = #20999#25442#27169#24335
      TabOrder = 3
      OnClick = BtnSwitchModeClick
    end
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 16
    Top = 132
    object MISync: TMenuItem
      Caption = #21516#27493#21442#25968
      OnClick = MISyncClick
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object N1: TMenuItem
      Caption = #21516#27493#36873#39033
      object MICard: TMenuItem
        Caption = #25511#21046#21345#31867#22411
        OnClick = MICardClick
      end
      object MISize: TMenuItem
        Caption = #23631#24149#22823#23567
        OnClick = MICardClick
      end
    end
  end
end
