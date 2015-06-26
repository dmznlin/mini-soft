inherited fFrameMember: TfFrameMember
  Width = 646
  Height = 412
  inherited ToolBar1: TToolBar
    Width = 646
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
    Top = 187
    Width = 646
    Height = 225
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 646
    Height = 120
    object EditName: TcxButtonEdit [0]
      Left = 100
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = cxButtonEdit1PropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object EditPhone: TcxButtonEdit [1]
      Left = 272
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = cxButtonEdit1PropertiesButtonClick
      TabOrder = 1
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #20250#21592#21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          Caption = #25163#26426':'
          Control = EditPhone
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 179
    Width = 646
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 646
    inherited TitleBar: TcxLabel
      Caption = #20250#21592#26723#26696
      Style.IsFontAssigned = True
      Width = 646
      AnchorX = 323
      AnchorY = 11
    end
  end
end
