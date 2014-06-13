unit GSDataAccess;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, ComCtrls, StdCtrls, Buttons, DB, ADODB, Uglobals,
  GSUtils, GSTypes;

Const
  // dbPath = defaultDBPath;
  // connStr = 'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=' + dbPath + ';Persist Security Info=False;';
  NUMQUERIES = 8;

const
  dbTblQrys: array [0 .. 11] of String = ('Place holder for title TODO',
    'SELECT * FROM EVAPORATION', 'SELECT t1.ID, t1.Category,' +
    ' IIf(IsNull(t1.Parameter), switch(t1.Category=''START_DATE'',' +
    '(select START_DATE from SimulationPeriod where ID = <PARAM>),t1.Category =''REPORT_START_DATE'',(select REPORT_START_DATE from SimulationPeriod where ID = <PARAM>),t1.Category=''END_DATE'',(select END_DATE from SimulationPeriod '
    + 'where ID = <PARAM>)),t1.Parameter) AS Parameter FROM Options as t1',
    'SELECT ta.AqName AS Name, mg.Porosity' +
    ' AS Porosity, mg.WiltingPoint AS [Wilt Point], mg.[Field Capacity] ' +
    'AS [Field Capac], mg.AquiferKsat AS [Hyd Cond], ta.[Conductivity Slope] AS [Cond Slope], ta.[Tension Slope] AS [Tens Slope], ta.[Upper Evaporation Fraction] AS [Upper Evap], ta.[Lower Evaporation Depth]'
    + ' AS [Lower Evap], ta.[Lower Groundwater Loss Rate] AS [Lower Loss], ta.[Bottom Elevation] AS [Bottom Elev], '
    + 'ta.[Water Table Elevation] AS [Water Table], mg.UnsatZoneMoisture AS [Upper Moist]FROM Aquifer as ta, MetGrid as mg WHERE (((mg.ID)= <PARAM>));',
    'SELECT tg.Subcatchment, tg.Aquifer,' +
    ' tg.ReceivingNode AS Node, MetGrid.AvgElev AS [Surf Elev],' +
    ' tg.GroundwaterFlowCoefficient AS A1, tg.GroundwaterFlowExponent AS B1, tg.SurfaceWaterFlowCoefficient AS A2, tg.[SurfaceWaterFlow Exponent]'
    + ' AS B2, tg.SurfaceGWInteractionCoefficient AS A3, tg.FixedSurfaceWaterDepth AS [Fixed Depth], '
    + 'tg.ThresholdGroundwaterElevation AS [GW Elev] FROM GroundWater as tg, MetGrid WHERE (((MetGrid.ID)=<PARAM>));',
    'SELECT * FROM SNOWPACKS',
    'SELECT "WINDSPEED" AS Expr1, "MONTHLY" AS Expr2, tmw.January, tmw.February, tmw.March, tmw.April, tmw.May, tmw.June, tmw.July, tmw.August, tmw.September,  tmw.October, tmw.November, tmw.December '
    + 'FROM MonthlyWindSpeed as tmw; ' + 'UNION ' +
    'SELECT "SNOWMELT" AS Expr1, tsm.DividingTemp, tsm.ATI, tsm.NegativeMeltRatio, dpqrySM.[Surf Elev], tsm.Latitude, tsm.LongitudeCorrection, "''", "''", "''", "''", "''", "''", "''" '
    + 'FROM SnowMelt as tsm, ' +
    '(SELECT "SNOWMELT" AS Expr1, tsm.DividingTemp, tsm.ATI, MetGrid.AvgElev AS [Surf Elev], tsm.NegativeMeltRatio, tsm.Latitude, tsm.LongitudeCorrection '
    + 'FROM MetGrid, SnowMelt AS tsm ' +
    'WHERE (MetGrid.ID = <P1> )) as dpqrySM; ' + 'UNION ' +
    'SELECT "ADC" AS Expr1, tad.Surface, tad.AD0, tad.AD1, tad.AD2, tad.AD3, tad.AD4, tad.AD5, tad.AD6, tad.AD7, tad.AD8,  tad.AD9, "''", "''" '
    + 'FROM ArealDepletion as tad ' + 'ORDER BY Expr1, Expr2 DESC;',
    'SELECT ([st.Month] & "/" & [st.Day] & "/" ' +
    '& [st.Year]) AS Date1, ([st.Hour] & ":00") AS Time1, ((select MetGrid.TempCorr'
    + ' From MetGrid where ID=''&gridNum&'')+AirTemp) AS Monthly FROM SnoTelTimeSeries as st'
    + ' WHERE (((st.SnoTelID)=(Select [SnoTelID] from MetGrid where ID=''&gridNum&''))) ORDER BY st.Year, st.Month, st.Day, st.Hour;',
    'SELECT * FROM Soils',
    'SELECT "WINDSPEED" AS Expr1, "MONTHLY" AS Expr2, tmw.January, tmw.February, tmw.March, tmw.April, tmw.May, tmw.June, tmw.July, tmw.August, tmw.September, tmw.October, tmw.November, tmw.December FROM tblMonthlyWindSpeed as tmw; '
    + 'UNION SELECT "SNOWMELT" AS Expr1, tsm.DividingTemp, tsm.ATI, tsm.NegativeMeltRatio, '
    + 'dpqrySM.[Surf Elev], tsm.Latitude, tsm.LongitudeCorrection, "na3", "na4", "na5", "na6", "na7", "na8", "na9" '
    + 'FROM SnowMelt as tsm, ' +
    '(SELECT "SNOWMELT" AS Expr1, tsm1.DividingTemp, tsm1.ATI, MetGrid.AvgElev AS [Surf Elev], tsm1.NegativeMeltRatio, tsm1.Latitude, tsm1.LongitudeCorrection '
    + 'FROM MetGrid, SnowMelt AS tsm1 ' +
    'WHERE (MetGrid.ID = <P1> )) as dpqrySM; ' +
    'UNION SELECT "ADC" AS Expr1, tad.Surface, Switch(<P2>="ND",tad.ND0,<P2>="NA",tad.NA0), '
    + 'Switch(<P2>="ND",tad.ND1,<P2>="NA",tad.NA1), Switch(<P2>="ND",tad.ND2,<P2>="NA",tad.NA2), '
    + 'Switch(<P2>="ND",tad.ND3,<P2>="NA",tad.NA3), Switch(<P2>="ND",tad.ND4,<P2>="NA",tad.NA4), Switch(<P2>="ND",tad.ND5,<P2>="NA",tad.NA5), '
    + 'Switch(<P2>="ND",tad.ND6,<P2>="NA",tad.NA6), Switch(<P2>="ND",tad.ND7,<P2>="NA",tad.NA7), Switch(<P2>="ND",tad.ND8,<P2>="NA",tad.NA8), Switch(<P2>="ND",tad.ND9,<P2>="NA",tad.NA9), "na1", "na2" '
    + 'FROM ArealDepletion as tad',
    'SELECT * FROM Codes WHERE (((Codes.code) Like "<CODEPREFIX>"))',
    'SELECT Soils.MU, Soils.MUName FROM Soils');

