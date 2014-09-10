unit Dchart;
{
   Unit:    Dchart.pas
   Project: EPA SWMM
   Author:  L. Rossman
   Version: 5.1
   Delphi:  2010
   Date:    11/07/13

   This is the form unit used for the TChartDialog 
   dialog box component (ChartDlg.pas).
}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, Spin, ExtCtrls, ComCtrls, Chart, TeEngine,
  Series, Vcl.Themes, Vcl.Grids, UpDnEdit;

const
  LineStyleText: array[0..4] of PChar =
    ('Solid','Dash','Dot','DashDot','DashDotDot');
  LegendPosText: array[0..3] of PChar =
    ('Left','Right','Top','Bottom');
  MarkStyleText: array[0..7] of PChar =
    ('Rectangle','Circle','Up Triangle','Down Triangle','Cross',
     'Diagonal Cross','Star','Diamond');
  FillStyleText: array[0..7] of PChar =
    ('Solid','Clear','Horizontal','Vertical','Foward Diagonal','Back Diagonal',
     'Cross','Diagonal Cross');
  StackStyleText: array[0..3] of PChar =
    ('None','Side','Stacked','Stacked 100%');
  LabelStyleText: array[0..8] of PChar =
    ('Value','Percent','Label','Label & %','Label & Value','Legend','% Total',
     'Label & % Total','X Value');
  DateFormats: array[0..4] of PChar =
    ('h:nn', 'h:nn m/d/yy', 'm/d yyyy', 'mmm yyyy', 'yyyy');

  // Axis indexes
  BOTM   = 1;
  LEFT   = 2;
  RIGHT  = 3;

type
//Graph series types
  TSeriesType = (stLine, stFastLine, stPoint, stBar, stHorizBar, stArea, stPie);

  TGraphAxis = record
    Title: String;
    DataMin: String;
    DataMax: String;
    Min: String;
    Max: String;
    Delta: String;
    DateFmt: Integer;
    Auto: Boolean;
    Grid: Boolean;
  end;

