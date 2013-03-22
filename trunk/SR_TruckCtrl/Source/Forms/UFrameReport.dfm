inherited fFrameReport: TfFrameReport
  Width = 770
  Height = 459
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 770
    Height = 459
    Align = alClient
    BevelOuter = bvNone
    ParentColor = True
    TabOrder = 0
    object Panel1: TPanel
      Left = 0
      Top = 0
      Width = 770
      Height = 45
      Align = alTop
      BevelOuter = bvNone
      BorderWidth = 3
      ParentColor = True
      TabOrder = 0
      object Bevel1: TBevel
        Left = 3
        Top = 37
        Width = 764
        Height = 5
        Align = alBottom
        Shape = bsBottomLine
      end
      object BtnNext: TButton
        Left = 430
        Top = 9
        Width = 55
        Height = 25
        Caption = #19979#19968#39029'>>'
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = BtnNextClick
      end
      object cxLabel1: TcxLabel
        Left = 186
        Top = 15
        Caption = #26102#38388':'
        ParentFont = False
      end
      object EditTime: TcxDateEdit
        Left = 224
        Top = 12
        ParentFont = False
        Properties.Kind = ckDateTime
        Properties.OnEditValueChanged = EditTimePropertiesEditValueChanged
        TabOrder = 2
        OnKeyPress = EditTimeKeyPress
        Width = 150
      end
      object BtnPre: TButton
        Left = 375
        Top = 9
        Width = 55
        Height = 25
        Caption = '<<'#19978#19968#39029
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = BtnPreClick
      end
      object cxLabel2: TcxLabel
        Left = 5
        Top = 15
        Caption = #35774#22791':'
        ParentFont = False
      end
      object EditDevice: TcxCheckComboBox
        Left = 38
        Top = 12
        ParentFont = False
        Properties.DropDownRows = 25
        Properties.Items = <>
        TabOrder = 5
        Width = 135
      end
    end
    object wPage: TcxPageControl
      Left = 0
      Top = 45
      Width = 770
      Height = 414
      ActivePage = SheetBreakPipe
      Align = alClient
      LookAndFeel.Kind = lfStandard
      LookAndFeel.NativeStyle = True
      TabOrder = 1
      ClientRectBottom = 410
      ClientRectLeft = 2
      ClientRectRight = 766
      ClientRectTop = 22
      object SheetBreakPipe: TcxTabSheet
        Caption = #21046#21160#31649
        ImageIndex = 0
        object DBGrid1: TDBGrid
          Left = 0
          Top = 0
          Width = 764
          Height = 388
          Align = alClient
          BorderStyle = bsNone
          DataSource = DataSource1
          TabOrder = 0
          TitleFont.Charset = GB2312_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #23435#20307
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'P_Date'
              Title.Caption = #37319#38598#26102#38388
              Width = 125
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'C_Name'
              Title.Caption = #36710#21410
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'P_Value'
              Title.Caption = #25968#25454
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'P_Number'
              Title.Caption = #25968#25454#20010#25968
              Width = 100
              Visible = True
            end>
        end
      end
      object SheetBreakPot: TcxTabSheet
        Caption = #21046#21160#32568
        ImageIndex = 1
        object DBGrid2: TDBGrid
          Left = 0
          Top = 0
          Width = 764
          Height = 388
          Align = alClient
          BorderStyle = bsNone
          DataSource = DataSource2
          TabOrder = 0
          TitleFont.Charset = GB2312_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #23435#20307
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'P_Date'
              Title.Caption = #37319#38598#26102#38388
              Width = 125
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'C_Name'
              Title.Caption = #36710#21410
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'P_Value'
              Title.Caption = #25968#25454
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'P_Number'
              Title.Caption = #25968#25454#20010#25968
              Width = 100
              Visible = True
            end>
        end
      end
      object SheetTotalPipe: TcxTabSheet
        Caption = #24635#39118#31649
        ImageIndex = 2
        object DBGrid3: TDBGrid
          Left = 0
          Top = 0
          Width = 764
          Height = 388
          Align = alClient
          BorderStyle = bsNone
          DataSource = DataSource3
          TabOrder = 0
          TitleFont.Charset = GB2312_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -12
          TitleFont.Name = #23435#20307
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'P_Date'
              Title.Caption = #37319#38598#26102#38388
              Width = 125
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'C_Name'
              Title.Caption = #36710#21410
              Width = 100
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'P_Value'
              Title.Caption = #25968#25454
              Width = 100
              Visible = True
            end>
        end
      end
      object SheetChart: TcxTabSheet
        Caption = #26354#32447#22270
        ImageIndex = 3
        object Chart1: TChart
          Left = 0
          Top = 0
          Width = 764
          Height = 388
          BackWall.Brush.Color = clWhite
          BackWall.Brush.Style = bsClear
          Gradient.Direction = gdFromCenter
          Gradient.EndColor = 14280412
          Gradient.StartColor = clBlack
          MarginBottom = 2
          MarginLeft = 2
          MarginRight = 2
          MarginTop = 2
          Title.Text.Strings = (
            #31995#32479#36816#34892#30417#25511#26354#32447)
          BottomAxis.LabelStyle = talText
          LeftAxis.Title.Caption = #21387#21147#20540': '#21333#20301#21315#24085
          Legend.LegendStyle = lsSeries
          Legend.ShadowSize = 0
          Legend.TextStyle = ltsPlain
          View3D = False
          Align = alClient
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 0
          object CheckBreakPipe: TcxCheckBox
            Tag = 10
            Left = 2
            Top = 2
            Caption = #21046#21160#31649
            ParentFont = False
            State = cbsChecked
            TabOrder = 0
            Transparent = True
            OnClick = CheckBreakPipeClick
            Width = 65
          end
          object CheckTotalPipe: TcxCheckBox
            Tag = 30
            Left = 125
            Top = 2
            Caption = #24635#39118#31649
            ParentFont = False
            State = cbsChecked
            TabOrder = 1
            Transparent = True
            OnClick = CheckBreakPipeClick
            Width = 65
          end
          object CheckBreakPot: TcxCheckBox
            Tag = 20
            Left = 63
            Top = 2
            Caption = #21046#21160#32568
            ParentFont = False
            State = cbsChecked
            TabOrder = 2
            Transparent = True
            OnClick = CheckBreakPipeClick
            Width = 65
          end
        end
      end
    end
  end
  object TimerUI: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerUITimer
    Left = 20
    Top = 206
  end
  object QueryBreakPipe: TADOQuery
    Connection = FDM.ADOConn
    Parameters = <>
    Left = 20
    Top = 122
  end
  object QueryBreakPot: TADOQuery
    Connection = FDM.ADOConn
    Parameters = <>
    Left = 20
    Top = 150
  end
  object QueryTotalPipe: TADOQuery
    Connection = FDM.ADOConn
    Parameters = <>
    Left = 21
    Top = 178
  end
  object DataSource1: TDataSource
    AutoEdit = False
    DataSet = QueryBreakPipe
    Left = 48
    Top = 122
  end
  object DataSource2: TDataSource
    AutoEdit = False
    DataSet = QueryBreakPot
    Left = 48
    Top = 150
  end
  object DataSource3: TDataSource
    AutoEdit = False
    DataSet = QueryTotalPipe
    Left = 49
    Top = 178
  end
end
