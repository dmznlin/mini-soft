inherited fFormRYuanLiao: TfFormRYuanLiao
  Left = 400
  Top = 326
  ClientHeight = 435
  ClientWidth = 400
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 400
    Height = 435
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 254
      Top = 402
      TabOrder = 11
    end
    inherited BtnExit: TButton
      Left = 324
      Top = 402
      TabOrder = 12
    end
    object InfoList1: TcxMCListBox [2]
      Left = 23
      Top = 268
      Width = 354
      Height = 122
      HeaderSections = <
        item
          Text = #29289#21697#21517#31216
          Width = 100
        end
        item
          Alignment = taCenter
          Text = #37319#36141#21333#20215
          Width = 60
        end
        item
          Alignment = taCenter
          Text = #37319#36141#25968#37327
          Width = 60
        end>
      ParentFont = False
      Style.BorderStyle = cbsOffice11
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 10
    end
    object BtnAdd: TButton [3]
      Left = 282
      Top = 209
      Width = 45
      Height = 22
      Caption = #28155#21152
      TabOrder = 8
      OnClick = BtnAddClick
    end
    object BtnDel: TButton [4]
      Left = 332
      Top = 209
      Width = 45
      Height = 22
      Caption = #21024#38500
      TabOrder = 9
      OnClick = BtnDelClick
    end
    object EditGG: TcxComboBox [5]
      Left = 81
      Top = 86
      Hint = 'T.G_GuiGe'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 16
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 32
      TabOrder = 2
      Width = 298
    end
    object EditUnit: TcxComboBox [6]
      Left = 81
      Top = 61
      Hint = 'T.G_Unit'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 16
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 32
      TabOrder = 1
      Width = 100
    end
    object EditName: TcxLookupComboBox [7]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.ListColumns = <>
      Properties.OnEditValueChanged = EditNamePropertiesEditValueChanged
      TabOrder = 0
      Width = 145
    end
    object EditGY: TcxLookupComboBox [8]
      Left = 81
      Top = 124
      ParentFont = False
      Properties.ListColumns = <>
      TabOrder = 4
      Width = 145
    end
    object EditCW: TcxLookupComboBox [9]
      Left = 81
      Top = 174
      ParentFont = False
      Properties.ListColumns = <>
      Properties.OnEditValueChanged = EditCWPropertiesEditValueChanged
      TabOrder = 7
      Width = 145
    end
    object EditNum: TcxTextEdit [10]
      Left = 81
      Top = 149
      ParentFont = False
      TabOrder = 5
      Width = 100
    end
    object EditPrice: TcxTextEdit [11]
      Left = 244
      Top = 149
      ParentFont = False
      TabOrder = 6
      Width = 121
    end
    object cxLabel1: TcxLabel [12]
      Left = 23
      Top = 111
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 8
      Width = 384
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item10: TdxLayoutItem
          Caption = #29289#21697#21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group7: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item9: TdxLayoutItem
            Caption = #35745#37327#21333#20301':'
            Control = EditUnit
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item11: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #29289#21697#35268#26684':'
            Control = EditGG
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item15: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #20379' '#24212' '#21830':'
          Control = EditGY
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group6: TdxLayoutGroup
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group3: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayout1Group4: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item13: TdxLayoutItem
                Caption = #37319#36141#25968#37327':'
                Control = EditNum
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item14: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahClient
                Caption = #37319#36141#21333#20215':'
                Control = EditPrice
                ControlOptions.ShowBorder = False
              end
            end
            object dxLayout1Item12: TdxLayoutItem
              Caption = #23384#25918#20179#20301':'
              Control = EditCW
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group8: TdxLayoutGroup
            AutoAligns = [aaHorizontal]
            AlignVert = avBottom
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item6: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              ShowCaption = False
              Control = BtnAdd
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item8: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              ShowCaption = False
              Control = BtnDel
              ControlOptions.ShowBorder = False
            end
          end
        end
      end
      object dxLayout1Group2: TdxLayoutGroup [1]
        Caption = #20837#24211#28165#21333
        object dxLayout1Item4: TdxLayoutItem
          Control = InfoList1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
