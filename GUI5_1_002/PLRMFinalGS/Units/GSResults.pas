unit GSResults;

// This unit transfers scenario results from the TPLRMResults record to a TStringList
// and exports the stringlist to an output textfile
interface

uses
  Windows, Messages, Dialogs, SysUtils, Variants, Classes, Uglobals, Uproject,
  Ustats, Math, GSTypes, GSNodes, GSIO, StrUtils;

{ function SWTStatSummary(SWTType: Integer; swtName: String;
  swtData: PLRMGridDataDbl): TStringList; }
function catchStatSummary(catchName: String; annLoads: PLRMGridDataDbl;
  mode: Integer): TStringList;
// function resultsToTextFile(Rslts: TPLRMResults; filePath: string): Boolean;
function resultsToTextFile(Rslts: TPLRMResults; filePath: string;
  mode: Integer): Boolean;
function SWTStatSummary(SWTType: Integer; swtName: String;
  swtDataVols: PLRMGridDataDbl; swtDataLoads: PLRMGridDataDbl; mode: Integer)
  : TStringList;
function catchStatSummaryByLuse(catchName: String; catchLuseList: TStringList;
  loadsByLuse: PLRMGridDataDbl): TStringList;
function getLandUseLabel(catchmentAndLusName: String): String;

implementation

Uses
  GSUtils, GSPLRM;

function catchStatSummaryByLuse(catchName: String; catchLuseList: TStringList;
  loadsByLuse: PLRMGridDataDbl): TStringList;
// This function reads in a PLRM grid of annual volumes and loads of influent and effluent
// and returns a stringlist of summary statistics. Stringlist objects include:
var
  I, J, K, tempIndex: Integer;
  tempSL: TStringList;
  tempStr, tempLine1: String;
  Tab: String;
  lusePositionCheckList: TStringList;
  loadsByLuseCombined: PLRMGridDataDbl;
begin

  lusePositionCheckList := TStringList.Create();
  SetLength(loadsByLuseCombined, Length(loadsByLuse),
    Length(loadsByLuse[0]) + 1);

  if Uglobals.TabDelimited then
    Tab := #9
  else
    Tab := ' ';
  tempSL := TStringList.Create;
  // plrm 2014 check to see if annLoads populated before continuing
  if (Length(loadsByLuse) < 1) then
  begin
    tempSL.Add('Unable to get annual loads for catchments');
    Result := tempSL;
    exit;
  end;

  // loop through and combine entries with the same land use
  K := 0;
  // tempIndex := -1;
  for I := 0 to High(loadsByLuse) do
  begin
    // check if landuse exists in the checklist, if so retrieve its position otherwise add it
    tempStr := getLandUseLabel(catchLuseList[I]);
    tempIndex := lusePositionCheckList.IndexOf(tempStr);
    if (tempIndex = -1) then
    begin
      lusePositionCheckList.Add(tempStr);
      for J := 0 to High(loadsByLuse[0]) do
      begin
        loadsByLuseCombined[I, J] := loadsByLuse[I, J];
      end;
      inc(K);
    end
    else
    begin
      for J := 0 to High(loadsByLuse[0]) do
      begin
        loadsByLuseCombined[tempIndex, J] := loadsByLuseCombined[tempIndex, J] +
          loadsByLuse[I, J];
      end;
    end;
  end;
  SetLength(loadsByLuseCombined, K, Length(loadsByLuse[0]));

  for I := 0 to High(loadsByLuseCombined) do
  begin
    // tempStr := getLandUseLabel(catchLuseList[I]);
    tempLine1 := Format(rsltsFormatStrLft, [lusePositionCheckList[I]]) +
      Format(rsltsFormatDec181f, [loadsByLuseCombined[I, 0] * CONVMGALTOACFT]);

    for J := 1 to High(loadsByLuseCombined[0]) do
    begin
      tempLine1 := tempLine1 + Format(rsltsFormatDec181f,
        [loadsByLuseCombined[I, J]]);
    end;
    tempSL.Add(tempLine1);
  end;

  { // add catchment totals
    tempLine1 := Format(rsltsFormatStrLft, [catchName + ' Total']) +
    Format(rsltsFormatDec181f, [loadsByLuseCombined[I, 0] * CONVMGALTOACFT]);
    for J := 1 to High(loadsByLuseCombined[0]) do
    begin
    tempLine1 := tempLine1 + Format(rsltsFormatDec181f,
    [loadsByLuseCombined[I, J]]);
    end; }
  // tempSL.Add(tempLine1);
  Result := tempSL;
