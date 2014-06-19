object Form7: TForm7
  Left = 0
  Top = 0
  BorderIcons = []
  Caption = 'Form7'
  ClientHeight = 294
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object DBGrid1: TDBGrid
    Left = 24
    Top = 24
    Width = 497
    Height = 209
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
  end
  object DataSource1: TDataSource
    DataSet = ADOTable1
    Left = 16
    Top = 256
  end
  object ADOTable1: TADOTable
    CursorType = ctStatic
    EnableBCD = False
    TableName = 'BMP_Parameters'
    Left = 56
    Top = 256
  end
end
