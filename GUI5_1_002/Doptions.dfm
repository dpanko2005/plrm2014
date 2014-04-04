object AnalysisOptionsForm: TAnalysisOptionsForm
  Left = 465
  Top = 171
  BorderStyle = bsDialog
  Caption = 'Simulation Options'
  ClientHeight = 464
  ClientWidth = 423
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 403
    Height = 401
    ActivePage = TabSheet4
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'General'
      object ModelsGroup: TGroupBox
        Left = 16
        Top = 16
        Width = 169
        Height = 208
        Caption = 'Process Models'
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 0
        object RainfallBox: TCheckBox
          Left = 8
          Top = 24
          Width = 145
          Height = 21
          Caption = 'Rainfall/Runoff'
          TabOrder = 0
        end
        object SnowMeltBox: TCheckBox
          Left = 8
          Top = 85
          Width = 145
          Height = 21
          Caption = 'Snow Melt'
          TabOrder = 1
        end
        object GroundwaterBox: TCheckBox
          Left = 8
          Top = 115
          Width = 145
          Height = 21
          Caption = 'Groundwater'
          TabOrder = 2
        end
        object FlowRoutingBox: TCheckBox
          Left = 8
          Top = 146
          Width = 145
          Height = 21
          Caption = 'Flow Routing'
          TabOrder = 3
        end
        object WaterQualityBox: TCheckBox
          Left = 8
          Top = 177
          Width = 145
          Height = 21
          Caption = 'Water Quality'
          TabOrder = 4
        end
        object RDIIBox: TCheckBox
          Left = 8
          Top = 54
          Width = 145
          Height = 21
          Caption = 'Rainfall Dependent I/I'
          TabOrder = 5
        end
      end
      object MiscGroup: TGroupBox
        Left = 200
        Top = 16
        Width = 177
        Height = 208
        Caption = 'Miscellaneous'
        TabOrder = 1
        object Label8: TLabel
          Left = 8
          Top = 117
          Width = 131
          Height = 15
          Caption = 'Minimum Conduit Slope'
        end
        object Label13: TLabel
          Left = 80
          Top = 137
          Width = 18
          Height = 15
          Caption = '(%)'
        end
        object AllowPondingBox: TCheckBox
          Left = 8
          Top = 24
          Width = 157
          Height = 21
          Caption = 'Allow Ponding'
          TabOrder = 0
          OnClick = EditChange
        end
        object ReportControlsBox: TCheckBox
          Left = 8
          Top = 54
          Width = 157
          Height = 21
          Caption = 'Report Control Actions'
          TabOrder = 1
          OnClick = EditChange
        end
        object ReportInputBox: TCheckBox
          Left = 8
          Top = 85
          Width = 157
          Height = 21
          Caption = 'Report Input Summary'
          TabOrder = 2
          OnClick = EditChange
        end
        object MinSlopeEdit: TNumEdit
          Left = 7
          Top = 133
          Width = 65
          Height = 23
          TabOrder = 3
          Text = '0'
          OnChange = EditChange
          Style = esPosNumber
          Modified = False
          SelLength = 0
          SelStart = 0
        end
      end
      object InfilModelsGroup: TRadioGroup
        Left = 16
        Top = 238
        Width = 169
        Height = 121
        Caption = 'Infiltration Model'
        Items.Strings = (
          'Horton'
          'Modified Horton'
          'Green Ampt'
          'Curve Number')
        TabOrder = 2
        OnClick = EditChange
      end
      object RoutingMethodsGroup: TRadioGroup
        Left = 200
        Top = 238
        Width = 177
        Height = 121
        Caption = 'Routing Model'
        Items.Strings = (
          'Steady Flow'
          'Kinematic Wave'
          'Dynamic Wave')
        TabOrder = 3
        OnClick = EditChange
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Dates'
      ImageIndex = 1
      object Label6: TLabel
        Left = 40
        Top = 238
        Width = 61
        Height = 15
        Caption = 'Antecedent'
      end
      object Label17: TLabel
        Left = 40
        Top = 46
        Width = 87
        Height = 15
        Caption = 'Start Analysis on'
      end
      object Label18: TLabel
        Left = 40
        Top = 86
        Width = 96
        Height = 15
        Caption = 'Start Reporting on'
      end
      object Label1: TLabel
        Left = 40
        Top = 126
        Width = 83
        Height = 15
        Caption = 'End Analysis on'
      end
      object Label3: TLabel
        Left = 160
        Top = 16
        Width = 71
        Height = 15
        Caption = 'Date (M/D/Y)'
      end
      object Label4: TLabel
        Left = 272
        Top = 16
        Width = 61
        Height = 15
        Caption = 'Time (H:M)'
      end
      object Label7: TLabel
        Left = 40
        Top = 254
        Width = 46
        Height = 15
        Caption = 'Dry Days'
      end
      object Label21: TLabel
        Left = 40
        Top = 168
        Width = 95
        Height = 15
        Caption = 'Start Sweeping on'
      end
      object Label23: TLabel
        Left = 40
        Top = 208
        Width = 91
        Height = 15
        Caption = 'End Sweeping on'
      end
      object DryDaysEdit: TNumEdit
        Left = 160
        Top = 240
        Width = 41
        Height = 23
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 8
        Text = '0'
        OnChange = EditChange
        Style = esPosNumber
        Modified = False
        SelLength = 0
        SelStart = 0
      end
      object StartDatePicker: TDateTimePicker
        Left = 160
        Top = 40
        Width = 97
        Height = 23
        Date = 37914.027740509250000000
        Time = 37914.027740509250000000
        DateMode = dmUpDown
        TabOrder = 0
        OnChange = EditChange
      end
      object RptDatePicker: TDateTimePicker
        Left = 160
        Top = 80
        Width = 97
        Height = 23
        Date = 37914.027740509250000000
        Time = 37914.027740509250000000
        DateMode = dmUpDown
        TabOrder = 2
        OnChange = EditChange
      end
      object EndDatePicker: TDateTimePicker
        Left = 160
        Top = 120
        Width = 97
        Height = 23
        Date = 37914.027740509250000000
        Time = 37914.027740509250000000
        DateMode = dmUpDown
        TabOrder = 4
        OnChange = EditChange
      end
      object StartTimePicker: TDateTimePicker
        Left = 272
        Top = 40
        Width = 65
        Height = 23
        Date = 37914.000000000000000000
        Format = 'HH:mm'
        Time = 37914.000000000000000000
        Kind = dtkTime
        TabOrder = 1
        OnChange = EditChange
      end
      object RptTimePicker: TDateTimePicker
        Left = 272
        Top = 80
        Width = 65
        Height = 23
        Date = 37914.000000000000000000
        Format = 'HH:mm'
        Time = 37914.000000000000000000
        Kind = dtkTime
        TabOrder = 3
        OnChange = EditChange
      end
      object EndTimePicker: TDateTimePicker
        Left = 272
        Top = 120
        Width = 65
        Height = 23
        Date = 37914.000000000000000000
        Format = 'HH:mm'
        Time = 37914.000000000000000000
        Kind = dtkTime
        TabOrder = 5
        OnChange = EditChange
      end
      object SweepStartPicker: TDateTimePicker
        Left = 160
        Top = 160
        Width = 65
        Height = 23
        Date = 17168.027740509250000000
        Format = 'MM/dd'
        Time = 17168.027740509250000000
        DateMode = dmUpDown
        TabOrder = 6
        OnChange = EditChange
      end
      object SweepEndPicker: TDateTimePicker
        Left = 160
        Top = 200
        Width = 65
        Height = 23
        Date = 17532.027740509250000000
        Format = 'MM/dd'
        Time = 17532.027740509250000000
        DateMode = dmUpDown
        TabOrder = 7
        OnChange = EditChange
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Time Steps'
      ImageIndex = 4
      object Label12: TLabel
        Left = 56
        Top = 44
        Width = 52
        Height = 15
        Caption = 'Reporting'
      end
      object Label11: TLabel
        Left = 56
        Top = 162
        Width = 42
        Height = 15
        Caption = 'Routing'
      end
      object Label24: TLabel
        Left = 160
        Top = 16
        Width = 25
        Height = 15
        Caption = 'Days'
      end
      object Label27: TLabel
        Left = 224
        Top = 16
        Width = 58
        Height = 15
        Caption = 'Hr:Min:Sec'
      end
      object Label10: TLabel
        Left = 56
        Top = 89
        Width = 65
        Height = 15
        Caption = 'Dry Weather'
      end
      object Label9: TLabel
        Left = 56
        Top = 130
        Width = 68
        Height = 15
        Caption = 'Wet Weather'
      end
      object Label5: TLabel
        Left = 56
        Top = 74
        Width = 39
        Height = 15
        Caption = 'Runoff:'
      end
      object Label16: TLabel
        Left = 56
        Top = 116
        Width = 39
        Height = 15
        Caption = 'Runoff:'
      end
      object Label2: TLabel
        Left = 224
        Top = 162
        Width = 44
        Height = 15
        Caption = 'Seconds'
      end
      object RptStepPicker: TDateTimePicker
        Left = 224
        Top = 37
        Width = 81
        Height = 23
        Date = 37914.000000000000000000
        Format = 'HH:mm:ss'
        Time = 37914.000000000000000000
        Kind = dtkTime
        TabOrder = 1
        OnChange = EditChange
      end
      object DryStepPicker: TDateTimePicker
        Left = 224
        Top = 78
        Width = 81
        Height = 23
        Date = 37914.000000000000000000
        Format = 'HH:mm:ss'
        Time = 37914.000000000000000000
        Kind = dtkTime
        TabOrder = 3
        OnChange = EditChange
      end
      object WetStepPicker: TDateTimePicker
        Left = 224
        Top = 118
        Width = 81
        Height = 23
        Date = 37914.000000000000000000
        Format = 'HH:mm:ss'
        Time = 37914.000000000000000000
        Kind = dtkTime
        TabOrder = 5
        OnChange = EditChange
      end
      object DryDaysPicker: TDateTimePicker
        Left = 160
        Top = 77
        Width = 49
        Height = 23
        Date = 37914.000000000000000000
        Format = 'm'
        Time = 37914.000000000000000000
        Kind = dtkTime
        TabOrder = 2
        OnChange = EditChange
      end
      object WetDaysPicker: TDateTimePicker
        Left = 160
        Top = 117
        Width = 49
        Height = 23
        Date = 37914.000000000000000000
        Format = 'm'
        Time = 37914.000000000000000000
        Kind = dtkTime
        TabOrder = 4
        OnChange = EditChange
      end
      object RptDaysPicker: TDateTimePicker
        Left = 160
        Top = 37
        Width = 49
        Height = 23
        Date = 37914.000000000000000000
        Format = 'm'
        Time = 37914.000000000000000000
        Kind = dtkTime
        TabOrder = 0
        OnChange = EditChange
      end
      object RouteStepEdit: TNumEdit
        Left = 160
        Top = 158
        Width = 49
        Height = 23
        TabOrder = 6
        Text = '0'
        OnChange = EditChange
        Style = esPosNumber
        Modified = False
        SelLength = 0
        SelStart = 0
      end
      object GroupBox1: TGroupBox
        Left = 56
        Top = 200
        Width = 265
        Height = 137
        Caption = 'Steady Flow Periods'
        TabOrder = 7
        object Label14: TLabel
          Left = 16
          Top = 93
          Width = 139
          Height = 15
          Caption = 'Lateral Flow Tolerance (%)'
        end
        object Label19: TLabel
          Left = 16
          Top = 61
          Width = 142
          Height = 15
          Caption = 'System Flow Tolerance (%)'
        end
        inline SysFlowTolSpinner: TUpDnEditBox
          Left = 191
          Top = 58
          Width = 57
          Height = 23
          AutoSize = True
          TabOrder = 1
          ExplicitLeft = 191
          ExplicitTop = 58
          ExplicitWidth = 57
          ExplicitHeight = 23
          inherited Spinner: TUpDown
            Left = 41
            Height = 23
            Position = 5
            ExplicitLeft = 41
            ExplicitHeight = 23
          end
          inherited EditBox: TEdit
            Width = 41
            Height = 23
            Text = '5'
            ExplicitWidth = 41
            ExplicitHeight = 23
          end
        end
        inline LatFlowTolSpinner: TUpDnEditBox
          Left = 191
          Top = 90
          Width = 57
          Height = 23
          AutoSize = True
          TabOrder = 2
          ExplicitLeft = 191
          ExplicitTop = 90
          ExplicitWidth = 57
          ExplicitHeight = 23
          inherited Spinner: TUpDown
            Left = 41
            Height = 23
            Position = 5
            ExplicitLeft = 41
            ExplicitHeight = 23
          end
          inherited EditBox: TEdit
            Width = 41
            Height = 23
            Text = '5'
            ExplicitWidth = 41
            ExplicitHeight = 23
          end
        end
        object SkipSteadyBox: TCheckBox
          Left = 16
          Top = 28
          Width = 146
          Height = 21
          Caption = 'Skip Steady Flow Periods'
          TabOrder = 0
          OnClick = EditChange
        end
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Dynamic Wave'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -12
      Font.Name = 'Tahoma'
      Font.Style = []
      ImageIndex = 3
      ParentFont = False
      object Label29: TLabel
        Left = 34
        Top = 173
        Width = 229
        Height = 14
        Caption = 'Time Step For Conduit Lengthening (sec)'
      end
      object MinSurfAreaLabel: TLabel
        Left = 33
        Top = 211
        Width = 232
        Height = 14
        Caption = 'Minimum Nodal Surface Area (square feet)'
      end
      object Label15: TLabel
        Left = 33
        Top = 251
        Width = 164
        Height = 14
        Caption = 'Maximum Trials per Time Step'
      end
      object HeadTolLabel: TLabel
        Left = 33
        Top = 289
        Width = 199
        Height = 14
        Caption = 'Head Convergence Tolerance (feet)'
      end
      object SFLabel1: TLabel
        Left = 202
        Top = 137
        Width = 66
        Height = 14
        Caption = 'Adjusted By'
      end
      object Label22: TLabel
        Left = 347
        Top = 138
        Width = 12
        Height = 14
        Caption = '%'
      end
      object InertialTermsGroup: TRadioGroup
        Left = 8
        Top = 16
        Width = 97
        Height = 102
        Caption = 'Inertial Terms'
        Ctl3D = True
        ItemIndex = 1
        Items.Strings = (
          'Keep'
          'Dampen'
          'Ignore')
        ParentCtl3D = False
        TabOrder = 0
        OnClick = EditChange
      end
      object NormalFlowGroup: TRadioGroup
        Left = 115
        Top = 16
        Width = 132
        Height = 102
        Caption = 'Normal Flow Criterion'
        ItemIndex = 2
        Items.Strings = (
          'Slope'
          'Froude No.'
          'Both')
        TabOrder = 1
        OnClick = EditChange
      end
      object ForceMainGroup: TRadioGroup
        Left = 256
        Top = 16
        Width = 128
        Height = 102
        Caption = ' Force Main Equation'
        Ctl3D = True
        ItemIndex = 0
        Items.Strings = (
          'Hazen-Williams'
          'Darcy-Weisbach')
        ParentCtl3D = False
        TabOrder = 2
        OnClick = EditChange
      end
      object LengthenStepEdit: TNumEdit
        Left = 281
        Top = 170
        Width = 58
        Height = 22
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 5
        Text = '0'
        OnChange = EditChange
        Style = esPosNumber
        Modified = False
        SelLength = 0
        SelStart = 0
      end
      object MinSurfAreaEdit: TNumEdit
        Left = 281
        Top = 208
        Width = 58
        Height = 22
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 6
        Text = '0'
        OnChange = EditChange
        Style = esPosNumber
        Modified = False
        SelLength = 0
        SelStart = 0
      end
      object VarTimeStepBox: TCheckBox
        Left = 33
        Top = 135
        Width = 163
        Height = 21
        Caption = 'Use Variable Time Steps '
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 3
        OnClick = VarTimeStepBoxClick
      end
      object HeadTolEdit: TNumEdit
        Left = 281
        Top = 286
        Width = 58
        Height = 22
        AutoSize = False
        Ctl3D = True
        ParentCtl3D = False
        TabOrder = 8
        Text = '0'
        OnChange = EditChange
        Style = esPosNumber
        Modified = False
        SelLength = 0
        SelStart = 0
      end
      object DefaultsBtn: TButton
        Left = 33
        Top = 324
        Width = 113
        Height = 25
        Caption = 'Apply Defaults'
        TabOrder = 9
        OnClick = DefaultsBtnClick
      end
      inline VarStepEdit: TUpDnEditBox
        Left = 281
        Top = 133
        Width = 58
        Height = 22
        AutoSize = True
        TabOrder = 4
        ExplicitLeft = 281
        ExplicitTop = 133
        ExplicitWidth = 58
        ExplicitHeight = 22
        inherited Spinner: TUpDown
          Left = 42
          Height = 22
          Min = 25
          Max = 150
          Increment = 5
          Position = 75
          TabOrder = 1
          ExplicitLeft = 42
          ExplicitHeight = 22
        end
        inherited EditBox: TEdit
          Width = 42
          Height = 22
          TabOrder = 0
          Text = '75'
          ExplicitWidth = 42
          ExplicitHeight = 22
        end
      end
      inline MaxTrialsEdit: TUpDnEditBox
        Left = 281
        Top = 247
        Width = 58
        Height = 22
        AutoSize = True
        TabOrder = 7
        ExplicitLeft = 281
        ExplicitTop = 247
        ExplicitWidth = 58
        ExplicitHeight = 22
        inherited Spinner: TUpDown
          Left = 42
          Height = 22
          Min = 3
          Max = 20
          Position = 4
          TabOrder = 1
          ExplicitLeft = 42
          ExplicitHeight = 22
        end
        inherited EditBox: TEdit
          Width = 42
          Height = 22
          TabOrder = 0
          Text = '4'
          ExplicitWidth = 42
          ExplicitHeight = 22
        end
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Files'
      ImageIndex = 2
      object Label25: TLabel
        Left = 8
        Top = 16
        Width = 189
        Height = 15
        Caption = 'Specify interface files to use or save:'
      end
      object FileListBox: TListBox
        Left = 8
        Top = 40
        Width = 375
        Height = 177
        Style = lbOwnerDrawFixed
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ItemHeight = 18
        ParentFont = False
        TabOrder = 0
        OnDblClick = FileListBoxDblClick
        OnKeyPress = FileListBoxKeyPress
      end
      object AddBtn: TButton
        Left = 74
        Top = 232
        Width = 75
        Height = 25
        Caption = 'Add'
        TabOrder = 1
        OnClick = AddBtnClick
      end
      object EditBtn: TButton
        Left = 158
        Top = 232
        Width = 75
        Height = 25
        Caption = 'Edit'
        TabOrder = 2
        OnClick = EditBtnClick
      end
      object DeleteBtn: TButton
        Left = 242
        Top = 232
        Width = 75
        Height = 25
        Caption = 'Delete'
        TabOrder = 3
        OnClick = DeleteBtnClick
      end
    end
  end
  object OKBtn: TButton
    Left = 83
    Top = 424
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 1
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 170
    Top = 424
    Width = 75
    Height = 25
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
  end
  object HelpBtn: TButton
    Left = 258
    Top = 424
    Width = 75
    Height = 25
    Caption = '&Help'
    TabOrder = 3
    OnClick = HelpBtnClick
  end
end
