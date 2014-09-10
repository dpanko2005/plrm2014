object VolumeDischargeForm: TVolumeDischargeForm
  Left = 412
  Top = 135
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Volume-Discharge Curve Editor'
  ClientHeight = 371
  ClientWidth = 457
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 421
    Height = 32
    Caption = 
      'Note: Changing these values will overwrite any previously entere' +
      'd values for drawdown time or infiltration rate.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    WordWrap = True
  end
  object BtnSave: TButton
    Left = 359
    Top = 256
    Width = 90
    Height = 26
    Caption = 'Save and Close'
    TabOrder = 0
    OnClick = BtnSaveClick
  end
  object BtnCancel: TButton
    Left = 359
    Top = 320
    Width = 90
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
    Visible = False
    OnClick = BtnCancelClick
  end
  object sgVolDischarge: TStringGrid
    Left = 8
    Top = 48
    Width = 345
    Height = 297
    BevelEdges = []
    BevelInner = bvNone
    BevelOuter = bvNone
    ColCount = 3
    DefaultColWidth = 110
    DefaultRowHeight = 23
    FixedColor = cl3DLight
    RowCount = 12
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clDefault
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor]
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 2
    OnKeyPress = sgVolDischargeKeyPress
  end
  object btnAutoCalc: TButton
    Left = 359
    Top = 288
    Width = 90
    Height = 26
    Caption = 'Auto Calculate'
    TabOrder = 3
    WordWrap = True
    OnClick = btnAutoCalcClick
  end
  object statBar: TStatusBar
    Left = 0
    Top = 352
    Width = 457
    Height = 19
    Panels = <>
    SimplePanel = True
  end
end
