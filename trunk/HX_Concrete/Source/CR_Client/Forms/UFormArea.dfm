inherited fFormArea: TfFormArea
  Left = 459
  Top = 371
  ClientHeight = 219
  ClientWidth = 395
  PixelsPerInch = 120
  TextHeight = 15
  inherited dxLayout1: TdxLayoutControl
    Width = 395
    Height = 219
    inherited BtnOK: TButton
      Left = 213
      Top = 177
      TabOrder = 3
    end
    inherited BtnExit: TButton
      Left = 300
      Top = 177
      TabOrder = 4
    end
    object EditID: TcxTextEdit [2]
      Left = 69
      Top = 45
      Properties.MaxLength = 32
      TabOrder = 0
      Width = 121
    end
    object EditName: TcxTextEdit [3]
      Left = 69
      Top = 73
      Properties.MaxLength = 32
      TabOrder = 1
      Width = 121
    end
    object EditURL: TcxTextEdit [4]
      Left = 69
      Top = 101
      Properties.MaxLength = 100
      TabOrder = 2
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #32534#21495#65306
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #21517#31216#65306
          Control = EditName
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #26381#21153#65306
          Control = EditURL
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
