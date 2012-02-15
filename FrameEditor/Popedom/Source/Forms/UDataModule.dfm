object FDM: TFDM
  OldCreateOrder = False
  Left = 351
  Top = 445
  Height = 227
  Width = 263
  object ADOConn: TADOConnection
    Left = 35
    Top = 25
  end
  object SQLQuery: TADOQuery
    Connection = ADOConn
    Parameters = <>
    Left = 35
    Top = 85
  end
  object Command: TADOQuery
    Connection = ADOConn
    Parameters = <>
    Left = 95
    Top = 85
  end
end
