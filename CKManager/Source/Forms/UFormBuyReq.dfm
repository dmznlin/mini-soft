inherited fFormBuyReq: TfFormBuyReq
  Left = 309
  Top = 205
  Width = 426
  Height = 462
  BorderStyle = bsSizeable
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object GroupEdit: TcxGroupBox [0]
    Left = 116
    Top = 204
    Caption = 'GroupEdit'
    PanelStyle.Active = True
    ParentFont = False
    TabOrder = 1
    OnExit = GroupEditExit
    Height = 111
    Width = 261
    object EditNum: TcxTextEdit
      Left = 52
      Top = 18
      ParentFont = False
      TabOrder = 0
      Width = 200
    end
    object cxLabel2: TcxLabel
      Left = 8
      Top = 20
      Caption = #30003#35831#37327':'
      ParentFont = False
      Transparent = True
    end
    object cxLabel3: TcxLabel
      Left = 8
      Top = 46
      Caption = #22791'  '#27880':'
      ParentFont = False
      Transparent = True
    end
    object EditMemo: TcxMemo
      Left = 52
      Top = 40
      ParentFont = False
      Properties.MaxLength = 100
      TabOrder = 3
      Height = 61
      Width = 200
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 418
    Height = 428
    AutoControlAlignment = False
    AutoControlTabOrders = False
    inherited BtnOK: TButton
      Left = 272
      Top = 395
      TabOrder = 1
    end
    inherited BtnExit: TButton
      Left = 342
      Top = 395
      TabOrder = 2
    end
    object EditPart: TcxComboBox [2]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 16
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 32
      TabOrder = 0
      Width = 136
    end
    object cxLabel1: TcxLabel [3]
      Left = 23
      Top = 86
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 16
      Width = 162
    end
    object EditType: TcxCheckComboBox [4]
      Left = 81
      Top = 107
      ParentFont = False
      Properties.ShowEmptyText = False
      Properties.DropDownRows = 18
      Properties.Items = <>
      Properties.OnEditValueChanged = EditTypePropertiesEditValueChanged
      TabOrder = 7
      Width = 121
    end
    object EditDesc: TcxTextEdit [5]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 121
    end
    object ListGoods: TcxMCListBox [6]
      Left = 23
      Top = 132
      Width = 266
      Height = 173
      HeaderSections = <
        item
          Text = #32534#21495
          Width = 74
        end
        item
          Text = #21517#31216
        end
        item
          Alignment = taCenter
          Text = #30003#35831#37327
        end
        item
          Alignment = taCenter
          Text = #21333#20301
        end
        item
          Text = #35268#26684
        end
        item
          Text = #26448#36136
        end
        item
          Text = #22791#27880
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 9
      OnDblClick = ListGoodsDblClick
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item4: TdxLayoutItem
          Caption = #30003#35831#25551#36848':'
          Control = EditDesc
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item11: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #30003#35831#37096#38376':'
          Control = EditPart
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #29289#21697#20998#31867':'
          Control = EditType
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'cxMCListBox1'
          ShowCaption = False
          Control = ListGoods
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
