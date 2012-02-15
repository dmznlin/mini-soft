inherited fFrameBuyPlan: TfFrameBuyPlan
  Width = 830
  Height = 422
  inherited ToolBar1: TToolBar
    Width = 830
    inherited BtnAdd: TToolButton
      Caption = #37319#36141#35745#21010
      ImageIndex = 17
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Caption = #37319#36141#30003#35831
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      OnClick = BtnDelClick
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 182
    Width = 830
    Height = 240
    RootLevelOptions.DetailTabsPosition = dtpTop
    OnActiveTabChanged = cxGrid1ActiveTabChanged
    object cxView2: TcxGridDBTableView [1]
      OnDblClick = cxView2DblClick
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = DataSource2
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
    end
    inherited cxLevel1: TcxGridLevel
      Caption = #37319#36141#35745#21010
    end
    object cxLevel2: TcxGridLevel
      Caption = #37319#36141#30003#35831
      GridView = cxView2
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 830
    Height = 115
    object EditName: TcxButtonEdit [0]
      Left = 81
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
    object EditWeek: TcxButtonEdit [1]
      Left = 264
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
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #29289#21697#21517#31216':'
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
        Visible = False
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 174
    Width = 830
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 830
    inherited TitleBar: TcxLabel
      Caption = #29289#21697#37319#36141#35745#21010
      Style.IsFontAssigned = True
      Width = 830
      AnchorX = 415
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 10
    Top = 266
  end
  inherited DataSource1: TDataSource
    Left = 38
    Top = 266
  end
  object SQLQuery2: TADOQuery
    Connection = FDM.ADOConn
    Parameters = <>
    Left = 10
    Top = 294
  end
  object DataSource2: TDataSource
    DataSet = SQLQuery2
    Left = 38
    Top = 294
  end
end
