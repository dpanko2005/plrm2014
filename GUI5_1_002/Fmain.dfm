object MainForm: TMainForm
  Left = 328
  Top = 128
  Caption = 'EPA SWMM 5'
  ClientHeight = 479
  ClientWidth = 704
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clBlack
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIForm
  Icon.Data = {
    0000010001002020100000000400E80200001600000028000000200000004000
    0000010004000000000000020000000000000000000010000000100000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000444
    444444444444444444444444444404EEEEEEEEEE4444E4444EEEEEEEEEE404EE
    EEEEEE444444E444444EEEEEEEE404EEEEEE44444444E44444444EEEEEE404EE
    EE4444444444E4444444444EEEE404EEE4444444444EEE4444444444EEE404EE
    E4444444444EEE44444444444EE404EE44444444444EEEE4444444444EE404E4
    4444444444EEEEE44444444444E404E44444444444EEEEEE4444444444E40444
    444444444EEEEEEE444444444444044444444444EEEEEEEEE444444444440444
    4444444EE4444444EE4444444444044444444EE44444444444EE444444440444
    4444EE4444444444444EE444444404444EEEE444444444444444EEEE444404EE
    EEEE44444444444444444EEEEEE404EEEEEE44444444444444444EEEEEE404EE
    EEE4444444444444444444EEEEE404EEEEE4EEE4EEE4EE4EEE4EE4EEEEE404EE
    EEEEEEEEEEEEEEEEEEEEEEEEEEE404EEEEE4444444EEEEE4444444EEEEE404EE
    EEE4444444EEEEE4444444EEEEE404EEEEE4444444EEEEE4444444EEEEE404EE
    EEEE444444EEEEE444444EEEEEE404EEEEEE4444444EEE4444444EEEEEE404EE
    EEEEE444444444444444EEEEEEE404EEEEEEEE4444444444444EEEEEEEE404EE
    EEEEEEE44444444444EEEEEEEEE404EEEEEEEEEE444444444EEEEEEEEEE40444
    4444444444444444444444444444000000000000000000000000000000008000
    0000800000008000000080000000800000008000000080000000800000008000
    0000800000008000000080000000800000008000000080000000800000008000
    0000800000008000000080000000800000008000000080000000800000008000
    0000800000008000000080000000800000008000000080000000FFFFFFFF}
  KeyPreview = True
  Menu = MainMenu1
  OldCreateOrder = False
  WindowMenu = MnuWindow
  OnActivate = FormActivate
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 173
    Top = 30
    Height = 389
    Beveled = True
    Color = clBtnShadow
    ParentColor = False
    ExplicitHeight = 393
  end
  object ProgressPanel: TPanel
    Left = 0
    Top = 419
    Width = 704
    Height = 30
    Align = alBottom
    Alignment = taLeftJustify
    BevelOuter = bvLowered
    ParentBackground = False
    ParentColor = True
    TabOrder = 1
    object ProgressBar: TProgressBar
      Left = 158
      Top = 6
      Width = 189
      Height = 15
      Step = 1
      TabOrder = 0
    end
  end
  object ControlBar1: TControlBar
    Left = 0
    Top = 0
    Width = 704
    Height = 30
    Align = alTop
    AutoSize = True
    DrawingStyle = dsGradient
    TabOrder = 2
    object StdToolBar: TToolBar
      Left = 11
      Top = 2
      Width = 428
      Height = 22
      DrawingStyle = dsGradient
      Images = BtnImageList
      TabOrder = 0
      Transparent = False
      Wrapable = False
      object TBNew: TToolButton
        Left = 0
        Top = 0
        Hint = 'Start a new project'
        ImageIndex = 0
        ParentShowHint = False
        ShowHint = True
        OnClick = MnuNewClick
      end
      object TBOpen: TToolButton
        Left = 23
        Top = 0
        Hint = 'Open an existing project'
        ImageIndex = 1
        ParentShowHint = False
        ShowHint = True
        OnClick = MnuOpenClick
      end
      object TBSave: TToolButton
        Left = 46
        Top = 0
        Hint = 'Save the current project'
        ImageIndex = 2
        ParentShowHint = False
        ShowHint = True
        OnClick = MnuSaveClick
      end
      object TBPrint: TToolButton
        Left = 69
        Top = 0
        Hint = 'Print the current window'
        ImageIndex = 3
        ParentShowHint = False
        ShowHint = True
        OnClick = MnuPrintClick
      end
      object ToolButton5: TToolButton
        Left = 92
        Top = 0
        Width = 8
        Caption = 'ToolButton5'
        ImageIndex = 4
        Style = tbsSeparator
      end
      object TBCopy: TToolButton
        Left = 100
        Top = 0
        Hint = 'Copy the contents of the current window'
        ImageIndex = 4
        ParentShowHint = False
        ShowHint = True
        OnClick = MnuCopyClick
      end
      object TBFind: TToolButton
        Left = 123
        Top = 0
        Hint = 'Find an object on the map'
        ImageIndex = 5
        ParentShowHint = False
        ShowHint = True
        OnClick = MnuFindObjectClick
      end
      object TBQuery: TToolButton
        Left = 146
        Top = 0
        Hint = 'Find all objects meeting a given criterion'
        ImageIndex = 6
        ParentShowHint = False
        ShowHint = True
        OnClick = MnuQueryClick
      end
      object TBOverview: TToolButton
        Left = 169
        Top = 0
        Hint = 'Toggle the display of the Overview Map'
        ImageIndex = 7
        ParentShowHint = False
        ShowHint = True
        OnClick = MnuOVMapClick
      end
      object ToolButton10: TToolButton
        Left = 192
        Top = 0
        Width = 8
        Caption = 'ToolButton10'
        ImageIndex = 8
        Style = tbsSeparator
      end
      object TBRun: TToolButton
        Left = 200
        Top = 0
        Hint = 'Run a simulation'
        ImageIndex = 8
        ParentShowHint = False
        ShowHint = True
        OnClick = MnuProjectRunSimulationClick
      end
      object ToolButton12: TToolButton
        Left = 223
        Top = 0
        Width = 8
        Caption = 'ToolButton12'
        ImageIndex = 9
        Style = tbsSeparator
      end
      object TBReport: TToolButton
        Left = 231
        Top = 0
        Hint = 'View the Status Report'
        DropdownMenu = ReportPopupMenu
        ImageIndex = 9
        ParentShowHint = False
        ShowHint = True
        OnClick = MnuReportStatusClick
      end
      object TBProfile: TToolButton
        Left = 254
        Top = 0
        Hint = 'Create a Profile Plot'
        ImageIndex = 10
        ParentShowHint = False
        ShowHint = True
        OnClick = MnuGraphProfileClick
      end
      object TBGraph: TToolButton
        Left = 277
        Top = 0
        Hint = 'Create a Time Series Plot'
        ImageIndex = 11
        ParentShowHint = False
        ShowHint = True
        OnClick = TBGraphClick
      end
      object TBTable: TToolButton
        Left = 300
        Top = 0
        Hint = 'Create a Time Series Table'
        DropdownMenu = TablePopupMenu
        ImageIndex = 13
        ParentShowHint = False
        ShowHint = True
      end
      object TBScatter: TToolButton
        Left = 323
        Top = 0
        Hint = 'Create a Scatter Plot'
        ImageIndex = 12
        ParentShowHint = False
        ShowHint = True
        OnClick = TBGraphClick
      end
      object TBStats: TToolButton
        Left = 346
        Top = 0
        Hint = 'Create a Statistics Report'
        ImageIndex = 14
        ParentShowHint = False
        ShowHint = True
        OnClick = MnuReportStatisticsClick
      end
      object ToolButton19: TToolButton
        Left = 369
        Top = 0
        Width = 8
        Caption = 'ToolButton19'
        ImageIndex = 15
        Style = tbsSeparator
      end
      object TBOptions: TToolButton
        Left = 377
        Top = 0
        Hint = 'Select viewing options for the current window'
        ImageIndex = 15
        ParentShowHint = False
        ShowHint = True
        OnClick = TBOptionsClick
      end
      object TBArrange: TToolButton
        Left = 400
        Top = 0
        Hint = 'Arrange all windows'
        ImageIndex = 17
        ParentShowHint = False
        ShowHint = True
        OnClick = MnuWindowCascadeClick
      end
    end
    object MapToolBar: TToolBar
      Left = 452
      Top = 2
      Width = 192
      Height = 22
      Caption = 'MapToolBar'
      DrawingStyle = dsGradient
      Images = BtnImageList
      TabOrder = 1
      Wrapable = False
      object MapButton1: TToolButton
        Tag = 101
        Left = 0
        Top = 0
        Hint = 'Select an object on the map'
        AllowAllUp = True
        Caption = 'MapButton1'
        Down = True
        Grouped = True
        ImageIndex = 18
        ParentShowHint = False
        ShowHint = True
        OnClick = MapButtonClick
      end
      object MapButton2: TToolButton
        Tag = 102
        Left = 23
        Top = 0
        Hint = 'Select a link vertex'
        AllowAllUp = True
        Caption = 'MapButton2'
        Grouped = True
        ImageIndex = 19
        ParentShowHint = False
        ShowHint = True
        OnClick = MapButtonClick
      end
      object MapButton3: TToolButton
        Tag = 103
        Left = 46
        Top = 0
        Hint = 'Select a region on the map'
        AllowAllUp = True
        Caption = 'MapButton3'
        Grouped = True
        ImageIndex = 20
        ParentShowHint = False
        ShowHint = True
        OnClick = MapButtonClick
      end
      object MapButton4: TToolButton
        Tag = 104
        Left = 69
        Top = 0
        Hint = 'Pan the map'
        AllowAllUp = True
        Caption = 'MapButton4'
        Grouped = True
        ImageIndex = 21
        ParentShowHint = False
        ShowHint = True
        OnClick = MapButtonClick
      end
      object MapButton5: TToolButton
        Tag = 105
        Left = 92
        Top = 0
        Hint = 'Zoom in on the map'
        AllowAllUp = True
        Caption = 'MapButton5'
        Grouped = True
        ImageIndex = 22
        ParentShowHint = False
        ShowHint = True
        OnClick = MapButtonClick
      end
      object MapButton6: TToolButton
        Tag = 106
        Left = 115
        Top = 0
        Hint = 'Zoom out on the map'
        AllowAllUp = True
        Caption = 'MapButton6'
        Enabled = False
        Grouped = True
        ImageIndex = 23
        ParentShowHint = False
        ShowHint = True
        OnClick = MapButtonClick
      end
      object MapButton7: TToolButton
        Tag = 107
        Left = 138
        Top = 0
        Hint = 'View the map at full extent'
        Caption = 'MapButton7'
        ImageIndex = 24
        ParentShowHint = False
        ShowHint = True
        OnClick = MapButton7Click
      end
      object MapButton8: TToolButton
        Tag = 108
        Left = 161
        Top = 0
        Hint = 'Measure a distance or area on the map'
        AllowAllUp = True
        Caption = 'MapButton8'
        Grouped = True
        ImageIndex = 25
        ParentShowHint = False
        ShowHint = True
        OnClick = MapButtonClick
      end
    end
  end
  object StatusBar: TToolBar
    Left = 0
    Top = 449
    Width = 704
    Height = 30
    Align = alBottom
    AutoSize = True
    ButtonHeight = 30
    ButtonWidth = 119
    DrawingStyle = dsGradient
    EdgeInner = esNone
    EdgeOuter = esNone
    Images = RunImageList
    List = True
    ShowCaptions = True
    TabOrder = 3
    Transparent = True
    Wrapable = False
    object StatusHint: TToolButton
      Left = 0
      Top = 0
      AutoSize = True
      Style = tbsTextButton
      Visible = False
    end
    object StatusHintSep: TToolButton
      Left = 14
      Top = 0
      Width = 8
      Caption = 'StatusHintSep'
      ImageIndex = 0
      Style = tbsSeparator
    end
    object AutoLengthBtn: TToolButton
      Left = 22
      Top = 0
      Hint = 'Automatically calculate lengths and areas'
      AutoSize = True
      Caption = 'AutoLength: Off'
      DropdownMenu = AutoLengthMnu
      ParentShowHint = False
      ShowHint = True
      Style = tbsDropDown
    end
    object ToolButton4: TToolButton
      Left = 140
      Top = 0
      Width = 8
      Caption = 'ToolButton4'
      ImageIndex = 0
      Style = tbsSeparator
    end
    object OffsetsBtn: TToolButton
      Left = 148
      Top = 0
      Hint = 'Link offset convention.'
      AutoSize = True
      Caption = 'Offsets: Depth'
      DropdownMenu = OffsetsMnu
      ParentShowHint = False
      ShowHint = True
      Style = tbsDropDown
    end
    object ToolButton3: TToolButton
      Left = 255
      Top = 0
      Width = 8
      Caption = 'ToolButton3'
      ImageIndex = 0
      Style = tbsSeparator
    end
    object FlowUnitsBtn: TToolButton
      Left = 263
      Top = 0
      Hint = 'Choice of flow units (and unit system)'
      AutoSize = True
      Caption = 'Flow Units: CFS'
      DropdownMenu = FlowUnitsMnu
      ParentShowHint = False
      ShowHint = True
      Style = tbsDropDown
    end
    object ToolButton6: TToolButton
      Left = 376
      Top = 0
      Width = 8
      Caption = 'ToolButton6'
      ImageIndex = 0
      Style = tbsSeparator
    end
    object RunStatusButton: TToolButton
      Left = 384
      Top = 0
      Hint = 'No Results Available'
      AutoSize = True
      ImageIndex = 0
      ParentShowHint = False
      ShowHint = True
    end
    object ToolButton7: TToolButton
      Left = 418
      Top = 0
      Width = 8
      Caption = 'ToolButton7'
      ImageIndex = 0
      Style = tbsSeparator
    end
    object ZoomLevelLabel: TToolButton
      Left = 426
      Top = 0
      AutoSize = True
      Caption = 'Zoom Level: 100'
      Style = tbsTextButton
    end
    object ToolButton1: TToolButton
      Left = 523
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      ImageIndex = 0
      Style = tbsSeparator
    end
    object XYLabel: TToolButton
      Left = 531
      Top = 0
      AutoSize = True
      Caption = 'X, Y:'
      Style = tbsTextButton
    end
  end
  object BrowserPageControl: TPageControl
    Left = 0
    Top = 30
    Width = 173
    Height = 389
    ActivePage = BrowserDataPage
    Align = alLeft
    DoubleBuffered = False
    ParentDoubleBuffered = False
    TabOrder = 0
    OnResize = BrowserPageControlResize
    object BrowserDataPage: TTabSheet
      Caption = 'Project'
      object BrowserDataSplitter: TSplitter
        Left = 0
        Top = 158
        Width = 165
        Height = 3
        Cursor = crVSplit
        Align = alBottom
        Beveled = True
        Color = clBtnShadow
        ParentColor = False
        ExplicitTop = 161
      end
      object ItemsPanel: TPanel
        Left = 0
        Top = 161
        Width = 165
        Height = 198
        Align = alBottom
        BevelOuter = bvNone
        ParentBackground = False
        TabOrder = 1
        object ItemsLabel: TLabel
          Left = 0
          Top = 22
          Width = 165
          Height = 18
          Align = alTop
          AutoSize = False
          Caption = 'ItemsLabel'
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlue
          Font.Height = -12
          Font.Name = 'Segoe UI'
          Font.Style = []
          ParentFont = False
          Layout = tlCenter
          ExplicitTop = 13
          ExplicitWidth = 168
        end
        object BrowserToolBar: TToolBar
          Left = 0
          Top = 0
          Width = 165
          Height = 22
          AutoSize = True
          ButtonWidth = 26
          Caption = 'BrowserToolBar'
          DrawingStyle = dsGradient
          Images = BrowserImageList
          TabOrder = 0
          Transparent = True
          object BrowserBtnNew: TToolButton
            Left = 0
            Top = 0
            Hint = 'Add Object'
            ImageIndex = 0
            ParentShowHint = False
            ShowHint = True
            OnClick = BrowserBtnNewClick
          end
          object BrowserBtnDelete: TToolButton
            Left = 26
            Top = 0
            Hint = 'Delete Object'
            ImageIndex = 1
            ParentShowHint = False
            ShowHint = True
            OnClick = BrowserBtnDeleteClick
          end
          object BrowserBtnEdit: TToolButton
            Left = 52
            Top = 0
            Hint = 'Edit Object'
            ImageIndex = 2
            ParentShowHint = False
            ShowHint = True
            OnClick = BrowserBtnEditClick
          end
          object BrowserBtnUp: TToolButton
            Left = 78
            Top = 0
            Hint = 'Move Up'
            ImageIndex = 3
            ParentShowHint = False
            ShowHint = True
            OnClick = BrowserBtnUpClick
          end
          object BrowserBtnDown: TToolButton
            Left = 104
            Top = 0
            Hint = 'Move Down'
            Caption = 'BrowserBtnDown'
            ImageIndex = 4
            ParentShowHint = False
            ShowHint = True
            OnClick = BrowserBtnDownClick
          end
          object BrowserBtnSort: TToolButton
            Left = 130
            Top = 0
            Hint = 'Sort Objects'
            Caption = 'BrowserBtnSort'
            ImageIndex = 5
            ParentShowHint = False
            ShowHint = True
            OnClick = BrowserBtnSortClick
          end
        end
        object ItemListBox: TListBox
          Left = 0
          Top = 40
          Width = 165
          Height = 158
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Style = lbVirtual
          Align = alClient
          DoubleBuffered = False
          ParentDoubleBuffered = False
          TabOrder = 1
          OnClick = ItemListBoxClick
          OnData = ItemListBoxData
          OnDblClick = ItemListBoxDblClick
          OnDrawItem = ItemListBoxDrawItem
          OnKeyDown = ItemListBoxKeyDown
          OnKeyPress = ItemListBoxKeyPress
          OnMouseDown = ItemListBoxMouseDown
        end
      end
      object ObjectTreeView: TTreeView
        Left = 0
        Top = 0
        Width = 165
        Height = 158
        Align = alClient
        AutoExpand = True
        Ctl3D = True
        DoubleBuffered = True
        HideSelection = False
        Indent = 19
        ParentCtl3D = False
        ParentDoubleBuffered = False
        ReadOnly = True
        StateImages = BtnImageList
        TabOrder = 0
        OnChange = ObjectTreeViewChange
        OnClick = ObjectTreeViewClick
        Items.NodeData = {
          030A000000340000000000000000000000FFFFFFFFFFFFFFFF00000000000000
          0000000000010B5400690074006C0065002F004E006F007400650073002C0000
          000100000001000000FFFFFFFFFFFFFFFF00000000000000000000000001074F
          007000740069006F006E007300340000000200000002000000FFFFFFFFFFFFFF
          FF000000000000000000000000010B43006C0069006D00610074006F006C006F
          0067007900300000000300000003000000FFFFFFFFFFFFFFFF00000000000000
          0006000000010948007900640072006F006C006F0067007900320000000A0000
          000A000000FFFFFFFFFFFFFFFF000000000000000000000000010A5200610069
          006E00200047006100670065007300380000000B0000000B000000FFFFFFFFFF
          FFFFFF000000000000000000000000010D530075006200630061007400630068
          006D0065006E00740073002E0000001500000016000000FFFFFFFFFFFFFFFF00
          0000000000000000000000010841007100750069006600650072007300320000
          001500000016000000FFFFFFFFFFFFFFFF000000000000000000000000010A53
          006E006F00770020005000610063006B0073003E0000001500000016000000FF
          FFFFFFFFFFFFFF000000000000000000000000011055006E0069007400200048
          007900640072006F006700720061007000680073003600000015000000160000
          00FFFFFFFFFFFFFFFF000000000000000000000000010C4C0049004400200043
          006F006E00740072006F006C007300320000000400000004000000FFFFFFFFFF
          FFFFFF000000000000000004000000010A4800790064007200610075006C0069
          0063007300280000001500000016000000FFFFFFFFFFFFFFFF00000000000000
          000400000001054E006F00640065007300300000000C0000000C000000FFFFFF
          FFFFFFFFFF00000000000000000000000001094A0075006E006300740069006F
          006E0073002E0000000D0000000D000000FFFFFFFFFFFFFFFF00000000000000
          000000000001084F0075007400660061006C006C0073002E0000000E0000000E
          000000FFFFFFFFFFFFFFFF000000000000000000000000010844006900760069
          006400650072007300380000000F0000000F000000FFFFFFFFFFFFFFFF000000
          000000000000000000010D530074006F007200610067006500200055006E0069
          0074007300280000001500000016000000FFFFFFFFFFFFFFFF00000000000000
          000500000001054C0069006E006B0073002E0000001000000010000000FFFFFF
          FFFFFFFFFF000000000000000000000000010843006F006E0064007500690074
          007300280000001100000011000000FFFFFFFFFFFFFFFF000000000000000000
          0000000105500075006D00700073002E0000001200000012000000FFFFFFFFFF
          FFFFFF00000000000000000000000001084F0072006900660069006300650073
          00280000001300000013000000FFFFFFFFFFFFFFFF0000000000000000000000
          000105570065006900720073002C0000001400000014000000FFFFFFFFFFFFFF
          FF00000000000000000000000001074F00750074006C00650074007300300000
          001500000016000000FFFFFFFFFFFFFFFF000000000000000000000000010954
          00720061006E00730065006300740073002E0000001500000016000000FFFFFF
          FFFFFFFFFF000000000000000000000000010843006F006E00740072006F006C
          0073002C0000000500000005000000FFFFFFFFFFFFFFFF000000000000000002
          00000001075100750061006C00690074007900320000001500000016000000FF
          FFFFFFFFFFFFFF000000000000000000000000010A50006F006C006C00750074
          0061006E0074007300300000001500000016000000FFFFFFFFFFFFFFFF000000
          00000000000000000001094C0061006E006400200055007300650073002A0000
          000600000006000000FFFFFFFFFFFFFFFF000000000000000007000000010643
          00750072007600650073003A0000001500000016000000FFFFFFFFFFFFFFFF00
          0000000000000000000000010E43006F006E00740072006F006C002000430075
          0072007600650073003E0000001500000016000000FFFFFFFFFFFFFFFF000000
          000000000000000000011044006900760065007200730069006F006E00200043
          0075007200760065007300340000001500000016000000FFFFFFFFFFFFFFFF00
          0000000000000000000000010B500075006D0070002000430075007200760065
          007300380000001500000016000000FFFFFFFFFFFFFFFF000000000000000000
          000000010D52006100740069006E006700200043007500720076006500730036
          0000001500000016000000FFFFFFFFFFFFFFFF00000000000000000000000001
          0C5300680061007000650020004300750072007600650073003A000000150000
          0016000000FFFFFFFFFFFFFFFF000000000000000000000000010E530074006F
          0072006100670065002000430075007200760065007300360000001500000016
          000000FFFFFFFFFFFFFFFF000000000000000000000000010C54006900640061
          006C002000430075007200760065007300340000000700000007000000FFFFFF
          FFFFFFFFFF000000000000000000000000010B540069006D0065002000530065
          007200690065007300380000000800000008000000FFFFFFFFFFFFFFFF000000
          000000000000000000010D540069006D00650020005000610074007400650072
          006E007300320000000900000009000000FFFFFFFFFFFFFFFF00000000000000
          0000000000010A4D006100700020004C006100620065006C007300}
      end
    end
    object BrowserMapPage: TTabSheet
      Caption = 'Map'
      ImageIndex = 1
      object MapScrollBox: TScrollBox
        Left = 0
        Top = 0
        Width = 165
        Height = 359
        Align = alClient
        BorderStyle = bsNone
        Ctl3D = False
        ParentCtl3D = False
        TabOrder = 0
        object MapThemesBox: TGroupBox
          Left = 5
          Top = 8
          Width = 129
          Height = 165
          Caption = 'Themes'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 0
          object Label1: TLabel
            Left = 8
            Top = 20
            Width = 82
            Height = 15
            Caption = 'Subcatchments'
          end
          object Label2: TLabel
            Left = 8
            Top = 68
            Width = 34
            Height = 15
            Caption = 'Nodes'
          end
          object Label3: TLabel
            Left = 8
            Top = 114
            Width = 27
            Height = 15
            Caption = 'Links'
          end
          object SubcatchViewBox: TComboBox
            Left = 8
            Top = 35
            Width = 108
            Height = 23
            Style = csDropDownList
            Ctl3D = True
            ParentCtl3D = False
            ParentShowHint = False
            ShowHint = False
            TabOrder = 0
            OnChange = MapViewBoxChange
          end
          object NodeViewBox: TComboBox
            Left = 8
            Top = 83
            Width = 108
            Height = 23
            Style = csDropDownList
            ParentShowHint = False
            ShowHint = False
            TabOrder = 1
            OnChange = MapViewBoxChange
          end
          object LinkViewBox: TComboBox
            Left = 8
            Top = 131
            Width = 108
            Height = 23
            BevelInner = bvNone
            Style = csDropDownList
            Ctl3D = True
            ParentCtl3D = False
            ParentShowHint = False
            ShowHint = False
            TabOrder = 2
            OnChange = MapViewBoxChange
          end
        end
        object MapTimePeriodBox: TGroupBox
          Left = 5
          Top = 188
          Width = 129
          Height = 198
          Caption = 'Time Period'
          Color = clBtnFace
          ParentColor = False
          TabOrder = 1
          object DateLabel: TLabel
            Left = 8
            Top = 20
            Width = 24
            Height = 15
            Caption = 'Date'
          end
          object TimeLabel: TLabel
            Left = 8
            Top = 83
            Width = 64
            Height = 15
            Caption = 'Time of Day'
          end
          object ElapsedTimeLabel: TLabel
            Left = 8
            Top = 146
            Width = 70
            Height = 15
            Caption = 'Elapsed Time'
          end
          object DateListBox: TComboBox
            Left = 8
            Top = 35
            Width = 108
            Height = 23
            Style = csDropDownList
            ParentShowHint = False
            ShowHint = False
            TabOrder = 0
            OnClick = DateListBoxClick
          end
          object DateScrollBar: TScrollBar
            Left = 8
            Top = 57
            Width = 108
            Height = 17
            Ctl3D = True
            PageSize = 0
            ParentCtl3D = False
            TabOrder = 1
            OnChange = DateScrollBarChange
            OnScroll = DateScrollBarScroll
          end
          object TimeListBox: TComboBox
            Left = 8
            Top = 98
            Width = 108
            Height = 23
            Style = csDropDownList
            ParentShowHint = False
            ShowHint = False
            TabOrder = 2
            OnClick = TimeListBoxClick
          end
          object TimeScrollBar: TScrollBar
            Left = 8
            Top = 120
            Width = 108
            Height = 17
            Ctl3D = False
            PageSize = 0
            ParentCtl3D = False
            TabOrder = 3
            OnChange = TimeScrollBarChange
            OnScroll = TimeScrollBarScroll
          end
          object ElapsedTimePanel: TEdit
            Left = 8
            Top = 161
            Width = 84
            Height = 21
            BevelKind = bkFlat
            BorderStyle = bsNone
            Ctl3D = True
            Enabled = False
            ParentCtl3D = False
            ReadOnly = True
            TabOrder = 4
            Text = '0'
          end
          object ElapsedTimeUpDown: TUpDown
            Left = 92
            Top = 161
            Width = 15
            Height = 21
            Associate = ElapsedTimePanel
            Min = -1
            Max = 1
            TabOrder = 5
            TabStop = True
            Wrap = True
            OnChangingEx = ElapsedTimeUpDownChangingEx
          end
        end
        inline AnimatorFrame: TAnimatorFrame
          Left = 5
          Top = 400
          Width = 129
          Height = 87
          AutoSize = True
          TabOrder = 2
          ExplicitLeft = 5
          ExplicitTop = 400
          ExplicitWidth = 129
          ExplicitHeight = 87
          inherited AnimatorBox: TGroupBox
            Width = 129
            Height = 87
            ExplicitWidth = 129
            ExplicitHeight = 87
            inherited RewindBtn: TSpeedButton
              Width = 24
              Height = 21
              ExplicitWidth = 24
              ExplicitHeight = 21
            end
            inherited BackBtn: TSpeedButton
              Left = 33
              Height = 21
              ExplicitLeft = 33
              ExplicitHeight = 21
            end
            inherited PauseBtn: TSpeedButton
              Left = 59
              Width = 22
              Height = 21
              ExplicitLeft = 59
              ExplicitWidth = 22
              ExplicitHeight = 21
            end
            inherited FwdBtn: TSpeedButton
              Left = 86
              Width = 21
              Height = 21
              ExplicitLeft = 86
              ExplicitWidth = 21
              ExplicitHeight = 21
            end
            inherited SpeedBar: TTrackBar
              Top = 47
              Width = 108
              Ctl3D = False
              ParentCtl3D = False
              ExplicitTop = 47
              ExplicitWidth = 108
            end
          end
          inherited Timer: TTimer
            Left = 24
            Top = 48
          end
        end
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 312
    Top = 48
    object MnuFile: TMenuItem
      Caption = '&File'
      OnClick = MnuFileClick
      object MnuNew: TMenuItem
        Caption = '&New'
        OnClick = MnuNewClick
      end
      object MnuOpen: TMenuItem
        Caption = '&Open...'
        OnClick = MnuOpenClick
      end
      object MnuReopen: TMenuItem
        Caption = '&Reopen'
        OnClick = MnuReopenClick
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object MnuSave: TMenuItem
        Caption = '&Save'
        OnClick = MnuSaveClick
      end
      object MnuSaveAs: TMenuItem
        Caption = 'Save &As...'
        OnClick = MnuSaveAsClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object MnuExport: TMenuItem
        Caption = '&Export'
        object MnuExportMap: TMenuItem
          Caption = '&Map...'
          OnClick = MnuExportMapClick
        end
        object MnuExportHotstart: TMenuItem
          Caption = '&Hot Start File...'
          OnClick = MnuExportHotstartClick
        end
        object MnuExportStatusRpt: TMenuItem
          Caption = '&Status/Summary Report...'
          OnClick = MnuExportStatusRptClick
        end
      end
      object MnuCombine: TMenuItem
        Caption = '&Combine...'
        OnClick = MnuCombineClick
      end
      object N10: TMenuItem
        Caption = '-'
      end
      object MnuPageSetup: TMenuItem
        Caption = 'Pa&ge Setup...'
        OnClick = MnuPageSetupClick
      end
      object MnuPrintPreview: TMenuItem
        Caption = 'Print Pre&view'
        OnClick = MnuPrintPreviewClick
      end
      object MnuPrint: TMenuItem
        Caption = '&Print'
        OnClick = MnuPrintClick
      end
      object N11: TMenuItem
        Caption = '-'
      end
      object MnuExit: TMenuItem
        Caption = 'E&xit'
        OnClick = MnuExitClick
      end
    end
    object MnuEdit: TMenuItem
      Caption = '&Edit'
      OnClick = MnuEditClick
      object MnuCopy: TMenuItem
        Caption = '&Copy To...'
        Enabled = False
        OnClick = MnuCopyClick
      end
      object N3: TMenuItem
        Caption = '-'
      end
      object MnuSelectObject: TMenuItem
        Caption = '&Select Object'
        OnClick = MnuSelectObjectClick
      end
      object MnuSelectVertex: TMenuItem
        Caption = 'Select &Vertex'
        Enabled = False
        OnClick = MnuSelectVertexClick
      end
      object MnuSelectRegion: TMenuItem
        Caption = 'Select &Region'
        OnClick = MnuSelectRegionClick
      end
      object MnuSelectAll: TMenuItem
        Caption = 'Select &All'
        OnClick = MnuSelectAllClick
      end
      object N16: TMenuItem
        Caption = '-'
      end
      object MnuFindObject: TMenuItem
        Caption = '&Find Object...'
        OnClick = MnuFindObjectClick
      end
      object N21: TMenuItem
        Caption = '-'
      end
      object MnuEditObject: TMenuItem
        Caption = '&Edit Object...'
        OnClick = BrowserBtnEditClick
      end
      object MnuDeleteObject: TMenuItem
        Caption = '&Delete Object'
        OnClick = BrowserBtnDeleteClick
      end
      object N17: TMenuItem
        Caption = '-'
      end
      object MnuGroupEdit: TMenuItem
        Caption = '&Group Edit...'
        Enabled = False
        OnClick = MnuGroupEditClick
      end
      object MnuGroupDelete: TMenuItem
        Caption = 'G&roup Delete...'
        Enabled = False
        OnClick = MnuGroupDeleteClick
      end
    end
    object MnuView: TMenuItem
      Caption = '&View'
      object MnuDimensions: TMenuItem
        Tag = 16
        Caption = '&Dimensions...'
        OnClick = MnuDimensionsClick
      end
      object MnuBackdrop: TMenuItem
        Caption = '&Backdrop'
        OnClick = MnuBackdropClick
        object MnuBackdropLoad: TMenuItem
          Caption = '&Load...'
          OnClick = MnuBackdropLoadClick
        end
        object MnuBackdropUnload: TMenuItem
          Caption = '&Unload'
          OnClick = MnuBackdropUnloadClick
        end
        object N15: TMenuItem
          Caption = '-'
        end
        object MnuBackdropAlign: TMenuItem
          Caption = '&Align'
          Enabled = False
          OnClick = MnuBackdropAlignClick
        end
        object MnuBackdropResize: TMenuItem
          Caption = '&Resize...'
          Enabled = False
          OnClick = MnuBackdropResizeClick
        end
        object N18: TMenuItem
          Caption = '-'
        end
        object MnuBackdropWatermark: TMenuItem
          Caption = '&Watermark'
          Enabled = False
          OnClick = MnuBackdropWatermarkClick
        end
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object MnuPan: TMenuItem
        Tag = 104
        Caption = '&Pan'
        OnClick = MapActionClick
      end
      object MnuZoomIn: TMenuItem
        Tag = 105
        Caption = 'Zoom &In'
        OnClick = MapActionClick
      end
      object MnuZoomOut: TMenuItem
        Tag = 106
        Caption = 'Zoom &Out'
        OnClick = MapActionClick
      end
      object MnuFullExtent: TMenuItem
        Tag = 107
        Caption = 'Full &Extent'
        OnClick = MapActionClick
      end
      object N14: TMenuItem
        Caption = '-'
      end
      object MnuQuery: TMenuItem
        Caption = '&Query...'
        OnClick = MnuQueryClick
      end
      object MnuOVMap: TMenuItem
        Caption = 'Over&view'
        OnClick = MnuOVMapClick
      end
      object N12: TMenuItem
        Caption = '-'
      end
      object MnuObjects: TMenuItem
        Caption = '&Objects'
        OnClick = MnuObjectsClick
        object MnuShowGages: TMenuItem
          Caption = '&Rain Gages'
          Checked = True
          OnClick = MnuShowObjectsClick
        end
        object MnuShowSubcatch: TMenuItem
          Caption = '&Subcatchments'
          Checked = True
          OnClick = MnuShowObjectsClick
        end
        object MnuShowNodes: TMenuItem
          Caption = '&Nodes'
          Checked = True
          OnClick = MnuShowObjectsClick
        end
        object MnuShowLinks: TMenuItem
          Caption = '&Links'
          Checked = True
          OnClick = MnuShowObjectsClick
        end
        object MnuShowLabels: TMenuItem
          Caption = 'Lab&els'
          Checked = True
          OnClick = MnuShowObjectsClick
        end
        object MnuShowBackdrop: TMenuItem
          Caption = '&Backdrop'
          OnClick = MnuShowBackdropClick
        end
      end
      object MnuLegends: TMenuItem
        Caption = '&Legends'
        OnClick = MnuLegendsClick
        object MnuSubcatchLegend: TMenuItem
          Caption = '&Subcatchment'
          Checked = True
          OnClick = MnuSubcatchLegendClick
        end
        object MnuNodeLegend: TMenuItem
          Caption = '&Node'
          Checked = True
          OnClick = MnuNodeLegendClick
        end
        object MnuLinkLegend: TMenuItem
          Caption = '&Link'
          Checked = True
          OnClick = MnuLinkLegendClick
        end
        object MnuTimeLegend: TMenuItem
          Caption = '&Time'
          Checked = True
          OnClick = MnuTimeLegendClick
        end
        object N6: TMenuItem
          Caption = '-'
        end
        object MnuModifyLegend: TMenuItem
          Caption = '&Modify'
          OnClick = MnuModifyLegendClick
          object MnuModifySubcatchLegend: TMenuItem
            Caption = '&Subcatchment'
            OnClick = MnuModifySubcatchLegendClick
          end
          object MnuModifyNodeLegend: TMenuItem
            Caption = '&Node'
            OnClick = MnuModifyNodeLegendClick
          end
          object MnuModifyLinkLegend: TMenuItem
            Caption = '&Link'
            OnClick = MnuModifyLinkLegendClick
          end
        end
      end
    end
    object MnuProject: TMenuItem
      Caption = '&Project'
      object MnuProjectSummary: TMenuItem
        Caption = '&Summary'
        OnClick = MnuProjectSummaryClick
      end
      object MnuProjectDetails: TMenuItem
        Caption = '&Details'
        OnClick = MnuProjectDetailsClick
      end
      object MnuProjectDefaults: TMenuItem
        Caption = 'De&faults...'
        OnClick = MnuProjectDefaultsClick
      end
      object MnuProjectCalibData: TMenuItem
        Caption = '&Calibration Data...'
        OnClick = MnuProjectCalibDataClick
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object MnuAddObject: TMenuItem
        Caption = 'Add Object'
        OnClick = BrowserBtnNewClick
      end
      object N22: TMenuItem
        Caption = '-'
      end
      object MnuProjectRunSimulation: TMenuItem
        Caption = '&Run Simulation'
        OnClick = MnuProjectRunSimulationClick
      end
    end
    object MnuReport: TMenuItem
      Caption = '&Report'
      OnClick = MnuReportClick
      object MnuReportStatus: TMenuItem
        Caption = '&Status'
        OnClick = MnuReportStatusClick
      end
      object MnuReportSummary: TMenuItem
        Caption = 'S&ummary'
        OnClick = MnuReportSummaryClick
      end
      object MnuReportGraph: TMenuItem
        Caption = '&Graph'
        OnClick = MnuReportGraphClick
        object MnuGraphProfile: TMenuItem
          Caption = '&Profile'
          OnClick = MnuGraphProfileClick
        end
        object MnuGraphTimeSeries: TMenuItem
          Caption = '&Time Series'
          OnClick = MnuGraphTimeSeriesClick
        end
        object MnuGraphScatter: TMenuItem
          Caption = '&Scatter'
          OnClick = MnuGraphScatterClick
        end
      end
      object MnuReportTable: TMenuItem
        Caption = '&Table'
        object MnuTableByObject: TMenuItem
          Caption = 'By &Object'
          OnClick = MnuTableByObjectClick
        end
        object MnuTableByVariable: TMenuItem
          Caption = 'By &Variable'
          OnClick = MnuTableByVariableClick
        end
      end
      object MnuReportStatistics: TMenuItem
        Caption = 'St&atistics'
        OnClick = MnuReportStatisticsClick
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object MnuReportOptions: TMenuItem
        Caption = '&Customize...'
        OnClick = MnuReportCustomizeClick
      end
    end
    object MnuTools: TMenuItem
      Caption = '&Tools'
      object MnuProgramOptions: TMenuItem
        Caption = '&Program Preferences...'
        OnClick = MnuPreferencesClick
      end
      object MnuMapDisplayOptions: TMenuItem
        Caption = '&Map Display Options...'
        OnClick = MnuViewOptionsClick
      end
      object MnuConfigureTools: TMenuItem
        Caption = '&Configure Tools...'
        OnClick = MnuConfigureToolsClick
      end
      object N7: TMenuItem
        Caption = '-'
      end
    end
    object MnuWindow: TMenuItem
      Caption = '&Window'
      OnClick = MnuWindowClick
      object MnuWindowCascade: TMenuItem
        Caption = '&Cascade'
        OnClick = MnuWindowCascadeClick
      end
      object MnuWindowTile: TMenuItem
        Caption = '&Tile'
        OnClick = MnuWindowTileClick
      end
      object MnuWindowCloseAll: TMenuItem
        Caption = 'C&lose All'
        OnClick = MnuWindowCloseAllClick
      end
    end
    object MnuHelp: TMenuItem
      Caption = '&Help'
      object MnuHelpTopics: TMenuItem
        Caption = '&Help Topics'
        OnClick = MnuHelpTopicsClick
      end
      object MnuHowdoI: TMenuItem
        Caption = 'How do I...'
        OnClick = MnuHowdoIClick
      end
      object N13: TMenuItem
        Caption = '-'
      end
      object MnuHelpUnits: TMenuItem
        Caption = '&Measurement Units'
        OnClick = MnuHelpUnitsClick
      end
      object MnuHelpErrors: TMenuItem
        Caption = '&Error Messages'
        OnClick = MnuHelpErrorsClick
      end
      object N19: TMenuItem
        Caption = '-'
      end
      object MnuHelpTutorial: TMenuItem
        Caption = '&Tutorial'
        OnClick = MnuHelpTutorialClick
      end
      object N4: TMenuItem
        Caption = '-'
      end
      object MnuAbout: TMenuItem
        Caption = '&About...'
        OnClick = MnuAboutClick
      end
    end
  end
  object OpenDialog: TOpenDialog
    Options = [ofHideReadOnly]
    Left = 216
    Top = 48
  end
  object SaveDialog: TSaveDialog
    Options = [ofOverwritePrompt, ofHideReadOnly]
    Left = 216
    Top = 216
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [fdAnsiOnly]
    Left = 216
    Top = 272
  end
  object OpenPictureDialog: TOpenPictureDialog
    Filter = 
      'All (*.bmp;*.emf;*.wmf;*.jpg;*.jpeg)|*.bmp;*.emf;*.wmf;*.jpg;*.j' +
      'peg|Bitmaps (*.bmp)|*.bmp|Enhanced Metafiles (*.emf)|*.emf|Metaf' +
      'iles (*.wmf)|*.wmf|JPEG Files (*.jpg)|*.jpg'
    Options = [ofHideReadOnly, ofFileMustExist]
    Title = 'Open a Backdrop Map'
    Left = 216
    Top = 104
  end
  object BrowserImageList: TImageList
    Left = 408
    Top = 160
    Bitmap = {
      494C010106001402480210001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000000080000000
      8000000080000000800000008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000008000000080000000
      0000000000000000000000008000000000000000000000000000000000008080
      8000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000080000000
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      8000000080000000000000000000000000000000000000000000808080000000
      0000000000000000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF0000FFFF0000FFFF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000
      0000000000000000000000000000000000000000000000008000000000000000
      0000000000000000800000008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF0000FFFF0000FFFF0000000000000000
      0000000000000000000000000000000000000000000000008000000080000000
      8000000080000000800000008000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF0000FFFF0000FFFF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF0000FFFF0000FFFF0000000000000000
      0000000000000000000000000000000000000000000080000000800000008000
      0000000000008000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF0000FFFF0000FFFF0000000000000000
      0000000000000000000000000000000000000000000080808000800000000000
      0000000000000000000080000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008000
      0000000000008000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008000
      0000800000008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000800000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000800000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008400000084000000840000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF0000FFFF0000FFFF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000084000000FF000000840000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF0000FFFF0000FFFF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000084000000FF000000840000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000080000000800000008000000080000000800000008000000080000000
      80000000800000000000000000000000000000000000000000000000000000FF
      FF000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF0000FFFF0000FFFF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000084000000840000008400000084000000FF000000840000008400000084
      0000008400000000000000000000000000000000000000000000000000000000
      0000000080000000FF000000FF000000FF000000FF000000FF000000FF000000
      FF00000080000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF0000FFFF0000FFFF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000084000000FF000000FF000000FF000000FF000000FF000000FF000000FF
      0000008400000000000000000000000000000000000000000000000000000000
      0000000080000000800000008000000080000000800000008000000080000000
      8000000080000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000084000000840000008400000084000000FF000000840000008400000000
      0000008400000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF00000000000000000000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000FFFF0000FFFF0000FFFF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FF000000840000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFF000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000084000000FF000000840000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000008400000084000000840000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000FFFF81F700000000
      FFFF9DE300000000FF7FCFE300000000FE3FE7C100000000FC1FF3C100000000
      F80FB9F700000000F00781F700000000FC1FFFF700000000FC1F88F700000000
      FC1F9CF700000000FC1FC1F700000000FFFFC9F700000000FFFFE3F700000000
      FFFFE3F700000000FFFFF7F700000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFE0BFFFFFFFFFFFFFC03FC1FFE3FFFFFBC03FC1FFE3FFFFFC803FC1F
      FE3FF007C003FC1FF007F007E003F007F007F007F003F80FF007FFFFF803FC1F
      FE3FFFFFFC0FFE3FFE3FFFFFFE3FFF7FFE3FFFFFFF1FFFFFFFFFFFFFFF8FFFFF
      FFFFFFFFFFDFFFFFFFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object TablePopupMenu: TPopupMenu
    Left = 312
    Top = 272
    object PopupTableByObject: TMenuItem
      Caption = 'by &Object'
      OnClick = MnuTableByObjectClick
    end
    object PopupTableByVariable: TMenuItem
      Caption = 'by &Variable'
      OnClick = MnuTableByVariableClick
    end
  end
  object OpenTextFileDialog: TOpenTxtFileDialog
    Options = [ofHideReadOnly]
    ShowPreview = True
    WordWrap = False
    Left = 216
    Top = 160
  end
  object AutoLengthMnu: TPopupMenu
    AutoHotkeys = maManual
    Left = 312
    Top = 104
    object AutoLengthOnMnu: TMenuItem
      Caption = 'Auto-Length: On'
      OnClick = AutoLengthOnMnuClick
    end
    object AutoLengthOffMnu: TMenuItem
      Caption = 'Auto-Length: Off'
      OnClick = AutoLengthOffMnuClick
    end
  end
  object FlowUnitsMnu: TPopupMenu
    AutoHotkeys = maManual
    Left = 312
    Top = 160
    object CFSMnuItem: TMenuItem
      Caption = 'CFS'
      OnClick = FlowUnitsMnuItemClick
    end
    object GPMMnuItem: TMenuItem
      Caption = 'GPM'
      OnClick = FlowUnitsMnuItemClick
    end
    object MGDMnuItem: TMenuItem
      Caption = 'MGD'
      OnClick = FlowUnitsMnuItemClick
    end
    object N20: TMenuItem
      Caption = '-'
    end
    object CMSMnuItem: TMenuItem
      Caption = 'CMS'
      OnClick = FlowUnitsMnuItemClick
    end
    object LPSMnuItem: TMenuItem
      Caption = 'LPS'
      OnClick = FlowUnitsMnuItemClick
    end
    object MLDMnuItem: TMenuItem
      Caption = 'MLD'
      OnClick = FlowUnitsMnuItemClick
    end
  end
  object OffsetsMnu: TPopupMenu
    AutoHotkeys = maManual
    Left = 312
    Top = 216
    object OffsetsMnuDepth: TMenuItem
      Caption = 'Depth Offsets'
      OnClick = OffsetsMnuItemClick
    end
    object OffsetsMnuElev: TMenuItem
      Tag = 1
      Caption = 'Elevation Offsets'
      OnClick = OffsetsMnuItemClick
    end
  end
  object BtnImageList: TImageList
    Left = 408
    Top = 104
    Bitmap = {
      494C01012600BC01F00110001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      000000000000360000002800000040000000A0000000010020000000000000A0
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000808080008080
      8000808080008080800080808000808080008080800080808000808080008080
      8000808080008080800080808000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000000000008080800080808000000000000000
      000080808000FFFFFF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000000000000000000080808000000000000000000080808000808080000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000808080000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000808080000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800000000000808080008080800080808000000000008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000008080800080808000000000008080800080808000808080000000
      0000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000000000000000000080808000808080000000000080808000808080000000
      0000000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000808080008080800000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000000000000000000000000000000000000000000000000000808080000000
      0000808080008080800000000000000000008080800080808000000000000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000000000000000000000000000000000000808080000000
      0000000000008080800080808000000000000000000080808000808080000000
      0000808080008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000000000000000000000000000000000000FFFFFF008080
      8000000000000000000080808000808080000000000000000000808080008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00000000000000000000000000000000000000000000000
      0000808080000000000000000000808080008080800000000000000000008080
      8000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C000C0C0C000C0C0C000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000FFFFFF008080800080808000000000008080800080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000004E4E4E002D2D
      2D00505050000000000000000000000000000000000000000000000000002D2D
      2D00050505002525250000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000038383800B0B0
      B000353535005757570057575700575757005757570057575700575757001A1A
      1A00B2B2B2001515150000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000003A3A3A006262
      6200383838006FDF9D0078E0A30074E09E005FDD930056DE930051DE91001A1A
      1A00636363000909090000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000063636300ACAC
      AC00575757004FCB5C0057D77A0042D16A0070C75E00B6B85000CBAE3F003A3A
      3A009A9A9A003A3A3A0000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000005C5C5C006D6D
      6D005F5F5F004FC445004BBA2C00D8BD6000FFBA6200FFB96500DBBB7D004242
      42004C4C4C002F2F2F0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000656565008989
      8900656565007FBF3600DDC56900FFC27000FFBF6700AECBAC0068E0F9004848
      48006E6E6E00383838000000000000000000000000000000000000000000FFFF
      FF00FFFFFF000000000000000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000006E6E6E00A4A4
      A4006C6C6C00F8C66E00FFC87700FFC57200FFC46C0098D8CF0099E4EB004E4E
      4E008E8E8E00414141000000000000000000000000000000000000000000FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000696969007171
      7100686868005757570057575700575757005757570057575700575757003232
      32004D4D4D00393939000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000077777700AAAA
      AA007474740072E29E007CE3A40078E3A00063E095005AE1950055E293005656
      5600949494004B4B4B0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000777777009797
      9700777777004FCB5C0057D77A0042D16A0070C75E00B6B85000CBAE3F005B5B
      5B007C7C7C004B4B4B00000000000000000000000000FFFFFF00000000000000
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000777777008585
      85007A7A7A004FC445004BBA2C00D8BD6000FFBA6200FFB96500DBBB7D005E5E
      5E00656565004B4B4B00000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000083838300AFAF
      AF007C7C7C007FBF3600DDC56900FFC27000FFBF6700AECBAC0068E0F9006060
      6000ACACAC005C5C5C00000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000006C6C6C007474
      740068686800E6BC7100EDBE7900ECBB7300ECB96D0084CDCF0084D8EB004B4B
      4B00686868003D3D3D0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000073737300A6A6
      A600696969005757570057575700575757005757570057575700575757004D4D
      4D009A9A9A006262620000000000000000000000000000000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000898989007676
      7600808080000000000000000000000000000000000000000000000000006E6E
      6E00515151006666660000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000808080000000000080808000000000008080800000000000808080000000
      0000808080000000000080808000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000FFFFFF000000000000000000FFFFFF000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000FF00000000000000FF0000000000000000000000FF000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000FFFFFF000000000000000000FFFFFF000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000080808000000000000000
      0000FF000000000000000000000000000000FF00000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FF00000000000000000000000000000000000000FF00
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000FFFFFF000000000000000000FFFFFF000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF00FFFFFF000000
      0000000000000000000000000000000000000000000080808000000000000000
      000000000000000000000000000000000000FF00000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF00FFFFFF00FFFFFF0000000000C0C0C00000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000FF0000000000
      000000000000FF000000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000000000000FFFFFF000000000000000000FFFFFF000000
      00000000000000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF0000000000C0C0
      C00000000000FFFFFF0000000000C0C0C00000000000C0C0C000000000000000
      0000000000000000000080000000800000000000000080808000000000000000
      000000000000000000000000000000000000FF00000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00FFFFFF000000
      0000C0C0C00000000000C0C0C00000000000C0C0C00000000000C0C0C000C0C0
      C000C0C0C0000000000080000000800000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000FF0000000000
      00000000000000000000000000000000000000000000FF000000FF000000FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000FF000000FF000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C00000000000C0C0C00000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00080000000800000000000000080808000000000000000
      000000000000000000000000000000000000FF00000000000000000000000000
      0000FF00000000000000000000000000000000000000BFBFBF00BFBFBF00FF00
      0000FF000000FF000000FF000000FF000000FF000000FF000000FF000000FF00
      0000FF000000BFBFBF00BFBFBF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000C0C0C00000000000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000080000000800000000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000007F7F7F000000
      000000000000000000007F7F7F000000000000000000000000007F7F7F000000
      000000000000000000007F7F7F00000000000000000000000000000000000000
      0000000000000000000000000000000000008080800000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF00000000000000000000000000007F7F7F000000
      00007F7F7F00000000007F7F7F00000000007F7F7F00000000007F7F7F000000
      00007F7F7F00000000007F7F7F00000000000000000000000000000000000000
      000000000000000000000000000000FFFF000000000080808000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFF0000FFFF0000FFFF0000000000007F7F7F007F7F7F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000FFFF0000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000FFFF0000FFFF00FFFFFF0000FFFF0000FFFF00000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF000000000000000000007F7F7F00000000000000
      FF00000000000000000000000000000000000000000000000000FF0000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000FFFF0000FFFF000000000000FFFF0000FFFF0000FFFF
      0000FFFF00000000000000000000000000000000000000000000000000000000
      00000000FF00000000000000FF000000FF0000000000FF00000000000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000FFFF00FFFFFF0000FFFF0000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFF0000FFFF0000FFFF0000FFFF000000000000FFFF0000FFFF00000000
      0000000000000000000000000000000000007F7F7F007F7F7F00000000007F7F
      7F000000FF007F7F7F000000FF007F7F7F000000FF007F7F7F007F7F7F00FF00
      00007F7F7F007F7F7F007F7F7F007F7F7F000000000000000000000000000000
      000000000000000000000000000000FFFF00FFFFFF0000FFFF00000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF000000000000FFFF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000FF0000000000000000000000FF0000000000000000000000
      0000FF000000000000000000000000000000000000000000000000000000FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF0000FFFF0000FFFF00000000000000000000000000000000
      000000000000000000000000000000000000000000007F7F7F0000000000FF00
      0000000000000000000000000000FF000000000000000000FF00000000000000
      00000000FF000000000000000000000000000000000000000000000000000000
      0000FFFFFF0000FFFF00FFFFFF0000FFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FF00000000000000FF00000000000000000000000000FF00000000000000
      FF00FF0000000000FF0000000000000000000000000000000000000000000000
      000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF0000000000808080000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF00000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F007F7F7F00000000007F7F
      7F00FF0000007F7F7F00FF0000007F7F7F007F7F7F007F7F7F000000FF007F7F
      7F007F7F7F00FF0000000000FF007F7F7F000000000000000000000000000000
      00000000000000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF00000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF0000FFFF00FFFFFF00FFFFFF000000
      0000808080000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007F7F7F00000000000000
      000000000000FF00000000000000000000000000000000000000000000000000
      00000000000000000000FF000000000000000000000000000000000000000000
      00000000000000000000FFFFFF0000FFFF00FFFFFF00FFFFFF0000FFFF00FFFF
      FF00000000008080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007F7F7F007F7F7F00000000007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F7F007F7F
      7F007F7F7F007F7F7F007F7F7F007F7F7F000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000800000008000000080000000800000008000
      0000800000008000000080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF0000FFFF00000080000080808000FFFF0000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00800000000000000000000000FFFFFF00000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF000000000000000000000000000000000000000000000000000000FF000000
      FF000000000000000000000000000000000000000000FF000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000FFFF0000FFFF000000800000808080000080000080808000FFFF0000FFFF
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF000000000000000000000000000000
      000000000000FFFFFF00800000000000000000000000FFFFFF00000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF000000000000000000000000000000000000000000000000000000FF000000
      FF000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF000080808000008000008080800000800000FFFF0000FFFF
      0000FFFF00000000000000000000000000000000000000000000000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0080000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      0000FFFF0000FFFF00000080000080808000008000008080800000800000FFFF
      0000FFFF000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0080000000FFFFFF000000000000000000000000000000
      000000000000FFFFFF0080000000000000000000000000000000FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      00000000000000000000000000000000000000000000FF000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF0000FFFF
      0000FFFF0000FFFF00008080800000800000808080000080000080808000FFFF
      0000FFFF0000FFFF0000000000000000000000000000FFFFFF00000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0080000000000000000000000000000000FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      00000000000000000000000000000000000000000000000000000000FF000000
      FF0000000000000000000000000000000000FF00000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF00008080
      8000008000008080800000800000808080000080000080808000008000008080
      8000FFFF0000FFFF0000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0080000000FFFFFF000000000000000000FFFFFF008000
      0000800000008000000080000000000000000000000000000000FFFFFF000000
      00000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      FF000000FF000000000000000000FF0000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF00000080
      0000808080000080000080808000008000008080800000800000808080000080
      0000FFFF000000800000000000000000000000000000FFFFFF00000000000000
      0000000000000000000080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      0000FFFFFF008000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000FF000000FF000000000000000000FF00000000000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF00008080
      8000008000008080800000800000808080000080000080808000008000008080
      80000080000080808000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0080000000FFFFFF00FFFFFF00FFFFFF00FFFFFF008000
      000080000000000000000000000000000000000000000000000000000000FFFF
      FF000000000000000000000000000000000000000000FFFFFF00000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      00000000FF000000FF00000000000000000000000000FF000000000000000000
      00000000000000000000000000000000000000000000FFFF0000FFFF00000080
      0000808080000080000080808000FFFF00008080800000800000FFFF00000080
      00008080800000800000000000000000000000000000FFFFFF00000000000000
      0000FFFFFF000000000080000000800000008000000080000000800000008000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000FF000000FF00000000000000
      00000000FF000000FF00000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF0000FFFF
      00000080000080808000FFFF0000FFFF0000FFFF0000FFFF0000FFFF00008080
      80000080000000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF0000000000FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000FF000000FF000000
      FF000000FF0000000000000000000000000000000000FF000000000000000000
      0000000000000000000000000000000000000000000000000000FFFF00000080
      0000808080000080000080808000008000008080800000800000808080000080
      00008080800000000000000000000000000000000000FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FF000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000FFFF00008080800000800000808080000080000080808000008000008080
      8000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FF000000FF00
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFF000080808000008000008080800000800000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C000000000000080800000000000000000000000000000000000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000C0C0C000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000000
      0000000000000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C000000000000080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C0000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF00000000000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000000000000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000C0C0C000C0C0
      C0000000000000808000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C00000FFFF0000FFFF0000FFFF00C0C0C000C0C0
      C00000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF0000FFFF000000
      0000008080000080800000808000008080000080800000808000008080000080
      8000008080000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      00000000000000808000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000808080008080800080808000C0C0C000C0C0
      C00000000000C0C0C0000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00000000000080800000808000008080000080800000808000008080000080
      8000008080000080800000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000008080000080800000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000C0C0C000C0C0C00000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000080
      8000000000000000000000000000000000000000000000000000000000000000
      00000080800000808000000000000000000000000000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C0000000
      0000C0C0C00000000000C0C0C00000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000000000000080800000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000C0C0
      C00000000000C0C0C0000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF000000000000000000000000000000000000000000FFFFFF0000FFFF00FFFF
      FF0000FFFF00FFFFFF0000FFFF00FFFFFF0000FFFF00FFFFFF00000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C00000000000008080000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000
      0000C0C0C00000000000C0C0C00000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00000000000000000000000000000000000000000000FFFF00FFFFFF0000FF
      FF00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000000000000080800000000000000000000000000000000000000000000000
      0000FFFFFF000000000000000000000000000000000000000000FFFFFF000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000000000000080800000000000000000000000000000000000000000000000
      0000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000000000000000000000000000000000000000000000000000000000000000
      000000000000FFFFFF000000000000000000000000000000000000000000FFFF
      FF0000000000000000000000000000000000000000000000000000000000FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000008080000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C00000000000C0C0C00000000000000000000000000000000000000000000000
      000000000000FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000A00000000100010000000000000500000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFF00000000FFFFFFFF00000000
      FFFFFFFF00000000C007FC3F00000000CFE7FE7F00000000D7D7FE7F00000000
      DBB7FE7F000000001D71FE7F000000001EF1FE7F000000001D71FE7F00000000
      DBB7FE7F00000000D7D7FE7F00000000CFE7E66700000000C007E00700000000
      FFFFFFFF00000000FFFFFFFF00000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFF0FFC007C007FFFFEF7FDFF7DFF7FFFFDFBFDC77DFF7
      DFFDBFDFDBB7DEF7DFFDBFDF17D11D71C001BFDF17D11BB1DFFDBFC017D117D1
      DFFDBFFEDBB7CFE7FFFFDFFEDC77DFF7FFFFEFFEDFF7DFF7FFFFF000C007FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      F81FFEFFFEFF8001F7EFFEFFFD7FBFFDEFF7FD7FFBBFBFFDDFFBFD7FF7DFBE0D
      DFFBFBBFEFEFBFFDDFFBFBBFDFF7B03DDFFBF7DFBFFBBFFDDFFBF7DFDFF7BFFD
      DFFBEFEFEFEF8001EFF7EFEFF7DFBFFDF7EFDFF7FBBFBFFDF81FC007FD7FBFFD
      FFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFF8000FFFFFFFF8FF10000F6FF8001
      9FF97FFCFFBFA921AFF57FFCF6FFA491F00F6DB4FFFF8249F7EF0001FBBFA025
      F7EFFFFFFEFF9011F7EFDFF7E00F8809F7EF9EF3D007A405F7EF038190039211
      F7EF9EF3A0038901F00FDEF7A0018485AFF5FEFFC80192419FF9FB7FE403812D
      8FF1FBBFF03F8001FFFFFC7FFFFFFFFFFFFFFFFFFFF9FFF91FF8FFFFFFF1FFF1
      0000F01FFFE3FFE31FF8F7DFFFC7FFC7BFF7E7EFE08FE08FBFEFEFEFDF1FDF1F
      BF1FCFF7BF9FBF9F1F1FDFF77BDF7FDF1F1FD7F77BDF7FDF1FEFE7F760DF60DF
      EFF7F5577BDF7FDFF1F8F54F7BDF7FDFF000F93FBFBFBFBFF1F8FEFFDF7FDF7F
      FFFFFFFFE0FFE0FFFFFFFFFFFFFFFFFFC7E3F800FFFFFFFFC003F800FFFFF7FF
      C003F800FF9FF3FFC003F800FF9FF5FFC003C000FF3FF6FFC003C200F73FF701
      C003C000F27FF7FBC003C007F07FF7F7C0030007F00FF7EFC0031007F01FF7DF
      C0030007F03FF7BFC003001FF07FF77FC003001FF0FFF6FFC003401FF1FFF5FF
      C7E3001FF3FFF3FFFFFFFFFFF7FFF7FFFFFFFFFFFFFFFFFFD5550000FFFF000F
      80010000C007000FDFFF0000E7E7000F95BF0000F3F7000FDFFF0000F9F7000F
      977F0000FCFF000FDDEF0000FE7F000F9F7F0000FF3F000FDBDB0000FE7F0004
      9F7F0000FCFF0000DBDF0000F9F700009F770000F3F7F800DFFF0000E7E7FC00
      9FFFFFFFC007FE04FFFFFFFFFFFFFFFFFFFFFFFFFFFCDDDDFC7FC001FFF0D555
      FC3FDFFDFFC00000F01FD005FF00DFFFF00FDFFDFC008FDFF80FD01DF000D4AF
      F81FDFFDC0060000C00FD005001EDB77C007DFFD003E8EB7E00FD01D007ED5A3
      E01FDFFD037F0000F00FD005077FDBFBF007DFFD1F7F9BFDF803C0017FFFDFFF
      F803FFFF7FFF0000FFFFFFFF7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC8F83F
      FC0107C1FFB8E00FFC0107C1CFBFC007FC0107C1CFBC800300010101FFBC8003
      00010001DFBF000100010201CF7C000100010201E6FC000100038003F37F0001
      0007C10733BC0001000FC10733BC800300FFE38F87BF800301FFE38FFFB8C007
      03FFE38FFFC8E00FFFFFFFFFFFFFF83FFFFFFFFFFFFFFFFFFFFFFFFFC001C007
      C007001F80018003C007000F80010001C007000780010001C007000380010001
      C007000180010000C007000080010000C007001F80018000C007001F8001C000
      C007001F8001E001C0078FF18001E007C00FFFF98001F007C01FFF758001F003
      C03FFF8F8001F803FFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object thePrinter: TPrintControl
    Left = 408
    Top = 272
  end
  object ReportPopupMenu: TPopupMenu
    Left = 312
    Top = 328
    object PopupReportStatus: TMenuItem
      Caption = '&Status Report'
      OnClick = MnuReportStatusClick
    end
    object PopupReportSummary: TMenuItem
      Caption = 'S&ummary Results'
      OnClick = MnuReportSummaryClick
    end
  end
  object RunImageList: TImageList
    Left = 408
    Top = 216
    Bitmap = {
      494C0101040058018C0110001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000002000000001002000000000000020
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007A9DB8001D5887007A9D
      B800F2F5F8000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007A9DB8001D5887007A9D
      B800F2F5F8000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007A9DB8001D5887007A9D
      B800F2F5F8000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007A9DB8001D5887007A9D
      B800F2F5F8000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001D58870056A2D600387B
      AC0095B0C7000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001D58870056A2D600387B
      AC0095B0C7000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001D58870056A2D600387B
      AC0095B0C7000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001D58870056A2D600387B
      AC0095B0C7000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001D58870056A2D600458C
      BE00608AAB000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001D58870056A2D600458C
      BE00608AAB000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001D58870056A2D600458C
      BE00608AAB000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000001D58870056A2D600458C
      BE00608AAB000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000407299004D97CA0056A2
      D6001D5887000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000407299004D97CA0056A2
      D6001D5887000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000407299004D97CA0056A2
      D6001D5887000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000407299004D97CA0056A2
      D6001D5887000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000086A5BF003C80B10056A2
      D6001D5887000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007EA0BB003C80B10056A2
      D6001D5887000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000086A5BF003C80B10056A2
      D6001D5887000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000086A5BF003C80B10056A2
      D6001D588700000000000000000000000000CCA97D00D7821F00EC860B00EA85
      0B00D9861800BD925800000000000000000000000000C4D3DF002C6B9C0056A2
      D6001D5887000000000000000000000000006F955B003CA3450033B2470033B1
      470038A54700558B4C00000000000000000000000000B4C7D7002C6B9C0056A2
      D6001D5887000000000000000000000000006CAEBA000D92C5000291CA000290
      C9000892C800449EBA00000000000000000000000000C4D3DF002C6B9C0056A2
      D6001D5887000000000000000000000000007D86CC001F36D7000B25EC000B25
      EA00182AD9005861BD00000000000000000000000000C4D3DF002C6B9C0056A2
      D6001D588700000000000000000000000000F9A43F0000000000000000000000
      000000000000F9AA3500EC8D0D00D8AC6E00FEEFD800EFCD9C00161D3200539E
      D4002B6A9A00C8D6E2000000000000000000829D4B009BDEA500A3E0AA00A3E0
      AA00ABE3B1006ACD7B0035B34C006FAA6800D3E7C100C5CC9800161D3200539E
      D4002B6A9A00C8D6E200000000000000000048ADC0007DDBF20090E0F5008EDF
      F400A3E5F60009B9E5000297CD005EB8CB00D4E5E200BECCB8000681B100539E
      D4002B6A9A00C8D6E20000000000000000003F56F900949BFE00A3A8FF00A2A8
      FF00B2B6FE003543F9000D21EC006E76D800D8DBFE009CA3EF00161D3200539E
      D4002B6A9A00C8D6E2000000000000000000F1A8550000000000000000000000
      000000000000000000000000000000000000F2B75A00F9B65000ABB2AD0056A2
      D6003A7EB0008BA9C1000000000000000000B49D5900AAE3B00063CE77005FCD
      740080D68E00A7E3AF00B4E7B900A3E0AB0068C5750078C77100ACB3AC0056A2
      D6003A7EB0008BA9C100000000000000000060AEB90085DCF3002AC4EB0022C2
      EB0061D3F00097E2F500B3EAF80081E1ED002AC9DA0017CCDC0021A1CF0056A2
      D6003A7EB0008BA9C1000000000000000000556AF1009BA1FF00505BFF004953
      FF007C83FF00A9AEFF00C0C4FF00A0A7FC005A63F200505BF9005E67C00056A2
      D6003A7EB0008BA9C1000000000000000000E5B9870000000000000000000000
      0000000000000000000000000000000000000000000000000000ADA78F0056A2
      D6004692C70043749B000000000000000000C4AD8500A0D3A90090DB9B006AD0
      7D006CD17E0086D994009EE0A700C5ECC700B4E6B900B0E6B7008DAB900056A2
      D6004692C70043749B00000000000000000086B8BC007FD9EF0062D3F00039C8
      EC003BC8EC006BD6F10097E2F500D5F6F900A9ECF4009DEBF20089C7D00056A2
      D6004692C70043749B0000000000000000008793E500959CFE007D85FF005C67
      FF005E68FF00858CFF00AAB0FF00DFE0FF00BDC1FF00B5B9FF009898D10056A2
      D6004692C70043749B000000000000000000E7D2BA00FBAB3100000000000000
      0000000000000000000000000000000000000000000000000000D9C39900428C
      C0007DB7DF001D5887000000000000000000CBC2B100479A5C00A2E1AB0066CF
      7A0068CF7C0084D892009BDFA500B6E7BA00A8E3B00095DEA1009DC9A200428C
      C0007DB7DF001D5887000000000000000000B0CBCC0029B3D10089DEF4002FC5
      EB0033C7EC0067D5F00092E1F500BDF0F600A0EAF20077E3EC0083D4DD00428C
      C0007DB7DF001D5887000000000000000000BAC0E700313FFB009DA2FF00545E
      FF005760FF00828AFF00A5AAFF00CDD0FF00B7BBFF009AA0FF00999AD900428C
      C0007DB7DF001D5887000000000000000000F0E9E000FAA93700000000000000
      0000000000000000000000000000000000000000000000000000F0C173003579
      AC006EAFDB001D5887000000000000000000F0E9E0004B965600A1E0A90064CF
      780064CF780084D8920097DEA300B0E6B700B2E6B70098DFA3008ECF96003579
      AC006EAFDB001D5887000000000000000000D6E3E3003EB1C70085DDF3002AC4
      EB002AC4EB0066D5F0008BDFF400B2EEF500B3EEF5007EE3EE004CD1E0003579
      AC006EAFDB001D5887000000000000000000E0E1F0003747FA009BA2FF00515C
      FF00505BFF008189FF009FA4FF00C4C7FF00C5C9FF009DA3FF007378F0003579
      AC006EAFDB001D5887000000000000000000FAF8F600F9A74300000000000000
      000000000000000000000000000000000000000000000000000000000000356E
      97008FC1E400215F8F00E8EEF30000000000FAF8F60062925500BDE9C000B8E7
      BC00B7E7BC00C1EBC300C6ECC800A8E3B000BAE8BE0099DFA400A7DC9E00356E
      97008FC1E400215F8F00E8EEF30000000000F2F6F6004FAEBE0085DDF3008BDF
      F40086DEF400AAE7F700BDEDF9009FEAF200C4F2F80080E3EE0073E0ED00356E
      97008FC1E400215F8F00E8EEF30000000000F6F7FA004358F9009BA2FF009FA5
      FF009BA0FF00B8BCFF00C8CCFF00B6BBFF00D1D4FF009FA5FF00959CFF00356E
      97008FC1E400215F8F00E8EEF30000000000FEFEFD00F8AC5600F5860A00F585
      0400F5870400F5890300FCD1930000000000000000000000000000000000A0B4
      C00086BCE2002E72A400A8BFD10000000000FEFEFD009A9A640034A54C0031A6
      4C0031A64D0030A64D0082C29600C3EBC600C9EDCB00B9E9BF00B7E7BC00A0B4
      C00086BCE2002E72A400A8BFD10000000000FDFDFD0067B0BA000792C8000090
      CA000092CB000093CC007CD9F100CCF4F900DFF8FB00BEF1F700B5EEF500A0B6
      C20086BCE2002E72A400A8BFD10000000000FDFDFE00566CF8000A2AF5000424
      F5000421F500031EF500939BFC00D7DAFF00E7E8FF00CDCFFF00C7CAFF00A0B4
      C00086BCE2002E72A400A8BFD100000000000000000000000000000000000000
      00000000000000000000E98C0C00FAB75100000000000000000000000000D794
      2E00EFF7FB003684BB00608AAB00000000000000000000000000000000000000
      0000000000000000000035A052005EB77900BFE9C200AEE4B6006DD180004794
      5300EFF7FB003684BB00608AAB00000000000000000000000000000000000000
      000000000000000000000295CD002DC3E900C0EDF8009BE3F50006B7E4000599
      C000EFF7FB003684BB00608AAB00000000000000000000000000000000000000
      000000000000000000000C1FE900515CFA00CBCFFE00ACB2FE00313EFC002E39
      D700EFF7FB003684BB00608AAB00000000000000000000000000000000000000
      00000000000000000000F3F0EB00C39F6F00CB924000CA8E4000C39C690082A0
      B6001D588700608AAB00BDCFDC00000000000000000000000000000000000000
      00000000000000000000DFE3D9005D835C004B8E56004E994E0062905400698D
      A7001D588700608AAB00BDCFDC00000000000000000000000000000000000000
      00000000000000000000E1EBEC005DABBB0028A3C50026A0C3006BA3AB0082A0
      B6001D588700608AAB00BDCFDC00000000000000000000000000000000000000
      00000000000000000000EBECF3006F76C300404BCB00404ECA006972C30082A0
      B6001D588700608AAB00BDCFDC00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000200000000100010000000000000100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000FF87FF87FF87FF87FF87FF87FF87FF87
      FF87FF87FF87FF87FF87FF87FF87FF87FF87FF87FF87FF870387038703870387
      78030003000300037F030003000300037FC30003000300033FC3000300030003
      3FC30003000300033FE100010001000101E1000100010001FCE1FC01FC01FC01
      FC01FC01FC01FC01FFFFFFFFFFFFFFFF00000000000000000000000000000000
      000000000000}
  end
  object PageSetupDialog: TPageSetupDialog
    BoldFont = False
    HelpContext = 0
    Left = 216
    Top = 328
  end
  object ProjectImageList: TImageList
    Left = 408
    Top = 48
    Bitmap = {
      494C01011700D8000C0110001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000006000000001002000000000000060
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000CFCFCF00CCCCCC00CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCC
      CC00CCCCCC00D0D0D00000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000A2CAEE0076B2E6003E91
      DB00348CD900348CD900348CD900348CD900348CD900348CD900348CD900348C
      D900348BD900398FDA0085B9E900000000004E9DD3004398D2004094D0003E92
      CF003E92CE003F92CE003F92CE003F92CE003F92CE003F92CE003F92CE003F92
      CE003F93CF004C9AD100F1F1F100000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000004799DD00DEF1FA00A8DD
      F4009EDBF40096DAF3008ED8F30086D7F3007FD4F20079D3F20072D2F1006CD0
      F10069CFF100C2EAF8003F95DB00000000004499D2003F94D000ABFBFF009BF3
      FF0092F1FF0093F1FF0093F1FF0093F1FF0093F1FF0093F1FF0093F1FF0093F1
      FF00A6F8FF0065B8E300B2CADA00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003B97DB00EFFAFE00A1E9
      F90091E5F80081E1F70072DEF60063DAF50054D7F40047D3F30039D0F2002ECD
      F10026CBF000CAF2FB003B97DB00000000004398D2004FA6D9008EDAF500A2EE
      FF0082E5FE0084E5FE0084E5FE0085E6FE0085E6FE0085E6FE0085E6FE0084E6
      FE0096EBFF008CD8F50070A7CF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003C9DDB00F2FAFD00B3ED
      FA00A4E9F90095E6F80085E2F70076DEF60065DBF50057D7F40049D4F3003BD1
      F20030CEF100CCF2FB003B9BDB00000000004296D1006BBEE8006DBDE600BBF2
      FF0075DEFD0077DEFC0078DEFC007BDFFC007DDFFC007DDFFC007DDFFC007CDF
      FC0080E0FD00ADF0FF004D9DD300F1F1F1000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003BA3DB00F6FCFE00C8F2
      FC00B9EFFB00ACECFA009CE8F9008BE3F7007CE0F6006CDCF6005DD9F5004FD6
      F40044D3F300D0F3FC003BA2DB00000000004095D0008AD7F50044A1D800DDFD
      FF00DAFAFF00DBFAFF00DEFAFF0074DCFC0076DBFA0075DAFA0074DAFA0074DA
      FA0072D9FA00A1E8FF007CBFE600B3CADB000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003BA8DB00FEFFFF00F8FD
      FF00F6FDFF00F5FCFF00F3FCFE00D8F6FC0094E6F80085E3F70076DFF60068DB
      F5005CD8F400D7F4FC003BA7DB00000000003E94D000ABF0FF00449DD600368C
      CB00368CCB00368CCB00378BCB005CBEEA006FD9FB006AD6FA0068D5F90067D4
      F90066D4F90082DEFC00AAE0F6006FA6CE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000039ADDB00E8F6FB0094D4
      EF0088CEEE0073C1E900C9E9F600F2FCFE00F3FCFE00F2FCFE00F0FCFE00EFFB
      FE00EEFBFE00FEFFFF003CAEDB00000000003D92CF00B9F4FF0073DBFB006BCC
      F2006CCDF3006CCEF3006DCEF300479CD40056BAE900DAF8FF00D7F6FF00D6F6
      FF00D5F6FF00D5F7FF00DBFCFF003E94D0000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000040AEDC00F1FAFD0094DE
      F50093DCF40081D5F2006ACAED006CCBEA0085D3EF0080D2EF007AD0EF0076CF
      EE0072CFEE00E9F7FB003EB2DC00000000003C92CF00C0F3FF0071DAFB0074DB
      FB0075DBFC0075DBFC0076DCFC0073DAFA00449CD400378CCB00368CCB00358C
      CC00348DCC003890CE003D94D00052A0D6000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000041B4DC00F7FCFE008EE4
      F80091DEF5009FE0F500ACE1F600EFFBFE00F4FDFE00F3FCFE00F1FCFE00EFFB
      FE00EEFBFE00FAFDFF0058BCE000000000003B92CF00CAF6FF0069D5F9006CD5
      F9006BD5F90069D5F90069D5FA006AD7FB0068D4FA005EC7F1005EC7F2005DC8
      F200B4E3F8003D94D000B0D1E800000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000003CB5DB00FDFEFE00FEFF
      FF00FEFEFF00FDFEFF00FEFFFF00EAF7FB006EC8E5006FC9E4006FC9E4006FC9
      E4007DCFE70084D0E800BAE5F200000000003B92CF00D5F7FF0060D1F90061D0
      F800B4EBFD00D9F6FF00DAF8FF00DAF8FF00DBF9FF00DCFAFF00DCFAFF00DCFB
      FF00E0FFFF003E95D000DAEBF600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000059C2E00061C3E20063C4
      E30063C4E30063C4E30062C4E30056C0E000EDF8FC00F3FAFD00F3FAFD00F3FA
      FD00F3FAFD00F3FBFD00FCFEFE00000000003D94D000DCFCFF00D8F7FF00D8F7
      FF00DBFAFF00358ECD003991CE003A92CF003A92CF003A92CF003A92CF003B92
      CF003D94D00060A8D90000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000007DB8E0003D94D0003A92CF003A92
      CF003D94D00063A9D90000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCC
      CC00000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000079686F0078656B00796369007963
      690076676700736C6400706D61006F6D5F006F6D5F006F6E61006D6D65006669
      6A0061666D0061666D0062676F0065697400000000000000000000000000B8A6
      9600B5A29200B4A09000B39F8F00B39F8E00B39F8F00B4A09000B5A29200B8A6
      9600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000008D450018EEB20000E49D0000E5
      9C0014F3A800262ACB007989FF006177FF006177FF00778AFF00162CCE00FFD9
      8100FCC97400FAC87600FFD58F00BF850F00000000000000000000000000B7A4
      940000000000000000000000000000000000000000000000000000000000B7A4
      9400000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000008080800000000000000000008080800080808000000000000000
      000080808000FFFFFF000000000000000000008846002DE3B60000D49A0000D5
      980028EAA9002A2AC2007B89FF005C71FF005C71FF00788AFF00162BC700FFD1
      7900EFBC6700EDBB6900F5CB8A00B7821500000000000000000000000000B8A5
      9600B39F8F00E6DED80000000000FFFDFC0000000000E6DED800B39F8F00B8A5
      9600000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000000000000000000080808000000000000000000080808000808080000000
      000000000000808080000000000000000000008745003DE0BA0000CD990000CE
      970037E7AD002A2AC1007B8AFF00586CFA00586CFA00788AFF00162CC700FFCF
      7400EBB65A00E8B55D00F2C88700B68116000000000000000000000000000000
      000000000000B19C8B0000000000FCFAF80000000000B19C8B00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000808080000000000000000000808080008080
      800000000000000000000000000000000000008845004ADEC00000C69A0000C8
      980044E5B300292AC1007A8AFF005368F8005368F800788BFF00162CC700FECD
      7000E8B05000E6AF5200F1C78300B68116000000000000000000000000000000
      000000000000B29F8E0000000000FBF8F50000000000B29F8E00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000808080008080800000000000808080008080800080808000000000008080
      8000808080000000000000000000000000000088440055DCC50000C0990000C2
      97004FE3B700282AC1007C8BFD004D64F6004D64F6007A8BFE00162DC800FDCB
      6E00E6AA4500E4A84800F0C58000B68217000000000000000000000000000000
      000000000000B39F8E0000000000F9F4F10000000000B39F8E00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000000000008080800080808000000000008080800080808000808080000000
      0000808080008080800000000000000000000088440061DBCA0000BA980000BB
      96005BE2BD00282AC1007C8BFC00495FF300495FF3007A8BFD00162DC900FDCA
      6B00E4A63A00E2A43C00F0C47D00B68217000000000000000000000000000000
      000000000000B39F8E0000000000F7F2ED0000000000B39F8E00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000808080008080
      8000000000000000000080808000808080000000000080808000808080000000
      000000000000808080000000000000000000008A470071DDD6004FE4D6004FE6
      D4006BE4C800292CC3007D8DFA00435BF100435BF1007A8DFB00172DC900FCCA
      6A00E29E2F00E09D3200EFC37C00B68217000000000000000000000000000000
      000000000000B39F8F0000000000F5EEE90000000000B39F8F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000000000000000000000000000000000000000000000000000000000008080
      8000808080000000000000000000808080008080800000000000808080008080
      80000000000000000000000000000000000010945700008A470000884400008A
      4100009239002C30C8007E8FF9003D57EF003D57EF007B8FFA00172DC900FBC9
      6A00E0992300DD982500EEC27B00B68218000000000000000000000000000000
      000000000000B39F8F0000000000F3ECE50000000000B39F8F00000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000000000000000000000000000000000000000000000000000808080000000
      0000808080008080800000000000000000008080800080808000000000000000
      000080808000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF002D33C8008291F8003952ED003952ED007E90F900172DCA00FCC9
      6900DE911200DB901400EEC27B00B7821800CCCCCC00CCCCCC00CCCCCC000000
      000000000000B39F8F0000000000F2E8E20000000000B39F8F00000000000000
      0000CCCCCC00CCCCCC00CCCCCC0000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000000000000000000000000000000000000808080000000
      0000000000008080800080808000000000000000000080808000808080000000
      000080808000808080000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF002B37C4008293F700334EEA00334EEA007F91F800182ECB00FEC9
      6B00EBD28500E9D08800F1C27D00B8831900B9A69700B7A59600B8A69700CCCC
      CC00CCCCCC00B29F8E0000000000EFE6DE0000000000B29F8E00CCCCCC00CCCC
      CC00B8A69700B7A59600B9A6970000000000000000000000000000000000C0C0
      C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C0000000000000000000000000000000000000000000FFFFFF008080
      8000000000000000000080808000808080000000000000000000808080008080
      800000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF002A38C1008495F5002C48E8002C48E8008294F8001A31CE00C68A
      0600BA831400B7821700B8831900CAA15000B7A49400FBF4EE00B39F9000B4A1
      9100B4A09000AF9B8A0000000000EEE4DB0000000000AF9B8A00B4A09000B4A1
      9100B39F9000FBF4EE00B7A49400000000000000000000000000000000000000
      000000000000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0C000C0C0
      C000C0C0C000C0C0C00000000000000000000000000000000000000000000000
      0000808080000000000000000000808080008080800000000000000000008080
      800080808000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF002A39C0008596F4002540E5002540E5008395F7001F33CC00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00B5A39300F5EBE300F2E8DF00F2E8
      DF00F1E7DE00F0E5DC00EDE2D800ECE0D600EDE2D800F0E5DC00F1E7DE00F2E8
      DF00F2E8DF00F5EBE300B5A39300000000000000000000000000000000000000
      00000000000000000000C0C0C000C0C0C000C0C0C000C0C0C000000000000000
      0000000000000000000000000000000000000000000000000000808080000000
      0000FFFFFF008080800080808000000000008080800080808000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF002B3BC1008998F6006CAFF6006CAFF6008998F6002638C700FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00B6A39400EBE6E300000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000EBE6E300B6A39400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF006F7AD6002B3AC1002B38C0002B38C0002B3AC1004B59CD00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00BCAC9E00B6A39300B4A09000B39F
      8F00B39F8F00B39F8F00B39F8F00B39F8F00B39F8F00B39F8F00B39F8F00B39F
      8F00B4A09000B6A39300BCAC9E00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D7D7D700CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00DBDBDB000000000000000000CCCCCC00CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CFCFCF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000D5D5
      D500CCCCCC00CCCCCC00D5D5D500000000000000000000000000C0B29900BBA9
      8700B9A78400B8A78300B8A68300B8A68200B8A68200B8A68200B8A68200B8A5
      8100B8A68200BAA88500C1B69D0000000000A8A8A80093939300919192009191
      9200909192009090910090909000909090009090900090909000909090009090
      900090909000929292009A9A9A00FFFFFF0000000000DFB49300D59D7400D196
      6800CE926300CB8E5E00C98A5B00C7875600C3845200C3845200C3845200C384
      5200C3845200C3845200D0A17D00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000D6D6D600B4B4
      B400AEAFAF00AEAEAE00B3B4B400D5D5D5000000000000000000BBAA8700F6EB
      E000FDF3EC00FCF3EC00FDF6EF00FEF8F300FFFCF900FFFFFE00000000000000
      00000000000000000000BBA986000000000093939300FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF0093939300FFFFFF0000000000D7A17500F8F2ED00F7F0
      EA00F6EDE600F4EAE200F3E7DE00F1E4DB00F0E2D800EAD6C800F2E5DC00FAF4
      F100F9F3F000FAF5F200C58B5E00000000000000000000000000000000000000
      0000000000000000000000000000DADADA00CCCCCC00CCCCCC00B6B6B600ACAB
      A900BCB9B700BCB9B600BDBAB800B3B3B3000000000000000000E7E1D500D1C2
      A800F9EFE400F2E6D800FDF9F600FDFBF800EFDFCE00EFDDCD00EEDCC900ECD9
      C500FCF5EF00D6CBB600E7E1D5000000000091919200FFFFFF00B97F0D00B579
      0300C4A26100FDFEFE00FFFFFF00D7D7D800FFFFFF00FFFFFE00D8D8D600FFFF
      FE00FFFFFE00FFFFFF0091919100FFFFFF0000000000D9A47A00F9F3EE00EBD2
      BE0000000000EBD3BF0000000000EBD3C00000000000EAC7AD00ECD9CD00F1E4
      DB00F9F3F000F9F2EF00C68C5F00000000000000000000000000000000000000
      0000000000000000000000000000AAAAAA009C9C9C0099999900AFB0B000C2C1
      BF00EEEDED00DFDEDD00DEDDDB00ACACAC00000000000000000000000000BAA9
      8800F3E9DD00F4E6DA00FAF5EE00FDFAF700EFDFCE00EFDECE00EEDDCA00F0E0
      CF00FCFCFA00BAA78400000000000000000091919100FFFFFF00FFFFFF00F7F4
      ED00BC8F3200C08E2B00F8F3EC00D9DADD00FFFFFF00FFFFFD00E1DFD500FFFF
      FD00FFFFFC00FFFFFF0091919000FFFFFF0000000000DDA87E00F9F3EF00EBD0
      BA00EBD0BB0075B57A0075B57A0075B57A00EBD1BD00EACDB500FAF4F000EBD9
      CC00F1E4DB00FAF4F100C68A5C00000000000000000000000000000000000000
      00000000000000000000000000009C9C9C000000000000000000AEAEAE00E1E0
      DF00FFFEFE0000000000FCFBFB00ABABAB00000000000000000000000000DDD4
      C200D1C2AA00F8EDE300F9F1E900FDFAF700EFDFCE00EFDECE00EEDDCA00FCF4
      F000D5C9B500E8E1D500000000000000000091919100FFFFFF00D2D3D300D4D6
      D900D8DDE400C29E5300BA7E0700DDDDD900BABED8006873C9004150C4001527
      BD000013B900FFFFFF0092929100FFFFFF0000000000DFAA8200F9F3EF00EACE
      B7000000000075B57A0094D49B0074B5790000000000EACFBA00FBF6F200FAF3
      F000EBD8CB00F2E6DD00C88D5F00000000000000000000000000000000000000
      00000000000000000000000000009C9C9C000000000000000000BCBCBC00D4D3
      D3000000000000000000D3D2D200BABBBB000000000000000000000000000000
      0000B8A78300F4E9E000F8EFE600FDFAF700EFDFCE00EFDECD00F1E1D100FBF8
      F700B8A6820000000000000000000000000091919100FFFFFF00F7F6F500F9F8
      F800D7D7D700FFFFFF00AB8756009F7022003443C9007A86DF009FA3CD00E6E7
      F000FFFFF500FFFFFF0091919100FFFFFF0000000000E1AE8700FAF4F000EACB
      B200EACCB30075B57A0074B5790073B47800EACEB70070B375006FB274006EB1
      7200E8C8AE00EAD7C900C4865400000000000000000000000000000000000000
      00000000000000000000000000009C9C9C00000000000000000000000000BABB
      BB00AAAAAA00AAAAAA00BABABA00000000000000000000000000000000000000
      0000DDD4C300D1C3AA00FBF4EE00FEFBF800EFDFCE00EFDDCD00FBF4EE00D4C8
      B300DDD3C20000000000000000000000000092919100FFFEFE00FFF6F900FFFA
      FC00E7DBD9007076DF002C3FD800C09B5100CC982C00FDFCF700D7D9D900F8F9
      F800F5F5F400FFFEFC0091919100FFFFFF0000000000E3B18C00FAF6F100EAC9
      AE0000000000EAC9B00000000000E9CBB300000000006FB173008ED295006BAF
      6F0000000000F1E5DB00C6865500000000000000000000000000000000000000
      00000000000000000000000000009B9B9B000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000B8A68300F5EBE200FFFCFB00EFDFCD00F1E2D300F9F7F300B8A6
      82000000000000000000000000000000000092929200FFFFFF00007B29000084
      2F000089470013569600DED4DB00DCDBE000C29C4F00B77D0600C7B28A00CBC8
      BF00CCD0D600FDFFFF0091929200FFFFFF0000000000E5B48F00FAF6F200E9C6
      AA00E9C6AC00EAC7AC00E9C7AD00E9C9AE00E9C9B0006CB071006AAF6E0068AD
      6D00E8CCB500F2E7DE00C88A59000000000000000000D5D5D500CCCCCC00CCCC
      CC00D5D5D50000000000000000009B9B9B00000000000000000000000000D5D5
      D500CCCCCC00CCCCCC00D5D5D500000000000000000000000000000000000000
      000000000000DDD4C300D1C3AA00FFFEFE00EFDFCD00FAF2EB00D3C8B000DDD4
      C3000000000000000000000000000000000092929200FFFDFD00FFF8F400A69E
      E600275B9F0005994D0025A26700D0CDD100FBF7FF00E3CEAF00C0934200B876
      0000B5720000FEFEFF0092929300FFFFFF0000000000E7B79400FBF7F400E9C3
      A60000000000E8C4A90000000000E9C6AA0000000000E8C7AC0000000000E8C8
      B00000000000F7F1EB00CB8F5F0000000000D5D5D500B4B4B400AEAFAF00AEAE
      AE00B4B4B400D6D6D600000000009B9B9B000000000000000000D6D6D600B4B4
      B400AEAFAF00AEAEAE00B3B4B400D5D5D5000000000000000000000000000000
      00000000000000000000B6A47F0000000000F0DFCD00FFFEFD00B7A480000000
      00000000000000000000000000000000000092929200FFFDFA00EBE8E6001F2E
      C600AFAACC00F3F0EB0047AC7D0000863E0092C8B100EEECF000DBD1DB00FDF5
      FF00F7F2FA00FFFCFF0092929300FFFFFF0000000000E9BA9800FBF7F40065A4
      FF0064A3FF0062A2FF0061A1FF005F9FFF005C9DFF005A9AFF005798FF005495
      FF005294FF00FBF7F400CE93640000000000B4B4B400ACAAA900BCB9B700BCB9
      B600BDBBB800B6B6B600CCCCCC009C9C9C00CCCCCC00CCCCCC00B6B6B600ACAB
      A900BCB9B700BCB9B600BDBAB800B3B3B3000000000000000000000000000000
      00000000000000000000B8A5810000000000F0DFCD00FFFEFD00B8A682000000
      00000000000000000000000000000000000092939200FFFFF9007B83C000404D
      C100D3D0C400CDC8C600D3C9CB0087B39E00159259000080330000813500007F
      3300007B2C00FFFCFF0093929300FFFFFF0000000000EBBD9B00FBF7F40064A4
      FF0079BDFF0075BBFF0071B9FF006DB8FF0068B3FF0061B0FF005AABFF0054A7
      FF003B7DFF00FBF7F400D1976A0000000000ADADAE00C2C1BE00EEEDED00DFDE
      DD00DEDDDC00ADAEAE00999999009B9B9B009B9B9B0099999900AFB0B000C2C1
      BF00EEEDED00DFDEDD00DEDDDB00ACACAC000000000000000000000000000000
      00000000000000000000B8A5810000000000F0DFCD00FFFEFD00B8A682000000
      00000000000000000000000000000000000093939200FFFFF8003645C600ABB0
      D800C7C6BE00E5E5E200E7E4E300C8C2C200F0E7E900F4E8EB00D1C4C800F4E7
      EB00EDE4E600FEF9FA0092929200FFFFFF0000000000ECBF9E00FBF7F40065A4
      FF0064A3FF0060A0FF005D9EFF005899FF005496FF004D90FF00478BFF004284
      FF003D7FFF00FBF7F400D49B6F0000000000ACACAC00E1E0DF00FFFEFE000000
      0000FCFBFB00ABACAC0000000000000000000000000000000000AEAEAE00E1E0
      DF00FFFEFE0000000000FCFBFB00ABABAB000000000000000000000000000000
      00000000000000000000B8A6820000000000F0DFCE00FFFFFE00B8A683000000
      00000000000000000000000000000000000094949200FFFFF9001224BF00EAE7
      DD00BEBDB900DEDDDC00DEDDDC00BCBABA00E0DDDD00E1DDDD00BEBBBB00E0DD
      DD00DEDBDB00F9F8F80092929200FFFFFF0000000000EFC6A800FBF7F400FBF7
      F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7F400FBF7
      F400FBF7F400FBF7F400D8A3780000000000BBBBBB00D4D3D300000000000000
      0000D3D2D200BBBBBB0000000000000000000000000000000000BCBCBC00D4D3
      D3000000000000000000D3D2D200BABBBB000000000000000000000000000000
      00000000000000000000B9A7840000000000FFFCFA0000000000B9A884000000
      00000000000000000000000000000000000095949400FFFFFB00FFFEF700FCFB
      F600FAF9F700F8F7F600F8F7F600F9F8F600F8F7F600F8F7F600F9F8F600F8F7
      F600F8F7F600FDFBFA0094949400FFFFFF0000000000F7E1D200F1C8AC00EDC0
      9F00EBBE9D00EBBC9A00E9BA9600E7B79300E6B59000E4B28C00E2AF8800E0AC
      8400DDA98000DCA57D00E2B696000000000000000000BABBBB00AAAAAA00AAAA
      AA00BABABA00000000000000000000000000000000000000000000000000BABB
      BB00AAAAAA00AAAAAA00BABABA00000000000000000000000000000000000000
      00000000000000000000C0B09000B9A78400B8A68300B9A88400C0B090000000
      000000000000000000000000000000000000AFAFAF0094949400939392009292
      9200929292009292920092929200929292009292920092929200929292009292
      920092929200949494009E9E9E00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CCCCCC00CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00D3D3D300FFFFFF0000000000DCDCDC00CCCCCC00CCCC
      CC00DDDDDD000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000CCCCCC00CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCC
      CC00CCCCCC0000000000FFFFFF00FFFFFF0000000000DCDCDC00FEFEFE000000
      0000DCDCDC00FEFEFE0000000000DCDCDC00FEFEFE0000000000DCDCDC00FEFE
      FE0000000000000000000000000000000000A4A4A4008E8E8E008C8C8C008C8C
      8C008B8B8B008B8B8B008C8C8C008C8C8C008C8C8C008C8C8C008C8C8C008C8C
      8C008C8C8C008D8D8D009A9A9A00FFFFFF0000000000BE9A5200C18B2600BF8A
      2300BF9C5400DEDEDE0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000DBAF6500E3B56500E1B46400E1B4
      6500E1B46500E1B46500E1B46500E1B46500E1B46500E1B46500E1B46500E1B4
      6400E3B56500DBAF6500FFFFFF00FFFFFF0000000000B3A26700E8E8E6000000
      0000B3A26700E8E8E60000000000B3A26700E8E8E60000000000B3A26700E8E8
      E500000000000000000000000000000000008E8E8E00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008D8D8D00FFFFFF0000000000C28E2A00EEBB6800E8AF
      4F00D1972E00C19D5300DEDEDE00000000000000000000000000000000000000
      000000000000000000000000000000000000E4BC7600FFF5D000FFEBB300FFE0
      9700FFE09800FFE09800FFE09800FFE09800FFE09700FFE09700FFE09600FFEB
      B300FFF5D000E4BC7600FFFFFF00FFFFFF0000000000BFAE7600BBB08E000000
      0000C0AF7800BBB08E0000000000C0AF7800BBB08E0000000000C0AF7800BBB1
      8E00000000000000000000000000000000008C8C8C00FFFFFF005F5F5F009F9F
      9F009C9C9C00FFFFFF005E5E5E00A0A0A0009F9F9F009E9E9E009E9E9E009E9E
      9E009C9C9C00FFFFFF008C8C8C00FFFFFF0000000000C18E2A00FFF2D200EAB5
      5F00E7AD4C00D6992E00C19D5300DEDEDE000000000000000000000000000000
      000000000000000000000000000000000000DCB06400E2BB7500F8E1B300FFE7
      A900FFE2A000FFE2A100FFE2A100FFE2A100FFE4A400FFE8B200FFE7A700F9E1
      B200E4BB7400DEB06200FFFFFF00FFFFFF0000000000F8F6EF00A1873500F8F8
      F800F9F7F200A1883600F8F8F800F9F7F200A1883600F8F8F800F9F7F200A187
      3500F7F7F7000000000000000000000000008C8C8C00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF008B8B8B00FFFFFF0000000000CEAB6300CF9F4200FFEF
      CD00E9B45D00E7AD4B00D5983000BF9C5600DDDDDD0000000000000000000000
      000000000000000000000000000000000000FFFFFF00F8F0E200E5C28200FFFF
      ED00FFEFC000FFE8AD00FFE8AD00FFE8AD00FFEFC100FFF1D100FFFFE900EEC3
      7B00FBF2E400FFFFFF00FFFFFF00FFFFFF000000000000000000A9914600D1CE
      C10000000000A9924700D1CEC10000000000A9924700D1CEC10000000000A991
      4600D0CCBE000000000000000000000000008C8C8C00FFFFFF0060606000A1A1
      A1009F9F9F009C9C9C00FFFFFF005F5F5F00A0A0A0009D9D9D00FFFFFF005F5F
      5F009E9E9E00FFFFFF008C8C8C00FFFFFF000000000000000000CFAC6600DBAC
      5800FFEECB00E8B45D00E6AC4B00D6992E00C49D4F00FEFEFE00000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00F2E1C500D6A3
      4E00FFF9E200FFF0BE00FFEDBA00FFF0BD00FFF5D500C5A15A00B1A2750089A7
      B600D6D6D600E6E6E600FFFFFF00FFFFFF000000000000000000D8CDAA00AF9D
      5E0000000000D8CEAB00AF9D5E0000000000D8CEAB00AF9D5E0000000000D8CE
      AB00AF9B5D000000000000000000000000008C8C8C00FFFFFF00FFFFFF00FFFF
      FF00FEFEFE00FCFCFC00FBFBFB00FCFCFC00FCFCFC00FCFCFD00FCFCFC00FDFE
      FE00FCFCFC00FFFFFF008C8C8C00FFFFFF00000000000000000000000000CFAC
      6500E0B56900FFEECB00EFC47600EBAD4500A17E3500CFCFCF00000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00F3E2
      C500ECCA9000FFFFFD00FFFFF000FFFFFA00F7C477004F9ECF000D9DFF00169C
      FE00319EF50087C7FE00FFFFFF00FFFFFF00000000000000000000000000BDAC
      73000000000000000000BDAC73000000000000000000BDAC7300000000000000
      0000BCAC73000000000000000000000000008C8C8C00FFFFFF00636363006464
      6500A3A3A300A0A1A100A0A0A0009F9F9F00FAF9F70060606000A2A2A200A1A1
      A1009F9F9F00FFFFFF008C8C8C00FFFFFF000000000000000000000000000000
      0000CFAC6500DCAC5600FFF0C700E0BD8300B5B8BE0083828300CCCCCC00CCCC
      CC00CCCCCC00D9D9D9000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00E6C89900EFB35800F4BE6E00E7B2600066A6BE001BA6FF0024A8FF0027A9
      FF0024A1FF00D9DCDE00FFFFFF00FFFFFF0000000000ECECEC00CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCCCC00CCCC
      CC00CCCCCC00CCCCCC00E0E0E000000000008C8D8D00FFFFFF00FBFAF900FCFB
      FA00FBFAF900F9F8F700FCFBFA00FCFBF900F9F7F600F8F7F600FBFAF900F0EF
      EF00FAF9F800FFFFFF008C8C8C00FFFFFF000000000000000000000000000000
      000000000000D0AC6100A27E3700E4E8EF00CBCACC00A8A7A500757370008E8C
      8A007F7D7B008F8D8D00D0D0D00000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0069B7F20025AEFF0055ADD7001EADFF0026AFFF002DB0FF002FB0FF002FB0
      FF003BB1FF0060AFF400FFFFFF00FFFFFF0000000000D2C0A300DFAF5F00E2B4
      6300E1B36200E1B36300E2B46400E1B46300E1B46300E2B46400E1B46300E1B3
      6200E2B46200E0B15F00D4B88800000000008D8D8D00FFFFFF0047474700FFFF
      FE0047484800FDFCFA004A4A4A004B4B4B008B8B8B00F9F8F7008A8B8B004748
      480042434300FFFFFF008D8D8D00FFFFFF000000000000000000000000000000
      000000000000000000000000000085848500D2D0D100C9C7C600D4D2D100ECEB
      EB00EFEFEF00DCDCDC008786840000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF007CC4FF0051C1FF002FB9FF0031B9FF0033B9FF0034B9FF0034B9FF0032BA
      FF0052C1FF0067BAFE00FFFFFF00FFFFFF0000000000DEB05F00F6D08000F3CB
      7300F3CA7300F3CB7500F3CB7600F3CB7600F3CB7600F3CB7600F3CB7500F3CB
      7400FAE1AA00FBE3AC00E0B36200000000008E8E8E00FFFFFF004E4E4E005151
      51004F505000FEFCFC0050505000FFFFFF004D4D4D00FBF9F9004A4A4A00F8F6
      F600F0EEEE00FFFEFE008C8C8C00FFFFFF000000000000000000000000000000
      000000000000000000000000000087868500DBD9D800CECCCC00CDCBC900CBC9
      CA0089868400878582008A88860000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00DEE1E3004DBCFF0055CFFF002DC3FF002DC2FF002DC2FF002CC2FF0050CE
      FF003DB9FF00C5CACE00CCCCCC00CCCCCC0000000000DEB16000FDE8BB00FAE2
      B000FBE5B800F5D38900F3CC7A00F3CC7B00F3CC7A00F3CB7800F4CB7700F5CF
      8000E4BD7400E0B36100DBB06500000000008D8D8D00FFFFFF004B4B4B00FDFB
      FB004D4D4D00FAF8F800525252005454540066666700FAF7F7004A4B4B00F1EE
      EF00E8E6E600FDFCFC008C8C8C00FFFFFF000000000000000000000000000000
      00000000000000000000000000008B898800E1E1E000CAC8C700CCCAC9008E8C
      890000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF0076BEFF0054B6FF00F3B14F00F6B55400F3B35500F3B35500F2B35500F2B3
      5500F2B45500F1B65900EAB86200DDAE5E0000000000E5C58E00DFB06000DFB2
      6000DDB26200F5D08200F4CF8200F4CF8100F4CF8000FCECC700FBEAC300FDEA
      C100E1BA74000000000000000000000000008D8D8D00FFFFFF0086868600F5F3
      F20088898900F4F1F00050505000FEFBFA004E4E4E00F5F2F1004A4B4B00F1EE
      ED00E9E6E500FFFFFE008C8C8C00FFFFFF000000000000000000000000000000
      000000000000000000000000000092908D00E2E2E100BBB9B800BCBABA009492
      8F00CCCCCC00CCCCCC00CCCCCC0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00F4B35100FFEFB100FFEBAF00FFE6A200FFE29A00FFE2
      9A00FFE59D00FFEAAC00FCDB9A00E0B36400000000000000000000000000FCFC
      FC00E0B36400F8D78E00F5D28600F5D18600F8D79200DFB06000DAAA5900E1B4
      6400DFB773000000000000000000000000008D8D8D00FFFFFF00828281004848
      480083848300ECE9E8004B4B4B004D4D4D0086868500EBE8E700858584004848
      490043434400FFFFFF008D8D8D00FFFFFF000000000000000000000000000000
      00000000000000000000000000009B999600D4D3D300DDDBDB00B4B1AF00A9A6
      A4009D9B98009E9C98009C9B970000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00BEC6BE00E6B86900E2B96F00FEEBBF00FFEAB000FFEA
      B000FFF0C800EDD09600E0B97800FAF4E900000000000000000000000000FDFB
      F700E0B46500FDEECA00F7D48A00F7D48A00FEEECA00E0B46400000000000000
      0000000000000000000000000000000000008E8F8F00FFFFFF00FBF8F800FDFB
      FB00FBF9F900FAF8F800FDFBFB00FEFCFC00FCF9F900FAF7F700FBF9F900FEFB
      FB00FCFAFA00FFFFFF008F8F8F00FFFFFF000000000000000000000000000000
      0000000000000000000000000000E4E4E300AEACAA00DADAD900F0EEEF00ECEB
      EA00E2E0E000BFBCBC00A3A19E0000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F0DBBA00F0DCB100FFFFF700FFFF
      F700F0DBB100E3BF8300FFFFFF00FFFFFF000000000000000000000000000000
      0000DCAD5F00FFF0D200FFF7E400FFF7E400FAE6BF00DEB77500000000000000
      000000000000000000000000000000000000999999008F8F8F008D8D8D008E8E
      8E008D8E8E008D8D8D008E8E8E008E8E8E008D8E8E008D8D8D008D8E8E008E8E
      8E008E8E8E008F8F8F0099999900FFFFFF000000000000000000000000000000
      000000000000000000000000000000000000EDEDEC00AEACA900AEACA900B9B6
      B500ABA9A500B7B5B200F3F3F20000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00E1BC7D00E2BE7E00E2BE
      7E00E2BD7E00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000FAF4E900DAAC5C00E1B46500E1B46600DCB06500FAF3E800000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000600000000100010000000000000300000000000000000000
      000000000000000000000000FFFFFF00FFFFFFFFFFFF0000FFFFFFFF00030000
      FFFF800100010000C007800100010000CFE7800100010000D7D7800100000000
      DBB78001000000001D718001000000001EF18001000000001D71800100000000
      DBB7800100010000D7D7800100010000CFE7800100030000C007FFFF03FF0000
      FFFFFFFFFFFF0000FFFFFFFFFFFF0000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFF0FFC007C007FFFFEF7FDFF7DFF7FFFFDFBFDC77DFF7
      DFFDBFDFDBB7DEF7DFFDBFDF17D11D71C001BFDF17D11BB1DFFDBFC017D117D1
      DFFDBFFEDBB7CFE7FFFFDFFEDC77DFF7FFFFEFFEDFF7DFF7FFFFF000C007FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      F81FFEFFFEFF8001F7EFFEFFFD7FBFFDEFF7FD7FFBBFBFFDDFFBFD7FF7DFBE0D
      DFFBFBBFEFEFBFFDDFFBFBBFDFF7B03DDFFBF7DFBFFBBFFDDFFBF7DFDFF7BFFD
      DFFBEFEFEFEF8001EFF7EFEFF7DFBFFDF7EFDFF7FBBFBFFDF81FC007FD7FBFFD
      FFFFFFFFFEFFFFFFFFFFFFFFFFFFFFFFFFFFE00FFFFFFFFF0000E00FF6FF8001
      0000EFEFFFBFA9210000E28FF6FFA4910000FABFFFFF82490000FABFFBBFA025
      0000FABFFEFF90110000FABFE00F88090000FABFD007A4050000FABF90039211
      00001AB1A003890100000281A001848500000281C801924100000001E403812D
      00003FF9F03F800100000001FFFFFFFFFFFFC0018000FFFFFFE1C00100008001
      FFC0C03D00008001FE00C00100008A81FE00E00300008001FEC4E00300008881
      FECCF00700008001FEE1F00700008A89FEFFF80F0000800186E1F80F00008AA9
      02C0FD1F000080010000FD1F000080010000FD1F0000800113C4FD1F00008001
      33CCFD5F0000800187E1FC1F0000FFFF800087FF8004924F000083FF0000924F
      000081FF0000924F000080FF000080070000807F0000C9270000C03F0000C927
      0000E03F0000EDB70000F003000080010000F801000080010000FE0100008001
      0000FE01000080010000FE0F000080070000FE010000E0070000FE010000E03F
      0000FE010000F03F0000FF010000F03F00000000000000000000000000000000
      000000000000}
  end
end
