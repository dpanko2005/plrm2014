object InfilForm: TInfilForm
  Left = 198
  Top = 110
  BorderStyle = bsDialog
  Caption = 'Infiltration Editor'
  ClientHeight = 305
  ClientWidth = 279
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 41
    Width = 279
    Height = 152
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 279
    Height = 41
    Align = alTop
    Alignment = taLeftJustify
    BevelOuter = bvNone
    Caption = '  Infiltration Method'
    Padding.Left = 4
    Padding.Top = 4
    Padding.Right = 4
    TabOrder = 0
    object ComboBox1: TComboBox
      Left = 136
      Top = 10
      Width = 125
      Height = 23
      Style = csDropDownList
      TabOrder = 0
      OnChange = ComboBox1Change
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 249
    Width = 279
    Height = 56
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object OKBtn: TButton
      Left = 11
      Top = 16
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = OKBtnClick
    end
    object CancleBtn: TButton
      Left = 99
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object HelpBtn: TButton
      Left = 187
      Top = 16
      Width = 75
      Height = 25
      Caption = '&Help'
      TabOrder = 2
      OnClick = HelpBtnClick
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 193
    Width = 279
    Height = 56
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 1
    BorderStyle = bsSingle
    Ctl3D = False
    Padding.Left = 2
    Padding.Top = 2
    Padding.Right = 2
    Padding.Bottom = 2
    ParentBackground = False
    ParentCtl3D = False
    TabOrder = 3
    object HintLabel: TLabel
      Left = 3
      Top = 3
      Width = 271
      Height = 48
      Align = alClient
      Caption = 'HintLabel'
      Transparent = True
      WordWrap = True
      ExplicitWidth = 51
      ExplicitHeight = 15
    end
  end
end
