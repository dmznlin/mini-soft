inherited fFormIOMoney: TfFormIOMoney
  Left = 483
  Top = 516
  Caption = #20250#21592#20805#20540
  ClientHeight = 321
  ClientWidth = 476
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 16
  inherited dxLayout1: TdxLayoutControl
    Width = 476
    Height = 321
    inherited BtnOK: TButton
      Left = 325
      Top = 284
      Caption = #20805#20540
      TabOrder = 8
    end
    inherited BtnExit: TButton
      Left = 396
      Top = 284
      TabOrder = 9
    end
    object EditPhone: TcxTextEdit [2]
      Left = 108
      Top = 77
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 121
    end
    object EditMIn: TcxTextEdit [3]
      Left = 108
      Top = 107
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 121
    end
    object EditMFreeze: TcxTextEdit [4]
      Left = 312
      Top = 107
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 121
    end
    object EditMOut: TcxTextEdit [5]
      Left = 108
      Top = 137
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 121
    end
    object EditTimes: TcxTextEdit [6]
      Left = 312
      Top = 137
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 121
    end
    object EditName: TcxButtonEdit [7]
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
    object EditMoney: TcxButtonEdit [8]
      Left = 108
      Top = 215
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 6
      Text = '0'
      Width = 121
    end
    object EditMemo: TcxTextEdit [9]
      Left = 108
      Top = 245
      ParentFont = False
      Properties.MaxLength = 100
      TabOrder = 7
      Text = #20250#21592#20805#20540
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
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
          ShowBorder = False
          object dxLayout1Group5: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item7: TdxLayoutItem
              AutoAligns = [aaVertical]
              Caption = #20805#20540#37329#39069':'
              Control = EditMIn
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item8: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #20923#32467#37329#39069':'
              Control = EditMFreeze
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group4: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item9: TdxLayoutItem
              AutoAligns = [aaVertical]
              Caption = #28040#36153#37329#39069':'
              Control = EditMOut
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item10: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #28040#36153#27425#25968':'
              Control = EditTimes
              ControlOptions.ShowBorder = False
            end
          end
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        Caption = #20805#20540': '#36755#20837#36127#20540#20026#36864#27454'.'
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #20805#20540#37329#39069':'
          Control = EditMoney
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #25551#36848#22791#27880':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
