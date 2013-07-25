inherited fFrameArea: TfFrameArea
  Width = 768
  Height = 537
  inherited ToolBar1: TToolBar
    Width = 768
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
    Top = 364
    Width = 768
    Height = 173
    Align = alBottom
    inherited cxView1: TcxGridDBTableView
      DataController.DataSource = nil
    end
    object cxView2: TcxGridTableView [1]
      NavigatorButtons.ConfirmDelete = False
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
    end
    object cxLevel2: TcxGridLevel
      GridView = cxView2
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 768
    Height = 297
    Align = alClient
    AutoContentSizes = [acsWidth, acsHeight]
    object Chart1: TdxOrgChart [0]
      Left = 23
      Top = 36
      Width = 320
      Height = 196
      BorderStyle = bsNone
      Options = [ocSelect, ocFocus, ocButtons, ocDblClick, ocEdit, ocCanDrag, ocShowDrag]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      OnDblClick = Chart1DblClick
      Items = {
        564552312E30410000010000000000FFFFFF1F0100FFFF000000010000000000
        FFFFFF1F0100FFFF000000020000000000FFFFFF1F0100FFFF00000000000000
        0000FFFFFF1F0100FFFF0000000000}
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #21306#22495#20998#24067
        object dxLayout1Item1: TdxLayoutItem
          AutoAligns = []
          AlignHorz = ahClient
          AlignVert = avClient
          Caption = 'dxOrgChart1'
          ShowCaption = False
          Control = Chart1
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        AutoAligns = [aaHorizontal]
        AlignVert = avBottom
        Visible = False
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 356
    Width = 768
    AlignSplitter = salBottom
    Control = cxGrid1
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 768
    inherited TitleBar: TcxLabel
      Caption = #31449#28857#21306#22495#31649#29702
      Style.IsFontAssigned = True
      Width = 768
      AnchorX = 384
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Top = 406
  end
  inherited DataSource1: TDataSource
    Top = 406
  end
end
