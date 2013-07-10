inherited fFormCard: TfFormCard
  Left = 409
  Top = 437
  Caption = #30913#21345
  ClientHeight = 190
  ClientWidth = 388
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 120
  TextHeight = 15
  inherited dxLayout1: TdxLayoutControl
    Width = 388
    Height = 190
    inherited BtnOK: TButton
      Left = 206
      Top = 148
      Caption = #30830#23450
      TabOrder = 3
    end
    inherited BtnExit: TButton
      Left = 293
      Top = 148
      TabOrder = 4
    end
    object EditTruck: TcxTextEdit [2]
      Left = 87
      Top = 45
      ParentFont = False
      Properties.ReadOnly = True
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 152
    end
    object cxLabel1: TcxLabel [3]
      Left = 29
      Top = 70
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 25
      Width = 359
    end
    object EditCard: TcxTextEdit [4]
      Left = 87
      Top = 100
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 2
      OnKeyPress = EditCardKeyPress
      Width = 152
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = ''
        object dxLayout1Item4: TdxLayoutItem
          Caption = #36710#33337#21495#30721':'
          Control = EditTruck
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #30913#21345#32534#21495':'
          Control = EditCard
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object ComPort1: TComPort
    BaudRate = br9600
    Port = 'COM1'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    Timeouts.ReadTotalMultiplier = 10
    Timeouts.ReadTotalConstant = 100
    OnRxChar = ComPort1RxChar
    Left = 24
    Top = 80
  end
end