end;

function getLandUseLabel(catchmentAndLusName: String): String;
var
  luseDBData: dbReturnFields;
  I: Integer;
begin
  luseDBData := GSIO.lookUpValFrmTable(18, 1, 2);

  for I := 0 to luseDBData[0].Count - 1 do
  begin
    if (Pos(LowerCase('_' + luseDBData[0][I]), LowerCase(catchmentAndLusName)
      ) > 0) then
    begin
      Result := luseDBData[1][I];
      exit;
    end;
  end;

  Result := 'LU not found-' + catchmentAndLusName;
  if (Pos('_Othr', catchmentAndLusName) > 0) then
    Result := 'Other';
  if (Pos('_Road', catchmentAndLusName) > 0) then
    Result := 'Road';
end;

function catchStatSummary(catchName: String; annLoads: PLRMGridDataDbl;
  mode: Integer): TStringList;
// This function reads in a PLRM grid of annual volumes and loads of influent and effluent
// and returns a stringlist of summary statistics. Stringlist objects include:
var
  I: Integer;
  tempSL: TStringList;
  tempLine1: String;
  Tab: String;
begin
  if Uglobals.TabDelimited then
    Tab := #9
  else
    Tab := ' ';
  tempSL := TStringList.Create;
  // plrm 2014 check to see if annLoads populated before continuing
  if (Length(annLoads) < 1) then
  begin
    tempSL.Add('Unable to get annual loads for catchments');
    Result := tempSL;
    exit;
  end;

  tempLine1 := Format(rsltsFormatStrLft, [catchName]) +
    Format(rsltsFormatDec181f, [annLoads[0, 0] * CONVMGALTOACFT]);
  // convert vol to ac-ft
  for I := 1 to High(annLoads[0]) do
    // exclude TSS, SRP, DIN
    if ((mode = 1) or ((I <> 1) and (I <> 4) and (I <> 6))) then
    begin
      tempLine1 := tempLine1 + Format(rsltsFormatDec180f, [annLoads[0, I]]);
    end;
  tempSL.Add(tempLine1);
  Result := tempSL;
end;

function getOutfallStatSummary(annLoads: PLRMGridDataDbl; mode: Integer)
  : TStringList;
// This function reads in a PLRM grid of annual volumes and loads of influent and effluent
// and returns a stringlist of summary statistics. Stringlist objects include:
var
  I, J: Integer;
  tempSL: TStringList;
  tempLine1: String;
  tempSWMMNode: TNode;
  totLoads: PLRMGridDataDbl;
  Tab: String;
