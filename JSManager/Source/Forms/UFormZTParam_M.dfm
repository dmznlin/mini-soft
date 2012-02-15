inherited fFormZTParam_M: TfFormZTParam_M
  Left = 501
  Top = 372
  ClientHeight = 356
  ClientWidth = 361
  Position = poMainFormCenter
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 361
    Height = 356
    inherited BtnOK: TButton
      Left = 215
      Top = 323
      TabOrder = 10
    end
    inherited BtnExit: TButton
      Left = 285
      Top = 323
      TabOrder = 11
    end
    object PortList1: TcxComboBox [2]
      Left = 57
      Top = 36
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      TabOrder = 0
      Width = 85
    end
    object EditDesc: TcxTextEdit [3]
      Left = 193
      Top = 36
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 1
      Width = 161
    end
    object EditNum: TcxTextEdit [4]
      Left = 57
      Top = 61
      ParentFont = False
      TabOrder = 2
      Width = 247
    end
    object EditDelay: TcxTextEdit [5]
      Left = 57
      Top = 86
      ParentFont = False
      TabOrder = 4
      Width = 247
    end
    object BtnAdd: TcxButton [6]
      Left = 283
      Top = 61
      Width = 55
      Height = 20
      Caption = #28155#21152
      TabOrder = 3
      OnClick = BtnAddClick
    end
    object BtnDel: TcxButton [7]
      Left = 283
      Top = 86
      Width = 55
      Height = 20
      Caption = #21024#38500
      TabOrder = 5
      OnClick = BtnDelClick
    end
    object ListTunnel: TcxMCListBox [8]
      Left = 23
      Top = 111
      Width = 351
      Height = 101
      HeaderSections = <
        item
          Text = #35013#36710#32447
          Width = 80
        end
        item
          Alignment = taCenter
          Text = #31471#21475
          Width = 65
        end
        item
          Alignment = taCenter
          Text = #30828#20214#32534#21495
          Width = 65
        end
        item
          Alignment = taCenter
          Text = #27599#21253#24310#36831
          Width = 65
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 6
      OnClick = ListTunnelClick
    end
    object cxLabel3: TcxLabel [9]
      Left = 23
      Top = 274
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 12
      Width = 351
    end
    object EditWeight: TcxTextEdit [10]
      Left = 57
      Top = 291
      ParentFont = False
      TabOrder = 8
      Width = 242
    end
    object cxLabel1: TcxLabel [11]
      Left = 268
      Top = 291
      Caption = #20844#26020'(Kg)/'#34955
      ParentFont = False
      Transparent = True
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group6: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item3: TdxLayoutItem
              Caption = #31471#21475':'
              Control = PortList1
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item4: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #35013#36710#32447':'
              Control = EditDesc
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group8: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayout1Group5: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item5: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahClient
                Caption = #32534#21495':'
                Control = EditNum
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item7: TdxLayoutItem
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
              object dxLayout1Item6: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahClient
                Caption = #24310#36831':'
                Control = EditDelay
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
        end
        object dxLayout1Group2: TdxLayoutGroup
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item9: TdxLayoutItem
            AutoAligns = [aaHorizontal]
            AlignVert = avClient
            Control = ListTunnel
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item10: TdxLayoutItem
            AutoAligns = [aaHorizontal]
            AlignVert = avBottom
            ShowCaption = False
            Control = cxLabel3
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Group7: TdxLayoutGroup
            AutoAligns = [aaHorizontal]
            AlignVert = avBottom
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item11: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #34955#37325':'
              Control = EditWeight
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item12: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              ShowCaption = False
              Control = cxLabel1
              ControlOptions.ShowBorder = False
            end
          end
        end
      end
    end
  end
end
