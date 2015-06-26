inherited fFormWashData: TfFormWashData
  Left = 386
  Top = 209
  Width = 659
  Height = 680
  BorderStyle = bsSizeable
  Caption = #25910#21462#34915#29289
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  inherited dxLayout1: TdxLayoutControl
    Width = 651
    Height = 653
    inherited BtnOK: TButton
      Left = 500
      Top = 616
      TabOrder = 12
    end
    inherited BtnExit: TButton
      Left = 571
      Top = 616
      TabOrder = 13
    end
    object EditPhone: TcxTextEdit [2]
      Left = 108
      Top = 77
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 121
    end
    object EditZheKou: TcxTextEdit [3]
      Left = 406
      Top = 107
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 121
    end
    object EditMoney: TcxTextEdit [4]
      Left = 108
      Top = 107
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 121
    end
    object EditName: TcxButtonEdit [5]
      Left = 108
      Top = 47
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = False
      Properties.OnButtonClick = EditNamePropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 121
    end
    object ListGrid: TcxListView [6]
      Left = 31
      Top = 237
      Width = 121
      Height = 97
      Columns = <
        item
          Caption = #32534#21495
        end
        item
          Caption = #21517#31216
        end
        item
          Caption = #39068#33394
        end
        item
          Caption = #25968#37327
        end
        item
          Caption = #21333#20301
        end
        item
          Caption = #31867#22411
        end
        item
          Caption = #22791#27880
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 4
      ViewStyle = vsReport
    end
    object cxTextEdit3: TcxTextEdit [7]
      Left = 108
      Top = 521
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 121
    end
    object cxTextEdit4: TcxTextEdit [8]
      Left = 406
      Top = 521
      ParentFont = False
      TabOrder = 9
      Width = 121
    end
    object cxButton1: TcxButton [9]
      Left = 545
      Top = 419
      Width = 75
      Height = 25
      Caption = #21024#38500
      TabOrder = 6
    end
    object cxButton2: TcxButton [10]
      Left = 464
      Top = 419
      Width = 75
      Height = 25
      Caption = #28155#21152
      TabOrder = 5
    end
    object Check1: TcxCheckBox [11]
      Left = 31
      Top = 491
      Caption = #21462#34915#29289#26102#32467#24080
      ParentFont = False
      TabOrder = 7
      Transparent = True
      Width = 135
    end
    object cxLabel1: TcxLabel [12]
      Left = 31
      Top = 551
      Caption = #25552#31034': '#23458#25143#20132#29616#37329#26102#36755#20837#37329#39069#65292#27809#20132#29616#37329#35831#36755#20837'0.'
      ParentFont = False
      Transparent = True
    end
    object EditPay: TcxTextEdit [13]
      Left = 108
      Top = 577
      ParentFont = False
      TabOrder = 11
      Text = '0'
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #20250#21592#20449#24687
        object dxLayout1Item5: TdxLayoutItem
          Caption = #20250#21592#21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #25163#26426#21495#30721':'
          Control = EditPhone
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item8: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #21097#20313#37329#39069':'
            Control = EditMoney
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item7: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #28040#36153#25240#25187':'
            Control = EditZheKou
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #34915#29289#26126#32454
        object dxLayout1Item9: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'cxListView1'
          ShowCaption = False
          Control = ListGrid
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          AutoAligns = [aaVertical]
          AlignHorz = ahRight
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item13: TdxLayoutItem
            Caption = 'cxButton2'
            ShowCaption = False
            Control = cxButton2
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item12: TdxLayoutItem
            Caption = 'cxButton1'
            ShowCaption = False
            Control = cxButton1
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxGroup3: TdxLayoutGroup [2]
        AutoAligns = [aaHorizontal]
        AlignVert = avBottom
        Caption = #25903#20184#36153#29992
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaVertical]
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = Check1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group5: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item10: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #24212#25910#37329#39069':'
            Control = cxTextEdit3
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item11: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #23454#25910#37329#39069':'
            Control = cxTextEdit4
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item14: TdxLayoutItem
          Caption = #26412#27425#25903#20184':'
          Control = EditPay
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
