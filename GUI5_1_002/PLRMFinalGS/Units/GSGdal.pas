unit GSGdal;

{ Declarations of imported procedures from the GDALL C Api from GDAL DLL }
{ (Gdal.DLL) }

interface

uses
  SysUtils, Forms, Dialogs, Generics.Collections,
  Classes, gdal, gdalcore, ogr, GSUtils, GSTypes, GSCatchments;

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

    luseDict: TDictionary<String, TGSAreaWTObj>;
    rdShouldersDict: TDictionary<String, TGSAreaWTObj>;
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
  rsRunoffConnDSName = 'PLRM_RunoffConnectivity';

  fldNameCatch = 'NAME';
  fldNameSlope = 'SLOPE';
  fldNameLuseCode = 'LU_ID';
  fldNameSoilCode = 'SOIL_ID';
  fldNameRdShoulder = 'SHOULDER';
  fldNameRdConn = 'CONNECTIVITY';

  intcatchSlope = 'PLRM_CatchSlopes';
  intcatchLuse = 'PLRM_CatchLuses';
  intcatchSoil = 'PLRM_CatchSoils';
  intcatchRdShd = 'PLRM_CatchShlds';
  intcatchRdConn = 'PLRM_CatchConn';

  layerNum = 0;
  driverName = 'ESRI Shapefile';

function runGISOps(): Boolean;
function gdalVersion(): AnsiString;
function getAreaWeightedTable(var catchDict: TDictionary<String, TGISCatch>;
  shpFilePath: String; catchNameFld: String; propNameFld: String): Boolean;
function getAreaWeightedTableLuse(var catchDict: TDictionary<String, TGISCatch>;
  shpFilePath: String; catchNameFld: String; propNameFld: String): Boolean;
function processRoadShoulders(var catchDict: TDictionary<String, TGISCatch>;
  shpFilePath: String; catchNameFld: String; propNameFld: String): Boolean;
function getLayer(shpFilePath: String): OGRLayerH;
function createPLRMCatchmentObjs(CDict: TDictionary<String, TGISCatch>)
  : Boolean;

procedure intersectShapeFilesAsLayers(shp1FilePath: String;
  shp2FilePath: String; outShpFilePath: String;
  resultShpFileType: OGRwkbGeometryType);
procedure listGDalDrivers();

implementation

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
      if (CDict.Items[tempKey] is TGISCatch) then
      begin
        if (tempCatch.tempWeightedVal < minSlope) then
          tempCatch.tempWeightedVal := minSlope;
        CDict.Items[tempKey].aveSlope := tempCatch.tempWeightedVal;
        CDict.Items[tempKey].totalSlopeArea := tempCatch.tempTotalArea;
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
          tempCatch.luseDict := TDictionary<String, TGSAreaWTObj>.Create
            (tempCatch.TempAreaWTDict)
        else
          tempCatch.soilsDict := TDictionary<String, TGSAreaWTObj>.Create
            (tempCatch.TempAreaWTDict);
        // IMPORTANT free dict below for next set of intersections and calcs
        tempCatch.TempAreaWTDict.Free;
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

  flag := processRoadShoulders(CDict, dir + intcatchRdShd + shpExt,
    fldNameCatch, fldNameRdShoulder);

  // calculation was successful if flag is true so copy tempdict to rdShouldersDict of each catchment
  if (flag) then
    for tempKey in CDict.Keys do
      if (CDict.Items[tempKey] is TGISCatch) then
      begin
        tempCatch := CDict.Items[tempKey];
        tempCatch.rdShouldersDict := TDictionary<String, TGSAreaWTObj>.Create
          (tempCatch.TempAreaWTDict);
        // IMPORTANT free dict below for next set of intersections and calcs
        tempCatch.TempAreaWTDict.Free;
      end;
  Result := flag;
end;

function processRdConn(dir: String;
  CDict: TDictionary<String, TGISCatch>): Boolean;
var
  flag: Boolean;
  tempKey: String;
  tempCatch: TGISCatch;
