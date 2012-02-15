inherited fFormZTParam: TfFormZTParam
  Left = 271
  Top = 174
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 132
  ClientWidth = 260
  OldCreateOrder = True
  Position = poMainFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 260
    Height = 132
    Align = alClient
    TabOrder = 0
    TabStop = False
    LookAndFeel = FDM.dxLayoutWeb1
    object EditDesc: TcxTextEdit
      Left = 57
      Top = 61
      ParentFont = False
      Properties.OnChange = EditDescPropertiesChange
      TabOrder = 1
      Width = 121
    end
    object BtnExit: TButton
      Left = 176
      Top = 93
      Width = 65
      Height = 22
      Caption = #21462#28040
      ModalResult = 2
      TabOrder = 3
    end
    object BtnOK: TButton
      Left = 106
      Top = 93
      Width = 65
      Height = 22
      Caption = #20445#23384
      TabOrder = 2
      OnClick = BtnOKClick
    end
    object PortList1: TcxComboBox
      Left = 57
      Top = 36
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.OnChange = PortList1PropertiesChange
      TabOrder = 0
      Width = 172
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        Caption = #26632#21488#21442#25968
        object dxLayoutControl1Item1: TdxLayoutItem
          Caption = #31471#21475':'
          Control = PortList1
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item2: TdxLayoutItem
          Caption = #25551#36848':'
          Control = EditDesc
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Group2: TdxLayoutGroup
        ShowCaption = False
        Hidden = True
        LayoutDirection = ldHorizontal
        ShowBorder = False
        object dxLayoutControl1Item8: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahRight
          Caption = 'Button2'
          ShowCaption = False
          Control = BtnOK
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item7: TdxLayoutItem
          AutoAligns = []
          AlignHorz = ahRight
          AlignVert = avBottom
          Caption = 'Button1'
          ShowCaption = False
          Control = BtnExit
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
