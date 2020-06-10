object Form1: TForm1
  Left = 258
  Top = 243
  Width = 786
  Height = 713
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PopupMenu = PopupMenu1
  OnCreate = FormCreate
  DesignSize = (
    778
    667)
  PixelsPerInch = 96
  TextHeight = 12
  object Memo1: TMemo
    Left = 6
    Top = 74
    Width = 677
    Height = 171
    Anchors = [akLeft, akTop, akRight]
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 6
    Top = 38
    Width = 679
    Height = 20
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'D:\MyWork\'#20018#21475#36890#35759'\Bin\Lang.xml'
  end
  object Button2: TButton
    Left = 692
    Top = 38
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'load'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 690
    Top = 74
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'trans'
    TabOrder = 3
    OnClick = Button3Click
  end
  object ToolBar1: TToolBar
    Left = 0
    Top = 0
    Width = 778
    Height = 29
    ButtonHeight = 20
    ButtonWidth = 31
    Caption = 'ToolBar1'
    ShowCaptions = True
    TabOrder = 4
    object ToolButton1: TToolButton
      Left = 0
      Top = 2
      Caption = #25991#20214
      ImageIndex = 0
    end
    object ToolButton2: TToolButton
      Left = 31
      Top = 2
      Caption = #32534#36753
      ImageIndex = 1
    end
  end
  object Button1: TButton
    Left = 690
    Top = 110
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'lang'
    TabOrder = 5
    OnClick = Button1Click
  end
  object cxMCListBox1: TcxMCListBox
    Left = 14
    Top = 256
    Width = 369
    Height = 225
    HeaderSections = <
      item
        Text = 'Section #1'
        Width = 74
      end>
    TabOrder = 6
  end
  object dxLayoutControl1: TdxLayoutControl
    Left = 402
    Top = 278
    Width = 291
    Height = 305
    TabOrder = 7
    TabStop = False
    object cxTextEdit1: TcxTextEdit
      Left = 96
      Top = 29
      TabOrder = 0
      Text = #26102#38388': %s'
      Width = 121
    end
    object Button5: TButton
      Left = 11
      Top = 68
      Width = 75
      Height = 25
      Caption = 'Button5'
      TabOrder = 1
      OnClick = Button5Click
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        Caption = 'New Group'
        object dxLayoutControl1Item1: TdxLayoutItem
          Caption = 'cxTextEdit1'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Item2: TdxLayoutItem
        Caption = 'Button5'
        ShowCaption = False
        Control = Button5
        ControlOptions.ShowBorder = False
      end
    end
  end
  object cxRadioGroup1: TcxRadioGroup
    Left = 34
    Top = 542
    Caption = 'cxRadioGroup1'
    Properties.Items = <>
    TabOrder = 8
    Height = 43
    Width = 199
  end
  object cxGroupBox1: TcxGroupBox
    Left = 218
    Top = 500
    Caption = 'cxGroupBox1'
    TabOrder = 9
    Height = 101
    Width = 163
  end
  object dxNavBar1: TdxNavBar
    Left = 28
    Top = 416
    Width = 117
    Height = 115
    ActiveGroupIndex = 0
    TabOrder = 10
    View = 0
    object dxNavBar1Group1: TdxNavBarGroup
      Caption = 'dxNavBar1Group1'
      SelectedLinkIndex = -1
      TopVisibleLinkIndex = 0
      Links = <
        item
          Item = dxNavBar1Item1
        end>
    end
    object dxNavBar1Item1: TdxNavBarItem
      Caption = 'dxNavBar1Item1'
    end
  end
  object cxPageControl1: TcxPageControl
    Left = 478
    Top = 454
    Width = 289
    Height = 193
    ActivePage = cxTabSheet1
    TabOrder = 11
    ClientRectBottom = 193
    ClientRectRight = 289
    ClientRectTop = 23
    object cxTabSheet1: TcxTabSheet
      Caption = 'cxTabSheet1'
      ImageIndex = 0
    end
    object cxTabSheet2: TcxTabSheet
      Caption = 'cxTabSheet2'
      ImageIndex = 1
    end
  end
  object cxButton1: TcxButton
    Left = 48
    Top = 594
    Width = 75
    Height = 25
    Caption = 'cxButton1'
    TabOrder = 12
  end
  object Button4: TButton
    Left = 690
    Top = 142
    Width = 75
    Height = 25
    Caption = 'Button4'
    TabOrder = 13
    OnClick = Button4Click
  end
  object Panel1: TPanel
    Left = 552
    Top = 220
    Width = 185
    Height = 41
    Caption = 'Panel1'
    TabOrder = 14
  end
  object BitBtn1: TBitBtn
    Left = 288
    Top = 628
    Width = 75
    Height = 25
    Caption = 'BitBtn1'
    TabOrder = 15
  end
  object StaticText1: TStaticText
    Left = 162
    Top = 614
    Width = 70
    Height = 16
    Caption = 'StaticText1'
    TabOrder = 16
  end
  object cxCheckBox1: TcxCheckBox
    Left = 64
    Top = 638
    Caption = 'cxCheckBox1'
    TabOrder = 17
    Width = 121
  end
  object MainMenu1: TMainMenu
    AutoHotkeys = maManual
    Left = 176
    Top = 96
    object N1: TMenuItem
      Caption = #25991#20214
    end
    object N2: TMenuItem
      Caption = #32534#36753
    end
    object N3: TMenuItem
      Caption = #24110#21161
    end
  end
  object PopupMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 148
    Top = 98
    object N4: TMenuItem
      Caption = #25991#20214
      object N5: TMenuItem
        Caption = #25991#20214
      end
      object N6: TMenuItem
        Caption = #32534#36753
      end
      object N7: TMenuItem
        Caption = #25991#20214
        object N8: TMenuItem
          Caption = #25991#20214
        end
        object N9: TMenuItem
          Caption = #32534#36753
        end
      end
    end
    object N10: TMenuItem
      Caption = #32534#36753
    end
    object N11: TMenuItem
      Caption = #24110#21161
    end
  end
end