begin
  intersectShapeFilesAsLayers(dir + catchDSName + shpExt,
    dir + rdCondDSName + shpExt, dir + intcatchRdConn + shpExt,
    OGRwkbGeometryType.wkbLineString);

  flag := processRoadShoulders(CDict, dir + intcatchRdShd + shpExt,
    fldNameCatch, fldNameRdConn);
  // calculation was successful if flag is true so copy tempdict to lusedict of each catchment
  if (flag) then
    for tempKey in CDict.Keys do
      if (CDict.Items[tempKey] is TGISCatch) then
      begin
        tempCatch := CDict.Items[tempKey];
        tempCatch.rdConnDict := TDictionary<String, TGSAreaWTObj>.Create
          (tempCatch.TempAreaWTDict);
        // IMPORTANT free dict below for next set of intersections and calcs
        tempCatch.TempAreaWTDict.Free;
      end;
  Result := flag;
end;

function runGISOps(): Boolean;
var
  tempKey: String;
  dir: String;
  CDict: TDictionary<String, TGISCatch>;
  flag: Boolean;
  tempCatch: TGISCatch;
begin
  shpExt := '.shp';
  dir := defaultGISDir + '\';
  // Step 0: Validate layers

  // Step 1: Calc catchment areas
  // *******************************************
  // Create dict to hold catchment properties
  CDict := TDictionary<String, TGISCatch>.Create;

  // Step 2: Catchment average slopes
  // *******************************************
  // Intersect catchment layer and slopes layer and calc area-weighted slope by catchment
  processSlopes(dir, CDict);

  // Step 3: Catchment land uses
  // *******************************************
  // Intersect catchment layer and landuse layer and calc area-weighted landuse by catchment
  processLusesOrSoils(dir, CDict, luseDSName, intcatchLuse, fldNameLuseCode, 0);

  // Step 4: Catchment land uses
  // *******************************************
  // Intersect catchment layer and soils layer and calc area-weighted soils by catchment
  processLusesOrSoils(dir, CDict, soilsDSName, intcatchSoil,
    fldNameSoilCode, 1);

  // Step 5: Road shoulders
  // *******************************************
  // Intersect catchment layer and road shoulders layer and calc lengths of each kind of shoulder
  processRdShoulders(dir, CDict);

  // Step 6: Road connectivity
  // *******************************************
  // Intersect catchment layer and road runoff connectivity layer and calc lengths of each kind of connectivity
  processRdConn(dir, CDict);

  Result := True;
end;

function createPLRMCatchmentObjs(CDict: TDictionary<String, TGISCatch>)
  : Boolean;
var
  I, J: Integer;
  tempKey: String;
  flag: Boolean;
  tempCatch: TGISCatch;
  newCatch: TPLRMCatch;
begin
  for tempKey in CDict.Keys do
    if (CDict.Items[tempKey] is TGISCatch) then
    begin
      tempCatch := CDict.Items[tempKey];
      // mpCatch.id= id;
      newCatch.ObjIndex := -1;
      newCatch.ObjType := -1;
      newCatch.name := tempCatch.id;
      newCatch.hasDefLuse := True;
      newCatch.hasDefSoils := True;
      // newCatch.hasDefPSCs := false;
      // newCatch.hasphysclProps := false;
      // newCatch.hasDefDrnXtcs := false;
      newCatch.hasDefRoadPolls := False;
      newCatch.hasDefRoadDrainage := False;
      newCatch.hasDefParcelAndDrainageBMPs := False;
      newCatch.hasDefCustomBMPSizeData := False;

      newCatch.area := tempCatch.totalCatchArea;
      newCatch.slope := tempCatch.aveSlope;
    end;
end;

// computes area weighted average of a single field with multiple possible values such as catchment landuses
function processRoadShoulders(var catchDict: TDictionary<String, TGISCatch>;
  shpFilePath: String; catchNameFld: String; propNameFld: String): Boolean;
