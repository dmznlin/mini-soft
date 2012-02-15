object FrmMain: TFrmMain
  Left = 302
  Top = 229
  Width = 710
  Height = 498
  Caption = #33756#21333#32534#36753#22120' V1.0'
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
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 702
    Height = 37
    AutoSize = True
    ButtonHeight = 35
    ButtonWidth = 79
    Flat = True
    Images = FDM.ImageList1
    ShowCaptions = True
    TabOrder = 0
    object BtnConn: TToolButton
      Left = 0
      Top = 0
      Caption = '    '#36830#25509'    '
      ImageIndex = 0
      OnClick = BtnConnClick
    end
    object ToolButton4: TToolButton
      Left = 79
      Top = 0
      Width = 8
      Caption = 'ToolButton4'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object BtnAdd: TToolButton
      Left = 87
      Top = 0
      Caption = #28155#21152
      Enabled = False
      ImageIndex = 1
      OnClick = BtnAddClick
    end
    object BtnEdit: TToolButton
      Left = 166
      Top = 0
      Caption = #20462#25913
      Enabled = False
      ImageIndex = 2
      OnClick = BtnEditClick
    end
    object BtnDel: TToolButton
      Left = 245
      Top = 0
      Caption = #21024#38500
      Enabled = False
      ImageIndex = 3
      OnClick = BtnDelClick
    end
    object ToolButton6: TToolButton
      Left = 324
      Top = 0
      Width = 8
      Caption = 'ToolButton6'
      Enabled = False
      ImageIndex = 4
      Style = tbsSeparator
    end
    object BtnFresh: TToolButton
      Left = 332
      Top = 0
      Caption = #21047#26032
      Enabled = False
      ImageIndex = 5
      OnClick = BtnFreshClick
    end
    object BtnPreview: TToolButton
      Left = 411
      Top = 0
      Caption = #39044#35272
      Enabled = False
      ImageIndex = 4
      OnClick = BtnPreviewClick
    end
    object BtnExit: TToolButton
      Left = 490
      Top = 0
      Caption = #36864#20986
      ImageIndex = 6
      OnClick = BtnExitClick
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 452
    Width = 702
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object cxGrid1: TcxGrid
    Left = 0
    Top = 37
    Width = 702
    Height = 415
    Align = alClient
    TabOrder = 1
    object cxView1: TcxGridDBTableView
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = DataSource1
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsData.Deleting = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.ShowColumnFilterButtons = sfbAlways
      Styles.Background = Winter
      Styles.Content = Light
      Styles.ContentEven = Winter
      Styles.Inactive = Winter
      Styles.Selection = Summer
      Styles.Footer = Winter
      Styles.Header = Spring
      Styles.Indicator = Winter
      Styles.StyleSheet = UserStyleSheet
    end
    object cxLevel1: TcxGridLevel
      GridView = cxView1
    end
  end
  object DataSource1: TDataSource
    DataSet = FDM.SQLQuery
    Left = 488
    Top = 230
  end
  object StyleRepository: TcxStyleRepository
    Left = 458
    Top = 230
    PixelsPerInch = 96
    object Sunny: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 14811135
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      TextColor = clNavy
    end
    object Dark: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 15451300
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      TextColor = clWhite
    end
    object Golden: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 4707838
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      TextColor = clBlack
    end
    object Summer: TcxStyle
      AssignedValues = [svColor, svFont]
      Color = 15451300
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
    end
    object Autumn: TcxStyle
      AssignedValues = [svColor, svFont]
      Color = clBtnFace
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
    end
    object Bright: TcxStyle
      AssignedValues = [svColor, svFont]
      Color = 16749885
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
    end
    object Cold: TcxStyle
      AssignedValues = [svColor, svFont]
      Color = 14872561
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
    end
    object Spring: TcxStyle
      AssignedValues = [svColor, svFont]
      Color = 16247513
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
    end
    object Light: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 14811135
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      TextColor = clBlack
    end
    object Winter: TcxStyle
      AssignedValues = [svColor, svFont]
      Color = clWhite
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
    end
    object Depth: TcxStyle
      AssignedValues = [svColor, svFont, svTextColor]
      Color = 12937777
      Font.Charset = GB2312_CHARSET
      Font.Color = clWhite
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      TextColor = clWhite
    end
    object UserStyleSheet: TcxGridTableViewStyleSheet
      Caption = 'User Defined Style Sheet'
      Styles.Background = Dark
      Styles.Content = Spring
      Styles.ContentEven = Autumn
      Styles.ContentOdd = Spring
      Styles.FilterBox = Sunny
      Styles.Inactive = Summer
      Styles.IncSearch = Golden
      Styles.Selection = Bright
      Styles.Footer = Light
      Styles.Group = Cold
      Styles.GroupByBox = Golden
      Styles.Header = Depth
      Styles.Indicator = Autumn
      Styles.Preview = Winter
      BuiltIn = True
    end
  end
end
