unit GSGdal;

{ Declarations of imported procedures from the GDALL C Api from GDAL DLL }
{ (Gdal.DLL) }

interface

uses
  SysUtils, Forms, Dialogs, Generics.Collections,
  Classes, gdal, gdalcore, ogr, UProject, GSUtils, GSTypes, GSCatchments, GSIO,
  GSPLRM;

type
  TGSAreaWTObj = class
    // used to calculate percent of item area over parent area
    parentTotArea: Double;
    // used in calcs to temporarily hold sums during area / length weighting etc
    tempAccumulation: Double;
    // used to accumulate geometry areas during area weighting allows check with actual area
    tempTotalArea: Double;
    // used to accumulate geometry lengths for road shoulder erosion and connectivity
    tempTotalLength: Double;
    // used to hold calculated area weighted value temporarily before assigning to actual property
    tempWeightedVal: Double;
    // % percent of this variables area as a fraction of total catchment area
    percentOfTotalCatch: Double;
  end;

  TGISCatch = class
    id: String;
    aveSlope: Double;

    totalCatchArea: Double;
    totalSlopeArea: Double;
    totalLuseArea: Double; // total landuse coverage area
    totalSoilsArea: Double; // total soils coverage area
    totalRdShdLength: Double; // sum of all road shoulder lengths for catchment
    totalRdConnLength: Double; // sum all road connectivity lengths
    totalRdConditionLength: Double; // sum all road condition lenghths
    // sum of all road connectivity lengths for catchment

    luseDict: TDictionary<String, TGSAreaWTObj>;
    rdShouldersDict: TDictionary<String, TGSAreaWTObj>;
    rdConditionDict: TDictionary<String, TGSAreaWTObj>;
    rdConnDict: TDictionary<String, TGSAreaWTObj>;
    soilsDict: TDictionary<String, TGSAreaWTObj>;

    // used in calcs to temporarily hold sums during area weighting etc
    tempAccumulation: Double;
    // used to accumulate geometry areas during area weighting allows check with actual area
    tempTotalArea: Double;
    // used to accumulate geometry lengths for road shoulder erosion and connectivity
    tempTotalLength: Double;
    // used to hold calculated area weighted value temporarily before assigning to actual property
    tempWeightedVal: Double;
    // needed to temporarily hold area-weighted variables with multiple possible values per catchment such as land use
    TempAreaWTDict: TDictionary<String, TGSAreaWTObj>;
  end;

const
  GISAREACONV = 1 / 43560; // conversions for geom area to acres
  shpExt: String = '.shp';
  minSlope: Double = 0.1;
  shpExts: array [0 .. 4] of string = ('.shp', '.shx', '.prj', '.dbf', '.sbn');

  catchDSName = 'PLRM_Catchments';
  bmpsDSName = 'PLRM_BMPs';
  luseDSName = 'PLRM_LandUse';
  slopeDSName = 'PLRM_Slope';
  soilsDSName = 'PLRM_Soils';
  rdCondDSName = 'PLRM_RoadCondition';
  rdShdlrErosionDSName = 'PLRM_ShoulderErosion';
  rdRunoffConnDSName = 'PLRM_RunoffConnectivity';

  fldNameCatch = 'NAME';
  fldNameCatchArea = 'Acres';
  fldNameSlope = 'SLOPE';
  fldNameLuseCode = 'LU_ID';
  fldNameSoilCode = 'SOIL_ID';
  fldNameRdShoulder = 'SHOULDER';
  fldNameRdCondition = 'SCORE';
  fldNameRdConn = 'CONNECT';

  intcatchSlope = 'PLRM_CatchSlopes';
  intcatchLuse = 'PLRM_CatchLuses';
  intcatchSoil = 'PLRM_CatchSoils';
  intcatchRdShd = 'PLRM_CatchShlds';
  intcatchRdCondition = 'PLRM_CatchCond';
  intcatchRdConn = 'PLRM_CatchConn';

  layerNum = 0;
  driverName = 'ESRI Shapefile';

function runGISOps(): Boolean;
function getAreaWeightedTable(var catchDict: TDictionary<String, TGISCatch>;
  shpFilePath: String; catchNameFld: String; propNameFld: String): Boolean;
function getAreaWeightedTableLuse(var catchDict: TDictionary<String, TGISCatch>;
  shpFilePath: String; catchNameFld: String; propNameFld: String): Boolean;
function lengthWeigthRoads(var catchDict: TDictionary<String, TGISCatch>;
  shpFilePath: String; catchNameFld: String; propNameFld: String): Boolean;
function getLayer(shpFilePath: String): OGRLayerH;
function createPLRMCatchmentObjs(CDict: TDictionary<String, TGISCatch>)
  : Boolean;

procedure intersectShapeFilesAsLayers(shp1FilePath: String;
  shp2FilePath: String; outShpFilePath: String;
  resultShpFileType: OGRwkbGeometryType);

function updateCatchObjLuse(tempCatch: TGISCatch;
  var NewCatch: TPLRMCatch): Boolean;
function updateCatchObjRdShoulders(tempCatch: TGISCatch;
  var NewCatch: TPLRMCatch): Boolean;
function updateCatchObjRdCondition(tempCatch: TGISCatch;
  var NewCatch: TPLRMCatch): Boolean;

implementation

var
  luseDBData, luseShpCodes, soilMUCodes: dbReturnFields;

function processCatchments(dir: String;
  CDict: TDictionary<String, TGISCatch>): Boolean;
