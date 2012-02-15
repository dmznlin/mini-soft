object FDM: TFDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 344
  Top = 139
  Height = 121
  Width = 301
  object ROChannel1: TROWinInetHTTPChannel
    UserAgent = 'RemObjects SDK'
    TrustInvalidCA = False
    ServerLocators = <>
    DispatchOptions = []
    Left = 24
    Top = 24
  end
  object ROBin1: TROBinMessage
    Envelopes = <>
    Left = 80
    Top = 24
  end
end
