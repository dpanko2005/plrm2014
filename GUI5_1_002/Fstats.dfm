object StatsReportForm: TStatsReportForm
  Left = 192
  Top = 107
  Caption = 'Statistical Report'
  ClientHeight = 333
  ClientWidth = 528
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormStyle = fsMDIChild
  Icon.Data = {
    0000010001001010000000001800680300001600000028000000100000002000
    0000010018000000000000030000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFF
    0000FFFF0000C0070000E7E70000F3F70000F9F70000FCFF0000FE7F0000FF3F
    0000FE7F0000FCFF0000F9F70000F3F70000E7E70000C0070000FFFF0000}
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 528
    Height = 333
    ActivePage = StatsPage
    Align = alClient
    TabOrder = 0
    object StatsPage: TTabSheet
      Caption = 'Summary'
      ImageIndex = 2
      object StatsMemo: TMemo
        Left = 0
        Top = 0
        Width = 520
        Height = 303
        Align = alClient
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
        WordWrap = False
      end
    end
    object TablePage: TTabSheet
      Caption = 'Events'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object EventTable: TDrawGrid
        Left = 0
        Top = 0
        Width = 520
        Height = 303
        Align = alClient
        ColCount = 6
        Ctl3D = False
        DefaultColWidth = 80
        DrawingStyle = gdsClassic
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goThumbTracking, goFixedColClick, goFixedRowClick]
        ParentCtl3D = False
        TabOrder = 0
        OnDrawCell = EventTableDrawCell
        OnFixedCellClick = EventTableFixedCellClick
      end
    end
    object HistogramPage: TTabSheet
      Caption = 'Histogram'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object HistoChart: TChart
        Left = 0
        Top = 0
        Width = 520
        Height = 303
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        BackWall.Brush.Gradient.Visible = True
        BackWall.Transparent = False
        Legend.Font.Quality = fqDefault
        Legend.Title.Font.Quality = fqDefault
        Legend.Visible = False
        ScrollMouseButton = mbLeft
        SubTitle.Font.Quality = fqDefault
        Title.Font.Quality = fqDefault
        Title.Text.Strings = (
          '')
        BottomAxis.Grid.Color = clWhite
        BottomAxis.Grid.Style = psSolid
        BottomAxis.LabelsFont.Quality = fqDefault
        BottomAxis.Title.Font.Quality = fqDefault
        ClipPoints = False
        DepthTopAxis.LabelsFont.Quality = fqDefault
        LeftAxis.Grid.Color = clSilver
        LeftAxis.Grid.Style = psSolid
        LeftAxis.LabelsFont.Quality = fqDefault
        LeftAxis.Title.Font.Quality = fqDefault
        TopAxis.Title.Font.Quality = fqDefault
        View3D = False
        Align = alClient
        BevelOuter = bvNone
        Color = clWhite
        TabOrder = 0
        OnMouseDown = HistoChartMouseDown
        ColorPaletteIndex = 13
        object HistoSeries: TBarSeries
          BarBrush.Gradient.EndColor = 753908
          BarBrush.Gradient.StartColor = 14540754
          BarBrush.Gradient.SubGradient.EndColor = 14853278
          BarBrush.Gradient.SubGradient.Visible = True
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Font.Quality = fqDefault
          Marks.Visible = False
          SeriesColor = 14853278
          ShowInLegend = False
          Title = 'Computed'
          BeforeDrawValues = HistoSeriesBeforeDrawValues
          BarWidthPercent = 100
          Gradient.EndColor = 753908
          Gradient.StartColor = 14540754
          Gradient.SubGradient.EndColor = 14853278
          Gradient.SubGradient.Visible = True
          MultiBar = mbNone
          SideMargins = False
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Bar'
          YValues.Order = loNone
        end
      end
    end
    object FrequencyPlotPage: TTabSheet
      Caption = 'Frequency Plot'
      ImageIndex = 3
      object FreqChart: TChart
        Left = 0
        Top = 0
        Width = 520
        Height = 303
        BackWall.Brush.Color = clWhite
        BackWall.Brush.Style = bsClear
        BackWall.Brush.Gradient.Visible = True
        BackWall.Transparent = False
        Foot.Font.Quality = fqDefault
        Foot.Text.Strings = (
          '')
        Legend.Font.Quality = fqDefault
        Legend.Title.Font.Quality = fqDefault
        Legend.Visible = False
        ScrollMouseButton = mbLeft
        SubTitle.Font.Quality = fqDefault
        Title.Font.Quality = fqDefault
        Title.Text.Strings = (
          'TChart')
        BottomAxis.Grid.Color = clSilver
        BottomAxis.Grid.Style = psSolid
        BottomAxis.LabelsFont.Quality = fqDefault
        BottomAxis.MinorGrid.Color = clSilver
        BottomAxis.MinorTickCount = 4
        BottomAxis.MinorTicks.Color = clSilver
        BottomAxis.Title.Font.Quality = fqDefault
        LeftAxis.Grid.Color = clSilver
        LeftAxis.Grid.Style = psSolid
        LeftAxis.LabelsFont.Quality = fqDefault
        LeftAxis.MinorGrid.Color = clSilver
        LeftAxis.MinorGrid.Visible = True
        LeftAxis.MinorTickCount = 8
        LeftAxis.Title.Font.Quality = fqDefault
        View3D = False
        Align = alClient
        BevelOuter = bvNone
        Color = clWhite
        TabOrder = 0
        OnMouseDown = HistoChartMouseDown
        ColorPaletteIndex = 13
        object FreqSeries: TAreaSeries
          Gradient.EndColor = 14853278
          Gradient.Visible = True
          Marks.Arrow.Visible = True
          Marks.Callout.Brush.Color = clBlack
          Marks.Callout.Arrow.Visible = True
          Marks.Font.Quality = fqDefault
          Marks.Visible = False
          SeriesColor = 12615935
          Title = 'Computed'
          AreaChartBrush.Gradient.EndColor = 14853278
          AreaChartBrush.Gradient.Visible = True
          AreaLinesPen.Visible = False
          Dark3D = False
          DrawArea = True
          Pointer.Brush.Gradient.EndColor = 12615935
          Pointer.Gradient.EndColor = 12615935
          Pointer.InflateMargins = True
          Pointer.Style = psRectangle
          Pointer.Visible = False
          Transparency = 50
          XValues.Name = 'X'
          XValues.Order = loAscending
          YValues.Name = 'Y'
          YValues.Order = loNone
          object TSmoothingFunction
            CalcByValue = False
            Period = 1.000000000000000000
            Factor = 8
          end
        end
      end
    end
  end
end
