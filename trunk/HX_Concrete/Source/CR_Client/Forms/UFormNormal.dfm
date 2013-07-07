inherited fFormNormal: TfFormNormal
  Left = 489
  Top = 305
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 161
  ClientWidth = 279
  OldCreateOrder = True
  PixelsPerInch = 120
  TextHeight = 15
  object dxLayout1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 279
    Height = 161
    Align = alClient
    TabOrder = 0
    TabStop = False
    AutoContentSizes = [acsWidth, acsHeight]
    LookAndFeel = FDM.dxLayoutWeb1
    object BtnOK: TButton
      Left = 97
      Top = 119
      Width = 82
      Height = 28
      Caption = #20445#23384
      TabOrder = 0
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 184
      Top = 119
      Width = 81
      Height = 28
      Caption = #21462#28040
      TabOrder = 1
      OnClick = BtnExitClick
    end
    object dxLayout1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxGroup1: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #22522#26412#20449#24687
      end
      object dxLayout1Group1: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avBottom
        ShowCaption = False
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        object dxLayout1Item1: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahRight
          Caption = 'Button1'
          ShowCaption = False
          Control = BtnOK
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahRight
          Caption = 'Button2'
          ShowCaption = False
          Control = BtnExit
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
