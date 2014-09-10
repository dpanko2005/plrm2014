object CurveDataForm: TCurveDataForm
  Left = 412
  Top = 135
  BorderStyle = bsDialog
  Caption = 'Curve Editor'
  ClientHeight = 374
  ClientWidth = 337
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 66
    Height = 15
    Caption = 'Curve Name'
  end
  object Label3: TLabel
    Left = 16
    Top = 55
    Width = 60
    Height = 15
    Caption = 'Description'
  end
  object CurveTypeLabel: TLabel
    Left = 200
    Top = 8
    Width = 61
    Height = 15
    Caption = 'Pump Type'
  end
  object CurveName: TEdit
    Left = 16
    Top = 24
    Width = 149
    Height = 23
    TabOrder = 0
    OnChange = CurveNameChange
    OnKeyPress = CurveNameKeyPress
  end
  object Comment: TEdit
    Left = 16
    Top = 71
    Width = 273
    Height = 23
    TabOrder = 2
    OnChange = CurveNameChange
  end
  object BtnOK: TButton
    Left = 240
    Top = 250
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 8
    OnClick = BtnOKClick
  end
  object BtnCancel: TButton
    Left = 240
    Top = 290
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 9
  end
  object BtnHelp: TButton
    Left = 240
    Top = 330
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 10
    OnClick = BtnHelpClick
  end
  object BtnLoad: TButton
    Left = 240
    Top = 144
    Width = 75
    Height = 25
    Caption = '&Load...'
    TabOrder = 6
    OnClick = BtnLoadClick
  end
  object BtnSave: TButton
    Left = 240
    Top = 184
    Width = 75
    Height = 25
    Caption = '&Save...'
    TabOrder = 7
    OnClick = BtnSaveClick
  end
  object BtnView: TButton
    Left = 240
    Top = 104
    Width = 75
    Height = 25
    Caption = '&View...'
    TabOrder = 5
    OnClick = BtnViewClick
  end
  object CurveTypeCombo: TComboBox
    Left = 200
    Top = 24
    Width = 113
    Height = 23
    Style = csDropDownList
    TabOrder = 1
    OnChange = CurveNameChange
    OnClick = CurveTypeComboClick
  end
  inline GridEdit: TGridEditFrame
    Left = 16
    Top = 104
    Width = 201
    Height = 253
    TabOrder = 4
    ExplicitLeft = 16
    ExplicitTop = 104
    ExplicitWidth = 201
    ExplicitHeight = 253
    inherited Grid: TStringGrid
      Width = 201
      Height = 253
      ColCount = 3
      RowCount = 101
      ExplicitWidth = 201
      ExplicitHeight = 253
    end
  end
  object EditBtn: TBitBtn
    Tag = 1
    Left = 290
    Top = 71
    Width = 21
    Height = 21
    Hint = 'Edit'
    Glyph.Data = {
      4E010000424D4E01000000000000760000002800000012000000120000000100
      040000000000D800000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
      7777770000007777777777777777770000007777777777777777770000007777
      7777000007077700000077777770BFBFB007770000007707777000FBFB077700
      00007770070FBFBFBF07770000007770B00000FBFB077700000077770FBFBFBF
      BF0777000000777770000000FB07770000007777770B00BFB007770000007777
      7770B000077777000000777777770B077777770000007777777770B077777700
      0000777777777709077777000000777777777770777777000000777777777777
      777777000000777777777777777777000000}
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = EditBtnClick
  end
end
