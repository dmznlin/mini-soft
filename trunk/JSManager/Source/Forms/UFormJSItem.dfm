inherited fFormJSItem: TfFormJSItem
  Left = 460
  Top = 278
  ClientHeight = 337
  ClientWidth = 522
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 15
  inherited dxLayout1: TdxLayoutControl
    Width = 522
    Height = 337
    inherited BtnOK: TButton
      Left = 340
      Top = 295
      TabOrder = 10
    end
    inherited BtnExit: TButton
      Left = 427
      Top = 295
      TabOrder = 11
    end
    object EditTruck: TcxComboBox [2]
      Left = 87
      Top = 73
      Hint = 'T.L_TruckNo'
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 15
      TabOrder = 1
      OnKeyDown = OnCtrlKeyDown
      Width = 157
    end
    object EditStock: TcxComboBox [3]
      Left = 87
      Top = 129
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.OnChange = EditStockPropertiesChange
      TabOrder = 3
      OnKeyDown = OnCtrlKeyDown
      Width = 157
    end
    object EditSID: TcxTextEdit [4]
      Left = 87
      Top = 187
      Hint = 'T.L_SerialID'
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 7
      OnKeyDown = OnCtrlKeyDown
      Width = 153
    end
    object EditWeight: TcxTextEdit [5]
      Left = 87
      Top = 157
      Hint = 'T.L_Weight'
      HelpType = htKeyword
      HelpKeyword = 'I'
      ParentFont = False
      Properties.OnChange = EditWeightPropertiesChange
      TabOrder = 4
      Text = '0'
      OnKeyDown = OnCtrlKeyDown
      Width = 115
    end
    object EditNum: TcxTextEdit [6]
      Left = 301
      Top = 157
      Hint = 'T.L_DaiShu'
      HelpType = htKeyword
      HelpKeyword = 'I'
      ParentFont = False
      Properties.OnChange = EditNumPropertiesChange
      TabOrder = 6
      Text = '0'
      OnKeyDown = OnCtrlKeyDown
      Width = 122
    end
    object EditMemo: TcxMemo [7]
      Left = 87
      Top = 215
      Hint = 'T.L_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      TabOrder = 9
      OnKeyDown = OnCtrlKeyDown
      Height = 57
      Width = 200
    end
    object cxLabel1: TcxLabel [8]
      Left = 207
      Top = 157
      AutoSize = False
      Caption = #21544
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Height = 25
      Width = 31
      AnchorY = 170
    end
    object EditCus: TcxComboBox [9]
      Left = 87
      Top = 101
      Hint = 'T.L_Customer'
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 100
      TabOrder = 2
      OnKeyDown = EditCusKeyDown
      Width = 163
    end
    object EditBC: TcxTextEdit [10]
      Left = 303
      Top = 187
      Hint = 'T.L_BC'
      HelpType = htKeyword
      HelpKeyword = 'I'
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 8
      Text = '0'
      Width = 106
    end
    object EditCard: TcxButtonEdit [11]
      Left = 87
      Top = 45
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditCardPropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #25552#36135#20449#24687
        object dxLayout1Item10: TdxLayoutItem
          Caption = #30913#21345#32534#21495':'
          Control = EditCard
          ControlOptions.ShowBorder = False
        end
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
