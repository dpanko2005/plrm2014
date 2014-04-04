unit Uglobals;

{-------------------------------------------------------------------}
{                    Unit:    Uglobals.pas                          }
{                    Project: EPA SWMM                              }
{                    Version: 5.1                                   }
{                    Date:    12/2/13     (5.1.000)                 }
{                    Author:  L. Rossman                            }
{                                                                   }
{   Delphi Pascal unit that defines all global data types and       }
{   constants used by EPA SWMM.                                     }
{-------------------------------------------------------------------}

interface

uses
  SysUtils, Types, Forms, Messages, Classes, Graphics,
  Controls, Dialogs, Math, Windows, Vcl.Themes,
  Propedit, Uutils, Uproject, Uvertex;

type
  TUnitSystem     = (usUS,usSI);
  TRunStatus      = (rsSuccess, rsWarning, rsError, rsWrongVersion,
                     rsFailed, rsShutdown, rsStopped, rsImportError,
                     rsNone);
  TArrowStyle     = (asNone, asOpen, asFilled, asFancy);
  TMapUnits       = (muFeet, muMeters, muDegrees, muNone);
  TInputFileType  = (iftNone, iftNET, iftINP);

const
//------------------
// Object categories
//------------------
  TXT_SUBCATCH = 'Subcatch';
  TXT_NODE = 'Node';
  TXT_LINK = 'Link';
  TXT_SYS  = 'System';

//-----------------------------------------
// Version ID - range of versions supported
//-----------------------------------------
  VERSIONID1 = 51000;
  VERSIONID2 = 51000;

//------------------
// File names
//------------------
  INIFILE = 'epaswmm5.ini';
  HLPFILE = 'epaswmm5.chm';
  TUTORFILE = 'tutorial.chm';

//------------------
// Maximum limits
//------------------
  MAXINTERVALS = 4;  //Max. color scale interval index
  MAXSERIES    = 5;  //Max. graph series index
  MAXCOLS      = 10; //Max. columns in a table
  MAXFILTERS   = 10; //Max. filter conditions for table
  MAXQUALPARAMS = 3; //Max. types of WQ analyses
  MAXDEGDIGITS  = 6; //Max. decimal digits for lat-long degrees
  MAXMRUINDEX   = 9; //Max. index of Most Recently Used files

//---------------
// Custom cursors
//---------------
  crXHAIR    = 1;
  crZOOMIN   = 2;
  crZOOMOUT  = 3;
  crFIST     = 4;
  crMOVE     = 5;
  crPENCIL   = 6;
  crARROWTIP = 7;
  crSQUARE   = 8;

//-----------------------
// Subcatchment variables
//-----------------------
  AREA            = 1;  //Input
  WIDTH           = 2;  //Input
  SUBCATCHSLOPE   = 3;  //Input
  IMPERVIOUSNESS  = 4;  //Input
  LID_USAGE       = 5;  //Input
  RAINFALL        = 6;  //Output
  SNOWDEPTH       = 7;  //Output
  EVAP            = 8;  //Output
  INFIL           = 9;  //Output
  RUNOFF          = 10; //Output
  GW_FLOW         = 11; //Output
  GW_ELEV         = 12; //Output
  GW_MOIST        = 13; //Output
  SUBCATCHQUAL    = 14; //Output
  SUBCATCHVIEWS   = 14; //Max. display variable index
  SUBCATCHOUTVAR1 = 6;  //Index of 1st output variable

//-----------------
// Node variables
//-----------------
  INVERT      = 1;   //Input
  NODEDEPTH   = 2;   //Output
  HEAD        = 3;   //Output
  VOLUME      = 4;   //Output
  LATFLOW     = 5;   //Output
  INFLOW      = 6;   //Output
  OVERFLOW    = 7;   //Output
  NODEQUAL    = 8;   //Output
  NODEVIEWS   = 8;   //Max. display variable index
  NODEOUTVAR1 = 2;   //Index of 1st output variable

