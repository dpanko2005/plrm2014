object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'LID Usage Editor'
  ClientHeight = 330
  ClientWidth = 551
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object OkBtn: TButton
    Left = 254
    Top = 289
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object CancelBtn: TButton
    Left = 348
    Top = 289
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
  end
  object HelpBtn: TButton
    Left = 436
    Top = 289
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 2
  end
end
