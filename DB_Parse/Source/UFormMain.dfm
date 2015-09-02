object fFormMain: TfFormMain
  Left = 591
  Top = 317
  Width = 778
  Height = 544
  Caption = 'SQL Server'#25968#25454#24211#20998#26512#24037#20855
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 770
    Height = 41
    Align = alTop
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 0
    object BtnConn: TButton
      Left = 14
      Top = 8
      Width = 75
      Height = 25
      Caption = '1.'#36830#25509
      TabOrder = 0
      OnClick = BtnConnClick
    end
    object BtnParse: TButton
      Left = 99
      Top = 8
      Width = 75
      Height = 25
      Caption = '2.'#20998#26512
      TabOrder = 1
      OnClick = BtnParseClick
    end
    object BtnSave: TButton
      Left = 184
      Top = 8
      Width = 75
      Height = 25
      Caption = '3.'#20445#23384
      TabOrder = 2
      OnClick = BtnSaveClick
    end
    object BtnEnum: TButton
      Left = 336
      Top = 8
      Width = 75
      Height = 25
      Caption = '*.'#26816#32034
      TabOrder = 3
      OnClick = BtnEnumClick
    end
  end
  object MemoSQL: TMemo
    Left = 0
    Top = 41
    Width = 770
    Height = 457
    Align = alClient
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object stat1: TStatusBar
    Left = 0
    Top = 498
    Width = 770
    Height = 19
    Panels = <>
  end
  object ADOConnection1: TADOConnection
    LoginPrompt = False
    Left = 594
    Top = 6
  end
  object Query1: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 622
    Top = 6
  end
end
