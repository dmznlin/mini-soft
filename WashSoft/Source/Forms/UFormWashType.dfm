inherited fFormWashType: TfFormWashType
  Left = 548
  Top = 592
  Caption = #26723#26696
  ClientHeight = 236
  ClientWidth = 461
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 16
  inherited dxLayout1: TdxLayoutControl
    Width = 461
    Height = 236
    inherited BtnOK: TButton
      Left = 310
      Top = 199
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 381
      Top = 199
      TabOrder = 6
    end
    object EditName: TcxTextEdit [2]
      Left = 108
      Top = 47
      Hint = 'T.T_Name'
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 0
      Width = 280
    end
    object EditPrice: TcxTextEdit [3]
      Left = 312
      Top = 77
      Hint = 'T.T_Price'
      ParentFont = False
      TabOrder = 2
      Text = '0'
      Width = 121
    end
    object EditMemo: TcxTextEdit [4]
      Left = 108
      Top = 137
      Hint = 'T.T_Memo'
      ParentFont = False
      TabOrder = 4
      Width = 121
    end
    object EditUnit: TcxComboBox [5]
      Left = 108
      Top = 77
      Hint = 'T.T_Unit'
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 22
      Properties.Items.Strings = (
        #20214
        #22871
        #20010)
      Properties.MaxLength = 16
      TabOrder = 1
      Width = 121
    end
    object EditWashType: TcxComboBox [6]
      Left = 108
      Top = 107
      Hint = 'T.T_WashType'
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 22
      Properties.Items.Strings = (
        #24178#27927
        #27700#27927)
      Properties.MaxLength = 16
      TabOrder = 3
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
          object dxLayout1Item7: TdxLayoutItem
            Caption = #34915#29289#21333#20301':'
            Control = EditUnit
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #21333#20301#20215#26684':'
            Control = EditPrice
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #28165#29702#26041#24335':'
          Control = EditWashType
          ControlOptions.ShowBorder = False
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
