inherited fFrameConfig: TfFrameConfig
  Width = 729
  Height = 451
  Font.Color = clBlack
  Font.Height = -16
  object DeviceList: TdxOrgChart
    Left = 0
    Top = 0
    Width = 729
    Height = 271
    LineColor = clGreen
    IndentY = 32
    BorderStyle = bsNone
    Options = [ocSelect, ocButtons, ocDblClick, ocCanDrag, ocShowDrag, ocAnimate]
    OnChange = DeviceListChange
    OnDeletion = DeviceListDeletion
    Align = alClient
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    OnDragOver = DeviceListDragOver
    OnEndDrag = DeviceListEndDrag
  end
  object wPanel: TPanel
    Left = 0
    Top = 271
    Width = 729
    Height = 180
    Align = alBottom
    BevelOuter = bvNone
    Font.Charset = GB2312_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentColor = True
    ParentFont = False
    TabOrder = 1
    object Bevel1: TBevel
      Left = 0
      Top = 0
      Width = 729
      Height = 5
      Align = alTop
      Shape = bsBottomLine
    end
  end
end
