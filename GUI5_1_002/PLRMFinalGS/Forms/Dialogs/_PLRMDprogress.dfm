object plrmProgress: TplrmProgress
  Left = 227
  Top = 108
  BorderStyle = bsDialog
  Caption = 'Generating Meterological Data'
  ClientHeight = 179
  ClientWidth = 384
  Color = clBtnFace
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 8
    Width = 368
    Height = 161
    Shape = bsFrame
  end
  object lblProgress: TLabel
    Left = 18
    Top = 43
    Width = 349
    Height = 39
    Caption = 
      'You are requesting generation of meteorological data for Met Gri' +
      'd # <P1>.  First time data generation takes up to 5 minutes.  Do' +
      ' you wish to proceed? '
    WordWrap = True
  end
  object Label2: TLabel
    Left = 160
    Top = 24
    Width = 54
    Height = 13
    Caption = 'Attention'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold, fsUnderline]
    ParentFont = False
  end
  object OKBtn: TButton
    Left = 112
    Top = 101
    Width = 75
    Height = 25
    Caption = 'Yes'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 193
    Top = 101
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
    OnClick = CancelBtnClick
  end
  object progBar: TProgressBar
    Left = 24
    Top = 136
    Width = 337
    Height = 17
    Step = 1
    TabOrder = 2
  end
end
