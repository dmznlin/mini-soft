object fFormMain: TfFormMain
  Left = 490
  Top = 362
  Width = 786
  Height = 485
  Caption = #21512#24182#40657#21517#21333
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
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
    Width = 778
    Height = 35
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 14
      Width = 102
      Height = 12
      Caption = '1.'#36873#25321#40657#21517#21333#25991#20214':'
    end
    object BtnApply: TButton
      Left = 472
      Top = 6
      Width = 75
      Height = 25
      Caption = '2.'#21512#24182
      TabOrder = 0
      OnClick = BtnApplyClick
    end
    object EditFile: TEdit
      Left = 112
      Top = 10
      Width = 321
      Height = 20
      ReadOnly = True
      TabOrder = 1
    end
    object BtnSelect: TButton
      Left = 438
      Top = 9
      Width = 20
      Height = 20
      Caption = '...'
      TabOrder = 2
      OnClick = BtnSelectClick
    end
    object BtnMake: TButton
      Left = 550
      Top = 6
      Width = 75
      Height = 25
      Caption = '3.'#29983#25104
      TabOrder = 3
      OnClick = BtnMakeClick
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 435
    Width = 778
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object ListBlack: TListView
    Left = 0
    Top = 35
    Width = 778
    Height = 400
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        Caption = #29992#25143#26631#35782
        Width = 220
      end
      item
        AutoSize = True
        Caption = #29992#25143#21517#31216
      end>
    ReadOnly = True
    RowSelect = True
    PopupMenu = PMenu1
    TabOrder = 2
    ViewStyle = vsReport
  end
  object IdHTTP1: TIdHTTP
    AllowCookies = True
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.Accept = 'text/html, */*'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    HTTPOptions = [hoForceEncodeParams]
    Left = 10
    Top = 68
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 16
    Top = 106
    object N1: TMenuItem
      Tag = 10
      Caption = #20840#37096#36873#20013
      OnClick = N1Click
    end
    object N2: TMenuItem
      Tag = 20
      Caption = #20840#37096#21462#28040
      OnClick = N1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Tag = 30
      Caption = #20840#37096#21453#36873
      OnClick = N1Click
    end
  end
end