var
  flag: Boolean;
  tempKey: String;
  tempCatch: TGISCatch;
begin
  flag := getAreaWeightedTable(CDict, dir + catchDSName + shpExt, fldNameCatch,
    fldNameCatchArea);
  // calculation was successful if flag is true so set ave slope prop of each catchment
  if (flag) then
    for tempKey in CDict.Keys do
    begin
      if (CDict.Items[tempKey] is TGISCatch and assigned(CDict.Items[tempKey]))
      then
      begin
        tempCatch := CDict.Items[tempKey];
        CDict.Items[tempKey].totalCatchArea := tempCatch.tempTotalArea;
        tempCatch.tempTotalArea := 0;
        // IMPORTANT free dict below for next set of intersections and calcs
        FreeAndNil(tempCatch.TempAreaWTDict);
      end;
    end;
  Result := flag;
end;

function processSlopes(dir: String;
  CDict: TDictionary<String, TGISCatch>): Boolean;
var
  flag: Boolean;
  tempKey: String;
  tempCatch: TGISCatch;
begin
  intersectShapeFilesAsLayers(dir + catchDSName + shpExt,
    dir + slopeDSName + shpExt, dir + intcatchSlope + shpExt,
    OGRwkbGeometryType.wkbPolygon);

  flag := getAreaWeightedTable(CDict, dir + intcatchSlope + shpExt,
    fldNameCatch, fldNameSlope);
  // calculation was successful if flag is true so set ave slope prop of each catchment
  if (flag) then
    for tempKey in CDict.Keys do
    begin
      if (CDict.Items[tempKey] is TGISCatch) then
      begin
        tempCatch := CDict.Items[tempKey];
        if (tempCatch.tempWeightedVal < minSlope) then
          tempCatch.tempWeightedVal := minSlope;
        CDict.Items[tempKey].aveSlope := tempCatch.tempWeightedVal;
        CDict.Items[tempKey].totalSlopeArea := tempCatch.tempTotalArea;
        // IMPORTANT free dict below for next set of intersections and calcs
        FreeAndNil(tempCatch.TempAreaWTDict);
      end;
    end;
  Result := flag;
end;

// mode = 0 > land uses
// mode = 1 > soils
function processLusesOrSoils(dir: String; CDict: TDictionary<String, TGISCatch>;
  sourceDSName: String; rsltShpName: String; fldNameVar: String;
  mode: Integer): Boolean;
var
  flag: Boolean;
  tempKey: String;
  tempCatch: TGISCatch;
begin
  intersectShapeFilesAsLayers(dir + catchDSName + shpExt,
    dir + sourceDSName + shpExt, dir + rsltShpName + shpExt,
    OGRwkbGeometryType.wkbPolygon);

  flag := getAreaWeightedTableLuse(CDict, dir + rsltShpName + shpExt,
    fldNameCatch, fldNameVar);

  // calculation was successful if flag is true so copy tempdict to lusedict of each catchment
  if (flag) then
    for tempKey in CDict.Keys do
      if (CDict.Items[tempKey] is TGISCatch) then
      begin
        tempCatch := CDict.Items[tempKey];
        if (mode = 0) then
        begin
          tempCatch.luseDict := TDictionary<String, TGSAreaWTObj>.Create
            (tempCatch.TempAreaWTDict);
          tempCatch.totalLuseArea := tempCatch.tempTotalArea;
          tempCatch.tempTotalArea := 0;
        end
        else
        begin
          tempCatch.soilsDict := TDictionary<String, TGSAreaWTObj>.Create
            (tempCatch.TempAreaWTDict);
          tempCatch.totalSoilsArea := tempCatch.tempTotalArea;
          tempCatch.tempTotalArea := 0;
        end;
        // IMPORTANT free dict below for next set of intersections and calcs
        FreeAndNil(tempCatch.TempAreaWTDict);
      end;
  Result := flag;
end;

function processRdShoulders(dir: String;
  CDict: TDictionary<String, TGISCatch>): Boolean;
var
  flag: Boolean;
  tempKey: String;
  tempCatch: TGISCatch;
begin
  intersectShapeFilesAsLayers(dir + catchDSName + shpExt,
    dir + rdShdlrErosionDSName + shpExt, dir + intcatchRdShd + shpExt,
    OGRwkbGeometryType.wkbLineString);

  flag := lengthWeigthRoads(CDict, dir + intcatchRdShd + shpExt, fldNameCatch,
    fldNameRdShoulder);

  // calculation was successful if flag is true so copy tempdict to rdShouldersDict of each catchment
  if (flag) then
    for tempKey in CDict.Keys do
      if (CDict.Items[tempKey] is TGISCatch) then
      begin
        tempCatch := CDict.Items[tempKey];
        if (assigned(tempCatch.TempAreaWTDict)) then
        begin
          tempCatch.rdShouldersDict := TDictionary<String, TGSAreaWTObj>.Create
            (tempCatch.TempAreaWTDict);
          tempCatch.totalRdShdLength := tempCatch.tempTotalLength;
          // IMPORTANT free dict below and reset other vars for next set of intersections and calcs
          FreeAndNil(tempCatch.TempAreaWTDict);
          tempCatch.tempTotalLength := 0;
        end;
      end;
  Result := flag;
end;

function processRdCondition(dir: String;
  CDict: TDictionary<String, TGISCatch>): Boolean;
var
  flag: Boolean;
  tempKey: String;
  tempCatch: TGISCatch;
