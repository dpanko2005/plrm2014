object ProfilePlotForm: TProfilePlotForm
  Left = 191
  Top = 107
  Caption = 'Profile Plot'
  ClientHeight = 339
  ClientWidth = 528
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  Icon.Data = {
    0000010001001010000000001800680300001600000028000000100000002000
    0000010018000000000000030000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000FFFF000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000FFFF00FFFF00FFFF00000000000000000000000000000000000000000000
    000000000000000000000000FFFF00FFFF00FFFF00FFFF00FFFF000000000000
    00000000000000000000000000000000000000000000000000FFFF00FFFF00FF
    FF00FFFF00FFFF00FFFF00000000000000000000000000000000000000000000
    FFFF00FFFF00000000FFFF00FFFF00FFFF00FFFF000000000000000000000000
    00000000000000000000FFFF00FFFF00FFFF00FFFF00000000FFFF00FFFF0000
    0000000000000000000000000000000000000000FFFF00FFFF00FFFF00FFFF00
    FFFF00FFFF00000000FFFF000000000000000000000000000000000000000000
    00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF0000000000000000000000
    0000000000000000000000000000000000FFFF00FFFF00FFFF00FFFF00FFFF00
    0000000000000000000000000000000000000000000000000000000000000000
    00FFFF00FFFF00FFFF00FFFF0000000000000000000000000000000000000000
    0000000000000000000000000000000000FFFF00FFFF00000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000FFFC
    0000FFF00000FFC00000FF000000FC000000F0000000C0060000001E0000003E
    0000007E0000037F0000077F00001F7F00007FFF00007FFF00007FFF0000}
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Chart1: TChart
    Left = 0
    Top = 0
    Width = 528
    Height = 339
    BackWall.Brush.Color = clAqua
    BackWall.Color = clWhite
    BackWall.Transparent = False
    Foot.Alignment = taRightJustify
    Foot.Font.Quality = fqDefault
    Foot.Text.Strings = (
      'Date / Time')
    Legend.Font.Quality = fqDefault
    Legend.Title.Font.Quality = fqDefault
    Legend.Visible = False
    MarginBottom = 5
    MarginLeft = 2
    MarginRight = 2
    MarginTop = 5
    SubFoot.Font.Quality = fqDefault
    SubTitle.Font.Quality = fqDefault
    Title.Font.Quality = fqDefault
    Title.Text.Strings = (
      'TChart')
    BottomAxis.Axis.Visible = False
    BottomAxis.Grid.Color = clSilver
    BottomAxis.Grid.Style = psSolid
    BottomAxis.LabelsFont.Quality = fqDefault
    BottomAxis.LabelsOnAxis = False
    BottomAxis.LabelStyle = talValue
    BottomAxis.Title.Font.Quality = fqDefault
    DepthAxis.LabelsFont.Quality = fqDefault
    DepthAxis.Title.Font.Quality = fqDefault
    DepthTopAxis.LabelsFont.Quality = fqDefault
    DepthTopAxis.Title.Font.Quality = fqDefault
    LeftAxis.Axis.Visible = False
    LeftAxis.Grid.Color = clSilver
    LeftAxis.Grid.Style = psSolid
    LeftAxis.LabelsFont.Quality = fqDefault
    LeftAxis.Title.Font.Quality = fqDefault
    RightAxis.LabelsFont.Quality = fqDefault
    RightAxis.Title.Font.Quality = fqDefault
    TopAxis.Axis.Visible = False
    TopAxis.Grid.Color = clSilver
    TopAxis.Grid.SmallDots = True
    TopAxis.LabelsFont.Quality = fqDefault
    TopAxis.LabelStyle = talText
    TopAxis.MinorTicks.Visible = False
    TopAxis.TicksInner.Visible = False
    TopAxis.Title.Angle = 90
    TopAxis.Title.Font.Charset = ANSI_CHARSET
    TopAxis.Title.Font.Height = -8
    TopAxis.Title.Font.Name = 'Small Fonts'
    TopAxis.Title.Font.Quality = fqDefault
    View3D = False
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 0
    OnMouseDown = Chart1MouseDown
    ColorPaletteIndex = 13
    object RefreshBtn: TSpeedButton
      Left = 0
      Top = 0
      Width = 24
      Height = 24
      Hint = 'Refresh'
      Glyph.Data = {
        4E010000424D4E01000000000000760000002800000012000000120000000100
        040000000000D800000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333444444
        3333330000003243342222224433330000003224422222222243330000003222
        222AAAAA222433000000322222A33333A222430000003222223333333A224300
        00003222222333333A44430000003AAAAAAA3333333333000000333333333333
        3333330000003333333333334444440000003A444333333A2222240000003A22
        43333333A2222400000033A22433333442222400000033A22244444222222400
        0000333A2222222222AA240000003333AA222222AA33A3000000333333AAAAAA
        333333000000333333333333333333000000}
      ParentShowHint = False
      ShowHint = True
      OnClick = RefreshBtnClick
    end
    object LinkInvert: TLineSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Font.Quality = fqDefault
      Marks.Visible = False
      SeriesColor = clBlack
      Title = 'LinkInvert'
      BeforeDrawValues = LinkInvertBeforeDrawValues
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object LinkCrown: TLineSeries
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Font.Quality = fqDefault
      Marks.Visible = False
      SeriesColor = clBlack
      Title = 'LinkCrown'
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object GroundLine: TLineSeries
      Marks.Arrow.Visible = False
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = False
      Marks.BackColor = clWhite
      Marks.Color = clWhite
      Marks.Font.Quality = fqDefault
      Marks.Frame.Visible = False
      Marks.Visible = True
      SeriesColor = clBlack
      Title = 'GroundLine'
      LinePen.Style = psDot
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      Pointer.Visible = False
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object NodeInvert: TPointSeries
      HorizAxis = aBothHorizAxis
      Marks.Arrow.Visible = True
      Marks.Callout.Brush.Color = clBlack
      Marks.Callout.Arrow.Visible = True
      Marks.Font.Quality = fqDefault
      Marks.Visible = False
      Title = 'NodeInvert'
      AfterDrawValues = NodeInvertAfterDrawValues
      ClickableLine = False
      Pointer.Brush.Color = clBlack
      Pointer.Brush.Gradient.EndColor = 10708548
      Pointer.Gradient.EndColor = 10708548
      Pointer.HorizSize = 8
      Pointer.InflateMargins = True
      Pointer.Pen.Visible = False
      Pointer.Style = psRectangle
      Pointer.VertSize = 1
      Pointer.Visible = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
end
