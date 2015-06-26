inherited fFormGetMember: TfFormGetMember
  Left = 401
  Top = 134
  Width = 653
  Height = 474
  BorderStyle = bsSizeable
  Constraints.MinHeight = 300
  Constraints.MinWidth = 445
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  inherited dxLayout1: TdxLayoutControl
    Width = 645
    Height = 447
    inherited BtnOK: TButton
      Left = 494
      Top = 410
      Caption = #30830#23450
      TabOrder = 3
    end
    inherited BtnExit: TButton
      Left = 565
      Top = 410
      TabOrder = 4
    end
    object EditCus: TcxButtonEdit [2]
      Left = 108
      Top = 47
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditCIDPropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 161
    end
    object ListCustom: TcxListView [3]
      Left = 31
      Top = 103
      Width = 556
      Height = 193
      Columns = <
        item
          Caption = #20250#21592#32534#21495
          Width = 93
        end
        item
          Caption = #20250#21592#21517#31216
          Width = 93
        end
        item
          Caption = #25163#26426#21495#30721
          Width = 93
        end>
      HideSelection = False
      ParentFont = False
      ReadOnly = True
      RowSelect = True
      SmallImages = FDM.ImageBar
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 2
      ViewStyle = vsReport
      OnDblClick = ListCustomDblClick
      OnKeyPress = ListCustomKeyPress
    end
    object cxLabel1: TcxLabel [4]
      Left = 31
      Top = 77
      Caption = #26597#35810#32467#26524':'
      ParentFont = False
      Transparent = True
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #26597#35810#26465#20214
        object dxLayout1Item5: TdxLayoutItem
          Caption = #20250#21592#21517#31216':'
          Control = EditCus
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = #26597#35810#32467#26524':'
          ShowCaption = False
          Control = ListCustom
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