//--------------------
// Link view variables
//--------------------
  DIAMETER    = 1;   //Input
  ROUGHNESS   = 2;   //Input
  LINKSLOPE   = 3;   //Input
  FLOW        = 4;   //Output
  LINKDEPTH   = 5;   //Output
  VELOCITY    = 6;   //Output
  LINKVOLUME  = 7;   //Output
  CAPACITY    = 8;   //Output
  LINKQUAL    = 9;   //Output
  LINKVIEWS   = 9;   //Max. display variable index
  LINKOUTVAR1 = 4;   //Index of 1st output variable

//----------------------
// System view variables
//----------------------
  SYS_TEMPERATURE = 0;
  SYS_RAINFALL    = 1;
  SYS_SNOWDEPTH   = 2;
  SYS_INFIL       = 3;
  SYS_RUNOFF      = 4;
  SYS_DWFLOW      = 5;
  SYS_GWFLOW      = 6;
  SYS_IIFLOW      = 7;
  SYS_EXFLOW      = 8;
  SYS_INFLOW      = 9;
  SYS_FLOODING    = 10;
  SYS_OUTFLOW     = 11;
  SYS_STORAGE     = 12;
  SYS_EVAP        = 13;
  SYSVIEWS        = 13;
  SYSOUTVAR1      = 0;

//------------------
// Report-type codes
//------------------
  TIMESERIESPLOT  = 0;
  PROFILEPLOT     = 1;
  SCATTERPLOT     = 2;
  FREQUENCYPLOT   = 3;
  TABLEBYVARIABLE = 4;
  TABLEBYOBJECT   = 5;

//----------------------
// Reported Object codes
//----------------------
  SUBCATCHMENTS = 0;
  NODES         = 1;
  LINKS         = 2;
  SYS           = 3;

//----------------------
// Network map constants
//----------------------
  MINMAPSIZE = 100;
  SYMBOLSIZE = 4;
  PIXTOL = 5;

//------------------------------
// Map and default legend colors
//------------------------------
  MAXMAPCOLORINDEX = 9;
  MapForeColor: array[1..MAXMAPCOLORINDEX] of TColor =
    (clBlack, clBlack, clBlack, clBlack, clWhite,
     clBlack, clBlack, clBlack, clSilver);
  MapGrayColor: array[1..MAXMAPCOLORINDEX] of TColor =
    (clBlack, clBlack, clBlack, clBlack, clGray,
     clBlack, clBlack, clBlack, clSilver);
  DefLegendColor: array[0..MAXINTERVALS] of TColor =
    ($FF0000, $FFFF00, $FF00, $FFFF, $FF);

//-------------------------
// Map viewing action codes
//-------------------------
  SELECT       = 101;
  VERTEXSELECT = 102;
  GROUPSELECT  = 103;
  PAN          = 104;
  ZOOMIN       = 105;
  ZOOMOUT      = 106;
  FULLEXTENT   = 107;
  RULER        = 108;

