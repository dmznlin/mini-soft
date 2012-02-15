object Form1: TForm1
  Left = 394
  Top = 406
  Width = 384
  Height = 293
  Caption = 'Form1'
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
  object dd: TcxLookupComboBox
    Left = 70
    Top = 102
    ParentFont = False
    Properties.ListColumns = <
      item
      end>
    Properties.ListOptions.GridLines = glVertical
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clWindowText
    Style.Font.Height = -12
    Style.Font.Name = #23435#20307
    Style.Font.Style = []
    Style.IsFontAssigned = True
    TabOrder = 0
    Width = 259
  end
  object Button1: TButton
    Left = 134
    Top = 152
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 272
    Top = 164
    Width = 75
    Height = 25
    Caption = 'Button2'
    TabOrder = 2
    OnClick = Button2Click
  end
  object ADOConnection1: TADOConnection
    Connected = True
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=sa;Persist Security Info=True;User ' +
      'ID=sa;Initial Catalog=HJData;Data Source=.'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 18
    Top = 32
  end
  object cxLookAndFeelController1: TcxLookAndFeelController
    Kind = lfOffice11
    Left = 48
    Top = 36
  end
end