const
  dbTblNames: array [0 .. 11] of String = ('TITLE', 'EVAPORATION', 'OPTIONS',
    'AQUIFERS', 'GROUNDWATER', 'SNOWPACKS', 'TEMPERATURE2', 'SnoTelTimeSeries',
    'Soils', 'Soils_tmp', 'codes', 'Soils');

  // Begin runtime querries and resulting table names
  // uses sentinels T* = table name, F* = field name, V* = value, R1 is return value field name etc
const
  dbRunTimeQrys: array [0 .. 20] of String =
    ('SELECT <R1> FROM <T1> as T1 WHERE (T1.<F1> = <V1> AND T1.<F2> =<V2> )',
    'SELECT T1.PollutantPotentialScore, T1.PollutantCode, T1.CRCValue FROM RoadCRCs as T1 WHERE (((T1.PollutantPotentialScore)=<V1>)) ORDER BY T1.PollutantCode;',
    'SELECT T1.SweeperTypeScore, T1.SweepFrequencyScore, T1.PollutantCode, T1.Percent_Red FROM SweepingEffectiveness as T1 WHERE (((T1.SweeperTypeScore)=<V1>) AND ((T1.SweepFrequencyScore)=<V2>))ORDER BY T1.PollutantCode;',
    'SELECT ParcelCRCs.* FROM ParcelCRCs ORDER BY ParcelCRCs.ParcelLandUseAndRisk, ParcelCRCs.PollutantCode',
    'SELECT Soils.MU, (Soils.KsatPervious) AS ksp, (sg.KsatBMP) AS ksb, (sg.SoilSuctionHead) AS ssh, (Soils.SoilMoisDef) AS smd '
    + 'FROM Soils LEFT JOIN HydSoilGroup AS sg ON Soils.HydSoilGroupID = sg.ID WHERE ((Soils.MU) In (<P1>));',
    'SELECT * FROM Defaults WHERE (Defaults.ID Like (<P1>)) ORDER BY Defaults.displayOrder;',
    'SELECT SWTDesignParameters.*, "0" as userValue FROM SWTDesignParameters WHERE (((SWTDesignParameters.SWT_Code) Like (<P1>))) ORDER BY SWTDesignParameters.displayOrder;',
    'SELECT SWTCECs.*, "0" as userValue FROM SWTCECs WHERE (((SWTCECs.SWT_Code) Like (<P1>))) ORDER BY SWTCECs.displayOrder;',
    'SELECT * FROM Defaults WHERE (Defaults.ID Like (<P1>)) ORDER BY Defaults.displayOrder;',
    'SELECT Codes.PLRM_Name, Pollutants.Pollutant, "NONE" as Fxn, "0.0" as Coef1, "0.0" as Coef2, "0.0" as Coef3, "AREA" as Normalizer FROM Codes, Pollutants WHERE (((Codes.code) Like "1%"))',
    'SELECT Codes.PLRM_Name, Pollutants.Pollutant, "NONE" as Fxn, "0.0" as Coef1, "0.0" as Coef2, "0.0" as cleanEff, "EMC" as bmpEff FROM Codes, Pollutants WHERE (((Codes.code) Like "1%"))',
    'SELECT * FROM Pollutants',
    'SELECT ttts.Dates AS [Date], ttts.Times AS [Hour], round(((select MetGrid.TempCorr From MetGrid where ID= <P1>)+AirTemp),2) AS TempF '
    + 'FROM TempTimeSeries AS ttts ' +
    'WHERE (((ttts.SnoTelID)=(Select [SnoTelID] from MetGrid where ID= <P1>))) ORDER BY ttts.Dates, ttts.Times;',
    'SELECT tpts.SnoTelID, tpts.Year, tpts.Month, tpts.Day, tpts.Hour, tpts.Min, Switch( '
    + '[Month]=12,round(((select PrecipCorrDec from MetGrid where ID= <P1>)*Precip*100),0)/100, '
    + '[Month]=11,round(((Select PrecipCorrNov from MetGrid where ID= <P1>)*Precip*100),0)/100, '
    + '[Month]=10,round(((Select PrecipCorrOct From MetGrid where ID= <P1>)*Precip*100),0)/100, '
    + '[Month]=9,round(((select PrecipCorrSep From MetGrid where ID= <P1>)*Precip*100),0)/100, '
    + '[Month]=8,round(((select MetGrid.PrecipCorrAug From MetGrid where ID= <P1>)*Precip*100),0)/100, '
    + '[Month]=7,round(((select MetGrid.PrecipCorrJul From MetGrid where ID= <P1>)*Precip*100),0)/100, '
    + '[Month]=6,round(((select MetGrid.PrecipCorrJun From MetGrid where ID= <P1>)*Precip*100),0)/100, '
    + '[Month]=5,round(((select MetGrid.PrecipCorrMay From MetGrid where ID= <P1>)*Precip*100),0)/100, '
    + '[Month]=4,round(((select MetGrid.PrecipCorrApr From MetGrid where ID= <P1>)*Precip*100),0)/100, '
    + '[Month]=3,round(((select MetGrid.PrecipCorrMar From MetGrid where ID= <P1>)*Precip*100),0)/100, '
    + '[Month]=2,round(((select MetGrid.PrecipCorrFeb From MetGrid where ID= <P1>)*Precip*100),0)/100, '
    + '[Month]=1,round(((select MetGrid.PrecipCorrJan From MetGrid where ID= <P1>)*Precip*100),0)/100) AS Depth '
    + 'FROM PrecipTimeSeries AS tpts ' +
    'WHERE ((tpts.SnoTelID)=(Select [SnoTelID] from MetGrid where ID= <P1>) and Precip>0) '
    + 'ORDER BY tpts.Year, tpts.Month, tpts.Day, tpts.Hour;',
    'SELECT <F1> FROM <T1> <W1>;', 'SELECT * FROM BuildupParcels;',
    'SELECT * FROM ParcelCRCs;', 'SELECT * FROM LanduseParcels',
    'SELECT LandUses.code, LandUses.PLRM_Name, LandUses.name, LandUses.defaultImpervFrac FROM LandUses',
    'SELECT t.Parameter, t.Min, t.Max, t.Units, t.Flag, t.Description FROM catchmentValidationRules as t ORDER BY t.DisplayOrder',
    'SELECT t.Parameter, t.Min, t.Max, t.Units, t.Flag, t.Description FROM nodeValidationRules as t ORDER BY t.DisplayOrder');

