object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'JSONValue Helper'
  ClientHeight = 779
  ClientWidth = 846
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = MainMenu
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object Splitter: TSplitter
    Left = 0
    Top = 625
    Width = 846
    Height = 8
    Cursor = crVSplit
    Align = alTop
    ExplicitLeft = -8
    ExplicitTop = 499
  end
  object SynEdit: TSynEdit
    Left = 0
    Top = 73
    Width = 846
    Height = 552
    Align = alTop
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    Font.Quality = fqClearTypeNatural
    TabOrder = 0
    UseCodeFolding = False
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Consolas'
    Gutter.Font.Style = []
    Gutter.Bands = <
      item
        Kind = gbkMarks
        Width = 13
      end
      item
        Kind = gbkLineNumbers
      end
      item
        Kind = gbkFold
      end
      item
        Kind = gbkTrackChanges
      end
      item
        Kind = gbkMargin
        Width = 3
      end>
    Highlighter = SynJSONSyn
    Lines.Strings = (
      'SynEdit')
    RightEdge = 0
    SelectedColor.Alpha = 0.400000005960464500
  end
  object PanelBar: TPanel
    Left = 0
    Top = 0
    Width = 846
    Height = 73
    Align = alTop
    BevelOuter = bvNone
    Caption = 'PanelBar'
    TabOrder = 1
    object LblValuePath: TLabel
      Left = 8
      Top = 13
      Width = 117
      Height = 15
      Caption = 'The value search path:'
    end
    object BtnGetValue: TButton
      Left = 320
      Top = 32
      Width = 105
      Height = 25
      Caption = 'Get Value'
      TabOrder = 0
      OnClick = BtnGetValueClick
    end
    object edValueName: TEdit
      Left = 8
      Top = 34
      Width = 281
      Height = 23
      TabOrder = 1
      Text = 'edValueName'
    end
    object BtnDeSerialize: TButton
      Left = 446
      Top = 32
      Width = 107
      Height = 25
      Caption = 'DeSerialize'
      TabOrder = 2
      OnClick = BtnDeSerializeClick
    end
  end
  object Memo: TMemo
    Left = 0
    Top = 633
    Width = 846
    Height = 146
    Align = alClient
    Lines.Strings = (
      'Memo')
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object MainMenu: TMainMenu
    Left = 400
    Top = 144
    object MenuFile: TMenuItem
      Caption = 'File'
      object MenuOpenJSON: TMenuItem
        Caption = 'Open JSON File'
        OnClick = MenuOpenJSONClick
      end
      object MenuSpliet: TMenuItem
        Caption = '-'
      end
      object MenuExit: TMenuItem
        Caption = 'Exit'
      end
    end
    object MenuHelp: TMenuItem
      Caption = 'Help'
      object MenuAbout: TMenuItem
        Caption = 'About'
      end
    end
  end
  object OpenDialog: TOpenDialog
    Filter = 'JSON Files (*.json)|*.json|Text File (*.txt)|*.txt'
    Left = 304
    Top = 144
  end
  object SynJSONSyn: TSynJSONSyn
    Left = 504
    Top = 144
  end
end
