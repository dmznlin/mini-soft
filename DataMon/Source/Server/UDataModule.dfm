object FDM: TFDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 826
  Top = 448
  Height = 190
  Width = 328
  object LocalConn: TADOConnection
    LoginPrompt = False
    Left = 16
    Top = 12
  end
  object SQLQuery: TADOQuery
    Connection = LocalConn
    Parameters = <>
    Left = 70
    Top = 12
  end
  object SQLCmd: TADOQuery
    Connection = LocalConn
    Parameters = <>
    Left = 124
    Top = 12
  end
  object ROSvr1: TROIndyHTTPServer
    Dispatchers = <
      item
        Name = 'ROBin1'
        Message = ROBin1
        Enabled = True
        PathInfo = 'Bin'
      end>
    IndyServer.Bindings = <>
    IndyServer.DefaultPort = 8099
    Port = 8099
    Left = 16
    Top = 78
  end
  object ROBin1: TROBinMessage
    Envelopes = <>
    Left = 70
    Top = 78
  end
end
