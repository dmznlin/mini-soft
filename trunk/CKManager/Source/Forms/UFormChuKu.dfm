inherited fFormChuKu: TfFormChuKu
  Left = 348
  Top = 346
  ClientHeight = 407
  ClientWidth = 380
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 380
    Height = 407
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 234
      Top = 374
      TabOrder = 4
    end
    inherited BtnExit: TButton
      Left = 304
      Top = 374
      TabOrder = 5
    end
    object InfoList1: TcxMCListBox [2]
      Left = 23
      Top = 182
      Width = 354
      Height = 122
      HeaderSections = <
        item
          Text = #29289#21697#21517#31216
          Width = 100
        end
        item
          Alignment = taCenter
          Text = #23384#25918#20179#20301
          Width = 60
        end
        item
          Alignment = taCenter
          Text = #24211#23384#25968#37327
          Width = 60
        end
        item
          Alignment = taCenter
          Text = #24453#20986#24211#37327
          Width = 60
        end>
      ParentFont = False
      Style.BorderStyle = cbsOffice11
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 3
    end
    object EditName: TcxLookupComboBox [3]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.ListColumns = <>
      Properties.OnEditValueChanged = EditNamePropertiesEditValueChanged
      TabOrder = 1
      Width = 145
    end
    object EditNum: TcxTextEdit [4]
      Left = 81
      Top = 86
      ParentFont = False
      TabOrder = 2
      OnExit = EditNumExit
      Width = 100
    end
    object EditBM: TcxLookupComboBox [5]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.ListColumns = <>
      TabOrder = 0
      Width = 145
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #39046#29992#37096#38376':'
          Control = EditBM
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group6: TdxLayoutGroup
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item10: TdxLayoutItem
            Caption = #29289#21697#21517#31216':'
            Control = EditName
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item13: TdxLayoutItem
            Caption = #39046#29992#25968#37327':'
            Control = EditNum
            ControlOptions.ShowBorder = False
          end
        end
      end
      object dxLayout1Group2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #24211#23384#28165#21333
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Control = InfoList1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
