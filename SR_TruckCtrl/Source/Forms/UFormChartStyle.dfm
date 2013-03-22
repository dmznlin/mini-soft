inherited fFormChartStyle: TfFormChartStyle
  Left = 280
  Top = 148
  Caption = #30028#38754#39118#26684
  ClientHeight = 452
  ClientWidth = 388
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 388
    Height = 452
    inherited BtnOK: TButton
      Left = 242
      Top = 419
      Caption = #30830#23450
      TabOrder = 12
    end
    inherited BtnExit: TButton
      Left = 312
      Top = 419
      TabOrder = 13
    end
    object cxLabel1: TcxLabel [2]
      Left = 23
      Top = 326
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 12
      Width = 241
    end
    object DeviceList: TdxOrgChart [3]
      Left = 23
      Top = 54
      Width = 301
      Height = 192
      BorderStyle = bsNone
      Options = [ocSelect, ocButtons, ocDblClick, ocEdit, ocCanDrag, ocShowDrag]
      OnChange = DeviceListChange
      OnCollapsing = DeviceListCollapsing
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Items = {
        564552312E30410000010000000000FFFFFF1F0100FFFF000000020000000000
        FFFFFF1F0100FFFF000000020000000000FFFFFF1F0100FFFF00000000000000
        0000FFFFFF1F0100FFFF000000000000000000FFFFFF1F0100FFFF0000000100
        00000000FFFFFF1F0100FFFF0000000000}
    end
    object EditWidth: TcxSpinEdit [4]
      Left = 57
      Top = 251
      ParentFont = False
      Properties.MaxValue = 200.000000000000000000
      Properties.MinValue = 10.000000000000000000
      Properties.OnChange = EditWidthPropertiesChange
      TabOrder = 1
      Value = 10
      Width = 125
    end
    object EditHeight: TcxSpinEdit [5]
      Left = 221
      Top = 251
      ParentFont = False
      Properties.MaxValue = 200.000000000000000000
      Properties.MinValue = 10.000000000000000000
      Properties.OnChange = EditWidthPropertiesChange
      TabOrder = 2
      Value = 10
      Width = 121
    end
    object EditColor: TcxColorComboBox [6]
      Left = 57
      Top = 276
      ParentFont = False
      Properties.ColorComboStyle = cxccsComboList
      Properties.CustomColors = <>
      Properties.DefaultDescription = #40664#35748
      Properties.DropDownRows = 15
      Properties.PrepareList = cxplX11
      Properties.ShowDescriptions = False
      Properties.OnChange = EditWidthPropertiesChange
      TabOrder = 3
      Width = 125
    end
    object EditShape: TcxComboBox [7]
      Left = 221
      Top = 276
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 20
      Properties.Items.Strings = (
        #38271#26041#24418
        #22278#35282#30697#24418
        #26925#22278#24418
        #33777#24418)
      Properties.OnChange = EditWidthPropertiesChange
      TabOrder = 4
      Width = 121
    end
    object EditImage: TcxImageComboBox [8]
      Left = 57
      Top = 301
      ParentFont = False
      Properties.Items = <>
      Properties.OnChange = EditWidthPropertiesChange
      TabOrder = 5
      Width = 125
    end
    object EditAlign: TcxComboBox [9]
      Left = 221
      Top = 301
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ItemHeight = 20
      Properties.OnChange = EditWidthPropertiesChange
      TabOrder = 6
      Width = 121
    end
    object EditIndentY: TcxSpinEdit [10]
      Left = 221
      Top = 343
      ParentFont = False
      Properties.MaxValue = 100.000000000000000000
      Properties.MinValue = 1.000000000000000000
      Properties.OnChange = EditIndentYPropertiesChange
      TabOrder = 9
      Value = 1
      Width = 115
    end
    object EditIndentX: TcxSpinEdit [11]
      Left = 57
      Top = 343
      ParentFont = False
      Properties.MaxValue = 100.000000000000000000
      Properties.MinValue = 1.000000000000000000
      Properties.OnChange = EditIndentYPropertiesChange
      TabOrder = 8
      Value = 1
      Width = 125
    end
    object EditLineColor: TcxColorComboBox [12]
      Left = 57
      Top = 368
      ParentFont = False
      Properties.CustomColors = <>
      Properties.DefaultDescription = #40664#35748
      Properties.DropDownRows = 15
      Properties.PrepareList = cxplX11
      Properties.ShowDescriptions = False
      Properties.OnChange = EditIndentYPropertiesChange
      TabOrder = 10
      Width = 125
    end
    object EditLineWidth: TcxSpinEdit [13]
      Left = 221
      Top = 368
      ParentFont = False
      Properties.MaxValue = 10.000000000000000000
      Properties.MinValue = 1.000000000000000000
      Properties.OnChange = EditIndentYPropertiesChange
      TabOrder = 11
      Value = 1
      Width = 115
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #35774#22791#26641
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          Caption = #22270#20363':'
          CaptionOptions.Layout = clTop
          Control = DeviceList
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item6: TdxLayoutItem
            Caption = #23485#24230':'
            Control = EditWidth
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item3: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #39640#24230':'
            Control = EditHeight
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item7: TdxLayoutItem
            Caption = #39068#33394':'
            Control = EditColor
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #24418#29366':'
            Control = EditShape
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group5: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item9: TdxLayoutItem
              Caption = #22270#26631':'
              Control = EditImage
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item10: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #20301#32622':'
              Control = EditAlign
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Item5: TdxLayoutItem
            ShowCaption = False
            Control = cxLabel1
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Group6: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayout1Group7: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item12: TdxLayoutItem
                Caption = #27700#24179':'
                Control = EditIndentX
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item11: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahClient
                Caption = #22402#30452':'
                Control = EditIndentY
                ControlOptions.ShowBorder = False
              end
            end
            object dxLayout1Group8: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item13: TdxLayoutItem
                Caption = #36830#32447':'
                Control = EditLineColor
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item14: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahClient
                Caption = #32447#23485':'
                Control = EditLineWidth
                ControlOptions.ShowBorder = False
              end
            end
          end
        end
      end
    end
  end
end
