inherited fFormPressMax: TfFormPressMax
  Left = 253
  Top = 248
  Caption = #21387#21147#28385#24230
  ClientWidth = 294
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 294
    object Bevel1: TBevel [0]
      Left = 23
      Top = 36
      Width = 255
      Height = 7
      Shape = bsSpacer
    end
    inherited BtnOK: TButton
      Left = 148
      Caption = #30830#23450
      TabOrder = 1
    end
    inherited BtnExit: TButton
      Left = 218
      TabOrder = 2
    end
    object EditValue: TcxTextEdit [3]
      Left = 69
      Top = 48
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 0
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #35831#22635#20889#21387#21147#28385#24230#20540':'
        object dxLayout1Item4: TdxLayoutItem
          Control = Bevel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          Caption = #21387#21147#20540':'
          Control = EditValue
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
