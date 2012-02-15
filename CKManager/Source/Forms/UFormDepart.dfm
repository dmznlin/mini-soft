inherited fFormDepart: TfFormDepart
  Left = 400
  Top = 326
  ClientHeight = 379
  ClientWidth = 378
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 378
    Height = 379
    AutoControlAlignment = False
    AutoControlTabOrders = False
    inherited BtnOK: TButton
      Left = 232
      Top = 346
      TabOrder = 8
    end
    inherited BtnExit: TButton
      Left = 302
      Top = 346
      TabOrder = 9
    end
    object EditName: TcxTextEdit [2]
      Left = 81
      Top = 36
      Hint = 'T.D_Name'
      ParentFont = False
      Properties.MaxLength = 52
      TabOrder = 0
      Width = 403
    end
    object InfoItems: TcxComboBox [3]
      Left = 81
      Top = 180
      ParentFont = False
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.MaxLength = 30
      TabOrder = 3
      Width = 100
    end
    object InfoList1: TcxMCListBox [4]
      Left = 23
      Top = 234
      Width = 338
      Height = 100
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 105
        end
        item
          AutoSize = True
          Text = #20869#23481
          Width = 229
        end>
      ParentFont = False
      Style.BorderStyle = cbsOffice11
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 7
    end
    object EditInfo: TcxTextEdit [5]
      Left = 81
      Top = 207
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 4
      Width = 120
    end
    object BtnAdd: TButton [6]
      Left = 310
      Top = 180
      Width = 45
      Height = 22
      Caption = #28155#21152
      TabOrder = 5
      OnClick = BtnAddClick
    end
    object BtnDel: TButton [7]
      Left = 310
      Top = 207
      Width = 45
      Height = 22
      Caption = #21024#38500
      TabOrder = 6
      OnClick = BtnDelClick
    end
    object cxTextEdit1: TcxTextEdit [8]
      Left = 81
      Top = 61
      Hint = 'T.D_Owner'
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 1
      Width = 121
    end
    object cxTextEdit2: TcxTextEdit [9]
      Left = 81
      Top = 86
      Hint = 'T.D_Phone'
      ParentFont = False
      Properties.MaxLength = 22
      TabOrder = 2
      Width = 121
    end
    object EditPPart: TcxLookupComboBox [10]
      Left = 81
      Top = 111
      Hint = 'T.D_Parent'
      Properties.ListColumns = <>
      TabOrder = 13
      Width = 145
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item7: TdxLayoutItem
          Caption = #37096#38376#21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #37096#38376#20027#31649':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item10: TdxLayoutItem
          Caption = #32852#31995#30005#35805':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item11: TdxLayoutItem
          Caption = #19978#32423#37096#38376':'
          Control = EditPPart
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayout1Group2: TdxLayoutGroup [1]
        Caption = #38468#21152#20449#24687
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group5: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item3: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #20449' '#24687' '#39033':'
              Control = InfoItems
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item6: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              ShowCaption = False
              Control = BtnAdd
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group4: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item5: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #20449#24687#20869#23481':'
              Control = EditInfo
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item8: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              ShowCaption = False
              Control = BtnDel
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Item4: TdxLayoutItem
          Control = InfoList1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
