object FDM: TFDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 594
  Top = 193
  Height = 150
  Width = 215
  object CPort1: TComPort
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
    Timeouts.ReadTotalConstant = 5
    Timeouts.WriteTotalMultiplier = 0
    Timeouts.WriteTotalConstant = 0
    SyncMethod = smWindowSync
    OnRxChar = CPort1RxChar
    Left = 12
    Top = 10
  end
end
