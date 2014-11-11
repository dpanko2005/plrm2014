unit GSIO;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  StrUtils,
  Dialogs, jpeg, ExtCtrls, ComCtrls, StdCtrls, Buttons, DB, ADODB, Uglobals,
  GSDataAccess, GSUtils, GSTypes;

function getLuseCodeFamily(Var outLuseCodes: TStringList;
  Var outLuseFamilyCodes: TStringList): TStringList;
function getMapUnitMuName(): TStringList;
function getMapUnitMuNumber(): TStringList;
function getAndSaveTSeries(metGridNum: Integer; var PBar: TProgressBar)
  : TStringList;
function getSwmmDefaultBlocks(typeFlag: Integer; optional2ndParam: string = '0')
  : TStringList;
function getCodes(codePrefix: string): TStringList; overload;
function getCodes(codePrefix: string; fldNum: Integer): TStringList; overload;
function getCodesAndValues(codePrefix: string; Var outCodes: TStringList;
  Var outValues: TStringList): TStringList;
function lookUpValFrmTable(tblName: String; fldName: String; fldNum: Integer;
  closeConnAfter: boolean; whereStr: String = ''): TStringList; overload;
function lookUpValFrmTable(runtimeQryNum: Integer; fldNum1: Integer;
  fldNum2: Integer): dbReturnFields; overload;
function lookUpValueFrmPolPotTbl(dbtblName: String; dbField1Name: String;
  dbField1Value: String; dbField2Name: String; dbField2Value: String;
  returnFieldName: String): Double;
// Returns the appropriate RS Value from table
function lookUpRDCRCs(ppScore: String): dbReturnFields;
// :array[0..1] of TStringList;  // returns list of crcs for the give score ordered by pollutant code
function lookUpParcelCRCs(): dbReturnFields;
// :array[0..1] of TStringList;  // returns all parcel crcs
function lookUpSwprEffReds(rdSwprTypScores: Integer; rdSwprFreqScores: Integer)
  : dbReturnFields;
// array[0..1] of TStringList;  // returns list of crcs for the give score ordered by pollutant code
function getSoilsProps(data: PLRMGridData): PLRMGridData;
function getDefaults(codeStr: String): dbReturnFields; overload;
function getDefaults(codeStr: String; fldNum1: Integer; fldNum2: Integer;
  fldNum3: Integer): dbReturnFields2; overload;
function getDBDataAsPLRMGridData(runTimeQryNumber: Integer)
  : PLRMGridData; overload;
function getDBDataAsPLRMGridData(tblName: String): PLRMGridData; overload;
function getSWMMDefaults(codePrefix: string; Var outCodes: TStringList;
  Var outValues: TStringList): TStringList;
function getDesignParams(codeStr: String; fldNum1: Integer; fldNum2: Integer;
  fldNum3: Integer; fldNum4: Integer): dbReturnFields3;
function getEfflQuals(codeStr: String; fldNum1: Integer; fldNum2: Integer;
  fldNum3: Integer; fldNum4: Integer): dbReturnFields3;
function getNodeValidationRules(): PLRMGridData;
function getCatchmentValidationRules(): PLRMGridData;
procedure initDbPath();
procedure closeDatabase();

implementation

procedure initDbPath();
begin
  connStr := 'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=' + dbPath +
    ';Persist Security Info=False;';
end;

function getNodeValidationRules(): PLRMGridData;
var
  Conn: TADOConnection;
begin
  Conn := initConn(GSDataAccess.connStr);
  Result := GSDataAccess.getDBDataAsPLRMGridData(dbRunTimeQrys[20],
    dbRunTimeQryTblNames[20], Conn);
end;

function getCatchmentValidationRules(): PLRMGridData;
var
  Conn: TADOConnection;
begin
  Conn := initConn(GSDataAccess.connStr);
  Result := GSDataAccess.getDBDataAsPLRMGridData(dbRunTimeQrys[19],
    dbRunTimeQryTblNames[19], Conn);
end;

function lookUpValFrmTable(runtimeQryNum: Integer; fldNum1: Integer;
  fldNum2: Integer): dbReturnFields;
var
  Conn: TADOConnection;
begin
  Conn := initConn(GSDataAccess.connStr);
  Result := GSDataAccess.lookUpValFrmTable(dbRunTimeQrys[runtimeQryNum],
    dbRunTimeQryTblNames[runtimeQryNum], fldNum1, fldNum2, Conn, false);
end;

function getLuseCodeFamily(Var outLuseCodes: TStringList;
  Var outLuseFamilyCodes: TStringList): TStringList;
var
  Conn: TADOConnection;
begin
  Conn := initConn(GSDataAccess.connStr);
  Result := GSDataAccess.getLuseCodeFamily(outLuseCodes,
    outLuseFamilyCodes, Conn);
