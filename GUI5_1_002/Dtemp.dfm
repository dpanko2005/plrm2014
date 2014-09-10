object TemperatureForm: TTemperatureForm
  Left = 302
  Top = 174
  BorderStyle = bsDialog
  Caption = 'Temperature Editor'
  ClientHeight = 358
  ClientWidth = 345
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 345
    Height = 305
    ActivePage = TabSheet1
    Align = alTop
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Temperature'
      object Label2: TLabel
        Left = 56
        Top = 192
        Width = 48
        Height = 13
        Caption = 'Start Date'
      end
      object Label3: TLabel
        Left = 184
        Top = 192
        Width = 45
        Height = 13
        Caption = 'End Date'
      end
      object Label12: TLabel
        Left = 32
        Top = 24
        Width = 138
        Height = 13
        Caption = 'Source of Temperature Data:'
      end
      object RadioButton1: TRadioButton
        Left = 32
        Top = 56
        Width = 113
        Height = 17
        Caption = 'Time Series'
        Checked = True
        TabOrder = 0
        TabStop = True
      end
      object ComboBox1: TComboBox
        Left = 56
        Top = 80
        Width = 145
        Height = 21
        ItemHeight = 13
        TabOrder = 1
      end
      object RadioButton2: TRadioButton
        Left = 32
        Top = 128
        Width = 209
        Height = 17
        Caption = 'Climatological File'
        TabOrder = 2
      end
      object Edit1: TEdit
        Left = 56
        Top = 152
        Width = 217
        Height = 21
        TabOrder = 3
      end
      object BitBtn1: TBitBtn
        Left = 274
        Top = 152
        Width = 25
        Height = 25
        TabOrder = 4
        Glyph.Data = {
          F6000000424DF600000000000000760000002800000010000000100000000100
          04000000000080000000CE0E0000C40E00001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
          77777777777777777777000000000007777700333333333077770B0333333333
          07770FB03333333330770BFB0333333333070FBFB000000000000BFBFBFBFB07
          77770FBFBFBFBF0777770BFB0000000777777000777777770007777777777777
          7007777777770777070777777777700077777777777777777777}
      end
      object Edit2: TEdit
        Left = 56
        Top = 208
        Width = 81
        Height = 21
        TabOrder = 5
      end
      object Edit3: TEdit
        Left = 184
        Top = 208
        Width = 81
        Height = 21
        TabOrder = 6
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Wind Speed'
      ImageIndex = 1
      object Label1: TLabel
        Left = 16
        Top = 24
        Width = 214
        Height = 13
        Caption = 'Monthly Average Wind Speed (mph or km/hr)'
      end
      inline WindGrid1: TGridEditFrame
        Left = 16
        Top = 54
        Width = 295
        Height = 53
        TabOrder = 0
        inherited Grid: TStringGrid
          Width = 295
          Height = 53
          ColCount = 6
          Ctl3D = False
          DefaultColWidth = 48
          FixedCols = 0
          RowCount = 2
          ParentCtl3D = False
          ScrollBars = ssNone
        end
        inherited EditPanel: TPanel
          inherited EditBox: TNumEdit
            Style = esPosNumber
          end
        end
        inherited PopupMenu: TPopupMenu
          Top = 16
        end
      end
      inline WindGrid2: TGridEditFrame
        Left = 16
        Top = 130
        Width = 295
        Height = 53
        TabOrder = 1
        inherited Grid: TStringGrid
          Width = 295
          Height = 53
          ColCount = 6
          Ctl3D = False
          DefaultColWidth = 48
          FixedCols = 0
          RowCount = 2
          ParentCtl3D = False
          ScrollBars = ssNone
        end
        inherited EditPanel: TPanel
          inherited EditBox: TNumEdit
            Style = esPosNumber
          end
        end
        inherited PopupMenu: TPopupMenu
          Top = 16
        end
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Snow Melt'
      ImageIndex = 2
      object Label4: TLabel
        Left = 24
        Top = 24
        Width = 101
        Height = 13
        Caption = 'Dividing Temperature'
      end
      object Label5: TLabel
        Left = 24
        Top = 72
        Width = 54
        Height = 13
        Caption = 'ATI Weight'
      end
      object Label6: TLabel
        Left = 24
        Top = 112
        Width = 94
        Height = 13
        Caption = 'Negative Melt Ratio'
      end
      object Label7: TLabel
        Left = 24
        Top = 152
        Width = 102
        Height = 13
        Caption = 'Elevation above MSL'
      end
      object Label8: TLabel
        Left = 24
        Top = 192
        Width = 99
        Height = 13
        Caption = 'Latitude (Deg. North)'
      end
      object Label9: TLabel
        Left = 24
        Top = 232
        Width = 98
        Height = 13
        Caption = 'Longitude Correction'
      end
      object Label11: TLabel
        Left = 24
        Top = 40
        Width = 118
        Height = 13
        Caption = 'Between Snow and Rain'
      end
      object NumEdit1: TNumEdit
        Left = 216
        Top = 24
        Width = 73
        Height = 21
        TabOrder = 0
        Style = esPosNumber
        Modified = False
        SelLength = 0
        SelStart = 0
      end
      object NumEdit2: TNumEdit
        Left = 216
        Top = 64
        Width = 73
        Height = 21
        TabOrder = 1
        Style = esPosNumber
        Modified = False
        SelLength = 0
        SelStart = 0
      end
      object NumEdit3: TNumEdit
        Left = 216
        Top = 104
        Width = 73
        Height = 21
        TabOrder = 2
        Style = esPosNumber
        Modified = False
        SelLength = 0
        SelStart = 0
      end
      object NumEdit4: TNumEdit
        Left = 216
        Top = 144
        Width = 73
        Height = 21
        TabOrder = 3
        Style = esNumber
        Modified = False
        SelLength = 0
        SelStart = 0
      end
      object NumEdit5: TNumEdit
        Left = 216
        Top = 184
        Width = 73
        Height = 21
        TabOrder = 4
        Style = esPosNumber
        Modified = False
        SelLength = 0
        SelStart = 0
      end
      object NumEdit6: TNumEdit
        Left = 216
        Top = 224
        Width = 73
        Height = 21
        TabOrder = 5
        Style = esNumber
        Modified = False
        SelLength = 0
        SelStart = 0
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Areal Depletion'
      ImageIndex = 3
      object Label10: TLabel
        Left = 112
        Top = 24
        Width = 162
        Height = 13
        Caption = 'Fraction of Area Covered by Snow'
      end
      inline ADCGrid: TGridEditFrame
        Left = 16
        Top = 40
        Width = 305
        Height = 203
        TabOrder = 0
        inherited Grid: TStringGrid
          Width = 305
          Height = 203
          ColCount = 3
          Ctl3D = False
          DefaultColWidth = 94
          RowCount = 11
          ParentCtl3D = False
        end
        inherited EditPanel: TPanel
          inherited EditBox: TNumEdit
            Style = esPosNumber
          end
        end
      end
    end
  end
  object OKBtn: TButton
    Left = 87
    Top = 320
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 1
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 175
    Top = 320
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object HelpBtn: TButton
    Left = 263
    Top = 320
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 3
  end
end
