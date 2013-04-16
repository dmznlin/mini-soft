inherited fFormSysParam: TfFormSysParam
  Left = 253
  Top = 248
  Caption = #31995#32479#21442#25968
  ClientHeight = 378
  ClientWidth = 343
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 343
    Height = 378
    inherited BtnOK: TButton
      Left = 197
      Top = 345
      Caption = #30830#23450
      TabOrder = 11
    end
    inherited BtnExit: TButton
      Left = 267
      Top = 345
      TabOrder = 12
    end
    object EditTrainID: TcxTextEdit [2]
      Left = 117
      Top = 36
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 0
      Width = 121
    end
    object EditUIInterval: TcxTextEdit [3]
      Left = 117
      Top = 138
      ParentFont = False
      Properties.CharCase = ecUpperCase
      Properties.MaxLength = 16
      TabOrder = 4
      Width = 121
    end
    object cxLabel1: TcxLabel [4]
      Left = 23
      Top = 111
      AutoSize = False
      Caption = #36816#34892#25968#25454#26609#22270#8595
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 22
      Width = 264
      AnchorY = 122
    end
    object EditQInterval: TcxTextEdit [5]
      Left = 117
      Top = 61
      ParentFont = False
      Properties.MaxLength = 4
      TabOrder = 1
      Width = 121
    end
    object EditUIMax: TcxTextEdit [6]
      Left = 117
      Top = 163
      ParentFont = False
      TabOrder = 5
      Width = 121
    end
    object EditChartCount: TcxTextEdit [7]
      Left = 117
      Top = 215
      ParentFont = False
      TabOrder = 7
      Width = 121
    end
    object EditPage: TcxTextEdit [8]
      Left = 117
      Top = 86
      ParentFont = False
      TabOrder = 2
      Width = 121
    end
    object CheckSend: TcxCheckBox [9]
      Left = 23
      Top = 265
      Caption = #36816#34892#26102#25968#25454':'#26174#31034#21457#36865
      ParentFont = False
      TabOrder = 9
      Transparent = True
      Width = 121
    end
    object CheckRecv: TcxCheckBox [10]
      Left = 23
      Top = 291
      Caption = #36816#34892#26102#25968#25454':'#26174#31034#25509#25910
      ParentFont = False
      TabOrder = 10
      Transparent = True
      Width = 121
    end
    object cxLabel2: TcxLabel [11]
      Left = 23
      Top = 188
      AutoSize = False
      Caption = #36816#34892#30417#25511#26354#32447#8595
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 22
      Width = 264
      AnchorY = 199
    end
    object EditChartTime: TcxTextEdit [12]
      Left = 117
      Top = 240
      ParentFont = False
      TabOrder = 8
      Width = 187
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #21442#25968#20449#24687
        object dxLayout1Item3: TdxLayoutItem
          Caption = #36710#36742#36710#27425#26631#35782':'
          Control = EditTrainID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #37319#38598#38388#38548'('#27627#31186'):'
          Control = EditQInterval
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #25253#34920#20998#39029'('#23567#26102'):'
          Control = EditPage
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #26609#22270#30456#37051#38388#36317':'
          Control = EditUIInterval
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #26609#22270#26174#31034#19978#38480':'
          Control = EditUIMax
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item12: TdxLayoutItem
          ShowCaption = False
          Control = cxLabel2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #26354#32447#28857#25968#19978#38480':'
          Control = EditChartCount
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item13: TdxLayoutItem
          Caption = #20445#25345#26102#38271'('#20998#38047'):'
          Control = EditChartTime
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item10: TdxLayoutItem
          Caption = 'cxCheckBox1'
          ShowCaption = False
          Control = CheckSend
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item11: TdxLayoutItem
          Caption = 'cxCheckBox2'
          ShowCaption = False
          Control = CheckRecv
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
