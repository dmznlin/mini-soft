inherited fFormMember: TfFormMember
  Left = 483
  Top = 516
  Caption = #20250#21592#26723#26696
  ClientHeight = 312
  ClientWidth = 483
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 16
  inherited dxLayout1: TdxLayoutControl
    Width = 483
    Height = 312
    inherited BtnOK: TButton
      Left = 332
      Top = 275
      TabOrder = 8
    end
    inherited BtnExit: TButton
      Left = 403
      Top = 275
      TabOrder = 9
    end
    object EditName: TcxTextEdit [2]
      Left = 108
      Top = 47
      Hint = 'T.M_Name'
      ParentFont = False
      TabOrder = 0
      Width = 280
    end
    object EditPhone: TcxTextEdit [3]
      Left = 108
      Top = 77
      Hint = 'T.M_Phone'
      ParentFont = False
      TabOrder = 1
      Width = 121
    end
    object EditJiFen: TcxTextEdit [4]
      Left = 108
      Top = 107
      Hint = 'T.M_JiFen'
      ParentFont = False
      TabOrder = 2
      Text = '0'
      Width = 121
    end
    object EditZheKou: TcxTextEdit [5]
      Left = 312
      Top = 107
      HelpType = htKeyword
      HelpKeyword = 'T.M_ZheKou'
      ParentFont = False
      TabOrder = 3
      Text = '1'
      Width = 121
    end
    object EditMIn: TcxTextEdit [6]
      Left = 108
      Top = 206
      Hint = 'T.M_MoneyIn'
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 4
      Text = '0'
      Width = 121
    end
    object EditMFreeze: TcxTextEdit [7]
      Left = 312
      Top = 206
      Hint = 'T.M_MoneyFreeze'
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 5
      Text = '0'
      Width = 121
    end
    object EditMOut: TcxTextEdit [8]
      Left = 108
      Top = 236
      Hint = 'T.M_MoneyOut'
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 6
      Text = '0'
      Width = 121
    end
    object EditTimes: TcxTextEdit [9]
      Left = 312
      Top = 236
      Hint = 'T.M_Times'
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 7
      Text = '0'
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
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
          object dxLayout1Item5: TdxLayoutItem
            Caption = #28040#36153#31215#20998':'
            Control = EditJiFen
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item6: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #28040#36153#25240#25187':'
            Control = EditZheKou
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        Caption = #28040#36153#20449#24687
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item7: TdxLayoutItem
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
        object dxLayout1Group5: TdxLayoutGroup
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
  end
end
