inherited fFormSetDB: TfFormSetDB
  Left = 334
  Top = 237
  Caption = #37197#32622
  ClientHeight = 378
  ClientWidth = 365
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 365
    Height = 378
    inherited BtnOK: TButton
      Left = 219
      Top = 345
      TabOrder = 8
    end
    inherited BtnExit: TButton
      Left = 289
      Top = 345
      TabOrder = 9
    end
    object EditIP: TcxTextEdit [2]
      Left = 93
      Top = 36
      ParentFont = False
      TabOrder = 0
      Width = 121
    end
    object EditPort: TcxTextEdit [3]
      Left = 93
      Top = 61
      ParentFont = False
      TabOrder = 1
      Width = 121
    end
    object EditDB: TcxTextEdit [4]
      Left = 93
      Top = 86
      ParentFont = False
      TabOrder = 2
      Width = 121
    end
    object cxLabel1: TcxLabel [5]
      Left = 23
      Top = 111
      AutoSize = False
      ParentFont = False
      Properties.LineOptions.Visible = True
      Transparent = True
      Height = 16
      Width = 234
    end
    object EditUser: TcxTextEdit [6]
      Left = 93
      Top = 132
      ParentFont = False
      TabOrder = 4
      Width = 121
    end
    object EditPwd: TcxTextEdit [7]
      Left = 93
      Top = 157
      ParentFont = False
      Properties.PasswordChar = '*'
      TabOrder = 5
      Width = 121
    end
    object EditConn: TcxMemo [8]
      Left = 23
      Top = 200
      ParentFont = False
      Properties.ScrollBars = ssVertical
      TabOrder = 6
      Height = 100
      Width = 319
    end
    object BtnTest: TcxButton [9]
      Left = 23
      Top = 305
      Width = 75
      Height = 25
      Caption = #36830#25509#27979#35797
      TabOrder = 7
      OnClick = BtnTestClick
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #25968#25454#24211
        object dxLayout1Item3: TdxLayoutItem
          Caption = #26381#21153#22120#22320#22336':'
          Control = EditIP
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #26381#21153#22120#31471#21475':'
          Control = EditPort
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #25968#25454#24211#21517#31216':'
          Control = EditDB
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = 'cxLabel1'
          ShowCaption = False
          Control = cxLabel1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item7: TdxLayoutItem
          Caption = #30331#24405#29992#25143#21517':'
          Control = EditUser
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item8: TdxLayoutItem
          Caption = #30331#24405#23494#30721':'
          Control = EditPwd
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item9: TdxLayoutItem
          Caption = #36830#25509#23383#31526#20018':'
          CaptionOptions.Layout = clTop
          Control = EditConn
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item10: TdxLayoutItem
          AutoAligns = [aaVertical]
          Caption = 'cxButton1'
          ShowCaption = False
          Control = BtnTest
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
