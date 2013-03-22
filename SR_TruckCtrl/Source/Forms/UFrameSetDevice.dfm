inherited fFrameDevice: TfFrameDevice
  Width = 790
  Height = 180
  Font.Color = clBlack
  object Label1: TLabel
    Left = 10
    Top = 74
    Width = 54
    Height = 12
    Caption = #20018#21475#21517#31216':'
  end
  object Label2: TLabel
    Left = 10
    Top = 103
    Width = 54
    Height = 12
    Caption = #22320#22336#32034#24341':'
  end
  object Label3: TLabel
    Left = 210
    Top = 45
    Width = 54
    Height = 12
    Caption = #35013#32622#32534#21495':'
  end
  object Label4: TLabel
    Left = 210
    Top = 74
    Width = 54
    Height = 12
    Caption = #36710#21410#21517#31216':'
  end
  object Label5: TLabel
    Left = 210
    Top = 103
    Width = 54
    Height = 12
    Caption = #36710#21410#31867#22411':'
  end
  object Label6: TLabel
    Left = 10
    Top = 45
    Width = 54
    Height = 12
    Caption = #25152#22312#20018#21475':'
  end
  object cxLabel1: TcxLabel
    Left = 0
    Top = 0
    Align = alTop
    AutoSize = False
    Caption = #35774#22791#20449#24687':'
    ParentFont = False
    Properties.Alignment.Vert = taVCenter
    Properties.LineOptions.Alignment = cxllaBottom
    Properties.LineOptions.OuterColor = clGreen
    Properties.LineOptions.Visible = True
    Height = 30
    Width = 790
    AnchorY = 15
  end
  object BtnAdd: TcxButton
    Left = 10
    Top = 132
    Width = 122
    Height = 35
    Caption = #28155#21152#35774#22791
    TabOrder = 1
    OnClick = BtnAddClick
  end
  object BtnEdit: TcxButton
    Left = 142
    Top = 132
    Width = 122
    Height = 35
    Caption = #20462#25913#35774#22791
    TabOrder = 2
    OnClick = BtnEditClick
  end
  object BtnDel: TcxButton
    Left = 268
    Top = 132
    Width = 122
    Height = 35
    Caption = #21024#38500#35774#22791
    TabOrder = 3
    OnClick = BtnDelClick
  end
  object EditName: TcxTextEdit
    Left = 68
    Top = 71
    ParentFont = False
    TabOrder = 4
    Width = 120
  end
  object EditIndex: TcxTextEdit
    Left = 68
    Top = 100
    ParentFont = False
    TabOrder = 5
    Width = 120
  end
  object EditSerial: TcxTextEdit
    Left = 268
    Top = 42
    ParentFont = False
    TabOrder = 6
    Width = 120
  end
  object EditCarriage: TcxTextEdit
    Left = 268
    Top = 71
    ParentFont = False
    TabOrder = 7
    Width = 120
  end
  object EditCarType: TcxTextEdit
    Left = 268
    Top = 100
    ParentFont = False
    TabOrder = 8
    Width = 120
  end
  object EditPort: TcxTextEdit
    Left = 68
    Top = 42
    ParentFont = False
    TabOrder = 9
    Width = 120
  end
  object GroupBreakPipe: TcxGroupBox
    Left = 400
    Top = 42
    Caption = #21046#21160#31649
    ParentFont = False
    TabOrder = 10
    Height = 60
    Width = 185
    object BtnBreakPipeMin: TcxButton
      Tag = 10
      Left = 12
      Top = 22
      Width = 75
      Height = 25
      Caption = #21387#21147#38646#28857
      TabOrder = 0
      OnClick = BtnBreakPipeMinClick
    end
    object BtnBtnBreakPipeMax: TcxButton
      Tag = 10
      Left = 100
      Top = 22
      Width = 75
      Height = 25
      Caption = #21387#21147#28385#24230
      TabOrder = 1
      OnClick = BtnBtnBreakPipeMaxClick
    end
  end
  object GroupBreakPot: TcxGroupBox
    Left = 402
    Top = 107
    Caption = #21046#21160#32568
    ParentFont = False
    TabOrder = 11
    Height = 60
    Width = 185
    object BtnBreakPotMin: TcxButton
      Tag = 20
      Left = 12
      Top = 22
      Width = 75
      Height = 25
      Caption = #21387#21147#38646#28857
      TabOrder = 0
      OnClick = BtnBreakPipeMinClick
    end
    object BtnBreakPotMax: TcxButton
      Tag = 20
      Left = 100
      Top = 22
      Width = 75
      Height = 25
      Caption = #21387#21147#28385#24230
      TabOrder = 1
      OnClick = BtnBtnBreakPipeMaxClick
    end
  end
  object GroupTotalPipe: TcxGroupBox
    Left = 590
    Top = 42
    Caption = #24635#39118#31649
    ParentFont = False
    TabOrder = 12
    Height = 60
    Width = 185
    object BtnTotalPipeMin: TcxButton
      Tag = 30
      Left = 12
      Top = 22
      Width = 75
      Height = 25
      Caption = #21387#21147#38646#28857
      TabOrder = 0
      OnClick = BtnBreakPipeMinClick
    end
    object BtnTotalPipeMax: TcxButton
      Tag = 30
      Left = 100
      Top = 22
      Width = 75
      Height = 25
      Caption = #21387#21147#28385#24230
      TabOrder = 1
      OnClick = BtnBtnBreakPipeMaxClick
    end
  end
  object GroupOther: TcxGroupBox
    Left = 592
    Top = 107
    Caption = #20854#23427#21151#33021
    ParentFont = False
    TabOrder = 13
    Height = 60
    Width = 185
    object BtnLocate: TcxButton
      Tag = 30
      Left = 12
      Top = 22
      Width = 75
      Height = 25
      Caption = #35013#32622#23450#20301
      TabOrder = 0
      OnClick = BtnLocateClick
    end
  end
end