//--------------------
//Data reporting units
//--------------------
  USFlowUnits: array[0..2] of PChar = ('CFS', 'GPM', 'MGD');

  SIFlowUnits: array[0..2] of PChar = ('CMS', 'LPS', 'MLD');

  MassUnits:   array[0..2] of PChar = ('mg/L', 'ug/L', '#/L');

  TempUnits:   array[TUnitSystem] of PChar = ('deg F','deg C');

  EvapUnits:   array[TUnitSystem] of PChar = ('in/day','mm/day');

  BaseSubcatchUnits: array[0..SUBCATCHVIEWS, TUnitSystem] of PChar =
                 (('',''),                // No View
                  ('ac','ha'),            // Area
                  ('ft','m'),             // Width
                  ('%','%'),              // Slope
                  ('%','%'),              // Imperviousness
                  ('%','%'),              // LID Usage
                  ('in/hr','mm/hr'),      // Rainfall
                  ('in', 'mm'),           // Snow Depth
                  ('in/day','mm/day'),    // Evap Rate
                  ('in/hr','mm/hr'),      // Infil Rate
                  ('CFS','CMS'),          // Runoff
                  ('CFS','CMS'),          // GW Flow
                  ('ft','m'),             // GW Elev
                  ('',''),                // Soil Moisture
                  ('mg/L','mg/L'));       // Washoff

  BaseNodeUnits: array[0..NODEVIEWS, TUnitSystem] of PChar =
                 (('',''),                // No View
                  ('ft','m'),             // Elev.
                  ('ft','m'),             // Depth
                  ('ft','m'),             // Head
                  ('ft3','m3'),           // Volume
                  ('CFS','CMS'),          // Lateral Inflow
                  ('CFS','CMS'),          // Total Inflow
                  ('CFS','CMS'),          // Overflow
                  ('mg/L','mg/L'));       // Quality

  BaseLinkUnits: array[0..LINKVIEWS,TUnitSystem] of PChar =
                 (('',''),                // No View
                  ('ft','m'),             // Max. Depth
                  ('',''),                // Manning N
                  ('%','%'),              // Slope
                  ('CFS','CMS'),          // Flow
                  ('ft','m'),             // Depth
                  ('fps','m/s'),          // Velocity
                  ('ft3','m3'),           // Volume.
                  ('',''),                // Fraction Full
                  ('mg/L','mg/L'));       // Quality

  MapUnits: array[0..3] of PChar =
                  ('Feet', 'Meters', 'Degrees', 'None');
  MapUnitsAbbrev: array[0..3] of PChar =
                  ('ft', 'm', 'deg', '');

//---------------------
//Calibration Variables
//---------------------
  CalibVariables: array[1..12] of String =
  ('Subcatchment Runoff', 'Subcatchment Washoff', 'Node Water Depth',
   'Link Flow Rate', 'Node Water Quality', 'Node Lateral Inflow',
   'Node Flooding', 'Groundwater Flow', 'Groundwater Elevation',
   'Snow Pack Depth', 'Link Flow Depth', 'Link Flow Velocity');

//------------------
//Auto-Length status
//------------------
  AutoLengthStatus: array[0..1] of PChar = ('Off', 'On');

//---------------------
//Map Label meter types (not used)
//---------------------
  MeterTypes: array[0..3] of PChar = ('None','Area','Node','Link');

//----------------------------------------------------
// Relations used in search filters
// (these correspond to the elements of TRelationType
// which is declared in the unit Uutils.pas)
//----------------------------------------------------
  FilterRelation: array[0..2] of PChar = ('Below','Equal To','Above');

//------------------------
// Unit conversion factors
//------------------------
  METERSperFOOT     = 0.3048;
  FEETperMETER      = 3.281;
  ACRESperFOOT2     = 2.2956e-5;
  ACRESperMETER2    = 24.71e-5;
  HECTARESperMETER2 = 0.0001;
  HECTARESperFOOT2  = 0.92903e-5;

//------------------------
// Miscellaneous constants
//------------------------
  FLOWTOL         = 0.005;             //Zero flow tolerance
  MISSING         = -1.0e10;           //Missing value
  NOXY            = -9999999;          //Missing map coordinate

  NOPOINT: TPoint = (X: -9999999; Y: -9999999);
  NORECT: TRect   = (Left: -9999999; Top: -9999999;
                     Right: -9999999; Bottom: -9999999);

  NODATE          = -693594;   // 1/1/0001
  NA              = '#N/A';
  NONE            = 0;
  NOVIEW          = 0;
  PLUS            = 1;
  MINUS           = 2;
  DefMeasError    = 5;
  DefIDIncrement  = 1;
  DefMaxTrials    = 8;
  DefMinSurfAreaUS = '12.557'; //(ft2)
  DefMinSurfAreaSI = '1.14';   //(m2)
  DefHeadTolUS     = '0.005';  //(ft)
  DefHeadTolSI     = '0.0015'; //(m)

