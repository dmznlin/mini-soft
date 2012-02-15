inherited fFormCustomer: TfFormCustomer
  Left = 324
  Top = 188
  ClientHeight = 416
  ClientWidth = 456
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 456
    Height = 416
    inherited BtnOK: TButton
      Left = 304
      Top = 380
      TabOrder = 11
    end
    inherited BtnExit: TButton
      Left = 374
      Top = 380
      TabOrder = 12
    end
    object EditMemo: TcxMemo [2]
      Left = 81
      Top = 136
      Hint = 'T.C_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 5
      OnKeyDown = OnCtrlKeyDown
      Height = 50
      Width = 320
    end
    object EditPhone: TcxTextEdit [3]
      Left = 81
      Top = 86
      Hint = 'T.C_Phone'
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 3
      OnKeyDown = OnCtrlKeyDown
      Width = 110
    end
    object EditName: TcxTextEdit [4]
      Left = 81
      Top = 61
      Hint = 'T.C_Name'
      ParentFont = False
      Properties.MaxLength = 100
      TabOrder = 1
      OnExit = EditNameExit
      OnKeyDown = OnCtrlKeyDown
      Width = 195
    end
    object ListInfo1: TcxMCListBox [5]
      Left = 23
      Top = 273
      Width = 234
      Height = 95
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 85
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 145
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 10
      OnClick = ListInfo1Click
      OnKeyDown = OnCtrlKeyDown
    end
    object EditInfo: TcxTextEdit [6]
      Left = 81
      Top = 248
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 8
      OnKeyDown = OnCtrlKeyDown
      Width = 186
    end
    object InfoItems: TcxTextEdit [7]
      Left = 81
      Top = 223
      ParentFont = False
      Properties.MaxLength = 30
      TabOrder = 6
      OnKeyDown = OnCtrlKeyDown
      Width = 180
    end
    object BtnDel: TButton [8]
      Left = 377
      Top = 248
      Width = 50
      Height = 20
      Caption = #21024#38500
      TabOrder = 9
      OnClick = BtnDelClick
    end
    object BtnAdd: TButton [9]
      Left = 377
      Top = 223
      Width = 50
      Height = 20
      Caption = #28155#21152
      TabOrder = 7
      OnClick = BtnAddClick
    end
    object EditID: TcxButtonEdit [10]
      Left = 81
      Top = 36
      Hint = 'T.C_ID'
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.MaxLength = 15
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 0
      OnKeyDown = OnCtrlKeyDown
      Width = 121
    end
    object cxTextEdit1: TcxTextEdit [11]
      Left = 81
      Top = 111
      Hint = 'T.C_Addr'
      Properties.MaxLength = 100
      TabOrder = 4
      OnKeyDown = OnCtrlKeyDown
      Width = 155
    end
    object EditPY: TcxTextEdit [12]
      Left = 327
      Top = 61
      Hint = 'T.C_PY'
      Properties.MaxLength = 100
      TabOrder = 2
      OnKeyDown = OnCtrlKeyDown
      Width = 100
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        AutoAligns = [aaVertical]
        object dxLayout1Item10: TdxLayoutItem
          Caption = #23458#25143#32534#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item16: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #23458#25143#21517#31216':'
            Control = EditName
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item11: TdxLayoutItem
            Caption = #21161#35760#30721':'
            Control = EditPY
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item14: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #32852#31995#26041#24335':'
            Control = EditPhone
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            Caption = #32852#31995#22320#22336':'
            Control = cxTextEdit1
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
          Caption = 'cxMCListBox1'
          ShowCaption = False
          Control = ListInfo1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
