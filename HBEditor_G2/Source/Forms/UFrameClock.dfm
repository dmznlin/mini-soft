inherited fFrameClock: TfFrameClock
  Width = 1137
  inherited Group1: TGroupBox
    TabOrder = 1
  end
  object Group2: TGroupBox
    Left = 245
    Top = 12
    Width = 510
    Height = 137
    Caption = #34920#30424#23646#24615
    TabOrder = 0
    object Bevel1: TBevel
      Left = 400
      Top = 46
      Width = 80
      Height = 80
    end
    object BtnOpen: TSpeedButton
      Left = 400
      Top = 25
      Width = 80
      Height = 22
      Caption = #34920#30424#25991#20214
      Flat = True
      Glyph.Data = {
        36040000424D3604000000000000360000002800000010000000100000000100
        2000000000000004000000000000000000000000000000000000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF003399
        CC00006699000066990000669900006699000066990000669900006699000066
        9900006699000066990066CCCC00FF00FF00FF00FF00FF00FF003399CC003399
        CC0099FFFF0066CCFF0066CCFF0066CCFF0066CCFF0066CCFF0066CCFF0066CC
        FF0066CCFF003399CC0000669900FF00FF00FF00FF00FF00FF003399CC003399
        CC0066CCFF0099FFFF0099FFFF0099FFFF0099FFFF0099FFFF0099FFFF0099FF
        FF0099FFFF0066CCFF00006699003399CC00FF00FF00FF00FF003399CC003399
        CC0066CCFF0099FFFF0099FFFF0099FFFF0099FFFF0099FFFF0099FFFF0099FF
        FF0099FFFF0066CCFF0066CCCC0000669900FF00FF00FF00FF003399CC0066CC
        FF003399CC0099FFFF0099FFFF0099FFFF0099FFFF0099FFFF0099FFFF0099FF
        FF0099FFFF0066CCFF0099FFFF00006699003399CC00FF00FF003399CC0066CC
        FF0066CCCC0066CCCC0099FFFF0099FFFF0099FFFF0099FFFF0099FFFF0099FF
        FF0099FFFF0066CCFF0099FFFF0066CCCC0000669900FF00FF003399CC0099FF
        FF0066CCFF003399CC00CCFFFF00CCFFFF00CCFFFF00CCFFFF00CCFFFF00CCFF
        FF00CCFFFF0099FFFF00CCFFFF00CCFFFF0000669900FF00FF003399CC0099FF
        FF0099FFFF0066CCFF003399CC003399CC003399CC003399CC003399CC003399
        CC003399CC003399CC003399CC003399CC0066CCFF00FF00FF003399CC00CCFF
        FF0099FFFF0099FFFF0099FFFF0099FFFF00CCFFFF00CCFFFF00CCFFFF00CCFF
        FF00CCFFFF0000669900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF003399
        CC00CCFFFF00CCFFFF00CCFFFF00CCFFFF003399CC003399CC003399CC003399
        CC003399CC00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF003399CC003399CC003399CC003399CC00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00993300009933000099330000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF009933000099330000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF009933
        0000FF00FF00FF00FF00FF00FF0099330000FF00FF0099330000FF00FF00FF00
        FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
        FF00993300009933000099330000FF00FF00FF00FF00FF00FF00}
      OnClick = BtnOpenClick
    end
    object Label3: TLabel
      Left = 180
      Top = 35
      Width = 54
      Height = 12
      Caption = #26102#38024#39068#33394':'
    end
    object Label1: TLabel
      Left = 180
      Top = 64
      Width = 54
      Height = 12
      Caption = #20998#38024#39068#33394':'
    end
    object Label2: TLabel
      Left = 180
      Top = 93
      Width = 54
      Height = 12
      Caption = #31186#38024#39068#33394':'
    end
    object Image1: TImage
      Left = 400
      Top = 46
      Width = 80
      Height = 80
      Center = True
      Proportional = True
    end
    object ListColorH: TComboBox
      Left = 235
      Top = 32
      Width = 73
      Height = 19
      Style = csOwnerDrawFixed
      DropDownCount = 12
      ItemHeight = 13
      TabOrder = 0
      OnChange = ListColorHChange
      OnDrawItem = ListColorHDrawItem
    end
    object ListColorM: TComboBox
      Left = 235
      Top = 61
      Width = 73
      Height = 19
      Style = csOwnerDrawFixed
      DropDownCount = 12
      ItemHeight = 13
      TabOrder = 1
      OnChange = ListColorHChange
      OnDrawItem = ListColorHDrawItem
    end
    object ListColorS: TComboBox
      Left = 235
      Top = 90
      Width = 73
      Height = 19
      Style = csOwnerDrawFixed
      DropDownCount = 12
      ItemHeight = 13
      TabOrder = 2
      OnChange = ListColorHChange
      OnDrawItem = ListColorHDrawItem
    end
    object EditOX: TLabeledEdit
      Left = 65
      Top = 32
      Width = 73
      Height = 20
      EditLabel.Width = 42
      EditLabel.Height = 12
      EditLabel.Caption = #22352#26631'_X:'
      LabelPosition = lpLeft
      MaxLength = 5
      TabOrder = 3
      OnChange = EditOXChange
      OnExit = Edit_XExit
      OnKeyPress = Edit_XKeyPress
    end
    object EditOY: TLabeledEdit
      Left = 65
      Top = 61
      Width = 73
      Height = 20
      EditLabel.Width = 42
      EditLabel.Height = 12
      EditLabel.Caption = #22352#26631'_Y:'
      LabelPosition = lpLeft
      MaxLength = 5
      TabOrder = 4
      OnChange = EditOXChange
      OnExit = Edit_XExit
      OnKeyPress = Edit_XKeyPress
    end
    object CheckAuto: TCheckBox
      Left = 20
      Top = 90
      Width = 97
      Height = 17
      Caption = #33258#21160#23450#20301
      TabOrder = 5
      OnClick = CheckAutoClick
    end
  end
  object OpenDialog1: TOpenDialog
    Filter = '11|*.bmp;*.aa|22|*.aaa'
    Left = 162
    Top = 16
  end
end
