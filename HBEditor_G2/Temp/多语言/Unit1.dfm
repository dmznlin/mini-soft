object Form1: TForm1
  Left = 258
  Top = 243
  Width = 544
  Height = 395
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  PixelsPerInch = 96
  TextHeight = 12
  object Memo1: TMemo
    Left = 12
    Top = 74
    Width = 409
    Height = 97
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 10
    Top = 44
    Width = 409
    Height = 20
    TabOrder = 1
    Text = 'D:\MyWork\'#20018#21475#36890#35759'\Bin\Lang.xml'
  end
  object Button2: TButton
    Left = 428
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 426
    Top = 76
    Width = 75
    Height = 25
    Caption = 'Button3'
    TabOrder = 3
    OnClick = Button3Click
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 536
    Height = 29
    ButtonHeight = 20
    ButtonWidth = 31
    Caption = 'ToolBar1'
    ShowCaptions = True
    TabOrder = 4
    object ToolButton1: TToolButton
      Left = 0
      Top = 2
      Caption = #25991#20214
      ImageIndex = 0
    end
    object ToolButton2: TToolButton
      Left = 31
      Top = 2
      Caption = #32534#36753
      ImageIndex = 1
    end
  end
  object Button1: TButton
    Left = 426
    Top = 112
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 5
    OnClick = Button1Click
  end
  object MainMenu1: TMainMenu
    AutoHotkeys = maManual
    Left = 176
    Top = 96
    object N1: TMenuItem
      Caption = #25991#20214
    end
    object N2: TMenuItem
      Caption = #32534#36753
    end
    object N3: TMenuItem
      Caption = #24110#21161
    end
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 148
    Top = 98
    object N4: TMenuItem
      Caption = #25991#20214
      object N5: TMenuItem
        Caption = #25991#20214
      end
      object N6: TMenuItem
        Caption = #32534#36753
      end
      object N7: TMenuItem
        Caption = #25991#20214
        object N8: TMenuItem
          Caption = #25991#20214
        end
        object N9: TMenuItem
          Caption = #32534#36753
        end
      end
    end
    object N10: TMenuItem
      Caption = #32534#36753
    end
    object N11: TMenuItem
      Caption = #24110#21161
    end
  end
end
