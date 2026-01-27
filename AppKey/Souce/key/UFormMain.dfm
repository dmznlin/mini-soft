object fFormMain: TfFormMain
  Left = 557
  Top = 463
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Key'
  ClientHeight = 204
  ClientWidth = 252
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object BtnOK: TButton
    Left = 88
    Top = 170
    Width = 75
    Height = 25
    Caption = #29983#25104
    TabOrder = 0
    OnClick = BtnOKClick
  end
  object wPanel: TPanel
    Left = 8
    Top = 8
    Width = 235
    Height = 155
    BevelInner = bvRaised
    BevelOuter = bvLowered
    TabOrder = 1
    object wPage: TPageControl
      Left = 2
      Top = 2
      Width = 231
      Height = 151
      ActivePage = TabSheet2
      Align = alClient
      Style = tsFlatButtons
      TabOrder = 0
      object TabSheet1: TTabSheet
        Caption = #25480#26435#20449#24687
        object Label1: TLabel
          Left = 5
          Top = 12
          Width = 102
          Height = 12
          Caption = #36873#25321#31995#32479#30340#26377#25928#26399':'
          Transparent = True
        end
        object Label2: TLabel
          Left = 5
          Top = 65
          Width = 90
          Height = 12
          Caption = #29983#25104#23494#38053#25991#20214#21517':'
          Transparent = True
        end
        object EditDate: TDateTimePicker
          Left = 5
          Top = 32
          Width = 201
          Height = 20
          Date = 42874.631509814810000000
          Format = 'yyyy-MM-dd'
          Time = 42874.631509814810000000
          TabOrder = 0
        end
        object EditFile: TEdit
          Left = 5
          Top = 88
          Width = 201
          Height = 20
          ReadOnly = True
          TabOrder = 1
          Text = 'Lock.ini'
        end
      end
      object TabSheet2: TTabSheet
        Caption = #32593#32476#25480#26435
        ImageIndex = 1
        object Label3: TLabel
          Left = 5
          Top = 65
          Width = 60
          Height = 12
          Caption = #26381#21153#22120'URL:'
          Transparent = True
        end
        object Label4: TLabel
          Left = 5
          Top = 12
          Width = 60
          Height = 12
          Caption = #24212#29992'Token:'
          Transparent = True
        end
        object EditServer: TEdit
          Left = 5
          Top = 88
          Width = 201
          Height = 20
          ReadOnly = True
          TabOrder = 0
        end
        object EditToken: TEdit
          Left = 5
          Top = 32
          Width = 201
          Height = 20
          ReadOnly = True
          TabOrder = 1
        end
      end
    end
  end
end
