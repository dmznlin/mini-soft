inherited fFrameClothesIn: TfFrameClothesIn
  Width = 971
  Height = 527
  inherited ToolBar1: TToolBar
    Width = 971
    inherited BtnAdd: TToolButton
      Caption = #25910#34915#26381
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      Caption = #21462#34915#26381
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      OnClick = BtnDelClick
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 187
    Width = 971
    Height = 340
    inherited cxView1: TcxGridDBTableView
      PopupMenu = PMenu1
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 971
    Height = 120
    object EditName: TcxButtonEdit [0]
      Left = 304
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
    object EditPhone: TcxButtonEdit [1]
      Left = 476
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = cxButtonEdit1PropertiesButtonClick
      TabOrder = 2
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object EditID: TcxButtonEdit [2]
      Left = 100
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = cxButtonEdit1PropertiesButtonClick
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clWindowText
      Style.Font.Height = -16
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object EditDate: TcxButtonEdit [3]
      Left = 680
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditDatePropertiesButtonClick
      TabOrder = 3
      Width = 185
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item4: TdxLayoutItem
          Caption = #26631#31614#32534#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
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
        object dxLayout1Item3: TdxLayoutItem
          Caption = #26085#26399#31579#36873':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 179
    Width = 971
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 971
    inherited TitleBar: TcxLabel
      Caption = #25910#21462#34915#29289#26126#32454
      Style.IsFontAssigned = True
      Width = 971
      AnchorX = 486
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Top = 230
  end
  inherited DataSource1: TDataSource
    Top = 230
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 62
    Top = 232
    object N1: TMenuItem
      Caption = #25171#21360#31080#25454
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #26597#26410#32467#24080
      OnClick = N3Click
    end
    object N4: TMenuItem
      Caption = #26597#26410#39046#21462
      OnClick = N4Click
    end
  end
end
