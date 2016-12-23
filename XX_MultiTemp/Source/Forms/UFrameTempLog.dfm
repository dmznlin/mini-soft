inherited fFrameTemplog: TfFrameTemplog
  Width = 773
  Height = 436
  inherited ToolBar1: TToolBar
    Width = 773
    inherited BtnAdd: TToolButton
      Visible = False
    end
    inherited BtnEdit: TToolButton
      Visible = False
    end
    inherited BtnDel: TToolButton
      Visible = False
    end
    inherited S1: TToolButton
      Visible = False
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 202
    Width = 773
    Height = 234
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 773
    Height = 135
    object EditSMemo: TcxTextEdit [0]
      Left = 81
      Top = 93
      Hint = 'T.T_Date'
      ParentFont = False
      TabOrder = 1
      Width = 185
    end
    object EditDate: TcxButtonEdit [1]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      TabOrder = 0
      Width = 185
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item6: TdxLayoutItem
          Caption = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaVertical]
          Caption = #37319#38598#26085#26399':'
          Control = EditSMemo
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 194
    Width = 773
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 773
    inherited TitleBar: TcxLabel
      Caption = #28201#28287#24230#37319#38598#35760#24405
      Style.IsFontAssigned = True
      Width = 773
      AnchorX = 387
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