var
  I, J: Integer;
  ogrLayer: OGRLayerH;
  feat: OGRFeatureH;
  geom: OGRGeometryH;
  catchFldIdx, propCodeFldIdx: longint;
  catchName, propCode, tempKey, tempPropKey: String;
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
      catchName := OGR_F_GetFieldAsString(feat, catchFldIdx);
      propCode := OGR_F_GetFieldAsString(feat, propCodeFldIdx);
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
  I, J: Integer;
  ogrLayer: OGRLayerH;
  feat: OGRFeatureH;
  geom: OGRGeometryH;
  catchFldIdx, propCodeFldIdx: longint;
  catchName, propCode, tempKey, tempPropKey: String;
  tempArea: Double;
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
      catchName := OGR_F_GetFieldAsString(feat, catchFldIdx);
      propCode := OGR_F_GetFieldAsString(feat, propCodeFldIdx);
      geom := OGR_F_GetGeometryRef(feat);
      tempArea := OGR_G_GetArea(geom);

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
              tempCatch.tempTotalArea := tempCatch.tempTotalArea + tempArea;

              // accumulate total area for this variable e.g. SFR sliver
              tempAreaWTObj.tempTotalArea := tempCatch.totalCatchArea +
                tempArea;
              tempAreaWTObj.tempAccumulation := tempAreaWTObj.tempTotalArea;
              tempAreaWTObj.tempWeightedVal := tempAreaWTObj.tempTotalArea;
            end;
          end
          else
          begin
            tempAreaWTObj := TGSAreaWTObj.Create;
            tempAreaWTObj.tempTotalArea := tempArea;
            tempAreaWTObj.tempAccumulation := tempArea;
            tempAreaWTObj.tempWeightedVal := 0;
            tDict.Add(propCode, tempAreaWTObj);
          end;
        end
      end
      else
      begin
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
  I, J: Integer;
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
      catchName := OGR_F_GetFieldAsString(feat, catchFldIdx);
      propVal := OGR_F_GetFieldAsDouble(feat, propFldIdx);
      geom := OGR_F_GetGeometryRef(feat);
      tempArea := OGR_G_GetArea(geom);

      // Try looking up current catchment.
      if catchDict.ContainsKey(catchName) then
      begin
        if (catchDict.TryGetValue(catchName, tempCatch) = True) then
        begin
          tempCatch.id := catchName;
          tempCatch.tempTotalArea := tempCatch.totalCatchArea + tempArea;
          tempCatch.tempAccumulation := tempCatch.tempAccumulation + tempArea
            * propVal
        end
      end
      else
      begin
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

function gdalVersion(): AnsiString;
var
  tempStr: AnsiString;
begin
  tempStr := GDALVersionInfo('VERSION_NUM');
  Result := tempStr;
end;

function getLayer(shpFilePath: String): OGRLayerH;
var
  ogrShp1, ogrShp2, ogrShp3, intersectLayer: OGRLayerH;
  ds1: OGRDataSourceH;
  ogrDriver: OGRSFDriverH;
  ogrDS: OGRDataSourceH;
  ogrLayer: OGRLayerH;
begin
  // OGRRegisterAll;
  // get handle on shapefile driver
  ogrDriver := OGRGetDriverByName(PAnsiChar(driverName));
  if ogrDriver = Nil then
  begin
    ShowMessage(Format('%s driver not available.', [driverName]));
    Result := nil;
    exit;
  end;

  // check to see if intersect result shp file already exists
  if FileExists(shpFilePath) then
  begin
    // Prepare to intersect source shapefiles
    ds1 := OGR_Dr_Open(ogrDriver, PAnsiChar(AnsiString(shpFilePath)), 0);
    if ogrDriver = Nil then
    begin
      ShowMessage(Format('unable to open %s.', [shpFilePath]));
      Result := nil;
      exit;
    end;
    ogrShp1 := OGROpen(PAnsiChar(AnsiString(shpFilePath)), 0, Nil);
    ogrLayer := OGR_DS_GetLayer(ogrShp1, 0);
    if ogrShp1 = nil then
    begin
      ShowMessage(shpFilePath + ' was not found');
      Result := nil;
      exit;
    end;
  end;
  Result := ogrLayer;
end;

procedure intersectShapeFilesAsLayers(shp1FilePath: String;
  shp2FilePath: String; outShpFilePath: String;
  resultShpFileType: OGRwkbGeometryType);
