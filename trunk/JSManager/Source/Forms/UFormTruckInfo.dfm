inherited fFormTruckInfo: TfFormTruckInfo
  Left = 347
  Top = 147
  ClientHeight = 375
  ClientWidth = 374
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 374
    Height = 375
    inherited BtnOK: TButton
      Left = 228
      Top = 342
      TabOrder = 10
    end
    inherited BtnExit: TButton
      Left = 298
      Top = 342
      TabOrder = 11
    end
    object EditNo: TcxTextEdit [2]
      Left = 81
      Top = 36
      Hint = 'T.T_TruckNo'
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 0
      Width = 105
    end
    object EditMemo: TcxMemo [3]
      Left = 81
      Top = 86
      Hint = 'T.T_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 4
      Height = 50
      Width = 262
    end
    object EditType: TcxComboBox [4]
      Left = 249
      Top = 36
      Hint = 'T.T_Type'
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.MaxLength = 32
      TabOrder = 1
      Width = 135
    end
    object EditPhone: TcxTextEdit [5]
      Left = 249
      Top = 61
      Hint = 'T.T_Phone'
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 3
      Width = 135
    end
    object EditOwner: TcxTextEdit [6]
      Left = 81
      Top = 61
      Hint = 'T.T_Owner'
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 2
      Width = 105
    end
    object ListInfo1: TcxMCListBox [7]
      Left = 23
      Top = 223
      Width = 304
      Height = 102
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 85
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 215
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 9
      OnClick = ListInfo1Click
    end
    object EditInfo: TcxTextEdit [8]
      Left = 81
      Top = 198
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 7
      Width = 121
    end
    object InfoItems: TcxTextEdit [9]
      Left = 81
      Top = 173
      ParentFont = False
      Properties.MaxLength = 30
      TabOrder = 5
      Width = 263
    end
    object BtnDel: TButton [10]
      Left = 301
      Top = 198
      Width = 50
      Height = 20
      Caption = #21024#38500
      TabOrder = 8
      OnClick = BtnDelClick
    end
    object BtnAdd: TButton [11]
      Left = 301
      Top = 173
      Width = 50
      Height = 20
      Caption = #28155#21152
      TabOrder = 6
      OnClick = BtnAddClick
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        AutoAligns = [aaVertical]
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item5: TdxLayoutItem
            Caption = #36710' '#29260' '#21495':'
            Control = EditNo
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item13: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #36710#36742#31867#22411':'
            Control = EditType
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item16: TdxLayoutItem
            AutoAligns = [aaVertical]
            Caption = #36710#20027#22995#21517':'
            Control = EditOwner
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item14: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #32852#31995#26041#24335':'
            Control = EditPhone
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item6: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #22791#27880#20449#24687':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #38468#21152#20449#24687
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item7: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #20449' '#24687' '#39033':'
            Control = InfoItems
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item9: TdxLayoutItem
            Caption = 'Button2'
            ShowCaption = False
            Control = BtnAdd
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group5: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item4: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #20449#24687#20869#23481':'
            Control = EditInfo
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            Caption = 'Button1'
            ShowCaption = False
            Control = BtnDel
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'cxMCListBox1'
          ShowCaption = False
          Control = ListInfo1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