const
  dbRunTimeQryTblNames: array [0 .. 20] of String = ('RdPollPot', 'RdCRCs',
    'SWPRReds', 'ParcelCRCs', 'soilsProps', 'Defaults', 'SWTDesignParameters',
    'SWTCECs', 'Defaults', 'BuildUp', 'WashOff', 'Pollutants', 'TempTimeSeries',
    'PrecipTimeSeries', 'Generic', 'BuildupParcels', 'ParcelCRCs',
    'LanduseParcels', 'LandUses', 'nodeValidationRules',
    'catchmentValidationRules');

var
  dbDataSets: array of TADODataSet;
  connStr: String;

function init(): Boolean;
procedure closeConn(); overload;
procedure closeConn(var conn: TADOConnection); overload;
function initConn(connStr: String): TADOConnection;
function generateTimeSeries(qry: String; tblName: String; fileDescrp: String;
  Var S: TStringList; conn: TADOConnection; var PBar: TProgressBar)
  : TStringList;
function generatePrecipTimeSeries(metGridNum: String; qry: String;
  tblName: String; fileDescrp: String; Var S: TStringList; conn: TADOConnection;
  PBar: TProgressBar): TStringList;
function getDbTable(tableName: String; connStr: String; sqlStr: String)
  : TADOTable; overload;
function getDbDataset(tableName: String; connStr: String; sqlStr: String)
  : TADODataSet; overload;
function getDbTable(tableName: String; conn: TADOConnection; sqlStr: String;
  flagCloseConn: Boolean): TADOTable; overload;
function getDbDataset(tableName: String; conn: TADOConnection; sqlStr: String;
  flagCloseConn: Boolean): TADODataSet; overload;
function getDBDataAsPLRMGridData(qry: String; rsltTblName: String;
  conn: TADOConnection): PLRMGridData;
function getDbDataset(DS: TADODataSet; tableName: String; conn: TADOConnection;
  sqlStr: String; flagCloseConn: Boolean): TADODataSet; overload;

function getOptions(Var S: TStringList; simTypeID: integer;
  conn: TADOConnection): TStringList;
function getEvap(Var S: TStringList; conn: TADOConnection): TStringList;
function getAquifers(Var S: TStringList; metGrid: integer; conn: TADOConnection)
  : TStringList;
