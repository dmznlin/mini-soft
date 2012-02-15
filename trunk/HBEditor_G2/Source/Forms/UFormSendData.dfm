object fFormSendData: TfFormSendData
  Left = 627
  Top = 303
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 343
  ClientWidth = 339
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
    339
    343)
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 12
    Top = 12
    Width = 317
    Height = 293
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = #21457#36865#35774#32622
    TabOrder = 0
    object Label2: TLabel
      Left = 20
      Top = 29
      Width = 30
      Height = 12
      Alignment = taRightJustify
      Caption = #35774#22791':'
    end
    object Label1: TLabel
      Left = 12
      Top = 60
      Width = 54
      Height = 12
      Caption = #32452#20214#21015#34920':'
    end
    object EditDevice: TComboBox
      Left = 55
      Top = 27
      Width = 250
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 0
    end
    object ListItems: TListView
      Left = 12
      Top = 78
      Width = 293
      Height = 201
      Columns = <
        item
          Caption = #24207#21495
        end
        item
          AutoSize = True
          Caption = #31867#22411
        end>
      ReadOnly = True
      RowSelect = True
      TabOrder = 1
      ViewStyle = vsReport
    end
  end
  object BtnSend: TButton
    Left = 196
    Top = 310
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #21457#36865
    TabOrder = 1
    OnClick = BtnSendClick
  end
  object BtnExit: TButton
    Left = 264
    Top = 310
    Width = 65
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #21462#28040
    TabOrder = 2
    OnClick = BtnExitClick
  end
  object Check1: TCheckBox
    Left = 12
    Top = 312
    Width = 97
    Height = 17
    Caption = #21453#30456#22270#25991
    TabOrder = 3
  end
end