begin
  if Uglobals.TabDelimited then
    Tab := #9
  else
    Tab := ' ';

  tempSL := TStringList.Create;

  SetLength(totLoads, High(annLoads) + 1, High(annLoads[0]) + 1);
  for I := 0 to High(annLoads[0]) do
  begin
    tempSWMMNode := (Project.Lists[Outfall].Objects[I] as TNode);
    if ((tempSWMMNode <> nil) and (tempSWMMNode.ID <> 'GW')) then
    begin
      tempLine1 := Format(rsltsFormatStrLft, [tempSWMMNode.ID]) +
        Format(rsltsFormatDec181f, [annLoads[0, I] * CONVMGALTOACFT]);

      totLoads[0, 0] := totLoads[0, 0] + annLoads[0, I];
      for J := 1 to High(annLoads) do
      begin
        // exclude TSS,SRP, DIN for summary report
        if ((mode = 0) and ((J <> 1) and (J <> 4) and (J <> 6))) then
          tempLine1 := tempLine1 + Format(rsltsFormatDec180f, [annLoads[J, I]])
        else if (mode = 1) then
          tempLine1 := tempLine1 + Format(rsltsFormatDec181f, [annLoads[J, I]]);

        totLoads[J, 0] := totLoads[J, 0] + (annLoads[J, I]);
      end;
      tempSL.Add(tempLine1);
    end;
  end;

  tempLine1 := Format(rsltsFormatStrLft, ['Scenario Total']) +
    Format(rsltsFormatDec181f, [totLoads[0, 0] * CONVMGALTOACFT]);

  for I := 1 to High(totLoads) do
  begin
    // exclude TSS,SRP, DIN for summary report
    if ((mode = 0) and ((I <> 1) and (I <> 4) and (I <> 6))) then
      tempLine1 := tempLine1 + Format(rsltsFormatDec180f, [totLoads[I, 0]])
    else if (mode = 1) then
      tempLine1 := tempLine1 + Format(rsltsFormatDec181f, [totLoads[I, 0]])
  end;

  tempSL.Add(tempLine1);
  Result := tempSL;
end;

function SWTStatSummary(SWTType: Integer; swtName: String;
  swtDataVols: PLRMGridDataDbl; swtDataLoads: PLRMGridDataDbl; mode: Integer)
  : TStringList;
// This function reads in a PLRM grid of annual volumes and loads of influent and effluent
// and returns a stringlist of summary statistics. Stringlist objects include:
// 1.	Total Inflow Volume
// 2.	Total Outflow Volume
// 3.	Volume Reduction (%)
// 4.	Influent Load
// 5.	Effluent Load
// 6.	Load Reduction (%)

// swtData[I,K] structure: I's are volumes and loads, K's are link numbers
var
  inVol, comboVol, trVol, byVol, pDif, perCapt: Double;
  I, J: Integer;
  tempSL: TStringList;
  tempStr, tempLine1, tempLine2, tempLine3, tempLine4, tempLine5, tempLine6,
    tempLine7, loadNumberFormat: String;