type
//-----------------------------------------
// View variable (visual theme) information
//-----------------------------------------
  TViewVariable = record
    Name        : String;
    SourceIndex : Integer;
    DefIntervals: array[1..MAXINTERVALS] of Single;
  end;
  TVariableUnits = record
    Units       : String;
    Digits      : Integer;
  end;

//----------------
// Map legend data
//----------------
  TMapLegend = record
    Intervals  : array[0..MAXINTERVALS] of Single;
    Nintervals : Integer; //# intervals used
    Ltype      : Integer; //Legend type (SUBCATCH, NODE or LINK)
    ViewVar    : Integer; //View variable index
  end;

//-----------------
// Map legend frame
//-----------------
  TLegendFrame = record
    X,Y      : Single;
    Framed   : Boolean;
  end;

//-----------------
// Calibration data
//-----------------
  TCalibData = record
    FileName : String;      //File where data resides
    Locations: String;      //Locations where measurements exist
  end;

//----------------------
// Graph display options
//----------------------
  TGraphOptions = record
    View3D          : Boolean;
    Percent3D       : Integer;
    PanelColor      : TColor;
    BackColor       : TColor;
    BackGradColor   : TColor;
    LegendPosition  : Integer;
    LegendColor     : TColor;
    LegendWidth     : Integer;
    LegendTransparent: Boolean;
    LegendFramed    : Boolean;
    LegendVisible   : Boolean;
    AxisGridStyle   : array[0..2] of Integer;
    AxisGridColor   : TColor;
    LineVisible     : array [0..MAXSERIES] of Boolean;
    LineStyle       : array [0..MAXSERIES] of Integer;
    LineColor       : array [0..MAXSERIES] of TColor;
    LineWidth       : array [0..MAXSERIES] of Integer;
    PointVisible    : array [0..MAXSERIES] of Boolean;
    PointStyle      : array [0..MAXSERIES] of Integer;
    PointColor      : array [0..MAXSERIES] of TColor;
    PointSize       : array [0..MAXSERIES] of Integer;
    TitleFontColor  : TColor;
    TitleFontName   : String;
    AxisFontName    : String;
    TitleFontSize   : Integer;
    AxisFontSize    : Integer;
    TitleFontBold   : Boolean;
    TitleFontItalic : Boolean;
    AxisFontBold    : Boolean;
    AxisFontItalic  : Boolean;
    AreaFillColor   : TColor;
    AreaFillStyle   : TBrushStyle;
    LabelsVisible   : Boolean;
    LabelsTransparent: Boolean;
    LabelsArrows    : Boolean;
    LabelsBackColor : TColor;
    DateTimeFormat  : String;
    AxisInverted    : Boolean;
  end;

//-----------------------------
// Profile Plot Display Options
//-----------------------------
  TProfileOptions = record
    ConduitColor       : TColor;
    WaterColor         : TColor;
    LabelsOnAxis       : Boolean;
    LabelsOnPlot       : Boolean;
    LabelsArrowLength  : Integer;
    LabelsFontSize     : Integer;
  end;

//-------------
// Report Item
//-------------
  TReportItem = record
    ObjType    : Integer;
    ObjName    : String;
    LegendTxt  : String;
    Variable   : Integer;
    Axis       : Integer;
  end;

//------------------------
// Report Selection Options
//------------------------
  TReportSelection = record
    ReportType     : Integer;
    XObjectType    : Integer;
    ObjectType     : Integer;
    StartDateIndex : LongInt;
    EndDateIndex   : LongInt;
    Items          : TStrings;
    Variables      : array[0..MAXCOLS] of Integer;
    ReportItems    : array[0..MAXCOLS] of TReportItem;
    ItemCount      : Integer;
    VariableCount  : Integer;
    DateTimeDisplay: Boolean;
  end;

//--------------------
// Printed Page Layout
//--------------------
  TPageLayout = record
    PaperSize    : TSinglePoint;
    LMargin      : Single;
    RMargin      : Single;
    TMargin      : Single;
    BMargin      : Single;
  end;

