object fFrameSummary: TfFrameSummary
  Left = 0
  Top = 0
  Width = 711
  Height = 175
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  ParentFont = False
  TabOrder = 0
  object GroupBox1: TGroupBox
    Left = 12
    Top = 12
    Width = 285
    Height = 137
    Caption = #22522#26412#20449#24687
    TabOrder = 0
    object Label1: TLabel
      Left = 10
      Top = 25
      Width = 54
      Height = 12
      Alignment = taRightJustify
      Caption = #23631#24149#21517#31216':'
    end
    object Label2: TLabel
      Left = 10
      Top = 77
      Width = 54
      Height = 12
      Alignment = taRightJustify
      Caption = #21345' '#31867' '#22411':'
    end
    object Label3: TLabel
      Left = 138
      Top = 51
      Width = 54
      Height = 12
      Alignment = taRightJustify
      Caption = #23631#24149#28857#25968':'
    end
    object Label4: TLabel
      Left = 10
      Top = 51
      Width = 54
      Height = 12
      Alignment = taRightJustify
      Caption = #23631#24149#31867#22411':'
    end
    object Label5: TLabel
      Left = 10
      Top = 103
      Width = 54
      Height = 12
      Alignment = taRightJustify
      Caption = #36890#20449#31471#21475':'
    end
    object Label6: TLabel
      Left = 150
      Top = 103
      Width = 42
      Height = 12
      Alignment = taRightJustify
      Caption = #27874#29305#29575':'
    end
    object Edit1: TEdit
      Left = 65
      Top = 22
      Width = 205
      Height = 20
      ReadOnly = True
      TabOrder = 0
    end
    object Edit4: TEdit
      Left = 65
      Top = 74
      Width = 60
      Height = 20
      ReadOnly = True
      TabOrder = 3
    end
    object Edit3: TEdit
      Left = 195
      Top = 48
      Width = 75
      Height = 20
      ReadOnly = True
      TabOrder = 2
    end
    object Edit2: TEdit
      Left = 65
      Top = 48
      Width = 60
      Height = 20
      ReadOnly = True
      TabOrder = 1
    end
    object Edit5: TEdit
      Left = 65
      Top = 100
      Width = 60
      Height = 20
      ReadOnly = True
      TabOrder = 4
    end
    object Edit6: TEdit
      Left = 195
      Top = 100
      Width = 75
      Height = 20
      ReadOnly = True
      TabOrder = 5
    end
  end
  object GroupBox2: TGroupBox
    Left = 310
    Top = 12
    Width = 285
    Height = 137
    Caption = #35774#22791#21015#34920
    TabOrder = 1
    object ListBox1: TListBox
      Left = 10
      Top = 20
      Width = 265
      Height = 100
      Style = lbOwnerDrawFixed
      ItemHeight = 16
      TabOrder = 0
      OnExit = ListBox1Exit
    end
  end
end