begin
  comboVol := 0.0;
  if (mode = 0) then
    loadNumberFormat := rsltsFormatDec180f
  else
    loadNumberFormat := rsltsFormatDec181f;

  // if Uglobals.TabDelimited then Tab := #9 else Tab := ' ';
  tempSL := TStringList.Create;
  tempStr := Format(rsltsFormatStrLft, [swtName]) + Format(rsltsFormatStrRgt,
    ['Volume(ac-ft/yr)']);

  for J := 0 to Project.PollutNames.Count - 1 do
  begin
    if ((mode = 0) and ((J = 0) or (J = 3) or (J = 5))) then
      // skip TSS,SRP,DIN
    else
      tempStr := tempStr + Format(rsltsFormatStrRgt,
        [Project.PollutNames[J] + '(lbs/yr)']);
  end;
  tempSL.Add(tempStr);

  if (mode = 1) then
    tempSL.Add
      ('-------------------------  ----------------       -----------       -----------        ----------       -----------        -----------      -----------')
  else
    tempSL.Add
      ('-------------------------  ----------------       -----------       -----------        ----------');

  inVol := swtDataVols[0, 0] * CONVMGALTOACFT; // total inflow volume
  byVol := swtDataVols[0, 1] * CONVMGALTOACFT;
  trVol := swtDataVols[0, 2] * CONVMGALTOACFT;
  pDif := 0;
  // perCapt := 0;

  case SWTType of
    1, 3, 4, 5, 6:
      // Detention, Bed Filter, Cartridge Filter bed, Hydrodynamic device
      begin
        comboVol := swtDataVols[0, 3] * CONVMGALTOACFT;
        if (inVol <> 0) then
          pDif := ((inVol - comboVol) / inVol) * 100
          // (inflow-outflow)/inflow as a percent
      end;
    2: // Infiltration
      begin
        comboVol := byVol;
        if (inVol <> 0) then
          pDif := ((inVol - comboVol) / inVol) * 100
          // (inflow-outflow)/inflow as a percent
      end;
  end;
  perCapt := 100 * (1 - byVol / inVol);
  // Transfer volume results to TStringList;

  tempLine1 := Format(rsltsFormatStrLft, ['Total Influent']) +
    Format(rsltsFormatDec181f, [inVol]);
  tempLine2 := Format(rsltsFormatStrLft, ['Bypass Stream']) +
    Format(rsltsFormatDec181f, [byVol]);
  tempLine3 := Format(rsltsFormatStrLft, ['Treated Stream']) +
    Format(rsltsFormatDec181f, [trVol]);
  tempLine4 := Format(rsltsFormatStrLft, ['Total Effluent']) +
    Format(rsltsFormatDec181f, [comboVol]);
  tempLine5 := Format(rsltsFormatStrLft, ['Volume/Load Removed']) +
    Format(rsltsFormatDec181f, [(inVol - comboVol)]);

  tempLine6 := Format(rsltsFormatStrLft, ['%Removed']) +
    Format(rsltsFormatDec170f, [pDif]) + '%';
  tempLine7 := Format(rsltsFormatStrLft, ['%Treated']) +
    Format(rsltsFormatDec160f, [perCapt]) + '%';

  for I := 1 to High(swtDataLoads) do
  begin
    // Transfer load results to TStringList;
    inVol := swtDataLoads[I, 0]; // total inflow volume
    byVol := swtDataLoads[I, 1];
    trVol := swtDataLoads[I, 2];

    case SWTType of
      1, 3, 4, 5, 6:
        // Detention, Bed Filter, Cartridge Filter bed, Hydrodynamic device
        comboVol := swtDataLoads[I, 3];
      2: // Infiltration
        comboVol := byVol;
    end;
    if (inVol <> 0) then
      pDif := ((inVol - comboVol) / inVol) * 100;
    if ((mode = 0) and ((I = 1) or (I = 4) or (I = 6))) then
      // skip TSS,SRP,DIN
    else
    begin
      tempLine1 := tempLine1 + Format(loadNumberFormat, [inVol]);
      tempLine2 := tempLine2 + Format(loadNumberFormat, [byVol]);
      tempLine3 := tempLine3 + Format(loadNumberFormat, [trVol]);
      tempLine4 := tempLine4 + Format(loadNumberFormat, [comboVol]);
      tempLine5 := tempLine5 + Format(loadNumberFormat, [(inVol - comboVol)]);
      tempLine6 := tempLine6 + Format(rsltsFormatDec170f, [pDif]) + '%';
    end;
    pDif := 0;
  end;
  if (mode = 1) then
  begin
    tempSL.Add(tempLine1);
    tempSL.Add(tempLine2);
    tempSL.Add(tempLine3);
    tempSL.Add(tempLine4);
  end;
  tempSL.Add(tempLine5);
  tempSL.Add(tempLine6);
  tempSL.Add(tempLine7);
  SWTStatSummary := tempSL;
end;

// mode = 0 => summary report - low detail
// mode = 1 => supplemental report - high detail
function resultsToTextFile(Rslts: TPLRMResults; filePath: string;
  mode: Integer): Boolean;
var
  tempList: TStringList;
  S, OutfallLines: TStringList;
  I, tempInt0, tempInt1, tempInt2: Integer;
  pollsHdr, pollsHdrDetailed, tempStr, tempStr1: String;
  tempDbl2, tempDbl3, uprZoneEt1, uprZoneEt2, lowrZoneEt1, lowrZoneEt2,
    percToGW, outfallInfloSum: Double;
  precip, sysDischarge, percoltn, et, initGWStor, finalGWStor, initSnow,
    finSnow, chngDepStor: Double;
  undrlnStr: String;
  areaFactor, infiltration: Double;