const

  DefGraphOptions: TGraphOptions =
    (View3D          : False;
     Percent3D       : 25;
     PanelColor      : clBtnFace;
     BackColor       : clWhite;
     BackGradColor   : clWhite;
     LegendPosition  : 2;
     LegendColor     : clWhite;
     LegendWidth     : 20;
     LegendTransparent: True;
     LegendFramed    : True;
     LegendVisible   : False;
     AxisGridStyle   : (1, 1, 0);
     AxisGridColor   : clGray;
     LineVisible     : (True, True, True, True, True, False);
     LineStyle       : (0, 0, 0, 0, 0, 0);
     LineColor       : (clRed, clBlue, clFuchsia, clGreen, clGray, clLime);
     LineWidth       : (2, 2, 2, 2, 2, 2);
     PointVisible    : (False, False, False, False, False, True);
     PointStyle      : (0, 0, 0, 0, 0, 0);
     PointColor      : (clRed, clBlue, clFuchsia, clGreen, clGray, clLime);
     PointSize       : (3, 3, 3, 3, 3, 3);
     TitleFontColor  : clBlue;
     TitleFontName   : 'Arial';
     AxisFontName    : 'Arial';
     TitleFontSize   : 12;
     AxisFontSize    : 8;
     TitleFontBold   : True;
     TitleFontItalic : False;
     AxisFontBold    : False;
     AxisFontItalic  : False;
     AreaFillColor   : clBlue;
     AreaFillStyle   : bsSolid;
     LabelsVisible   : True;
     LabelsTransparent: False;
     LabelsArrows    : False;
     LabelsBackColor : clYellow;
     DateTimeFormat  : '';
     AxisInverted    : False);


  DefProfileOptions: TProfileOptions =
    (ConduitColor       : clWhite;
     WaterColor         : clAqua;
     LabelsOnAxis       : True;
     LabelsOnPlot       : False;
     LabelsArrowLength  : 10;
     LabelsFontSize     : 8);

{$I viewvars.txt}  //File containing definitions of view variables

var

//--------------------
// Program preferences
//--------------------
  StyleName     : String;
  FontName      : String;
  LargeFonts    : Boolean;             // Dialogs use large fonts
  BoldFonts     : Boolean;             // Dialogs use bold fonts
  Blinking      : Boolean;             // Map hilighter blinks
  FlyOvers      : Boolean;             // Flyover map labels
  AutoBackup    : Boolean;             // Auto project file backup
  ConfirmDelete : Boolean;             // Confirm object deletions
  AutoLength    : Boolean;             // Automatically computes pipe length
  HasChanged    : Boolean;             // Records if changes made to data
  UpdateFlag    : Boolean;             // Records if data changed after a run
  TitleAsHeader : Boolean;             // Use project title as page header
  PageLayout    : TPageLayout;         // Printed page size & margins
  Orientation   : Integer;             // Page orientation
  MyFormatSettings: TFormatSettings;   // Special format settings for SWMM
  AutoSave      : Boolean;             // Auto saves results to disk
  RptElapsedTime: Boolean;             // Elapsed time is default for reporting
  TabDelimited  : Boolean;             // Tab separated fields in project file

//-----------------
// Project database
//-----------------
  Project           : TProject;        // Instance of Project object
  CurrentObject     : Integer;         // Current object category index
  CurrentList       : Integer;         // Current object list selected
  CurrentSubcatchVar: Integer;         // Subcatchment variable being viewed
  CurrentNodeVar    : Integer;         // Node variable being viewed
  CurrentLinkVar    : Integer;         // Link variable being viewed
  EditorObject      : Integer;         // Category of object being edited
  EditorIndex       : Integer;         // Index of object being edited
  UnitSystem        : TUnitSystem;     // System of units in use
  FlowUnits         : String;          // Flow units
  SubcatchUnits     : array [0..SUBCATCHVIEWS] of TVariableUnits;
  NodeUnits         : array [0..NODEVIEWS] of TVariableUnits;
  LinkUnits         : array [0..LINKVIEWS] of TVariableUnits;
  GraphOptions      : TGraphOptions;   // Actual graph options
  ProfileOptions    : TProfileOptions; // Actual profile plot options

