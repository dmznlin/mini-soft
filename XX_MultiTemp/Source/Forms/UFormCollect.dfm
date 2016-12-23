inherited fFormCollect: TfFormCollect
  Left = 695
  Top = 383
  ClientHeight = 359
  ClientWidth = 333
  FormStyle = fsStayOnTop
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 333
    Height = 359
    inherited BtnOK: TButton
      Left = 187
      Top = 326
      TabOrder = 8
    end
    inherited BtnExit: TButton
      Left = 257
      Top = 326
      Caption = #20851#38381
      TabOrder = 9
    end
    object LabelNum: TcxLabel [2]
      Left = 23
      Top = 36
      AutoSize = False
      Caption = '0'
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clBlack
      Style.Font.Height = -48
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.IsFontAssigned = True
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Height = 55
      Width = 262
      AnchorX = 154
      AnchorY = 64
    end
    object EditBaud: TcxComboBox [3]
      Left = 81
      Top = 153
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.ItemHeight = 20
      TabOrder = 2
      Width = 121
    end
    object EditData: TcxComboBox [4]
      Left = 81
      Top = 178
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.ItemHeight = 20
      TabOrder = 3
      Width = 219
    end
    object EditVerify: TcxComboBox [5]
      Left = 81
      Top = 228
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.ItemHeight = 20
      TabOrder = 5
      Width = 219
    end
    object EditStop: TcxComboBox [6]
      Left = 81
      Top = 203
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.ItemHeight = 20
      TabOrder = 4
      Width = 219
    end
    object Check1: TcxCheckBox [7]
      Left = 11
      Top = 326
      Caption = #20462#25913#37197#32622
      ParentFont = False
      TabOrder = 7
      Transparent = True
      OnClick = Check1Click
      Width = 121
    end
    object EditPort: TcxComboBox [8]
      Left = 81
      Top = 128
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 20
      Properties.ImmediateDropDown = False
      Properties.ItemHeight = 20
      TabOrder = 1
      Width = 213
    end
    object EditLog: TcxMemo [9]
      Left = 81
      Top = 253
      Properties.ReadOnly = True
      Properties.ScrollBars = ssVertical
      TabOrder = 6
      Height = 55
      Width = 229
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #37319#38598#32479#35745
        object dxLayout1Item3: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = LabelNum
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #31471#21475#37197#32622
        object dxLayout1Item10: TdxLayoutItem
          Caption = #36890#35759#31471#21475':'
          Control = EditPort
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #27874' '#29305' '#29575':'
          Control = EditBaud
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #25968' '#25454' '#20301':'
          Control = EditData
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #21551' '#20572' '#20301':'
          Control = EditStop
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #26657' '#39564' '#20301':'
          Control = EditVerify
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #26085#24535#25551#36848':'
          Control = EditLog
          ControlOptions.ShowBorder = False
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxLayout1Item9: TdxLayoutItem [0]
          AutoAligns = [aaVertical]
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = Check1
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
    OnAfterOpen = ComPort1AfterOpen
    OnAfterClose = ComPort1AfterClose
    OnRxChar = ComPort1RxChar
    Left = 18
    Top = 36
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 46
    Top = 36
  end
  object TimerDelay: TTimer
    OnTimer = TimerDelayTimer
    Left = 74
    Top = 36
  end
end