var
  ogrShp1, ogrShp2, ogrShp3, intersectLayer: OGRLayerH;
  ds1, ds2, intersectshp: OGRDataSourceH;
  pszName: PAnsiString;
  bUpdate: longint;
  ogrDriver: OGRSFDriverH;
  ogrDS: OGRDataSourceH;
  ogrRef: OGRSpatialReferenceH;
  ogrLayer: OGRLayerH;
  geomType: OGRwkbGeometryType;
  featureCount, I, J: longint;
  geom1, geom2, intGeom: OGRGeometryH;
  feature1, feature2, intFeature: OGRFeatureH;
  feature1Count, feature2Count: longint;
  flagIntersects, err: longint;
  fld1, fld2: OGRFieldDefnH;
  featDefn: OGRFeatureDefnH;
  intDSName: String;
begin
  OGRRegisterAll;

  // get handle on shapefile driver
  ogrDriver := OGRGetDriverByName(PAnsiChar(driverName));
  if ogrDriver = Nil then
  begin
    ShowMessage(Format('%s driver not available.', [driverName]));
    exit;
  end;

  // get name of resulting intersected shapefile from path passed in
  intDSName := ChangeFileExt(ExtractFileName(outShpFilePath), '');

  // check to see if intersect result shp file already exists
  if FileExists(outShpFilePath) then
  begin
    for I := 0 to High(shpExts) do
      DeleteFile(intDSName + shpExts[I]);
  end;

  // create shape file to hold results of intersect operation
  // first try to create datasource
  ogrDS := OGR_Dr_CreateDataSource(ogrDriver,
    PAnsiChar(AnsiString(outShpFilePath)), Nil);
  if ogrDS = Nil then
  begin
    ShowMessage(Format('Failed to create output file %s.', [outShpFilePath]));
    exit;
  end;

  // now try to create layer inside datasource
  ogrLayer := OGR_DS_CreateLayer(ogrDS, PAnsiChar(AnsiString(intDSName)), Nil,
    resultShpFileType, Nil);
  if ogrLayer = Nil then
  begin
    ShowMessage(Format('Failed to create layer %s in datasource.',
      [intDSName]));
    exit;
  end;

  ogrShp1 := OGROpen(PAnsiChar(AnsiString(shp1FilePath)), 0, Nil);
  ogrShp1 := OGR_DS_GetLayer(ogrShp1, 0);
  if ogrShp1 = nil then
    ShowMessage(shp1FilePath + ' was not found');

  ogrShp2 := OGROpen(PAnsiChar(AnsiString(shp2FilePath)), 0, Nil);
  ogrShp2 := OGR_DS_GetLayer(ogrShp2, 0);
  if ogrShp2 = nil then
    ShowMessage(shp2FilePath + ' was not found');

  err := OGR_L_Intersection(ogrShp1, ogrShp2, ogrLayer, nil, nil, nil);
  if err <> OGRERR_NONE then
  begin
    ShowMessage(Format('Failed to intersect layers: %d', [err]));
  end;

  // release the datasource
  err := OGRReleaseDatasource(ogrDS);
  if err <> OGRERR_NONE then
  begin
    // ShowMessage(Format('Error releasing datasource: %d', [err]));
  end;
  OGRCleanupAll;
end;

procedure listGDalDrivers();
var
  driver: GDALDriverH;
  driverShortName, driverLongName: CPChar;
  driverOptions, driverHelp: CPChar;
  driversCount, I: longint;

begin
  GDALAllRegister;

  driversCount := GDALGetDriverCount;
  writeln(driversCount, ' drivers are registered.');

  // iterate over drivers and get their metadata and capabilities
  for I := 0 to driversCount - 1 do
  begin
    driver := GDALGetDriver(I);
    if driver = Nil then
    begin
      writeln('Failed to get driver ', I);
      writeln;
      continue;
    end;

    driverShortName := GDALGetDriverShortName(driver);
    driverLongName := GDALGetDriverLongName(driver);
    driverOptions := GDALGetDriverCreationOptionList(driver);
    driverHelp := GDALGetDriverHelpTopic(driver);

    writeln(Format('Driver %2d short name is %s',
      [I, string(driverShortName)]));
    writeln(Format('Driver %2d long name is %s', [I, string(driverLongName)]));
    writeln(Format('Driver %2d help URL is %s', [I, string(driverHelp)]));
    writeln(Format('Driver %2d options are %s', [I, string(driverOptions)]));

    writeln;
  end;
end;

end.
