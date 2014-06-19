inherited fFrameCard: TfFrameCard
  Width = 887
  inherited ToolBar1: TToolBar
    Width = 887
    ButtonWidth = 79
    inherited BtnAdd: TToolButton
      Caption = #21150#29702
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Left = 79
      Caption = #28165#29702
      ImageIndex = 19
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      Left = 158
      OnClick = BtnDelClick
    end
    inherited S1: TToolButton
      Left = 237
    end
    inherited BtnRefresh: TToolButton
      Left = 245
      Caption = '    '#21047#26032'    '
    end
    inherited S2: TToolButton
      Left = 324
    end
    inherited BtnPrint: TToolButton
      Left = 332
    end
    inherited BtnPreview: TToolButton
      Left = 411
    end
    inherited BtnExport: TToolButton
      Left = 490
    end
    inherited S3: TToolButton
      Left = 569
    end
    inherited BtnExit: TToolButton
      Left = 577
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 217
    Width = 887
    Height = 150
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 887
    Height = 150
    object cxTextEdit1: TcxTextEdit [0]
      Left = 69
      Top = 93
      Hint = 'T.L_TruckNo'
      ParentFont = False
      TabOrder = 4
      Width = 100
    end
    object EditTruck: TcxButtonEdit [1]
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
      OnKeyPress = OnCtrlKeyPress
      Width = 100
    end
    object EditStock: TcxButtonEdit [2]
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
      OnKeyPress = OnCtrlKeyPress
      Width = 110
    end
    object cxTextEdit2: TcxTextEdit [3]
      Left = 232
      Top = 93
      Hint = 'T.S_Name'
      ParentFont = False
      TabOrder = 5
      Width = 110
    end
    object cxTextEdit3: TcxTextEdit [4]
      Left = 405
      Top = 93
      Hint = 'T.L_SerialID'
      ParentFont = False
      TabOrder = 6
      Width = 80
    end
    object EditDate: TcxButtonEdit [5]
      Left = 568
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      TabOrder = 3
      Width = 234
    end
    object cxTextEdit4: TcxTextEdit [6]
      Left = 560
      Top = 93
      Hint = 'T.L_Weight'
      ParentFont = False
      TabOrder = 7
      Width = 80
    end
    object EditCus: TcxButtonEdit [7]
      Left = 405
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditTruckPropertiesButtonClick
      TabOrder = 2
      OnKeyPress = OnCtrlKeyPress
      Width = 100
    end
    object cxTextEdit5: TcxTextEdit [8]
      Left = 703
      Top = 93
      Hint = 'T.L_Customer'
      ParentFont = False
      TabOrder = 8
      Width = 100
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item2: TdxLayoutItem
          Caption = #36710#29260#21495':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #27700#27877#21697#31181':'
          Control = EditStock
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #23458#25143#21517#31216':'
          Control = EditCus
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #36710#29260#21495':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #27700#27877#21697#31181':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #25209' '#27425' '#21495':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #25552#36135#37327'('#21544'):'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #23458#25143#21517#31216':'
          Control = cxTextEdit5
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 209
    Width = 887
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 887
    inherited TitleBar: TcxLabel
      Caption = #25552#36135#30913#21345#31649#29702
      Style.IsFontAssigned = True
      Width = 887
      AnchorX = 444
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Top = 250
  end
  inherited DataSource1: TDataSource
    Top = 250
  end
end