//---------------
// File variables
//---------------
  HomeDir       : String;              // User's home directory
  EpaSwmmDir    : String;              // Executable directory
  WindowsDir    : String;              // Windows directory
  ProjectDir    : String;              // Project directory
  TempDir       : String;              // Temporary file directory
  IniFileDir    : String;              // Ini file directory
  InputFileName : String;              // Name of input data file
  InputFileType : TInputFileType;      // Type of input file
  TempInputFile : String;              // Name of temporary input file
  TempReportFile: String;              // Name of status report file
  TempOutputFile: String;              // Name of temporary output file
  ReadOnlyFlag  : Boolean;             // Input file read-only flag
  ResultsSaved  : Boolean;             // Output results saved flag

//-------------------
// Map view variables
//-------------------
  CurrentX        : Extended;          // Current map X-coordinate
  CurrentY        : Extended;          // Current map Y-coordinate
  MapBackColor    : array[1..MAXMAPCOLORINDEX] of TColor; // Background colors
  MapSubcatchColor: array [0..MAXINTERVALS] of TColor; // Subcatch colors
  MapNodeColor    : array [0..MAXINTERVALS] of TColor; // Node colors used
  MapLinkColor    : array [0..MAXINTERVALS] of TColor; // Link colors used
  SubcatchLegend  : array [0..SUBCATCHVIEWS] of TMapLegend;
  NodeLegend      : array [0..NODEVIEWS] of TMapLegend;
  LinkLegend      : array [0..LINKVIEWS] of TMapLegend;
  SubcatchLegendFrame: TLegendFrame;
  NodeLegendFrame : TLegendFrame;
  LinkLegendFrame : TLegendFrame;
  TimeLegendFrame : TLegendFrame;

//-----------------
// Analysis results
//-----------------
  Nsubcatchs    : Integer;             // Number of subcatchments
  Nnodes        : Integer;             // Number of nodes
  Nlinks        : Integer;             // Number of links
  Npolluts      : Integer;             // Number of pollutants
  NsysViews     : Integer;             // Number of system view variables
  Qunits        : Integer;             // Index of flow units
  Zsubcatch     : PSingleArray;        // Values of subcatch view variable
  Znode         : PSingleArray;        // Values of node view variable
  Zlink         : PSingleArray;        // Values of link view variable
  FlowDir       : PByteArray;          // Flow direction (+-) of each link
  RunFlag       : Boolean;             // Analysis ran OK (True/False)
  RunStatus     : TRunStatus;          // Current run status flag
  DynWaveFlag   : Boolean;             // Dynamic Wave routing used
  Nperiods      : LongInt;             // Total number of time periods
  CurrentPeriod : LongInt;             // Time period being viewed
  StartDateTime : TDateTime;           // Starting date/time
  EndDateTime   : TDateTime;           // Ending date/time
  DeltaDateTime : TDateTime;           // Reporting time step (in days)
  CurrentDateTime: TDateTime;          // Current date/time being viewed

//--------------------
// Map query variables
//--------------------
  QueryFlag     : Boolean;              // Query in progress flag
  QueryRelation : TRelationType;        // Query relation type
  QueryValue    : Single;               // Query value
  QueryColor    : TColor;               // Query color

//-----------------
// Calibration data
//-----------------
  CalibData: array [1..High(CalibVariables)] of TCalibData;

//------------------
// Global Procedures
//------------------
  procedure GetObjVarNames(const ObjType: Integer; const VarIndex: Integer;
            var ObjName: String; var VarName: String; var VarUnits: String);
  function  GetPeriod(const DateIndex: LongInt): LongInt;
  procedure RegisterCalibData;
  procedure SetDirectories;
  procedure SetMapBackColors;
  procedure SetFont(aForm: TForm);
  procedure SetFormatSettings;