begin
  intersectShapeFilesAsLayers(dir + catchDSName + shpExt,
    dir + rdCondDSName + shpExt, dir + intcatchRdCondition + shpExt,
    OGRwkbGeometryType.wkbLineString);

  flag := lengthWeigthRoads(CDict, dir + intcatchRdCondition + shpExt,
    fldNameCatch, fldNameRdCondition);
  // calculation was successful if flag is true so copy tempdict to lusedict of each catchment
  if (flag) then
    for tempKey in CDict.Keys do
      if (CDict.Items[tempKey] is TGISCatch) then
      begin
        tempCatch := CDict.Items[tempKey];
        if (assigned(tempCatch.TempAreaWTDict)) then
        begin
          tempCatch.rdConditionDict := TDictionary<String, TGSAreaWTObj>.Create
            (tempCatch.TempAreaWTDict);
          tempCatch.totalRdConditionLength := tempCatch.tempTotalLength;

          // IMPORTANT free dict below and reset other vars for next set of intersections and calcs
          FreeAndNil(tempCatch.TempAreaWTDict);
          tempCatch.tempTotalLength := 0;
        end;
      end;
  Result := flag;
end;

function processRdConnectivity(dir: String;
  CDict: TDictionary<String, TGISCatch>): Boolean;
var
  flag: Boolean;
  tempKey: String;
  tempCatch: TGISCatch;
begin
  intersectShapeFilesAsLayers(dir + catchDSName + shpExt,
    dir + rdRunoffConnDSName + shpExt, dir + intcatchRdConn + shpExt,
    OGRwkbGeometryType.wkbLineString);

  flag := lengthWeigthRoads(CDict, dir + intcatchRdConn + shpExt, fldNameCatch,
    fldNameRdConn);
  // calculation was successful if flag is true so copy tempdict to lusedict of each catchment
  if (flag) then
    for tempKey in CDict.Keys do
      if (CDict.Items[tempKey] is TGISCatch) then
      begin
        tempCatch := CDict.Items[tempKey];
        if (assigned(tempCatch.TempAreaWTDict)) then
        begin
          tempCatch.rdConnDict := TDictionary<String, TGSAreaWTObj>.Create
            (tempCatch.TempAreaWTDict);
          tempCatch.totalRdConnLength := tempCatch.tempTotalLength;

          // IMPORTANT free dict below and reset other vars for next set of intersections and calcs
          FreeAndNil(tempCatch.TempAreaWTDict);
          tempCatch.tempTotalLength := 0;
        end;
      end;
  Result := flag;
end;

function runGISOps(): Boolean;
var
  // tempKey: String;
  dir: String;
  CDict: TDictionary<String, TGISCatch>;
  // flag: Boolean;
  // tempCatch: TGISCatch;
begin
  shpExt := '.shp';
  dir := defaultGISDir + '\';
  // Step 0: Validate layers

  // Step 1: Calc catchment areas
  // *******************************************
  // Create dict to hold catchment properties
  CDict := TDictionary<String, TGISCatch>.Create;
  processCatchments(dir, CDict);

  // Step 2: Catchment average slopes
  // *******************************************
  // Intersect catchment layer and slopes layer and calc area-weighted slope by catchment
  processSlopes(dir, CDict);

  // Step 3: Catchment land uses
  // *******************************************
  // Intersect catchment layer and landuse layer and calc area-weighted landuse by catchment
  processLusesOrSoils(dir, CDict, luseDSName, intcatchLuse, fldNameLuseCode, 0);

  // Step 4: Catchment soils
  // *******************************************
  // Intersect catchment layer and soils layer and calc area-weighted soils by catchment
  processLusesOrSoils(dir, CDict, soilsDSName, intcatchSoil,
    fldNameSoilCode, 1);

  // Step 5: Road shoulders
  // *******************************************
  // Intersect catchment layer and road shoulders layer and calc lengths of each kind of shoulder
  processRdShoulders(dir, CDict);

  // Step 6: Road condition
  // *******************************************
  // Intersect catchment layer and road conditions layer and calc lengths of each kind of condition
  processRdCondition(dir, CDict);

  // Step 7: Road connectivity
  // *******************************************
  // Intersect catchment layer and road runoff connectivity layer and calc lengths of each kind of connectivity
  processRdConnectivity(dir, CDict);
  createPLRMCatchmentObjs(CDict);

  Result := True;
end;

function updateCatchObjLuse(tempCatch: TGISCatch;
  var NewCatch: TPLRMCatch): Boolean;
var
  rsltArry, tempArry: PLRMGridData;
  tempArryVals: PLRMGridDataDbl;
  I, tempInt: Integer;
  tempVarKey: String;
  areaWTObj: TGSAreaWTObj;
