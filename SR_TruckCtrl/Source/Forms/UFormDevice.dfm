inherited fFormDevice: TfFormDevice
  Left = 253
  Top = 248
  Caption = #35774#22791
  ClientHeight = 371
  ClientWidth = 335
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 335
    Height = 371
    inherited BtnOK: TButton
      Left = 189
      Top = 338
      TabOrder = 12
    end
    inherited BtnExit: TButton
      Left = 259
      Top = 338
      TabOrder = 13
    end
    object EditIndex: TcxTextEdit [2]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 1
      Width = 121
    end
    object EditCarName: TcxTextEdit [3]
      Left = 81
      Top = 163
      ParentFont = False
      Properties.CharCase = ecUpperCase
      Properties.MaxLength = 16
      TabOrder = 5
      Width = 121
    end
    object cxLabel1: TcxLabel [4]
      Left = 23
      Top = 111
      AutoSize = False
      Caption = #25152#22312#36710#21410#8595
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 22
      Width = 281
      AnchorY = 122
    end
    object EditCarType: TcxComboBox [5]
      Left = 81
      Top = 188
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 12
      Properties.ItemHeight = 18
      TabOrder = 6
      Width = 121
    end
    object EditCarMode: TcxComboBox [6]
      Left = 81
      Top = 213
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 12
      Properties.ItemHeight = 18
      TabOrder = 7
      Width = 121
    end
    object EditCar: TcxComboBox [7]
      Left = 81
      Top = 138
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ItemHeight = 18
      Properties.OnChange = EditCarPropertiesChange
      TabOrder = 4
      Width = 121
    end
    object EditSerial: TcxTextEdit [8]
      Left = 81
      Top = 86
      ParentFont = False
      Properties.MaxLength = 4
      TabOrder = 2
      Width = 121
    end
    object EditPort: TcxComboBox [9]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 18
      TabOrder = 0
      Width = 121
    end
    object EditTotalPipe: TcxColorComboBox [10]
      Left = 229
      Top = 265
      ParentFont = False
      Properties.ColorComboStyle = cxccsComboList
      Properties.CustomColors = <>
      Properties.DefaultDescription = #40664#35748
      Properties.DropDownRows = 15
      Properties.PrepareList = cxplX11
      Properties.ShowDescriptions = False
      TabOrder = 11
      Width = 85
    end
    object EditBreakPot: TcxColorComboBox [11]
      Left = 81
      Top = 290
      ParentFont = False
      Properties.ColorComboStyle = cxccsComboList
      Properties.CustomColors = <>
      Properties.DefaultDescription = #40664#35748
      Properties.DropDownRows = 15
      Properties.PrepareList = cxplX11
      Properties.ShowDescriptions = False
      TabOrder = 10
      Width = 85
    end
    object EditBreakPipe: TcxColorComboBox [12]
      Left = 81
      Top = 265
      ParentFont = False
      Properties.ColorComboStyle = cxccsComboList
      Properties.CustomColors = <>
      Properties.DefaultDescription = #40664#35748
      Properties.DropDownRows = 15
      Properties.PrepareList = cxplX11
      Properties.ShowDescriptions = False
      TabOrder = 9
      Width = 85
    end
    object cxLabel2: TcxLabel [13]
      Left = 23
      Top = 238
      AutoSize = False
      Caption = #26354#32447#39068#33394#8595
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 22
      Width = 281
      AnchorY = 249
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #21442#25968#20449#24687
        object dxLayout1Item10: TdxLayoutItem
          Caption = #21487#36873#20018#21475':'
          Control = EditPort
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #22320#22336#32034#24341':'
          Control = EditIndex
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #35013#32622#32534#21495':'
          Control = EditSerial
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #21487#36873#36710#21410':'
          Control = EditCar
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #36710#21410#21517#31216':'
          Control = EditCarName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #36710#21410#31867#22411':'
          Control = EditCarType
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #36710#21410#22411#21495':'
          Control = EditCarMode
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item14: TdxLayoutItem
          ShowCaption = False
          Control = cxLabel2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Group3: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayout1Item13: TdxLayoutItem
              Caption = #21046' '#21160' '#31649':'
              Control = EditBreakPipe
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item12: TdxLayoutItem
              AutoAligns = [aaVertical]
              Caption = #21046' '#21160' '#32568':'
              Control = EditBreakPot
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Item11: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #24635' '#39118' '#31649':'
            Control = EditTotalPipe
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
  end
end
