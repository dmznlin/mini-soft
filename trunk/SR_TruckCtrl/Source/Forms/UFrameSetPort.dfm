inherited fFramePort: TfFramePort
  Width = 778
  Height = 180
  Font.Color = clBlack
  object Label1: TLabel
    Left = 10
    Top = 45
    Width = 54
    Height = 12
    Caption = #20018#21475#21517#31216':'
  end
  object Label2: TLabel
    Left = 10
    Top = 74
    Width = 54
    Height = 12
    Caption = #25152#22312#31471#21475':'
  end
  object Label3: TLabel
    Left = 10
    Top = 103
    Width = 54
    Height = 12
    Caption = #27874' '#29305' '#29575':'
  end
  object Label4: TLabel
    Left = 210
    Top = 74
    Width = 54
    Height = 12
    Caption = #25968' '#25454' '#20301':'
  end
  object Label5: TLabel
    Left = 210
    Top = 103
    Width = 54
    Height = 12
    Caption = #20572' '#27490' '#20301':'
  end
  object cxLabel1: TcxLabel
    Left = 0
    Top = 0
    Align = alTop
    AutoSize = False
    Caption = #20018#21475#20449#24687':'
    ParentFont = False
    Properties.Alignment.Vert = taVCenter
    Properties.LineOptions.Alignment = cxllaBottom
    Properties.LineOptions.OuterColor = clGreen
    Properties.LineOptions.Visible = True
    Height = 30
    Width = 778
    AnchorY = 15
  end
  object BtnAdd: TcxButton
    Left = 10
    Top = 132
    Width = 122
    Height = 35
    Caption = #28155#21152#20018#21475
    TabOrder = 1
    OnClick = BtnAddClick
  end
  object BtnEdit: TcxButton
    Left = 142
    Top = 132
    Width = 122
    Height = 35
    Caption = #20462#25913#20018#21475
    TabOrder = 2
    OnClick = BtnEditClick
  end
  object BtnDel: TcxButton
    Left = 268
    Top = 132
    Width = 122
    Height = 35
    Caption = #21024#38500#20018#21475
    TabOrder = 3
    OnClick = BtnDelClick
  end
  object EditName: TcxTextEdit
    Left = 68
    Top = 42
    ParentFont = False
    TabOrder = 4
    Width = 120
  end
  object EditPort: TcxTextEdit
    Left = 68
    Top = 71
    ParentFont = False
    TabOrder = 5
    Width = 120
  end
  object EditBaund: TcxTextEdit
    Left = 68
    Top = 100
    ParentFont = False
    TabOrder = 6
    Width = 120
  end
  object EditData: TcxTextEdit
    Left = 268
    Top = 71
    ParentFont = False
    TabOrder = 7
    Width = 120
  end
  object EditStop: TcxTextEdit
    Left = 268
    Top = 100
    ParentFont = False
    TabOrder = 8
    Width = 120
  end
  object cxGroupBox1: TcxGroupBox
    Left = 402
    Top = 30
    Caption = #21151#33021
    ParentFont = False
    TabOrder = 9
    Height = 135
    Width = 115
    object BtnAddDev: TcxButton
      Left = 12
      Top = 22
      Width = 85
      Height = 30
      Caption = #28155#21152#35774#22791
      TabOrder = 0
      OnClick = BtnAddDevClick
    end
  end
end
