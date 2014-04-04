object TreatmentForm: TTreatmentForm
  Left = 192
  Top = 107
  BorderStyle = bsDialog
  Caption = 'Treatment Editor'
  ClientHeight = 329
  ClientWidth = 495
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object OKBtn: TButton
    Left = 222
    Top = 288
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 310
    Top = 288
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object HelpBtn: TButton
    Left = 400
    Top = 288
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 3
    OnClick = HelpBtnClick
  end
  object Panel1: TPanel
    Left = 16
    Top = 16
    Width = 461
    Height = 249
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 0
      Top = 131
      Width = 459
      Height = 3
      Cursor = crVSplit
      Align = alTop
      Beveled = True
      ExplicitWidth = 461
    end
    object HintMemo: TMemo
      Left = 0
      Top = 134
      Width = 459
      Height = 113
      Align = alClient
      BorderStyle = bsNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        'HintMemo')
      ParentColor = True
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 1
    end
    object Grid: TStringGrid
      Left = 0
      Top = 0
      Width = 459
      Height = 131
      Align = alTop
      BorderStyle = bsNone
      ColCount = 2
      Ctl3D = False
      DefaultColWidth = 128
      DrawingStyle = gdsClassic
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing]
      ParentCtl3D = False
      TabOrder = 0
    end
  end
end