begin
  S := TStringList.Create;
  outfallInfloSum := 0.0;
  tempDbl3 := 0.0;
  tempDbl2 := 0.0;
  et := 0.0;
  undrlnStr :=
    '-----------------------------------------------------------------------------------------------------------------------------------------------------------------';
  // save pollutants header for reuse
  for I := 0 to Project.PollutNames.Count - 1 do
  begin
    pollsHdrDetailed := pollsHdrDetailed + Format(rsltsFormatStrRgt,
      [Project.PollutNames[I] + '(lbs/yr)']);
    // exclude TSS, SRP, DIN
    if ((I <> 0) and (I <> 3) and (I <> 5)) then
    begin
      pollsHdr := pollsHdr + Format(rsltsFormatStrRgt,
        [Project.PollutNames[I] + '(lbs/yr)']);
    end;
  end;

  // plrm 2014 add program name and version number  last 3 digits match support swmm engine last 3 digits
  S.Add('*******************************************************************');
  S.Add('POLLUTTANT LOAD REDUCTION MODEL (PLRM) - VERSION 2.0 (Build 2.0.006)');
  S.Add('*******************************************************************');

  // Write general results
  S.Add('*******************');
  S.Add('Global Information');
  S.Add('*******************');
  S.Add(' ');
  S.Add('Project Name:....................  ' + Rslts.projectName);
  S.Add('Scenario Name:...................  ' + Rslts.scenarioName);
  S.Add('Number of years in simulation :..  ' +
    IntToStr(Rslts.numYrsSimulated));
  S.Add('Met Grid # simulated:............  ' + IntToStr(Rslts.metGridNum));
  S.Add('Working Directory:...............  ' + Rslts.wrkDir);
  S.Add('Date First Created:..............  ' + PLRMObj.dateCreated);
  S.Add('Date Computed:...................  ' + DateTimeToStr(Now));
  S.Add(' ');

  // Write catchment results
  S.Add('****************');
  S.Add('Catchments');
  S.Add('****************');
  S.Add(' ');
  if (mode = 0) then
  begin
    tempStr := Format(rsltsFormatStrLft, ['Catchment Name']) +
      Format(rsltsFormatStrRgt, ['Volume(ac-ft/yr)']);
    S.Add(tempStr + pollsHdr);
    S.Add('--------------------       ----------------       -----------       -----------        ----------');
  end;

  if (mode = 0) then
  begin
    for I := 0 to High(Rslts.catchData) do
    begin
      // plrm 2014 added if statement to check for nil
      if (Length(Rslts.catchData) > 0) then
      begin
        tempList := catchStatSummary(Rslts.catchData[I].catchName,
          Rslts.catchData[I].annLoads, mode);
        S.Add(tempList[0]);
      end;
    end;
  end
  else
  begin
    for I := 0 to High(Rslts.catchData) do
    begin
      tempStr := Format(rsltsFormatStrLft, [Rslts.catchData[I].catchName]) +
        Format(rsltsFormatStrRgt, ['Volume(ac-ft/yr)']);

      S.Add(tempStr + pollsHdrDetailed);
      S.Add('--------------------       ----------------       -----------       -----------        ----------       -----------        -----------      -----------');
      // plrm 2014 added if statement to check for nil
      if (Length(Rslts.catchData) > 0) then
      begin
        tempList := catchStatSummaryByLuse(Rslts.catchData[I].catchName,
          Rslts.catchData[I].loadLandUses, Rslts.catchData[I].annLoadsLuse);
        S.AddStrings(tempList);

        // add totals for the current catchment
        // S.Add('--------------------       ----------------       -----------       -----------        ----------       -----------        -----------      -----------');
        tempList := catchStatSummary(Rslts.catchData[I].catchName + ' Total',
          Rslts.catchData[I].annLoads, mode);
        S.Add(tempList[0]);
      end;
      S.Add(' ');
      S.Add(' ');
    end;
  end;
  S.Add(' ');

  // Write swt results
  S.Add('**********************');
  S.Add('Storm Water Treatment');
  S.Add('**********************');
  S.Add(' ');
  for I := 0 to High(Rslts.swtData) do
  begin
    tempList := SWTStatSummary(Rslts.swtData[I].SWTType,
      Rslts.swtData[I].swtName, Rslts.swtData[I].swtVols,
      Rslts.swtData[I].swtLoads, mode);
    S.Add(tempList.Text);
  end;
  S.Add(' ');

  // Write Scenario Summary
  S.Add('****************');
  S.Add('Scenario Summary');
  S.Add('****************');
  S.Add(' ');
  S.Add('Average Annual Hydrology              acre-feet/yr            inches/yr');
  S.Add('----------------------------          ------------            ---------');
  // get upperzone et from Ground water continuity
  tempInt0 := 4 + Rslts.nativeSWMMRpt.IndexOf
    ('  Groundwater Continuity         acre-feet        inches');
  initGWStor := StrToFloat
    (AnsiMidStr(Rslts.nativeSWMMRpt[tempInt0 - 2], 29, 15));
  uprZoneEt1 := StrToFloat(AnsiMidStr(Rslts.nativeSWMMRpt[tempInt0], 29, 15));
  uprZoneEt2 := StrToFloat(AnsiMidStr(Rslts.nativeSWMMRpt[tempInt0], 44, 14));
  lowrZoneEt1 := StrToFloat
    (AnsiMidStr(Rslts.nativeSWMMRpt[tempInt0 + 1], 29, 15));
  lowrZoneEt2 := StrToFloat
    (AnsiMidStr(Rslts.nativeSWMMRpt[tempInt0 + 1], 44, 14));
  finalGWStor := StrToFloat
    (AnsiMidStr(Rslts.nativeSWMMRpt[tempInt0 + 4], 29, 15));

  tempInt1 := 2 + Rslts.nativeSWMMRpt.IndexOf
    ('  Runoff Quantity Continuity     acre-feet        inches');
  tempInt2 := Rslts.nativeSWMMRpt.IndexOf
    ('  Runoff Quality Continuity            lbs           lbs           lbs           lbs           lbs')
    - 5;
  precip := StrToFloat(AnsiMidStr(Rslts.nativeSWMMRpt[tempInt1 + 1], 29, 15));
  initSnow := StrToFloat(AnsiMidStr(Rslts.nativeSWMMRpt[tempInt1], 29, 15));
  finSnow := StrToFloat(AnsiMidStr(Rslts.nativeSWMMRpt[tempInt1 + 6], 29, 15));
  chngDepStor := StrToFloat
    (AnsiMidStr(Rslts.nativeSWMMRpt[tempInt1 + 7], 29, 15));
  infiltration := StrToFloat
    (AnsiMidStr(Rslts.nativeSWMMRpt[tempInt1 + 3], 29, 15));

  for I := tempInt1 + 1 to tempInt2 - 2 do
  begin
    if ((I <> (tempInt1 + 5)) and (I <> (tempInt1 + 3)) and
      (I <> (tempInt1 + 4))) then
    begin
      tempStr1 := AnsiLeftStr(Rslts.nativeSWMMRpt[I], 29);
      tempDbl2 := StrToFloat(AnsiMidStr(Rslts.nativeSWMMRpt[I], 29, 15)) /
        Rslts.numYrsSimulated;
      tempDbl3 := StrToFloat(AnsiMidStr(Rslts.nativeSWMMRpt[I], 44, 14)) /
        Rslts.numYrsSimulated;

      // calculate combined evaporation loss
      if (I = (tempInt1 + 2)) then
      begin
        et := (StrToFloat(AnsiMidStr(Rslts.nativeSWMMRpt[I], 29, 15)) +
          uprZoneEt1 + lowrZoneEt1);
        tempDbl2 := et / Rslts.numYrsSimulated;
        tempDbl3 := (StrToFloat(AnsiMidStr(Rslts.nativeSWMMRpt[I], 44, 14)) +
          uprZoneEt2 + lowrZoneEt2) / Rslts.numYrsSimulated;
      end;

      // calculate combined infiltration loss
      if (I = (tempInt1 + 3)) then
      begin
        tempDbl2 := (StrToFloat(AnsiMidStr(Rslts.nativeSWMMRpt[I], 29, 15)) -
          (StrToFloat(AnsiMidStr(Rslts.nativeSWMMRpt[I - 1], 29, 15)) +
          uprZoneEt1 + lowrZoneEt1)) / Rslts.numYrsSimulated;
        tempDbl3 := (StrToFloat(AnsiMidStr(Rslts.nativeSWMMRpt[I], 44, 14)) -
          (StrToFloat(AnsiMidStr(Rslts.nativeSWMMRpt[I - 1], 44, 14)) +
          uprZoneEt2 + lowrZoneEt2)) / Rslts.numYrsSimulated;
      end;
      S.Add(tempStr1 + '   ' + Format(rsltsFormatDec181f, [tempDbl2]) + '   ' +
        Format(rsltsFormatDec181f, [tempDbl3]));
    end;
  end;

  // calculate factor for converting from ac-ft to in
  areaFactor := tempDbl3 / tempDbl2;
  // extract values from outfall summary
  tempInt1 := 8 + Rslts.nativeSWMMRpt.IndexOf('  Outfall Loading Summary');
  OutfallLines := TStringList.Create();
  for I := 0 to Project.Lists[Outfall].Count - 2 do
  begin
    // OutfallLines.Add(Rslts.nativeSWMMRpt[tempInt1 + I]);
    outfallInfloSum := outfallInfloSum +
      StrToFloat(AnsiMidStr(Rslts.nativeSWMMRpt[tempInt1 + I], 51, 12));
  end;
  sysDischarge := outfallInfloSum * CONVMGALTOACFT;
  percoltn := (infiltration - (uprZoneEt1 + lowrZoneEt1)) +
    StrToFloat(AnsiMidStr(Rslts.nativeSWMMRpt[tempInt1 + Project.Lists[Outfall]
    .Count - 1], 51, 12)) * CONVMGALTOACFT;

  S.Add('  System Surface Discharge..    ' + Format(rsltsFormatDec181f,
    [sysDischarge / Rslts.numYrsSimulated]) + '   ' + Format(rsltsFormatDec181f,
    [areaFactor * sysDischarge / Rslts.numYrsSimulated]));
  S.Add('  Percolation to Groundwater    ' + Format(rsltsFormatDec181f,
    [percoltn / Rslts.numYrsSimulated]) + '   ' + Format(rsltsFormatDec181f,
    [areaFactor * percoltn / Rslts.numYrsSimulated]));
  S.Add('  Continuity Error..........    ' + Format(rsltsFormatDec170f,
    [(100 * (precip - (sysDischarge + percoltn + et)) / precip)]) + '%');
  { S.Add('  Percent Surface Runoff....    ' + Format(rsltsFormatDec181f,
    [100 * Rslts.runCoeff]) + '%'); }
  S.Add('  Percent Surface Runoff....    ' + Format(rsltsFormatDec170f,
    [100 * sysDischarge / precip]) + '%');
  S.Add(' ');
  S.Add(' ');

  S.Add('Average Annual Surface Loading');
  S.Add('------------------------------');
  S.Add(' ');
  tempStr := Format(rsltsFormatStrLft, ['Name']) + Format(rsltsFormatStrRgt,
    ['Volume(ac-ft/yr)']);
  for I := 0 to Project.PollutNames.Count - 1 do
  begin
    if ((mode = 0) and ((I = 0) or (I = 3) or (I = 5))) then
      // skip TSS,SRP,DIN
    else
      tempStr := tempStr + Format(rsltsFormatStrRgt,
        [Project.PollutNames[I] + '(lbs/yr)']);
  end;
  S.Add(tempStr);
  if (mode = 0) then
    S.Add('--------------------       ----------------       -----------       -----------        ----------')
  else
    S.Add('--------------------       ----------------       -----------       -----------        ----------       -----------        ----------       -----------');

  tempList := getOutfallStatSummary(Rslts.outfallLoads, mode);
  S.Add(tempList.Text);
  S.Add('');
  S.SaveToFile(filePath);
  S.Free;
  OutfallLines.Free;
end;

end.
