object TransectForm: TTransectForm
  Left = 211
  Top = 109
  BorderStyle = bsDialog
  Caption = 'Transect Editor'
  ClientHeight = 425
  ClientWidth = 456
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 80
    Height = 15
    Caption = 'Transect Name'
  end
  object Label3: TLabel
    Left = 184
    Top = 7
    Width = 60
    Height = 15
    Caption = 'Description'
  end
  object NameEdit: TEdit
    Left = 16
    Top = 23
    Width = 145
    Height = 23
    TabOrder = 0
    OnChange = NameEditChange
    OnKeyPress = NameEditKeyPress
  end
  object CommentEdit: TEdit
    Left = 184
    Top = 23
    Width = 233
    Height = 23
    TabOrder = 1
    OnChange = NameEditChange
  end
  object BtnOK: TButton
    Left = 184
    Top = 384
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 6
    OnClick = BtnOKClick
  end
  object BtnCancel: TButton
    Left = 271
    Top = 384
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 7
  end
  object BtnHelp: TButton
    Left = 358
    Top = 384
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 8
    OnClick = BtnHelpClick
  end
  object BtnView: TButton
    Left = 16
    Top = 384
    Width = 75
    Height = 25
    Caption = '&View...'
    TabOrder = 5
    OnClick = BtnViewClick
  end
  object Panel1: TPanel
    Left = 240
    Top = 64
    Width = 193
    Height = 288
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 4
  end
  inline GridEdit: TGridEditFrame
    Left = 16
    Top = 64
    Width = 201
    Height = 302
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 3
    ExplicitLeft = 16
    ExplicitTop = 64
    ExplicitWidth = 201
    ExplicitHeight = 302
    inherited Grid: TStringGrid
      Width = 198
      Height = 288
      ColCount = 3
      RowCount = 101
      ExplicitWidth = 198
      ExplicitHeight = 288
    end
    inherited EditPanel: TPanel
      inherited EditBox: TNumEdit
        Style = esNumber
      end
    end
  end
  object EditBtn: TBitBtn
    Tag = 1
    Left = 418
    Top = 23
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
    TabOrder = 2
    OnClick = EditBtnClick
  end
end