implementation

procedure GetObjVarNames(const ObjType: Integer; const VarIndex: Integer;
  var ObjName: String; var VarName: String; var VarUnits: String);
//-----------------------------------------------------------------------------
//  Retrieves name of an object class and a variable in that class.
//-----------------------------------------------------------------------------
var
  K: Integer;
begin
  ObjName  := '';
  VarName  := '';
  VarUnits := '';
  if ObjType = SUBCATCHMENTS then
  begin
    ObjName := TXT_SUBCATCH;
    if (VarIndex >= SUBCATCHQUAL) then
    begin
      K := VarIndex - SUBCATCHQUAL;
      VarName := Project.PollutNames[K];
      VarUnits := Project.PollutUnits[K];
    end
    else
    begin
      VarName := SubcatchVariable[VarIndex].Name;
      VarUnits := SubcatchUnits[VarIndex].Units;
    end;
  end
  else if ObjType = NODES then
  begin
    ObjName := TXT_NODE;
    if (VarIndex >= NODEQUAL) then
    begin
      K := VarIndex - NODEQUAL;
      VarName := Project.PollutNames[K];
      VarUnits := Project.PollutUnits[K];
    end
    else
    begin
      VarName := NodeVariable[VarIndex].Name;
      VarUnits := NodeUnits[VarIndex].Units;
    end;
  end
  else if ObjType = LINKS then
  begin
    ObjName := TXT_LINK;
    if (VarIndex >= LINKQUAL) then
    begin
      K := VarIndex - LINKQUAL;
      VarName := Project.PollutNames[K];
      VarUnits := Project.PollutUnits[K];
    end
    else
    begin
      VarName := LinkVariable[VarIndex].Name;
      VarUnits := LinkUnits[VarIndex].Units;
    end;
  end
  else if ObjType = SYS then
  begin
    ObjName := TXT_SYS;
    VarName := SysViewNames[VarIndex];
    case VarIndex of
    SYS_TEMPERATURE: VarUnits := TempUnits[UnitSystem];
    SYS_RAINFALL:  VarUnits := BaseSubcatchUnits[RAINFALL, UnitSystem];
    SYS_SNOWDEPTH: VarUnits := BaseSubcatchUnits[SNOWDEPTH, UnitSystem];
    SYS_INFIL:     VarUnits := BaseSubcatchUnits[INFIL, UnitSystem];
    SYS_STORAGE:   VarUnits := BaseNodeUnits[VOLUME, UnitSystem];
    SYS_EVAP:      VarUnits := BaseSubcatchUnits[EVAP, UnitSystem];
    else           VarUnits := FlowUnits;
    end;
  end;
end;


function GetPeriod(const DateIndex: LongInt): LongInt;
//-----------------------------------------------------------------------------
//  Determines which reporting period of the simulation a
//  specific date index belongs to (where start day has index 0)
//-----------------------------------------------------------------------------
var
  N: LongInt;
  T: TDateTime;
begin
  if DeltaDateTime <= 0 then Result := 0
  else
  begin
    T := Floor(StartDateTime) + DateIndex;
    N := Floor((T - StartDateTime)/DeltaDateTime);
    if N < 0 then N := 0;
    if N >= Nperiods then N := Nperiods-1;
    Result := N;
  end;
end;


procedure RegisterCalibData;
//-----------------------------------------------------------------------------
//  Determines the locations where calibration data exist in the
//  project's calibration files.
//-----------------------------------------------------------------------------
var
  I        : Integer;
  Ntoks, P : Integer;
  Toklist  : TStringList;
  F        : TextFile;
  Line     : String;
  S        : String;