end;

function getDBDataAsPLRMGridData(tblName: String): PLRMGridData;
var
  Conn: TADOConnection;
begin
  Conn := initConn(GSDataAccess.connStr);
  Result := GSDataAccess.getDBDataAsPLRMGridData('SELECT * FROM ' + tblName +
    ';', tblName, Conn);
end;

procedure closeDatabase();
begin
  closeConn;
end;

function getAndSaveTSeries(metGridNum: Integer; var PBar: TProgressBar)
  : TStringList;
var
  Conn: TADOConnection;
  S: TStringList;
  filePaths: TStringList;
  tempQry: String;
begin
  Conn := initConn(GSDataAccess.connStr);
  S := TStringList.Create;
  filePaths := TStringList.Create;

  filePaths.Add(defaultDataDir + '\' + intToStr(metGridNum) + '_Temp.dat');
  if (FileExists(filePaths[0]) = false) then
  begin
    tempQry := StringReplace(dbRunTimeQrys[12], '<P1>', intToStr(metGridNum),
      [rfReplaceAll]);
    S := generateTimeSeries(tempQry, 'SnoTelTemperatureTimeSeries',
      ';;THOC1 adjusted using a constant lapse rate of 0.0022 degree F/ft', S,
      Conn, PBar);
    S.SaveToFile(filePaths[0]);
  end;

  S.clear;
  filePaths.Add(defaultDataDir + '\' + intToStr(metGridNum) + '_Precip.dat');
  if (FileExists(filePaths[1]) = false) then
  begin
    tempQry := StringReplace(dbRunTimeQrys[13], '<P1>', intToStr(metGridNum),
      [rfReplaceAll]);
    S := generatePrecipTimeSeries(intToStr(metGridNum), tempQry,
      'SnoTelPrecipitationTimeSeries', ';;Rainfall', S, Conn, PBar);
    S.SaveToFile(filePaths[1]);
  end;
  FreeAndNil(S);
  Result := filePaths;
end;

function getDesignParams(codeStr: String; fldNum1: Integer; fldNum2: Integer;
  fldNum3: Integer; fldNum4: Integer): dbReturnFields3;
var
  Conn: TADOConnection;
  sqlStr: String;
begin
  Conn := initConn(GSDataAccess.connStr);
  sqlStr := StringReplace(dbRunTimeQrys[6], '<P1>', codeStr, [rfReplaceAll]);
  Result := GSDataAccess.lookUpValFrmTable(sqlStr,
    GSDataAccess.dbRunTimeQryTblNames[6], fldNum1, fldNum2, fldNum3, fldNum4,
    Conn, false);
end;

function lookUpValFrmTable(tblName: String; fldName: String; fldNum: Integer;
  closeConnAfter: boolean; whereStr: String = ''): TStringList;
var
  Conn: TADOConnection;
  sqlStr: String;
begin
  Conn := initConn(GSDataAccess.connStr);
  sqlStr := StringReplace(dbRunTimeQrys[14], '<F1>', fldName, [rfReplaceAll]);
  sqlStr := StringReplace(sqlStr, '<T1>', tblName, [rfReplaceAll]);
  sqlStr := StringReplace(sqlStr, '<W1>', whereStr, [rfReplaceAll]);
  Result := GSDataAccess.lookUpValFrmTable(sqlStr, tblName, 0, Conn,
    closeConnAfter);
end;

function getEfflQuals(codeStr: String; fldNum1: Integer; fldNum2: Integer;
  fldNum3: Integer; fldNum4: Integer): dbReturnFields3;
var
  Conn: TADOConnection;
  sqlStr: String;
begin
  Conn := initConn(GSDataAccess.connStr);
  sqlStr := StringReplace(dbRunTimeQrys[7], '<P1>', codeStr, [rfReplaceAll]);
  Result := GSDataAccess.lookUpValFrmTable(sqlStr,
    GSDataAccess.dbRunTimeQryTblNames[7], fldNum1, fldNum2, fldNum3, fldNum4,
    Conn, false);
end;

function getSWMMDefaults(codePrefix: string; Var outCodes: TStringList;
  Var outValues: TStringList): TStringList;
var
  Conn: TADOConnection;
begin
  Conn := initConn(GSDataAccess.connStr);
  GSDataAccess.getSWMMDefaults(outCodes, outValues, codePrefix, Conn);
  // read required codes from the database
  Result := outValues;
end;

function getDefaults(codeStr: String; fldNum1: Integer; fldNum2: Integer;
  fldNum3: Integer): dbReturnFields2;
var
  Conn: TADOConnection;
  sqlStr: String;
begin
  Conn := initConn(GSDataAccess.connStr);
  sqlStr := StringReplace(dbRunTimeQrys[5], '<P1>', codeStr, [rfReplaceAll]);
  Result := GSDataAccess.lookUpValFrmTable(sqlStr,
    GSDataAccess.dbRunTimeQryTblNames[5], fldNum1, fldNum2, fldNum3,
    Conn, false);
end;

function getDefaults(codeStr: String): dbReturnFields;
var
  Conn: TADOConnection;
  sqlStr: String;
begin
  Conn := initConn(GSDataAccess.connStr);
  sqlStr := StringReplace(dbRunTimeQrys[5], '<P1>', codeStr, [rfReplaceAll]);
  Result := GSDataAccess.lookUpValFrmTable(sqlStr,
    GSDataAccess.dbRunTimeQryTblNames[5], 2, 3, Conn, false);
end;

function getSoilsProps(data: PLRMGridData): PLRMGridData;
var
  Conn: TADOConnection;
  I, J: Integer;
  delimMapUnits: String;
  areas: TStringList;
  tempRslts: PLRMGridData;
  rslts: PLRMGridData;
  rsltsDblArry: array of array of Double;
  areaSum: Double;
  area: Double;
begin
  areaSum := 0;
  Conn := initConn(GSDataAccess.connStr);
  if data = nil then
  begin
    showMessage('a problem occured with the soils information');
    Result := nil;
    Exit;
  end;
  areas := TStringList.Create;
  for I := 0 to High(data) do
  begin
    delimMapUnits := delimMapUnits + ',' + AnsiLeftStr(data[I][0], 4);
    if (data[I][2] <> '') then
      area := StrToFloat(data[I][2])
    else
      area := 0;
    areas.Add(floatToStr(area));
    areaSum := areaSum + area;
  end;
  delimMapUnits := AnsiRightStr(delimMapUnits, Length(delimMapUnits) - 1);
  tempRslts := GSDataAccess.getSoilsProps(High(data) + 1, delimMapUnits, Conn);
  SetLength(rslts, 1, 4);
  SetLength(rsltsDblArry, 1, 4);
  for I := 0 to High(tempRslts) do
    for J := 1 to High(tempRslts[0]) do
      rsltsDblArry[0, J - 1] := rsltsDblArry[0, J - 1] +
        (StrToFloat(tempRslts[I, J]) * StrToFloat(areas[I]));

  // copy results to string array
  for I := 0 to High(rsltsDblArry) do
    for J := 1 to High(rsltsDblArry[0]) do
      rslts[I, J] := floatToStr(rsltsDblArry[I, J] / areaSum);
  Result := rslts;
end;

function getDBDataAsPLRMGridData(runTimeQryNumber: Integer): PLRMGridData;
var
  Conn: TADOConnection;
  data: PLRMGridData;
begin
  Conn := initConn(GSDataAccess.connStr);
  data := GSDataAccess.getDBDataAsPLRMGridData(dbRunTimeQrys[runTimeQryNumber],
    dbRunTimeQryTblNames[runTimeQryNumber], Conn);
  Result := data;
end;

function getMapUnitMuName(): TStringList;
var
  S: TStringList;
  Conn: TADOConnection;
begin
  S := TStringList.Create;
  Conn := initConn(GSDataAccess.connStr);
  GSDataAccess.getMapUnitMuName(S, Conn);
  // read required codes from the database
  Result := S;
end;

function getMapUnitMuNumber(): TStringList;
var
  S: TStringList;
  Conn: TADOConnection;
begin
  S := TStringList.Create;
  Conn := initConn(GSDataAccess.connStr);
  GSDataAccess.getMapUnitMuNumber(S, Conn);
  // read required codes from the database
  Result := S;
end;

function getSwmmDefaultBlocks(typeFlag: Integer; optional2ndParam: string = '0')
  : TStringList;
var
  S: TStringList;
  Conn: TADOConnection;
begin
  S := TStringList.Create;
  Conn := initConn(GSDataAccess.connStr);
  case typeFlag of
    0:
      getOptions(S, strToInt(optional2ndParam), Conn);
    // read swmm options from database
    1:
      getEvap(S, Conn); // read evaporation data from the database
    2:
      getTemperature1(S, 1, 'NA', Conn);
    // read in default temperature (wind and adc) data from the database
    3:
      getAquifers(S, 1, Conn); // read in default aquifer data from the database
    4:
      getGroundWater(S, 1, Conn);
    // read in default groundwater data from the database
    5:
      S := getSnowPacks(snowPackNames, Conn);
    // read in default groundwater data from the database
  end;
  Result := S;
end;

function getCodes(codePrefix: string): TStringList;
var
  S: TStringList;
  Conn: TADOConnection;
begin
  S := TStringList.Create;
  Conn := initConn(GSDataAccess.connStr);
  GSDataAccess.getCodes(S, codePrefix, Conn);
  // read required codes from the database
  Result := S;
end;

function getCodes(codePrefix: string; fldNum: Integer): TStringList;
var
  S: TStringList;
  Conn: TADOConnection;
begin
  S := TStringList.Create;
  Conn := initConn(GSDataAccess.connStr);
  GSDataAccess.getCodes(S, codePrefix, fldNum, Conn);
  // read required codes from the database
  Result := S;
end;

function getCodesAndValues(codePrefix: string; Var outCodes: TStringList;
  Var outValues: TStringList): TStringList;
var
  S: TStringList;
  Conn: TADOConnection;
begin
  S := TStringList.Create;
  Conn := initConn(GSDataAccess.connStr);
  GSDataAccess.getCodesAndValues(outCodes, outValues, codePrefix, Conn);
  // read required codes from the database
  Result := S;
end;

function lookUpValueFrmPolPotTbl(dbtblName: String; dbField1Name: String;
  dbField1Value: String; dbField2Name: String; dbField2Value: String;
  returnFieldName: String): Double;
// Returns the appropriate RS Value from table
var
  Conn: TADOConnection;
  sqlQry: String;
  tblName: String;
begin
  Conn := initConn(GSDataAccess.connStr);
  sqlQry := StringReplace(GSDataAccess.dbRunTimeQrys[0], '<T1>', dbtblName,
    [rfReplaceAll]);
  // <T1> is sentinel sequence in code to be replace with actual parameter value
  sqlQry := StringReplace(sqlQry, '<F1>', dbField1Name, [rfReplaceAll]);
  // <F1> is sentinel sequence in code to be replace with actual parameter value
  sqlQry := StringReplace(sqlQry, '<V1>', dbField1Value, [rfReplaceAll]);
  // <V1> is sentinel sequence in code to be replace with actual parameter value
  sqlQry := StringReplace(sqlQry, '<F2>', dbField2Name, [rfReplaceAll]);
  // <F2> is sentinel sequence in code to be replace with actual parameter value
  sqlQry := StringReplace(sqlQry, '<V2>', dbField2Value, [rfReplaceAll]);
  // <V2> is sentinel sequence in code to be replace with actual parameter value
  sqlQry := StringReplace(sqlQry, '<R1>', returnFieldName, [rfReplaceAll]);
  // <V2> is sentinel sequence in code to be replace with actual parameter value
  tblName := GSDataAccess.dbRunTimeQryTblNames[0];
  Result := StrToFloat(GSDataAccess.lookUpValFrmTable(sqlQry, tblName,
    Conn, false));
end;

function lookUpRDCRCs(ppScore: String): dbReturnFields;
// :array[0..1] of TStringList;  // returns list of crcs for the give score ordered by pollutant code
var
  Conn: TADOConnection;
  sqlQry: String;
  tblName: String;
begin
  Conn := initConn(GSDataAccess.connStr);
  sqlQry := StringReplace(GSDataAccess.dbRunTimeQrys[1], '<V1>', ppScore,
    [rfReplaceAll]);
  // <T1> is sentinel sequence in code to be replace with actual parameter value
  tblName := GSDataAccess.dbRunTimeQryTblNames[1];
  Result := GSDataAccess.lookUpValFrmTable(sqlQry, tblName, 1, 2, Conn, false);
end;

function lookUpParcelCRCs(): dbReturnFields;
// :array[0..1] of TStringList;  // returns list of crcs for the give score ordered by pollutant code
var
  Conn: TADOConnection;
  sqlQry: String;
  tblName: String;
begin
  Conn := initConn(GSDataAccess.connStr);
  sqlQry := GSDataAccess.dbRunTimeQrys[3];
  tblName := GSDataAccess.dbRunTimeQryTblNames[3];
  Result := GSDataAccess.lookUpValFrmTable(sqlQry, tblName, 0, 5, Conn, false);
end;

function lookUpSwprEffReds(rdSwprTypScores: Integer; rdSwprFreqScores: Integer)
  : dbReturnFields;
// returns list of crcs for the give score ordered by pollutant code
var
  Conn: TADOConnection;
  sqlQry: String;
  tblName: String;
begin
  Conn := initConn(GSDataAccess.connStr);
  sqlQry := StringReplace(GSDataAccess.dbRunTimeQrys[2], '<V1>',
    intToStr(rdSwprTypScores), [rfReplaceAll]);
  // <T1> is sentinel sequence in code to be replace with actual parameter value
  sqlQry := StringReplace(sqlQry, '<V2>', intToStr(rdSwprFreqScores),
    [rfReplaceAll]);
  // <T1> is sentinel sequence in code to be replace with actual parameter value
  tblName := GSDataAccess.dbRunTimeQryTblNames[2];
  Result := GSDataAccess.lookUpValFrmTable(sqlQry, tblName, 2, 3, Conn, false);
end;

end.
