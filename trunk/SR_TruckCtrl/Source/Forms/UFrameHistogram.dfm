inherited fFrameHistogram: TfFrameHistogram
  Width = 653
  Height = 441
  object PanelTotalPipe: TPanel
    Left = 0
    Top = 270
    Width = 653
    Height = 135
    Align = alTop
    BevelOuter = bvNone
    BevelWidth = 10
    BorderWidth = 5
    Color = clWhite
    TabOrder = 1
    object cxLabel1: TcxLabel
      Left = 5
      Top = 5
      Align = alTop
      AutoSize = False
      Caption = #24635#39118#31649'('#21333#20301': '#21315#24085')'
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.OuterColor = clGreen
      Properties.LineOptions.Visible = True
      Height = 25
      Width = 643
      AnchorY = 18
    end
  end
  object PanelBreakPot: TPanel
    Left = 0
    Top = 135
    Width = 653
    Height = 135
    Align = alTop
    BevelOuter = bvNone
    BevelWidth = 10
    BorderWidth = 5
    Color = clWhite
    TabOrder = 2
    object cxLabel3: TcxLabel
      Left = 5
      Top = 5
      Align = alTop
      AutoSize = False
      Caption = #21046#21160#32568'('#21333#20301': '#21315#24085')'
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.OuterColor = clGreen
      Properties.LineOptions.Visible = True
      Height = 25
      Width = 643
      AnchorY = 18
    end
  end
  object PanelBreakPipe: TPanel
    Left = 0
    Top = 0
    Width = 653
    Height = 135
    Align = alTop
    BevelOuter = bvNone
    BevelWidth = 10
    BorderWidth = 5
    Color = clWhite
    TabOrder = 0
    DesignSize = (
      653
      135)
    object cxLabel2: TcxLabel
      Left = 5
      Top = 5
      Align = alTop
      AutoSize = False
      Caption = #21046#21160#31649'('#21333#20301': '#21315#24085')'
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.OuterColor = clGreen
      Properties.LineOptions.Visible = True
      Height = 25
      Width = 643
      AnchorY = 18
    end
    object BtnExit: TButton
      Left = 581
      Top = 2
      Width = 55
      Height = 22
      Anchors = [akTop, akRight]
      Caption = #36820#22238
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = BtnExitClick
    end
  end
  object PanelStyle: TPanel
    Left = 140
    Top = 0
    Width = 40
    Height = 135
    BevelOuter = bvNone
    BevelWidth = 10
    BorderWidth = 5
    Color = 15724527
    TabOrder = 3
    Visible = False
    object cxLabel4: TcxLabel
      Left = 5
      Top = 5
      Align = alTop
      AutoSize = False
      Caption = #26679#24335':'
      ParentFont = False
      Properties.Alignment.Vert = taVCenter
      Properties.LineOptions.Alignment = cxllaBottom
      Properties.LineOptions.OuterColor = clGreen
      Properties.LineOptions.Visible = True
      Height = 25
      Width = 30
      AnchorY = 18
    end
    object PBar: TcxProgressBar
      Left = 8
      Top = 30
      AutoSize = False
      ParentColor = False
      ParentFont = False
      Position = 50.000000000000000000
      Properties.BarStyle = cxbsGradient
      Properties.BeginColor = clWhite
      Properties.EndColor = clGreen
      Properties.Orientation = cxorVertical
      Properties.OverloadValue = 20.000000000000000000
      Properties.PeakColor = clYellow
      Properties.PeakValue = 50.000000000000000000
      Properties.ShowTextStyle = cxtsText
      Properties.SolidTextColor = True
      Properties.Text = '325'
      Properties.TextOrientation = cxorVertical
      Style.BorderStyle = ebsOffice11
      Style.Color = clWhite
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -14
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.TextColor = clMaroon
      Style.IsFontAssigned = True
      TabOrder = 1
      Height = 90
      Width = 22
    end
    object LabelStyle: TcxLabel
      Left = 4
      Top = 120
      Caption = #36710#21410'1'
      ParentFont = False
      Style.Font.Charset = GB2312_CHARSET
      Style.Font.Color = clGreen
      Style.Font.Height = -12
      Style.Font.Name = #23435#20307
      Style.Font.Style = []
      Style.LookAndFeel.Kind = lfUltraFlat
      Style.LookAndFeel.NativeStyle = True
      Style.IsFontAssigned = True
      StyleDisabled.LookAndFeel.Kind = lfUltraFlat
      StyleDisabled.LookAndFeel.NativeStyle = True
      StyleFocused.LookAndFeel.Kind = lfUltraFlat
      StyleFocused.LookAndFeel.NativeStyle = True
      StyleHot.LookAndFeel.Kind = lfUltraFlat
      StyleHot.LookAndFeel.NativeStyle = True
    end
  end
  object TimerStart: TTimer
    Enabled = False
    Interval = 200
    OnTimer = TimerStartTimer
    Left = 6
    Top = 30
  end
  object TimerUI: TTimer
    Enabled = False
    OnTimer = TimerUITimer
    Left = 34
    Top = 30
  end
end
