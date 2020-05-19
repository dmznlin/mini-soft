object fFormMain: TfFormMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #24494#20449#22270#29255' -  '#33258#21160#35299#30721
  ClientHeight = 298
  ClientWidth = 392
  Color = clBtnFace
  Constraints.MinHeight = 325
  Constraints.MinWidth = 400
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesigned
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object wPage: TPageControl
    Left = 0
    Top = 0
    Width = 392
    Height = 298
    ActivePage = SheetDecode
    Align = alClient
    Style = tsFlatButtons
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #33258#21160#35299#30721
      ImageIndex = 2
      object MemoLog: TMemo
        Left = 0
        Top = 0
        Width = 384
        Height = 267
        Align = alClient
        Lines.Strings = (
          'MemoLog')
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object SheetDecode: TTabSheet
      Caption = #25163#21160#35299#30721
      object ListFile: TListBox
        Left = 0
        Top = 0
        Width = 384
        Height = 235
        Style = lbOwnerDrawFixed
        Align = alClient
        ItemHeight = 18
        TabOrder = 0
      end
      object Panel1: TPanel
        Left = 0
        Top = 235
        Width = 384
        Height = 32
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        object BtnDecode: TButton
          Left = 100
          Top = 6
          Width = 75
          Height = 25
          Caption = #35299#30721
          TabOrder = 0
          OnClick = BtnDecodeClick
        end
        object BtnClear: TButton
          Left = 11
          Top = 6
          Width = 75
          Height = 25
          Caption = #28165#31354
          TabOrder = 1
          OnClick = BtnClearClick
        end
      end
    end
    object SheetSet: TTabSheet
      Caption = #21442#25968#35774#32622
      ImageIndex = 1
      DesignSize = (
        384
        267)
      object GroupBox1: TGroupBox
        Left = 3
        Top = 110
        Width = 378
        Height = 150
        Anchors = [akLeft, akTop, akRight]
        Caption = #22270#29255#35774#32622
        TabOrder = 0
        DesignSize = (
          378
          150)
        object EditSrc: TLabeledEdit
          Left = 12
          Top = 80
          Width = 355
          Height = 20
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 78
          EditLabel.Height = 12
          EditLabel.Caption = #24494#20449#22270#29255#20301#32622':'
          TabOrder = 0
          OnChange = EditKeysChange
        end
        object EditDest: TLabeledEdit
          Left = 12
          Top = 120
          Width = 355
          Height = 20
          Anchors = [akLeft, akTop, akRight]
          EditLabel.Width = 78
          EditLabel.Height = 12
          EditLabel.Caption = #35299#30721#21518#20445#23384#22312':'
          TabOrder = 1
          OnChange = EditKeysChange
        end
        object EditTime: TLabeledEdit
          Left = 12
          Top = 40
          Width = 125
          Height = 20
          EditLabel.Width = 96
          EditLabel.Height = 12
          EditLabel.Caption = #26368#36817'n'#20998#38047#20869#26377#25928':'
          ParentShowHint = False
          ShowHint = False
          TabOrder = 2
          Text = '1'
          OnChange = EditKeysChange
        end
      end
      object GroupBox2: TGroupBox
        Left = 3
        Top = 3
        Width = 378
        Height = 100
        Anchors = [akLeft, akTop, akRight]
        Caption = #22522#26412#35774#32622
        TabOrder = 1
        object CheckAuto: TCheckBox
          Left = 12
          Top = 25
          Width = 120
          Height = 17
          Caption = #24320#26426#21518#33258#21160#21551#21160
          TabOrder = 0
          OnClick = EditKeysChange
        end
        object EditKeys: TLabeledEdit
          Left = 12
          Top = 65
          Width = 125
          Height = 20
          CharCase = ecUpperCase
          EditLabel.Width = 66
          EditLabel.Height = 12
          EditLabel.Caption = #35299#30721#24555#25463#38190':'
          ParentShowHint = False
          ShowHint = False
          TabOrder = 1
          Text = 'CTRL + ALT + F'
          OnChange = EditKeysChange
        end
        object CheckOpen: TCheckBox
          Left = 163
          Top = 25
          Width = 132
          Height = 17
          Caption = #35299#30721#23436#25104#21518#25171#24320#30446#24405
          TabOrder = 2
          OnClick = EditKeysChange
        end
        object EditHide: TLabeledEdit
          Left = 163
          Top = 65
          Width = 125
          Height = 20
          CharCase = ecUpperCase
          EditLabel.Width = 90
          EditLabel.Height = 12
          EditLabel.Caption = #26174#31034#38544#34255#35813#31383#21475':'
          ParentShowHint = False
          ShowHint = False
          TabOrder = 3
          Text = 'CTRL + ALT + Y'
          OnChange = EditKeysChange
        end
      end
    end
  end
  object HotKey1: THotKeyManager
    OnHotKeyPressed = HotKey1HotKeyPressed
    Left = 320
    Top = 64
  end
end