begin
  if (assigned(tempCatch.luseDict)) then
  begin
    SetLength(tempArry, luseDBData[0].Count, 4);
    SetLength(tempArryVals, luseDBData[0].Count, 4);
    I := 0;
    for tempVarKey in tempCatch.luseDict.Keys do
    begin
      if (tempCatch.luseDict.Items[tempVarKey] is TGSAreaWTObj and
        assigned(tempCatch.luseDict.Items[tempVarKey])) then
      begin
        // look up shapefile luse code
        // tempInt := shpLuseCodesList.IndexOf(tempVarKey);
        tempInt := luseShpCodes[0].IndexOf(tempVarKey);

        if tempInt <> -1 then
        begin
          areaWTObj := tempCatch.luseDict.Items[tempVarKey];
          // translate shapefile luse code into plrm land use label and find index of landuse
          tempInt := luseDBData[0].IndexOf(luseShpCodes[1][tempInt]);
          if tempInt <> -1 then
          begin
            areaWTObj.percentOfTotalCatch := 100 * areaWTObj.tempAccumulation /
              tempCatch.totalLuseArea;
            tempArry[tempInt, 0] := luseDBData[0][tempInt]; // label
            tempArry[tempInt, 2] := luseDBData[1][tempInt]; // %imp
            tempArryVals[tempInt, 1] := tempArryVals[tempInt, 1] +
              areaWTObj.percentOfTotalCatch; // %catch
            tempArryVals[tempInt, 3] := tempCatch.totalCatchArea * tempArryVals
              [tempInt, 1];
            inc(I);
          end;
        end;
      end;
    end;
    // copy land use data to catchment object
    SetLength(rsltArry, I, 4);
    tempInt := 0;
    for I := 0 to High(tempArry) do
      if (tempArry[I, 0] <> '') then
      begin
        rsltArry[tempInt, 0] := tempArry[I, 0]; // label
        rsltArry[tempInt, 1] := FormatFloat(TWODP, tempArryVals[I, 1]);
        rsltArry[tempInt, 2] := tempArry[I, 2]; // %imp
        rsltArry[tempInt, 3] := FormatFloat(TWODP, tempArryVals[I, 3]);;
        inc(tempInt);
      end;
    SetLength(rsltArry, tempInt, 4);
    // NewCatch.othrArea := tempOthrPercent * NewCatch.area;
    NewCatch.othrArea := 0;
    NewCatch.othrPrcntToOut := 100;
    NewCatch.othrPrcntImpv := 0;
    NewCatch.landUseData := rsltArry;
  end;
  Result := True;
end;

// saves soils to catchment obj
function updateCatchObjSoils(tempCatch: TGISCatch;
  var NewCatch: TPLRMCatch): Boolean;
var
  rsltArry, tempArry: PLRMGridData;
  tempArryVals: PLRMGridDataDbl;
  I, tempInt, numSoilTblCols: Integer;
  tempVarKey: String;
  areaWTObj: TGSAreaWTObj;
begin
  numSoilTblCols := 3;
  soilMUCodes := GSIO.lookUpValFrmTable(23, 0, 1);

  if (assigned(tempCatch.soilsDict)) then
  begin
    SetLength(tempArry, luseDBData[0].Count, numSoilTblCols);
    SetLength(tempArryVals, luseDBData[0].Count, numSoilTblCols);
    I := 0;
    for tempVarKey in tempCatch.soilsDict.Keys do
    begin
      if (tempCatch.soilsDict.Items[tempVarKey] is TGSAreaWTObj and
        assigned(tempCatch.soilsDict.Items[tempVarKey])) then
      begin
        // look up shapefile soil mu code
        tempInt := soilMUCodes[0].IndexOf(tempVarKey);

        if tempInt <> -1 then
        begin
          areaWTObj := tempCatch.soilsDict.Items[tempVarKey];
          areaWTObj.percentOfTotalCatch := 100 * areaWTObj.tempAccumulation /
            tempCatch.totalSoilsArea;
          tempArry[I, 0] := soilMUCodes[0][tempInt] + '-' + soilMUCodes[1]
            [tempInt]; // label
          tempArryVals[I, 1] := tempArryVals[I, 1] +
            areaWTObj.percentOfTotalCatch; // %catch
          tempArryVals[I, 2] := tempCatch.totalCatchArea * tempArryVals[I, 1];
          inc(I);
        end;
      end;
    end;
    // copy soils data to catchment object
    SetLength(rsltArry, I, numSoilTblCols);
    tempInt := 0;
    for I := 0 to High(tempArry) do
      if (tempArry[I, 0] <> '') then
      begin
        rsltArry[tempInt, 0] := tempArry[I, 0]; // label
        // %catch
        rsltArry[tempInt, 1] := FormatFloat(TWODP, tempArryVals[I, 1]);
        // acres
        rsltArry[tempInt, 2] := FormatFloat(TWODP, tempArryVals[I, 2]);
        inc(tempInt);
      end;
    SetLength(rsltArry, tempInt, numSoilTblCols);
    NewCatch.soilsMapUnitData := rsltArry;
  end;
  Result := True;
end;

// saves road condition to catchment obj
function updateCatchObjRdCondition(tempCatch: TGISCatch;
  var NewCatch: TPLRMCatch): Boolean;
var
  rsltArry: PLRMGridData;
  tempArryVals: PLRMGridDataDbl;
  I, J, tempInt, numTblCols: Integer;
  tempVarKey: String;
  areaWTObj: TGSAreaWTObj;
  rdCondStates: TArray<string>;
  rdCondStateList: TStringList;
begin
  numTblCols := 2;
  I := 0;
  if (assigned(tempCatch.rdConditionDict)) then
  begin
    SetLength(tempArryVals, tempCatch.rdConditionDict.Count, numTblCols);
    for tempVarKey in tempCatch.rdConditionDict.Keys do
    begin
      if (tempCatch.rdConditionDict.Items[tempVarKey] is TGSAreaWTObj and
        assigned(tempCatch.rdConditionDict.Items[tempVarKey])) then
      begin
        areaWTObj := tempCatch.rdConditionDict.Items[tempVarKey];

        if (tempCatch.totalRdConditionLength = 0) then
          areaWTObj.percentOfTotalCatch := 0
        else
          areaWTObj.percentOfTotalCatch := 100 * areaWTObj.tempWeightedVal /
            tempCatch.totalRdConditionLength;

        tempArryVals[I, 0] := areaWTObj.percentOfTotalCatch;
        tempArryVals[I, 1] := StrToFloat(tempVarKey);
        inc(I);
      end;
    end;
  end;
  // copy data to string array and save on object
  SetLength(rsltArry, I, numTblCols);
  tempInt := 0;
  for I := 0 to I - 1 do
    for J := 0 to numTblCols - 1 do
      rsltArry[I, J] := FormatFloat(TWODP, tempArryVals[I, J]);

  NewCatch.frm4of6SgRoadConditionData := rsltArry;
  Result := True;
