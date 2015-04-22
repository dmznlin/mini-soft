inherited fFrameTruckQuery: TfFrameTruckQuery
  Width = 780
  Height = 401
  inherited ToolBar1: TToolBar
    Width = 780
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
    Top = 195
    Width = 780
    Height = 206
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 780
    Height = 128
    object cxTextEdit1: TcxTextEdit [0]
      Left = 81
      Top = 96
      Hint = 'T.T_Truck'
      ParentFont = False
      TabOrder = 4
      Width = 100
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
      Width = 100
    end
    object EditTask: TcxButtonEdit [2]
      Left = 244
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
      Width = 100
    end
    object cxTextEdit2: TcxTextEdit [3]
      Left = 244
      Top = 96
      Hint = 'T.T_TaskID'
      ParentFont = False
      TabOrder = 5
      Width = 100
    end
    object cxTextEdit3: TcxTextEdit [4]
      Left = 407
      Top = 96
      Hint = 'T.C_Name'
      ParentFont = False
      TabOrder = 6
      Width = 100
    end
    object EditDate: TcxButtonEdit [5]
      Left = 570
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
      Width = 185
    end
    object EditCustomer: TcxButtonEdit [6]
      Left = 407
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
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item2: TdxLayoutItem
          Caption = #36710#29260#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #20219#21153#21333#21495':'
          Control = EditTask
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #36865#36135#23567#31080':'
          Control = EditCustomer
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
          Caption = #36710#29260#21495#30721':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #20219#21153#21333#21495':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
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
    Top = 187
    Width = 780
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 780
    inherited TitleBar: TcxLabel
      Caption = #36710#36742#36827#20986#31449#26597#35810
      Style.IsFontAssigned = True
      Width = 780
      AnchorX = 390
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 10
    Top = 252
  end
  inherited DataSource1: TDataSource
    Left = 38
    Top = 252
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 10
    Top = 280
    object N4: TMenuItem
      Tag = 10
      Caption = #26174#31034#20840#37096
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Tag = 20
      Caption = #26410#20986#31449#36710#36742
      OnClick = N1Click
    end
    object N1: TMenuItem
      Tag = 30
      Caption = #24050#20986#31449#36710#36742
      OnClick = N1Click
    end
  end
end
