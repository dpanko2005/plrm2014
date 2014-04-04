object frmPLRMStats: TfrmPLRMStats
  Left = 281
  Top = 104
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Statistics Selection'
  ClientHeight = 449
  ClientWidth = 616
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 22
    Width = 78
    Height = 13
    Caption = 'Load Output File'
  end
  object BtnOK: TButton
    Left = 144
    Top = 88
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
    OnClick = BtnOKClick
  end
  object tbxOutputFileName: TEdit
    Left = 144
    Top = 19
    Width = 273
    Height = 21
    TabOrder = 1
  end
  object Button1: TButton
    Left = 423
    Top = 17
    Width = 75
    Height = 25
    Caption = 'Load'
    TabOrder = 2
    OnClick = Button1Click
  end
  object dlgOpenOutputFile: TOpenDialog
    Left = 288
    Top = 408
  end
end
