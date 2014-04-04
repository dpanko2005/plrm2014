object FcatchProp: TFcatchProp
  Left = 0
  Top = 0
  Caption = 'Catchment Properties'
  ClientHeight = 311
  ClientWidth = 356
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 17
  object DBGrid1: TDBGrid
    Left = 10
    Top = 10
    Width = 337
    Height = 148
    DataSource = DataSource2
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -14
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Property'
        Width = 145
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Value'
        Width = 75
        Visible = True
      end>
  end
  object Button1: TButton
    Left = 10
    Top = 178
    Width = 337
    Height = 33
    Caption = 'Edit Soils Properties'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -22
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object Button2: TButton
    Left = 10
    Top = 218
    Width = 337
    Height = 33
    Caption = 'Edit Land Uses'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -22
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object Button3: TButton
    Left = 10
    Top = 259
    Width = 337
    Height = 33
    Caption = 'Define Source Controls'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -22
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object ADOTable2: TADOTable
    CursorType = ctStatic
    TableName = 'CatchProperties'
    Left = 8
    Top = 336
  end
  object DataSource2: TDataSource
    DataSet = ADOTable2
    Left = 40
    Top = 336
  end
end
