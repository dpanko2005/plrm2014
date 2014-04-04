object FGlobalCatch: TFGlobalCatch
  Left = 0
  Top = 0
  ClientHeight = 608
  ClientWidth = 974
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 17
  object GroupBox3: TGroupBox
    Left = 3
    Top = 21
    Width = 971
    Height = 242
    Caption = 'Catchment Parameters'
    TabOrder = 0
    object DBGrid1: TDBGrid
      Left = 18
      Top = 42
      Width = 950
      Height = 157
      DataSource = DataSource1
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -14
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
    Left = 845
    Top = 562
    Width = 119
    Height = 32
    Caption = 'Save and Exit'
    TabOrder = 1
  end
  object btnCloseFrm: TButton
    Left = 744
    Top = 562
    Width = 93
    Height = 32
    Caption = 'Cancel'
    TabOrder = 2
  end
  object btnHelp: TButton
    Left = 675
    Top = 562
    Width = 61
    Height = 32
    Caption = 'Help'
    TabOrder = 3
  end
  object Button1: TButton
    Left = 675
    Top = 522
    Width = 289
    Height = 32
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
