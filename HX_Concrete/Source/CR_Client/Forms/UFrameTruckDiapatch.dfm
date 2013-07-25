inherited fFrameTruckDispatch: TfFrameTruckDispatch
  Width = 743
  Height = 402
  inherited ToolBar1: TToolBar
    Width = 743
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
    Width = 743
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PopupMenu1
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 743
    Height = 135
    object cxTextEdit1: TcxTextEdit [0]
      Left = 81
      Top = 91
      Hint = 'T.T_Truck'
      ParentFont = False
      TabOrder = 1
      Width = 90
    end
    object EditTruck: TcxButtonEdit [1]
      Left = 81
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
      Width = 90
    end
    object cxTextEdit2: TcxTextEdit [2]
      Left = 234
      Top = 91
      Hint = 'T.T_Line'
      ParentFont = False
      TabOrder = 2
      Width = 100
    end
    object cxTextEdit3: TcxTextEdit [3]
      Left = 397
      Top = 91
      Hint = 'T.T_InTime'
      ParentFont = False
      TabOrder = 3
      Width = 125
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item2: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #25152#22312#38431#21015':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #36827#31449#26102#38388':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 194
    Width = 743
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 743
    inherited TitleBar: TcxLabel
      Caption = #25490#38431#36710#36742#35843#24230
      Style.IsFontAssigned = True
      Width = 743
      AnchorX = 372
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 4
    Top = 240
  end
  inherited DataSource1: TDataSource
    Left = 32
    Top = 240
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 3
    Top = 267
    object N1: TMenuItem
      Caption = #36710#36742#25554#38431#39318
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = #36710#36742#37325#25490#38431
      OnClick = N2Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Tag = 10
      Caption = #36827#20837#38431#21015
      OnClick = N4Click
    end
    object N5: TMenuItem
      Tag = 20
      Caption = #31227#20986#38431#21015
      OnClick = N4Click
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #25351#23450#36947#35013#36710
      OnClick = N3Click
    end
  end
end