function getGroundWater(Var S: TStringList; metGrid: integer;
  conn: TADOConnection): TStringList;
function getSnowPacks(Var outSnowPackNames: TStringList; conn: TADOConnection)
  : TStringList;
function getTemperature1(Var S: TStringList; metGrid: integer; adcType: String;
  conn: TADOConnection): TStringList;
function getMapUnitMuName(Var S: TStringList; conn: TADOConnection)
  : TStringList;
function getSWMMDefaults(Var outCodes: TStringList; Var outValues: TStringList;
  codePrefix: string; conn: TADOConnection): TStringList;

// Used on drng details form
function getSoilsProps(numMapUnits: integer; delimMapUnits: String;
  conn: TADOConnection): PLRMGridData;

// used on PSC forms
function getCodes(Var S: TStringList; codePrefix: String; conn: TADOConnection)
  : TStringList; overload;
function getCodes(Var S: TStringList; codePrefix: String; fldNum: integer;
  conn: TADOConnection): TStringList; overload;
function getCodesAndvalues(Var outCodes: TStringList;
  Var outValues: TStringList; codePrefix: string; conn: TADOConnection)
  : TStringList;
function lookUpValFrmTable(sqlQry: String; tblName: String;
  conn: TADOConnection; flagCloseConn: Boolean): String; overload;
function lookUpValFrmTable(sqlQry: String; tblName: String; fldNum: integer;
  conn: TADOConnection; flagCloseConn: Boolean): TStringList; overload;
function lookUpValFrmTable(sqlQry: String; tblName: String; fldNum1: integer;
  fldNum2: integer; conn: TADOConnection; flagCloseConn: Boolean)
  : dbReturnFields; overload;
function lookUpValFrmTable(sqlQry: String; tblName: String; fldNum1: integer;
  fldNum2: integer; fldNum3: integer; conn: TADOConnection;
  flagCloseConn: Boolean): dbReturnFields2; overload;
function lookUpValFrmTable(sqlQry: String; tblName: String; fldNum1: integer;
  fldNum2: integer; fldNum3: integer; fldNum4: integer; conn: TADOConnection;
  flagCloseConn: Boolean): dbReturnFields3; overload;

implementation

var
  ADOConn: TADOConnection;

  // TO DO - function to close connections and release memory
function init(): Boolean;
var
  I: integer;
begin
  Setlength(dbDataSets, NUMQUERIES);
  for I := 0 to High(dbTblQrys) do
  begin
    dbDataSets[I] := getDbDataset(dbTblNames[I], connStr, dbTblQrys[I]);
  end;
  Result := True;
end;

procedure closeConn();
begin
  closeConn(ADOConn);
end;

// Opens a new dataconnection. Call routine must close connection
function initConn(connStr: String): TADOConnection;
begin
  if Assigned(ADOConn) then
  begin
    if ADOConn.Connected = True then
    begin
      Result := ADOConn;
      Exit;
    end;
  end;

  try
    ADOConn := TADOConnection.Create(application);
    ADOConn.ConnectionString := connStr;
    ADOConn.LoginPrompt := false;
    if (ADOConn.Connected = false) then
      ADOConn.Open();
    if (ADOConn.Connected = True) then
      Result := ADOConn
    else
      Result := nil;
  except
    ShowMessage
      ('Connection to the database failed, Please close all applications and try again');
    Result := nil;
  end;
  // Result := nil;
end;

// Closes a database connection
procedure closeConn(var conn: TADOConnection);
begin
  conn.Close; // owned by application so freed by application
end;

function getDbDataset(tableName: String; connStr: String; sqlStr: String)
  : TADODataSet;
var
  ADOConn: TADOConnection;
  DS: TADODataSet;
begin
  ADOConn := TADOConnection.Create(application);
  DS := TADODataSet.Create(application);
  try
    ADOConn.ConnectionString := connStr;
    ADOConn.Open();
    if (ADOConn.Connected = True) then
    begin
      DS.Connection := ADOConn;
      DS.CommandText := sqlStr;
      DS.Active := True;
    end;
  except
    if ADOConn <> nil then
      ADOConn.Free;
    if DS <> nil then
      DS.Free;
  end;
  Result := DS;
end;

function getDbTable(tableName: String; conn: TADOConnection; sqlStr: String;
  flagCloseConn: Boolean): TADOTable;
var
  ADOTbl: TADOTable;
begin
  if (conn.Connected = True) then
  begin
    ADOTbl := TADOTable.Create(application);
    ADOTbl.Connection := conn;
    ADOTbl.Connection.Execute(sqlStr);
    ADOTbl.tableName := tableName;
    ADOTbl.Active := True;
    ADOTbl.First;
    if flagCloseConn then
      closeConn(conn);
    Result := ADOTbl;
  end
  else
    Result := nil;
end;

// Overloaded to use existing database connection
function getDbDataset(tableName: String; conn: TADOConnection; sqlStr: String;
  flagCloseConn: Boolean): TADODataSet;
var
  DS: TADODataSet;
begin
  if (conn.Connected = True) then
    DS := TADODataSet.Create(application)
  else
    Exit;
  try
    begin
      DS.Connection := conn;
      DS.CommandText := sqlStr;
      DS.Active := True;
      if flagCloseConn then
        closeConn(conn);
    end;
  except
    if flagCloseConn then
      closeConn(conn);
    if DS <> nil then
      DS.Free;
  end;
  Result := DS;
