object TimePlotForm: TTimePlotForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsDialog
  Caption = 'Time Series Plot Selection'
  ClientHeight = 340
  ClientWidth = 297
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 297
    Height = 340
    ActivePage = TabSheet1
    Align = alClient
    Style = tsButtons
    TabHeight = 1
    TabOrder = 0
    TabStop = False
    TabWidth = 1
    ExplicitWidth = 291
    object TabSheet1: TTabSheet
      ExplicitTop = 29
      ExplicitWidth = 283
      ExplicitHeight = 307
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 289
        Height = 329
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitLeft = 64
        ExplicitTop = 56
        ExplicitWidth = 185
        ExplicitHeight = 41
        object OkBtn: TButton
          Left = 23
          Top = 297
          Width = 75
          Height = 25
          Caption = 'OK'
          TabOrder = 0
          OnClick = OkBtnClick
        end
        object CancelBtn1: TButton
          Left = 107
          Top = 297
          Width = 75
          Height = 25
          Cancel = True
          Caption = 'Cancel'
          TabOrder = 1
          OnClick = CancelBtn1Click
        end
        object HelpBtn1: TButton
          Left = 192
          Top = 297
          Width = 75
          Height = 25
          Caption = 'Help'
          TabOrder = 2
          OnClick = HelpBtn1Click
        end
        object GroupBox1: TGroupBox
          Left = 14
          Top = 131
          Width = 259
          Height = 153
          Caption = 'Data Series'
          TabOrder = 3
          object BtnAdd: TBitBtn
            Left = 8
            Top = 24
            Width = 57
            Height = 25
            Hint = 'Add a new data series'
            Caption = 'Add'
            Glyph.Data = {
              DE000000424DDE0000000000000076000000280000000D0000000D0000000100
              0400000000006800000000000000000000001000000010000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              700077777777777770007777700077777000777770C077777000777770C07777
              7000770000C000077000770CCCCCCC077000770000C000077000777770C07777
              7000777770C07777700077777000777770007777777777777000777777777777
              7000}
            ParentShowHint = False
            ShowHint = True
            TabOrder = 0
            OnClick = BtnAddClick
          end
          object SeriesListBox: TListBox
            Left = 8
            Top = 50
            Width = 241
            Height = 95
            ItemHeight = 15
            TabOrder = 5
          end
          object BtnDelete: TBitBtn
            Left = 126
            Top = 24
            Width = 67
            Height = 25
            Hint = 'Delete the selected data series'
            Caption = 'Delete'
            Glyph.Data = {
              DE000000424DDE0000000000000076000000280000000D0000000D0000000100
              0400000000006800000000000000000000001000000010000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              7000777777777777700077777777777770007777777777777000777777777777
              70007700000000077000770CCCCCCC0770007700000000077000777777777777
              7000777777777777700077777777777770007777777777777000777777777777
              7000}
            ParentShowHint = False
            ShowHint = True
            TabOrder = 2
            OnClick = BtnDeleteClick
          end
          object BtnMoveUp: TBitBtn
            Left = 195
            Top = 24
            Width = 25
            Height = 25
            Hint = 'Move selected series up'
            Glyph.Data = {
              DE000000424DDE0000000000000076000000280000000D0000000D0000000100
              0400000000006800000000000000000000001000000010000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              7000777777777777700077770000077770007777066607777000777706660777
              7000777706660777700070000666000070007706666666077000777066666077
              7000777706660777700077777060777770007777770777777000777777777777
              7000}
            ParentShowHint = False
            ShowHint = True
            TabOrder = 3
            OnClick = BtnMoveUpClick
          end
          object BtnMoveDown: TBitBtn
            Left = 224
            Top = 24
            Width = 25
            Height = 25
            Hint = 'Move selected series down'
            Glyph.Data = {
              DE000000424DDE0000000000000076000000280000000D0000000D0000000100
              0400000000006800000000000000000000001000000010000000000000000000
              BF0000BF000000BFBF00BF000000BF00BF00BFBF0000C0C0C000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00777777777777
              7000777777777777700077777707777770007777706077777000777706660777
              7000777066666077700077066666660770007000066600007000777706660777
              7000777706660777700077770666077770007777000007777000777777777777
              7000}
            ParentShowHint = False
            ShowHint = True
            TabOrder = 4
            OnClick = BtnMoveDownClick
          end
          object BtnEdit: TBitBtn
            Left = 67
            Top = 24
            Width = 57
            Height = 25
            Hint = 'Edit the selected data series'
            Caption = 'Edit'
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
            TabOrder = 1
            OnClick = BtnEditClick
          end
        end
        object GroupBox2: TGroupBox
          Left = 16
          Top = 16
          Width = 257
          Height = 106
          Caption = 'Time Periods'
          TabOrder = 4
          object Label1: TLabel
            Left = 8
            Top = 25
            Width = 51
            Height = 15
            Caption = 'Start Date'
          end
          object Label5: TLabel
            Left = 136
            Top = 25
            Width = 47
            Height = 15
            Caption = 'End Date'
          end
          object StartDateCombo1: TComboBox
            Left = 8
            Top = 43
            Width = 113
            Height = 23
            Style = csDropDownList
            TabOrder = 0
          end
          object EndDateCombo1: TComboBox
            Left = 136
            Top = 43
            Width = 113
            Height = 23
            Style = csDropDownList
            TabOrder = 1
          end
          object ElapsedTimeBtn: TRadioButton
            Left = 8
            Top = 81
            Width = 113
            Height = 17
            Caption = 'Elapsed Time'
            TabOrder = 2
          end
          object DateTimeBtn: TRadioButton
            Left = 136
            Top = 81
            Width = 113
            Height = 17
            Caption = 'Date/Time'
            TabOrder = 3
          end
        end
      end
    end
    object TabSheet2: TTabSheet
      ImageIndex = 1
      ExplicitWidth = 283
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 289
        Height = 329
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        ExplicitLeft = 24
        ExplicitTop = 40
        ExplicitWidth = 185
        ExplicitHeight = 41
        object Label2: TLabel
          Left = 16
          Top = 83
          Width = 64
          Height = 15
          Caption = 'Object Type'
        end
        object ObjNameLabel: TLabel
          Left = 16
          Top = 123
          Width = 70
          Height = 15
          Caption = 'Object Name'
        end
        object Label4: TLabel
          Left = 16
          Top = 163
          Width = 42
          Height = 15
          Caption = 'Variable'
        end
        object Label6: TLabel
          Left = 16
          Top = 202
          Width = 70
          Height = 15
          Caption = 'Legend Label'
        end
        object Label7: TLabel
          Left = 16
          Top = 238
          Width = 21
          Height = 15
          Caption = 'Axis'
        end
        object Label8: TLabel
          Left = 44
          Top = 16
          Width = 202
          Height = 15
          Caption = 'Specify the object and variable to plot:'
        end
        object Label3: TLabel
          Left = 42
          Top = 37
          Width = 207
          Height = 15
          Caption = '(Click an object on the map to select it)'
        end
        object ObjTypeCombo: TComboBox
          Left = 112
          Top = 80
          Width = 156
          Height = 23
          Style = csDropDownList
          TabOrder = 0
          OnChange = ObjTypeComboChange
        end
        object ObjNameEdit: TEdit
          Left = 112
          Top = 120
          Width = 155
          Height = 23
          TabOrder = 1
        end
        object VariableCombo: TComboBox
          Left = 112
          Top = 160
          Width = 156
          Height = 23
          Style = csDropDownList
          TabOrder = 2
        end
        object LegendLabelEdit: TEdit
          Left = 112
          Top = 199
          Width = 156
          Height = 23
          TabOrder = 3
        end
        object AcceptBtn: TButton
          Left = 23
          Top = 297
          Width = 75
          Height = 25
          Caption = 'Accept'
          TabOrder = 4
          OnClick = AcceptBtnClick
        end
        object CancelBtn2: TButton
          Left = 107
          Top = 297
          Width = 75
          Height = 25
          Caption = 'Cancel'
          TabOrder = 5
          OnClick = CancelBtn2Click
        end
        object HelpBtn2: TButton
          Left = 192
          Top = 297
          Width = 75
          Height = 25
          Caption = 'Help'
          TabOrder = 6
          OnClick = HelpBtn2Click
        end
        object LeftAxisBtn: TRadioButton
          Left = 112
          Top = 238
          Width = 49
          Height = 17
          Caption = 'Left'
          TabOrder = 7
        end
        object RightAxisBtn: TRadioButton
          Left = 178
          Top = 238
          Width = 57
          Height = 17
          Caption = 'Right'
          TabOrder = 8
        end
      end
    end
  end
end
