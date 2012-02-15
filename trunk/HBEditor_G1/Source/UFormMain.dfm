object fFormMain: TfFormMain
  Left = 323
  Top = 175
  Width = 880
  Height = 550
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object WorkPanel: TScrollBox
    Left = 0
    Top = 87
    Width = 872
    Height = 205
    Align = alClient
    Color = clGray
    ParentColor = False
    TabOrder = 1
    OnResize = WorkPanelResize
  end
  object SBar: TdxStatusBar
    Left = 0
    Top = 496
    Width = 872
    Height = 20
    Panels = <
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
      end
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
      end
      item
        PanelStyleClassName = 'TdxStatusBarTextPanelStyle'
      end>
    PaintStyle = stpsUseLookAndFeel
    LookAndFeel.SkinName = ''
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
  end
  object wPage: TcxPageControl
    Left = 0
    Top = 292
    Width = 872
    Height = 204
    ActivePage = SheetMemo
    Align = alBottom
    TabOrder = 6
    ClientRectBottom = 204
    ClientRectRight = 872
    ClientRectTop = 23
    object SheetScreen: TcxTabSheet
      Caption = #23631#24149#21442#25968
      ImageIndex = 0
      object GroupInfo: TcxGroupBox
        Left = 10
        Top = 35
        Caption = #23631#24149#20449#24687
        TabOrder = 0
        Height = 135
        Width = 255
        object cxLabel7: TcxLabel
          Left = 10
          Top = 31
          Caption = #23631#23485':'
          Transparent = True
        end
        object cxLabel8: TcxLabel
          Left = 10
          Top = 56
          Caption = #23631#39640':'
          Transparent = True
        end
        object EditScreenW: TcxComboBox
          Left = 45
          Top = 30
          Properties.DropDownListStyle = lsEditFixedList
          Properties.DropDownRows = 15
          Properties.ImmediateDropDown = False
          Properties.IncrementalSearch = False
          Properties.ItemHeight = 18
          Properties.OnEditValueChanged = EditScreenWPropertiesEditValueChanged
          TabOrder = 2
          Width = 135
        end
        object EditScreenH: TcxComboBox
          Left = 45
          Top = 55
          Properties.DropDownListStyle = lsEditFixedList
          Properties.DropDownRows = 15
          Properties.ImmediateDropDown = False
          Properties.IncrementalSearch = False
          Properties.ItemHeight = 18
          Properties.OnEditValueChanged = EditScreenWPropertiesEditValueChanged
          TabOrder = 3
          Width = 135
        end
        object EditJR: TcxCheckBox
          Left = 10
          Top = 88
          Caption = #20860#23481'V2.76'#29256#26412
          TabOrder = 4
          Transparent = True
          OnClick = EditTimeCharChange
          Width = 100
        end
        object BtnSaveWH: TcxButton
          Left = 115
          Top = 84
          Width = 65
          Height = 25
          Caption = #20445#23384#23485#39640
          TabOrder = 5
          OnClick = BtnSaveParamClick
        end
      end
      object DockCard: TdxBarDockControl
        Left = 0
        Top = 0
        Width = 872
        Height = 26
        Align = dalTop
        BarManager = BarMgr
      end
    end
    object SheetMemo: TcxTabSheet
      Caption = #33410#30446#32534#36753
      ImageIndex = 1
      DesignSize = (
        872
        181)
      object cxGroupBox3: TcxGroupBox
        Left = 10
        Top = 35
        Anchors = [akLeft, akTop, akRight, akBottom]
        Caption = #33410#30446#20869#23481
        TabOrder = 0
        DesignSize = (
          270
          138)
        Height = 138
        Width = 270
        object EditText: TcxMemo
          Left = 10
          Top = 15
          Anchors = [akLeft, akTop, akRight, akBottom]
          Properties.ScrollBars = ssBoth
          TabOrder = 0
          Height = 115
          Width = 250
        end
      end
      object cxGroupBox4: TcxGroupBox
        Left = 290
        Top = 35
        Anchors = [akTop, akRight, akBottom]
        Caption = #33410#30446#34920
        TabOrder = 1
        Height = 138
        Width = 177
        object ListMovie: TcxListBox
          Left = 10
          Top = 15
          Width = 135
          Height = 115
          ItemHeight = 16
          ListStyle = lbOwnerDrawFixed
          TabOrder = 0
          OnClick = ListMovieClick
        end
        object BtnDel: TcxButton
          Left = 146
          Top = 105
          Width = 28
          Height = 25
          Hint = #21024#38500#24403#21069#23631
          ParentShowHint = False
          ShowHint = True
          TabOrder = 1
          OnClick = BtnDelClick
          Glyph.Data = {
            36040000424D3604000000000000360000002800000010000000100000000100
            2000000000000004000000000000000000000000000000000000FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF000000
            FF00000099000000990000009900FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF000000FF00000099000000990000009900FF00FF00FF00FF00FF00FF000000
            FF000000CC000000CC000000CC0000009900FF00FF00FF00FF00FF00FF000000
            FF000000CC000000CC000000CC0000009900FF00FF00FF00FF00FF00FF00FF00
            FF000000FF000000CC000000CC000000CC0000009900FF00FF000000FF000000
            CC000000CC000000CC0000009900FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF000000FF000000CC000000CC000000CC00000099000000CC000000
            CC000000CC0000009900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF000000FF000000CC000000CC000000CC000000CC000000
            CC0000009900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF000000FF000000CC000000CC000000CC000000
            9900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF000000FF000000CC000000CC000000CC000000CC000000
            CC0000009900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF000000FF000000CC000000CC000000CC00000099000000CC000000
            CC000000CC0000009900FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF000000FF000000CC000000CC000000CC0000009900FF00FF000000FF000000
            CC000000CC000000CC0000009900FF00FF00FF00FF00FF00FF00FF00FF000000
            FF000000CC000000CC000000CC0000009900FF00FF00FF00FF00FF00FF000000
            FF000000CC000000CC000000CC0000009900FF00FF00FF00FF00FF00FF000000
            FF000000FF000000FF000000FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF000000FF000000FF000000FF000000FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00
            FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00FF00}
        end
        object BtnSync: TcxButton
          Left = 146
          Top = 15
          Width = 28
          Height = 90
          Hint = #26356#26032#21015#34920
          ParentShowHint = False
          ShowHint = True
          TabOrder = 2
          OnClick = BtnSyncClick
          Glyph.Data = {
            36050000424D3605000000000000360400002800000010000000100000000100
            08000000000000010000000000000000000000010000000000001684BD00106F
            AA00106BA600B1ECFC0097E5FB00C3F1FC00C3F1FD00EFFDFE00A9EAFC00D5F6
            FD002697BA00DEF8FE00DDF8FE00DDF8FD00B1ECFB00FFFFFF0000000000C0C0
            C000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000000000000000
            0000000000000000000000000000000000000000000000000000111111111111
            1111111102021111111111111111111111111111020402111111111111111111
            111111110204040211111111111102020202020202040404021111111100030E
            0303030303030303030011111111000000000000000909090011111111111111
            111111110007000011111111111101011111111100000A111111111111010401
            11111111000A1111111111110104040111111111111111111111110108080801
            010101010101111111110005060605060505060505050111111111000C0D0B00
            0000000000001111111111110007070011111111111111111111111111000700
            1111111111111111111111111111000011111111111111111111}
        end
      end
      object GroupMode: TcxGroupBox
        Left = 476
        Top = 35
        Anchors = [akTop, akRight, akBottom]
        Caption = #33410#30446#27169#24335
        TabOrder = 2
        Height = 138
        Width = 385
        object BtnModeSync: TcxButton
          Left = 10
          Top = 26
          Width = 29
          Height = 87
          Caption = #27169#24335#19968#33268
          TabOrder = 0
          WordWrap = True
          OnClick = BtnModeSyncClick
        end
        object EditEnterMode: TcxComboBox
          Left = 102
          Top = 30
          Properties.DropDownListStyle = lsEditFixedList
          Properties.DropDownRows = 15
          Properties.ImmediateDropDown = False
          Properties.ItemHeight = 18
          Properties.OnChange = EditEnterModePropertiesChange
          TabOrder = 1
          Width = 111
        end
        object cxLabel1: TcxLabel
          Left = 45
          Top = 32
          Caption = #36827#20837#26041#24335':'
          Transparent = True
        end
        object cxLabel2: TcxLabel
          Left = 45
          Top = 60
          Caption = #20572#30041#26102#38388':'
          Transparent = True
        end
        object EditKeep: TcxComboBox
          Left = 102
          Top = 58
          Properties.DropDownListStyle = lsEditFixedList
          Properties.DropDownRows = 15
          Properties.ImmediateDropDown = False
          Properties.ItemHeight = 18
          Properties.OnChange = EditEnterModePropertiesChange
          TabOrder = 4
          Width = 55
        end
        object cxLabel3: TcxLabel
          Left = 160
          Top = 60
          Caption = #31186
          Transparent = True
        end
        object cxLabel4: TcxLabel
          Left = 45
          Top = 88
          Caption = #36864#20986#26041#24335':'
          Transparent = True
        end
        object EditExitMode: TcxComboBox
          Left = 102
          Top = 86
          Properties.DropDownListStyle = lsEditFixedList
          Properties.DropDownRows = 15
          Properties.ImmediateDropDown = False
          Properties.ItemHeight = 18
          Properties.OnChange = EditEnterModePropertiesChange
          TabOrder = 7
          Width = 111
        end
        object cxLabel5: TcxLabel
          Left = 226
          Top = 32
          Caption = #36827#20837#36895#24230':'
          Transparent = True
        end
        object EditEnterSpeed: TcxComboBox
          Left = 285
          Top = 30
          Properties.DropDownListStyle = lsEditFixedList
          Properties.DropDownRows = 15
          Properties.ImmediateDropDown = False
          Properties.ItemHeight = 18
          Properties.OnChange = EditEnterModePropertiesChange
          TabOrder = 9
          Width = 85
        end
        object EditGS: TcxCheckBox
          Left = 226
          Top = 60
          Caption = #32039#38543#21069#24149
          Properties.OnEditValueChanged = EditEnterModePropertiesChange
          TabOrder = 10
          Transparent = True
          Width = 82
        end
        object cxLabel6: TcxLabel
          Left = 226
          Top = 92
          Caption = #36864#20986#36895#24230':'
          Transparent = True
        end
        object EditExitSpeed: TcxComboBox
          Left = 285
          Top = 90
          Properties.DropDownListStyle = lsEditFixedList
          Properties.DropDownRows = 15
          Properties.ImmediateDropDown = False
          Properties.ItemHeight = 18
          Properties.OnChange = EditEnterModePropertiesChange
          TabOrder = 12
          Width = 85
        end
        object EditBlank: TcxCheckBox
          Left = 300
          Top = 60
          Caption = #28040#38500#31354#26684
          Properties.OnChange = EditEnterModePropertiesChange
          TabOrder = 13
          Transparent = True
          Width = 82
        end
      end
      object DockEdit: TdxBarDockControl
        Left = 0
        Top = 0
        Width = 872
        Height = 26
        Align = dalTop
        BarManager = BarMgr
      end
    end
  end
  object BarMgr: TdxBarManager
    AlwaysSaveText = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    CanCustomize = False
    Categories.Strings = (
      'Default'
      #25991#20214
      #24110#21161
      'Menus')
    Categories.ItemsVisibles = (
      2
      2
      2
      2)
    Categories.Visibles = (
      True
      True
      True
      True)
    ImageOptions.Images = FDM.ImagesBase
    ImageOptions.LargeImages = FDM.ImagesBase
    NotDocking = [dsLeft, dsRight, dsBottom]
    PopupMenuLinks = <>
    Style = bmsOffice11
    UseSystemFont = True
    Left = 50
    Top = 129
    DockControlHeights = (
      0
      0
      87
      0)
    object dxBarManager1Bar1: TdxBar
      AllowQuickCustomizing = False
      Caption = 'Menu'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 22
      DockingStyle = dsTop
      FloatLeft = 331
      FloatTop = 188
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarLargeButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton3'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'BtnClock'
        end
        item
          Visible = True
          ItemName = 'BtnTime'
        end
        item
          Visible = True
          ItemName = 'BtnBg'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarLargeButton4'
        end
        item
          Visible = True
          ItemName = 'dxBarLargeButton5'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarLargeButton19'
        end>
      NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
      OneOnRow = True
      Row = 1
      UseOwnFont = False
      Visible = True
      WholeRow = True
    end
    object dxBarManager1Bar2: TdxBar
      AllowClose = False
      AllowQuickCustomizing = False
      Caption = #26102#38047
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 61
      DockingStyle = dsTop
      FloatLeft = 331
      FloatTop = 188
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          UserDefine = [udWidth]
          UserWidth = 98
          Visible = True
          ItemName = 'EditTimeChar'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'EditDispMode'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'EditDispPos'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'BtnYear'
        end
        item
          Visible = True
          ItemName = 'BtnMonth'
        end
        item
          Visible = True
          ItemName = 'BtnDay'
        end
        item
          Visible = True
          ItemName = 'BtnWeek'
        end
        item
          Visible = True
          ItemName = 'BtnHour'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'EditPlayDays'
        end>
      NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
      OneOnRow = True
      Row = 2
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object dxBarManager1Bar3: TdxBar
      AllowQuickCustomizing = False
      Caption = 'Main Menu'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 0
      FloatTop = 0
      FloatClientWidth = 88
      FloatClientHeight = 90
      IsMainMenu = True
      ItemLinks = <
        item
          Visible = True
          ItemName = 'N1'
        end
        item
          Visible = True
          ItemName = 'N5'
        end>
      MultiLine = True
      NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = True
    end
    object dxBarManager1Bar4: TdxBar
      AllowClose = False
      AllowQuickCustomizing = False
      Caption = #36830#25509
      CaptionButtons = <>
      DockControl = DockCard
      DockedDockControl = DockCard
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 268
      FloatTop = 214
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          UserDefine = [udWidth]
          UserWidth = 79
          Visible = True
          ItemName = 'EditPort'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'EditBote'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarSubItem5'
        end
        item
          Visible = True
          ItemName = 'dxBarButton11'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarButton13'
        end>
      NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = True
    end
    object BarEdit: TdxBar
      AllowQuickCustomizing = False
      Caption = #32534#36753
      CaptionButtons = <>
      DockControl = DockEdit
      DockedDockControl = DockEdit
      DockedLeft = 0
      DockedTop = 0
      FloatLeft = 268
      FloatTop = 214
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'BtnRestoreText'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'BtnCopy'
        end
        item
          Visible = True
          ItemName = 'BtnCut'
        end
        item
          Visible = True
          ItemName = 'BtnPaste'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'EditFontName'
        end
        item
          Visible = True
          ItemName = 'EditFontSize'
        end
        item
          Visible = True
          ItemName = 'EditFontColor'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'BtnBold'
        end
        item
          Visible = True
          ItemName = 'BtnItaly'
        end
        item
          Visible = True
          ItemName = 'BtnUnder'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'BtnHLeft'
        end
        item
          Visible = True
          ItemName = 'BtnHMid'
        end
        item
          Visible = True
          ItemName = 'BtnHRight'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'BtnVTop'
        end
        item
          Visible = True
          ItemName = 'BtnVMid'
        end
        item
          Visible = True
          ItemName = 'BtnVBottom'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'BtnSend'
        end>
      NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = True
    end
    object dxBarButton2: TdxBarButton
      Caption = #25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320
      Category = 0
      Hint = #25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320#25171#24320
      Visible = ivAlways
      ImageIndex = 1
    end
    object dxBarButton3: TdxBarButton
      Caption = #20445#23384
      Category = 0
      Hint = #20445#23384
      Visible = ivAlways
      ImageIndex = 2
    end
    object dxBarLargeButton1: TdxBarLargeButton
      Action = Act_New
      Category = 0
      AutoGrayScale = False
      SyncImageIndex = False
      ImageIndex = 0
    end
    object dxBarLargeButton2: TdxBarLargeButton
      Action = Act_Open
      Category = 0
      AutoGrayScale = False
    end
    object dxBarLargeButton3: TdxBarLargeButton
      Action = Act_Save
      Category = 0
      AutoGrayScale = False
    end
    object dxBarLargeButton4: TdxBarLargeButton
      Action = Act_Conn
      Caption = #35835#23631
      Category = 0
      AutoGrayScale = False
    end
    object dxBarLargeButton5: TdxBarLargeButton
      Action = Act_Send
      Caption = #21457#36865
      Category = 0
      AutoGrayScale = False
    end
    object dxBarLargeButton19: TdxBarLargeButton
      Action = Act_Help
      Category = 0
      AutoGrayScale = False
    end
    object EditTimeChar: TdxBarCombo
      Caption = #26102#38047#26684#24335':'
      Category = 0
      Hint = #26102#38047#26684#24335':'
      Visible = ivAlways
      OnCurChange = EditTimeCharChange
      ShowCaption = True
      Width = 100
      Text = #27721#23383
      DropDownCount = 15
      Items.Strings = (
        #27721#23383
        #23383#31526)
      ItemIndex = 0
    end
    object EditDispMode: TdxBarCombo
      Caption = #26174#31034#27169#24335':'
      Category = 0
      Hint = #26174#31034#27169#24335':'
      Visible = ivAlways
      OnCurChange = EditTimeCharChange
      ShowCaption = True
      Width = 100
      Text = #22266#23450#26174#31034
      DropDownCount = 15
      Items.Strings = (
        #22266#23450#26174#31034
        #36319#38543#27169#24335)
      ItemIndex = 0
    end
    object EditDispPos: TdxBarCombo
      Caption = #20301#32622':'
      Category = 0
      Hint = #20301#32622':'
      Visible = ivAlways
      ShowCaption = True
      Width = 100
      DropDownCount = 15
      ItemIndex = -1
    end
    object BtnYear: TdxBarButton
      Caption = ' '#24180' '
      Category = 0
      Hint = ' '#24180' '
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object BtnMonth: TdxBarButton
      Caption = ' '#26376' '
      Category = 0
      Hint = ' '#26376' '
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object BtnDay: TdxBarButton
      Caption = ' '#26085' '
      Category = 0
      Hint = ' '#26085' '
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object BtnWeek: TdxBarButton
      Caption = #26143#26399
      Category = 0
      Hint = #26143#26399
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object BtnHour: TdxBarButton
      Caption = #26102#20998#31186
      Category = 0
      Hint = #26102#20998#31186
      Visible = ivAlways
      ButtonStyle = bsChecked
    end
    object EditPort: TdxBarCombo
      Caption = #36830#25509#31471#21475':'
      Category = 0
      Hint = #36830#25509#31471#21475':'
      Visible = ivAlways
      OnChange = EditPortChange
      ShowCaption = True
      Width = 65
      DropDownCount = 15
      ItemIndex = -1
    end
    object EditBote: TdxBarCombo
      Caption = #20256#36755#36895#29575':'
      Category = 0
      Hint = #20256#36755#36895#29575':'
      Visible = ivAlways
      OnChange = EditPortChange
      ShowCaption = True
      Width = 75
      DropDownCount = 15
      Items.Strings = (
        '9600'
        '38400')
      ItemIndex = -1
    end
    object dxBarButton11: TdxBarButton
      Action = Act_Conn
      Caption = #35835#21462#23631#21442
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarButton13: TdxBarButton
      Action = Act_Send
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarLargeButton20: TdxBarLargeButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
      LargeImageIndex = 9
      PaintStyle = psCaptionGlyph
    end
    object dxBarSubItem5: TdxBarSubItem
      Caption = #29992#25143#30331#24405
      Category = 0
      Visible = ivAlways
      ImageIndex = 5
      ItemLinks = <
        item
          Visible = True
          ItemName = 'BtnLogoff'
        end
        item
          Visible = True
          ItemName = 'EditPwd'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'BtnSyncTime'
        end
        item
          Visible = True
          ItemName = 'BtnCheckPort'
        end
        item
          Visible = True
          ItemName = 'BtnSaveParam'
        end>
    end
    object EditPwd: TcxBarEditItem
      Caption = #31649#29702#23494#30721':'
      Category = 0
      Hint = #31649#29702#23494#30721
      Visible = ivAlways
      OnKeyDown = EditPwdKeyDown
      ShowCaption = True
      Width = 100
      PropertiesClassName = 'TcxButtonEditProperties'
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.EchoMode = eemPassword
      Properties.PasswordChar = '*'
      Properties.OnButtonClick = EditPwdPropertiesButtonClick
    end
    object BtnLogoff: TdxBarButton
      Caption = #36864#20986#30331#24405
      Category = 0
      Hint = #36864#20986#30331#24405
      Visible = ivAlways
      OnClick = BtnLogoffClick
    end
    object BtnSyncTime: TdxBarButton
      Caption = #21516#27493#26102#38047
      Category = 0
      Hint = #21516#27493#26102#38047
      Visible = ivAlways
      OnClick = BtnSyncTimeClick
    end
    object BtnSaveParam: TdxBarButton
      Caption = #20445#23384#23631#24149#23610#23544
      Category = 0
      Hint = #20445#23384#23631#24149#23610#23544
      Visible = ivAlways
      OnClick = BtnSaveParamClick
    end
    object EditFontColor: TdxBarCombo
      Caption = #39068#33394':'
      Category = 0
      Hint = #39068#33394
      Visible = ivAlways
      OnCurChange = EditFontColorChange
      ShowCaption = True
      Width = 65
      ShowEditor = False
      DropDownCount = 15
      OnDrawItem = EditFontColorDrawItem
      ItemIndex = -1
    end
    object BtnHLeft: TdxBarButton
      Caption = #23621#24038
      Category = 0
      Hint = #23621#24038
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 1
      ImageIndex = 22
      OnClick = BtnHLeftClick
    end
    object BtnHMid: TdxBarButton
      Caption = #23621#20013
      Category = 0
      Hint = #23621#20013
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 1
      ImageIndex = 23
      OnClick = BtnHLeftClick
    end
    object BtnHRight: TdxBarButton
      Caption = #23621#21491
      Category = 0
      Hint = #23621#21491
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 1
      ImageIndex = 24
      OnClick = BtnHLeftClick
    end
    object BtnVTop: TdxBarButton
      Caption = #23621#19978
      Category = 0
      Hint = #23621#19978
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 2
      ImageIndex = 25
      OnClick = BtnHLeftClick
    end
    object BtnVMid: TdxBarButton
      Caption = #23621#20013
      Category = 0
      Hint = #23621#20013
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 2
      ImageIndex = 26
      OnClick = BtnHLeftClick
    end
    object BtnVBottom: TdxBarButton
      Caption = #23621#19979
      Category = 0
      Hint = #23621#19979
      Visible = ivAlways
      ButtonStyle = bsChecked
      GroupIndex = 2
      ImageIndex = 27
      OnClick = BtnHLeftClick
    end
    object dxBarCombo8: TdxBarCombo
      Caption = #23383#24418':'
      Category = 0
      Hint = #23383#24418':'
      Visible = ivAlways
      ShowCaption = True
      Width = 100
      ItemIndex = -1
    end
    object cxBarEditItem1: TcxBarEditItem
      Caption = #25928#26524':'
      Category = 0
      Hint = #25928#26524':'
      Visible = ivAlways
      Width = 100
      PropertiesClassName = 'TcxCheckGroupProperties'
      Properties.Columns = 2
      Properties.Items = <
        item
          Caption = #19979#21010#32447
        end
        item
          Caption = #21024#38500#32447
        end>
    end
    object BtnCut: TdxBarButton
      Action = Act_Cut
      Category = 0
    end
    object BtnCopy: TdxBarButton
      Action = Act_Copy
      Category = 0
    end
    object BtnPaste: TdxBarButton
      Action = Act_Paste
      Category = 0
    end
    object BtnBold: TdxBarButton
      Caption = #31895#20307
      Category = 0
      Hint = #31895#20307
      Visible = ivAlways
      ButtonStyle = bsChecked
      ImageIndex = 19
      OnClick = BtnBoldClick
    end
    object BtnUnder: TdxBarButton
      Caption = #19979#21010#32447
      Category = 0
      Hint = #19979#21010#32447
      Visible = ivAlways
      ButtonStyle = bsChecked
      ImageIndex = 21
      OnClick = BtnBoldClick
    end
    object BtnItaly: TdxBarButton
      Caption = #26012#20307
      Category = 0
      Hint = #26012#20307
      Visible = ivAlways
      ButtonStyle = bsChecked
      ImageIndex = 20
      OnClick = BtnBoldClick
    end
    object BtnSend: TdxBarButton
      Action = Act_Send
      Category = 0
      PaintStyle = psCaptionGlyph
    end
    object dxBarSubItem2: TdxBarSubItem
      Caption = #23450#26102
      Category = 0
      Visible = ivAlways
      ImageIndex = 7
      ShowCaption = False
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarCombo12'
        end>
    end
    object dxBarCombo9: TdxBarCombo
      Caption = #26684#24335':'
      Category = 0
      Hint = #26684#24335':'
      Visible = ivAlways
      Width = 100
      Text = #27721#23383
      Items.Strings = (
        #27721#23383
        #23383#31526)
      ItemIndex = 0
    end
    object dxBarCombo10: TdxBarCombo
      Caption = #27169#24335':'
      Category = 0
      Hint = #27169#24335':'
      Visible = ivAlways
      Width = 100
      Text = #22266#23450#26174#31034
      Items.Strings = (
        #22266#23450#26174#31034
        #36319#38543#27169#24335)
      ItemIndex = 0
    end
    object dxBarCombo11: TdxBarCombo
      Caption = #20301#32622':'
      Category = 0
      Hint = #20301#32622':'
      Visible = ivAlways
      Width = 100
      ItemIndex = -1
    end
    object cxBarEditItem2: TcxBarEditItem
      Category = 0
      Visible = ivAlways
      ShowCaption = True
      Width = 100
      PropertiesClassName = 'TcxCheckGroupProperties'
      Properties.Columns = 2
      Properties.Items = <
        item
          Caption = #24180
        end
        item
          Caption = #26376
        end
        item
          Caption = #26085
        end
        item
          Caption = #26143#26399
        end
        item
          Caption = #26102#20998#31186
        end>
    end
    object dxBarCombo12: TdxBarCombo
      Caption = #25773#25918#22825#25968':'
      Category = 0
      Hint = #25773#25918#22825#25968':'
      Visible = ivAlways
      Width = 65
      ItemIndex = -1
    end
    object BtnClock: TdxBarLargeButton
      Caption = #26102#38047
      Category = 0
      Visible = ivAlways
      ButtonStyle = bsChecked
      LargeImageIndex = 6
      OnClick = EditTimeCharChange
    end
    object BtnTime: TdxBarLargeButton
      Caption = #23450#26102
      Category = 0
      Visible = ivAlways
      ButtonStyle = bsChecked
      LargeImageIndex = 7
    end
    object EditPlayDays: TdxBarCombo
      Caption = #23450#26102#25773#25918':'
      Category = 0
      Hint = #23450#26102#25773#25918
      Visible = ivAlways
      ShowCaption = True
      Width = 65
      DropDownCount = 15
      ItemIndex = -1
    end
    object EditFontName: TcxBarEditItem
      Caption = #23383#20307':'
      Category = 0
      Hint = #23383#20307#21517#31216
      Visible = ivAlways
      ShowCaption = True
      Width = 115
      PropertiesClassName = 'TcxFontNameComboBoxProperties'
      Properties.DropDownRows = 15
      Properties.FontPreview.ShowButtons = False
      Properties.ImmediateDropDown = False
      Properties.OnEditValueChanged = EditFontNamePropertiesChange
    end
    object EditFontSize: TdxBarCombo
      Caption = #22823#23567':'
      Category = 0
      Hint = #23383#20307#22823#23567
      Visible = ivAlways
      OnCurChange = EditFontSizeChange
      ShowCaption = True
      Width = 65
      DropDownCount = 15
      ItemHeight = 18
      ItemIndex = -1
    end
    object BtnRestoreText: TdxBarButton
      Action = Act_Sync
      Category = 0
    end
    object BtnBg: TdxBarLargeButton
      Caption = #32972#26223
      Category = 0
      Hint = #32972#26223
      Visible = ivAlways
      LargeImageIndex = 10
      OnClick = BtnBgClick
      AutoGrayScale = False
      SyncImageIndex = False
      ImageIndex = -1
    end
    object BtnCheckPort: TdxBarButton
      Caption = #26597#25214#25511#21046#21345
      Category = 0
      Hint = #26597#25214#25511#21046#21345
      Visible = ivAlways
      OnClick = BtnCheckPortClick
    end
    object N14: TdxBarButton
      Action = Act_Open
      Category = 1
    end
    object N15: TdxBarButton
      Action = Act_Save
      Category = 1
    end
    object N16: TdxBarButton
      Caption = #36864#20986
      Category = 1
      Visible = ivAlways
      OnClick = N16Click
    end
    object N6: TdxBarButton
      Action = Act_About
      Category = 2
    end
    object N1: TdxBarSubItem
      Caption = #25991#20214
      Category = 3
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'N14'
        end
        item
          Visible = True
          ItemName = 'N15'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'N16'
        end>
    end
    object N5: TdxBarSubItem
      Caption = #24110#21161
      Category = 3
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'N6'
        end>
    end
  end
  object ActionList1: TActionList
    Images = FDM.ImagesBase
    Left = 22
    Top = 129
    object Act_New: TAction
      Caption = #26032#24314
      ImageIndex = 0
      OnExecute = Act_NewExecute
    end
    object Act_Open: TAction
      Caption = #25171#24320
      ImageIndex = 1
      OnExecute = Act_OpenExecute
    end
    object Act_Save: TAction
      Caption = #20445#23384
      ImageIndex = 2
      OnExecute = Act_SaveExecute
    end
    object Act_Clock: TAction
      Caption = #26102#38047
      ImageIndex = 6
    end
    object Act_Time: TAction
      Caption = #23450#26102
      ImageIndex = 7
    end
    object Act_Conn: TAction
      Caption = #36830#25509
      ImageIndex = 9
      OnExecute = Act_ConnExecute
    end
    object Act_Send: TAction
      Caption = #21457#36865#25968#25454
      ImageIndex = 8
      OnExecute = Act_SendExecute
    end
    object Act_Help: TAction
      Caption = #24110#21161
      ImageIndex = 3
      OnExecute = Act_HelpExecute
    end
    object Act_Copy: TAction
      Category = 'Edit'
      Caption = #22797#21046
      Hint = #22797#21046
      ImageIndex = 12
      OnExecute = Act_CopyExecute
    end
    object Act_Cut: TAction
      Category = 'Edit'
      Caption = #21098#20999
      Hint = #21098#20999
      ImageIndex = 11
      OnExecute = Act_CutExecute
    end
    object Act_Paste: TAction
      Category = 'Edit'
      Caption = #31896#36148
      Hint = #31896#36148
      ImageIndex = 13
      OnExecute = Act_PasteExecute
    end
    object Act_Sync: TAction
      Category = 'Edit'
      Caption = #21047#26032
      Hint = #26356#26032#33410#30446#20869#23481
      ImageIndex = 14
      OnExecute = Act_SyncExecute
    end
    object Act_About: TAction
      Caption = #20851#20110
      ImageIndex = 5
      OnExecute = Act_AboutExecute
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 22
    Top = 157
  end
end
