inherited fFrameTruckInfo: TfFrameTruckInfo
  Width = 681
  inherited ToolBar1: TToolBar
    Width = 681
    inherited BtnAdd: TToolButton
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      OnClick = BtnDelClick
    end
    inherited BtnExit: TToolButton
      OnClick = BtnExitClick
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 196
    Width = 681
    Height = 171
    inherited cxView1: TcxGridDBTableView
      OnDblClick = cxView1DblClick
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 681
    Height = 135
    object EditID: TcxButtonEdit [0]
      Left = 69
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
      Width = 105
    end
    object cxTextEdit1: TcxTextEdit [1]
      Left = 69
      Top = 93
      Hint = 'T.T_TruckNo'
      ParentFont = False
      TabOrder = 1
      Width = 105
    end
    object cxTextEdit2: TcxTextEdit [2]
      Left = 237
      Top = 93
      Hint = 'T.T_Owner'
      ParentFont = False
      TabOrder = 2
      Width = 105
    end
    object cxTextEdit3: TcxTextEdit [3]
      Left = 573
      Top = 93
      Hint = 'T.T_Memo'
      ParentFont = False
      TabOrder = 4
      Width = 121
    end
    object cxTextEdit4: TcxTextEdit [4]
      Left = 405
      Top = 93
      Hint = 'T.T_Phone'
      TabOrder = 3
      Width = 105
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #36710#29260#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item2: TdxLayoutItem
          Caption = #36710#29260#21495':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #36710#20027#22995#21517':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #32852#31995#26041#24335':'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #22791#27880#20449#24687':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited TitleBar: TcxLabel
    Caption = #36710#36742#20449#24687#31649#29702
    Width = 681
  end
  inherited SQLQuery: TADOQuery
    Top = 228
  end
  inherited DataSource1: TDataSource
    Top = 228
  end
end
