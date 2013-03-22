inherited fFormSetIndex: TfFormSetIndex
  Left = 253
  Top = 248
  Caption = #35774#22791#22320#22336
  ClientHeight = 144
  ClientWidth = 289
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 289
    Height = 144
    inherited BtnOK: TButton
      Left = 143
      Top = 111
      Caption = #30830#23450
      TabOrder = 2
    end
    inherited BtnExit: TButton
      Left = 213
      Top = 111
      TabOrder = 3
    end
    object EditIndex: TcxTextEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 0
      Width = 121
    end
    object EditSerial: TcxTextEdit [3]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.MaxLength = 4
      TabOrder = 1
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #21442#25968#20449#24687
        object dxLayout1Item3: TdxLayoutItem
          Caption = #22320#22336#32034#24341':'
          Control = EditIndex
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #35013#32622#32534#21495':'
          Control = EditSerial
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