end;

// Overloaded to accept dataset. Pass in dataset with paramaters already set
function getDbDataset(DS: TADODataSet; tableName: String; conn: TADOConnection;
  sqlStr: String; flagCloseConn: Boolean): TADODataSet;
begin
  try
    if (conn.Connected = True) then
    begin
      DS.Connection := conn;
      DS.CommandText := sqlStr;
      DS.Active := True;
      if flagCloseConn then
        closeConn(conn);
    end;
  except
    if flagCloseConn then
      closeConn(conn);
    DS.Free;
  end;
  Result := DS;
end;

// Overloaded to use existing database connection
function getDbTable(tableName: String; connStr: String; sqlStr: String)
  : TADOTable;
var
  ADOConn: TADOConnection;
  ADOTbl: TADOTable;
begin
  Result := nil;
  ADOConn := TADOConnection.Create(application);
  ADOConn.ConnectionString := connStr;
  ADOConn.Open();
  if (ADOConn.Connected = True) then
  begin
    ADOTbl := TADOTable.Create(application);
    ADOTbl.Connection := ADOConn;
    ADOTbl.Connection.Execute(sqlStr);
    ADOTbl.tableName := tableName;
    ADOTbl.Active := True;
    ADOTbl.First;
    Result := ADOTbl;
  end;
end;

function getEvap(Var S: TStringList; conn: TADOConnection): TStringList;
var
  DT: TADOTable;
  Line: String;
  Tab: String;
begin
  if Uglobals.TabDelimited then
    Tab := #9
  else
    Tab := ' ';
  S.Add('');
  S.Add('[EVAPORATION]');
  Line := ';;Type      ' + Tab + 'Parameters';
  S.Add(Line);
  Line := ';;----------' + Tab + '----------';
  S.Add(Line);
  Line := Format('%-12s', ['MONTHLY']);
  DT := getDbTable(dbTblNames[1], conn, dbTblQrys[1], false);
  DT.First;
  while not DT.Eof do
  begin
    Line := Line + Tab + Format('%-6s', [DT['January']]);
    Line := Line + Tab + Format('%-6s', [DT['February']]);
    Line := Line + Tab + Format('%-6s', [DT['March']]);
    Line := Line + Tab + Format('%-6s', [DT['April']]);
    Line := Line + Tab + Format('%-6s', [DT['May']]);
    Line := Line + Tab + Format('%-6s', [DT['June']]);
    Line := Line + Tab + Format('%-6s', [DT['July']]);
    Line := Line + Tab + Format('%-6s', [DT['August']]);
    Line := Line + Tab + Format('%-6s', [DT['September']]);
    Line := Line + Tab + Format('%-6s', [DT['October']]);
    Line := Line + Tab + Format('%-6s', [DT['November']]);
    Line := Line + Tab + Format('%-6s', [DT['December']]);
    S.Add(Line);
    DT.Next;
  end;
  Result := S;
end;

function getOptions(Var S: TStringList; simTypeID: integer;
  conn: TADOConnection): TStringList;
var
  DS: TADODataSet;
  Line: String;
  Tab: String;
  tempQry: String;
begin
  if Uglobals.TabDelimited then
    Tab := #9
  else
    Tab := ' ';
  S.Add('');
  S.Add('[OPTIONS]');
  Line := ';;----------------------------------------';
  S.Add(Line);

  tempQry := StringReplace(dbTblQrys[2], '<PARAM>', IntToStr(simTypeID),
    [rfReplaceAll]);
  // <PARAM> is sentinel sequence in code to be replace with actual parameter value
  DS := getDbDataset(dbTblNames[2], conn, tempQry, false);
  DS.First;
  while not DS.Eof do
  begin
    Line := Format('%-20s', [DS['Category']]) + Tab +
      Format('%-20s', [DS['Parameter']]);
    S.Add(Line);
    DS.Next;
  end;
  Result := S;
end;

function getAquifers(Var S: TStringList; metGrid: integer; conn: TADOConnection)
  : TStringList;
var
  DS: TADODataSet;
  Line: String;
  Tab: String;
  I: integer;
  tempQry: String;
begin
  tempQry := StringReplace(dbTblQrys[3], '<PARAM>', IntToStr(metGrid),
    [rfReplaceAll]);
  // <PARAM> is sentinel sequence in code to be replace with actual parameter value
  DS := getDbDataset(dbTblNames[3], conn, tempQry, false);
  DS.First;

  if Uglobals.TabDelimited then
    Tab := #9
  else
    Tab := ' ';
  S.Add('');
  S.Add('[AQUIFERS]');
  Line := ';;              ' + Tab + 'Por-  ' + Tab + 'Wilt  ' + Tab + 'Field ';
  Line := Line + Tab + 'Hyd   ' + Tab + 'Cond  ' + Tab + 'Tens  ' + Tab
    + 'Upper ';
  Line := Line + Tab + 'Lower ' + Tab + 'Lower ' + Tab + 'Bottom' + Tab +
    'Water ' + Tab + 'Upper ';
  S.Add(Line);
  Line := ';;Name          ' + Tab + 'osity ' + Tab + 'Point ' + Tab + 'Capac ';
  Line := Line + Tab + 'Cond  ' + Tab + 'Slope ' + Tab + 'Slope ' + Tab
    + 'Evap  ';
  Line := Line + Tab + 'Evap  ' + Tab + 'Loss  ' + Tab + 'Elev  ' + Tab +
    'Table ' + Tab + 'Moist ';
  S.Add(Line);
  Line := ';;--------------';
  for I := 0 to DS.Fields.count - 1 do
    Line := Line + Tab + '------';
  S.Add(Line);

  while not DS.Eof do
  begin
    Line := Format('%-16s', [DS.Fields[0].AsString]);
    for I := 1 to DS.Fields.count - 1 do
    begin
      Line := Line + Tab + FloatToStrF(DS.Fields[I].AsFloat, ffFixed, 10, 2) +
        '  '; // Format('%-3s',[DS.Fields[i].AsFloat]);
    end;

    S.Add(Line);
    DS.Next;
  end;
  Result := S;