end;

// saves road connectivity to catchment obj
function updateCatchObjRdConnectivity(tempCatch: TGISCatch;
  var NewCatch: TPLRMCatch): Boolean;
var
  rsltArry, tempArry: PLRMGridData;
  // tempArryVals: PLRMGridDataDbl;
  I, J, tempInt, numTblCols: Integer;
  tempVarKey: String;
  areaWTObj: TGSAreaWTObj;
  rdCondStates: TArray<string>;
  rdCondStateList: TStringList;
  tData: GSRoadDrainageInput;
begin
  numTblCols := 2;
  I := 0;
  if (assigned(tempCatch.rdConnDict)) then
  begin
    SetLength(tempArry, tempCatch.rdConnDict.Count, numTblCols);
    for tempVarKey in tempCatch.rdConnDict.Keys do
    begin
      if (tempCatch.rdConnDict.Items[tempVarKey] is TGSAreaWTObj and
        assigned(tempCatch.rdConnDict.Items[tempVarKey])) then
      begin
        areaWTObj := tempCatch.rdConnDict.Items[tempVarKey];

        if (tempCatch.totalRdConnLength = 0) then
          areaWTObj.percentOfTotalCatch := 0
        else
          areaWTObj.percentOfTotalCatch := 100 * areaWTObj.tempWeightedVal /
            tempCatch.totalRdConnLength;

        // tempArry[I, 0] := FormatFloat(TWODP, areaWTObj.percentOfTotalCatch);
        // tempArry[I, 1] := tempVarKey;
        if (tempVarKey = 'DCIA') then
          tData.DCIA := areaWTObj.percentOfTotalCatch
        else
          tData.ICIA := areaWTObj.percentOfTotalCatch;
        inc(I);
      end;
    end;
  end;
  // copy data to string array and save on object
  SetLength(rsltArry, I, numTblCols);
  tempInt := 0;
  for I := 0 to I - 1 do
    for J := 0 to numTblCols - 1 do
      rsltArry[I, J] := tempArry[I, J];

  tData.DINF := 0;
  tData.INFFacility.totSurfaceArea := 0;
  tData.INFFacility.totStorage := 0;
  tData.INFFacility.aveAnnInfiltrationRate := 0.5;
  tData.DPCH := 1;
  tData.PervChanFacility.length := 0;
  tData.PervChanFacility.width := 0;
  tData.PervChanFacility.aveSlope := 1;
  tData.PervChanFacility.storageDepth := 0;
  tData.PervChanFacility.aveAnnInfiltrationRate := 0.5;
  tData.isAssigned := True;

  NewCatch.frm5of6RoadDrainageEditorData := tData;
  Result := True;
end;

// saves road shoulders to catchment obj
function updateCatchObjRdShoulders(tempCatch: TGISCatch;
  var NewCatch: TPLRMCatch): Boolean;
var
  rsltArry: PLRMGridData;
  tempArryVals: PLRMGridDataDbl;
  I, J, tempInt, numTblCols, numTblRows: Integer;
  tempVarKey: String;
  areaWTObj: TGSAreaWTObj;
  rdCondStates: TArray<string>;
  rdCondStateList: TStringList;
begin
  numTblCols := 4;
  numTblRows := 1;
  // save in order presented in user grid on frm4of6
  rdCondStates := TArray<string>.Create('Erodible', 'Protected',
    'Stable & Protected', 'Stable');
  rdCondStateList := TStringList.Create;
  rdCondStateList.AddStrings(rdCondStates);

  if (assigned(tempCatch.rdShouldersDict)) then
  begin
    SetLength(tempArryVals, numTblRows, numTblCols);
    for tempVarKey in tempCatch.rdShouldersDict.Keys do
    begin
      if (tempCatch.rdShouldersDict.Items[tempVarKey] is TGSAreaWTObj and
        assigned(tempCatch.rdShouldersDict.Items[tempVarKey])) then
      begin
        // look up shapefile road condition code's index to determine position to save corresponding percentage
        tempInt := rdCondStateList.IndexOf(tempVarKey);

        if tempInt <> -1 then
        begin
          areaWTObj := tempCatch.rdShouldersDict.Items[tempVarKey];
          areaWTObj.percentOfTotalCatch := 100 * areaWTObj.tempWeightedVal /
            tempCatch.totalRdShdLength;
          tempArryVals[0, tempInt] := areaWTObj.percentOfTotalCatch;
          // %coverage
        end;
      end;
    end;
    // copy data to string array and save on object
    SetLength(rsltArry, numTblRows, numTblCols);
    tempInt := 0;
    for I := 0 to numTblRows - 1 do
      for J := 0 to numTblCols - 1 do
        rsltArry[I, J] := FormatFloat(TWODP, tempArryVals[I, J]);

    NewCatch.frm4of6SgRoadShoulderData := rsltArry;
  end;
  Result := True;
end;

