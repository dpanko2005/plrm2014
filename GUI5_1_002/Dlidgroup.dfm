object LidGroupDlg: TLidGroupDlg
  Left = 192
  Top = 114
  BorderStyle = bsDialog
  Caption = 'LID Controls'
  ClientHeight = 238
  ClientWidth = 577
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
  object OkBtn: TButton
    Left = 312
    Top = 192
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 4
    OnClick = OkBtnClick
  end
  object CancelBtn: TButton
    Left = 400
    Top = 192
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 5
  end
  object StringGrid1: TStringGrid
    Left = 16
    Top = 16
    Width = 457
    Height = 153
    ColCount = 13
    Ctl3D = True
    DefaultColWidth = 90
    FixedCols = 0
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    ParentCtl3D = False
    ScrollBars = ssVertical
    TabOrder = 0
    OnClick = StringGrid1Click
    OnKeyDown = StringGrid1KeyDown
  end
  object HelpBtn: TButton
    Left = 488
    Top = 192
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 6
    OnClick = HelpBtnClick
  end
  object BtnAdd: TButton
    Left = 488
    Top = 16
    Width = 75
    Height = 25
    Caption = 'Add'
    TabOrder = 1
    OnClick = BtnAddClick
  end
  object BtnEdit: TButton
    Left = 488
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Edit'
    TabOrder = 2
    OnClick = BtnEditClick
  end
  object BtnDelete: TButton
    Left = 488
    Top = 96
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 3
    OnClick = BtnDeleteClick
  end
end
