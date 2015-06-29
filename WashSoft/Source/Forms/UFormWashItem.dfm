inherited fFormWashItem: TfFormWashItem
  Left = 419
  Top = 614
  Caption = #25910#21462#34915#29289
  ClientHeight = 254
  ClientWidth = 480
  FormStyle = fsStayOnTop
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  inherited dxLayout1: TdxLayoutControl
    Width = 480
    Height = 254
    inherited BtnOK: TButton
      Left = 329
      Top = 217
      TabOrder = 6
    end
    inherited BtnExit: TButton
      Left = 400
      Top = 217
      Caption = #20851#38381
      TabOrder = 7
    end
    object EditName: TcxTextEdit [2]
      Left = 108
      Top = 47
      Hint = 'T.T_Name'
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 0
      OnKeyPress = EditNameKeyPress
      Width = 280
    end
    object EditMemo: TcxTextEdit [3]
      Left = 108
      Top = 137
      Hint = 'T.T_Memo'
      ParentFont = False
      TabOrder = 5
      Width = 121
    end
    object EditUnit: TcxComboBox [4]
      Left = 312
      Top = 77
      Hint = 'T.T_Unit'
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 22
      Properties.MaxLength = 16
      TabOrder = 2
      OnKeyDown = EditUnitKeyDown
      OnKeyPress = EditNumKeyPress
      Width = 121
    end
    object EditWashType: TcxComboBox [5]
      Left = 312
      Top = 107
      Hint = 'T.T_WashType'
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 22
      Properties.MaxLength = 16
      TabOrder = 4
      OnKeyDown = EditUnitKeyDown
      OnKeyPress = EditNumKeyPress
      Width = 121
    end
    object EditNum: TcxTextEdit [6]
      Left = 108
      Top = 77
      ParentFont = False
      TabOrder = 1
      Text = '0'
      OnKeyPress = EditNumKeyPress
      Width = 121
    end
    object EditColor: TcxComboBox [7]
      Left = 108
      Top = 107
      Hint = 'T.T_Unit'
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 22
      Properties.MaxLength = 16
      TabOrder = 3
      OnKeyDown = EditUnitKeyDown
      OnKeyPress = EditNumKeyPress
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #34915#29289#21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item8: TdxLayoutItem
            Caption = #34915#29289#25968#37327':'
            Control = EditNum
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item7: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #34915#29289#21333#20301':'
            Control = EditUnit
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item9: TdxLayoutItem
            Caption = #34915#29289#39068#33394':'
            Control = EditColor
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item4: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #28165#29702#26041#24335':'
            Control = EditWashType
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
    end
  end
end
