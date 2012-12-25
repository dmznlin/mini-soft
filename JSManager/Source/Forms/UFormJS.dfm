inherited fFormJS: TfFormJS
  Left = 328
  Top = 187
  ClientHeight = 353
  ClientWidth = 383
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 383
    Height = 353
    inherited BtnOK: TButton
      Left = 237
      Top = 320
      TabOrder = 12
    end
    inherited BtnExit: TButton
      Left = 307
      Top = 320
      Caption = #20851#38381
      TabOrder = 13
    end
    object EditZT: TcxComboBox [2]
      Left = 81
      Top = 36
      Hint = 'T.L_ZTLine'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      TabOrder = 0
      OnKeyDown = OnCtrlKeyDown
      Width = 105
    end
    object EditTruck: TcxComboBox [3]
      Left = 249
      Top = 36
      Hint = 'T.L_TruckNo'
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.MaxLength = 15
      TabOrder = 1
      OnKeyDown = OnCtrlKeyDown
      Width = 120
    end
    object EditStock: TcxComboBox [4]
      Left = 81
      Top = 86
      Hint = 'T.L_Stock'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.OnChange = EditStockPropertiesChange
      TabOrder = 3
      OnKeyDown = OnCtrlKeyDown
      Width = 100
    end
    object EditSID: TcxTextEdit [5]
      Left = 81
      Top = 111
      Hint = 'T.L_SerialID'
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 4
      OnKeyDown = OnCtrlKeyDown
      Width = 100
    end
    object EditWeight: TcxTextEdit [6]
      Left = 81
      Top = 136
      Hint = 'T.L_Weight'
      HelpType = htKeyword
      HelpKeyword = 'I'
      ParentFont = False
      Properties.OnEditValueChanged = EditWeightPropertiesEditValueChanged
      TabOrder = 5
      Text = '0'
      OnKeyDown = OnCtrlKeyDown
      Width = 95
    end
    object EditNum: TcxTextEdit [7]
      Left = 269
      Top = 136
      Hint = 'T.L_DaiShu'
      HelpType = htKeyword
      HelpKeyword = 'I'
      ParentFont = False
      Properties.OnEditValueChanged = EditNumPropertiesEditValueChanged
      TabOrder = 7
      Text = '0'
      OnKeyDown = OnCtrlKeyDown
      Width = 102
    end
    object EditNumNow: TcxTextEdit [8]
      Left = 81
      Top = 261
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 9
      OnKeyDown = OnCtrlKeyDown
      Width = 100
    end
    object EditHas: TcxTextEdit [9]
      Left = 81
      Top = 288
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 11
      OnKeyDown = OnCtrlKeyDown
      Width = 100
    end
    object BtnStart: TButton [10]
      Left = 290
      Top = 261
      Width = 70
      Height = 22
      Caption = #24320#22987#35745#25968
      TabOrder = 10
      OnClick = BtnStartClick
    end
    object EditMemo: TcxMemo [11]
      Left = 81
      Top = 161
      Hint = 'T.L_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      TabOrder = 8
      OnKeyDown = OnCtrlKeyDown
      Height = 60
      Width = 283
    end
    object cxLabel1: TcxLabel [12]
      Left = 181
      Top = 136
      AutoSize = False
      Caption = #21544
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Height = 20
      Width = 25
      AnchorY = 146
    end
    object EditCus: TcxComboBox [13]
      Left = 81
      Top = 61
      Hint = 'T.L_Customer'
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.MaxLength = 100
      TabOrder = 2
      OnKeyDown = EditCusKeyDown
      Width = 100
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #25552#36135#20449#24687
        object dxLayout1Group7: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item3: TdxLayoutItem
            Caption = #26632#21488#20301#32622':'
            Control = EditZT
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item4: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #25552#36135#36710#36742':'
            Control = EditTruck
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item15: TdxLayoutItem
          Caption = #23458#25143#22995#21517':'
          Control = EditCus
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item5: TdxLayoutItem
            Caption = #27700#27877#21697#31181':'
            Control = EditStock
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item6: TdxLayoutItem
            Caption = #25209' '#27425' '#21495':'
            Control = EditSID
            ControlOptions.ShowBorder = False
          end
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
        object dxLayout1Item13: TdxLayoutItem
          Caption = #22791#27880#20449#24687':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avBottom
        Caption = #35745#25968#25805#20316
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item10: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #26412#27425#34955#25968':'
            Control = EditNumNow
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item12: TdxLayoutItem
            AutoAligns = [aaVertical]
            Caption = 'Button1'
            ShowCaption = False
            Control = BtnStart
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item11: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #24050#35013#34955#25968':'
          Control = EditHas
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
