inherited fFormJSTruck_M: TfFormJSTruck_M
  Left = 501
  Top = 372
  Width = 538
  Height = 417
  BorderStyle = bsSizeable
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 530
    Height = 383
    OnResize = dxLayout1Resize
    inherited BtnOK: TButton
      Left = 384
      Top = 350
      Caption = #30830#23450
      TabOrder = 2
    end
    inherited BtnExit: TButton
      Left = 454
      Top = 350
      TabOrder = 3
    end
    object ListPD: TcxMCListBox [2]
      Left = 23
      Top = 54
      Width = 472
      Height = 129
      HeaderSections = <
        item
          Text = #36710#29260#21495#30721
          Width = 74
        end
        item
          Text = #27700#27877#21697#31181
          Width = 65
        end
        item
          Alignment = taCenter
          Text = #25552#36135#37327'('#21544')'
          Width = 75
        end
        item
          Alignment = taCenter
          Text = #25209#27425#21495
        end
        item
          Text = #23458#25143#21517#31216
        end>
      ItemHeight = 18
      ParentFont = False
      Style.Edges = [bLeft, bRight, bBottom]
      TabOrder = 0
      OnClick = ListPDClick
      OnDblClick = ListYZDblClick
    end
    object ListYZ: TcxMCListBox [3]
      Left = 23
      Top = 206
      Width = 472
      Height = 129
      HeaderSections = <
        item
          Text = #36710#29260#21495#30721
          Width = 74
        end
        item
          Text = #27700#27877#21697#31181
        end
        item
          Alignment = taCenter
          Text = #25552#36135#37327'('#21544')'
        end
        item
          Alignment = taCenter
          Text = #25209#27425#21495
        end
        item
          Text = #23458#25143#21517#31216
        end>
      ItemHeight = 18
      ParentFont = False
      Style.Edges = [bLeft, bRight, bBottom]
      TabOrder = 1
      OnClick = ListPDClick
      OnDblClick = ListYZDblClick
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #36710#36742#21015#34920
        object dxLayout1Item3: TdxLayoutItem
          Caption = #25490#38431#36710#36742':'
          CaptionOptions.Layout = clTop
          Control = ListPD
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = #26368#36817#24050#35013#36710':'
          CaptionOptions.Layout = clTop
          Control = ListYZ
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