//Graph series options
  TSeriesOptions = class(TObject)
    Constructor Create;
    public
      SeriesType      : TSeriesType;
      LineVisible     : Boolean;
      LineStyle       : Integer;
      LineColor       : TColor;
      LineWidth       : Integer;
      PointVisible    : Boolean;
      PointStyle      : Integer;
      PointColor      : TColor;
      PointSize       : Integer;
      AreaFillStyle   : Integer;
      AreaFillColor   : TColor;
      AreaStacking    : Integer;
      PieCircled      : Boolean;
      PieUsePatterns  : Boolean;
      PieRotation     : Integer;
      LabelsVisible   : Boolean;
      LabelsTransparent: Boolean;
      LabelsArrows    : Boolean;
      LabelsBackColor : TColor;
      LabelsStyle     : Integer;
    end;

  TChartOptionsDlg = class(TForm)
    DefaultBox: TCheckBox;
    FontDialog1: TFontDialog;
    OkBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    PageControl1: TPageControl;
    GeneralPage: TTabSheet;
    AxesPage: TTabSheet;
    LegendPage: TTabSheet;
    StylesPage: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label8: TLabel;
    PanelColorBox: TColorBox;
    BackColorBox1: TColorBox;
    View3DBox: TCheckBox;
    GraphTitleBox: TEdit;
    GraphTitleFontBtn: TButton;
    Pct3DUpDown: TUpDown;
    Pct3DEdit: TEdit;
    BackColorBox2: TColorBox;
    Label6: TLabel;
    Label7: TLabel;
    IncrementLabel: TLabel;
    Label11: TLabel;
    DataMinLabel: TLabel;
    DataMaxLabel: TLabel;
    AxisFormatLabel: TLabel;
    AxisMinEdit: TEdit;
    AxisMaxEdit: TEdit;
    AxisIncEdit: TEdit;
    AxisAutoCheck: TCheckBox;
    AxisTitleEdit: TEdit;
    AxisFontBtn: TButton;
    AxisGridCheck: TCheckBox;
    DateFmtCombo: TComboBox;
    Label18: TLabel;
    Label19: TLabel;
    LegendFrameBox: TCheckBox;
    LegendVisibleBox: TCheckBox;
    LegendPosBox: TComboBox;
    LegendColorBox: TColorBox;
    LegendCheckBox: TCheckBox;
    LegendShadowBox: TCheckBox;
    Label21: TLabel;
    Label22: TLabel;
    SeriesComboBox: TComboBox;
    SeriesTitle: TEdit;
    LegendFontBtn: TButton;
    Panel6: TPanel;
    PageControl2: TPageControl;
    LineOptionsSheet: TTabSheet;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    LineStyleBox: TComboBox;
    LineColorBox: TColorBox;
    LineVisibleBox: TCheckBox;
    LineSizeEdit: TEdit;
    LineSizeUpDown: TUpDown;
    MarkOptionsSheet: TTabSheet;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    MarkVisibleBox: TCheckBox;
    MarkStyleBox: TComboBox;
    MarkColorBox: TColorBox;
    MarkSizeEdit: TEdit;
    MarkSizeUpDown: TUpDown;
    AreaOptionsSheet: TTabSheet;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    AreaFillStyleBox: TComboBox;
    AreaColorBox: TColorBox;
    StackStyleBox: TComboBox;
    PieOptionsSheet: TTabSheet;
    Label32: TLabel;
    PieCircledBox: TCheckBox;
    PiePatternBox: TCheckBox;
    PieRotateEdit: TEdit;
    PieRotateUpDown: TUpDown;
    LabelsOptionsSheet: TTabSheet;
    Label33: TLabel;
    Label34: TLabel;
    LabelsStyleBox: TComboBox;
    LabelsBackColorBox: TColorBox;
    LabelsTransparentBox: TCheckBox;
    LabelsArrowsBox: TCheckBox;
    LabelsVisibleBox: TCheckBox;
    Label17: TLabel;
    AxisBottomBtn: TRadioButton;
    AxisLeftBtn: TRadioButton;
    AxisRightBtn: TRadioButton;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure GraphTitleFontBtnClick(Sender: TObject);
    procedure AxisFontBtnClick(Sender: TObject);
    procedure LegendFontBtnClick(Sender: TObject);
    procedure SeriesComboBoxClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure StylesPageExit(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure AxisBtnClick(Sender: TObject);
  private
    { Private declarations }
    theAxis:  Integer;
    theIndex: Integer;
    theSeries: TStringlist;
    IsPieChart: Boolean;
    IsDateTime: Boolean;
    GraphAxis: array[1..3] of TGraphAxis;
    procedure LoadDateTimeOptions(aChart: TChart);
    procedure GetSeriesOptions(const Index: Integer);
    procedure SetSeriesOptions(const Index: Integer);
    procedure SetAxisScaling(Axis: TChartAxis; const Smin,Smax,Sinc: String);
    procedure SaveCurrentAxisOptions;
    procedure SetCurrentAxisOptions;
    procedure SetAxisFmtDisplay(ShowIt: Boolean);
  public
    { Public declarations }
    UseDefaultPanelColor: Boolean;
    procedure LoadOptions(aChart: TChart);
    procedure UnloadOptions(aChart: TChart);
  end;

//var
//  ChartOptionsDlg: TChartOptionsDlg;

implementation

{$R *.dfm}

{Constructor for TSeriesOptions}
Constructor TSeriesOptions.Create;
begin
  Inherited Create;
end;

procedure TChartOptionsDlg.FormCreate(Sender: TObject);
var
  I: Integer;
begin
{ Load options into comboboxes }
  for I := 0 to High(LineStyleText) do
    LineStyleBox.Items.Add(LineStyleText[I]);
  for I := 0 to High(LegendPosText) do
    LegendPosBox.Items.Add(LegendPosText[I]);
  for I := 0 to High(FillStyleText) do
    AreaFillStyleBox.Items.Add(FillStyleText[I]);
  for I := 0 to High(MarkStyleText) do
    MarkStyleBox.Items.Add(MarkStyleText[I]);
  for I := 0 to High(StackStyleText) do
    StackStyleBox.Items.Add(StackStyleText[I]);
  for I := 0 to High(LabelStyleText) do
    LabelsStyleBox.Items.Add(LabelStyleText[I]);
  PanelColorBox.DefaultColorColor :=
    Integer(StyleServices.GetStyleColor(scPanel));
  UseDefaultPanelColor := False;

  { Position the Date Format controls on the Axes page }
  AxisFormatLabel.Top := IncrementLabel.Top;
  DateFmtCombo.Left := AxisIncEdit.Left;

{ Create a stringlist to hold data series options }
  theSeries := TStringlist.Create;
  theAxis := BOTM;
  PageControl1.ActivePage := GeneralPage;

end;

procedure TChartOptionsDlg.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  with theSeries do
  begin
    for i := 0 to Count - 1 do
      Objects[i].Free;
    Free;
  end;
end;

procedure TChartOptionsDlg.GraphTitleFontBtnClick(Sender: TObject);
begin
  with FontDialog1 do
  begin
    Font.Assign(GraphTitleBox.Font);
    if Execute then GraphTitleBox.Font.Assign(Font);
  end;
end;

procedure TChartOptionsDlg.HelpBtnClick(Sender: TObject);
begin
    Application.HelpCommand(HELP_CONTEXT, 211750);
end;

procedure TChartOptionsDlg.AxisBtnClick(Sender: TObject);
var
  NewAxis: Integer;
begin
  if      AxisBottomBtn.Checked then NewAxis := BOTM
  else if AxisLeftBtn.Checked then   NewAxis := LEFT
  else                               NewAxis := RIGHT;

  showmessage('NewAxis = ' + IntToStr(NewAxis));
  SaveCurrentAxisOptions;
  theAxis := NewAxis;
  SetCurrentAxisOptions;
end;

procedure TChartOptionsDlg.AxisFontBtnClick(Sender: TObject);
begin
  with FontDialog1 do
  begin
    Font.Assign(AxisTitleEdit.Font);
    if Execute then
    begin
      AxisTitleEdit.Font.Assign(Font);
    end;
  end;
end;

procedure TChartOptionsDlg.LegendFontBtnClick(Sender: TObject);
begin
  with FontDialog1 do
  begin
    Font.Assign(SeriesTitle.Font);
    if Execute then SeriesTitle.Font.Assign(Font);
  end;
end;

procedure TChartOptionsDlg.SeriesComboBoxClick(Sender: TObject);
begin
  if (Sender is TComboBox) then
    with Sender as TComboBox do
    begin
      GetSeriesOptions(theIndex);  {Store options for current series}
      theIndex := ItemIndex;       {Update value of current series}
      SetSeriesOptions(theIndex);  {Load series options into form}
    end;
end;

procedure TChartOptionsDlg.StylesPageExit(Sender: TObject);
begin
  GetSeriesOptions(theIndex);
end;

procedure TChartOptionsDlg.LoadOptions(aChart: TChart);
{------------------------------------------------------
  Transfers data from aChart to form.
-------------------------------------------------------}
var
  i: Integer;
  s: String;
  SeriesOptions: TSeriesOptions;
begin
  IsPieChart := False;
  with aChart do
  begin

  { General Page }
    View3DBox.Checked := View3D;
    Pct3DUpDown.Position := Chart3DPercent;
    with PanelColorBox do
    begin
      if aChart.Color = DefaultColorColor then
        ItemIndex := Items.IndexOf('Default')
      else Selected := aChart.Color;
    end;
    BackColorBox1.Selected := BackWall.Gradient.StartColor;
    BackColorBox2.Selected := BackWall.Gradient.EndColor;
    GraphTitleBox.Font.Assign(Title.Font);
    if (Title.Text.Count > 0) then
      GraphTitleBox.Text := Title.Text[0];

  { Series Page - do before Axis pages to get value for IsPieChart }
  { Save current line series options }
    IsDateTime := False;
    SeriesTitle.Font.Assign(Legend.Font);
    for i := 0 to SeriesCount-1 do
    begin
      if Series[i].Active then
      begin
        SeriesOptions := TSeriesOptions.Create;
        s := 'Series' + IntToStr(i+1);
        SeriesComboBox.Items.Add(s);
        if Series[i].XValues.DateTime then IsDateTime := True;

        with Series[i], SeriesOptions do
        begin
          LabelsVisible := Marks.Visible;
          LabelsArrows := Marks.Arrow.Visible;
          LabelsTransparent := Marks.Transparent;
          LabelsBackColor := Marks.BackColor;
          LabelsStyle := Ord(Marks.Style);
        end;
        if Series[i] is TLineSeries then
          with Series[i] as TLineSeries, SeriesOptions do
          begin
            SeriesType := stLine;
            LineVisible := LinePen.Visible;
            LineStyle := Ord(LinePen.Style);
            LineColor := SeriesColor;
            LineWidth := LinePen.Width;
            AreaFillStyle := Ord(LineBrush);
            PointVisible := Pointer.Visible;
            PointStyle := Ord(Pointer.Style);
            PointColor := ValueColor[0]; //Pointer.Brush.Color;
            PointSize := Pointer.VertSize;
            //PointColor := Pointer.Color;
            //PointSize := Pointer.Size;
          end
        else if Series[i] is TFastLineSeries then
          with Series[i] as TFastLineSeries, SeriesOptions do
          begin
            SeriesType := stFastLine;
            LineVisible := LinePen.Visible;
            LineStyle := Ord(LinePen.Style);
            LineColor := SeriesColor;
            LineWidth := LinePen.Width;
          end
        else if Series[i] is TPointSeries then
          with Series[i] as TPointSeries, SeriesOptions do
          begin
            SeriesType := stPoint;
            PointVisible := Pointer.Visible;
            PointStyle := Ord(Pointer.Style);
            PointColor := SeriesColor;
            PointSize := Pointer.HorizSize;
          end
        else if Series[i] is TBarSeries then
          with Series[i] as TBarSeries, SeriesOptions do
          begin
            SeriesType := stBar;
            AreaFillStyle := Ord(BarBrush.Style);
            if BarBrush.Style = bsSolid then
            begin
              AreaFillColor := SeriesColor;
              LineColor := BarBrush.Color;
            end
            else
            begin
              LineColor := SeriesColor;
              AreaFillColor := BarBrush.Color;
            end;
            AreaStacking := Ord(MultiBar);
          end
        else if Series[i] is THorizBarSeries then
          with Series[i] as THorizBarSeries, SeriesOptions do
          begin
            SeriesType := stHorizBar;
            AreaFillStyle := Ord(BarBrush.Style);
            if BarBrush.Style = bsSolid then
            begin
              AreaFillColor := SeriesColor;
              LineColor := BarBrush.Color;
            end
            else
            begin
              LineColor := SeriesColor;
              AreaFillColor := BarBrush.Color;
            end;
            AreaStacking := Ord(MultiBar);
          end
        else if Series[i] is TAreaSeries then
          with Series[i] as TAreaSeries, SeriesOptions do
          begin
            SeriesType := stArea;
            LineVisible := AreaLinesPen.Visible;
            LineStyle := Ord(AreaLinesPen.Style);
            LineColor := AreaLinesPen.Color;
            LineWidth := AreaLinesPen.Width;
            AreaFillColor := SeriesColor;
            AreaFillStyle := Ord(AreaBrush);
          end
        else if Series[i] is TPieSeries then
          with Series[i] as TPieSeries, SeriesOptions do
          begin
            SeriesType := stPie;
            IsPieChart := True;
            LineVisible := PiePen.Visible;
            LineStyle := Ord(PiePen.Style);
            LineColor := PiePen.Color;  //SeriesColor;
            LineWidth := PiePen.Width;
            PieCircled := Circled;
            PieUsePatterns := UsePatterns;
            PieRotation := RotationAngle;
          end;
        if Length(Series[i].Title) > 0 then s := Series[i].Title;
        theSeries.AddObject(s,SeriesOptions);
      end;
    end;

  // Bottom Axis
    if IsPieChart then AxesPage.TabVisible := False
    else
    begin
      if IsDateTime = True then LoadDateTimeOptions(aChart) else
      begin
        GraphAxis[BOTM].DataMin := Format('(%f)',[MinXValue(BottomAxis)]);
        GraphAxis[BOTM].DataMax := Format('(%f)',[MaxXValue(BottomAxis)]);
        AxisFormatLabel.Visible := False;
        DateFmtCombo.Visible := False;
        with BottomAxis do
        begin
          GraphAxis[BOTM].Auto := Automatic;
          if not Automatic then
          begin
            GraphAxis[BOTM].Min := Format('%f',[Minimum]);
            GraphAxis[BOTM].Max := Format('%f',[Maximum]);
            GraphAxis[BOTM].Delta := Format('%f',[Increment]);
          end;
        end;
      end;
      with BottomAxis do
      begin
        GraphAxis[BOTM].Grid := Grid.Visible;
        AxisTitleEdit.Font.Assign(Title.Font);
        GraphAxis[BOTM].Title := Title.Caption;
      end;
    end;

  // Left Axis
    if not IsPieChart then
    begin
      GraphAxis[LEFT].DataMin := Format('(%f)',[MinYValue(LeftAxis)]);
      GraphAxis[LEFT].DataMax := Format('(%f)',[MaxYValue(LeftAxis)]);
      with LeftAxis do
      begin
        GraphAxis[LEFT].Auto := Automatic;
        if not Automatic then
        begin
          GraphAxis[LEFT].Min := Format('%f',[Minimum]);
          GraphAxis[LEFT].Max := Format('%f',[Maximum]);
          GraphAxis[LEFT].Delta := Format('%f',[Increment]);
        end;
        GraphAxis[LEFT].Grid := Grid.Visible;
        GraphAxis[LEFT].Title := Title.Caption;
      end;
    end;
{
  // Right Axis
    if not IsPieChart then
    begin
      GraphAxis[RIGHT].DataMin := Format('(%f)',[MinYValue(RightAxis)]);
      GraphAxis[RIGHT].DataMax := Format('(%f)',[MaxYValue(RightAxis)]);
      with RightAxis do
      begin
        GraphAxis[RIGHT].Auto := Automatic;
        if not Automatic then
        begin
          GraphAxis[RIGHT].Min := Format('%f',[Minimum]);
          GraphAxis[RIGHT].Max := Format('%f',[Maximum]);
          GraphAxis[RIGHT].Delta := Format('%f',[Increment]);
        end;
        GraphAxis[RIGHT].Grid := Grid.Visible;
        GraphAxis[RIGHT].Title := Title.Caption;
      end;
    end;
}
  // Legend Page
    LegendPosBox.ItemIndex := Ord(Legend.Alignment);
    LegendColorBox.Selected := Legend.Color;
    LegendCheckBox.Checked := Legend.CheckBoxes;
    LegendShadowBox.Checked := Legend.Shadow.Visible;
    LegendFrameBox.Checked := Legend.Frame.Visible;
    LegendVisibleBox.Checked := Legend.Visible;
  end;

//Set current series to first series & update dialog entries
  if aChart.SeriesCount > 0 then
  begin
    theIndex := 0;
    SeriesComboBox.ItemIndex := 0;
    SetSeriesOptions(0);
  end
  else StylesPage.TabVisible := False;
  theAxis := BOTM;

 showmessage('theAxis0 = ' + IntToStr(theAxis));
  SetCurrentAxisOptions;
end;

procedure TChartOptionsDlg.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePage = StylesPage
    then SetSeriesOptions(theIndex);
end;

procedure TChartOptionsDlg.LoadDateTimeOptions(aChart: TChart);
{--------------------------------------------------------------
   Sets up the X Axis page for using Date/Time formats.
---------------------------------------------------------------}
var
  I      : Integer;
  Fmt    : Integer;
  S      : String;
  MinDate: TDateTime;
  MaxDate: TDateTime;
begin
  MinDate := aChart.MinXValue(aChart.BottomAxis);
  DateTimeToString(S, DateFormats[1], MinDate);
  GraphAxis[BOTM].Min := S;
  MaxDate := aChart.MaxXValue(aChart.BottomAxis);
  DateTimeToString(S, DateFormats[1], MaxDate);
  GraphAxis[BOTM].Max := S;
  S := aChart.BottomAxis.DateTimeFormat;
  Fmt := 1;
  for I := 0 to High(DateFormats) do
    if SameText(S, DateFormats[I]) then Fmt := i;
  for I := 0 to High(DateFormats) do
  begin
    DateTimeToString(S, DateFormats[I], MinDate);
    DateFmtCombo.Items.Add(S);
  end;
  DateFmtCombo.ItemIndex := Fmt;
  GraphAxis[BOTM].DateFmt := Fmt;
end;

procedure TChartOptionsDlg.UnloadOptions(aChart: TChart);
{--------------------------------------------------------
   Transfers data from form back to aChart.
---------------------------------------------------------}
var
  I, J: Integer;
  S  : String;
  SeriesOptions: TSeriesOptions;
begin
  with aChart do
  begin

  // General Page
    View3D := View3DBox.Checked;
    Chart3DPercent := Pct3DUpDown.Position;
    BackWall.Gradient.StartColor := BackColorBox1.Selected;
    BackWall.Gradient.EndColor := BackColorBox2.Selected;
    with PanelColorBox do
    begin
      if Items[ItemIndex] = 'Default' then
      begin
        aChart.Color := DefaultColorColor;
        UseDefaultPanelColor := True;
      end
      else aChart.Color := Selected;
    end;
    Title.Font.Assign(GraphTitleBox.Font);
    S := GraphTitleBox.Text;
    Title.Text.Clear;
    if (Length(S) > 0) then Title.Text.Add(S);

  // Bottom Axis
    if not IsPieChart then with BottomAxis do
    begin
      Automatic := GraphAxis[BOTM].Auto;
      if IsDateTime then
        DateTimeFormat := DateFormats[DateFmtCombo.ItemIndex]
      else if not Automatic then
        SetAxisScaling(BottomAxis, GraphAxis[BOTM].Min,
          GraphAxis[BOTM].Max, GraphAxis[BOTM].Delta);
      Grid.Visible := GraphAxis[BOTM].Grid;
      Title.Caption := GraphAxis[BOTM].Title;
      Title.Font.Assign(AxisTitleEdit.Font);
      LabelsFont.Assign(AxisTitleEdit.Font);
    end;

  // Left Axis
    if not IsPieChart then with LeftAxis do
    begin
      Automatic := GraphAxis[LEFT].Auto;
      if not Automatic then
        SetAxisScaling(LeftAxis, GraphAxis[LEFT].Min,
          GraphAxis[LEFT].Max, GraphAxis[LEFT].Delta);
      Grid.Visible := GraphAxis[LEFT].Grid;
      Title.Caption := GraphAxis[LEFT].Title;
      Title.Font.Assign(AxisTitleEdit.Font);
      LabelsFont.Assign(AxisTitleEdit.Font);
    end;

  // Legend Page
    Legend.Alignment := TLegendAlignment(LegendPosBox.ItemIndex);
    Legend.Color := LegendColorBox.Selected;
    Legend.CheckBoxes := LegendCheckBox.Checked;
    Legend.Shadow.Visible := LegendShadowBox.Checked;
    Legend.Frame.Visible := LegendFrameBox.Checked;
    Legend.Visible := LegendVisibleBox.Checked;
    Legend.Font.Assign(SeriesTitle.Font);

  // Series Page
    if SeriesCount > 0 then
    begin
      GetSeriesOptions(theIndex);
      j := 0;
      for i := 0 to SeriesCount-1 do
      begin
        if Series[i].Active then
        begin
          SeriesOptions := TSeriesOptions(theSeries.Objects[j]);
          Series[i].Title := theSeries.Strings[j];

          with Series[i], SeriesOptions do
          begin
            Marks.Visible := LabelsVisible;
            Marks.Arrow.Visible := LabelsArrows;
            Marks.Transparent := LabelsTransparent;
            Marks.BackColor := LabelsBackColor;
            Marks.Style := TSeriesMarksStyle(LabelsStyle);
          end;

          if Series[i] is TLineSeries then
          with Series[i] as TLineSeries, SeriesOptions do
          begin
            LinePen.Visible := LineVisible;
            if LinePen.Visible then
              LinePen.Style := TPenStyle(LineStyle)
            else
              LinePen.Style := psClear;
            SeriesColor := LineColor;
            LinePen.Width := LineWidth;
            Pointer.Visible := PointVisible;
            Pointer.Style := TSeriesPointerStyle(PointStyle);
            Pointer.Color := PointColor;
            Pointer.Size := PointSize;
            LineBrush := TBrushStyle(AreaFillStyle);
            if (not Pointer.Visible) and (not LinePen.Visible) then
              ShowinLegend := False
            else
              ShowinLegend := True;
          end;

          if Series[i] is TFastLineSeries then
          with Series[i] as TFastLineSeries, SeriesOptions do
          begin
            LinePen.Visible := LineVisible;
            if LinePen.Visible then
              LinePen.Style := TPenStyle(LineStyle)
            else
              LinePen.Style := psClear;
            SeriesColor := LineColor;
            LinePen.Width := LineWidth;
            ShowinLegend := LinePen.Visible;
          end;

          if Series[i] is TPointSeries then
          with Series[i] as TPointSeries, SeriesOptions do
          begin
            Pointer.Visible := PointVisible;
            Pointer.Style := TSeriesPointerStyle(PointStyle);
            SeriesColor := PointColor;
            //Pointer.Brush.Color := PointColor;
            Pointer.Size := PointSize;
            //Pointer.HorizSize := PointSize;
            //Pointer.VertSize := Pointer.HorizSize;
          end

          else if Series[i] is TBarSeries then
          with Series[i] as TBarSeries, SeriesOptions do
          begin
            BarBrush.Style := TBrushStyle(AreaFillStyle);
            if BarBrush.Style = bsSolid then
            begin
              SeriesColor := AreaFillColor;
              BarBrush.Color := AreaFillColor
            end
            else
            begin
              SeriesColor := LineColor;
              BarBrush.Color := AreaFillColor;
            end;
            MultiBar := TMultiBar(AreaStacking);
          end

          else if Series[i] is THorizBarSeries then
          with Series[i] as THorizBarSeries, SeriesOptions do
          begin
            BarBrush.Style := TBrushStyle(AreaFillStyle);
            if BarBrush.Style = bsSolid then
            begin
              SeriesColor := AreaFillColor;
              BarBrush.Color := AreaFillColor
            end
            else
            begin
              SeriesColor := LineColor;
              BarBrush.Color := AreaFillColor;
            end;
            MultiBar := TMultiBar(AreaStacking);
          end

          else if Series[i] is TAreaSeries then
          with Series[i] as TAreaSeries, SeriesOptions do
          begin
            AreaBrush := TBrushStyle(AreaFillStyle);
            SeriesColor := AreaFillColor;
            if AreaBrush = bsSolid then
              AreaColor := AreaFillColor
            else
              AreaColor := LineColor;
            AreaLinesPen.Visible := LineVisible;
            AreaLinesPen.Style := TPenStyle(LineStyle);
            AreaLinesPen.Color := LineColor;
            AreaLinesPen.Width := LineWidth;
          end

          else if Series[i] is TPieSeries then
          with Series[i] as TPieSeries, SeriesOptions do
          begin
            PiePen.Visible := LineVisible;
            PiePen.Style := TPenStyle(LineStyle);
            PiePen.Color := LineColor;
            PiePen.Width := LineWidth;
            Circled := PieCircled;
            UsePatterns := PieUsePatterns;
            RotationAngle := PieRotation;
          end;

          Inc(j);
        end;
      end;
    end;
  end;
end;

procedure TChartOptionsDlg.SaveCurrentAxisOptions;
begin
  GraphAxis[theAxis].DataMin := DataMinLabel.Caption;
  GraphAxis[theAxis].DataMax := DataMaxLabel.Caption;
  GraphAxis[theAxis].Auto := AxisAutoCheck.Checked;
  GraphAxis[theAxis].Min := AxisMinEdit.Text;
  GraphAxis[theAxis].Max := AxisMaxEdit.Text;
  GraphAxis[theAxis].Delta := AxisIncEdit.Text;
  GraphAxis[theAxis].Grid := AxisGridCheck.Checked;
  GraphAxis[theAxis].Title := AxisTitleEdit.Text;
end;

procedure TChartOptionsDlg.SetCurrentAxisOptions;
begin
  DataMinLabel.Caption := GraphAxis[theAxis].DataMin;
  DataMaxLabel.Caption := GraphAxis[theAxis].DataMax;
  AxisAutoCheck.Checked := GraphAxis[theAxis].Auto;
  AxisMinEdit.Text := GraphAxis[theAxis].Min;
  AxisMaxEdit.Text := GraphAxis[theAxis].Max;
  AxisIncEdit.Text := GraphAxis[theAxis].Delta;
  AxisGridCheck.Checked := GraphAxis[theAxis].Grid;
  AxisTitleEdit.Text := GraphAxis[theAxis].Title;
  if theAxis <> BOTM then SetAxisFmtDisplay(False)
  else SetAxisFmtDisplay(IsDateTime);
end;

procedure TChartOptionsDlg.SetAxisFmtDisplay(ShowIt: Boolean);
begin
  DataMinLabel.Visible := not ShowIt;
  DataMaxLabel.Visible := not ShowIt;
  AxisMinEdit.Enabled := not ShowIt;
  AxisMaxEdit.Enabled := not ShowIt;
  AxisIncEdit.Visible := not ShowIt;
  IncrementLabel.Visible := not ShowIt;

  AxisFormatLabel.Visible := ShowIt;
  DateFmtCombo.Visible := ShowIt;
  if ShowIt then
  begin
    AxisAutoCheck.Checked := True;
    AxisAutoCheck.Enabled := False;
  end;
end;

procedure TChartOptionsDlg.SetAxisScaling(Axis: TChartAxis;
            const Smin, Smax, Sinc: String);
{-------------------------------------------------
   Retrieves axis scaling options from form.
--------------------------------------------------}
var
  Code: Integer;
  V   : Double;
begin
  with Axis do
  begin
    AutomaticMinimum := False;
    Val(Smin, V, Code);
    if (Code = 0) then
      Minimum := V
    else
      AutomaticMinimum := True;
    AutomaticMaximum := False;
    Val(Smax, V, Code);
    if (Code = 0) then
      Maximum := V
    else
      AutomaticMaximum := True;
    Val(Sinc, V, Code);
    if (Code = 0) then
      Increment := V
    else
      Increment := 0;
  end;
end;

procedure TChartOptionsDlg.SetSeriesOptions(const Index: Integer);
{------------------------------------------------------
   Transfer options for data series Index to form.
------------------------------------------------------}
var
  SeriesOptions: TSeriesOptions;
begin
  SeriesTitle.Text := theSeries.Strings[Index];
  SeriesOptions := TSeriesOptions(theSeries.Objects[Index]);
  with SeriesOptions do
  begin
    LineStyleBox.ItemIndex := LineStyle;
    LineColorBox.Selected := LineColor;
    LineSizeUpDown.Position := LineWidth;
    LineVisibleBox.Checked := LineVisible;
    MarkStyleBox.ItemIndex := PointStyle;
    MarkColorBox.Selected := PointColor;
    MarkSizeUpDown.Position := PointSize;
    MarkVisibleBox.Checked := PointVisible;
    AreaFillStyleBox.ItemIndex := AreaFillStyle;
    AreaColorBox.Selected := AreaFillColor;
    StackStyleBox.ItemIndex := AreaStacking;
    PieCircledBox.Checked := PieCircled;
    PiePatternBox.Checked := PieUsePatterns;
    PieRotateUpDown.Position := PieRotation;
    LabelsVisibleBox.Checked := LabelsVisible;
    LabelsTransparentBox.Checked := LabelsTransparent;
    LabelsBackColorBox.Selected := LabelsBackColor;
    LabelsArrowsBox.Checked := LabelsArrows;
    LabelsStyleBox.ItemIndex := LabelsStyle;
  end;
  PieOptionsSheet.TabVisible := False;
  case SeriesOptions.SeriesType of
  stLine:
  begin
    LineOptionsSheet.TabVisible := True;
    MarkOptionsSheet.TabVisible := True;
    AreaOptionsSheet.TabVisible := True;
    LabelsOptionsSheet.TabVisible := True;
    PageControl2.ActivePage := LineOptionsSheet;
  end;
  stFastLine:
  begin
    LineOptionsSheet.TabVisible := True;
    MarkOptionsSheet.TabVisible := False;
    AreaOptionsSheet.TabVisible := False;
    LabelsOptionsSheet.TabVisible := False;
    PageControl2.ActivePage := LineOptionsSheet;
  end;
  stPoint:
  begin
    LineOptionsSheet.TabVisible := False;
    MarkOptionsSheet.TabVisible := True;
    AreaOptionsSheet.TabVisible := False;
    LabelsOptionsSheet.TabVisible := True;
    PageControl2.ActivePage := MarkOptionsSheet;
  end;
  stBar, stHorizBar:
  begin
    LineOptionsSheet.TabVisible := True;
    MarkOptionsSheet.TabVisible := False;
    AreaOptionsSheet.TabVisible := True;
    LabelsOptionsSheet.TabVisible := True;
    PageControl2.ActivePage := AreaOptionsSheet;
  end;
  stArea:
  begin
    LineOptionsSheet.TabVisible := True;
    MarkOptionsSheet.TabVisible := False;
    AreaOptionsSheet.TabVisible := True;
    LabelsOptionsSheet.TabVisible := True;
    PageControl2.ActivePage := AreaOptionsSheet;
  end;
  stPie:
  begin
    LineOptionsSheet.TabVisible := True;
    MarkOptionsSheet.TabVisible := False;
    AreaOptionsSheet.TabVisible := False;
    PieOptionsSheet.TabVisible := True;
    LabelsOptionsSheet.TabVisible := True;
    PageControl2.ActivePage := PieOptionsSheet;
  end;
  end;
end;

procedure TChartOptionsDlg.GetSeriesOptions(const Index: Integer);
{------------------------------------------------------
   Transfer options from form to data series Index.
------------------------------------------------------}
var
  SeriesOptions: TSeriesOptions;
begin
  theSeries.Strings[Index] := SeriesTitle.Text;
  SeriesOptions := TSeriesOptions(theSeries.Objects[Index]);
  with SeriesOptions do
  begin
    if LineOptionsSheet.TabVisible then
    begin
      LineStyle := LineStyleBox.ItemIndex;
      LineColor := LineColorBox.Selected;
      LineWidth := LineSizeUpDown.Position;
      LineVisible := LineVisibleBox.Checked;
    end;
    if MarkOptionsSheet.TabVisible then
    begin
      PointStyle := MarkStyleBox.ItemIndex;
      PointColor := MarkColorBox.Selected;
      PointSize := MarkSizeUpDown.Position;
      PointVisible := MarkVisibleBox.Checked;
    end;
    if AreaOptionsSheet.TabVisible then
    begin
      AreaFillStyle := AreaFillStyleBox.ItemIndex;
      AreaFillColor := AreaColorBox.Selected;
      AreaStacking := StackStyleBox.ItemIndex;
    end;
    if PieOptionsSheet.TabVisible then
    begin
      PieCircled := PieCircledBox.Checked;
      PieUsePatterns := PiePatternBox.Checked;
      PieRotation := PieRotateUpDown.Position;
    end;
    if LabelsOptionsSheet.TabVisible then
    begin
      LabelsVisible := LabelsVisibleBox.Checked;
      LabelsArrows := LabelsArrowsBox.Checked;
      LabelsTransparent := LabelsTransparentBox.Checked;
      LabelsBackColor := LabelsBackColorBox.Selected;
      LabelsStyle := LabelsStyleBox.ItemIndex;
    end;
  end;
end;

end.
