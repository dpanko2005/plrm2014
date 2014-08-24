unit GSGdal;

{ Declarations of imported procedures from the GDALL C Api from GDAL DLL }
{ (Gdal.DLL) }

interface

uses
  SysUtils, Forms, Dialogs, Generics.Collections,
  Classes, gdal, gdalcore, ogr, GSUtils, GSTypes;

type
  TGISCatch = class
    id: String;
    aveSlope: Double;
    totalArea: Double;
  end;

const
  shpExts: array [0 .. 4] of string = ('.shp', '.shx', '.prj', '.dbf', '.sbn');

  catchDSName = 'PLRM_Catchments';
  bmpsDSName = 'PLRM_BMPs';
  luseDSName = 'PLRM_LandUse';
  slopeDSName = 'PLRM_Slope';
  soilsDSName = 'PLRM_Soils';
  rdCondDSName = 'PLRM_RoadCondition';
  rdShdlrErosionDSName = 'PLRM_ShoulderErosion';
  rsRunoffConnDSName = 'PLRM_RunoffConnectivity';

  intcatchSlope = 'PLRM_CatchSlopes';

  // dsName = 'test.shp';
  layerNum = 0;
  // layerName = 'test';
  driverName = 'ESRI Shapefile';

function runGISOps(): Boolean;
function gdalVersion(): AnsiString;
function getAreaWeightedTable(var catchDict: TDictionary<String, TGISCatch>;
  shpFilePath: String; catchNameFld: String; propNameFld: String): Boolean;
function getLayer(shpFilePath: String): OGRLayerH;
// function intersectShapeFiles(shp1FilePath: String;
// shp2FilePath: String; resultShpFilePath:String): Boolean;
procedure intersectShapeFilesAsLayers(shp1FilePath: String;
  shp2FilePath: String; outShpFilePath: String);
procedure listGDalDrivers();

implementation

function runGISOps(): Boolean;
var
  I, J: Integer;
  shpExt: String;
  dir: String;
  CDict: TDictionary<String, TGISCatch>;
begin
  shpExt := '.shp';
  dir := defaultGISDir + '\';
  // Step 1: Validate layers

  // Step 1: Calc catchment areas
  // Create dict to hold catchment properties
  CDict := TDictionary<String, TGISCatch>.Create;

  // Step 2: Catchment average slopes
  // Intersect catchment layer and slopes layer and calc area-weighted slope by catchment
  intersectShapeFilesAsLayers(dir + catchDSName + shpExt,
    dir + slopeDSName + shpExt, dir + intcatchSlope + shpExt);

  getAreaWeightedTable(CDict, dir + intcatchSlope + shpExt, 'NAME', 'SLOPE');

  // Step 3: Catchment land uses
  // Intersect catchment layer and landuse layer and calc area-weighted landuse by catchment
  // intersectShapeFilesAsLayers(dir + catchDSName + shpExt,
  // dir + luseDSName + shpExt, dir + intcatchSlope + shpExt);

  Result := True;
end;

function getAreaWeightedTable(var catchDict: TDictionary<String, TGISCatch>;
  shpFilePath: String; catchNameFld: String; propNameFld: String): Boolean;
var
  I, J: Integer;
  ogrLayer: OGRLayerH;
  feat: OGRFeatureH;
  geom: OGRGeometryH;
  catchFldIdx, propFldIdx: longint;
  catchName: String;
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
      tempArea = OGR_G_GetArea(geom);

      // Try looking up current catchment.
      if catchDict.ContainsKey(catchName) then
      begin
        if (catchDict.TryGetValue(catchName, tempCatch) = True) then
        begin
          tempCatch.id := catchName;
          tempCatch.totalArea := tempCatch.totalArea + tempArea;
          tempCatch.aveSlope := tempCatch.aveSlope + (tempArea * propVal);
        end
      end
      else
      begin
        tempCatch := TGISCatch.Create;
        tempCatch.id := catchName;
        tempCatch.totalArea := tempArea;
        tempCatch.aveSlope := tempArea * propVal;
        catchDict.Add(catchName, tempCatch);
      end;
    end;

    feat := OGR_L_GetNextFeature(ogrLayer);
  until feat = nil;

  Result := True;
end;

function gdalVersion(): AnsiString;
var
  tempStr: AnsiString;
begin
  tempStr := GDALVersionInfo('VERSION_NUM');
  Result := tempStr;
end;

