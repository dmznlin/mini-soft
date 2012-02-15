inherited fFormRBeiPin: TfFormRBeiPin
  Left = 400
  Top = 326
  ClientHeight = 466
  ClientWidth = 418
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 418
    Height = 466
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 272
      Top = 433
      TabOrder = 15
    end
    inherited BtnExit: TButton
      Left = 342
      Top = 433
      TabOrder = 16
    end
    object InfoList1: TcxMCListBox [2]
      Left = 23
      Top = 311
      Width = 347
      Height = 110
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
      TabOrder = 14
    end
    object BtnAdd: TButton [3]
      Left = 300
      Top = 252
      Width = 45
      Height = 22
      Caption = #28155#21152
      TabOrder = 12
      OnClick = BtnAddClick
    end
    object BtnDel: TButton [4]
      Left = 350
      Top = 252
      Width = 45
      Height = 22
      Caption = #21024#38500
      TabOrder = 13
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
      TabOrder = 3
      Width = 298
    end
    object EditUnit: TcxComboBox [6]
      Left = 81
      Top = 136
      Hint = 'T.G_Unit'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 16
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 32
      TabOrder = 5
      Width = 122
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
      Top = 174
      ParentFont = False
      Properties.ListColumns = <>
      TabOrder = 8
      Width = 145
    end
    object EditCW: TcxLookupComboBox [9]
      Left = 81
      Top = 224
      ParentFont = False
      Properties.ListColumns = <>
      Properties.OnEditValueChanged = EditCWPropertiesEditValueChanged
      TabOrder = 11
      Width = 145
    end
    object EditNum: TcxTextEdit [10]
      Left = 266
      Top = 199
      ParentFont = False
      TabOrder = 10
      Width = 100
    end
    object EditPrice: TcxTextEdit [11]
      Left = 81
      Top = 199
      ParentFont = False
      TabOrder = 9
      Width = 122
    end
    object cxLabel1: TcxLabel [12]
      Left = 23
      Top = 161
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 8
      Width = 384
    end
    object EditBH: TcxTextEdit [13]
      Left = 81
      Top = 61
      ParentFont = False
      TabOrder = 1
      Width = 122
    end
    object EditTH: TcxTextEdit [14]
      Left = 266
      Top = 61
      ParentFont = False
      TabOrder = 2
      Width = 121
    end
    object cxTextEdit3: TcxTextEdit [15]
      Left = 10000
      Top = 10000
      ParentFont = False
      TabOrder = 19
      Text = 'cxTextEdit3'
      Visible = False
      Width = 121
    end
    object EditCZ: TcxComboBox [16]
      Left = 81
      Top = 111
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 16
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      TabOrder = 4
      Width = 121
    end
    object EditDZ: TcxTextEdit [17]
      Left = 266
      Top = 136
      ParentFont = False
      TabOrder = 6
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item10: TdxLayoutItem
          Caption = #29289#21697#21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group5: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item3: TdxLayoutItem
            Caption = #22791#20214#32534#21495':'
            Control = EditBH
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #38646#20214#22270#21495':'
            Control = EditTH
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group7: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item11: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #29289#21697#35268#26684':'
            Control = EditGG
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item17: TdxLayoutItem
            Caption = #29289#21697#26448#36136':'
            Control = EditCZ
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Group9: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item9: TdxLayoutItem
              Caption = #35745#37327#21333#20301':'
              Control = EditUnit
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item18: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #21333#37325'(KG):'
              Control = EditDZ
              ControlOptions.ShowBorder = False
            end
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
              object dxLayout1Item14: TdxLayoutItem
                AutoAligns = [aaVertical]
                Caption = #37319#36141#21333#20215':'
                Control = EditPrice
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item13: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahClient
                Caption = #37319#36141#25968#37327':'
                Control = EditNum
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
    object dxLayout1Item16: TdxLayoutItem
      Caption = 'cxTextEdit3'
      Control = cxTextEdit3
      ControlOptions.ShowBorder = False
    end
  end
end