begin
  // Examine the calibration file for each type of calibration data
  for I := Low(CalibData) to High(CalibData) do
  begin
    with CalibData[I] do
    begin
      // Clear Locations list & check if file can be accessed
      Locations := '';
      if (Length(FileName) = 0) then continue;
      if FileExists(FileName) then
      begin
        AssignFile(F, FileName);
        {$I-}
        Reset(F);
        {$I+}
        if (IOResult = 0) then
        begin

          // Create token list and read each line of file
          Toklist := TStringList.Create;
          try
            while not EOF(F) do
            begin
              Readln(F,Line);
              S := Line;

              // Tokenize the line after stripping
              //off any comment which starts with ';'
              P := Pos(';',S);
              if (P > 0) then Delete(S, P, 256);
              Uutils.Tokenize(S, Toklist, Ntoks);

              // If line has 1 token, then it is a location ID.
              if (Ntoks = 1)
              then Locations := Locations + '"' + Toklist[0] + '"';
            end;
          finally
            Toklist.Free;
          end;
          CloseFile(F);
        end;
      end;
    end;
  end;
end;

procedure SetDirectories;
//-----------------------------------------------------------------------------
//  Identifies various file directories.
//-----------------------------------------------------------------------------
begin
  EpaSwmmDir := ExtractFilePath(Application.ExeName);
  HomeDir := Uutils.GetHomeDir;
  ProjectDir := HomeDir + 'My Documents\EPA SWMM Projects';
  if not DirectoryExists(ProjectDir)
  then ProjectDir := HomeDir;
  WindowsDir := Uutils.GetWindowsDir;
  Application.HelpFile := EpaSwmmDir + HLPFILE;
  TempDir := GetTempFolder;
  if TempDir = '' then TempDir := EpaSwmmDir;
  IniFileDir := Uutils.GetAppDataDir('EPASWMM', EpaSwmmDir);
  InputFileName := '';
end;

procedure SetFormatSettings;
//-----------------------------------------------------------------------------
//  Sets formats for numbers, dates and times.
//-----------------------------------------------------------------------------
begin
  Application.UpdateFormatSettings := false;
  MyFormatSettings.Create('en-US');
  MyFormatSettings.DecimalSeparator := '.';
  MyFormatSettings.DateSeparator := '/';
  MyFormatSettings.TimeSeparator := ':';
  MyFormatSettings.ShortDateFormat := 'mm' + '/' + 'dd' + '/' + 'yyyy';
  MyFormatSettings.LongTimeFormat := 'HH' + ':' + 'nn' + ':' + 'ss';
end;

procedure SetMapBackColors;
//-----------------------------------------------------------------------------
//  Sets choices of map background colors.
//-----------------------------------------------------------------------------
begin
  MapBackColor[1] := clWhite;
  MapBackColor[2] := RGB(255,255,225); //Yellow
  MapBackColor[3] := RGB(166,202,240); //Blue
  MapBackColor[4] := StyleServices.GetStyleColor(scPanel);
  MapBackColor[5] := clBlack;
  MapBackColor[6] := RGB(224,255,255); //Cyan
  MapBackColor[7] := RGB(204,255,204); //Green
  MapBackColor[8] := RGB(255,175,175); //Pink
  MapBackColor[9] := clWhite;
end;


procedure SetFont(aForm: TForm);
//-----------------------------------------------------------------------------
//  Sets the font to be used on form aForm.
//-----------------------------------------------------------------------------
//var
//  NonClientMetrics: TNonClientMetrics;
begin
{
  with aForm.Font do
  begin
    //Name := FontName;
    //Name := 'MS Sans Serif';
    //Name := 'Tahoma';
    if LargeFonts then Size := 10
    else Size := 8;
    if BoldFonts then Style := [fsBold]
    else Style := [];
  end;
}
  //aForm.Scaled := false;
  //if Screen.PixelsPerInch <> aForm.PixelsPerInch
  //then aForm.ScaleBy(Screen.PixelsPerInch, aForm.PixelsPerInch);
//  NonClientMetrics.cbSize := SizeOf(NonClientMetrics);
//  SystemParametersInfo(SPI_GETNONCLIENTMETRICS, 0, @NonClientMetrics, 0);
//  aForm.Font.Handle := CreateFontIndirect(NonClientMetrics.lfMessageFont);
end;

end.
