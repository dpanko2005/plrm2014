unit PLRMStats;

interface

uses
 
  Windows, Messages, Dialogs, SysUtils, Variants, Classes, Uglobals, Uproject,
  Ustats, Math, GSTypes, GSNodes, GSCatchments;

function  GetStatsSelection(var Stats: TStatsSelection; ObjID:String; ObjType:Integer; OutVar:Integer;
       StatsTypeIndex: Integer; TimePeriodIndex: Integer): Boolean;
procedure GetVariableTypes(var Stats: TStatsSelection);
function GetAveAnnualLoadsForLink(LinkObjName: String): TStringList;
function GetSWTStats(const tempNode: TPLRMNode; var perCap: Double): PLRMGridDataDbl;
procedure GetAllResults();
procedure reloadUserHydro();
function GetTotalLoads(outfallName: String): PLRMGridDataDbl;
function GetRainStats():Double;
function GetCatchmentStats(catchName: String): PLRMGridDataDbl;
implementation

uses
  Uoutput, GSPLRM, GSResults, GSUtils;
const
  TXT_NO_AREA_SELECTED = 'Must select a subcatchment.';
  TXT_NO_NODE_SELECTED = 'Must select a node.';
  TXT_NO_LINK_SELECTED = 'Must select a link.';
  TXT_NO_OBJECT_SELECTED = 'No object was selected.';
  TXT_INVALID_DATES = 'End date comes before start date.';
  TXT_INVALID_PLOT_PARAM = 'Plotting parameter must be between 0 and 1.';

  BASICSTATS = 0;
  FLOWSTATS  = 1;
  QUALSTATS  = 2;

  StatsTypeText: array[0..2] of PChar =
    ('Mean'#13'Peak',
     'Mean'#13'Peak'#13'Total'#13'Duration'#13'Inter-Event Time',
     'Mean Concen.'#13'Peak Concen.'#13'Mean Load'#13'Peak Load'#13'Total Load');

function FindAllSWTs(SWTNum: Integer): TStringList;
var
I : Integer;
begin
  PLRMObj.getSWTTypeNodes(SWTNum)
end;

function GetAveAnnualLoadsForLink(LinkObjName: String): TStringList;
 //This function calculates average annual loads for a link of name ObjName for
 // all pollutants in the PollutNames list.
  //ObjName - ID name of object being analyzed

var
  Stats: TStatsSelection;// Information on what to analyze
  LoadSum : Double;
  AnnualLoad : Double;
  PeriodIndex : Integer;
  StatsIndex : Integer;
  EventList      : TList;            // List of all events
  AnalysisResults: TStatsResults;    // Analysis results
  VarNumber      : Integer;
  VarUnits       : String;           // Units for variable
  E: PStatsEvent; // Pointer to a TStatsEvent object
  i,J : Integer;
  AnnualLoads : TStringList; //String array containing loads for a single link
begin
  PeriodIndex := 1; //0-tpVariable, 1-tpDaily, 2-tpMonthly, 3-tpAnnual

 //Create lists
   EventList := TList.Create;
   AnnualLoads := TStringList.Create;

//Get Average Annual Volumes
VarNumber := FLOW; //Flow variable
StatsIndex := 2; // 0-stMean, 1-stPeak, 2-stTotal, 3-stDuration, 4-stDelta,
//                   5-stMeanConcen, 6-stPeakConcen, 7-stMeanLoad, 9-stPeakLoad,
//                   9-stTotalLoad)
if GetStatsSelection(Stats,LinkObjName,LINKS,VarNumber, StatsIndex, PeriodIndex) then
   begin
   GetStats(Stats, EventList, AnalysisResults);
   LoadSum :=0;
   for i := 0 to EventList.Count-1 do
    begin
     E := EventList.Items[i];
     LoadSum := LoadSum + E^.Value;
    end;
    EventList.Clear;
    AnnualLoad := LoadSum/((EndDateTime-StartDateTime)/365.2422);
    AnnualLoads.Add(FloatToStr(AnnualLoad));
   
  end
  else ShowMessage('Problem Getting Stats Selection!');

//Cycle through all pollutants for LINK ObjName and add to the AnnualLoads
  StatsIndex := 9; // 0-stMean, 1-stPeak, 2-stTotal, 3-stDuration, 4-stDelta,
//                   5-stMeanConcen, 6-stPeakConcen, 7-stMeanLoad, 9-stPeakLoad,
//                   9-stTotalLoad)
 for J := 0 to Project.PollutNames.Count -1 do
  begin
  VarNumber := LINKQUAL + J; //LINKQUAL=9 is the first pollutant in Uglobals Link variables list
  if GetStatsSelection(Stats,LinkObjName,LINKS,VarNumber, StatsIndex, PeriodIndex) then
   begin
   GetStats(Stats, EventList, AnalysisResults);
   LoadSum :=0;
   for i := 0 to EventList.Count-1 do
    begin
     E := EventList.Items[i];
     LoadSum := LoadSum + E^.Value;
    end;
    EventList.Clear;
    AnnualLoad := LoadSum/((EndDateTime-StartDateTime)/365.2422);
    AnnualLoads.Add(FloatToStr(AnnualLoad));
  end
  else ShowMessage('Problem Getting Stats Selection!');
 end;
   GetAveAnnualLoadsForLink := AnnualLoads;

 end;

function GetSWTStats(const tempNode: TPLRMNode; var perCap: Double): PLRMGridDataDbl;
var
 SWTs: TStringList;
 InLinkID: String; //Inflow link name
 ByLinkID: String; //Bypass link name
 TrLinkID: String; //Treated link (downstream of treatment node)
 Tr2LinkID, DsLinkID: String; //Treated link from permanent pool basin for wet basins
 AnnLoads : TStringList; //String list containing pollutant loads for a single link
 SWTLoads : PLRMGridDataDbl;  // 2-d array of loads for all links associated w/ SWTName
 tempInt, I : Integer;
 L : TLink;

begin
    InLinkID := tempNode.userName + '_InCo';
    ByLinkID := tempNode.userName + '_ByWe';
    TrLinkID := tempNode.userName + '_OtCo';
    DsLinkID := tempNode.userName + '_DsCo';
    AnnLoads := GetAveAnnualLoadsForLink(InLinkID); //StringList of annual loads for Link
    tempInt := AnnLoads.Count;
    SetLength(SWTLoads,tempInt,5);

    case tempNode.SWTType of
      1,4: //Detention, Bed Filter,
      begin
        InLinkID := tempNode.userName + '_InCo';
        ByLinkID := tempNode.userName + '_ByWe';
        TrLinkID := tempNode.userName + '_OtCo';
        DsLinkID := tempNode.userName + '_DsCo';
        if assigned(AnnLoads) then AnnLoads.Clear;
        AnnLoads := GetAveAnnualLoadsForLink(TrLinkID); //StringList of annual loads for Link
        for I := 0 to AnnLoads.Count - 1 do
          SWTLoads[I,2] := StrToFloat(AnnLoads[I]);
      end;

      2: //Infiltration
      begin
        InLinkID := tempNode.userName + '_InCo';
        ByLinkID := tempNode.userName + '_ByWe';
        DsLinkID := tempNode.userName + '_DsCo';
        Tr2LinkID := tempNode.userName + '_GwOl';

        if assigned(AnnLoads) then AnnLoads.Clear;
          AnnLoads := GetAveAnnualLoadsForLink(Tr2LinkID); //StringList of annual loads for Link
        for I := 0 to AnnLoads.Count - 1 do
            SWTLoads[I,4] := StrToFloat(AnnLoads[I]);
      end;
      3: //WetBasin
      begin
        InLinkID := tempNode.userName + '_InCo';
        ByLinkID := tempNode.userName + '_SurByWe';   //surcharge bypass outlet
        TrLinkID := tempNode.userName + '_SurOtCo';  //surcharge treated outlet
        Tr2LinkID := tempNode.userName + '_WetTrWe'; //permanent pool outlet
        if assigned(AnnLoads) then AnnLoads.Clear;
          AnnLoads := GetAveAnnualLoadsForLink(TrLinkID); //StringList of annual loads for Link
        for I := 0 to AnnLoads.Count - 1 do
            SWTLoads[I,2] := StrToFloat(AnnLoads[I]);

        if assigned(AnnLoads) then AnnLoads.Clear;
          AnnLoads := GetAveAnnualLoadsForLink(Tr2LinkID); //StringList of annual loads for Link
        for I := 0 to AnnLoads.Count - 1 do
            SWTLoads[I,2] := SWTLoads[I,2] + StrToFloat(AnnLoads[I]);
      end;
      5,6: //Cartridge Filter bed, Hydrodynamic device
      begin
        InLinkID := tempNode.userName + '_InCo';
        ByLinkID := tempNode.userName + '_ByCo';
        TrLinkID := tempNode.userName + '_OtCo';
        DsLinkID := tempNode.userName + '_DsCo';
        if assigned(AnnLoads) then AnnLoads.Clear;
          AnnLoads := GetAveAnnualLoadsForLink(TrLinkID); //StringList of annual loads for Link
        for I := 0 to AnnLoads.Count - 1 do
          SWTLoads[I,2] := StrToFloat(AnnLoads[I]);
      end;
    end;

    //Get annual loads for each link and transfer to SWTLoads array
    if assigned(AnnLoads) then AnnLoads.Clear;
    AnnLoads := GetAveAnnualLoadsForLink(InLinkID); //StringList of annual loads for Link
    for I := 0 to AnnLoads.Count - 1 do
      SWTLoads[I,0] := StrToFloat(AnnLoads[I]);

    if assigned(AnnLoads) then AnnLoads.Clear;
    AnnLoads := GetAveAnnualLoadsForLink(ByLinkID); //StringList of annual loads for Link
    for I := 0 to AnnLoads.Count - 1 do
      SWTLoads[I,1] := StrToFloat(AnnLoads[I]);

    if assigned(AnnLoads) then AnnLoads.Clear;
    AnnLoads := GetAveAnnualLoadsForLink(DsLinkID); //StringList of annual loads for Link
    for I := 0 to AnnLoads.Count - 1 do
      SWTLoads[I,3] := StrToFloat(AnnLoads[I]);

    if SWTLoads[0,0] = 0 then
      perCap := 0
    else perCap := (1 - (SWTLoads[0,1]/SWTLoads[0,0]))*100;
    GetSWTStats := SWTLoads;
end;

function GetStatsSelection(var Stats: TStatsSelection; ObjID:String; ObjType:Integer; OutVar:Integer;
  StatsTypeIndex: Integer; TimePeriodIndex: Integer): Boolean;
//-----------------------------------------------------------------------------
// Places user's selections into a TStatsSelection data structure
//-----------------------------------------------------------------------------
begin
  Result := False;
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
    PlotPosition := TPlotPosition(0); //ppFrequency;
    IsQualParam := TRUE;
    IsRainParam := FALSE;
    if PlotParameter > 1
    then MessageDlg(TXT_INVALID_PLOT_PARAM, mtError, [mbOK], 0)
    else
    if (ObjectType <> SYS) and (Uoutput.GetObject(ObjectType, ObjectID) = nil)
    then MessageDlg(TXT_NO_OBJECT_SELECTED, mtError, [mbOK], 0)
    else
    Result := True;

  end;
  if Result = True then GetVariableTypes(Stats);
end;

procedure GetVariableTypes(var Stats: TStatsSelection);
//-----------------------------------------------------------------------------
// Determines if the variable being analyzed is rainfall, losses, or quality.
//-----------------------------------------------------------------------------
begin
  Stats.IsQualParam := False;
  Stats.IsRainParam := False;
  Stats.VarIndex := Uoutput.GetVarIndex(Stats.Variable, Stats.ObjectType);
  Stats.FlowVarIndex := -1;
  case Stats.ObjectType of

    SUBCATCHMENTS:
    begin
      if Stats.Variable >= SUBCATCHQUAL
      then Stats.IsQualParam := True
      else
      begin
        if (Stats.Variable = RAINFALL)
        //plrm 2014 no LOSSES in v5.1 or (Stats.Variable = LOSSES)
        then Stats.IsRainParam := True;
      end;
      if Stats.IsQualParam
      then Stats.FlowVarIndex := Uoutput.GetVarIndex(RUNOFF, SUBCATCHMENTS)
      else Stats.FlowVarIndex := Stats.VarIndex;
    end;

    NODES:
    begin
      if Stats.Variable >= NODEQUAL then Stats.IsQualParam := True;
      if Stats.Variable = INFLOW
      then Stats.FlowVarIndex := Uoutput.GetVarIndex(INFLOW, NODES);
      if Stats.Variable = OVERFLOW
      then Stats.FlowVarIndex := Uoutput.GetVarIndex(OVERFLOW, NODES);
    end;

    LINKS:
    begin
      if Stats.Variable >= LINKQUAL then Stats.IsQualParam := True;
      Stats.FlowVarIndex := Uoutput.GetVarIndex(FLOW, LINKS);
    end;

    SYS:
    begin
      if (Stats.Variable = SYS_RAINFALL)
      //plrm 2014 no lossed in v5.1 or (Stats.Variable = SYS_LOSSES)
      then Stats.IsRainParam := True;
      Stats.FlowVarIndex := Stats.VarIndex;
    end;
  end;
end;

function GetRainStats():Double; //total average annual rainfall in inches
var
  VolSum : Double;      //cummulative inches of rainfall
  AnnualVol : Double;  //total average annual rainfall volume in inches
  Stats: TStatsSelection;// Information on what to analyze
  PeriodIndex : Integer;
  StatsIndex : Integer;
  EventList      : TList;            // List of all events
  AnalysisResults        : TStatsResults;    // Analysis results
  VarNumber      : Integer;
  VarUnits       : String;           // Units for variable
  E: PStatsEvent; // Pointer to a TStatsEvent object
  i,J : Integer;
begin
  PeriodIndex := 1; //0-tpVariable, 1-tpDaily, 2-tpMonthly, 3-tpAnnual

 //Create lists
   EventList := TList.Create;

//Get Average Annual Volumes
VarNumber := SYS_RAINFALL; //rainfall
StatsIndex := 2; // 0-stMean, 1-stPeak, 2-stTotal, 3-stDuration, 4-stDelta,
//                   5-stMeanConcen, 6-stPeakConcen, 7-stMeanLoad, 9-stPeakLoad,
//                   9-stTotalLoad)
if GetStatsSelection(Stats,'',SYS,VarNumber, StatsIndex, PeriodIndex) then
   begin
   GetStats(Stats, EventList, AnalysisResults);
   VolSum :=0;
   for i := 0 to EventList.Count-1 do
    begin
     E := EventList.Items[i];
     VolSum := VolSum + E^.Value;
    end;
    EventList.Clear;
    AnnualVol := VolSum/((EndDateTime-StartDateTime)/365.2422);

  end
  else ShowMessage('Problem Getting Stats Selection!');

  GetRainStats := AnnualVol;

end;

function GetTotalLoads(outfallName: String): PLRMGridDataDbl;
var
 OutLnkID: String; // outfall link name
 outLoads : TStringList; //String list containing pollutant loads for a outfall link
 tempSysLds : PLRMGridDataDbl; //volumes and loads summary for entire simulation
 I, tempInt : Integer;
begin
     OutLnkID := outfallName + '_UsCo';
    //Get annual loads for outfall link and transfer to SWTLoads array
     outLoads := GetAveAnnualLoadsForLink(OutLnkID); //StringList of annual loads for Link
     tempInt := outLoads.Count;
     SetLength(tempSysLds,tempInt,1);
     for I := 0 to  outLoads.Count - 1 do tempSysLds[I,0] := StrToFloat(outLoads[I]);
     outLoads.Clear;
     GetTotalLoads := tempSysLds;
end;
 
function GetCatchmentStats(catchName: String): PLRMGridDataDbl;
var
 OutLnkID: String; // outfall link name
 catchLoads : TStringList; //String list containing pollutant loads for a catchment
 tempLoads : PLRMGridDataDbl;
 I, tempInt : Integer;
begin
     OutLnkID := catchName + '_DsCo';
    //Get annual loads for downstream catchment link and transfer to tempLoads array
     catchLoads := GetAveAnnualLoadsForLink(OutLnkID); //StringList of annual loads for Link
     tempInt := catchLoads.Count;
     SetLength(tempLoads,tempInt,1);
     for I := 0 to catchLoads.Count - 1 do
      tempLoads[I,0] := StrToFloat(catchLoads[I]);
     catchLoads.Clear;
     GetCatchmentStats := tempLoads;
end;


procedure GetAllResults();
var
  PLRMResults : TPLRMResults;
  tempSWTs : TStringList; //temporary list of SWTs for specific SWTType
  tempCatch : TPLRMCatch;
  tempNode : TPLRMNode;
  tempSWMMNode : TNode;
  tempLoads : PLRMGridDataDbl;
  catOut : TcatchResults;
  swtOut : TswtResults; 
  totArea : Double; //total area of all catchments
  I,J, swtCount: Integer;
  tempNatvSwmmRptFile:TStringList;
begin

  PLRMResults.nativeSWMMRpt := TStringList.Create();
  PLRMResults.nativeSWMMRpt.LoadFromFile(TempReportFile);
  //Get catchment results
  totArea := 0;
  SetLength(PLRMResults.catchData,1000);  //set
  for I := 0 to PLRMObj.catchments.Count - 1 do
    begin
      tempCatch := PLRMObj.catchments.Objects[I] as TPLRMCatch;
      totArea := totArea + tempCatch.area;
      catOut.catchName := tempCatch.name;
      catOut.annLoads := GetCatchmentStats(tempCatch.name);
      PLRMResults.catchData[I] := catOut;
    end;
  SetLength(PLRMResults.catchData,I);  //reset


  //Get SWT results
  swtCount :=0;
  SetLength(PLRMResults.swtData,1000);  //set
  for I := 1 to 6 do //cycle through all SWT types
   begin

    tempSWTs := PLRMObj.getSWTTypeNodes(I);
    if tempSWTs <> nil then
    begin
     for J := 0 to tempSWTs.Count - 1 do
      begin
       tempNode := (tempSWTs.Objects[J] as TPLRMNode);
       swtOut.swtType := I;
       swtOut.swtName := tempNode.userName;

       swtOut.swtLoads := PLRMStats.GetSWTStats(tempNode,swtOut.perCap);
       PLRMResults.swtData[swtCount] := swtOut;
       swtCount:=swtCount+1;
      end;
    end;
   end;
   SetLength(PLRMResults.swtData,swtCount); //reset

   //Get general information
  PLRMResults.numYrsSimulated := Round((EndDateTime-StartDateTime)/365.2422);
  PLRMResults.metGridNum := PLRMObj.metGridNum;
  PLRMResults.scenarioName := PLRMObj.scenarioName;
  PLRMResults.projectName := PLRMObj.projUserName;
  PLRMResults.totPPT_in := GetRainStats();
  PLRMResults.totPPT_cf := PLRMResults.totPPT_in*totArea*3630;
  PLRMResults.wrkDir := PLRMObj.wrkdir + '\';

  for I := 0 to Project.Lists[Outfall].Count-1 do
  begin
    tempSWMMNode := (Project.Lists[Outfall].Objects[I] as TNode);
    if tempSWMMNode = nil then
    begin
      ShowMessage('Could not find Outfall!');
      Exit;
    end;
    if (tempSWMMNode.ID <> 'GW') then
    begin
      tempLoads := GetTotalLoads(tempSWMMNode.ID);
      if PLRMResults.outfallLoads = nil then  SetLength(PLRMResults.outfallLoads,High(tempLoads)+1,Project.Lists[Outfall].Count-1);

      for J := 0 to High(tempLoads)  do
        PLRMResults.outfallLoads[J,I] := tempLoads[J,0];
      PLRMResults.runCoeff := PLRMResults.runCoeff  + PLRMResults.outfallLoads[0,I]/PLRMResults.totPPT_cf;
    end;
  end;

  resultsToTextFile(PLRMResults, PLRMObj.wrkdir + '\' + 'swmm.prpt');
  ShowMessage('All Results Collected!');

   reloadUserHydro();
  tempSWTs := nil;
end;

procedure reloadUserHydro();
begin
  //Reload user hydrology from user swmm file
  if (FileExists(PLRMObj.scenarioXMLFilePath)= true) then
     if (openAndLoadSWMMInptFilefromXML(PLRMObj.scenarioXMLFilePath)= true) then
      PLRMObj.LinkObjsToSWMMObjs()
     else
      showMessage('An error occured while trying to reload project xml file');
end;
end.
