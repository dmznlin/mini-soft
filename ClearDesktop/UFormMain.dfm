object fFormMain: TfFormMain
  Left = 517
  Top = 323
  Width = 180
  Height = 327
  BorderIcons = [biSystemMenu]
  Color = clBtnFace
  Constraints.MinHeight = 320
  Constraints.MinWidth = 165
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object StatusBar1: TStatusBar
    Left = 0
    Top = 281
    Width = 172
    Height = 19
    Panels = <>
  end
  object wPage: TPageControl
    Left = 0
    Top = 0
    Width = 172
    Height = 281
    ActivePage = TabSheet1
    Align = alClient
    Style = tsFlatButtons
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #26700#38754#25972#29702
      object ListKey: TListBox
        Left = 0
        Top = 0
        Width = 164
        Height = 219
        Style = lbOwnerDrawFixed
        Align = alClient
        DragMode = dmAutomatic
        ItemHeight = 20
        Items.Strings = (
          'aa'
          'bb'
          'cc')
        PopupMenu = PMenu1
        TabOrder = 0
        OnDragOver = ListKeyDragOver
        OnEndDrag = ListKeyEndDrag
      end
      object Panel1: TPanel
        Left = 0
        Top = 219
        Width = 164
        Height = 32
        Align = alBottom
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          164
          32)
        object BtnClear: TButton
          Left = 11
          Top = 7
          Width = 65
          Height = 22
          Anchors = [akTop, akRight]
          Caption = #25972#29702
          TabOrder = 0
          OnClick = BtnClearClick
        end
        object BtnRestore: TButton
          Left = 85
          Top = 7
          Width = 65
          Height = 22
          Anchors = [akTop, akRight]
          Caption = #36824#21407
          TabOrder = 1
          OnClick = BtnRestoreClick
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #36824#21407
      ImageIndex = 1
      TabVisible = False
      object ListBox2: TListBox
        Left = 0
        Top = 0
        Width = 164
        Height = 251
        Style = lbOwnerDrawFixed
        Align = alClient
        ItemHeight = 20
        Items.Strings = (
          'aa'
          'bb'
          'cc')
        PopupMenu = PMenu1
        TabOrder = 0
      end
    end
  end
  object ZnHideForm1: TZnHideForm
    AutoDock = True
    AlwaysTop = True
    EdgeSpace = 3
    ValidSpace = 5
    Left = 7
    Top = 114
  end
  object TrayIcon1: TTrayIcon
    Visible = True
    PopupMenu = PMenu1
    Hide = True
    RestoreOn = imDoubleClick
    PopupMenuOn = imRightClickUp
    IconIndex = 0
    Left = 35
    Top = 114
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 7
    Top = 142
    object N2: TMenuItem
      Caption = #28155#21152#20869#23481
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = #21024#38500#20869#23481
      OnClick = N3Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object N1: TMenuItem
      Caption = #36864#20986#31243#24207
      OnClick = N1Click
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 35
    Top = 142
  end
end
