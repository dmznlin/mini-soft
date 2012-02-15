inherited fFrameJSItem: TfFrameJSItem
  Width = 820
  inherited ToolBar1: TToolBar
    Width = 820
    inherited BtnAdd: TToolButton
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      OnClick = BtnDelClick
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 217
    Width = 820
    Height = 150
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 820
    Height = 150
    object cxTextEdit1: TcxTextEdit [0]
      Left = 69
      Top = 93
      Hint = 'T.L_TruckNo'
      ParentFont = False
      TabOrder = 3
      Width = 100
    end
    object cxTextEdit2: TcxTextEdit [1]
      Left = 232
      Top = 93
      Hint = 'T.S_Name'
      ParentFont = False
      TabOrder = 4
      Width = 100
    end
    object cxTextEdit3: TcxTextEdit [2]
      Left = 733
      Top = 93
      Hint = 'T.L_Customer'
      ParentFont = False
      TabOrder = 7
      Width = 121
    end
    object EditTruck: TcxButtonEdit [3]
      Left = 69
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditTruckPropertiesButtonClick
      TabOrder = 0
      Width = 100
    end
    object EditStock: TcxButtonEdit [4]
      Left = 232
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditTruckPropertiesButtonClick
      TabOrder = 1
      Width = 100
    end
    object EditCus: TcxButtonEdit [5]
      Left = 395
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditTruckPropertiesButtonClick
      TabOrder = 2
      Width = 100
    end
    object cxTextEdit4: TcxTextEdit [6]
      Left = 570
      Top = 93
      Hint = 'T.L_Weight'
      ParentFont = False
      TabOrder = 6
      Width = 100
    end
    object cxTextEdit5: TcxTextEdit [7]
      Left = 395
      Top = 93
      Hint = 'T.L_SerialID'
      ParentFont = False
      TabOrder = 5
      Width = 100
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #36710#29260#21495':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #27700#27877#21697#31181':'
          Control = EditStock
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCus
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item2: TdxLayoutItem
          Caption = #36710#29260#21495':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #27700#27877#21697#31181':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #25209' '#27425' '#21495':'
          Control = cxTextEdit5
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #25552#36135#37327'('#21544'):'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #23458#25143#21517#31216':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 209
    Width = 820
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 820
    inherited TitleBar: TcxLabel
      Caption = #26632#21488#25552#36135#36710#36742#25490#38431#31649#29702
      Style.IsFontAssigned = True
      Width = 820
      AnchorX = 410
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Top = 252
  end
  inherited DataSource1: TDataSource
    Top = 252
  end
end
