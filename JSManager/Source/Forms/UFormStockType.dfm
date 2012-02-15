inherited fFormStockType: TfFormStockType
  Left = 347
  Top = 270
  ClientHeight = 234
  ClientWidth = 377
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 377
    Height = 234
    inherited BtnOK: TButton
      Left = 226
      Top = 198
      TabOrder = 6
    end
    inherited BtnExit: TButton
      Left = 296
      Top = 198
      TabOrder = 7
    end
    object EditName: TcxTextEdit [2]
      Left = 81
      Top = 61
      Hint = 'T.S_Name'
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 1
      Width = 121
    end
    object EditMemo: TcxMemo [3]
      Left = 81
      Top = 136
      Hint = 'T.S_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 5
      Height = 50
      Width = 268
    end
    object EditID: TcxButtonEdit [4]
      Left = 81
      Top = 36
      Hint = 'T.S_ID'
      HelpType = htKeyword
      HelpKeyword = 'NU'
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.MaxLength = 15
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 0
      Width = 252
    end
    object EditType: TcxComboBox [5]
      Left = 81
      Top = 111
      Hint = 'T.S_Type'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.Items.Strings = (
        'D=D'#12289#34955#35013
        'S=S'#12289#25955#35013)
      TabOrder = 3
      Width = 128
    end
    object EditWeight: TcxTextEdit [6]
      Left = 272
      Top = 111
      Hint = 'T.S_Weight'
      ParentFont = False
      TabOrder = 4
      Width = 67
    end
    object EditLevel: TcxTextEdit [7]
      Left = 81
      Top = 86
      Hint = 'T.S_Level'
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 2
      Width = 268
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        AutoAligns = [aaVertical]
        object dxLayout1Item12: TdxLayoutItem
          Caption = #21697#31181#32534#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #21697#31181#21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item16: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #24378#24230#31561#32423':'
          Control = EditLevel
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group3: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item13: TdxLayoutItem
              Caption = #27700#27877#31867#22411':'
              Control = EditType
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item14: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #34955#37325'(kg):'
              Control = EditWeight
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
end
