object ChartOptionsDlg: TChartOptionsDlg
  Left = 410
  Top = 182
  BorderStyle = bsDialog
  BorderWidth = 1
  Caption = 'Graph Options'
  ClientHeight = 407
  ClientWidth = 366
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15
  object DefaultBox: TCheckBox
    Left = 20
    Top = 331
    Width = 213
    Height = 21
    Caption = 'Make these the default options '
    TabOrder = 1
  end
  object OkBtn: TButton
    Left = 53
    Top = 367
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object CancelBtn: TButton
    Left = 146
    Top = 367
    Width = 74
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
  object HelpBtn: TButton
    Left = 238
    Top = 367
    Width = 74
    Height = 25
    Caption = 'Help'
    TabOrder = 4
    OnClick = HelpBtnClick
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 4
    Width = 351
    Height = 312
    ActivePage = AxesPage
    TabOrder = 0
    OnChange = PageControl1Change
    object GeneralPage: TTabSheet
      Caption = 'General'
      object Label1: TLabel
        Left = 8
        Top = 19
        Width = 61
        Height = 15
        Caption = 'Panel Color'
      end
      object Label2: TLabel
        Left = 8
        Top = 67
        Width = 123
        Height = 15
        Caption = 'Start Background Color'
      end
      object Label4: TLabel
        Left = 8
        Top = 184
        Width = 90
        Height = 15
        Caption = '3D Effect Percent'
      end
      object Label5: TLabel
        Left = 8
        Top = 223
        Width = 53
        Height = 15
        Caption = 'Main Title'
      end
      object Label8: TLabel
        Left = 8
        Top = 111
        Width = 119
        Height = 15
        Caption = 'End Background Color'
      end
      object PanelColorBox: TColorBox
        Left = 155
        Top = 16
        Width = 147
        Height = 26
        DefaultColorColor = clBtnFace
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbIncludeDefault, cbPrettyNames]
        Ctl3D = True
        ItemHeight = 20
        ParentCtl3D = False
        TabOrder = 0
      end
      object BackColorBox1: TColorBox
        Left = 155
        Top = 64
        Width = 147
        Height = 26
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbPrettyNames]
        ItemHeight = 20
        TabOrder = 1
      end
      object View3DBox: TCheckBox
        Left = 8
        Top = 145
        Width = 161
        Height = 21
        Alignment = taLeftJustify
        Caption = 'View in 3-D'
        TabOrder = 3
      end
      object GraphTitleBox: TEdit
        Left = 8
        Top = 239
        Width = 262
        Height = 23
        TabOrder = 6
      end
      object GraphTitleFontBtn: TButton
        Left = 276
        Top = 239
        Width = 49
        Height = 25
        Caption = 'Font...'
        TabOrder = 7
        OnClick = GraphTitleFontBtnClick
      end
      object Pct3DUpDown: TUpDown
        Left = 204
        Top = 181
        Width = 16
        Height = 23
        Associate = Pct3DEdit
        Min = 1
        Increment = 5
        Position = 15
        TabOrder = 5
        TabStop = True
      end
      object Pct3DEdit: TEdit
        Left = 155
        Top = 181
        Width = 49
        Height = 23
        NumbersOnly = True
        TabOrder = 4
        Text = '15'
      end
      object BackColorBox2: TColorBox
        Left = 155
        Top = 108
        Width = 147
        Height = 26
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbPrettyNames]
        ItemHeight = 20
        TabOrder = 2
      end
    end
    object AxesPage: TTabSheet
      Caption = 'Axes'
      ImageIndex = 1
      object Label6: TLabel
        Left = 8
        Top = 72
        Width = 53
        Height = 15
        Caption = 'Minimum'
      end
      object Label7: TLabel
        Left = 8
        Top = 112
        Width = 54
        Height = 15
        Caption = 'Maximum'
      end
      object IncrementLabel: TLabel
        Left = 8
        Top = 152
        Width = 54
        Height = 15
        Caption = 'Increment'
      end
      object Label11: TLabel
        Left = 8
        Top = 223
        Width = 47
        Height = 15
        Caption = 'Axis Title'
      end
      object DataMinLabel: TLabel
        Left = 198
        Top = 73
        Width = 73
        Height = 15
        Caption = 'DataMinLabel'
      end
      object DataMaxLabel: TLabel
        Left = 198
        Top = 113
        Width = 74
        Height = 15
        Caption = 'DataMaxLabel'
      end
      object AxisFormatLabel: TLabel
        Left = 8
        Top = 132
        Width = 38
        Height = 15
        Caption = 'Format'
      end
      object Label17: TLabel
        Left = 8
        Top = 16
        Width = 24
        Height = 15
        Caption = 'Axis:'
      end
      object Bevel1: TBevel
        Left = 8
        Top = 48
        Width = 321
        Height = 3
        Shape = bsBottomLine
        Style = bsRaised
      end
      object AxisMinEdit: TEdit
        Left = 96
        Top = 69
        Width = 86
        Height = 23
        TabOrder = 0
      end
      object AxisMaxEdit: TEdit
        Left = 96
        Top = 109
        Width = 86
        Height = 23
        TabOrder = 1
      end
      object AxisIncEdit: TEdit
        Left = 96
        Top = 149
        Width = 86
        Height = 23
        TabOrder = 2
      end
      object AxisAutoCheck: TCheckBox
        Left = 8
        Top = 188
        Width = 100
        Height = 21
        Alignment = taLeftJustify
        Caption = 'Auto Scale'
        TabOrder = 4
      end
      object AxisTitleEdit: TEdit
        Left = 8
        Top = 239
        Width = 264
        Height = 23
        TabOrder = 6
      end
      object AxisFontBtn: TButton
        Left = 278
        Top = 239
        Width = 49
        Height = 25
        Caption = 'Font...'
        TabOrder = 7
        OnClick = AxisFontBtnClick
      end
      object AxisGridCheck: TCheckBox
        Left = 172
        Top = 188
        Width = 100
        Height = 21
        Alignment = taLeftJustify
        Caption = 'Grid Lines'
        TabOrder = 5
      end
      object DateFmtCombo: TComboBox
        Left = 199
        Top = 149
        Width = 105
        Height = 23
        Style = csDropDownList
        TabOrder = 3
      end
      object AxisBottomBtn: TRadioButton
        Left = 96
        Top = 16
        Width = 73
        Height = 17
        Caption = 'Bottom'
        Checked = True
        TabOrder = 8
        TabStop = True
        OnClick = AxisBtnClick
      end
      object AxisLeftBtn: TRadioButton
        Left = 175
        Top = 16
        Width = 73
        Height = 17
        Caption = 'Left'
        TabOrder = 9
        OnClick = AxisBtnClick
      end
      object AxisRightBtn: TRadioButton
        Left = 254
        Top = 16
        Width = 73
        Height = 17
        Caption = 'Right'
        Enabled = False
        TabOrder = 10
        OnClick = AxisBtnClick
      end
    end
    object LegendPage: TTabSheet
      Caption = 'Legend'
      ImageIndex = 3
      object Label18: TLabel
        Left = 8
        Top = 35
        Width = 43
        Height = 15
        Caption = 'Position'
      end
      object Label19: TLabel
        Left = 8
        Top = 75
        Width = 29
        Height = 15
        Caption = 'Color'
      end
      object LegendFrameBox: TCheckBox
        Left = 8
        Top = 143
        Width = 121
        Height = 21
        Alignment = taLeftJustify
        Caption = 'Framed'
        TabOrder = 3
      end
      object LegendVisibleBox: TCheckBox
        Left = 8
        Top = 207
        Width = 121
        Height = 21
        Alignment = taLeftJustify
        Caption = 'Visible'
        TabOrder = 5
      end
      object LegendPosBox: TComboBox
        Left = 116
        Top = 32
        Width = 146
        Height = 23
        Style = csDropDownList
        TabOrder = 0
      end
      object LegendColorBox: TColorBox
        Left = 116
        Top = 72
        Width = 146
        Height = 26
        Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbPrettyNames]
        ItemHeight = 20
        TabOrder = 1
      end
      object LegendCheckBox: TCheckBox
        Left = 8
        Top = 112
        Width = 121
        Height = 21
        Alignment = taLeftJustify
        Caption = 'Check Boxes'
        TabOrder = 2
      end
      object LegendShadowBox: TCheckBox
        Left = 8
        Top = 176
        Width = 121
        Height = 21
        Alignment = taLeftJustify
        Caption = 'Shadowed'
        TabOrder = 4
      end
    end
    object StylesPage: TTabSheet
      Caption = 'Styles'
      ImageIndex = 4
      OnExit = StylesPageExit
      object Label21: TLabel
        Left = 8
        Top = 19
        Width = 30
        Height = 15
        Caption = 'Series'
      end
      object Label22: TLabel
        Left = 8
        Top = 62
        Width = 65
        Height = 15
        Caption = 'Legend Title'
      end
      object SeriesComboBox: TComboBox
        Left = 96
        Top = 16
        Width = 91
        Height = 23
        Style = csDropDownList
        TabOrder = 0
        OnClick = SeriesComboBoxClick
      end
      object SeriesTitle: TEdit
        Left = 96
        Top = 56
        Width = 176
        Height = 23
        TabOrder = 1
      end
      object LegendFontBtn: TButton
        Left = 278
        Top = 53
        Width = 49
        Height = 26
        Caption = 'Font...'
        TabOrder = 2
        OnClick = LegendFontBtnClick
      end
      object Panel6: TPanel
        Left = 8
        Top = 96
        Width = 319
        Height = 178
        BevelOuter = bvNone
        Caption = 'Panel1'
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 3
        object PageControl2: TPageControl
          Left = 0
          Top = 0
          Width = 319
          Height = 178
          ActivePage = LineOptionsSheet
          Align = alClient
          TabOrder = 0
          object LineOptionsSheet: TTabSheet
            Caption = 'Lines'
            object Label23: TLabel
              Left = 55
              Top = 14
              Width = 25
              Height = 15
              Caption = 'Style'
            end
            object Label24: TLabel
              Left = 55
              Top = 51
              Width = 29
              Height = 15
              Caption = 'Color'
            end
            object Label25: TLabel
              Left = 55
              Top = 94
              Width = 20
              Height = 15
              Caption = 'Size'
            end
            object LineStyleBox: TComboBox
              Left = 111
              Top = 11
              Width = 146
              Height = 23
              Style = csDropDownList
              TabOrder = 0
            end
            object LineColorBox: TColorBox
              Left = 111
              Top = 48
              Width = 146
              Height = 26
              Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbPrettyNames]
              ItemHeight = 20
              TabOrder = 1
            end
            object LineVisibleBox: TCheckBox
              Left = 55
              Top = 125
              Width = 69
              Height = 21
              Alignment = taLeftJustify
              Caption = 'Visible'
              TabOrder = 4
            end
            object LineSizeEdit: TEdit
              Left = 111
              Top = 91
              Width = 32
              Height = 23
              Ctl3D = True
              NumbersOnly = True
              ParentCtl3D = False
              TabOrder = 2
              Text = '1'
            end
            object LineSizeUpDown: TUpDown
              Left = 143
              Top = 91
              Width = 16
              Height = 23
              Associate = LineSizeEdit
              Min = 1
              Max = 10
              Position = 1
              TabOrder = 3
            end
          end
          object MarkOptionsSheet: TTabSheet
            Caption = 'Markers'
            ImageIndex = 1
            object Label26: TLabel
              Left = 55
              Top = 14
              Width = 25
              Height = 15
              Caption = 'Style'
            end
            object Label27: TLabel
              Left = 55
              Top = 51
              Width = 29
              Height = 15
              Caption = 'Color'
            end
            object Label28: TLabel
              Left = 55
              Top = 94
              Width = 20
              Height = 15
              Caption = 'Size'
            end
            object MarkVisibleBox: TCheckBox
              Left = 55
              Top = 125
              Width = 69
              Height = 21
              Alignment = taLeftJustify
              Caption = 'Visible'
              TabOrder = 4
            end
            object MarkStyleBox: TComboBox
              Left = 111
              Top = 11
              Width = 146
              Height = 23
              Style = csDropDownList
              TabOrder = 0
            end
            object MarkColorBox: TColorBox
              Left = 111
              Top = 48
              Width = 146
              Height = 26
              Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbPrettyNames]
              ItemHeight = 20
              TabOrder = 1
            end
            object MarkSizeEdit: TEdit
              Left = 111
              Top = 91
              Width = 32
              Height = 23
              Ctl3D = True
              NumbersOnly = True
              ParentCtl3D = False
              TabOrder = 2
              Text = '1'
            end
            object MarkSizeUpDown: TUpDown
              Left = 143
              Top = 91
              Width = 16
              Height = 23
              Associate = MarkSizeEdit
              Min = 1
              Max = 10
              Position = 1
              TabOrder = 3
            end
          end
          object AreaOptionsSheet: TTabSheet
            Caption = 'Patterns'
            ImageIndex = 2
            object Label29: TLabel
              Left = 47
              Top = 14
              Width = 45
              Height = 15
              AutoSize = False
              Caption = 'Style'
            end
            object Label30: TLabel
              Left = 47
              Top = 51
              Width = 29
              Height = 15
              Caption = 'Color'
            end
            object Label31: TLabel
              Left = 47
              Top = 90
              Width = 57
              Height = 15
              AutoSize = False
              Caption = 'Stacking'
            end
            object AreaFillStyleBox: TComboBox
              Left = 118
              Top = 11
              Width = 147
              Height = 23
              Style = csDropDownList
              TabOrder = 0
            end
            object AreaColorBox: TColorBox
              Left = 118
              Top = 48
              Width = 147
              Height = 26
              Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbPrettyNames]
              ItemHeight = 20
              TabOrder = 1
            end
            object StackStyleBox: TComboBox
              Left = 118
              Top = 87
              Width = 147
              Height = 23
              Style = csDropDownList
              TabOrder = 2
            end
          end
          object PieOptionsSheet: TTabSheet
            Caption = 'Pie Options'
            ImageIndex = 3
            object Label32: TLabel
              Left = 80
              Top = 96
              Width = 79
              Height = 15
              Caption = 'Rotation Angle'
            end
            object PieCircledBox: TCheckBox
              Left = 80
              Top = 24
              Width = 114
              Height = 21
              Alignment = taLeftJustify
              Caption = 'Circular'
              TabOrder = 0
            end
            object PiePatternBox: TCheckBox
              Left = 80
              Top = 56
              Width = 114
              Height = 21
              Alignment = taLeftJustify
              Caption = 'Use Patterns'
              TabOrder = 1
            end
            object PieRotateEdit: TEdit
              Left = 185
              Top = 91
              Width = 32
              Height = 23
              Ctl3D = True
              NumbersOnly = True
              ParentCtl3D = False
              TabOrder = 2
              Text = '0'
            end
            object PieRotateUpDown: TUpDown
              Left = 217
              Top = 91
              Width = 16
              Height = 23
              Associate = PieRotateEdit
              Max = 360
              Increment = 10
              TabOrder = 3
            end
          end
          object LabelsOptionsSheet: TTabSheet
            Caption = 'Labels'
            ImageIndex = 4
            object Label33: TLabel
              Left = 43
              Top = 14
              Width = 25
              Height = 15
              Caption = 'Style'
            end
            object Label34: TLabel
              Left = 43
              Top = 51
              Width = 29
              Height = 15
              Caption = 'Color'
            end
            object LabelsStyleBox: TComboBox
              Left = 122
              Top = 11
              Width = 147
              Height = 23
              Style = csDropDownList
              TabOrder = 0
            end
            object LabelsBackColorBox: TColorBox
              Left = 122
              Top = 48
              Width = 147
              Height = 26
              Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbPrettyNames]
              ItemHeight = 20
              TabOrder = 1
            end
            object LabelsTransparentBox: TCheckBox
              Left = 43
              Top = 79
              Width = 96
              Height = 21
              Alignment = taLeftJustify
              Caption = 'Transparent'
              TabOrder = 2
            end
            object LabelsArrowsBox: TCheckBox
              Left = 43
              Top = 104
              Width = 96
              Height = 21
              Alignment = taLeftJustify
              Caption = 'Show Arrows'
              TabOrder = 3
            end
            object LabelsVisibleBox: TCheckBox
              Left = 43
              Top = 128
              Width = 96
              Height = 21
              Alignment = taLeftJustify
              Caption = 'Visible'
              TabOrder = 4
            end
          end
        end
      end
    end
  end
  object FontDialog1: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 440
    Top = 432
  end
end