end;

function getGroundWater(Var S: TStringList; metGrid: integer;
  conn: TADOConnection): TStringList;
var
  Line: String;
  Tab: String;
begin
  if Uglobals.TabDelimited then
    Tab := #9
  else
    Tab := ' ';
  S.Add('');
  S.Add('[GROUNDWATER]');
  Line := ';;              ' + Tab + '                ' + Tab +
    '                ';
  Line := Line + Tab + 'Surf  ' + Tab + '      ' + Tab + '      ' + Tab
    + '      ';
  Line := Line + Tab + '      ' + Tab + '      ' + Tab + 'Fixed ' + Tab
    + 'GW    ';
  S.Add(Line);
  Line := ';;Subcatchment  ' + Tab + 'Aquifer         ' + Tab +
    'Node            ';
  Line := Line + Tab + 'Elev  ' + Tab + 'A1    ' + Tab + 'B1    ' + Tab
    + 'A2    ';
  Line := Line + Tab + 'B2    ' + Tab + 'A3    ' + Tab + 'Depth ' + Tab
    + 'Elev  ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------------' + Tab +
    '----------------';
  Line := Line + Tab + '------' + Tab + '------' + Tab + '------' + Tab
    + '------';
  Line := Line + Tab + '------' + Tab + '------' + Tab + '------' + Tab
    + '------';
  S.Add(Line);

  Result := S;
end;

function getSnowPacks(Var outSnowPackNames: TStringList; conn: TADOConnection)
  : TStringList;
var
  DS: TADODataSet;
  Line: String;
  Tab: String;
  I: integer;
  S: TStringList;
  tempStr: String;
begin
  DS := getDbDataset(dbTblNames[5], conn, dbTblQrys[5], false);
  DS.First;
  S := TStringList.Create;
  if Assigned(outSnowPackNames) = false then
    outSnowPackNames := TStringList.Create;

  if Uglobals.TabDelimited then
    Tab := #9
  else
    Tab := ' ';
  S.Add('');
  S.Add('[SNOWPACKS]');
  Line := ';;Snow Pack Name  ' + Tab + 'Surface         ' + Tab + 'Min. Melt ';
  Line := Line + Tab + 'Max Melt  ' + Tab + 'Base Temp ' + Tab + 'FreeWat.Ca' +
    Tab + 'InitSnoDep';
  Line := Line + Tab + 'InitFreeWa' + Tab + 'TBD       ';
  S.Add(Line);

  Line := ';;----------------' + Tab + '----------------' + Tab + '----------';
  Line := Line + Tab + '----------' + Tab + '----------' + Tab + '----------' +
    Tab + '----------';
  Line := Line + Tab + '----------' + Tab + '----------';
  S.Add(Line);
  while not DS.Eof do
  begin
    tempStr := DS.Fields[1].AsString;
    Line := Format('%-18s', [tempStr]);
    if (outSnowPackNames.indexOf(tempStr) = -1) then
      outSnowPackNames.Add(tempStr);
    for I := 2 to DS.Fields.count - 1 do
    begin
      Line := Line + Tab + Format('%-14s', [DS.Fields[I].AsString]);
    end;
    S.Add(Line);
    DS.Next;
  end;
  Result := S;
end;

function getTemperature1(Var S: TStringList; metGrid: integer; adcType: String;
  conn: TADOConnection): TStringList;
var
  DS: TADODataSet; // dataset for first temperature table with winds, adc, etc
  Line: String;
  Tab: String;
  I: integer;
  lineNum: integer;
  tempQry: String;
begin
  tempQry := StringReplace(dbTblQrys[6], '<P1>', IntToStr(metGrid),
    [rfReplaceAll]);
  // <PARAM> is sentinel sequence in code to be replace with actual parameter value
  DS := getDbDataset(dbTblNames[6], conn, tempQry, false);
  DS.First;

  if Uglobals.TabDelimited then
    Tab := #9
  else
    Tab := ' ';
  S.Add('');
  S.Add('[TEMPERATURE]');
  Line := 'TIMESERIES  ' + Tab + 'TempTSeries';
  S.Add(Line);
  lineNum := -1;

  while not DS.Eof do
  begin
    lineNum := lineNum + 1;
    case lineNum of
      0:
        begin
          Line := 'ADC         ';
          for I := 1 to 11 do
            Line := Line + Tab + Format('%-10s', [DS.Fields[I].AsString]);
          S.Add(Line);
        end;
      1:
        begin
          Line := 'ADC         ';
          for I := 1 to 11 do
            Line := Line + Tab + Format('%-10s', [DS.Fields[I].AsString]);
          S.Add(Line);
        end;
      2:
        begin
          Line := 'SNOWMELT               ';
          for I := 1 to 6 do
            Line := Line + Tab + Format('%-10s', [DS.Fields[I].AsString]);
          S.Add(Line);
        end;
      3:
        begin
          Line := 'WINDSPEED   ';
          for I := 1 to 13 do
            Line := Line + Tab + Format('%-10s', [DS.Fields[I].AsString]);
          S.Add(Line);
        end;
    end;
    DS.Next;
  end;
  Result := S;
