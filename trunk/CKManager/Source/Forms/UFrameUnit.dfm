inherited fFrameUnit: TfFrameUnit
  Width = 830
  Height = 422
  inherited ToolBar1: TToolBar
    Width = 830
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
    Top = 205
    Width = 830
    Height = 217
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 830
    Height = 138
    object EditName: TcxButtonEdit [0]
      Left = 57
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 120
    end
    object cxTextEdit1: TcxTextEdit [1]
      Left = 57
      Top = 93
      Hint = 'T.U_Name'
      ParentFont = False
      TabOrder = 1
      Width = 120
    end
    object cxTextEdit2: TcxTextEdit [2]
      Left = 216
      Top = 93
      Hint = 'T.U_Type'
      ParentFont = False
      TabOrder = 2
      Width = 128
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #21517#31216':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #31867#22411':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 197
    Width = 830
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 830
    inherited TitleBar: TcxLabel
      Caption = #29289#21697#35268#26684#26448#36136
      Style.IsFontAssigned = True
      Width = 830
      AnchorX = 415
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 4
    Top = 236
  end
  inherited DataSource1: TDataSource
    Left = 32
    Top = 236
  end
end
