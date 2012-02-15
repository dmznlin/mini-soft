object FDM: TFDM
  OldCreateOrder = False
  Left = 270
  Top = 133
  Height = 250
  Width = 309
  object ADOConn: TADOConnection
    LoginPrompt = False
    Left = 22
    Top = 14
  end
  object SQLQuery: TADOQuery
    Connection = ADOConn
    Parameters = <>
    Left = 22
    Top = 62
  end
  object SQLTemp: TADOQuery
    Connection = ADOConn
    Parameters = <>
    Left = 26
    Top = 120
  end
  object Command: TADOQuery
    Connection = ADOConn
    Parameters = <>
    Left = 84
    Top = 120
  end
  object DataSource1: TDataSource
    DataSet = SQLQuery
    Left = 88
    Top = 64
  end
end
