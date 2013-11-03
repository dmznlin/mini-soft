object fFormMain: TfFormMain
  Left = 467
  Top = 397
  Width = 148
  Height = 79
  Color = clTeal
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 140
    Height = 47
    Align = alClient
    BevelOuter = bvLowered
    ParentColor = True
    TabOrder = 0
    object Image1: TImage
      Left = 1
      Top = 1
      Width = 138
      Height = 45
      Align = alClient
      PopupMenu = PMenu1
      Proportional = True
      Transparent = True
      OnMouseDown = Image1MouseDown
      OnMouseMove = Image1MouseMove
      OnMouseUp = Image1MouseUp
    end
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 76
    Top = 11
    object N1: TMenuItem
      Caption = #24320#26426#21551#21160
      Enabled = False
    end
    object N3: TMenuItem
      Caption = #21442#25968#35774#32622
      OnClick = N3Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N6: TMenuItem
      Caption = #22791#20221#25968#25454
      OnClick = N6Click
    end
    object N7: TMenuItem
      Caption = #20840#37096#22791#20221
      Enabled = False
      OnClick = N7Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Caption = #36864#20986#31995#32479
      OnClick = N4Click
    end
  end
end