{ function intersectShapeFiles(shp1FilePath: String;
  shp2FilePath: String): Boolean;
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
  begin
  OGRRegisterAll;

  // get handle on shapefile driver
  ogrDriver := OGRGetDriverByName(PAnsiChar(driverName));
  if ogrDriver = Nil then
  begin
  ShowMessage(Format('%s driver not available.', [driverName]));
  exit;
  end;

  // check to see if intersect result shp file already exists
  if FileExists(dsName) then
  begin
  for I := 0 to High(shpExts) do
  DeleteFile(layerName + shpExts[I]);
  end;

  // create shape file to hold results of intersect operation
  // first try to create datasource
  ogrDS := OGR_Dr_CreateDataSource(ogrDriver, dsName, Nil);
  if ogrDS = Nil then
  begin
  ShowMessage(Format('Failed to create output file %s.', [dsName]));
  exit;
  end;

  // now try to create layer inside datasource
  ogrLayer := OGR_DS_CreateLayer(ogrDS, layerName, Nil, wkbPolygon, Nil);
  if ogrLayer = Nil then
  begin
  ShowMessage(Format('Failed to create layer %s in datasource.',
  [layerName]));
  exit;
  end;

  // create new field in the layer
  fld1 := OGR_Fld_Create('Name', OFTString);
  OGR_Fld_SetWidth(fld1, 10);
  err := OGR_L_CreateField(ogrLayer, fld1, 1);
  if err <> OGRERR_NONE then
  begin
  ShowMessage('Failed to create field.');
  exit;
  end;

  // Prepare to intersect source shapefiles
  ds1 := OGR_Dr_Open(ogrDriver, PAnsiChar(shp1FilePath), 0);
  if ogrDriver = Nil then
  begin
  ShowMessage(Format('unable to open %s.', [shp1FilePath]));
  exit;
  end;

  ogrShp1 := OGROpen(PAnsiChar(AnsiString(shp1FilePath)), 0, Nil);
  ogrShp1 := OGR_DS_GetLayer(ogrShp1, 0);
  if ogrShp1 = nil then
  ShowMessage(shp1FilePath + ' was not found');

  // get spatial reference for one of shp files being intersected
  ogrRef := OGR_L_GetSpatialRef(ogrShp1);

  ogrShp2 := OGROpen(PAnsiChar(AnsiString(shp2FilePath)), 0, Nil);
  ogrShp2 := OGR_DS_GetLayer(ogrShp2, 0);
  if ogrShp2 = nil then
  ShowMessage(shp2FilePath + ' was not found');

  // feature1Count := OGR_L_GetFeatureCount(ogrShp1, 1);
  // feature2Count := OGR_L_GetFeatureCount(ogrShp2, 1);

  Repeat
  feature1 := OGR_L_GetNextFeature(ogrShp1);
  geom1 := OGR_F_GetGeometryRef(feature1);

  if (geom1 <> nil) then
  begin
  // Move read cursor to the nIndex'th feature in the current resultset
  OGR_L_SetNextByIndex(ogrShp2, 0);
  Repeat

  feature2 := OGR_L_GetNextFeature(ogrShp2);
  geom2 := OGR_F_GetGeometryRef(feature2);
  if (geom2 <> nil) then
  begin
  // select only the intersections
  flagIntersects := OGR_G_Intersects(geom1, geom2);
  if flagIntersects = 0 then
  begin

  // create geometry from intersecting features
  intGeom := OGR_G_Intersection(geom1, geom2);
  if (intGeom <> nil) then
  begin

  // create new feature and fill attributes (fields)
  intFeature := OGR_F_Create(OGR_L_GetLayerDefn(ogrLayer));
  OGR_F_SetFieldString(intFeature, 0, 'first');

  // assign spatial reference to intersection result layer
  OGR_G_AssignSpatialReference(intGeom, ogrRef);

  // add previously created geometry to the feature
  // err := OGR_F_SetGeometryDirectly(intFeature, intGeom);
  err := OGR_F_SetGeometry(intFeature, intGeom);
  if err <> OGRERR_NONE then
  begin
  ShowMessage
  ('Intersection: Failed to set geometry to the feature.');
  exit;
  end;

  // write feature to the layer
  err := OGR_L_CreateFeature(ogrLayer, intFeature);
  if err <> OGRERR_NONE then
  begin
  ShowMessage('Intersection: Failed to write feature in layer.');
  exit;
  end;
  OGR_F_Destroy(intFeature);
  end;
  end;
  end;
  until feature2 = nil;
  end;
  until feature1 = nil;

  // release the datasource
  err := OGRReleaseDatasource(ogrDS);
  if err <> OGRERR_NONE then
  begin
  // ShowMessage(Format('Error releasing datasource: %d', [err]));
  end;
  OGRCleanupAll;
  Result := True;
  end;
}

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
  shp2FilePath: String; outShpFilePath: String);
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
    wkbPolygon, Nil);
  if ogrLayer = Nil then
  begin
    ShowMessage(Format('Failed to create layer %s in datasource.',
      [intDSName]));
    exit;
  end;

  // Prepare to intersect source shapefiles
  ds1 := OGR_Dr_Open(ogrDriver, PAnsiChar(AnsiString(shp1FilePath)), 0);
  if ogrDriver = Nil then
  begin
    ShowMessage(Format('unable to open %s.', [shp1FilePath]));
    exit;
  end;

  ogrShp1 := OGROpen(PAnsiChar(AnsiString(shp1FilePath)), 0, Nil);
  ogrShp1 := OGR_DS_GetLayer(ogrShp1, 0);
  if ogrShp1 = nil then
    ShowMessage(shp1FilePath + ' was not found');

  // get spatial reference for one of shp files being intersected
  ogrRef := OGR_L_GetSpatialRef(ogrShp1);

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
