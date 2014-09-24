unit GSGdal;

{ Declarations of imported procedures from the GDALL C Api from GDAL DLL }
{ (Gdal.DLL) }

interface

uses
  SysUtils, Forms, Dialogs, Generics.Collections, Vcl.ComCtrls, Vcl.StdCtrls,
  StrUtils, Vcl.Grids,
  Classes, gdal, gdalcore, ogr, UProject, GSUtils, GSTypes, GSCatchments, GSIO,
  GSPLRM;

type
  TGSAreaWTObj = class
    // used to calculate percent of item area over parent area
    parentTotArea: Double;
    // used in calcs to temporarily hold sums during area / length weighting etc
    tempAccumulation: Double;
    // used in calcs to temporarily hold sums during area / length weighting etc - currently used for calcing luse imperviousness
    tempAccumulation2: Double;
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
    totalImprvLuseArea: Double; // total landuse coverage area
    totalPervLuseArea: Double; // total landuse coverage area

    totalSoilsArea: Double; // total soils coverage area
    totalBMPsArea: Double; // total BMPs coverage area
    totalRdShdLength: Double; // sum of all road shoulder lengths for catchment
    totalRdConnLength: Double; // sum all road connectivity lengths
    totalRdConditionLength: Double; // sum all road condition lenghths
    // sum of all road connectivity lengths for catchment

    luseDict: TDictionary<String, TGSAreaWTObj>;
    // luseImpervDict: TDictionary<String, TGSAreaWTObj>;
    rdShouldersDict: TDictionary<String, TGSAreaWTObj>;
    rdConditionDict: TDictionary<String, TGSAreaWTObj>;
    rdConnDict: TDictionary<String, TGSAreaWTObj>;
    soilsDict: TDictionary<String, TGSAreaWTObj>;
    bmpsDict: TDictionary<String, TGSAreaWTObj>;

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
  // GISAREACONV = 1 / 43560; // conversions for geom area to acres
  GISAREACONV = 0.00024711; // conversions for geom area to acres
  shpExt: String = '.shp';
  minSlope: Double = 0.1;
  smallNum: Double = 0.00000001; // used to prevent 0/Number
  shpExts: array [0 .. 5] of string = ('.shp', '.shx', '.prj', '.dbf',
    '.sbn', '.xml');

  startMsgs: array [0 .. 9] of string = ('Begin processing catchments',
    'Begin processing slopes', 'Begin processing landuse codes',
    'Begin processing landuse imperviousness', 'Begin processing soils',
    'Begin processing road conditions', 'Begin processing road shoulders',
    'Begin processing runoff connectivity', 'Begin processing BMPs',
    'GIS Processing complete');

  endMsgs: array [0 .. 9] of string = ('Catchment layer processing complete',
    'Slope layer processing complete', 'Landuse codes processing complete',
    'Landuse imperviousness processing complete',
    'Soils layer processing complete',
    'Road conditions layer processing complete',
    'Road shoulder erosion layer processing complete',
    'Runoff connectivity layer processing complete',
    'BMPs layer processing complete', 'Success');

  startValidtnMsgs: array [0 .. 9] of string = ('Begin validating catchments',
    'Begin validating slopes', 'Begin validating landuse codes',
    'Begin validating landuse imperviousness', 'Begin validating soils',
    'Begin validating road conditions', 'Begin validating road shoulders',
    'Begin validating runoff connectivity', 'Begin validating BMPs',
    'GIS validating complete');

  endValidtnMsgs: array [0 .. 9] of string = ('Catchments validation complete',
    'Slopes validation complete', 'Landuse codes validation complete',
    'Landuse imperviousness validation complete', 'Soils validation complete',
    'Road conditions validation complete', 'Road shoulders validation complete',
    'Runoff connectivity validation complete', 'BMPs validation complete',
    'Success');

  pervImpervDefnStrings: array [0 .. 1] of string = ('Pervious', 'Impervious');

  fldNameCatch = 'NAME';
  fldNameCatchArea = 'Acres';
  fldNameBMPCode = 'COMB_ID';
  fldNameSlope = 'SLOPE';
  fldNameLuseCode = 'LU_ID';
  fldNameLuseImprvCode = 'LU_DESC';
  fldNameSoilCode = 'SOIL_ID';
  fldNameRdShoulder = 'SHOULDER';
  fldNameRdCondition = 'SCORE';
  fldNameRdConn = 'CONNECT';

  intcatchSlope = 'PLRM_CatchSlopes';
  intCatchBMP = 'PLRM_CatchBMPs';
  intcatchLuse = 'PLRM_CatchLuses';
  intcatchSoil = 'PLRM_CatchSoils';
  intcatchRdShd = 'PLRM_CatchShlds';
  intcatchRdCondition = 'PLRM_CatchCond';
  intcatchRdConn = 'PLRM_CatchConn';

  layerNum = 0;
  driverName = 'ESRI Shapefile';

function runGISOps(gisXMLFilePath: String;
  shpFilesDict: TDictionary<String, String>; var inpgBar: TProgressBar;
  var inlblPercentComplete: TLabel; var inlblCurrentItem: TLabel;
  hasManualBMPs: Boolean; sgManualBMPs: TStringGrid; defaultSlope: Double)
  : TStringList;
procedure aggregateOthrAreas(NewCatch: TPLRMCatch);
function getAreaWeightedTable(var catchDict: TDictionary<String, TGISCatch>;
  shpFilePath: String; catchNameFld: String; propNameFld: String): Boolean;
function getAreaWeightedTableLuse(var catchDict: TDictionary<String, TGISCatch>;
  shpFilePath: String; catchNameFld: String; propNameFld: String)
  : Boolean; overload;
function getAreaWeightedTableLuse(var catchDict: TDictionary<String, TGISCatch>;
  shpFilePath: String; catchNameFld: String; propNameFld: String;
  coPropNameFld: String): Boolean; overload;
function lengthWeigthRoads(var catchDict: TDictionary<String, TGISCatch>;
  shpFilePath: String; catchNameFld: String; propNameFld: String): Boolean;
function getShapeFilePath(sFilesDict: TDictionary<String, String>;
  I: Integer): String;
function getLayer(shpFilePath: String): OGRLayerH;
function createPLRMCatchmentObjs(CDict: TDictionary<String, TGISCatch>;
  gisXMLFilePath: String; hasManualBMPs: Boolean; sgManualBMPs: TStringGrid;
  defaultSlope: Double): Boolean;

procedure intersectShapeFilesAsLayers(shp1FilePath: String;
  shp2FilePath: String; outShpFilePath: String;
  resultShpFileType: OGRwkbGeometryType);

function updateCatchObjLuse(tempCatch: TGISCatch;
  var NewCatch: TPLRMCatch): Boolean;
