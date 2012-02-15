object Form1: TForm1
  Left = 429
  Top = 254
  Width = 489
  Height = 317
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 12
  object Memo1: TMemo
    Left = 0
    Top = 29
    Width = 481
    Height = 254
    Align = alClient
    Lines.Strings = (
      'Memo1')
    TabOrder = 0
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 481
    Height = 29
    ButtonHeight = 20
    ButtonWidth = 67
    Caption = 'ToolBar1'
    ShowCaptions = True
    TabOrder = 1
    object ToolButton1: TToolButton
      Left = 0
      Top = 2
      Caption = #20840#37096
      ImageIndex = 0
      OnClick = ToolButton1Click
    end
    object ToolButton2: TToolButton
      Left = 67
      Top = 2
      Caption = '   '#26377#25928'   '
      ImageIndex = 1
      OnClick = ToolButton2Click
    end
  end
end