function createPLRMCatchmentObjs(CDict: TDictionary<String, TGISCatch>)
  : Boolean;
var
  I: Integer;
  tempKey, gisXMLFilePath: String;
  tempCatch: TGISCatch;
  NewCatch: TPLRMCatch;
  catchList, tempFrmLusesList: TStringList;
begin

  catchList := TStringList.Create;
  tempFrmLusesList := TStringList.Create;

  for I := 0 to High(frmsLuses) do
    tempFrmLusesList.Add(frmsLuses[I]);

  // luseLblList := GSIO.getCodes('1%');
  luseDBData := GSIO.lookUpValFrmTable(18, 2, 3);
  luseShpCodes := GSIO.lookUpValFrmTable(22, 0, 2);

  for tempKey in CDict.Keys do
    if (CDict.Items[tempKey] is TGISCatch) then
    begin
      tempCatch := CDict.Items[tempKey];
      NewCatch := TPLRMCatch.Create;
      NewCatch.ObjIndex := -1;
      NewCatch.ObjType := SUBCATCH;
      NewCatch.name := tempCatch.id;
      NewCatch.hasDefLuse := True;
      NewCatch.hasDefSoils := True;
      NewCatch.hasDefRoadPolls := False;
      NewCatch.hasDefRoadDrainage := False;
      NewCatch.hasDefParcelAndDrainageBMPs := False;
      NewCatch.hasDefCustomBMPSizeData := False;
      NewCatch.area := tempCatch.totalCatchArea;
      NewCatch.slope := tempCatch.aveSlope;

      // 1. save landuses to catchObj
      updateCatchObjLuse(tempCatch, NewCatch);

      // 2. save soils to catchObj
      updateCatchObjSoils(tempCatch, NewCatch);

      // 3. save road shoulders to catchObj
      updateCatchObjRdShoulders(tempCatch, NewCatch);

      // 4. save road condition to catchObj
      updateCatchObjRdCondition(tempCatch, NewCatch);

      // 5. save road connectivity to catchObj
      updateCatchObjRdConnectivity(tempCatch, NewCatch);

      NewCatch.othrArea := 0;
      catchList.AddObject(tempKey, NewCatch);
    end;
  gisXMLFilePath := defaultEngnDir + '\GIS.xml';
  PLRMObj.plrmGISToXML(catchList, gisXMLFilePath);

  catchList.Free;
  Result := True;
end;

// computes area weighted average of a single field with multiple possible values such as catchment landuses
function lengthWeigthRoads(var catchDict: TDictionary<String, TGISCatch>;
  shpFilePath: String; catchNameFld: String; propNameFld: String): Boolean;
var
  ogrLayer: OGRLayerH;
  feat: OGRFeatureH;
  geom: OGRGeometryH;
  catchFldIdx, propCodeFldIdx: longint;
  catchName, propCode: String;
  tempLength: Double;
  tempCatch: TGISCatch;
  tDict: TDictionary<String, TGSAreaWTObj>;
  tempAreaWTObj: TGSAreaWTObj;
begin

  ogrLayer := getLayer(shpFilePath);

  feat := OGR_L_GetNextFeature(ogrLayer);
  catchFldIdx := OGR_F_GetFieldIndex(feat, PAnsiChar(AnsiString(catchNameFld)));
  propCodeFldIdx := OGR_F_GetFieldIndex(feat,
    PAnsiChar(AnsiString(propNameFld)));

  Repeat
    geom := OGR_F_GetGeometryRef(feat);

    if (geom <> nil) then
    begin
      catchName := String(OGR_F_GetFieldAsString(feat, catchFldIdx));
      propCode := String(OGR_F_GetFieldAsString(feat, propCodeFldIdx));
      geom := OGR_F_GetGeometryRef(feat);
      tempLength := OGR_G_Length(geom);

      // Try looking up current catchment.
      if catchDict.ContainsKey(catchName) then
      begin
        if (catchDict.TryGetValue(catchName, tempCatch) = True) then
        begin
          if tempCatch.id = '' then
            tempCatch.id := catchName;

          if (not(assigned(tempCatch.TempAreaWTDict))) then
          begin
            tempCatch.TempAreaWTDict :=
              TDictionary<String, TGSAreaWTObj>.Create;
          end;
          tDict := tempCatch.TempAreaWTDict;
          if tDict.ContainsKey(propCode) then
          begin
            if (tDict.TryGetValue(propCode, tempAreaWTObj) = True) then
            begin
              // accumulate total parent area - in this case parent is individual catchment containing this landuse
              tempCatch.tempTotalLength := tempCatch.tempTotalLength +
                tempLength;

              // accumulate total area for this variable e.g. SFR sliver
              tempAreaWTObj.tempTotalLength := tempAreaWTObj.tempTotalLength +
                tempLength;
              tempAreaWTObj.tempAccumulation := tempAreaWTObj.tempTotalLength;
              tempAreaWTObj.tempWeightedVal := tempAreaWTObj.tempTotalLength;
            end;
          end
          else
          begin
            tempAreaWTObj := TGSAreaWTObj.Create;
            tempAreaWTObj.tempTotalLength := tempLength;
            tempAreaWTObj.tempAccumulation := tempLength;
            tempAreaWTObj.tempWeightedVal := 0;
            tempCatch.tempTotalLength := tempCatch.tempTotalLength + tempLength;
            tDict.Add(propCode, tempAreaWTObj);
          end;
        end
      end
      else
      begin
        tempCatch := TGISCatch.Create;
        tempCatch.id := catchName;
        tempCatch.TempAreaWTDict := TDictionary<String, TGSAreaWTObj>.Create;
        tempCatch.tempTotalLength := tempLength;
        tempCatch.tempAccumulation := tempLength;
        tempCatch.tempWeightedVal := 0;
        catchDict.Add(catchName, tempCatch);
      end;
    end;

    feat := OGR_L_GetNextFeature(ogrLayer);
  until feat = nil;
  Result := True;
