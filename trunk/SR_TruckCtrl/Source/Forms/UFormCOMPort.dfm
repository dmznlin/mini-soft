inherited fFormPort: TfFormPort
  Left = 292
  Top = 194
  Caption = #20018#21475
  ClientHeight = 351
  ClientWidth = 327
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 327
    Height = 351
    inherited BtnOK: TButton
      Left = 181
      Top = 318
      TabOrder = 6
    end
    inherited BtnExit: TButton
      Left = 251
      Top = 318
      TabOrder = 7
    end
    object EditName: TcxTextEdit [2]
      Left = 69
      Top = 36
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 0
      Width = 121
    end
    object cxLabel1: TcxLabel [3]
      Left = 23
      Top = 61
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 12
      Width = 241
    end
    object EditBaud: TcxComboBox [4]
      Left = 69
      Top = 103
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 12
      Properties.ItemHeight = 18
      TabOrder = 3
      Width = 121
    end
    object EditData: TcxComboBox [5]
      Left = 69
      Top = 128
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 12
      Properties.ItemHeight = 18
      TabOrder = 4
      Width = 121
    end
    object EditStop: TcxComboBox [6]
      Left = 69
      Top = 153
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 12
      Properties.ItemHeight = 18
      TabOrder = 5
      Width = 121
    end
    object EditPort: TcxComboBox [7]
      Left = 69
      Top = 78
      ParentFont = False
      Properties.DropDownRows = 12
      Properties.ItemHeight = 18
      TabOrder = 2
      Width = 235
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #21442#25968#20449#24687
        object dxLayout1Item3: TdxLayoutItem
          Caption = #21517'  '#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #31471'  '#21475':'
          Control = EditPort
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #27874#29305#29575':'
          Control = EditBaud
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #25968#25454#20301':'
          Control = EditData
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #20572#27490#20301':'
          Control = EditStop
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
