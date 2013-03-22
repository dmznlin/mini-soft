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
        Left = 608
        Top = 10
        Width = 62
        Height = 27
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
        Left = 280
        Top = 14
        Caption = #26102#38388':'
        ParentFont = False
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clGreen
        Style.Font.Height = -16
        Style.Font.Name = #23435#20307
        Style.Font.Style = []
        Style.IsFontAssigned = True
      end
      object EditTime: TcxDateEdit
        Left = 325
        Top = 10
        ParentFont = False
        Properties.Kind = ckDateTime
        Properties.OnEditValueChanged = EditTimePropertiesEditValueChanged
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clGreen
        Style.Font.Height = -19
        Style.Font.Name = #23435#20307
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 2
        OnKeyPress = EditTimeKeyPress
        Width = 220
      end
      object BtnPre: TButton
        Left = 545
        Top = 10
        Width = 62
        Height = 27
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
        Top = 14
        Caption = #35774#22791':'
        ParentFont = False
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clGreen
        Style.Font.Height = -16
        Style.Font.Name = #23435#20307
        Style.Font.Style = []
        Style.IsFontAssigned = True
      end
      object EditDevice: TcxCheckComboBox
        Left = 50
        Top = 10
        ParentFont = False
        Properties.EmptySelectionText = #35831#36873#25321
        Properties.ShowEmptyText = False
        Properties.DropDownRows = 25
        Properties.Items = <>
        Properties.OnCloseUp = EditDevicePropertiesCloseUp
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clGreen
        Style.Font.Height = -19
        Style.Font.Name = #23435#20307
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 5
        Width = 150
      end
      object EditCheck: TcxComboBox
        Left = 195
        Top = 13
        ParentFont = False
        Properties.DropDownListStyle = lsEditFixedList
        Properties.ItemHeight = 25
        Properties.Items.Strings = (
          #20840#36873
          #21462#28040
          #21453#36873)
        Properties.OnChange = EditCheckPropertiesChange
        Style.Font.Charset = GB2312_CHARSET
        Style.Font.Color = clGreen
        Style.Font.Height = -16
        Style.Font.Name = #23435#20307
        Style.Font.Style = []
        Style.IsFontAssigned = True
        TabOrder = 6
        Width = 72
      end
    end
    object wPage: TcxPageControl
      Left = 0
      Top = 45
      Width = 770
      Height = 414
      ActivePage = SheetBreakPipe
      Align = alClient
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      LookAndFeel.Kind = lfStandard
      LookAndFeel.NativeStyle = True
      ParentFont = False
      TabHeight = 27
      TabOrder = 1
      TabWidth = 80
      ClientRectBottom = 410
      ClientRectLeft = 2
      ClientRectRight = 766
      ClientRectTop = 31
      object SheetBreakPipe: TcxTabSheet
        Caption = #21046#21160#31649
        ImageIndex = 0
        object DBGrid1: TDBGrid
          Left = 0
          Top = 0
          Width = 764
          Height = 379
          Align = alClient
          BorderStyle = bsNone
          DataSource = DataSource1
          TabOrder = 0
          TitleFont.Charset = GB2312_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -16
          TitleFont.Name = #23435#20307
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'P_Date'
              Title.Caption = #37319#38598#26102#38388
              Width = 165
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'C_Name'
              Title.Caption = #36710#21410
              Width = 120
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
          Height = 379
          Align = alClient
          BorderStyle = bsNone
          DataSource = DataSource2
          TabOrder = 0
          TitleFont.Charset = GB2312_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -16
          TitleFont.Name = #23435#20307
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'P_Date'
              Title.Caption = #37319#38598#26102#38388
              Width = 165
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'C_Name'
              Title.Caption = #36710#21410
              Width = 120
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
          Height = 379
          Align = alClient
          BorderStyle = bsNone
          DataSource = DataSource3
          TabOrder = 0
          TitleFont.Charset = GB2312_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -16
          TitleFont.Name = #23435#20307
          TitleFont.Style = []
          Columns = <
            item
              Expanded = False
              FieldName = 'P_Date'
              Title.Caption = #37319#38598#26102#38388
              Width = 165
              Visible = True
            end
            item
              Expanded = False
              FieldName = 'C_Name'
              Title.Caption = #36710#21410
              Width = 120
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
          Height = 379
          BackWall.Brush.Color = clWhite
          BackWall.Brush.Style = bsClear
          Gradient.Direction = gdFromCenter
          Gradient.EndColor = 14280412
          Gradient.StartColor = clBlack
          MarginBottom = 2
          MarginLeft = 2
          MarginRight = 2
          MarginTop = 2
          Title.Font.Charset = GB2312_CHARSET
          Title.Font.Color = clGreen
          Title.Font.Height = -12
          Title.Font.Name = #23435#20307
          Title.Font.Style = []
          Title.Text.Strings = (
            #31995#32479#36816#34892#30417#25511#26354#32447)
          BottomAxis.Axis.Visible = False
          BottomAxis.LabelStyle = talText
          LeftAxis.Axis.Visible = False
          LeftAxis.Title.Caption = #21387#21147#20540': '#21333#20301#21315#24085
          LeftAxis.Title.Font.Charset = GB2312_CHARSET
          LeftAxis.Title.Font.Color = clGreen
          LeftAxis.Title.Font.Height = -12
          LeftAxis.Title.Font.Name = #23435#20307
          LeftAxis.Title.Font.Style = []
          Legend.LegendStyle = lsSeries
          Legend.ShadowSize = 0
          Legend.TextStyle = ltsPlain
          RightAxis.Axis.Visible = False
          TopAxis.Axis.Visible = False
          View3D = False
          Align = alClient
          BevelOuter = bvNone
          Color = clWhite
          TabOrder = 0
          object CheckBreakPipe: TcxCheckBox
            Tag = 10
            Left = 2
            Top = 1
            Caption = #21046#21160#31649
            ParentFont = False
            State = cbsChecked
            Style.Font.Charset = GB2312_CHARSET
            Style.Font.Color = clGreen
            Style.Font.Height = -16
            Style.Font.Name = #23435#20307
            Style.Font.Style = []
            Style.IsFontAssigned = True
            TabOrder = 0
            Transparent = True
            OnClick = CheckBreakPipeClick
            Width = 75
          end
          object CheckTotalPipe: TcxCheckBox
            Tag = 30
            Left = 150
            Top = 1
            Caption = #24635#39118#31649
            ParentFont = False
            State = cbsChecked
            Style.Font.Charset = GB2312_CHARSET
            Style.Font.Color = clGreen
            Style.Font.Height = -16
            Style.Font.Name = #23435#20307
            Style.Font.Style = []
            Style.IsFontAssigned = True
            TabOrder = 1
            Transparent = True
            OnClick = CheckBreakPipeClick
            Width = 75
          end
          object CheckBreakPot: TcxCheckBox
            Tag = 20
            Left = 76
            Top = 1
            Caption = #21046#21160#32568
            ParentFont = False
            State = cbsChecked
            Style.Font.Charset = GB2312_CHARSET
            Style.Font.Color = clGreen
            Style.Font.Height = -16
            Style.Font.Name = #23435#20307
            Style.Font.Style = []
            Style.IsFontAssigned = True
            TabOrder = 2
            Transparent = True
            OnClick = CheckBreakPipeClick
            Width = 75
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