end;

// computes area weighted average of a single field with multiple possible values such as catchment landuses
function getAreaWeightedTableLuse(var catchDict: TDictionary<String, TGISCatch>;
  shpFilePath: String; catchNameFld: String; propNameFld: String): Boolean;
var
  ogrLayer: OGRLayerH;
  feat: OGRFeatureH;
  geom: OGRGeometryH;
  catchFldIdx, propCodeFldIdx: longint;
  catchName, propCode: String;
  tempArea: Double;
  tempCatch: TGISCatch;
  tempAreaWTObj: TGSAreaWTObj;
begin

  ogrLayer := getLayer(shpFilePath);

  feat := OGR_L_GetNextFeature(ogrLayer);
  catchFldIdx := OGR_F_GetFieldIndex(feat, PAnsiChar(AnsiString(catchNameFld)));
  propCodeFldIdx := OGR_F_GetFieldIndex(feat,
    PAnsiChar(AnsiString(propNameFld)));

  Repeat
    geom := OGR_F_GetGeometryRef(feat);

    if (geom <> nil) then
    begin
      catchName := String(OGR_F_GetFieldAsString(feat, catchFldIdx));
      propCode := String(OGR_F_GetFieldAsString(feat, propCodeFldIdx));
      geom := OGR_F_GetGeometryRef(feat);
      tempArea := OGR_G_GetArea(geom) * GISAREACONV;

      // Try looking up current catchment.
      if catchDict.ContainsKey(catchName) then
      begin
        if (catchDict.TryGetValue(catchName, tempCatch) = True) then
        begin
          if tempCatch.id = '' then
            tempCatch.id := catchName;

          if (not(assigned(tempCatch.TempAreaWTDict))) then
          begin
            tempCatch.TempAreaWTDict :=
              TDictionary<String, TGSAreaWTObj>.Create;
          end;
          // tDict := tempCatch.TempAreaWTDict;

          if tempCatch.TempAreaWTDict.ContainsKey(propCode) then
          begin
            if (tempCatch.TempAreaWTDict.TryGetValue(propCode, tempAreaWTObj)
              = True) then
            begin
              // accumulate total parent area - in this case parent is individual catchment containing this landuse
              tempCatch.tempTotalArea := tempCatch.tempTotalArea + tempArea;

              // accumulate total area for this variable e.g. SFR sliver
              tempAreaWTObj.tempTotalArea := tempCatch.tempTotalArea;
              tempAreaWTObj.tempAccumulation := tempCatch.tempTotalArea;
              tempAreaWTObj.tempWeightedVal := tempCatch.tempTotalArea;
            end;
          end
          else
          begin
            tempCatch.tempTotalArea := tempCatch.tempTotalArea + tempArea;

            // if (assigned(tempAreaWTObj)) then
            // tempAreaWTObj.Free;

            tempAreaWTObj := TGSAreaWTObj.Create;
            tempAreaWTObj.tempTotalArea := tempArea;
            tempAreaWTObj.tempAccumulation := tempArea;
            tempAreaWTObj.tempWeightedVal := 0;
            tempCatch.TempAreaWTDict.Add(propCode, tempAreaWTObj);
          end;

        end
      end
      else
      begin
        // if (assigned(tempCatch)) then
        // tempCatch.Free;

        tempCatch := TGISCatch.Create;
        tempCatch.id := catchName;
        tempCatch.TempAreaWTDict := TDictionary<String, TGSAreaWTObj>.Create;
        tempCatch.tempTotalArea := tempArea;
        tempCatch.tempAccumulation := tempArea;
        tempCatch.tempWeightedVal := 0;
        catchDict.Add(catchName, tempCatch);
      end;
    end;
    feat := OGR_L_GetNextFeature(ogrLayer);
  until feat = nil;
  Result := True;
end;

// computes area weighted average of a single field  e.g. catchment slope
function getAreaWeightedTable(var catchDict: TDictionary<String, TGISCatch>;
  shpFilePath: String; catchNameFld: String; propNameFld: String): Boolean;
var
  ogrLayer: OGRLayerH;
  feat: OGRFeatureH;
  geom: OGRGeometryH;
  catchFldIdx, propFldIdx: longint;
  catchName, tempKey: String;
  propVal, tempArea: Double;
  tempCatch: TGISCatch;