function updateCatchObjRdShoulders(tempCatch: TGISCatch;
  var NewCatch: TPLRMCatch): Boolean;
function updateCatchObjRdCondition(tempCatch: TGISCatch;
  var NewCatch: TPLRMCatch): Boolean;

procedure updateProgress(var pgBar: TProgressBar;
  var lblPercentComplete: TLabel; var lblCurrentItem: TLabel; stepNum: Integer;
  msg: String);
procedure handleGISErrs(errCode: Integer; err: String);

// validation functions and procs
function validateFldNameAndType(featDefn: OGRFeatureDefnH; feat: OGRFeatureH;
  fldName: String; fldType: OGRFieldType; errMsg: String): Boolean;
function validateAll(shpFilesDict: TDictionary<String, String>;
  var inpgBar: TProgressBar; var inlblPercentComplete: TLabel;
  var inlblCurrentItem: TLabel; hasManualBMPs: Boolean;
  sgManualBMPs: TStringGrid): TStringList;

function checkGeometryType(desiredGeomType: OGRwkbGeometryType;
  featDefn: OGRFeatureDefnH; errString: String): Boolean;

implementation

var
  luseDBData, luseShpCodes, soilMUCodes: dbReturnFields;
  numberOfpgBarSteps: Integer;
  gisErrsList: TStringList;
  pgBar: TProgressBar;
  lblPercentComplete: TLabel;
  lblCurrentItem: TLabel;

function validateFldNameAndType(featDefn: OGRFeatureDefnH; feat: OGRFeatureH;
  fldName: String; fldType: OGRFieldType; errMsg: String): Boolean;
var
  // rslt, flag: Boolean;
  fieldIndex: longint;
  // shpPath: String;
  fieldDefn: OGRFieldDefnH;
  fieldType: OGRFieldType;
  fieldName: string;
begin
  if ((featDefn <> nil) and (feat <> nil)) then
  begin
    fieldIndex := OGR_F_GetFieldIndex(feat, PAnsiChar(AnsiString(fldName)));
    if (fieldIndex <> -1) then
    begin
      fieldDefn := OGR_FD_GetFieldDefn(featDefn, fieldIndex);
      if assigned(fieldDefn) then
      begin
        fieldName := string(OGR_Fld_GetNameRef(fieldDefn));
        fieldType := OGR_Fld_GetType(fieldDefn);
        if ((fieldName = fldName) and (fieldType = fldType)) then
        begin
          Result := True;
          Exit;
        end;
      end;
    end;
  end;

  handleGISErrs(0, errMsg);
  Result := False;
end;

function validateSingleLayer(layerIdx: Integer; fldName: String;
  fldType: OGRFieldType; geomType: OGRwkbGeometryType; fldErrMsg: String;
  layerTypeErrMsg: String): Boolean;
var
  rslt, flag: Boolean;
  // I: Integer;
  shpPath: String;
  ogrLayer: OGRLayerH;
  featDefn: OGRFeatureDefnH;
  feat: OGRFeatureH;
