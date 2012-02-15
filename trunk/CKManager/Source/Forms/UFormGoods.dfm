inherited fFormGoods: TfFormGoods
  Left = 400
  Top = 326
  ClientHeight = 406
  ClientWidth = 397
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 397
    Height = 406
    AutoControlAlignment = False
    AutoControlTabOrders = False
    inherited BtnOK: TButton
      Left = 251
      Top = 373
      TabOrder = 11
    end
    inherited BtnExit: TButton
      Left = 321
      Top = 373
      TabOrder = 12
    end
    object EditName: TcxTextEdit [2]
      Left = 57
      Top = 36
      Hint = 'T.G_Name'
      ParentFont = False
      Properties.MaxLength = 52
      TabOrder = 0
      Width = 403
    end
    object EditType: TcxComboBox [3]
      Left = 57
      Top = 61
      Hint = 'T.G_Type'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 16
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'B=B'#12289#22791#21697#22791#20214
        'C=C'#12289#29983#20135#26448#26009)
      Properties.MaxLength = 32
      TabOrder = 1
      Width = 125
    end
    object InfoItems: TcxComboBox [4]
      Left = 81
      Top = 207
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 30
      TabOrder = 6
      Width = 100
    end
    object InfoList1: TcxMCListBox [5]
      Left = 23
      Top = 261
      Width = 338
      Height = 100
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 105
        end
        item
          AutoSize = True
          Text = #20869#23481
          Width = 229
        end>
      ParentFont = False
      Style.BorderStyle = cbsOffice11
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 10
    end
    object EditInfo: TcxTextEdit [6]
      Left = 81
      Top = 234
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 7
      Width = 120
    end
    object BtnAdd: TButton [7]
      Left = 329
      Top = 207
      Width = 45
      Height = 22
      Caption = #28155#21152
      TabOrder = 8
      OnClick = BtnAddClick
    end
    object BtnDel: TButton [8]
      Left = 329
      Top = 234
      Width = 45
      Height = 22
      Caption = #21024#38500
      TabOrder = 9
      OnClick = BtnDelClick
    end
    object EditGG: TcxComboBox [9]
      Left = 57
      Top = 111
      Hint = 'T.G_GuiGe'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 16
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 32
      TabOrder = 4
      Width = 298
    end
    object EditCZ: TcxComboBox [10]
      Left = 57
      Top = 136
      Hint = 'T.G_CaiZhi'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 16
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 32
      TabOrder = 5
      Width = 298
    end
    object EditGType: TcxComboBox [11]
      Left = 245
      Top = 61
      Hint = 'T.G_GType'
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
    object EditUnit: TcxComboBox [12]
      Left = 57
      Top = 86
      Hint = 'T.G_Unit'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 16
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 32
      TabOrder = 3
      Width = 125
    end
    object EditOStyle: TcxComboBox [13]
      Left = 245
      Top = 86
      Hint = 'T.G_OutStyle'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 16
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'I=I'#12289#20808#36827#20808#20986
        'O=O'#12289#20808#36827#21518#20986)
      Properties.MaxLength = 32
      TabOrder = 16
      Width = 125
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item7: TdxLayoutItem
          Caption = #21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group6: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item13: TdxLayoutItem
            AutoAligns = [aaVertical]
            Caption = #31867#22411':'
            Control = EditType
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item14: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #25152#23646#20998#31867':'
            Control = EditGType
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group7: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group8: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item9: TdxLayoutItem
              Caption = #21333#20301':'
              Control = EditUnit
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item15: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #20986#20179#35268#21017':'
              Control = EditOStyle
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Item11: TdxLayoutItem
            Caption = #35268#26684':'
            Control = EditGG
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item12: TdxLayoutItem
            Caption = #26448#36136':'
            Control = EditCZ
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxLayout1Group2: TdxLayoutGroup [1]
        Caption = #38468#21152#20449#24687
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group5: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item3: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #20449' '#24687' '#39033':'
              Control = InfoItems
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item6: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              ShowCaption = False
              Control = BtnAdd
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group4: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item5: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #20449#24687#20869#23481':'
              Control = EditInfo
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
        object dxLayout1Item4: TdxLayoutItem
          Control = InfoList1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
