object StatsSelectForm: TStatsSelectForm
  Left = 281
  Top = 104
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Statistics Report Selection'
  ClientHeight = 367
  ClientWidth = 302
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object Label103: TLabel
    Left = 16
    Top = 75
    Width = 93
    Height = 15
    Caption = 'Variable Analyzed'
  end
  object Label104: TLabel
    Left = 16
    Top = 107
    Width = 96
    Height = 15
    Caption = 'Event Time Period'
  end
  object Label102: TLabel
    Left = 16
    Top = 46
    Width = 70
    Height = 15
    Caption = 'Object Name'
  end
  object Label101: TLabel
    Left = 16
    Top = 11
    Width = 86
    Height = 15
    Caption = 'Object Category'
  end
  object Label105: TLabel
    Left = 16
    Top = 139
    Width = 41
    Height = 15
    Caption = 'Statistic'
  end
  object ObjectTypeCombo: TComboBox
    Left = 144
    Top = 8
    Width = 137
    Height = 23
    Style = csDropDownList
    TabOrder = 0
    OnClick = ObjectTypeComboClick
    Items.Strings = (
      'Subcatchment'
      'Node'
      'Link'
      'System')
  end
  object ObjectIDEdit: TEdit
    Left = 144
    Top = 40
    Width = 137
    Height = 23
    TabOrder = 1
  end
  object TimePeriodCombo: TComboBox
    Left = 144
    Top = 104
    Width = 137
    Height = 23
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 4
    Text = 'Event-Dependent'
    OnClick = TimePeriodComboClick
    Items.Strings = (
      'Event-Dependent'
      'Daily'
      'Monthly'
      'Annual')
  end
  object StatsTypeCombo: TComboBox
    Left = 144
    Top = 136
    Width = 137
    Height = 23
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 5
    Text = 'Mean'
    Items.Strings = (
      'Mean'
      'Peak')
  end
  object VariableCombo: TComboBox
    Left = 144
    Top = 72
    Width = 137
    Height = 23
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 3
    Text = 'Rainfall'
    OnClick = VariableComboClick
    Items.Strings = (
      'Rainfall'
      'Losses'
      'Runoff')
  end
  object BtnOK: TButton
    Left = 23
    Top = 320
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 7
    OnClick = BtnOKClick
  end
  object BtnCancel: TButton
    Left = 111
    Top = 320
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 8
    OnClick = BtnCancelClick
  end
  object BtnHelp: TButton
    Left = 199
    Top = 320
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 9
    OnClick = BtnHelpClick
  end
  object ObjectIDBtn: TBitBtn
    Left = 262
    Top = 42
    Width = 17
    Height = 17
    Glyph.Data = {
      96000000424D9600000000000000760000002800000008000000080000000100
      0400000000002000000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FFFFFFFFFFFF
      FFFFFF44FFFFFF44FFFF444444FF444444FFFF44FFFFFF44FFFF}
    TabOrder = 2
    OnClick = ObjectIDBtnClick
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 176
    Width = 265
    Height = 121
    Caption = 'Event Thresholds'
    TabOrder = 6
    object Label109: TLabel
      Left = 16
      Top = 23
      Width = 88
      Height = 15
      Caption = 'Analysis Variable'
    end
    object Label110: TLabel
      Left = 16
      Top = 55
      Width = 73
      Height = 15
      Caption = 'Event Volume'
    end
    object Label111: TLabel
      Left = 16
      Top = 87
      Width = 86
      Height = 15
      Caption = 'Separation Time'
    end
    object MinValueEdit: TNumEdit
      Left = 176
      Top = 20
      Width = 65
      Height = 23
      TabOrder = 0
      Text = '0'
      Style = esNumber
      Modified = False
      SelLength = 0
      SelStart = 0
    end
    object MinVolEdit: TNumEdit
      Left = 176
      Top = 52
      Width = 65
      Height = 23
      TabOrder = 1
      Text = '0'
      Style = esNumber
      Modified = False
      SelLength = 0
      SelStart = 0
    end
    object MinDeltaEdit: TNumEdit
      Left = 176
      Top = 84
      Width = 65
      Height = 23
      TabOrder = 2
      Text = '6'
      Style = esNumber
      Modified = False
      SelLength = 0
      SelStart = 0
    end
  end
end