begin
  rslt := True;

  updateProgress(pgBar, lblPercentComplete, lblCurrentItem, layerIdx,
    startValidtnMsgs[layerIdx]);

  shpPath := getShapeFilePath(shpFilesDict, layerIdx);
  ogrLayer := getLayer(shpPath);
  if(ogrLayer = nil) then
  begin
    handleGISErrs(0, 'Invalid shapefile: ' + shpPath);
    Result := False;
    Exit;
  end;
  featDefn := OGR_L_GetLayerDefn(ogrLayer);

  OGR_L_ResetReading(ogrLayer);
  feat := OGR_L_GetNextFeature(ogrLayer);

  // validate field name and type
  flag := validateFldNameAndType(featDefn, feat, fldName, fldType,
    shpPath + ' - ' + fldErrMsg + fldName + #13#10);
  rslt := rslt and flag;

  // validate layer geometry type
  flag := checkGeometryType(geomType, featDefn,
    shpPath + ' - ' + layerTypeErrMsg + #13#10);
  rslt := rslt and flag;

  updateProgress(pgBar, lblPercentComplete, lblCurrentItem, layerIdx,
    endValidtnMsgs[layerIdx]);
  Result := rslt;
end;

function validateAll(shpFilesDict: TDictionary<String, String>;
  var inpgBar: TProgressBar; var inlblPercentComplete: TLabel;
  var inlblCurrentItem: TLabel; hasManualBMPs: Boolean;
  sgManualBMPs: TStringGrid): TStringList;
var
  // rslt, flag: Boolean;
  // featDefn: OGRFeatureDefnH;
  // ogrLayer: OGRLayerH;
  // shpPath: String;
  // tempFieldNames: Array of String;
  // tempFieldTypes: Array of OGRFieldType;
  genericFldErrMsg: String;
  genericLayerTypeErrMsg1, genericLayerTypeErrMsg2: String;
  numberOfpgBarSteps: Integer;
begin
  genericFldErrMsg := 'Missing field or wrong field data type: ';
  genericLayerTypeErrMsg1 := 'Layer type should be POLYGON';
  genericLayerTypeErrMsg2 := 'Layer type should be POLYLINE';

  // save progress related vars to global unit vars for other fxns can update progress easily
  pgBar := inpgBar;
  lblPercentComplete := inlblPercentComplete;
  lblCurrentItem := inlblCurrentItem;

  numberOfpgBarSteps := 10;
  pgBar.Step := 1;
  pgBar.Position := 0;
  pgBar.Max := numberOfpgBarSteps;
  pgBar.StepIt;

  // get rid of old errors messages and notifications
  if (not(assigned(gisErrsList))) then
    gisErrsList := TStringList.Create
  else
    gisErrsList.Clear;

  // rslt := True;
  // 1. validate catchment layer - check catchment name field
  validateSingleLayer(0, fldNameCatch, OGRFieldType.OFTString,
    OGRwkbGeometryType.wkbPolygon, genericFldErrMsg, genericLayerTypeErrMsg1);

  // 1b. validate catchment layer - check catchment area field
  validateSingleLayer(0, fldNameCatchArea, OGRFieldType.OFTReal,
    OGRwkbGeometryType.wkbPolygon, genericFldErrMsg, genericLayerTypeErrMsg1);

  { // 2. validate slopes layer
    validateSingleLayer(1, fldNameSlope, OGRFieldType.OFTInteger,
    OGRwkbGeometryType.wkbPolygon, genericFldErrMsg, genericLayerTypeErrMsg1); }

  // 3. validate land use layer for land use codes field
  validateSingleLayer(2, fldNameLuseCode, OGRFieldType.OFTInteger,
    OGRwkbGeometryType.wkbPolygon, genericFldErrMsg, genericLayerTypeErrMsg1);
  // 3b. validate land use layer for land use imperviousness field - aware of redundant check for layer type
  validateSingleLayer(2, fldNameLuseImprvCode, OGRFieldType.OFTString,
    OGRwkbGeometryType.wkbPolygon, genericFldErrMsg, genericLayerTypeErrMsg1);

  // 4. validate soils layer
  validateSingleLayer(3, fldNameSoilCode, OGRFieldType.OFTString,
    OGRwkbGeometryType.wkbPolygon, genericFldErrMsg, genericLayerTypeErrMsg1);

  // 5. validate road conditions layer
  validateSingleLayer(4, fldNameRdCondition, OGRFieldType.OFTReal,
    OGRwkbGeometryType.wkbLineString, genericFldErrMsg,
    genericLayerTypeErrMsg2);

  // 6. validate road shoulder erosion layer
  validateSingleLayer(5, fldNameRdShoulder, OGRFieldType.OFTString,
    OGRwkbGeometryType.wkbLineString, genericFldErrMsg,
    genericLayerTypeErrMsg2);

  // 7. validate road connectivity layer
  validateSingleLayer(6, fldNameRdConn, OGRFieldType.OFTString,
    OGRwkbGeometryType.wkbLineString, genericFldErrMsg,
    genericLayerTypeErrMsg2);

  if (hasManualBMPs = False) then
  begin
    // 8. validate bmps layer
    validateSingleLayer(7, fldNameBMPCode, OGRFieldType.OFTString,
      OGRwkbGeometryType.wkbPolygon, genericFldErrMsg, genericLayerTypeErrMsg1);
  end;
  Result := gisErrsList;
end;

procedure handleGISErrs(errCode: Integer; err: String);
begin
  if (not(assigned(gisErrsList))) then
    gisErrsList := TStringList.Create;

  gisErrsList.Add(err);
end;

procedure gisCleanUp();
begin
  // do not delete gisErrsList cause returned back to calling form to
  // display errors
  { if (assigned(gisErrsList)) then
    FreeAndNil(gisErrsList); }

  FreeAndNil(luseShpCodes);
  FreeAndNil(soilMUCodes);
end;

function processCatchments(shpPath: String;
  CDict: TDictionary<String, TGISCatch>): Boolean;
var
  flag: Boolean;
  tempKey: String;
  tempCatch: TGISCatch;
begin
  flag := getAreaWeightedTable(CDict, shpPath, fldNameCatch, fldNameCatchArea);
  // calculation was successful if flag is true so set ave slope prop of each catchment
  if (flag) then
    for tempKey in CDict.Keys do
    begin
      if (CDict.Items[tempKey] is TGISCatch and assigned(CDict.Items[tempKey]))
      then
      begin
        tempCatch := CDict.Items[tempKey];
        CDict.Items[tempKey].totalCatchArea := tempCatch.tempTotalArea;

        // IMPORTANT free dict below for next set of intersections and calcs
        FreeAndNil(tempCatch.TempAreaWTDict);
        tempCatch.tempTotalArea := 0;
        tempCatch.tempAccumulation := 0; // important!
        tempCatch.tempWeightedVal := 0;
      end;
    end;
  Result := flag;
end;

function processSlopes(dir, catchmentsShpPath: String; slopesShpPath: String;
  CDict: TDictionary<String, TGISCatch>): Boolean;
var
  flag: Boolean;
  tempKey: String;
  tempCatch: TGISCatch;
begin
  intersectShapeFilesAsLayers(catchmentsShpPath, slopesShpPath,
    dir + intcatchSlope + shpExt, OGRwkbGeometryType.wkbPolygon);

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
        tempCatch.tempTotalArea := 0;
        tempCatch.tempAccumulation := 0; // important!
        tempCatch.tempWeightedVal := 0;
      end;
    end;
  Result := flag;
end;

// mode = 0 > land uses  | mode = 1 > soils | mode = 2 > bmps
function processLusesSoilsOrBMPs(dir: String; shpPathCatch: String;
  shpPathVar: String; CDict: TDictionary<String, TGISCatch>;
  sourceDSName: String; rsltShpName: String; fldNameVar: String; mode: Integer)
  : Boolean;
var
  flag: Boolean;
  tempKey: String;
  tempCatch: TGISCatch;
begin
  // ShowMessage('1');
  intersectShapeFilesAsLayers(shpPathCatch, shpPathVar,
    dir + rsltShpName + shpExt, OGRwkbGeometryType.wkbPolygon);
  // ShowMessage('2');
  if (mode = 0) then
    flag := getAreaWeightedTableLuse(CDict, dir + rsltShpName + shpExt,
      fldNameCatch, fldNameVar, fldNameLuseImprvCode)
  else
    flag := getAreaWeightedTableLuse(CDict, dir + rsltShpName + shpExt,
      fldNameCatch, fldNameVar);
  // ShowMessage('3');
  // calculation was successful if flag is true so copy tempdict to lusedict of each catchment
  if (flag) then
    for tempKey in CDict.Keys do
      if (CDict.Items[tempKey] is TGISCatch) then
      begin
        tempCatch := CDict.Items[tempKey];
        if (assigned(tempCatch.TempAreaWTDict)) then
        begin
          // for land uses
          if (mode = 0) then
          begin
            tempCatch.luseDict := TDictionary<String, TGSAreaWTObj>.Create
              (tempCatch.TempAreaWTDict);
            tempCatch.totalLuseArea := tempCatch.tempTotalArea;
          end
          // for soils
          else if (mode = 1) then
          begin
            tempCatch.soilsDict := TDictionary<String, TGSAreaWTObj>.Create
              (tempCatch.TempAreaWTDict);
            tempCatch.totalSoilsArea := tempCatch.tempTotalArea;
          end
          // for bmps
          else if ((mode = 2) and assigned(tempCatch.TempAreaWTDict)) then
          begin
            tempCatch.bmpsDict := TDictionary<String, TGSAreaWTObj>.Create
              (tempCatch.TempAreaWTDict);
            tempCatch.totalBMPsArea := tempCatch.tempTotalArea;
          end;
        end;
        // else
        // showMessage('Unknown mode while process polygon shapefiles');
        // IMPORTANT free dict below for next set of intersections and
        tempCatch.tempTotalArea := 0;
        tempCatch.tempAccumulation := 0; // important!
        tempCatch.tempWeightedVal := 0;
        FreeAndNil(tempCatch.TempAreaWTDict);
      end;
  Result := flag;
end;

function processRdShoulders(dir: String; shpPathCatch: String;
  shpPathVar: String; CDict: TDictionary<String, TGISCatch>): Boolean;
var
  flag: Boolean;
  tempKey: String;
  tempCatch: TGISCatch;
begin
  intersectShapeFilesAsLayers(shpPathCatch, shpPathVar,
    dir + intcatchRdShd + shpExt, OGRwkbGeometryType.wkbLineString);

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

function processRdCondition(dir: String; shpPathCatch: String;
  shpPathVar: String; CDict: TDictionary<String, TGISCatch>): Boolean;
var
  flag: Boolean;
  tempKey: String;
  tempCatch: TGISCatch;
begin
  intersectShapeFilesAsLayers(shpPathCatch, shpPathVar,
    dir + intcatchRdCondition + shpExt, OGRwkbGeometryType.wkbLineString);

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

function processRdConnectivity(dir: String; shpPathCatch: String;
  shpPathVar: String; CDict: TDictionary<String, TGISCatch>): Boolean;
var
  flag: Boolean;
  tempKey: String;
  tempCatch: TGISCatch;
begin
  intersectShapeFilesAsLayers(shpPathCatch, shpPathVar,
    dir + intcatchRdConn + shpExt, OGRwkbGeometryType.wkbLineString);

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

function getShapeFilePath(sFilesDict: TDictionary<String, String>;
  I: Integer): String;
begin
  if (sFilesDict.ContainsKey(shpFileKeys[I])) then
    Result := sFilesDict[shpFileKeys[I]]
  else
  begin
    showMessage('Unable to find shapefile for ' + shpFileKeys[I]);
    Result := '';
  end;
end;

procedure updateProgress(var pgBar: TProgressBar;
  var lblPercentComplete: TLabel; var lblCurrentItem: TLabel; stepNum: Integer;
  msg: String);
var
  percentComplete: Double;
begin
  if stepNum = 0 then
    stepNum := 1;

  percentComplete := 100 * stepNum / numberOfpgBarSteps;
  lblPercentComplete.Caption := FormatFloat(ONEDP, percentComplete) +
    '% complete ...';
  lblCurrentItem.Caption := msg;
  pgBar.Position := stepNum;
  Application.ProcessMessages; // TODO implement alternative
end;

function runGISOps(gisXMLFilePath: String;
  shpFilesDict: TDictionary<String, String>; var inpgBar: TProgressBar;
  var inlblPercentComplete: TLabel; var inlblCurrentItem: TLabel;
  hasManualBMPs: Boolean; sgManualBMPs: TStringGrid; defaultSlope: Double)
  : TStringList;
var
  dir: String;
  CDict: TDictionary<String, TGISCatch>;
  shpPathCatch, shpPathVar: String;
  luseDSName, soilsDSName, bmpsDSName: String;
begin
  dir := defaultGISDir + '\';
  numberOfpgBarSteps := 10;
  pgBar.Step := 1;
  pgBar.Position := 0;
  pgBar.Max := numberOfpgBarSteps;
  pgBar.StepIt;

  // Step 1: Calc catchment areas
  // *******************************************
  // Create dict to hold catchment properties
  updateProgress(pgBar, lblPercentComplete, lblCurrentItem, 1, startMsgs[0]);
  CDict := TDictionary<String, TGISCatch>.Create;
  shpPathCatch := getShapeFilePath(shpFilesDict, 0);
  processCatchments(shpPathCatch, CDict);
  updateProgress(pgBar, lblPercentComplete, lblCurrentItem, 2, endMsgs[0]);

  // Step 2: Catchment average slopes
  // *******************************************
  // Intersect catchment layer and slopes layer and calc area-weighted slope by catchment
  { updateProgress(pgBar, lblPercentComplete, lblCurrentItem, 2, startMsgs[1]);
    shpPathVar := getShapeFilePath(shpFilesDict, 1);
    processSlopes(dir, shpPathCatch, shpPathVar, CDict); }
  updateProgress(pgBar, lblPercentComplete, lblCurrentItem, 3, endMsgs[1]);

  // Step 3: Catchment land uses
  // *******************************************
  // Intersect catchment layer and landuse layer and calc area-weighted landuse by catchment
  // ShowMessage('1');
  updateProgress(pgBar, lblPercentComplete, lblCurrentItem, 3, startMsgs[2]);
  // ShowMessage('2');
  shpPathVar := getShapeFilePath(shpFilesDict, 2);
  // ShowMessage('3');
  luseDSName := ChangeFileExt(ExtractFileName(shpPathVar), '');
  // ShowMessage('4');
  processLusesSoilsOrBMPs(dir, shpPathCatch, shpPathVar, CDict, luseDSName,
    intcatchLuse, fldNameLuseCode, 0);
  // ShowMessage('5');
  updateProgress(pgBar, lblPercentComplete, lblCurrentItem, 4, endMsgs[2]);
  // ShowMessage('6');

  // Step 3b: Catchment land imperviousness
  // *******************************************
  // using previously intersected land use layer calc %imperv hment
  // processLusesImperv(dir, CDict, intcatchLuse, fldNameLuseCode, 0);
  // updateProgress(pgBar, lblPercentComplete, lblCurrentItem, 4);

  // Step 4: Catchment soils
  // *******************************************
  // Intersect catchment layer and soils layer and calc area-weighted soils by catchment
  updateProgress(pgBar, lblPercentComplete, lblCurrentItem, 4, startMsgs[4]);
  shpPathVar := getShapeFilePath(shpFilesDict, 3);
  soilsDSName := ChangeFileExt(ExtractFileName(shpPathVar), '');
  processLusesSoilsOrBMPs(dir, shpPathCatch, shpPathVar, CDict, soilsDSName,
    intcatchSoil, fldNameSoilCode, 1);
  updateProgress(pgBar, lblPercentComplete, lblCurrentItem, 5, endMsgs[4]);

  // Step 5: Road shoulder erosion
  // *******************************************
  // Intersect catchment layer and road shoulders layer and calc lengths of each kind of shoulder
  updateProgress(pgBar, lblPercentComplete, lblCurrentItem, 5, startMsgs[5]);
  shpPathVar := getShapeFilePath(shpFilesDict, 5);
  processRdShoulders(dir, shpPathCatch, shpPathVar, CDict);
  updateProgress(pgBar, lblPercentComplete, lblCurrentItem, 6, endMsgs[5]);

  // Step 6: Road condition
  // *******************************************
  // Intersect catchment layer and road conditions layer and calc lengths of each kind of condition
  updateProgress(pgBar, lblPercentComplete, lblCurrentItem, 6, startMsgs[6]);
  shpPathVar := getShapeFilePath(shpFilesDict, 4);
  processRdCondition(dir, shpPathCatch, shpPathVar, CDict);
  updateProgress(pgBar, lblPercentComplete, lblCurrentItem, 7, endMsgs[6]);

  // Step 7: Road connectivity
  // *******************************************
  // Intersect catchment layer and road runoff connectivity layer and calc lengths of each kind of connectivity
  updateProgress(pgBar, lblPercentComplete, lblCurrentItem, 7, startMsgs[7]);
  shpPathVar := getShapeFilePath(shpFilesDict, 6);
  processRdConnectivity(dir, shpPathCatch, shpPathVar, CDict);
  updateProgress(pgBar, lblPercentComplete, lblCurrentItem, 8, endMsgs[7]);

  // Step 8: BMPs
  // *******************************************
  // Intersect catchment layer and BMPs layer and calc area-weighted vals of each kind of BMP
  // when BMPs being processed by this function hasManualBMPs will be passed in as True
  // in which case we don't attempt to intersect BMP layer
  if (hasManualBMPs = False) then
  begin
    updateProgress(pgBar, lblPercentComplete, lblCurrentItem, 8, startMsgs[8]);
    shpPathVar := getShapeFilePath(shpFilesDict, 7);
    bmpsDSName := ChangeFileExt(ExtractFileName(shpPathVar), '');
    processLusesSoilsOrBMPs(dir, shpPathCatch, shpPathVar, CDict, bmpsDSName,
      intCatchBMP, fldNameBMPCode, 2);
  end;
  updateProgress(pgBar, lblPercentComplete, lblCurrentItem, 9, endMsgs[8]);

  // Step 9: Serialize collected data to disk
  createPLRMCatchmentObjs(CDict, gisXMLFilePath, hasManualBMPs, sgManualBMPs,
    defaultSlope);
  updateProgress(pgBar, lblPercentComplete, lblCurrentItem, 10, endMsgs[9]);

  // clean up and deallocate memory
  gisCleanUp();
  FreeAndNil(CDict);
  Result := gisErrsList;
end;

function updateCatchObjLuse(tempCatch: TGISCatch; var NewCatch: TPLRMCatch)
  : Boolean;
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
    // SetLength(tempArryVals, luseDBData[0].Count, 4);
    SetLength(tempArryVals, luseDBData[0].Count, 5);
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
            tempArryVals[tempInt, 1] := tempArryVals[tempInt, 1] +
              areaWTObj.percentOfTotalCatch; // %catch
            // tempArry[tempInt, 2] := luseDBData[1][tempInt]; // %imp
            tempArryVals[tempInt, 2] := tempArryVals[tempInt, 2] +
              areaWTObj.tempAccumulation2; // imp area

            tempArryVals[tempInt, 3] := tempCatch.totalCatchArea * tempArryVals
              [tempInt, 1];
            tempArryVals[tempInt, 4] := tempArryVals[tempInt, 4] +
              areaWTObj.tempAccumulation; // sum all areas of that luse
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
        // rsltArry[tempInt, 2] := tempArry[I, 2]; // %imp
        rsltArry[tempInt, 2] := FormatFloat(TWODP, 100 * tempArryVals[I, 2] /
          tempArryVals[I, 4]); // %imp
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
function updateCatchObjSoils(tempCatch: TGISCatch; var NewCatch: TPLRMCatch)
  : Boolean;
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
          tempArry[I, 0] := soilMUCodes[0][tempInt] + '-' + soilMUCodes
            [1][tempInt];
          // label
          tempArryVals[I, 1] := tempArryVals[I, 1] +
            areaWTObj.percentOfTotalCatch;
          // %catch
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
  I, J, numTblCols: Integer;
  tempVarKey: String;
  areaWTObj: TGSAreaWTObj;
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
  // tempInt := 0;
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
  I, J, numTblCols: Integer;
  tempVarKey: String;
  areaWTObj: TGSAreaWTObj;
  // rdCondStates: TArray<string>;
  // rdCondStateList: TStringList;
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
  // tempInt := 0;
  for I := 0 to I - 1 do
    for J := 0 to numTblCols - 1 do
      rsltArry[I, J] := tempArry[I, J];

  tData.DINF := 0;
  tData.INFFacility.totSurfaceArea := 0;
  tData.INFFacility.totStorage := 0;
  tData.INFFacility.aveAnnInfiltrationRate := 0.5;
  tData.DPCH := 0;
  tData.PervChanFacility.length := 0;
  tData.PervChanFacility.width := 0;
  tData.PervChanFacility.aveSlope := 1;
  tData.PervChanFacility.storageDepth := 0;
  tData.PervChanFacility.aveAnnInfiltrationRate := 0.5;
  tData.isAssigned := True;

  NewCatch.frm5of6RoadDrainageEditorData := tData;
  Result := True;
end;

function updateCatchObjBMPs(tempCatch: TGISCatch; var NewCatch: TPLRMCatch;
  hasManualBMPs: Boolean; sgManualBMPs: TStringGrid): Boolean;
var
  // rsltArry: PLRMGridData;
  // tempArryVals: PLRMGridDataDbl;
  numBMPImplCols, numNoBMPImplCols, numBMPRows: Integer;
  tempVarKey: String;
  areaWTObj: TGSAreaWTObj;
  tempf6of6SgBMPImplData: PLRMGridDataDbl;
  tempf6of6SgNoBMPsData: PLRMGridDataDbl;
  I: Integer;
  tempTotal: Double;
  // represents landuse index and BMP type index
  luseidx, ctrlidx: Integer;
begin
  // # of cols in frm6of6SgBMPImplData grid
  numBMPImplCols := 2;
  // # of cols in frm6of6SgNoBMPImplData grid
  numNoBMPImplCols := 3;
  // # of cols in frm6of6SgBMPImplData & frm6of6SgNoBMPImplData grids
  numBMPRows := 4;

  SetLength(tempf6of6SgBMPImplData, numBMPRows, numBMPImplCols);
  SetLength(tempf6of6SgNoBMPsData, numBMPRows, numNoBMPImplCols);

  // non-manual BMP option
  if (assigned(tempCatch.bmpsDict) and (hasManualBMPs = False)) then
  begin

    // if (hasManualBMPs = False) then
    // begin
    for tempVarKey in tempCatch.bmpsDict.Keys do
    begin
      if (tempCatch.bmpsDict.Items[tempVarKey] is TGSAreaWTObj and
        assigned(tempCatch.bmpsDict.Items[tempVarKey])) then
      begin
        areaWTObj := tempCatch.bmpsDict.Items[tempVarKey];
        if (assigned(areaWTObj) and (tempVarKey <> '')) then
        begin
          // compute land use and BMP type 10 - SRF:NoBMP, 11-SFR:BMP, 12-:SFR:SCO, 20-MFR:NoBMP etc
          luseidx := strToInt(tempVarKey[1]);
          ctrlidx := strToInt(tempVarKey[2]);
          if (ctrlidx = 0) then
          begin
            tempf6of6SgNoBMPsData[luseidx - 1, ctrlidx] := tempf6of6SgNoBMPsData
              [luseidx - 1, ctrlidx] + areaWTObj.tempAccumulation;
            tempf6of6SgNoBMPsData[luseidx - 1, 1] := 50; // default DCIA
          end
          else // takes care of both ctrlidx = 1 & 2
            tempf6of6SgBMPImplData[luseidx - 1, ctrlidx - 1] :=
              tempf6of6SgBMPImplData[luseidx - 1, ctrlidx - 1] +
              areaWTObj.tempAccumulation;
        end;
      end;
    end;
    // now loop through and calculate actual percentages from accumulated areas
    for I := 0 to High(tempf6of6SgNoBMPsData) do
    begin
      // total area = NoBMPs area              + BMPs area                   + source controls area
      tempTotal := tempf6of6SgNoBMPsData[I, 0] + tempf6of6SgBMPImplData[I, 0] +
        tempf6of6SgBMPImplData[I, 1];
      if (tempTotal <> 0) then
      begin
        tempf6of6SgNoBMPsData[I, 0] := 100 *
          ((smallNum + tempf6of6SgNoBMPsData[I, 0]) / tempTotal);
        tempf6of6SgBMPImplData[I, 0] := 100 *
          ((smallNum + tempf6of6SgBMPImplData[I, 0]) / tempTotal);
        tempf6of6SgBMPImplData[I, 1] := 100 *
          ((smallNum + tempf6of6SgBMPImplData[I, 1]) / tempTotal);
      end;
    end;
  end
  else
  begin

    // Manual BMP option
    // now loop through copy values from manually entered values
    for I := 0 to sgManualBMPs.RowCount - 1 do
    begin
      // total area = NoBMPs area              + BMPs area                   + source controls area
      tempf6of6SgNoBMPsData[I, 0] := StrToFloat(sgManualBMPs.Cells[0, I]);
      // NoBMPs
      tempf6of6SgBMPImplData[I, 0] := StrToFloat(sgManualBMPs.Cells[2, I]);
      // SrcCtrls
      tempf6of6SgBMPImplData[I, 1] := StrToFloat(sgManualBMPs.Cells[1, I]);
      // BMPs
    end;
  end;

  NewCatch.frm6of6SgNoBMPsData := PLRMGridDblToPLRMGridDataNT
    (tempf6of6SgNoBMPsData);
  NewCatch.frm6of6SgBMPImplData := PLRMGridDblToPLRMGridDataNT
    (tempf6of6SgBMPImplData);
  aggregateOthrAreas(NewCatch);
  Result := True;
end;

procedure aggregateOthrAreas(NewCatch: TPLRMCatch);
var
  tempInt, I: Integer;
  tempOtherArea, tempOtherImpvArea: Double;
  FrmLuseConds: TDrngXtsData;
  tempList: TStringList;
begin
  tempOtherArea := 0;
  tempOtherImpvArea := 0;
  SetLength(FrmLuseConds.luseAreaNImpv, High(frmsLuses) + 1, 2);
  tempList := TStringList.Create;
  // Add Landuses to StringList to allow indexof
  for I := 0 to High(frmsLuses) do
  begin
    tempList.Add(frmsLuses[I]);
  end;

  with NewCatch do
  begin
    // totArea := NewCatch.area;
    for I := 0 to landUseNames.Count - 1 do
    begin
      tempInt := tempList.IndexOf(landUseNames[I]);
      if (tempInt > -1) then
      begin
        // write total area
        FrmLuseConds.luseAreaNImpv[tempInt, 0] :=
          PLRMObj.currentCatchment.landUseData[I][3];
        // compute and write impervious acres
        FrmLuseConds.luseAreaNImpv[tempInt, 1] :=
          FormatFloat(THREEDP, StrToFloat(PLRMObj.currentCatchment.landUseData
          [I][3]) * StrToFloat(PLRMObj.currentCatchment.landUseData[I]
          [2]) / 100);
      end
      else
      // lump all other land uses into other areas
      begin
        tempOtherArea := tempOtherArea + StrToFloat(landUseData[I][3]);
        tempOtherImpvArea := tempOtherImpvArea + StrToFloat(landUseData[I][2]) *
          StrToFloat(landUseData[I][3]);
      end;
    end;
  end;
  FrmLuseConds.luseAreaNImpv[High(frmsLuses), 0] := FloatToStr(tempOtherArea);
  FrmLuseConds.luseAreaNImpv[High(frmsLuses), 1] :=
    FloatToStr(tempOtherImpvArea / 100);
  NewCatch.othrArea := tempOtherArea;
  NewCatch.othrPrcntToOut := 100;
  // entire area drains directly to out
  if tempOtherArea = 0 then
    NewCatch.othrPrcntImpv := 0
  else
    NewCatch.othrPrcntImpv := tempOtherImpvArea / tempOtherArea;

  NewCatch.frm6of6AreasData := FrmLuseConds;
  NewCatch.hasDefParcelAndDrainageBMPs := True;

  FreeAndNil(tempList);
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
    // tempInt := 0;
    for I := 0 to numTblRows - 1 do
      for J := 0 to numTblCols - 1 do
        rsltArry[I, J] := FormatFloat(TWODP, tempArryVals[I, J]);

    NewCatch.frm4of6SgRoadShoulderData := rsltArry;
  end;
  Result := True;
  FreeAndNil(rdCondStateList);
end;

function createPLRMCatchmentObjs(CDict: TDictionary<String, TGISCatch>;
  gisXMLFilePath: String; hasManualBMPs: Boolean; sgManualBMPs: TStringGrid;
  defaultSlope: Double): Boolean;
var
  I: Integer;
  tempKey: String;
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
      NewCatch.hasDefRoadPolls := True;
      NewCatch.hasDefRoadDrainage := True;
      NewCatch.hasDefParcelAndDrainageBMPs := False;
      NewCatch.hasDefCustomBMPSizeData := False;
      NewCatch.area := StrToFloat(FormatFloat(THREEDP,
        tempCatch.totalCatchArea));
      { NewCatch.slope := StrToFloat(FormatFloat(THREEDP, tempCatch.aveSlope)); }
      NewCatch.slope := StrToFloat(FormatFloat(THREEDP, defaultSlope));

      // 1. save landuse codes to catchObj
      updateCatchObjLuse(tempCatch, NewCatch);

      // 1b. save landuse imperviousness to catchObj
      // updateCatchObjLuseImprv(tempCatch, NewCatch);

      // 2. save soils to catchObj
      updateCatchObjSoils(tempCatch, NewCatch);

      // 3. save road shoulders to catchObj
      updateCatchObjRdShoulders(tempCatch, NewCatch);

      // 4. save road condition to catchObj
      updateCatchObjRdCondition(tempCatch, NewCatch);

      // 5. save road connectivity to catchObj
      updateCatchObjRdConnectivity(tempCatch, NewCatch);

      // 6. save BMPs to catchObj
      updateCatchObjBMPs(tempCatch, NewCatch, hasManualBMPs, sgManualBMPs);

      NewCatch.othrArea := 0;
      catchList.AddObject(tempKey, NewCatch);
    end;
  // now being set by user gisXMLFilePath := defaultGISDir + '\GIS.xml';
  PLRMObj.plrmGISToXML(catchList, gisXMLFilePath);

  catchList.Free;
  FreeAndNil(tempFrmLusesList);
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

  // it is safe to reset read position on the first feature
  OGR_L_ResetReading(ogrLayer);

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
            tempAreaWTObj.tempWeightedVal := tempLength;
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
  // OGRCleanupAll;
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

  // it is safe to reset read position on the first feature
  OGR_L_ResetReading(ogrLayer);

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

          if tempCatch.TempAreaWTDict.ContainsKey(propCode) then
          begin
            if (tempCatch.TempAreaWTDict.TryGetValue(propCode, tempAreaWTObj)
              = True) then
            begin
              // accumulate total parent area - in this case parent is individual catchment containing this landuse
              tempCatch.tempTotalArea := tempCatch.tempTotalArea + tempArea;

              // accumulate total area for this variable e.g. SFR sliver
              tempAreaWTObj.tempTotalArea := tempAreaWTObj.tempTotalArea
                + tempArea;
              tempAreaWTObj.tempAccumulation := tempAreaWTObj.tempAccumulation
                + tempArea;
              tempAreaWTObj.tempWeightedVal := tempAreaWTObj.tempWeightedVal
                + tempArea;
            end;
          end
          else
          begin
            tempCatch.tempTotalArea := tempCatch.tempTotalArea + tempArea;
            tempAreaWTObj := TGSAreaWTObj.Create;
            tempAreaWTObj.tempTotalArea := tempArea;
            tempAreaWTObj.tempAccumulation := tempArea;
            tempAreaWTObj.tempWeightedVal := 0;
            tempCatch.TempAreaWTDict.Add(propCode, tempAreaWTObj);
          end;
        end
      end;
    end;
    feat := OGR_L_GetNextFeature(ogrLayer);
  until feat = nil;
  Result := True;
  // OGRCleanupAll;
end;

// similar to overloaded version, computes area weighted average of a single field with multiple possible values such as catchment landuses but also
// looks at an additional field to calculater imperviousness for each land use
function getAreaWeightedTableLuse(var catchDict: TDictionary<String, TGISCatch>;
  shpFilePath: String; catchNameFld: String; propNameFld: String;
  coPropNameFld: String): Boolean;
var
  ogrLayer: OGRLayerH;
  feat: OGRFeatureH;
  geom: OGRGeometryH;
  catchFldIdx, propCodeFldIdx, coPropCodeFldIdx: longint;
  catchName, propCode, coPropCode: String;
  tempArea: Double;
  tempCatch: TGISCatch;
  tempAreaWTObj: TGSAreaWTObj;
  outLuseCodes: TStringList;
  tempIndex: Integer;
Var
  outLuseFamilyCodes: TStringList;
begin
  // ShowMessage('a1');
  // get landuse codes and family codes
  outLuseCodes := TStringList.Create;
  outLuseFamilyCodes := TStringList.Create;
  getLuseCodeFamily(outLuseCodes, outLuseFamilyCodes);
  // ShowMessage('a2');
  ogrLayer := getLayer(shpFilePath);
  // ShowMessage('a3');
  // it is safe to reset read position on the first feature
  OGR_L_ResetReading(ogrLayer);
  // ShowMessage('a4');
  feat := OGR_L_GetNextFeature(ogrLayer);
  catchFldIdx := OGR_F_GetFieldIndex(feat, PAnsiChar(AnsiString(catchNameFld)));
  propCodeFldIdx := OGR_F_GetFieldIndex(feat,
    PAnsiChar(AnsiString(propNameFld)));
  coPropCodeFldIdx := OGR_F_GetFieldIndex(feat,
    PAnsiChar(AnsiString(coPropNameFld)));
  // ShowMessage('a5');
  Repeat
    geom := OGR_F_GetGeometryRef(feat);

    if (geom <> nil) then
    begin
      catchName := String(OGR_F_GetFieldAsString(feat, catchFldIdx));
      propCode := String(OGR_F_GetFieldAsString(feat, propCodeFldIdx));
      tempIndex := outLuseCodes.IndexOf(propCode);
      if (tempIndex = -1) then
      begin
        handleGISErrs(0, 'Unknown land use code found in land use layer.' +
          propCode);
      end;
      // need to use first 2 characters of the code to get land use code that is common to both perv and imperv
      // propCode := AnsiLeftStr(propCode, 2);
      propCode := outLuseFamilyCodes[tempIndex];

      coPropCode := String(OGR_F_GetFieldAsString(feat, coPropCodeFldIdx));
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

          if tempCatch.TempAreaWTDict.ContainsKey(propCode) then
          begin
            if (tempCatch.TempAreaWTDict.TryGetValue(propCode, tempAreaWTObj)
              = True) then
            begin
              // accumulate total parent area - in this case parent is individual catchment containing this landuse
              tempCatch.tempTotalArea := tempCatch.tempTotalArea + tempArea;

              // accumulate total area for this variable e.g. SFR sliver
              tempAreaWTObj.tempTotalArea := tempAreaWTObj.tempTotalArea
                + tempArea;
              tempAreaWTObj.tempAccumulation := tempAreaWTObj.tempAccumulation
                + tempArea;
              if (AnsiEndsStr(pervImpervDefnStrings[1], coPropCode)) then
                tempAreaWTObj.tempAccumulation2 :=
                  tempAreaWTObj.tempAccumulation2 + tempArea;
              tempAreaWTObj.tempWeightedVal := tempAreaWTObj.tempWeightedVal +
                tempArea;
            end;
          end
          else
          begin
            tempCatch.tempTotalArea := tempCatch.tempTotalArea + tempArea;
            tempAreaWTObj := TGSAreaWTObj.Create;
            tempAreaWTObj.tempTotalArea := tempArea;
            tempAreaWTObj.tempAccumulation := tempArea;
            if (AnsiEndsStr(pervImpervDefnStrings[1], coPropCode)) then
              tempAreaWTObj.tempAccumulation2 := tempAreaWTObj.tempAccumulation2
                + tempArea;
            tempAreaWTObj.tempWeightedVal := 0;
            tempCatch.TempAreaWTDict.Add(propCode, tempAreaWTObj);
          end;
        end
      end;
    end;
    feat := OGR_L_GetNextFeature(ogrLayer);
  until feat = nil;
  // ShowMessage('a6');
  Result := True;
  // OGRCleanupAll;
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

  // it is safe to reset read position on the first feature
  OGR_L_ResetReading(ogrLayer);

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
          tempCatch.tempAccumulation := tempCatch.tempAccumulation +
            (tempArea * propVal)
        end
      end
      else
      begin
        tempCatch := TGISCatch.Create;
        tempCatch.id := catchName;
        tempCatch.tempTotalArea := tempArea;
        tempCatch.tempAccumulation := tempArea * propVal;
        catchDict.Add(catchName, tempCatch);
      end;
    end;

    feat := OGR_L_GetNextFeature(ogrLayer);
  until feat = nil;

  for tempKey in catchDict.Keys do
  begin
    if (catchDict.Items[tempKey] is TGISCatch) then
    begin
      if (catchDict.TryGetValue(tempKey, tempCatch) = True) then
      begin
        tempCatch.tempWeightedVal := tempCatch.tempAccumulation /
          tempCatch.tempTotalArea;
      end;
    end;
  end;
  Result := True;
  // OGRCleanupAll;
end;

function getLayer(shpFilePath: String): OGRLayerH;
var
  ogrShp1: OGRLayerH;
  ogrDriver: OGRSFDriverH;
  ogrLayer: OGRLayerH;
begin
  // ShowMessage('b1');
  OGRRegisterAll;
  // get handle on shapefile driver
  ogrDriver := OGRGetDriverByName(PAnsiChar(driverName));
  if ogrDriver = Nil then
  begin
    handleGISErrs(-1, Format('%s driver not available.', [driverName]));
    Result := nil;
    Exit;
  end;
  // ShowMessage('b2');
  // check to see if intersect result shp file already exists
  if FileExists(shpFilePath) then
  begin
    // Prepare to intersect source shapefiles
    OGR_Dr_Open(ogrDriver, PAnsiChar(AnsiString(shpFilePath)), 0);
    if ogrDriver = Nil then
    begin
      handleGISErrs(-1, Format('unable to open %s.', [shpFilePath]));
      Result := nil;
      Exit;
    end;
    ogrShp1 := OGROpen(PAnsiChar(AnsiString(shpFilePath)), 0, Nil);
    ogrLayer := OGR_DS_GetLayer(ogrShp1, 0);
    if ogrShp1 = nil then
    begin
      handleGISErrs(-1, shpFilePath + ' was not found');
      Result := nil;
      Exit;
    end;
    Result := ogrLayer;
    Exit;
  end;
  // ShowMessage('b3');
  Result := nil;
  // OGRCleanupAll;
end;

procedure intersectShapeFilesAsLayers(shp1FilePath: String;
  shp2FilePath: String; outShpFilePath: String;
  resultShpFileType: OGRwkbGeometryType);
var
  ogrShp1, ogrShp2: OGRLayerH;
  ogrDriver: OGRSFDriverH;
  ogrDS: OGRDataSourceH;
  ogrLayer: OGRLayerH;
  // I: longint;
  err: longint;
  intDSName, intDSPath: String;
begin
  err := 0;
  OGRRegisterAll;

  // get handle on shapefile driver
  ogrDriver := OGRGetDriverByName(PAnsiChar(driverName));
  if ogrDriver = Nil then
  begin
    handleGISErrs(-1, Format('%s driver not available.', [driverName]));
    Exit;
  end;

  // get name of resulting intersected shapefile from path passed in
  intDSName := ChangeFileExt(ExtractFileName(outShpFilePath), '');
  intDSPath := ExtractFilePath(outShpFilePath) + intDSName;

  // check to see if intersect result shp file already exists
  // TODO, uncomment for production
  if FileExists(outShpFilePath) then
  begin
    err := OGR_Dr_DeleteDataSource(ogrDriver,
      PAnsiChar(AnsiString(outShpFilePath)));
  end;

  // create shape file to hold results of intersect operation
  // first try to create datasource
  ogrDS := OGR_Dr_CreateDataSource(ogrDriver,
    PAnsiChar(AnsiString(outShpFilePath)), Nil);
  if ogrDS = Nil then
  begin
    handleGISErrs(-1, Format('Failed to create output file %s.',
      [outShpFilePath]));
    Exit;
  end;

  // now try to create layer inside datasource
  ogrLayer := OGR_DS_CreateLayer(ogrDS, PAnsiChar(AnsiString(intDSName)), Nil,
    resultShpFileType, Nil);
  if ogrLayer = Nil then
  begin
    handleGISErrs(-1, Format('Failed to create layer %s in datasource.',
      [intDSName]));
    Exit;
  end;

  ogrShp1 := OGROpen(PAnsiChar(AnsiString(shp1FilePath)), 0, Nil);
  ogrShp1 := OGR_DS_GetLayer(ogrShp1, 0);
  if ogrShp1 = nil then
  begin
    handleGISErrs(err, shp1FilePath + ' was not found');
    Exit;
  end;

  ogrShp2 := OGROpen(PAnsiChar(AnsiString(shp2FilePath)), 0, Nil);
  ogrShp2 := OGR_DS_GetLayer(ogrShp2, 0);
  if ogrShp2 = nil then
  begin
    handleGISErrs(err, shp2FilePath + ' was not found');
    Exit;
  end;

  err := OGR_L_Intersection(ogrShp1, ogrShp2, ogrLayer, nil, nil, nil);
  if err <> OGRERR_NONE then
    handleGISErrs(err, Format('Failed to intersect layers: %s and %s err:%d',
      [shp1FilePath, shp2FilePath, err]));

  // TODO fix // release the datasource
  OGRReleaseDatasource(ogrDS);
  // OGR_DS_Destroy(ogrDS);
  // err := OGRReleaseDatasource(ogrDS);
  { if err <> OGRERR_NONE then
    handleGISErrs(err, Format('Error releasing datasource: %d', [err])); }

  OGRCleanupAll;
end;

// checks weather feature definition passed in is point, polyline or polygon
function checkGeometryType(desiredGeomType: OGRwkbGeometryType;
  featDefn: OGRFeatureDefnH; errString: String): Boolean;
var
  geomType: OGRwkbGeometryType;
  // geom: OGRGeometryH;
begin
  // get layer geometry type
  geomType := OGR_FD_GetGeomType(featDefn);
  if (geomType = desiredGeomType) then
    Result := True
  else
  begin
    Result := False;
    handleGISErrs(0, errString);
  end;
  { writeln(Format('Layer geometry type is %d (%s)',
    [geomType, OGRGeometryTypeToName(geomType)])); }
end;

end.
