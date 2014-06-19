object FGlobalCatch: TFGlobalCatch
  Left = 0
  Top = 0
  BorderIcons = []
  ClientHeight = 465
  ClientWidth = 745
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox3: TGroupBox
    Left = 2
    Top = 16
    Width = 743
    Height = 185
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Catchment Parameters'
    TabOrder = 0
    object DBGrid1: TDBGrid
      Left = 14
      Top = 32
      Width = 726
      Height = 120
      Margins.Left = 2
      Margins.Top = 2
      Margins.Right = 2
      Margins.Bottom = 2
      DataSource = DataSource1
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'catchName'
          Width = 119
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'area'
          Width = 83
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'slope'
          Width = 107
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'flowDistance'
          Width = 162
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'landUse'
          Width = 106
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'soils'
          Width = 97
          Visible = True
        end>
    end
  end
  object Button2: TButton
    Left = 646
    Top = 430
    Width = 91
    Height = 24
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Save and Exit'
    TabOrder = 1
  end
  object btnCloseFrm: TButton
    Left = 569
    Top = 430
    Width = 71
    Height = 24
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Cancel'
    TabOrder = 2
  end
  object btnHelp: TButton
    Left = 516
    Top = 430
    Width = 47
    Height = 24
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Help'
    TabOrder = 3
  end
  object Button1: TButton
    Left = 516
    Top = 399
    Width = 221
    Height = 25
    Margins.Left = 2
    Margins.Top = 2
    Margins.Right = 2
    Margins.Bottom = 2
    Caption = 'Define Source Controls'
    TabOrder = 4
  end
  object ADOTable1: TADOTable
    CursorType = ctStatic
    TableName = 'UserCatchments'
    Left = 48
    Top = 440
  end
  object DataSource1: TDataSource
    DataSet = ADOTable1
    Left = 16
    Top = 440
  end
end