end;

function generateTimeSeries(qry: String; tblName: String; fileDescrp: String;
  Var S: TStringList; conn: TADOConnection; var PBar: TProgressBar)
  : TStringList;
var
  DS: TADODataSet;
  Tab: String;
  tempInt: integer;
begin
  DS := getDbDataset(tblName, conn, qry, false);
  DS.First;
  tempInt := DS.RecordCount;
  PBar.Max := tempInt;

  if Uglobals.TabDelimited then
    Tab := #9
  else
    Tab := ' ';
  S.Add(fileDescrp);
  while not DS.Eof do
  begin
    S.Add(DS.Fields[0].AsString + Tab + FormatDateTime('h:mm',
      DS.Fields[1].AsDateTime) + Tab + DS.Fields[2].AsString);
    DS.Next;
    PBar.StepIt;
  end;
  Result := S;
end;

function generatePrecipTimeSeries(metGridNum: String; qry: String;
  tblName: String; fileDescrp: String; Var S: TStringList; conn: TADOConnection;
  PBar: TProgressBar): TStringList;
var
  DS: TADODataSet;
  Line: String;
  Tab: String;
  I: integer;
  numFlds: integer;
begin
  DS := getDbDataset(tblName, conn, qry, false);
  DS.First;
  numFlds := DS.Fields.count - 1;
  if Uglobals.TabDelimited then
    Tab := #9
  else
    Tab := ' ';
  S.Add(fileDescrp);
  while not DS.Eof do
  begin
    Line := metGridNum + Tab + DS.Fields[1].AsString;
    for I := 2 to numFlds do
      Line := Line + Tab + DS.Fields[I].AsString;
    S.Add(Line);
    DS.Next;
  end;
  Result := S;
end;

function getSoilsProps(numMapUnits: integer; delimMapUnits: String;
  conn: TADOConnection): PLRMGridData;
var
  DS: TADODataSet;
  tempQry: String;
  rsltArry: PLRMGridData;
  I, J: integer;
begin
  I := 0;
  tempQry := StringReplace(dbRunTimeQrys[4], '<P1>', delimMapUnits,
    [rfReplaceAll]);
  // <PARAM> is sentinel sequence in code to be replace with actual parameter value
  DS := getDbDataset(dbRunTimeQryTblNames[4], conn, tempQry, false);
  DS.First;
  Setlength(rsltArry, numMapUnits, 5);
  while not DS.Eof do
  begin
    for J := 0 to High(rsltArry[0]) do
    begin
      rsltArry[I, J] := DS.Fields[J].AsString;
    end;
    I := I + 1;
    DS.Next;
  end;
  Result := rsltArry;
end;

function getDBDataAsPLRMGridData(qry: String; rsltTblName: String;
  conn: TADOConnection): PLRMGridData;
var
  DS: TADODataSet;
  rsltArry: PLRMGridData;
  I, J: integer;
begin
  I := 0;
  DS := getDbDataset(rsltTblName, conn, qry, false);
  DS.First;
  Setlength(rsltArry, DS.RecordCount, DS.FieldCount);
  while not DS.Eof do
  begin
    for J := 0 to High(rsltArry[0]) do
    begin
      rsltArry[I, J] := DS.Fields[J].AsString;
    end;
    I := I + 1;
    DS.Next;
  end;
  Result := rsltArry;
end;

function getMapUnitMuName(Var S: TStringList; conn: TADOConnection)
  : TStringList;
var
  DT: TADOTable;
begin
  DT := getDbTable(dbTblNames[11], conn, dbTblQrys[11], false);
  DT.First;
  while not DT.Eof do
  begin
    S.Add(DT.Fields[1].AsString + '-' + DT.Fields[8].AsString);
    DT.Next;
  end;
  Result := S;
end;

function getCodes(Var S: TStringList; codePrefix: String; fldNum: integer;
  conn: TADOConnection): TStringList;
var
  DS: TADODataSet;
  tempQry: String;
begin
  tempQry := StringReplace(dbTblQrys[10], '<CODEPREFIX>', codePrefix,
    [rfReplaceAll]);
  // <CODEPREFIX> is sentinel sequence in code to be replace with actual parameter value
  DS := getDbDataset(dbTblNames[10], conn, tempQry, false);
  DS.First;
  while not DS.Eof do
  begin
    S.Add(DS.Fields[fldNum].AsString);
    DS.Next;
  end;
  Result := S;
end;

function getSWMMDefaults(Var outCodes: TStringList; Var outValues: TStringList;
  codePrefix: string; conn: TADOConnection): TStringList;
var
  DS: TADODataSet;
  tempQry: String;
