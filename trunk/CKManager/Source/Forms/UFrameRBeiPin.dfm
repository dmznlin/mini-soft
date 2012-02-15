inherited fFrameRBeiPin: TfFrameRBeiPin
  Width = 830
  Height = 422
  inherited ToolBar1: TToolBar
    Width = 830
    inherited BtnAdd: TToolButton
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Visible = False
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
      Hint = 'T.G_Name'
      ParentFont = False
      TabOrder = 2
      Width = 120
    end
    object cxTextEdit2: TcxTextEdit [2]
      Left = 216
      Top = 93
      Hint = 'T.S_Name'
      ParentFont = False
      TabOrder = 3
      Width = 112
    end
    object cxTextEdit3: TcxTextEdit [3]
      Left = 379
      Top = 93
      Hint = 'T.S_Owner'
      ParentFont = False
      TabOrder = 4
      Width = 112
    end
    object EditWeek: TcxButtonEdit [4]
      Left = 240
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.OnButtonClick = EditWeekPropertiesButtonClick
      TabOrder = 1
      Width = 250
    end
    object cxTextEdit4: TcxTextEdit [5]
      Left = 554
      Top = 93
      Hint = 'T.Y_Memo'
      ParentFont = False
      TabOrder = 5
      Width = 121
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #21608#26399#31579#36873':'
          Control = EditWeek
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
          Caption = #20179#20301':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          Caption = #20445#31649#21592':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #22791#27880#20449#24687':'
          Control = cxTextEdit4
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
      Caption = #22791#21697#22791#20214#20837#24211
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
