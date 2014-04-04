object ControlsForm: TControlsForm
  Left = 265
  Top = 163
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSizeToolWin
  Caption = 'Control Rules Editor'
  ClientHeight = 384
  ClientWidth = 568
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poMainFormCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 15
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 568
    Height = 312
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
    ExplicitHeight = 308
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 353
    Width = 568
    Height = 31
    Panels = <
      item
        Text = ' Click Help to review the format of Control Rule statements.'
        Width = 40
      end>
    ParentFont = True
    UseSystemFont = False
    ExplicitTop = 349
  end
  object Panel1: TPanel
    Left = 0
    Top = 312
    Width = 568
    Height = 41
    Align = alBottom
    Alignment = taLeftJustify
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 308
    object Panel2: TPanel
      Left = 271
      Top = 0
      Width = 297
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object BtnOK: TButton
        Left = 10
        Top = 8
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
        OnClick = BtnOKClick
      end
      object BtnCancel: TButton
        Left = 106
        Top = 8
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 1
      end
      object BtnHelp: TButton
        Left = 202
        Top = 8
        Width = 75
        Height = 25
        Caption = '&Help'
        TabOrder = 2
        OnClick = BtnHelpClick
      end
    end
  end
end
