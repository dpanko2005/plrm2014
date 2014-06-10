unit PLRMStats;

interface

uses

  Windows, Messages, Dialogs, SysUtils, Variants, Classes, Uglobals, Uproject,
  Ustats, Math, GSTypes, GSNodes, GSCatchments;

function GetStatsSelection(var Stats: TStatsSelection; ObjID: String;
  ObjType: ShortInt; OutVar: Integer; StatsTypeIndex: Integer;
  TimePeriodIndex: Integer): Boolean;
procedure GetVariableTypes(var Stats: TStatsSelection);
procedure GetAllResults();
procedure reloadUserHydro();
function GetRainStats(): Double;

// plrm 2014 addition
function GetResultsForTopic(intTopic: Integer; reportFilePath: String)
  : PLRMGridData;
function GetSWTLoadResultsFromStatRpt(const tempNode: TPLRMNode;
  var perCap: Double; sourceTble: PLRMGridData; simLength: Double)
  : PLRMGridDataDbl;
function GetSWTVolResultsFromStatRpt(const tempNode: TPLRMNode;
  var perCap: Double; sourceTble: PLRMGridData; simLength: Double)
  : PLRMGridDataDbl;
function GetAveAnnualLoadsForJuncOrLink(JuncObjName: String;
  sourceTbl: PLRMGridData): PLRMGridData;

procedure GetHeaderLines(Topic: Integer);
function GetNewTopic(Line: String; Topic: Integer;
  TopicLabels: array of String): Integer;
procedure FindTopicsInReportFile;
procedure SetColHeaders(Topic: Integer);

implementation

uses
  Uoutput, GSPLRM, GSResults, GSUtils, StrUtils,
  // plrm 2014
  Fresults, Uutils;

