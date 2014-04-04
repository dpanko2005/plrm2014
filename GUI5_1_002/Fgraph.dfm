object GraphForm: TGraphForm
  Left = 193
  Top = 164
  Caption = 'GraphForm'
  ClientHeight = 337
  ClientWidth = 528
  Color = clBtnFace
  ParentFont = True
  FormStyle = fsMDIChild
  Icon.Data = {
    0000010001001010100000000000280100001600000028000000100000002000
    00000100040000000000C0000000000000000000000000000000000000000000
    0000000080000080000000808000800000008000800080800000C0C0C0008080
    80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00FF8F
    FF8FFF8FFF8FFF8F8F8F8F8F8F8F8800000000000000FF0FFFFFFFFFFFFFF809
    FFFFFF4FFFFFFF0F9F99F4F4FFFF8808989898848888FF0FF9FF9FFF4FFFF804
    FFF4F9FF4FF4FF0F4F4FF9FF4F4F8808484888988488FF0FF4FFFFF9FFFFF80F
    F4FFFFFF9FFFFF0FFFFFFFFFF9998808888888888888FFFFFFFFFFFFFFFF0000
    0000000000000000000000000000000000000000000000000000000000000000
    000000000000000000000000000000000000000000000000000000000000}
  OldCreateOrder = True
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
    Height = 337
    BackWall.Brush.Color = clWhite
    BackWall.Brush.Gradient.Balance = 67
    BackWall.Brush.Gradient.EndColor = 15461355
    BackWall.Brush.Gradient.Visible = True
    BackWall.Color = clWhite
    BackWall.Transparent = False
    Foot.Alignment = taRightJustify
    Foot.Font.Height = -12
    Foot.Font.Quality = fqDefault
    Legend.Font.Height = -12
    Legend.Font.Quality = fqDefault
    Legend.Title.Font.Height = -12
    Legend.Title.Font.Quality = fqDefault
    Legend.TopPos = 0
    Legend.Visible = False
    MarginBottom = 5
    MarginLeft = 2
    MarginRight = 2
    MarginTop = 5
    ScrollMouseButton = mbLeft
    SubFoot.Font.Height = -12
    SubTitle.Font.Height = -12
    SubTitle.Font.Quality = fqDefault
    Title.Font.Height = -12
    Title.Font.Quality = fqDefault
    Title.Text.Strings = (
      'TChart')
    BottomAxis.Grid.Color = clSilver
    BottomAxis.Grid.Style = psSolid
    BottomAxis.Grid.Visible = False
    BottomAxis.LabelsFont.Height = -12
    BottomAxis.LabelsFont.Quality = fqDefault
    BottomAxis.LabelsMultiLine = True
    BottomAxis.MinorTickCount = 0
    BottomAxis.Title.Caption = 'X Axis'
    BottomAxis.Title.Font.Height = -12
    BottomAxis.Title.Font.Quality = fqDefault
    Chart3DPercent = 25
    DepthAxis.LabelsFont.Height = -12
    DepthAxis.Title.Font.Height = -12
    DepthTopAxis.LabelsFont.Height = -12
    DepthTopAxis.Title.Font.Height = -12
    LeftAxis.AxisValuesFormat = '0.0#'
    LeftAxis.Grid.Color = clSilver
    LeftAxis.Grid.Style = psSolid
    LeftAxis.Grid.Visible = False
    LeftAxis.LabelsFont.Height = -12
    LeftAxis.LabelsFont.Quality = fqDefault
    LeftAxis.MinorTickCount = 0
    LeftAxis.Title.Caption = 'Y Axis'
    LeftAxis.Title.Font.Height = -12
    LeftAxis.Title.Font.Quality = fqDefault
    RightAxis.Axis.Visible = False
    RightAxis.AxisValuesFormat = '0.0#'
    RightAxis.Grid.Style = psSolid
    RightAxis.Grid.Visible = False
    RightAxis.LabelsFont.Height = -12
    RightAxis.LabelsFont.Quality = fqDefault
    RightAxis.MinorTickCount = 0
    RightAxis.Title.Font.Height = -12
    RightAxis.Title.Font.Quality = fqDefault
    TopAxis.Axis.Visible = False
    TopAxis.LabelsFont.Height = -12
    TopAxis.LabelsFont.Quality = fqDefault
    TopAxis.Title.Font.Height = -12
    TopAxis.Title.Font.Quality = fqDefault
    View3D = False
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    OnMouseDown = Chart1MouseDown
    ColorPaletteIndex = 7
    object SpeedButton1: TSpeedButton
      Left = 1
      Top = 1
      Width = 23
      Height = 22
      Hint = 'Lock/Unlock'
      AllowAllUp = True
      GroupIndex = 1
      Flat = True
      Glyph.Data = {
        76020000424D7602000000000000760000002800000040000000100000000100
        0400000000000002000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333000003
        3333333333000003333333333300000333333333330000033333333300777770
        0333333300777770033333330077777003333333007777700333333088780878
        8033333088780878803333308878087880333330887808788033330777780877
        7703330777780877770333077778087777033307777808777703330888770778
        8803330888770778880333088877077888033308887707788803330777700077
        7703330777700077770333077770007777033307777000777703330888800088
        8803330888800088880333088880008888033308888000888803B30777777777
        7703B307777777777703330777777777770333077777777777033B3000000000
        00333B300000000000333330000000000033333000000000003333BBBB333307
        033333BBBB333307033333330703330703333333070333070333BBBB808BB307
        0333BBBB808BB30703333333070333070333333307033307033333BB07033307
        033333BB070333070333333307033307033333330703330703333B3B07033307
        03333B3B07033307033333338870007883333333887000788333B33B88700078
        8333B33B88700078833333333077777033333333307777703333333B30777770
        3333333B30777770333333333300000333333333330000033333333B33000003
        3333333B33000003333333333333333333333333333333333333}
      NumGlyphs = 4
      ParentShowHint = False
      ShowHint = True
    end
  end
end
