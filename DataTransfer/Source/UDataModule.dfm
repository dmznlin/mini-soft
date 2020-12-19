object FDM: TFDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Left = 475
  Top = 119
  Height = 121
  Width = 301
  object ADOConn1: TADOConnection
    LoginPrompt = False
    Left = 72
    Top = 8
  end
  object IdServer: TIdTCPServer
    Bindings = <>
    DefaultPort = 0
    OnExecute = IdServerExecute
    Left = 16
    Top = 8
  end
end
