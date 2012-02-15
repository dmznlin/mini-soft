object fFormScreen: TfFormScreen
  Left = 281
  Top = 168
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'fFormScreen'
  ClientHeight = 398
  ClientWidth = 620
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    620
    398)
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 10
    Top = 15
    Width = 66
    Height = 12
    Caption = #26174#31034#23631#21015#34920':'
  end
  object BtnAdd: TSpeedButton
    Left = 147
    Top = 104
    Width = 23
    Height = 22
    Caption = '+'
    Flat = True
    OnClick = BtnAddClick
  end
  object BtnDel: TSpeedButton
    Left = 147
    Top = 154
    Width = 23
    Height = 22
    Caption = '-'
    Flat = True
    OnClick = BtnDelClick
  end
  object ListBox1: TListBox
    Left = 10
    Top = 32
    Width = 135
    Height = 332
    Style = lbOwnerDrawFixed
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 17
    TabOrder = 0
    OnClick = ListBox1Click
  end
  object wPage: TPageControl
    Left = 171
    Top = 15
    Width = 436
    Height = 349
    ActivePage = TabSheet1
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #23631#24149#21442#25968
      DesignSize = (
        428
        322)
      object GroupBox1: TGroupBox
        Left = 12
        Top = 12
        Width = 405
        Height = 115
        Anchors = [akLeft, akTop, akRight]
        Caption = #22522#26412#20449#24687
        TabOrder = 0
        object Label2: TLabel
          Left = 212
          Top = 25
          Width = 54
          Height = 12
          Caption = #25511#21046#32452#20214':'
        end
        object Label3: TLabel
          Left = 10
          Top = 25
          Width = 54
          Height = 12
          Caption = #23631#24149#21517#31216':'
        end
        object Label6: TLabel
          Left = 10
          Top = 55
          Width = 54
          Height = 12
          Caption = #27178#21521#28857#25968':'
        end
        object Label7: TLabel
          Left = 212
          Top = 55
          Width = 54
          Height = 12
          Caption = #32437#21521#28857#25968':'
        end
        object Label8: TLabel
          Left = 10
          Top = 85
          Width = 54
          Height = 12
          Caption = #23631#24149#31867#22411':'
        end
        object EditCard: TComboBox
          Left = 270
          Top = 22
          Width = 125
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          TabOrder = 0
          OnChange = EditTypeChange
        end
        object EditName: TEdit
          Left = 68
          Top = 22
          Width = 120
          Height = 20
          TabOrder = 1
          Text = #26174#31034#23631
          OnChange = EditTypeChange
        end
        object EditX: TEdit
          Left = 68
          Top = 52
          Width = 120
          Height = 20
          TabOrder = 2
          Text = '0'
          OnChange = EditTypeChange
        end
        object EditY: TEdit
          Left = 270
          Top = 52
          Width = 125
          Height = 20
          TabOrder = 3
          Text = '0'
          OnChange = EditTypeChange
        end
        object EditType: TComboBox
          Left = 68
          Top = 82
          Width = 120
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          TabOrder = 4
          OnChange = EditTypeChange
          Items.Strings = (
            #21333#33394
            #21452#33394
            #20840#24425)
        end
      end
      object GroupBox2: TGroupBox
        Left = 12
        Top = 132
        Width = 405
        Height = 80
        Anchors = [akLeft, akTop, akRight]
        Caption = #36890#20449#35774#32622
        TabOrder = 1
        object Label4: TLabel
          Left = 10
          Top = 55
          Width = 54
          Height = 12
          Caption = #36830#25509#31471#21475':'
        end
        object Label5: TLabel
          Left = 212
          Top = 55
          Width = 54
          Height = 12
          Caption = #27604' '#29305' '#29575':'
        end
        object Label11: TLabel
          Left = 10
          Top = 25
          Width = 54
          Height = 12
          Caption = #36890#20449#27169#24335':'
        end
        object EditPort: TComboBox
          Left = 68
          Top = 52
          Width = 120
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          Sorted = True
          TabOrder = 0
          OnChange = EditTypeChange
        end
        object EditBote: TComboBox
          Left = 270
          Top = 52
          Width = 125
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          TabOrder = 1
          OnChange = EditTypeChange
          Items.Strings = (
            '1200'
            '2400'
            '4800'
            '9600'
            '19200'
            '38400'
            '57600')
        end
        object EditConn: TComboBox
          Left = 68
          Top = 22
          Width = 120
          Height = 20
          Style = csDropDownList
          ItemHeight = 12
          TabOrder = 2
          OnChange = EditConnChange
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #35774#22791#21015#34920
      ImageIndex = 1
      DesignSize = (
        428
        322)
      object Label9: TLabel
        Left = 12
        Top = 173
        Width = 42
        Height = 12
        Caption = #35774#22791#21495':'
      end
      object Label10: TLabel
        Left = 152
        Top = 173
        Width = 30
        Height = 12
        Caption = #21517#31216':'
      end
      object BtnAdd2: TSpeedButton
        Left = 370
        Top = 170
        Width = 23
        Height = 22
        Caption = '+'
        Flat = True
        OnClick = BtnAdd2Click
      end
      object BtnDel2: TSpeedButton
        Left = 394
        Top = 170
        Width = 23
        Height = 22
        Caption = '-'
        Flat = True
        OnClick = BtnDel2Click
      end
      object ListDevice: TListView
        Left = 12
        Top = 12
        Width = 405
        Height = 150
        Anchors = [akLeft, akTop, akRight]
        Columns = <
          item
            Caption = #35774#22791#21495
            Width = 75
          end
          item
            AutoSize = True
            Caption = #21517#31216
          end>
        HideSelection = False
        ReadOnly = True
        RowSelect = True
        TabOrder = 0
        ViewStyle = vsReport
      end
      object EditSID: TEdit
        Left = 58
        Top = 170
        Width = 65
        Height = 20
        TabOrder = 1
      end
      object EditSName: TEdit
        Left = 185
        Top = 170
        Width = 180
        Height = 20
        TabOrder = 2
      end
      object GroupBox3: TGroupBox
        Left = 12
        Top = 204
        Width = 405
        Height = 80
        Caption = #21516#27493#35774#22791
        TabOrder = 3
        object Check1: TCheckBox
          Left = 12
          Top = 22
          Width = 185
          Height = 17
          Caption = #33258#21160#36873#20013#19979#20010#35774#22791
          TabOrder = 0
        end
        object BtnSet: TBitBtn
          Left = 12
          Top = 45
          Width = 120
          Height = 25
          Caption = #26356#26032#35774#22791#32534#21495
          TabOrder = 1
          OnClick = BtnSetClick
          Glyph.Data = {
            36030000424D3603000000000000360000002800000010000000100000000100
            1800000000000003000000000000000000000000000000000000C0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C4A9984E2E1C4E2E1C4E2E1C4E2E
            1C4E2E1C4E2E1C4E2E1CC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C4A998EEE6E1E7DCD5E0D0C7D8C5BAD0BAADD0BAAD4E2E1CC0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C4A998006CB0006CB0006CB0006C
            B0006CB0D4BFB44E2E1CC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C4A998007FD444DAFF00CAFF00B4E9007FD4DCCBC14E2E1CC0C0C0C0C0C0
            C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C4A998BFEBFF007FD400CAFF007F
            D4BFEBFFE3D7CE4E2E1CC0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0C0
            C0C0C4A998FFFFFF0096F844DAFF007FD4F2EBE7EAE1DA4E2E1CC4A9984E2E1C
            4E2E1C4E2E1C4E2E1C4E2E1C4E2E1C4E2E1CC4A998FFFFFFBFEBFF007FD4BFEB
            FFC4A9984E2E1C4E2E1CC4A998EEE6E1E7DCD5E0D0C7D8C5BAD0BAADD0BAAD4E
            2E1CC4A998FFFFFFFFFFFFFFFFFFFFFFFFC4A998C4A998C0C0C0C4A998F6F0EE
            EEE6E1001198E0D0C7D8C5BAD4BFB44E2E1CC4A998C4A998C4A998C4A998801C
            00C4A998C0C0C0C0C0C0C4A998FCFBFA0011981138E0001198E3D7CEDCCBC14E
            2E1CC0C0C0C0C0C0C0C0C0801C00DC8F68801C00C0C0C0C0C0C0C4A9980B23D4
            4858E01138E01138E0001198E3D7CE4E2E1CC0C0C0C0C0C0801C00DC8F68C26D
            44A0431B801C00C0C0C0C4A998FFFFFF0B23D44858E0001198F2EBE7EAE1DA4E
            2E1CC0C0C0801C00A0431BC26D44C26D44C26D44A0431B801C00C4A998FFFFFF
            FFFFFF0B23D4FFFFFFF8F6F3F2EBE74E2E1CC0C0C0C0C0C0C0C0C0A0431BC26D
            44801C00C0C0C0C0C0C0C4A998FFFFFFFFFFFFFFFFFFFFFFFFC4A9984E2E1C4E
            2E1CC0C0C0C0C0C0C0C0C0A0431B801C00C0C0C0C0C0C0C0C0C0C4A998FFFFFF
            FFFFFFFFFFFFFFFFFFC4A998C4A998C0C0C0C0C0C0C0C0C0A0431BC26D44801C
            00C0C0C0C0C0C0C0C0C0C4A998C4A998C4A998C4A998C4A998C4A998C0C0C0A0
            431BA0431BA0431B801C00801C00C0C0C0C0C0C0C0C0C0C0C0C0}
        end
      end
    end
  end
  object BtnSave: TButton
    Left = 464
    Top = 367
    Width = 70
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #20445#23384
    TabOrder = 2
    OnClick = BtnSaveClick
  end
  object BtnExit: TButton
    Left = 537
    Top = 367
    Width = 70
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = #20851#38381
    TabOrder = 3
    OnClick = BtnExitClick
  end
end