begin
  tempQry := StringReplace(dbRunTimeQrys[8], '<P1>', codePrefix, [rfReplaceAll]
    ); // <P1> is sentinel sequence in code to be replace with actual parameter value
  DS := getDbDataset(dbRunTimeQryTblNames[8], conn, tempQry, false);
  DS.First;

  while not DS.Eof do
  begin
    outCodes.Add(DS.Fields[1].AsString);
    outValues.Add(DS.Fields[2].AsString);
    DS.Next;
  end;
  Result := outCodes;
end;

function getCodes(Var S: TStringList; codePrefix: string; conn: TADOConnection)
  : TStringList;
begin
  Result := getCodes(S, codePrefix, 1, conn);
end;

function getCodesAndvalues(Var outCodes: TStringList;
  Var outValues: TStringList; codePrefix: string; conn: TADOConnection)
  : TStringList;
var
  DS: TADODataSet;
  tempQry: String;
begin
  tempQry := StringReplace(dbTblQrys[10], '<CODEPREFIX>', codePrefix,
    [rfReplaceAll]);
  // <CODEPREFIX> is sentinel sequence in code to be replace with actual parameter value
  DS := getDbDataset(dbTblNames[10], conn, tempQry, false);
  DS.First;

  while not DS.Eof do
  begin
    outCodes.Add(DS.Fields[1].AsString);
    outValues.Add(DS.Fields[3].AsString);
    DS.Next;
  end;
  Result := outCodes;
end;

function lookUpValFrmTable(sqlQry: String; tblName: String;
  conn: TADOConnection; flagCloseConn: Boolean): String;
var
  DS: TADODataSet;
  rslt: TStringList;
begin
  DS := getDbDataset(tblName, conn, sqlQry, flagCloseConn);
  DS.First;
  rslt := lookUpValFrmTable(sqlQry, tblName, 0, conn, flagCloseConn);
  Result := rslt[0];
end;

function lookUpValFrmTable(sqlQry: String; tblName: String; fldNum: integer;
  conn: TADOConnection; flagCloseConn: Boolean): TStringList;
var
  DS: TADODataSet;
  S: TStringList;
begin
  DS := getDbDataset(tblName, conn, sqlQry, flagCloseConn);
  DS.First;
  S := TStringList.Create;
  while not DS.Eof do
  begin
    S.Add(DS.Fields[fldNum].AsString);
    DS.Next;
  end;
  Result := S;
end;

function lookUpValFrmTable(sqlQry: String; tblName: String; fldNum1: integer;
  fldNum2: integer; conn: TADOConnection; flagCloseConn: Boolean)
  : dbReturnFields;
var
  DS: TADODataSet;
  S1: TStringList;
  S2: TStringList;
  rslt: dbReturnFields;
begin
  DS := getDbDataset(tblName, conn, sqlQry, flagCloseConn);
  DS.First;
  S1 := TStringList.Create;
  S2 := TStringList.Create;
  while not DS.Eof do
  begin
    S1.Add(DS.Fields[fldNum1].AsString);
    S2.Add(DS.Fields[fldNum2].AsString);
    DS.Next;
  end;
  rslt[0] := S1;
  rslt[1] := S2;
  Result := rslt;
end;

function lookUpValFrmTable(sqlQry: String; tblName: String; fldNum1: integer;
  fldNum2: integer; fldNum3: integer; conn: TADOConnection;
  flagCloseConn: Boolean): dbReturnFields2; overload;
var
  DS: TADODataSet;
  S1: TStringList;
  S2: TStringList;
  S3: TStringList;
  rslt: dbReturnFields2;
begin
  DS := getDbDataset(tblName, conn, sqlQry, flagCloseConn);
  DS.First;
  S1 := TStringList.Create;
  S2 := TStringList.Create;
  S3 := TStringList.Create;
  while not DS.Eof do
  begin
    S1.Add(DS.Fields[fldNum1].AsString);
    S2.Add(DS.Fields[fldNum2].AsString);
    S3.Add(DS.Fields[fldNum3].AsString);
    DS.Next;
  end;
  rslt[0] := S1;
  rslt[1] := S2;
  rslt[2] := S3;
  Result := rslt;
end;

function lookUpValFrmTable(sqlQry: String; tblName: String; fldNum1: integer;
  fldNum2: integer; fldNum3: integer; fldNum4: integer; conn: TADOConnection;
  flagCloseConn: Boolean): dbReturnFields3; overload;
var
  DS: TADODataSet;
  S1: TStringList;
  S2: TStringList;
  S3: TStringList;
  S4: TStringList;
  rslt: dbReturnFields3; // array[0..1] of TStringList;
begin
  DS := getDbDataset(tblName, conn, sqlQry, flagCloseConn);
  DS.First;
  S1 := TStringList.Create;
  S2 := TStringList.Create;
  S3 := TStringList.Create;
  S4 := TStringList.Create;
  while not DS.Eof do
  begin
    S1.Add(DS.Fields[fldNum1].AsString);
    S2.Add(DS.Fields[fldNum2].AsString);
    S3.Add(DS.Fields[fldNum3].AsString);
    S4.Add(DS.Fields[fldNum4].AsString);
    DS.Next;
  end;
  rslt[0] := S1;
  rslt[1] := S2;
  rslt[2] := S3;
  rslt[3] := S4;
  Result := rslt;
end;

end.
