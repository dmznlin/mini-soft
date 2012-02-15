inherited fFormJSItem: TfFormJSItem
  Left = 460
  Top = 278
  ClientHeight = 251
  ClientWidth = 387
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 387
    Height = 251
    inherited BtnOK: TButton
      Left = 241
      Top = 218
      TabOrder = 9
    end
    inherited BtnExit: TButton
      Left = 311
      Top = 218
      TabOrder = 10
    end
    object EditTruck: TcxComboBox [2]
      Left = 81
      Top = 36
      Hint = 'T.L_TruckNo'
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 15
      TabOrder = 0
      OnKeyDown = OnCtrlKeyDown
      Width = 125
    end
    object EditStock: TcxComboBox [3]
      Left = 81
      Top = 86
      Hint = 'T.L_Stock'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.OnChange = EditStockPropertiesChange
      TabOrder = 2
      OnKeyDown = OnCtrlKeyDown
      Width = 125
    end
    object EditSID: TcxTextEdit [4]
      Left = 81
      Top = 136
      Hint = 'T.L_SerialID'
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 6
      OnKeyDown = OnCtrlKeyDown
      Width = 122
    end
    object EditWeight: TcxTextEdit [5]
      Left = 81
      Top = 111
      Hint = 'T.L_Weight'
      HelpType = htKeyword
      HelpKeyword = 'I'
      ParentFont = False
      Properties.OnChange = EditWeightPropertiesChange
      TabOrder = 3
      Text = '0'
      OnKeyDown = OnCtrlKeyDown
      Width = 92
    end
    object EditNum: TcxTextEdit [6]
      Left = 266
      Top = 111
      Hint = 'E.L_DaiShu'
      HelpType = htKeyword
      HelpKeyword = 'I'
      ParentFont = False
      Properties.OnChange = EditNumPropertiesChange
      TabOrder = 5
      Text = '0'
      OnKeyDown = OnCtrlKeyDown
      Width = 98
    end
    object EditMemo: TcxMemo [7]
      Left = 81
      Top = 161
      Hint = 'T.L_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      TabOrder = 8
      OnKeyDown = OnCtrlKeyDown
      Height = 45
      Width = 160
    end
    object cxLabel1: TcxLabel [8]
      Left = 178
      Top = 111
      AutoSize = False
      Caption = #21544
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Height = 20
      Width = 25
      AnchorY = 121
    end
    object EditCus: TcxComboBox [9]
      Left = 81
      Top = 61
      Hint = 'T.L_Customer'
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 100
      TabOrder = 1
      OnKeyDown = EditCusKeyDown
      Width = 130
    end
    object EditBC: TcxTextEdit [10]
      Left = 266
      Top = 136
      Hint = 'T.L_BC'
      HelpType = htKeyword
      HelpKeyword = 'I'
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 7
      Text = '0'
      Width = 85
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #25552#36135#20449#24687
        object dxLayout1Item4: TdxLayoutItem
          Caption = #25552#36135#36710#36742':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item15: TdxLayoutItem
          Caption = #23458#25143#22995#21517':'
          Control = EditCus
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #27700#27877#21697#31181':'
          Control = EditStock
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item7: TdxLayoutItem
            Caption = #25552' '#36135' '#37327':'
            Control = EditWeight
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item14: TdxLayoutItem
            Caption = 'cxLabel1'
            ShowCaption = False
            Control = cxLabel1
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #24212#25552#34955#25968':'
            Control = EditNum
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item6: TdxLayoutItem
            Caption = #25209' '#27425' '#21495':'
            Control = EditSID
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item3: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #34917#24046#34955#25968':'
            Control = EditBC
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item13: TdxLayoutItem
          Caption = #22791#27880#20449#24687':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