const
  TXT_NO_AREA_SELECTED = 'Must select a subcatchment.';
  TXT_NO_NODE_SELECTED = 'Must select a node.';
  TXT_NO_LINK_SELECTED = 'Must select a link.';
  TXT_NO_OBJECT_SELECTED = 'No object was selected.';
  TXT_INVALID_DATES = 'End date comes before start date.';
  TXT_INVALID_PLOT_PARAM = 'Plotting parameter must be between 0 and 1.';

  BASICSTATS = 0;
  FLOWSTATS = 1;
  QUALSTATS = 2;
  NUMCATCHRSLTS = 7; // 2014 addition number of catch results
  NUMOUTFALLRSLTS = 7; // 2014 addition number of catch results
  CATCHTOTINFLCOLNUM = 6; // 2014 column number of tot infl vol in catch rslts

  StatsTypeText: array [0 .. 2] of PChar = ('Mean'#13'Peak',
    'Mean'#13'Peak'#13'Total'#13'Duration'#13'Inter-Event Time',
    'Mean Concen.'#13'Peak Concen.'#13'Mean Load'#13'Peak Load'#13'Total Load');

  TopicLabels: array [0 .. 13] of String = ('Subcatchment Runoff', // 0
    'LID Performance', // 1
    'Subcatchment Washoff', // 2
    'Node Depth', // 3
    'Node Inflow', // 4
    'Node Surcharge', // 5
    'Node Flooding', // 6
    'Storage Volume', // 7
    'Outfall Loading', // 8
    'Link Flow', // 9
    'Flow Classification', // 10
    'Conduit Surcharge', // 11
    'Pumping', // 12
    'Link Pollutant Load'); // 13
  TypeLabel: String = #10#10#10'Type';

var
  Topics: array [0 .. 13] of Integer;
  TopicStart: array [0 .. 13] of Integer;
  TopicSize: array [0 .. 13] of Integer;
  TopicHeaderLines: array [0 .. 13, 0 .. 3] of String;
  CopiedHeaders: array [0 .. 3] of String;
  ColHeaders: array of String;
  ColSorted: array of Integer;
  SortedCol: Integer;
  CurrentTopic: Integer;
  LineCount: Integer;
  UpdateCount: Boolean;
  F: TextFile;

function FindAllSWTs(SWTNum: Integer): TStringList;
var
  I: Integer;
begin
  PLRMObj.getSWTTypeNodes(SWTNum)
end;

function GetAveAnnualLoadsForJuncOrLink(JuncObjName: String;
  sourceTbl: PLRMGridData): PLRMGridData;
// This function calculates average annual loads for a juntion of name JuncObjName for
// all pollutants in the PollutNames list.
// JuncObjName - ID name of object being analyzed
var
  I, J: Integer;
  AnnualLoads: PLRMGridData; // String array containing loads for a single link
begin
  SetLength(AnnualLoads, Length(sourceTbl), Length(sourceTbl[0]));
  J := 0;
  for I := 0 to Length(sourceTbl) - 1 do
  begin
    if (Pos(JuncObjName, sourceTbl[I, 0]) = 1) then
    begin
      AnnualLoads[J] := sourceTbl[I];
      inc(J);
    end;
  end;
  SetLength(AnnualLoads, J, Length(sourceTbl[0]));
  result := AnnualLoads;
end;

function GetSWTVolResultsFromStatRpt(const tempNode: TPLRMNode;
  var perCap: Double; sourceTble: PLRMGridData; simLength: Double)
  : PLRMGridDataDbl;
var
  SWTs: TStringList;
  inJuncID: String; // Inflow junction name
  outJuncID: String; // Outflow junction name
  trJuncID: String; // Treated junction (downstream of treatment node)
  // Additional Treated junction (e.g. for surcharge)
  tr2JuncID: String;
  // Additional Treated junction (e.g. for permanent pool basin for wet basins)
  tr3JuncID: String;

  // String list containing pollutant loads for a single junction
  AnnLoads, AnnLoads2, AnnLoads3, AnnLoads4: PLRMGridData;

  // 2-d array of loads for all junctions associated w/ SWTName
  SWTLoads: PLRMGridDataDbl;

  tempInt, I: Integer;
  L: TLink;
begin
  inJuncID := tempNode.userName + '_InJu';
  outJuncID := tempNode.userName + '_OuJu';
  trJuncID := tempNode.userName + '_TrJu';
  tr2JuncID := tempNode.userName + '_SurTrJu';
  tr3JuncID := tempNode.userName + '_WetTrJu';

  AnnLoads := GetAveAnnualLoadsForJuncOrLink(inJuncID, sourceTble);
  SetLength(SWTLoads, Length(AnnLoads), 6);

  // row-0 Get annual influent loads
  AnnLoads := GetAveAnnualLoadsForJuncOrLink(inJuncID, sourceTble);
  if (Assigned(AnnLoads)) then
    for I := 0 to Length(AnnLoads) - 1 do
      SWTLoads[I, 0] := StrToFloat(AnnLoads[I, 7]) / simLength;

  // row-2 Get annual bypass loads
  AnnLoads := GetAveAnnualLoadsForJuncOrLink(trJuncID, sourceTble);
  if (Assigned(AnnLoads)) then
    for I := 0 to Length(AnnLoads) - 1 do
      SWTLoads[I, 2] := StrToFloat(AnnLoads[I, 7]) / simLength;

  // row-3 Get annual treated loads
  // AnnLoads:= Nil;
  AnnLoads := GetAveAnnualLoadsForJuncOrLink(outJuncID, sourceTble);
  if (Assigned(AnnLoads)) then
    for I := 0 to Length(AnnLoads) - 1 do
      SWTLoads[I, 3] := StrToFloat(AnnLoads[I, 7]) / simLength;

  // row-4 Get annual effluent loads
  // AnnLoads:= Nil;
  // AnnLoads2:= Nil;
  AnnLoads := GetAveAnnualLoadsForJuncOrLink(inJuncID, sourceTble);
  AnnLoads2 := GetAveAnnualLoadsForJuncOrLink(outJuncID, sourceTble);
  if (Assigned(AnnLoads) and Assigned(AnnLoads2)) then
    for I := 0 to Length(AnnLoads) - 1 do
      SWTLoads[I, 4] := (StrToFloat(AnnLoads[I, 7]) - StrToFloat(AnnLoads2[I, 7]
        )) / simLength;

  // row-5 Get annual %change in loads
  for I := 0 to Length(AnnLoads) - 1 do
    SWTLoads[I, 5] := (SWTLoads[I, 0] - SWTLoads[I, 3]) / SWTLoads[I, 0];

  case tempNode.SWTType of
    1, 4, 5, 6:
      // Detention, Bed Filter,Cartridge Filter bed, Hydrodynamic device
      begin
        // AnnLoads:= Nil;
        // AnnLoads2:= Nil;
        AnnLoads := GetAveAnnualLoadsForJuncOrLink(outJuncID, sourceTble);
        AnnLoads2 := GetAveAnnualLoadsForJuncOrLink(trJuncID, sourceTble);
        // row-0 same as for others see above before case stmnt
        // row-1 Get annual bypass loads
        if (Assigned(AnnLoads) and Assigned(AnnLoads2)) then
          for I := 0 to Length(AnnLoads) - 1 do
            SWTLoads[I, 1] :=
              (StrToFloat(AnnLoads[I, 7]) - StrToFloat(AnnLoads2[I, 7])) /
              simLength;
        // row-2,3,4 default see above before case stmnt
      end;

    2: // Infiltration
      begin
        // AnnLoads:= Nil;
        // AnnLoads2:= Nil;
        AnnLoads := GetAveAnnualLoadsForJuncOrLink(outJuncID, sourceTble);
        AnnLoads2 := GetAveAnnualLoadsForJuncOrLink(inJuncID, sourceTble);
        // row-0 same as for others see above before case stmnt
        // row-1 Get annual bypass loads
        if (Assigned(AnnLoads) and Assigned(AnnLoads2)) then
          for I := 0 to Length(AnnLoads) - 1 do
            SWTLoads[I, 1] :=
              (StrToFloat(AnnLoads[I, 7]) - StrToFloat(AnnLoads2[I, 7])) /
              simLength;
        // row-2 annual treated loads = 0.0
        for I := 0 to Length(AnnLoads) - 1 do
          SWTLoads[I, 2] := 0.0;
        // row-3,4 default see above before case stmnt
      end;
    3: // WetBasin
      begin
        // resets
        // SetLength(AnnLoads,0,0);
        // AnnLoads:= Nil;
        // AnnLoads2:= Nil;
        // AnnLoads3:= Nil;

        AnnLoads2 := GetAveAnnualLoadsForJuncOrLink(tr2JuncID, sourceTble);
        AnnLoads3 := GetAveAnnualLoadsForJuncOrLink(tr3JuncID, sourceTble);
        AnnLoads4 := GetAveAnnualLoadsForJuncOrLink(outJuncID, sourceTble);

        // row-0 same as for others see above before case stmnt
        // row-1 Get annual bypass loads
        if (Assigned(AnnLoads) and Assigned(AnnLoads2) and Assigned(AnnLoads3))
        then
          for I := 0 to Length(AnnLoads4) - 1 do
            SWTLoads[I, 1] :=
              (StrToFloat(AnnLoads4[I, 7]) - StrToFloat(AnnLoads2[I, 7]) -
              StrToFloat(AnnLoads3[I, 7])) / simLength;
        // row-2 annual treated loads = 0.0
        if (Assigned(AnnLoads) and Assigned(AnnLoads2) and Assigned(AnnLoads3))
        then
          for I := 0 to Length(AnnLoads4) - 1 do
            SWTLoads[I, 2] :=
              (StrToFloat(AnnLoads2[I, 7]) + StrToFloat(AnnLoads3[I, 7])) /
              simLength;
        // row-3,4 default see above before case stmnt
      end;
  end;

  if (SWTLoads[0, 0] = 0) then
    perCap := 0
  else
    perCap := (1 - (SWTLoads[0, 1] / SWTLoads[0, 0])) * 100;

  AnnLoads := nil;
  AnnLoads2 := nil;
  AnnLoads3 := nil;
  AnnLoads4 := nil;

  result := SWTLoads;
end;

function GetSWTLoadResultsFromStatRpt(const tempNode: TPLRMNode;
  var perCap: Double; sourceTble: PLRMGridData; simLength: Double)
  : PLRMGridDataDbl;
var
  SWTs: TStringList;
  InLinkID: String; // Inflow link name
  ByLinkID: String; // Bypass link name
  TrLinkID: String; // Treated link (downstream of treatment node)
  // Treated link from permanent pool basin for wet basins
  Tr2LinkID, DsLinkID: String;
  // String list containing pollutant loads for a single link
  AnnLoads: PLRMGridData;
  AnnLoads2: PLRMGridData;
  // 2-d array of loads for all links associated w/ SWTName
  SWTLoads: PLRMGridDataDbl;

  tempInt, I: Integer;
  L: TLink;

begin
  InLinkID := tempNode.userName + '_InCo';
  ByLinkID := tempNode.userName + '_ByWe';
  TrLinkID := tempNode.userName + '_OtCo';
  DsLinkID := tempNode.userName + '_DsCo';
  AnnLoads := GetAveAnnualLoadsForJuncOrLink(InLinkID, sourceTble);

  // StringList of annual loads for Link
  // tempInt := AnnLoads.Count;
  SetLength(SWTLoads, Length(AnnLoads[0]), 6);

  // column-0 Get annual influent loads for links
  AnnLoads := GetAveAnnualLoadsForJuncOrLink(InLinkID, sourceTble);
  if (Assigned(AnnLoads)) then
    for I := 1 to Length(AnnLoads[0]) - 1 do
      SWTLoads[I, 0] := StrToFloat(AnnLoads[0, I]) / simLength;

  // column-1 Get annual bypassed loads for links
  AnnLoads := GetAveAnnualLoadsForJuncOrLink(ByLinkID, sourceTble);
  if (Assigned(AnnLoads)) then
    for I := 1 to Length(AnnLoads[0]) - 1 do
      SWTLoads[I, 1] := StrToFloat(AnnLoads[0, I]) / simLength;

  // column-3 Get annual effluent loads for links
  AnnLoads := GetAveAnnualLoadsForJuncOrLink(DsLinkID, sourceTble);
  if (Assigned(AnnLoads)) then
    for I := 1 to Length(AnnLoads[0]) - 1 do
      SWTLoads[I, 3] := StrToFloat(AnnLoads[0, I]) / simLength;

  // column-4 Get annual removed loads for links
  for I := 1 to Length(AnnLoads[0]) - 1 do
    SWTLoads[I, 4] := (SWTLoads[I, 0] - SWTLoads[I, 3]) / simLength;

  // column-5 Get annual removed loads for links
  for I := 1 to Length(AnnLoads[0]) - 1 do
    SWTLoads[I, 5] := (SWTLoads[I, 4] / SWTLoads[I, 0]) / simLength;

  case tempNode.SWTType of
    1, 4, 5, 6: // Dry Detention Basin, Bed Filter,
      begin
        // column-2 Get annual bypassed loads for links
        AnnLoads := GetAveAnnualLoadsForJuncOrLink(TrLinkID, sourceTble);
        if (Assigned(AnnLoads)) then
          for I := 1 to Length(AnnLoads[0]) - 1 do
            SWTLoads[I, 2] := StrToFloat(AnnLoads[0, I]) / simLength;
      end;

    2: // Infiltration
      begin
        for I := 1 to Length(AnnLoads) - 1 do
          SWTLoads[I, 4] := 0.0;
      end;
    3: // WetBasin
      begin
        InLinkID := tempNode.userName + '_InCo';
        ByLinkID := tempNode.userName + '_SurByWe'; // surcharge bypass outlet
        TrLinkID := tempNode.userName + '_SurOtCo'; // surcharge treated outlet
        Tr2LinkID := tempNode.userName + '_WetOtCo';

        AnnLoads := GetAveAnnualLoadsForJuncOrLink(TrLinkID, sourceTble);
        AnnLoads2 := GetAveAnnualLoadsForJuncOrLink(Tr2LinkID, sourceTble);
        if (Assigned(AnnLoads) and Assigned(AnnLoads2)) then
          for I := 1 to Length(AnnLoads[0]) - 1 do
            SWTLoads[I, 2] :=
              (StrToFloat(AnnLoads[0, I]) - StrToFloat(AnnLoads2[0, I])) /
              simLength;
      end;
  end;

  if SWTLoads[0, 0] = 0 then
    perCap := 0
  else
    perCap := (1 - (SWTLoads[0, 1] / SWTLoads[0, 0])) * 100;
  result := SWTLoads;
end;

function GetStatsSelection(var Stats: TStatsSelection; ObjID: String;
  ObjType: ShortInt; OutVar: Integer; StatsTypeIndex: Integer;
  TimePeriodIndex: Integer): Boolean;
// -----------------------------------------------------------------------------
// Places user's selections into a TStatsSelection data structure
// -----------------------------------------------------------------------------
begin
  result := False;
  with Stats do
  begin
    ObjectType := ObjType;
    Variable := OutVar;
    MinEventDelta := 6;
    MinEventVolume := 0;
    MinEventValue := 0;
    ObjectID := ObjID;
    TimePeriod := TTimePeriod(TimePeriodIndex);
    StatsType := TStatsType(StatsTypeIndex);
    PlotParameter := 0;
    PlotPosition := TPlotPosition(0); // ppFrequency;
    IsQualParam := TRUE;
    IsRainParam := False;
    if PlotParameter > 1 then
      MessageDlg(TXT_INVALID_PLOT_PARAM, mtError, [mbOK], 0)
    else if (ObjectType <> SYS) and
      (Uoutput.GetObject(ObjectType, ObjectID) = nil) then
      MessageDlg(TXT_NO_OBJECT_SELECTED, mtError, [mbOK], 0)
    else
      result := TRUE;

  end;
  if result = TRUE then
    GetVariableTypes(Stats);
end;

procedure GetVariableTypes(var Stats: TStatsSelection);
// -----------------------------------------------------------------------------
// Determines if the variable being analyzed is rainfall, losses, or quality.
// -----------------------------------------------------------------------------
begin
  Stats.IsQualParam := False;
  Stats.IsRainParam := False;
  Stats.VarIndex := Uoutput.GetVarIndex(Stats.Variable, Stats.ObjectType);
  Stats.FlowVarIndex := -1;
  case Stats.ObjectType of

    SUBCATCHMENTS:
      begin
        if Stats.Variable >= SUBCATCHQUAL then
          Stats.IsQualParam := TRUE
        else
        begin
          if (Stats.Variable = RAINFALL)
          // plrm 2014 no LOSSES in v5.1 or (Stats.Variable = LOSSES)
          then
            Stats.IsRainParam := TRUE;
        end;
        if Stats.IsQualParam then
          Stats.FlowVarIndex := Uoutput.GetVarIndex(RUNOFF, SUBCATCHMENTS)
        else
          Stats.FlowVarIndex := Stats.VarIndex;
      end;

    NODES:
      begin
        if Stats.Variable >= NODEQUAL then
          Stats.IsQualParam := TRUE;
        if Stats.Variable = INFLOW then
          Stats.FlowVarIndex := Uoutput.GetVarIndex(INFLOW, NODES);
        if Stats.Variable = OVERFLOW then
          Stats.FlowVarIndex := Uoutput.GetVarIndex(OVERFLOW, NODES);
      end;

    LINKS:
      begin
        if Stats.Variable >= LINKQUAL then
          Stats.IsQualParam := TRUE;
        Stats.FlowVarIndex := Uoutput.GetVarIndex(FLOW, LINKS);
      end;

    SYS:
      begin
        if (Stats.Variable = SYS_RAINFALL)
        // plrm 2014 no lossed in v5.1 or (Stats.Variable = SYS_LOSSES)
        then
          Stats.IsRainParam := TRUE;
        Stats.FlowVarIndex := Stats.VarIndex;
      end;
  end;
end;

function GetRainStats(): Double; // total average annual rainfall in inches
var
  VolSum: Double; // cummulative inches of rainfall
  AnnualVol: Double; // total average annual rainfall volume in inches
  Stats: TStatsSelection; // Information on what to analyze
  PeriodIndex: Integer;
  StatsIndex: Integer;
  EventList: TList; // List of all events
  AnalysisResults: TStatsResults; // Analysis results
  VarNumber: Integer;
  VarUnits: String; // Units for variable
  E: PStatsEvent; // Pointer to a TStatsEvent object
  I, J: Integer;
begin
  PeriodIndex := 1; // 0-tpVariable, 1-tpDaily, 2-tpMonthly, 3-tpAnnual

  // Create lists
  EventList := TList.Create;

  // Get Average Annual Volumes
  VarNumber := SYS_RAINFALL; // rainfall
  StatsIndex := 2; // 0-stMean, 1-stPeak, 2-stTotal, 3-stDuration, 4-stDelta,
  // 5-stMeanConcen, 6-stPeakConcen, 7-stMeanLoad, 9-stPeakLoad,
  // 9-stTotalLoad)
  if GetStatsSelection(Stats, '', SYS, VarNumber, StatsIndex, PeriodIndex) then
  begin
    GetStats(Stats, EventList, AnalysisResults);
    VolSum := 0;
    for I := 0 to EventList.Count - 1 do
    begin
      E := EventList.Items[I];
      VolSum := VolSum + E^.Value;
    end;
    EventList.Clear;
    AnnualVol := VolSum / ((EndDateTime - StartDateTime) / 365.2422);

  end
  else
    ShowMessage('Problem Getting Stats Selection!');

  GetRainStats := AnnualVol;
end;

// begin plrm 2014 additions from Fresult
// adapted from TResultsForm.GetHeaderLines
procedure GetHeaderLines(Topic: Integer);
// -----------------------------------------------------------------------------
// Saves the lines from the SWMM report file that constitute the
// column headings for the current report topic.
// Headings have following format:
// Separator Line (-----)
// Heading Line 1
// . . .
// Separator Line (------)
// -----------------------------------------------------------------------------
var
  Line: String;
  I: Integer;
begin
  // Turn off updating of topic size
  UpdateCount := False;
  I := 0;

  // Skip next two lines after topic title
  Readln(F, Line);
  inc(LineCount);
  Readln(F, Line);
  inc(LineCount);

  // Exit if start of header section not found within next 2 lines
  Readln(F, Line);
  inc(LineCount);
  if not AnsiStartsStr('  -', Line) then
  begin
    Readln(F, Line);
    inc(LineCount);
    if not AnsiStartsStr('  -', Line) then
      Exit;
  end;

  // Keep reading header lines until last header line found
  // (Headers can't have more than 4 lines of text)
  while (I <= 4) do
  begin
    Readln(F, Line);
    inc(LineCount);

    // Last line of header section found
    if AnsiStartsStr('  -', Line) then
    begin
      // Make topic start here
      TopicStart[Topic] := LineCount;
      UpdateCount := TRUE;
      break;
    end

    // Otherwise copy line to topic's header
    else if I < 4 then
    begin
      TopicHeaderLines[Topic][I] := Line;
      inc(I);
    end;
  end;
end;

// adapted from TResultsForm.FindTopicsInReportFile
procedure FindTopicsInReportFile;
// -----------------------------------------------------------------------------
// Finds the starting line and number of lines for each topic contained
// in the SWMM report file.
// -----------------------------------------------------------------------------
var
  K: Integer;
  Line: String;
  Topic: Integer;
begin
  // Open SWMM's report file
  if FileExists(TempReportFile) then
  begin
    AssignFile(F, TempReportFile);

    // Initialize line count and current topic
    LineCount := 0;
    Topic := -1;

    // Turn off updating of topic's size
    UpdateCount := False;

    // Read each line of file
    try
      Reset(F);
      while not Eof(F) do
      begin
        Readln(F, Line);
        inc(LineCount);

        // Check if current line starts a new report topic
        K := GetNewTopic(Line, Topic, TopicLabels);

        // New topic found -- parse its header lines
        if K >= 0 then
        begin
          Topic := K;
          GetHeaderLines(Topic);
        end

        // Otherwise, if still updating size of current topic
        else if (Topic >= 0) and UpdateCount then
        begin

          // Line not blank nor end of current topic -
          // add to size of current topic
          Line := Trim(Line);
          if (Length(Line) > 0) and not(AnsiStartsStr('-', Line)) then
            inc(TopicSize[Topic])

            // Otherwise at end of current topic -- stop updating its size
          else
          begin
            UpdateCount := False;
          end;
        end;
      end;

      // Close report file
    finally
      CloseFile(F);
    end;
  end;
end;

// adapted from TResultsForm.GetNewTopic
function GetNewTopic(Line: String; Topic: Integer;
  TopicLabels: array of String): Integer;
// -----------------------------------------------------------------------------
// Checks if current line from SWMM report file starts a new topic.
// -----------------------------------------------------------------------------
var
  I: Integer;
begin
  result := -1;
  for I := Topic + 1 to High(TopicLabels) do
  begin
    if ContainsText(Line, TopicLabels[I] + ' Summary') then
    begin
      result := I;
      break;
    end;
  end;
end;

// adapted from native swmm fxn  TResultsForm.RefreshTopic to read results into data structure rather than grid
function GetResultsForTopic(intTopic: Integer; reportFilePath: String)
  : PLRMGridData;
// -----------------------------------------------------------------------------
// Gets summary results for the specified topic.
// -----------------------------------------------------------------------------
var
  I, J, intTopicNumber, N: Integer;
  Line: String;
  Caption: String;
  Tokens: TStringList;
  arrResults: PLRMGridData;
begin

  // Convert from index of available topics to absolute topic index
  intTopicNumber := intTopic;

  // set columns to arbitrarily long number and trim later
  SetLength(arrResults, TopicSize[intTopicNumber], 20);

  // Provide a minimum size grid for topics with no results
  if TopicSize[intTopicNumber] = 0 then
  begin
    SetLength(arrResults, 1, 1);
  end

  // Otherwise open the SWMM report file
  else if FileExists(reportFilePath) then
  begin

    // Open the SWMM report file
    Tokens := TStringList.Create;
    AssignFile(F, reportFilePath);
    try
      Reset(F);

      // Move file to start of current topic's report
      for I := 1 to TopicStart[intTopicNumber] do
        Readln(F, Line);

      // Tokenize each line of topic's results and insert into grid
      for I := 0 to TopicSize[intTopicNumber] - 1 do
      begin
        Readln(F, Line);
        Uutils.Tokenize(Line, Tokens, N);
        for J := 0 to N - 1 do
          arrResults[I, J] := Tokens[J];
      end;
      // Redim array to match data size
      SetLength(arrResults, TopicSize[intTopicNumber], N);

      // Close SWMM report file
    finally
      Tokens.Free;
      CloseFile(F);
    end;
  end;
  result := arrResults;
end;

procedure SetColHeaders(Topic: Integer);
// -----------------------------------------------------------------------------
// Forms the multi-line column headers that appear in the grid table
// for a specific report topic.
// -----------------------------------------------------------------------------
var
  I, N: Integer;
  Tokens: TStringList;
  Units1, Units2, Units3, Text1: String;
begin
  case Topic of
    0: // Subcatchment Runoff (3 lines with 9 cols)
      begin
        // Get units appearing on 3rd header line
        Units1 := Copy(TopicHeaderLines[Topic][2], 32, 2);
        Units2 := Copy(TopicHeaderLines[Topic][2], 81, 9);
        Units3 := Copy(TopicHeaderLines[Topic][2], 95, 4);

        // Build up each column heading
        SetLength(ColHeaders, 9);
        ColHeaders[0] := #10#10#10'Subcatchment';
        ColHeaders[1] := #10'Total'#10'Precip'#10 + Units1;
        ColHeaders[2] := #10'Total'#10'Runon'#10 + Units1;
        ColHeaders[3] := #10'Total'#10'Evap'#10 + Units1;
        ColHeaders[4] := #10'Total'#10'Infil'#10 + Units1;
        ColHeaders[5] := #10'Total'#10'Runoff'#10 + Units1;
        ColHeaders[6] := #10'Total'#10'Runoff'#10 + Units2;
        ColHeaders[7] := #10'Peak'#10'Runoff'#10 + Units3;
        ColHeaders[8] := #10#10'Runoff'#10'Coeff';
        CopiedHeaders[0] := Format('%-16s', [' ']);
      end;

    1: // LID Performance
      begin
        Units1 := Trim(Copy(TopicHeaderLines[Topic][2], 44, 3));
        SetLength(ColHeaders, 10);
        ColHeaders[0] := #10#10#10'Subcatchment';
        ColHeaders[1] := #10#10#10'LID Control';
        ColHeaders[2] := #10'Total'#10'Inflow'#10 + Units1;
        ColHeaders[3] := #10'Evap'#10'Loss'#10 + Units1;
        ColHeaders[4] := #10'Infil'#10'Loss'#10 + Units1;
        ColHeaders[5] := #10'Surface'#10'Outflow'#10 + Units1;
        ColHeaders[6] := #10'Drain'#10'Outflow'#10 + Units1;
        ColHeaders[7] := #10'Initial'#10'Storage'#10 + Units1;
        ColHeaders[8] := #10'Final'#10'Storage'#10 + Units1;
        ColHeaders[9] := #10#10'Percent'#10'Error';
      end;

    2: // Washoff Loads
      begin
        Tokens := TStringList.Create;
        try
          // Tokenize header with pollutant names
          Uutils.Tokenize(TopicHeaderLines[Topic][0], Tokens, N);

          // Set number of header columns to number of pollutant names
          // + one column for subcatchment name
          SetLength(ColHeaders, N + 1);

          // Fill in first line of grid column headers
          ColHeaders[0] := #10#10#10;
          for I := 0 to N - 1 do
            ColHeaders[I + 1] := #10#10 + Tokens[I] + #10;

          // Fill in second line of column headers (with mass units)
          Uutils.Tokenize(TopicHeaderLines[Topic][1], Tokens, N);
          for I := 0 to N - 1 do
            ColHeaders[I] := ColHeaders[I] + Tokens[I];
        finally
          Tokens.Free;
        end;
      end;

    3: // Node Depth
      begin
        Units1 := Trim(Copy(TopicHeaderLines[Topic][2], 35, 6));
        SetLength(ColHeaders, 7);
        ColHeaders[0] := #10#10#10'Node';
        ColHeaders[1] := TypeLabel;
        ColHeaders[2] := #10'Average'#10'Depth'#10 + Units1;
        ColHeaders[3] := #10'Maximum'#10'Depth'#10 + Units1;
        ColHeaders[4] := #10'Maximum'#10'HGL'#10 + Units1;
        ColHeaders[5] := #10'Day of'#10'Maximum'#10'Depth';
        ColHeaders[6] := #10'Hour of'#10'Maximum'#10'Depth';
      end;

    4: // Node Inflows
      begin
        Units1 := Trim(Copy(TopicHeaderLines[Topic][3], 38, 4));
        Units2 := Trim(Copy(TopicHeaderLines[Topic][3], 68, 8));
        SetLength(ColHeaders, 9);
        ColHeaders[0] := #10#10#10'Node';
        ColHeaders[1] := TypeLabel;
        ColHeaders[2] := 'Maximum'#10'Lateral'#10'Inflow'#10 + Units1;
        ColHeaders[3] := 'Maximum'#10'Total'#10'Inflow'#10 + Units1;
        ColHeaders[4] := #10'Day of'#10'Maximum'#10'Inflow';
        ColHeaders[5] := #10'Hour of'#10'Maximum'#10'Inflow';
        ColHeaders[6] := 'Lateral'#10'Inflow'#10'Volume'#10 + Units2;
        ColHeaders[7] := 'Total'#10'Inflow'#10'Volume'#10 + Units2;
        ColHeaders[8] := 'Flow'#10'Balance'#10'Error'#10'Percent';
      end;

    5: // Node Surcharge
      begin
        Units1 := Trim(Copy(TopicHeaderLines[Topic][2], 53, 6));
        SetLength(ColHeaders, 5);
        ColHeaders[0] := #10#10#10'Node';
        ColHeaders[1] := TypeLabel;
        ColHeaders[2] := #10#10'Hours'#10'Surcharged';
        ColHeaders[3] := 'Max Height'#10'Above'#10'Crown'#10 + Units1;
        ColHeaders[4] := 'Min Depth'#10'Below'#10'Rim'#10 + Units1;
      end;

    6: // Node Flooding
      begin
        Units1 := Trim(Copy(TopicHeaderLines[Topic][3], 38, 4));
        Units2 := Trim(Copy(TopicHeaderLines[Topic][3], 59, 9));
        Units3 := Trim(Copy(TopicHeaderLines[Topic][3], 69, 9));
        Text1 := Trim(AnsiRightStr(TopicHeaderLines[Topic][2], 7));
        SetLength(ColHeaders, 7);
        ColHeaders[0] := #10#10#10'Node';
        ColHeaders[1] := #10#10'Hours'#10'Flooded';
        ColHeaders[2] := #10'Maximum'#10'Rate'#10 + Units1;
        ColHeaders[3] := #10'Day of'#10'Maximum'#10'Flooding';
        ColHeaders[4] := #10'Hour of'#10'Maximum'#10'Flooding';
        ColHeaders[5] := 'Total'#10'Flood'#10'Volume'#10 + Units2;
        ColHeaders[6] := 'Maximum'#10'Ponded'#10 + Text1 + #10 + Units3;
      end;

    7: // Storage Volume
      begin
        Units1 := Trim(Copy(TopicHeaderLines[Topic][2], 25, 9));
        Units2 := Trim(Copy(TopicHeaderLines[Topic][2], 98, 4));
        SetLength(ColHeaders, 10);
        ColHeaders[0] := #10#10'Storage'#10'Unit';
        ColHeaders[1] := #10'Average'#10'Volume'#10 + Units1;
        ColHeaders[2] := #10'Average'#10'Percent'#10'Full';
        ColHeaders[3] := #10'Evap'#10'Percent'#10'Loss';
        ColHeaders[4] := #10'Infil'#10'Percent'#10'Loss';
        ColHeaders[5] := #10'Maximum'#10'Volume'#10 + Units1;
        ColHeaders[6] := #10'Maximum'#10'Percent'#10'Full';
        ColHeaders[7] := #10'Day of'#10'Maximum'#10'Volume';
        ColHeaders[8] := #10'Hour of'#10'Maximum'#10'Volume';
        ColHeaders[9] := #10'Maximum'#10'Outflow'#10 + Units2;
      end;

    8: // Outfall Loading
      begin
        Tokens := TStringList.Create;
        try
          // Tokenize header with pollutant names
          Uutils.Tokenize(TopicHeaderLines[Topic][1], Tokens, N);

          // Set number of header columns to number of tokens found
          // + one column for outfall name
          SetLength(ColHeaders, N + 1);

          // Parse flow and volume units from 3rd header line
          Units1 := Trim(Copy(TopicHeaderLines[Topic][2], 36, 4));
          Units2 := Trim(Copy(TopicHeaderLines[Topic][2], 54, 9));

          // Set headers for non-pollutant columns
          ColHeaders[0] := #10#10#10'Outfall Node';
          ColHeaders[1] := #10'Flow'#10'Freq.'#10'Pcnt.';
          ColHeaders[2] := #10'Avg.'#10'Flow'#10 + Units1;
          ColHeaders[3] := #10'Max.'#10'Flow'#10 + Units1;
          ColHeaders[4] := #10'Total'#10'Volume'#10 + Units2;

          if N > 5 then
          begin
            // Add pollutant names to column headers
            for I := 5 to N do
              ColHeaders[I] := #10'Total'#10 + Tokens[I - 1] + #10;

            // Trim non-pollutant units text from last header line
            Text1 := AnsiMidStr(TopicHeaderLines[Topic][2], 63,
              Length(TopicHeaderLines[Topic][2]));

            // Tokenize the pollutant units from this text
            Uutils.Tokenize(Text1, Tokens, N);

            // Add the pollutant units to the column headers
            for I := 0 to N - 1 do
              ColHeaders[I + 5] := ColHeaders[I + 5] + Tokens[I];
          end;
        finally
          Tokens.Free;
        end;
      end;

    9: // Link Flow
      begin
        Units1 := Trim(Copy(TopicHeaderLines[Topic][2], 38, 4));
        Units2 := Trim(Copy(TopicHeaderLines[Topic][2], 58, 6));
        SetLength(ColHeaders, 8);
        ColHeaders[0] := #10#10#10'Link';
        ColHeaders[1] := TypeLabel;
        ColHeaders[2] := #10'Maximum'#10'|Flow|'#10 + Units1;
        ColHeaders[3] := #10'Day of'#10'Maximum'#10'Flow';
        ColHeaders[4] := #10'Hour of'#10'Maximum'#10'Flow';
        ColHeaders[5] := #10'Maximum'#10'|Velocity|'#10 + Units2;
        ColHeaders[6] := #10'Max /'#10'Full'#10'Flow';
        ColHeaders[7] := #10'Max /'#10'Full'#10'Depth';
      end;

    10: // Flow Classification
      begin
        SetLength(ColHeaders, 11);
        ColHeaders[0] := #10#10#10'Conduit';
        ColHeaders[1] := #10'Adjusted/'#10'Actual'#10'Length';
        ColHeaders[2] := #10#10'Fully'#10'Dry';
        ColHeaders[3] := #10#10'Upstrm'#10'Dry';
        ColHeaders[4] := #10#10'Dnstrm'#10'Dry';
        ColHeaders[5] := #10#10'Sub'#10'Critical';
        ColHeaders[6] := #10#10'Super'#10'Critical';
        ColHeaders[7] := #10#10'Upstrm'#10'Critical';
        ColHeaders[8] := #10#10'Dnstrm'#10'Critical';
        ColHeaders[9] := #10'Normal'#10'Flow'#10'Limited';
        ColHeaders[10] := #10#10'Inlet'#10'Control';
      end;

    11: // Conduit Surcharge
      begin
        SetLength(ColHeaders, 6);
        ColHeaders[0] := #10#10#10'Conduit';
        ColHeaders[1] := #10'Hours'#10'Both Ends'#10'Full';
        ColHeaders[2] := #10'Hours'#10'Upstream'#10'Full';
        ColHeaders[3] := #10'Hours'#10'Dnstream'#10'Full';
        ColHeaders[4] := 'Hours'#10'Above'#10'Normal'#10'Flow';
        ColHeaders[5] := #10'Hours'#10'Capacity'#10'Limited';
      end;

    12: // Pumping
      begin
        Units1 := Trim(Copy(TopicHeaderLines[Topic][2], 51, 4));
        Units2 := Trim(Copy(TopicHeaderLines[Topic][2], 76, 9));
        Units3 := Trim(Copy(TopicHeaderLines[Topic][2], 89, 6));
        SetLength(ColHeaders, 10);
        ColHeaders[0] := #10#10#10'Pump';
        ColHeaders[1] := #10#10'Percent'#10'Utilized';
        ColHeaders[2] := #10#10'Number of'#10'Start-Ups';
        ColHeaders[3] := #10'Minimum'#10'Flow'#10 + Units1;
        ColHeaders[4] := #10'Average'#10'Flow'#10 + Units1;
        ColHeaders[5] := #10'Maximum'#10'Flow'#10 + Units1;
        ColHeaders[6] := #10'Total'#10'Volume'#10 + Units2;
        ColHeaders[7] := #10'Power'#10'Usage'#10 + Units3;
        ColHeaders[8] := '% Time'#10'Below'#10'Pump'#10'Curve';
        ColHeaders[9] := '% Time'#10'Above'#10'Pump'#10'Curve';
      end;

    13: // Link Loadings
      begin
        Tokens := TStringList.Create;
        try
          // Tokenize header with pollutant names
          Uutils.Tokenize(TopicHeaderLines[Topic][0], Tokens, N);

          // Set number of header columns to number of tokens found
          // + one column for outfall name
          SetLength(ColHeaders, N + 1);

          // Add pollutant names to column headers
          ColHeaders[0] := #10#10#10;
          for I := 0 to N - 1 do
            ColHeaders[I + 1] := #10#10 + Tokens[I] + #10;

          // Tokenize header with pollutant units
          Uutils.Tokenize(TopicHeaderLines[Topic][1], Tokens, N);

          // Add the pollutant units to the column headers
          for I := 0 to N - 1 do
            ColHeaders[I] := ColHeaders[I] + Tokens[I];
        finally
          Tokens.Free;
        end;
      end;
  end;
end;

procedure GetAllResults();
var
  PLRMResults: TPLRMResults;
  tempSWTs: TStringList; // temporary list of SWTs for specific SWTType
  tempCatch: TPLRMCatch;
  tempNode: TPLRMNode;
  tempSWMMNode: TNode;
  tempLoads: PLRMGridData;

  catchRunoffSmryArr: PLRMGridData;
  catchWashoffSmryArr: PLRMGridData;
  nodeInflowSmryArr: PLRMGridData;
  linkLoadSmryArr: PLRMGridData;
  outfallLoadSmryArr: PLRMGridData;

  catOut: TcatchResults;
  swtOut: TswtResults;
  totArea, numSimYears, tempDbl: Double; // total area of all catchments
  I, J, K, Z, swtCount: Integer;
  tempNatvSwmmRptFile: TStringList;
begin

  PLRMResults.nativeSWMMRpt := TStringList.Create();
  PLRMResults.nativeSWMMRpt.LoadFromFile(TempReportFile);

  // Get general information
  numSimYears := (EndDateTime - StartDateTime) / 365.2422;
  PLRMResults.numYrsSimulated := Round(numSimYears);
  PLRMResults.metGridNum := PLRMObj.metGridNum;
  PLRMResults.scenarioName := PLRMObj.scenarioName;
  PLRMResults.projectName := PLRMObj.projUserName;
  PLRMResults.wrkDir := PLRMObj.wrkDir + '\';

  // 2014 Locate report topics in the SWMM report file
  FindTopicsInReportFile;
  // Convert from index of available topics to absolute topic index
  K := Topics[CurrentTopic];
  // Set text of column headers
  SetColHeaders(K);

  // get results from temporary report file
  catchRunoffSmryArr := GetResultsForTopic(0, TempReportFile);
  catchWashoffSmryArr := GetResultsForTopic(2, TempReportFile);
  nodeInflowSmryArr := GetResultsForTopic(4, TempReportFile);
  linkLoadSmryArr := GetResultsForTopic(13, TempReportFile);
  outfallLoadSmryArr := GetResultsForTopic(8, TempReportFile);

  // Get catchment results
  totArea := 0;
  SetLength(PLRMResults.catchData, PLRMObj.catchments.Count); // set

  for I := 0 to PLRMObj.catchments.Count - 1 do
  begin
    tempCatch := PLRMObj.catchments.Objects[I] as TPLRMCatch;
    catOut.catchName := tempCatch.name;

    // stores volumes for each landuse in the catchment
    catOut.vollandUses := TStringList.Create();
    // stores loads for each landuse in the catchment
    catOut.loadLandUses := TStringList.Create();
    // SetLength(catOut.annLoadsLUse, Length(catchRunoffSmryArr), NUMCATCHRSLTS);
    SetLength(catOut.annLoadsLUse, 100, NUMCATCHRSLTS);
    SetLength(catOut.AnnLoads, 1, NUMCATCHRSLTS);

    Z := 0;
    // compute catchment annual volumes from Subcatment runoff summary
    for J := 0 to High(catchRunoffSmryArr) - 1 do
    begin
      if ((Pos(tempCatch.name, catchRunoffSmryArr[J, 0]) > 0) and
        (Pos('ToInfCa', catchRunoffSmryArr[J, 0]) = 0) and
        (Pos('ToIDspCa', catchRunoffSmryArr[J, 0]) = 0)) then
      begin
        // save catchment and landuse name
        catOut.vollandUses.Add(catchRunoffSmryArr[J, 0]);
        // 0-index is string names so cannot be converted to floats
        for K := CATCHTOTINFLCOLNUM to CATCHTOTINFLCOLNUM do
        begin
          //catOut.vollandUses.Add(catchRunoffSmryArr[J, 0]);
          tempDbl := StrToFloat(catchRunoffSmryArr[J, K]) / numSimYears;
          catOut.annLoadsLUse[Z, 0] := tempDbl;
          catOut.AnnLoads[0, 0] := catOut.AnnLoads[0, 0] + tempDbl;
        end;
        inc(Z);
      end;
    end;
    // reset now that we know actual number of land uses in catchment
    SetLength(catOut.annLoadsLUse, catOut.vollandUses.Count, NUMCATCHRSLTS);

    Z := 0;
    // compute catchment annual loads from Subcatment washoff summary
    for J := 0 to High(catchWashoffSmryArr) - 1 do
    begin
      if ((Pos(tempCatch.name, catchWashoffSmryArr[J, 0]) > 0) and
        (Pos('ToInfCa', catchWashoffSmryArr[J, 0]) = 0) and
        (Pos('ToIDspCa', catchWashoffSmryArr[J, 0]) = 0)) then
      begin
        // save catchment and landuse name
        catOut.loadLandUses.Add(catchWashoffSmryArr[J, 0]);
        // 0-index is string names so cannot be converted to floats
        for K := 1 to Length(catchWashoffSmryArr[J]) - 1 do
        begin
          tempDbl := StrToFloat(catchWashoffSmryArr[J, K]) / numSimYears;
          catOut.annLoadsLUse[Z, K] := tempDbl;
          catOut.AnnLoads[0, K] := catOut.AnnLoads[0, K] + tempDbl;
        end;
        inc(Z);
      end;
    end;
    // reset now that we know actual number of land uses in catchment
    SetLength(catOut.annLoadsLUse, catOut.loadLandUses.Count, NUMCATCHRSLTS);
    PLRMResults.catchData[I] := catOut;
  end;
  // SetLength(PLRMResults.catchData, I); // reset now that we know actual number of catchments

  // Get SWT results
  swtCount := 0;
  SetLength(PLRMResults.swtData, 100); // set
  for I := 1 to 6 do // cycle through all SWT types
  begin

    tempSWTs := PLRMObj.getSWTTypeNodes(I);
    if tempSWTs <> nil then
    begin
      for J := 0 to tempSWTs.Count - 1 do
      begin
        tempNode := (tempSWTs.Objects[J] as TPLRMNode);
        swtOut.SWTType := I;
        swtOut.swtName := tempNode.userName;

        // get swt volume results
        swtOut.swtVols := PLRMStats.GetSWTVolResultsFromStatRpt(tempNode,
          swtOut.perCap, nodeInflowSmryArr, numSimYears);

        // get swt load results
        swtOut.SWTLoads := PLRMStats.GetSWTLoadResultsFromStatRpt(tempNode,
          swtOut.perCap, linkLoadSmryArr, numSimYears);

        // calculate annual results by dividing by sim lenth in years

        PLRMResults.swtData[swtCount] := swtOut;
        swtCount := swtCount + 1;
      end;
    end;
  end;
  SetLength(PLRMResults.swtData, swtCount); // reset

  // Get general information
  PLRMResults.totPPT_in := GetRainStats();
  PLRMResults.totPPT_cf := PLRMResults.totPPT_in * totArea * 3630;

  // Get Outfall Results
  for I := 0 to Project.Lists[Outfall].Count - 1 do
  begin
    tempSWMMNode := (Project.Lists[Outfall].Objects[I] as TNode);
    if tempSWMMNode = nil then
    begin
      ShowMessage('Could not find Outfall!');
      Exit;
    end;
    if (tempSWMMNode.ID <> 'GW') then
    begin
      tempLoads := GetAveAnnualLoadsForJuncOrLink(tempSWMMNode.ID,
        outfallLoadSmryArr);
      if PLRMResults.outfallLoads = nil then
        SetLength(PLRMResults.outfallLoads, NUMOUTFALLRSLTS,
          Project.Lists[Outfall].Count - 1);

      for J := 4 to High(tempLoads[0]) - 1 do
      begin
        PLRMResults.outfallLoads[J - 4, I] := StrToFloat(tempLoads[0, J]);
      end;
      PLRMResults.runCoeff := 1;
      // PLRMResults.runCoeff := PLRMResults.runCoeff + PLRMResults.outfallLoads
      // [0, I] / PLRMResults.totPPT_cf;
    end;
  end;

  resultsToTextFile(PLRMResults, PLRMObj.wrkDir + '\' + 'swmm.prpt', 0);
  resultsToTextFile(PLRMResults, PLRMObj.wrkDir + '\' + 'swmmDetailed.prpt', 1);
  ShowMessage('All Results Collected!');

  // plrm 2014 moved reloadUserHydro fxn call to fmain to separate concerns
  // reloadUserHydro();
  catchRunoffSmryArr := nil;
  catchWashoffSmryArr := nil;
  nodeInflowSmryArr := nil;
  linkLoadSmryArr := nil;
  outfallLoadSmryArr := nil;
  tempLoads := nil;
  tempSWTs := nil;
end;

procedure reloadUserHydro();
begin
  // Reload user hydrology from user swmm file
  if (FileExists(PLRMObj.scenarioXMLFilePath) = TRUE) then
    if (openAndLoadSWMMInptFilefromXML(PLRMObj.scenarioXMLFilePath) = TRUE) then
      PLRMObj.LinkObjsToSWMMObjs()
    else
      ShowMessage('An error occured while trying to reload project xml file');
end;

end.