begin

  ogrLayer := getLayer(shpFilePath);

  feat := OGR_L_GetNextFeature(ogrLayer);
  catchFldIdx := OGR_F_GetFieldIndex(feat, PAnsiChar(AnsiString(catchNameFld)));
  propFldIdx := OGR_F_GetFieldIndex(feat, PAnsiChar(AnsiString(propNameFld)));

  Repeat
    geom := OGR_F_GetGeometryRef(feat);

    if (geom <> nil) then
    begin
      catchName := String(OGR_F_GetFieldAsString(feat, catchFldIdx));
      propVal := OGR_F_GetFieldAsDouble(feat, propFldIdx);
      geom := OGR_F_GetGeometryRef(feat);
      tempArea := OGR_G_GetArea(geom) * GISAREACONV;

      // Try looking up current catchment.
      if catchDict.ContainsKey(catchName) then
      begin
        if (catchDict.TryGetValue(catchName, tempCatch) = True) then
        begin
          tempCatch.id := catchName;
          tempCatch.tempTotalArea := tempCatch.tempTotalArea + tempArea;
          tempCatch.tempAccumulation := tempCatch.tempAccumulation + tempArea
            * propVal
        end
      end
      else
      begin
        // if (assigned(tempCatch)) then
        // FreeAndNil(tempCatch);

        tempCatch := TGISCatch.Create;
        tempCatch.id := catchName;
        tempCatch.tempTotalArea := tempArea;
        tempCatch.tempAccumulation := 0;
        tempCatch.tempWeightedVal := 0;
        catchDict.Add(catchName, tempCatch);
      end;
    end;

    feat := OGR_L_GetNextFeature(ogrLayer);
  until feat = nil;

  for tempKey in catchDict.Keys do
  begin
    if (catchDict.Items[tempKey] is TGISCatch) then
    begin
      catchDict.Items[tempKey].tempWeightedVal := tempCatch.tempAccumulation /
        tempCatch.tempTotalArea;
    end;
  end;
  Result := True;
end;

function getLayer(shpFilePath: String): OGRLayerH;
var
  ogrShp1: OGRLayerH;
  ogrDriver: OGRSFDriverH;
  ogrLayer: OGRLayerH;
begin
  OGRRegisterAll;
  // get handle on shapefile driver
  ogrDriver := OGRGetDriverByName(PAnsiChar(driverName));
  if ogrDriver = Nil then
  begin
    showMessage(Format('%s driver not available.', [driverName]));
    Result := nil;
    exit;
  end;

  // check to see if intersect result shp file already exists
  if FileExists(shpFilePath) then
  begin
    // Prepare to intersect source shapefiles
    OGR_Dr_Open(ogrDriver, PAnsiChar(AnsiString(shpFilePath)), 0);
    if ogrDriver = Nil then
    begin
      showMessage(Format('unable to open %s.', [shpFilePath]));
      Result := nil;
      exit;
    end;
    ogrShp1 := OGROpen(PAnsiChar(AnsiString(shpFilePath)), 0, Nil);
    ogrLayer := OGR_DS_GetLayer(ogrShp1, 0);
    if ogrShp1 = nil then
    begin
      showMessage(shpFilePath + ' was not found');
      Result := nil;
      exit;
    end;
    Result := ogrLayer;
    exit;
  end;
  Result := nil;
end;

procedure intersectShapeFilesAsLayers(shp1FilePath: String;
  shp2FilePath: String; outShpFilePath: String;
  resultShpFileType: OGRwkbGeometryType);
var
  ogrShp1, ogrShp2: OGRLayerH;
  ogrDriver: OGRSFDriverH;
  ogrDS: OGRDataSourceH;
  ogrLayer: OGRLayerH;
  I: longint;
  err: longint;
  intDSName, intDSPath: String;
begin
  OGRRegisterAll;

  // get handle on shapefile driver
  ogrDriver := OGRGetDriverByName(PAnsiChar(driverName));
  if ogrDriver = Nil then
  begin
    showMessage(Format('%s driver not available.', [driverName]));
    exit;
  end;

  // get name of resulting intersected shapefile from path passed in
  intDSName := ChangeFileExt(ExtractFileName(outShpFilePath), '');
  intDSPath := ExtractFilePath(outShpFilePath) + intDSName;

  // check to see if intersect result shp file already exists
  { TODO, uncomment for production
    if FileExists(outShpFilePath) then
    begin
    for I := 0 to High(shpExts) do
    DeleteFile(  intDSPath + shpExts[I]);
    end; }

  // create shape file to hold results of intersect operation
  // first try to create datasource
  ogrDS := OGR_Dr_CreateDataSource(ogrDriver,
    PAnsiChar(AnsiString(outShpFilePath)), Nil);
  if ogrDS = Nil then
  begin
    // showMessage(Format('Failed to create output file %s.', [outShpFilePath]));
    exit;
  end;

  // now try to create layer inside datasource
  ogrLayer := OGR_DS_CreateLayer(ogrDS, PAnsiChar(AnsiString(intDSName)), Nil,
    resultShpFileType, Nil);
  if ogrLayer = Nil then
  begin
    showMessage(Format('Failed to create layer %s in datasource.',
      [intDSName]));
    exit;
  end;

  ogrShp1 := OGROpen(PAnsiChar(AnsiString(shp1FilePath)), 0, Nil);
  ogrShp1 := OGR_DS_GetLayer(ogrShp1, 0);
  if ogrShp1 = nil then
    showMessage(shp1FilePath + ' was not found');

  ogrShp2 := OGROpen(PAnsiChar(AnsiString(shp2FilePath)), 0, Nil);
  ogrShp2 := OGR_DS_GetLayer(ogrShp2, 0);
  if ogrShp2 = nil then
    showMessage(shp2FilePath + ' was not found');

  err := OGR_L_Intersection(ogrShp1, ogrShp2, ogrLayer, nil, nil, nil);
  if err <> OGRERR_NONE then
  begin
    showMessage(Format('Failed to intersect layers: %d', [err]));
  end;

  // release the datasource
  err := OGRReleaseDatasource(ogrDS);
  if err <> OGRERR_NONE then
  begin
    // ShowMessage(Format('Error releasing datasource: %d', [err]));
  end;
  OGRCleanupAll;
end;

end.
