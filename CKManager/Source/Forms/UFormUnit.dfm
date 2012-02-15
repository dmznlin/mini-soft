inherited fFormUnit: TfFormUnit
  Left = 354
  Top = 507
  ClientHeight = 136
  ClientWidth = 337
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 337
    Height = 136
    inherited BtnOK: TButton
      Left = 191
      Top = 103
      TabOrder = 2
    end
    inherited BtnExit: TButton
      Left = 261
      Top = 103
      TabOrder = 3
    end
    object EditName: TcxTextEdit [2]
      Left = 57
      Top = 61
      Hint = 'T.U_Name'
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 1
      Width = 403
    end
    object EditType: TcxComboBox [3]
      Left = 57
      Top = 36
      Hint = 'T.U_Type'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.DropDownRows = 16
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.ItemHeight = 18
      Properties.Items.Strings = (
        'C=C'#12289#26448#36136
        'D=D'#12289#21333#20301
        'G=G'#12289#35268#26684)
      Properties.MaxLength = 35
      TabOrder = 0
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = ''
        object dxLayout1Item13: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #31867#22411':'
          Control = EditType
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
