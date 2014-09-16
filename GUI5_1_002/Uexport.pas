unit Uexport;

{-------------------------------------------------------------------}
{                    Unit:    Uexport.pas                           }
{                    Project: EPA SWMM                              }
{                    Version: 5.1                                   }
{                    Date:    12/2/13    (5.1.000)                  }
{                    Author:  L. Rossman                            }
{                                                                   }
{   Delphi Pascal unit that exports current project data to a       }
{   formatted text file.                                            }
{                                                                   }
{-------------------------------------------------------------------}

interface

uses SysUtils, Windows, Messages, Classes, Math, Dialogs, StrUtils,
  Uglobals, Uutils, Uproject, Uvertex;

procedure ExportMap(S: TStringlist);
procedure ExportProfiles(S: TStringlist);
procedure ExportProject(S: TStringlist);
procedure ExportTags(S: TStringlist);
procedure ExportTempDir(S: TStringlist);
procedure SaveProject(Fname: String);
procedure SaveResults(Fname: String);
procedure SaveHotstartFile(Fname: String);

implementation

uses
  Fmap, Uinifile, Uoutput, Dreporting, Ulid;

var
  DXFCount   : Integer;
  DWFCount   : Integer;
  RDIICount  : Integer;
  TreatCount : Integer;
  Tab        : String;
  SaveToPath : String;


procedure ExportComment(S: TStringlist; Comment: String);
//-----------------------------------------------------------------------------
var
  I: Integer;
begin
  if Length(Trim(Comment)) = 0 then exit;
  with Tstringlist.Create do
  try
    Clear;
    SetText(PChar(Comment));
    for I := 0 to Count-1 do S.Add(';' + Strings[I]);
  finally
    Free;
  end;
end;


procedure ExportTitle(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I: Integer;
begin
  with Project do
  begin
    S.Add('[TITLE]');
    S.Add(';;Project Title/Notes');
    for I := 0 to Lists[NOTES].Count-1 do
      S.Add(Lists[NOTES].Strings[I]);
  end;
end;


procedure ExportOptions(S: TStringlist);
//-----------------------------------------------------------------------------
var
   I: Integer;
   X: Extended;
   Line: String;
   TmpOptions: array[0..MAXOPTIONS] of String;
begin
  S.Add('');
  S.Add('[OPTIONS]');
  S.Add(';;Option            ' + Tab + 'Value');
  with Project.Options do
  begin
    for I := 0 to MAXOPTIONS do TmpOptions[I] := Data[I];
    if Length(Trim(TmpOptions[REPORT_START_DATE_INDEX])) = 0 then
       TmpOptions[REPORT_START_DATE_INDEX] := TmpOptions[START_DATE_INDEX];
    if Length(Trim(TmpOptions[REPORT_START_TIME_INDEX])) = 0 then
       TmpOptions[REPORT_START_TIME_INDEX] := TmpOptions[START_TIME_INDEX];
    if Length(Trim(TmpOptions[END_DATE_INDEX])) = 0 then
      TmpOptions[END_DATE_INDEX] := TmpOptions[START_DATE_INDEX];
    if Length(Trim(TmpOptions[END_TIME_INDEX])) = 0 then
      TmpOptions[END_TIME_INDEX] := TmpOptions[START_TIME_INDEX];
    TmpOptions[VARIABLE_STEP_INDEX] :=
      Format('%.2f', [StrToFloat(Data[VARIABLE_STEP_INDEX])/100]);

    // If routing time step is whole number of seconds then export it
    // in Hrs:Min:Sec format for backward compatibility
    if Uutils.GetExtended(Data[ROUTING_STEP_INDEX], X) then
    begin
      if Frac(X) = 0
      then TmpOptions[ROUTING_STEP_INDEX] := Uutils.GetTimeString(Round(X));
    end;

    if Length(Trim(TmpOptions[MIN_SURFAREA_INDEX])) = 0
    then TmpOptions[MIN_SURFAREA_INDEX] := '0';
    if Length(Trim(TmpOptions[HEAD_TOL_INDEX ])) = 0
    then TmpOptions[HEAD_TOL_INDEX ] := '0';

    for I := FLOW_UNITS_INDEX to SKIP_STEADY_INDEX do
    begin
      Line := Format('%-20s', [OptionLabels[I]]) + Tab + TmpOptions[I];
      S.Add(Line);
    end;
    S.Add('');

    for I := IGNORE_RAINFALL_INDEX to IGNORE_QUALITY_INDEX do
    begin
      if SameText(TmpOptions[I], 'YES') then
      begin
        Line := Format('%-20s', [OptionLabels[I]]) + Tab + TmpOptions[I];
        S.Add(Line);
      end;
    end;

    for I := START_DATE_INDEX to ROUTING_STEP_INDEX do
    begin
      Line := Format('%-20s', [OptionLabels[I]]) + Tab + TmpOptions[I];
      S.Add(Line);
    end;
    S.Add('');

    for I := INERTIAL_DAMPING_INDEX to MAXOPTIONS do
    begin
      Line := Format('%-20s', [OptionLabels[I]]) + Tab + TmpOptions[I];
      S.Add(Line);
    end;
  end;
end;


procedure ExportRaingages(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I:     Integer;
  Line:  String;
  Fname: String;
  Rgage: TRaingage;
begin
  if Project.Lists[RAINGAGE].Count = 0 then exit;
  S.Add('');
  S.Add('[RAINGAGES]');
//  Line := ';;              ' + Tab + 'Rain     ' + Tab + 'Time  ' + Tab + 'Snow  ';
//  Line := Line + Tab + 'Data      ';
//  S.Add(Line);
  Line := ';;Gage          ' + Tab + 'Format   ' + Tab + 'Interval';
  Line := Line + Tab + 'SCF     ' + Tab + 'Source    ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '---------' + Tab + '------' + Tab + '------';
  Line := Line + Tab + '----------';
  S.Add(Line);
  with Project.Lists[RAINGAGE] do
    for I := 0 to Count-1 do
    begin
      Rgage := TRaingage(Objects[I]);
      ExportComment(S, Rgage.Data[COMMENT_INDEX]);
      Line := Format('%-16s', [Strings[I]]);
      Line := Line + Tab + Format('%-9s', [Rgage.Data[GAGE_DATA_FORMAT]]);
      Line := Line + Tab + Format('%-8s', [Rgage.Data[GAGE_DATA_FREQ]]);
      Line := Line + Tab + Format('%-8s', [Rgage.Data[GAGE_SNOW_CATCH]]);
      Line := Line + Tab + Format('%-10s', [Rgage.Data[GAGE_DATA_SOURCE]]);
      if SameText(Rgage.Data[GAGE_DATA_SOURCE], RaingageOptions[0]) then
      begin
        Line := Line + Tab + Format('%-16s', [Rgage.Data[GAGE_SERIES_NAME]]);
      end
      else
      begin
        Fname := Rgage.Data[GAGE_FILE_NAME];
        if ExtractFilePath(Fname) = ''
        then Fname := ExtractFilePath(InputFileName) + Fname;
        if SameText(ExtractFilePath(Fname), SaveToPath)
        then Fname := ExtractFileName(Fname);
        Fname := '"' + Fname + '"';
        Line := Line + Tab + Format('%-16s', [Fname]);
        Line := Line + Tab + Format('%-10s', [Rgage.Data[GAGE_STATION_NUM]]);
        Line := Line + Tab + Format('%-5s',  [Rgage.Data[GAGE_RAIN_UNITS]]);
      end;
      S.Add(Line);
    end;
end;


procedure ExportHydrographs(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I: Integer;
  J: Integer;
  K: Integer;
  M: Integer;
  N: Integer;
  Name: String;
  Line: String;
  RTK : String;
  IA: String;
  H: THydrograph;
begin
  if Project.Lists[HYDROGRAPH].Count = 0 then Exit;
  S.Add('');
  S.Add('[HYDROGRAPHS]');
//  Line := ';;              ' + Tab + 'Rain Gage/      ';
//  S.Add(Line);
  Line := ';;Hydrograph    ' + Tab + 'Rain Gage/Month ' + Tab + 'Response';
  Line := Line + Tab + 'R       ' + Tab + 'T       ' + Tab + 'K       ';
  Line := Line + Tab + 'Dmax    ' + Tab + 'Drec    ' + Tab + 'D0      ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------------' + Tab + '--------';
  Line := Line + Tab + '--------' + Tab + '--------' + Tab + '--------';
  Line := Line + Tab + '--------' + Tab + '--------' + Tab + '--------';
  S.Add(Line);
  for I := 0 to Project.Lists[HYDROGRAPH].Count-1 do
  begin
    // Add name & rain gage line
    Name := Project.Lists[HYDROGRAPH].Strings[I];
    H := THydrograph(Project.Lists[HYDROGRAPH].Objects[I]);
    Line := Format('%-16s', [Name]);
    Line := Line + Tab + Format('%-16s', [H.Raingage]);
    S.Add(Line);

    // For each month (+ All)
    for M := 0 to 12 do
    begin
      // See if month contains any R-T-K values
      for K := 1 to 3 do
      begin
        N := 0;
        for J := 1 to 3 do
        begin
          if Length(Trim(H.Params[M,J,K])) > 0 then
          begin
            N := 1;
            break;
          end;
        end;

        // Write monthly UH parameters to line
        if N > 0 then
        begin
          Line := Format('%-16s', [Name]);
          Line := Line + Tab + Format('%-16s', [MonthLabels[M]]);
          Line := Line + Tab + Format('%-8s', [ResponseTypes[K-1]]);
          for J := 1 to 3 do
          begin
            RTK := Trim(H.Params[M,J,K]);
            if Length(RTK) = 0 then RTK := '0';
            Line := Line + Tab + Format('%-8s', [RTK]);
          end;
          for J := 1 to 3 do
          begin
            IA := Trim(H.InitAbs[M,J,K]);
            if Length(IA) = 0 then IA := '0';
            Line := Line + Tab + Format('%-8s', [IA]);
          end;
          S.Add(Line);
        end;
      end;
    end;
  end;
  S.Add('');
end;


procedure ExportTemperature(S: TStringlist);
//-----------------------------------------------------------------------------
var
  Line: String;
  Fname: String;
  I: Integer;
begin
  with Project.Climatology do
  begin
    if TempDataSource = NO_TEMP then exit;
    S.Add('');
    S.Add('[TEMPERATURE]');
    S.Add(';;Temp/Wind/Snow  ' + Tab + 'Source/Data');
    if (TempDataSource = TSERIES_TEMP) and (Length(TempTseries) > 0) then
    begin
      Line := 'TIMESERIES        ' + Tab + TempTseries;
      S.Add(Line);
    end
    else if (TempDataSource = FILE_TEMP) and (Length(TempFile) > 0) then
    begin
      Fname := TempFile;
      if ExtractFilePath(Fname) = ''  then
         Fname := ExtractFilePath(InputFileName) + Fname;
      if SameText(ExtractFilePath(Fname), SaveToPath)
      then Fname := ExtractFileName(Fname);
      Fname := '"' + Fname + '"';
      Line := 'FILE              ' + Tab + Fname;
      if Length(TempStartDate) > 0 then
        Line := Line + Tab + Format('%-10s', [TempStartDate]);
      S.Add(Line);
    end;
    if WindType = FILE_WINDSPEED then
      Line := 'WINDSPEED         ' + Tab + 'FILE'
    else
    begin
      Line := 'WINDSPEED         ' + Tab + 'MONTHLY   ';
      for I := 1 to 12 do Line := Line + Tab + WindSpeed[I];
    end;
    S.Add(Line);
    Line := 'SNOWMELT          ';
    for I := 1 to 6 do Line := Line + Tab + SnowMelt[I];
    S.Add(Line);
    Line := 'ADC IMPERVIOUS    ';
    for I := 1 to 10 do Line := Line + Tab + ADCurve[1][I];
    S.Add(Line);
    Line := 'ADC PERVIOUS      ';
    for I := 1 to 10 do Line := Line + Tab + ADCurve[2][I];
    S.Add(Line);
  end;
end;


procedure ExportEvaporation(S: TStringlist);
//-----------------------------------------------------------------------------
var
  Line: String;
  I: Integer;
begin
  with Project.Climatology do
  begin
    S.Add('');
    S.Add('[EVAPORATION]');
    Line := ';;Evap Data     ' + Tab + 'Parameters';
    S.Add(Line);
    Line := ';;--------------' + Tab + '----------------';
    S.Add(Line);
    case EvapType of
    CONSTANT_EVAP:
      Line := Format('%-16s', [EvapOptions[CONSTANT_EVAP]]) + Tab + EvapData[0];
    TSERIES_EVAP:
      Line := Format('%-16s', [EvapOptions[TSERIES_EVAP]]) + Tab + EvapTseries;
    FILE_EVAP:
      begin
        Line := Format('%-16s', [EvapOptions[FILE_EVAP]]);
        for I := 0 to 11 do Line := Line + Tab + Format('%-6s', [PanData[I]]);
      end;
    MONTHLY_EVAP:
      begin
        Line := Format('%-16s', [EvapOptions[MONTHLY_EVAP]]);
        for I := 0 to 11 do Line := Line + Tab + Format('%-6s', [EvapData[I]]);
      end;
    TEMP_EVAP:
      Line := 'TEMPERATURE ';
    end;
    S.Add(Line);
    if Length(RecoveryPat) > 0 then S.Add('RECOVERY        ' + Tab + RecoveryPat);
    if EvapDryOnly = True then S.Add('DRY_ONLY        ' + Tab + 'YES')
                          else S.Add('DRY_ONLY        ' + Tab + 'NO');
  end;
end;


procedure ExportSubcatchments(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I      : Integer;
  Line   : String;
  C      : TSubcatch;
begin
  if Project.Lists[SUBCATCH].Count = 0 then exit;
  S.Add('');
  S.Add('[SUBCATCHMENTS]');
//  Line := ';;              ' + Tab + '                ' + Tab + '                ';
//  Line := Line + Tab + 'Total   ' + Tab + 'Pcnt.   ' + Tab + '        ';
//  Line := Line + Tab + 'Pcnt.   ' + Tab + 'Curb    ' + Tab + 'Snow    ';
//  S.Add(Line);
  Line := ';;Subcatchment  ' + Tab + 'Rain Gage       ' + Tab + 'Outlet          ';
  Line := Line + Tab + 'Area    ' + Tab + '%Imperv ' + Tab + 'Width   ';
  Line := Line + Tab + '%Slope  ' + Tab + 'CurbLen ' + Tab + 'Snow Pack       ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------------' + Tab + '----------------';
  Line := Line + Tab + '--------' + Tab + '--------' + Tab + '--------';
  Line := Line + Tab + '--------' + Tab + '--------' + Tab + '----------------';
  S.Add(Line);
  with Project.Lists[SUBCATCH] do
    for I := 0 to Count-1 do
    begin
      C := TSubcatch(Objects[I]);
      ExportComment(S, C.Data[COMMENT_INDEX]);
      Line := Format('%-16s', [Strings[I]]);
      Line := Line + Tab + Format('%-16s', [C.Data[SUBCATCH_RAINGAGE_INDEX]]);
      Line := Line + Tab + Format('%-16s', [C.Data[SUBCATCH_OUTLET_INDEX]]);
      Line := Line + Tab + Format('%-8s',  [C.Data[SUBCATCH_AREA_INDEX]]);
      Line := Line + Tab + Format('%-8s',  [C.Data[SUBCATCH_IMPERV_INDEX]]);
      Line := Line + Tab + Format('%-8s',  [C.Data[SUBCATCH_WIDTH_INDEX]]);
      Line := Line + Tab + Format('%-8s',  [C.Data[SUBCATCH_SLOPE_INDEX]]);
      Line := Line + Tab + Format('%-8s',  [C.Data[SUBCATCH_CURBLENGTH_INDEX]]);
      Line := Line + Tab + Format('%-16s', [C.Data[SUBCATCH_SNOWPACK_INDEX]]);
      S.Add(Line);
    end;
end;


procedure ExportSubAreas(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I     : Integer;
  Line  : String;
  C     : TSubcatch;
begin
  if Project.Lists[SUBCATCH].Count = 0 then exit;
  S.Add('');
  S.Add('[SUBAREAS]');
  Line := ';;Subcatchment  ' + Tab + 'N-Imperv  ' + Tab + 'N-Perv    ';
  Line := Line + Tab + 'S-Imperv  ' + Tab + 'S-Perv    ' + Tab + 'PctZero   ';
  Line := Line + Tab + 'RouteTo   ' + Tab + 'PctRouted ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------' + Tab + '----------';
  Line := Line + Tab + '----------' + Tab + '----------' + Tab + '----------';
  Line := Line + Tab + '----------' + Tab + '----------';
  S.Add(Line);
  with Project.Lists[SUBCATCH] do
    for I := 0 to Count-1 do
    begin
      C := TSubcatch(Objects[I]);
      Line := Format('%-16s', [Strings[I]]);
      Line := Line + Tab + Format('%-10s', [C.Data[SUBCATCH_IMPERV_N_INDEX]]);
      Line := Line + Tab + Format('%-10s', [C.Data[SUBCATCH_PERV_N_INDEX]]);
      Line := Line + Tab + Format('%-10s', [C.Data[SUBCATCH_IMPERV_DS_INDEX]]);
      Line := Line + Tab + Format('%-10s', [C.Data[SUBCATCH_PERV_DS_INDEX]]);
      Line := Line + Tab + Format('%-10s', [C.Data[SUBCATCH_PCTZERO_INDEX]]);
      Line := Line + Tab + Format('%-10s', [C.Data[SUBCATCH_ROUTE_TO_INDEX]]);
      if not SameText(C.Data[SUBCATCH_ROUTE_TO_INDEX], 'OUTLET')
      then Line := Line + Tab + Format('%-10s', [C.Data[SUBCATCH_PCT_ROUTED_INDEX]]);
      S.Add(Line);
    end;
end;


procedure ExportInfiltration(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I, J, K   : Integer;
  InfilType : String;
  Line      : String;
  C         : TSubcatch;
begin
  if Project.Lists[SUBCATCH].Count = 0 then exit;
  S.Add('');
  S.Add('[INFILTRATION]');
  InfilType := Project.Options.Data[INFILTRATION_INDEX];
  K := -1;
  if SameText(InfilType, InfilOptions[0])
  or SameText(InfilType, InfilOptions[1]) then
  begin
    Line := ';;Subcatchment  ' + Tab + 'MaxRate   ' + Tab + 'MinRate   ';
    Line := Line + Tab + 'Decay     ' + Tab + 'DryTime   ' + Tab + 'MaxInfil  ';
    S.Add(Line);
    Line := ';;--------------' + Tab + '----------' + Tab + '----------';
    Line := Line + Tab + '----------' + Tab + '----------' + Tab + '----------';
    S.Add(Line);
    K := 4;
  end
  else if SameText(InfilType, InfilOptions[2]) then
  begin
    Line := ';;Subcatchment  ' + Tab + 'Suction   ' + Tab + 'HydCon    ' + Tab + 'IMDmax    ';
    S.Add(Line);
    Line := ';;--------------' + Tab + '----------' + Tab + '----------' + Tab + '----------';
    S.Add(Line);
    K := 2;
  end
  else if SameText(InfilType, InfilOptions[3]) then
  begin
    Line := ';;Subcatchment  ' + Tab + 'CurveNum  ' + Tab + 'HydCon    ' + Tab + 'DryTime   ';
    S.Add(Line);
    Line := ';;--------------' + Tab + '----------' + Tab + '----------' + Tab + '----------';
    S.Add(Line);
    K := 2;
  end;
  with Project.Lists[SUBCATCH] do
    for I := 0 to Count-1 do
    begin
      C := TSubcatch(Objects[I]);
      Line := Format('%-16s', [Strings[I]]);
      for J := 0 to K do
        Line := Line + Tab + Format('%-10s', [C.InfilData[J]]);
      S.Add(Line);
    end;
end;

procedure ExportAquifers(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I    : Integer;
  J    : Integer;
  A    : TAquifer;
  Line : String;
begin
  if Project.Lists[AQUIFER].Count = 0 then exit;
  S.Add('');
  S.Add('[AQUIFERS]');
//  Line := ';;              ' + Tab + 'Por-  ' + Tab + 'Wilt  ' + Tab + 'Field ';
//  Line := Line + Tab + 'Hyd   ' + Tab + 'Cond  ' + Tab + 'Tens  ' + Tab + 'Upper ';
//  Line := Line + Tab + 'Lower ' + Tab + 'Lower ' + Tab + 'Bottom' + Tab + 'Water ' + Tab + 'Upper ';
//  S.Add(Line);
  Line := ';;Aquifer       ' + Tab + 'Phi   ' + Tab + 'WP    ' + Tab + 'FC    ';
  Line := Line + Tab + 'HydCon' + Tab + 'Kslope' + Tab + 'Tslope' + Tab + 'UEF   ';
  Line := Line + Tab + 'LED   ' + Tab + 'LGLR  ' + Tab + 'BEL   ' + Tab + 'WTEL  ';
  Line := Line + Tab + 'UZM   ';
  S.Add(Line);
  Line := ';;--------------';
  for I := 0 to MAXAQUIFERPROPS do Line := Line + Tab + '------';
  S.Add(Line);
  with Project.Lists[AQUIFER] do
  begin
    for I := 0 to Count-1 do
    begin
      A := TAquifer(Objects[I]);
      Line := Format('%-16s',[Strings[I]]);
      for J := 0 to MAXAQUIFERPROPS do
        Line := Line + Tab + Format('%-6s',[A.Data[J]]);
      S.Add(Line);
    end;
  end;
end;


procedure ExportGroundwater(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I, J, N: Integer;
  Line   : String;
  Param  : String;
  C      : TSubcatch;
begin
  if Project.Lists[AQUIFER].Count = 0 then exit;

  S.Add('');
  S.Add('[GROUNDWATER]');
  Line := ';;Subcatchment  ' + Tab + 'Aquifer         ' + Tab + 'Node            ';
  Line := Line + Tab + 'Elev  ' + Tab + 'A1    ' + Tab + 'B1    ' + Tab + 'A2    ';
  Line := Line + Tab + 'B2    ' + Tab + 'A3    ' + Tab + 'Hsw   ' + Tab + 'Hcb   ';
  Line := Line + Tab + 'BEL   ' + Tab + 'WTEL  ' + Tab + 'UZM   ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------------' + Tab + '----------------';
  Line := Line + Tab + '------' + Tab + '------' + Tab + '------' + Tab + '------';
  Line := Line + Tab + '------' + Tab + '------' + Tab + '------' + Tab + '------';
  Line := Line + Tab + '------' + Tab + '------' + Tab + '------';
  S.Add(Line);

  N := 0;
  with Project.Lists[SUBCATCH] do
  begin
    for I := 0 to Count-1 do
    begin
      C := TSubcatch(Objects[I]);
      if C.Groundwater.Count < 2 then continue;
      Line := Format('%-16s', [Strings[I]]);
      Line := Line + Tab + Format('%-16s', [C.Groundwater[0]]);
      Line := Line + Tab + Format('%-16s', [C.Groundwater[1]]);
      for J := 2 to 8 do
        Line := Line + Tab + Format('%-6s', [C.Groundwater[J]]);
      for J := 9 to 12 do
      begin
        Param := C.Groundwater[J];
        if Length(Param) = 0 then Param := '*';
        Line := Line + Tab + Format('%-6s', [Param]);
      end;
      S.Add(Line);
      if Length(C.GwFlowEqn) > 0 then Inc(N);
    end;
  end;

  if N > 0 then
  begin
    S.Add('');
    S.Add('[GW_FLOW]');
    Line := ';;Subcatchment  ' + Tab + 'Outflow Equation';
    S.Add(Line);
    Line := ';;--------------' + Tab + '----------------';
    S.Add(Line);

    with Project.Lists[SUBCATCH] do
    begin
      for I := 0 to Count-1 do
      begin
        C := TSubcatch(Objects[I]);
        if Length(C.GwFlowEqn) > 0 then
        begin
          Line := Format('%-16s', [Strings[I]]);
          Line := Line + Tab + C.GwFlowEqn;
          S.Add(Line);
        end;
      end;
    end;
  end;
end;


procedure ExportSnowpacks(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I    : Integer;
  J    : Integer;
  P    : TSnowpack;
  Line : String;
begin
  if Project.Lists[SNOWPACK].Count = 0 then exit;
  S.Add('');
  S.Add('[SNOWPACKS]');
  S.Add(';;Snowpack Data');
  with Project.Lists[SNOWPACK] do
  begin
    for I := 0 to Count-1 do
    begin
      P := TSnowpack(Objects[I]);
      Line := Format('%-16s', [Strings[I]]);
      Line := Line + Tab + 'PLOWABLE  ';
      for J := 1 to 6 do Line := Line + Tab + Format('%-10s', [P.Data[1][J]]);
      Line := Line + Tab + Format('%-10s', [P.FracPlowable]);
      S.Add(Line);
      Line := Format('%-16s', [Strings[I]]);
      Line := Line + Tab + 'IMPERVIOUS';
      for J := 1 to 7 do Line := Line + Tab + Format('%-10s', [P.Data[2][J]]);
      S.Add(Line);
      Line := Format('%-16s', [Strings[I]]);
      Line := Line + Tab + 'PERVIOUS  ';
      for J := 1 to 7 do Line := Line + Tab + Format('%-10s', [P.Data[3][J]]);
      S.Add(Line);
      Line := Format('%-16s', [Strings[I]]);
      Line := Line + Tab + 'REMOVAL   ';
      for J := 1 to 6 do Line := Line + Tab + Format('%-10s', [P.Plowing[J]]);
      Line := Line + Tab + P.Plowing[7];
      S.Add(Line);
    end;
  end;
end;


procedure UpdateNodePropertyCount(N: TNode);
//-----------------------------------------------------------------------------
begin
  if N.DXInflow.Count > 0 then Inc(DXFCount);
  if N.DWInflow.Count > 0 then Inc(DWFCount);
  if N.IIInflow.Count > 0 then Inc(RDIICount);
  if N.Treatment.Count > 0 then Inc(TreatCount);
end;


procedure ExportJunctions(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I     : Integer;
  Line  : String;
  N     : TNode;
begin
  if Project.Lists[JUNCTION].Count = 0 then exit;
  S.Add('');
  S.Add('[JUNCTIONS]');
//Line := ';;              ' + Tab + 'Invert    ' + Tab + 'Max.      ';
//Line := Line + Tab + 'Init.     ' + Tab + 'Surcharge ' + Tab + 'Ponded    ';
//S.Add(Line);
  Line := ';;Junction      ' + Tab + 'Invert    ' + Tab + 'Dmax      ';
  Line := Line + Tab + 'Dinit     ' + Tab + 'Dsurch    ' + Tab + 'Aponded   ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------' + Tab + '----------';
  Line := Line + Tab + '----------' + Tab + '----------' + Tab + '----------';
  S.Add(Line);
  with Project.Lists[JUNCTION] do
    for I := 0 to Count-1 do
    begin
      N := TNode(Objects[I]);
      ExportComment(S, N.Data[COMMENT_INDEX]);
      UpdateNodePropertyCount(N);
      Line := Format('%-16s', [Strings[I]]);
      Line := Line + Tab + Format('%-10s', [N.Data[NODE_INVERT_INDEX]]);
      Line := Line + Tab + Format('%-10s', [N.Data[JUNCTION_MAX_DEPTH_INDEX]]);
      Line := Line + Tab + Format('%-10s', [N.Data[JUNCTION_INIT_DEPTH_INDEX]]);
      Line := Line + Tab + Format('%-10s', [N.Data[JUNCTION_SURCHARGE_DEPTH_INDEX]]);
      Line := Line + Tab + Format('%-10s', [N.Data[JUNCTION_PONDED_AREA_INDEX]]);
      S.Add(Line);
    end;
end;


procedure ExportOutfalls(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I, J, K: Integer;
  Line   : String;
  N      : TNode;
begin
  if Project.Lists[OUTFALL].Count = 0 then exit;
  S.Add('');
  S.Add('[OUTFALLS]');
//Line := ';;              ' + Tab + 'Invert    ' + Tab + 'Outfall   ';
//Line := Line + Tab + 'Stage/Table     ' + Tab + 'Tide';
//S.Add(Line);
  Line := ';;Outfall       ' + Tab + 'Invert    ' + Tab + 'Type      ';
  Line := Line + Tab + 'Stage Data      ' + Tab + 'Gated   ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------' + Tab + '----------';
  Line := Line + Tab + '----------------' + Tab + '--------';
  S.Add(Line);
  with Project.Lists[OUTFALL] do
    for I := 0 to Count-1 do
    begin
      N := TNode(Objects[I]);
      ExportComment(S, N.Data[COMMENT_INDEX]);
      UpdateNodePropertyCount(N);
      Line := Format('%-16s', [Strings[I]]);
      Line := Line + Tab + Format('%-10s', [N.Data[NODE_INVERT_INDEX]]);
      Line := Line + Tab + Format('%-10s', [N.Data[OUTFALL_TYPE_INDEX]]);
      K := -1;
      for J := 0 to High(OutfallOptions) do
      begin
        if SameText(N.Data[OUTFALL_TYPE_INDEX], OutfallOptions[J]) then
        begin
          K := J;
          break;
        end;
      end;
      case K of
      FIXED_OUTFALL:
        Line := Line + Tab + Format('%-16s', [N.Data[OUTFALL_FIXED_STAGE_INDEX]]);
      TIDAL_OUTFALL:
        Line := Line + Tab + Format('%-16s', [N.Data[OUTFALL_TIDE_TABLE_INDEX]]);
      TIMESERIES_OUTFALL:
        Line := Line + Tab + Format('%-16s', [N.Data[OUTFALL_TIME_SERIES_INDEX]]);
      else Line := Line + Tab + '                ';
      end;
      Line := Line + Tab + N.Data[OUTFALL_TIDE_GATE_INDEX];
      S.Add(Line);
    end;
end;


procedure ExportDividers(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I, J, K: Integer;
  Line   : String;
  N      : TNode;
begin
  if Project.Lists[DIVIDER].Count = 0 then exit;
  S.Add('');
  S.Add('[DIVIDERS]');
//Line := ';;              ' + Tab + 'Invert    ' + Tab + 'Diverted        ';
//Line := Line + Tab + 'Divider   ';
//S.Add(Line);
  Line := ';;Divider       ' + Tab + 'Invert    ' + Tab + 'Diverted Link   ';
  Line := Line + Tab + 'Type      ' + Tab + 'Parameters';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------' + Tab + '----------------';
  Line := Line + Tab + '----------' + Tab + '----------';
  S.Add(Line);
  with Project.Lists[DIVIDER] do
    for I := 0 to Count-1 do
    begin
      N := TNode(Objects[I]);
      ExportComment(S, N.Data[COMMENT_INDEX]);
      UpdateNodePropertyCount(N);
      Line := Format('%-16s', [Strings[I]]);
      Line := Line + Tab + Format('%-10s', [N.Data[NODE_INVERT_INDEX]]);
      Line := Line + Tab + Format('%-16s', [N.Data[DIVIDER_LINK_INDEX]]);
      Line := Line + Tab + Format('%-10s', [N.Data[DIVIDER_TYPE_INDEX]]);
      K := -1;
      for J := 0 to High(DividerOptions) do
      begin
        if SameText(N.Data[DIVIDER_TYPE_INDEX], DividerOptions[J]) then
        begin
          K := J;
          break;
        end;
      end;
      case K of
      CUTOFF_DIVIDER:
        Line := Line + Tab + Format('%-10s', [N.Data[DIVIDER_CUTOFF_INDEX]]);
      TABULAR_DIVIDER:
        Line := Line + Tab + Format('%-16s', [N.Data[DIVIDER_TABLE_INDEX]]);
      WEIR_DIVIDER:
        begin
          Line := Line + Tab + Format('%-10s', [N.Data[DIVIDER_QMIN_INDEX]]);
          Line := Line + Tab + Format('%-10s', [N.Data[DIVIDER_DMAX_INDEX]]);
          Line := Line + Tab + Format('%-10s', [N.Data[DIVIDER_QCOEFF_INDEX]]);
        end
      end;
      for J := DIVIDER_MAX_DEPTH_INDEX to DIVIDER_PONDED_AREA_INDEX do
        Line := Line + Tab + Format('%-10s', [N.Data[J]]);
      S.Add(Line);
    end;
end;


procedure ExportStorage(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I    : Integer;
  Line : String;
  N    : TNode;
begin
  if Project.Lists[STORAGE].Count = 0 then exit;
  S.Add('');
  S.Add('[STORAGE]');
//Line := ';;              ' + Tab + 'Invert  ' + Tab + 'Max.    ' + Tab + 'Init.   ';
//Line := Line + Tab + 'Storage   ' + Tab + 'Curve   ' + Tab + '        ';
//Line := Line + Tab + '        ' + Tab + 'Ponded  ' + Tab + 'Evap.   ';
//Line := Line + Tab + 'Seepage';
//S.Add(Line);
  Line := ';;Storage Node  ' + Tab + 'Invert  ' + Tab + 'Dmax    ' + Tab + 'Dinit    ';
  Line := Line + Tab + 'Curve     ' + Tab + 'Name/Params                 ';
  Line := Line + Tab + 'Aponded ' + Tab + 'Fevap   ' + Tab + 'SeepRate';
  S.Add(Line);
  Line := ';;--------------' + Tab + '--------' + Tab + '--------' + Tab + '---------';
  Line := Line + Tab + '----------' + Tab + '----------------------------';
  Line := Line + Tab + '--------' + Tab + '--------' + Tab + '--------';
  S.Add(Line);
  with Project.Lists[STORAGE] do
    for I := 0 to Count-1 do
    begin
      N := TNode(Objects[I]);
      ExportComment(S, N.Data[COMMENT_INDEX]);
      UpdateNodePropertyCount(N);
      Line := Format('%-16s', [Strings[I]]);
      Line := Line + Tab + Format('%-8s', [N.Data[NODE_INVERT_INDEX]]);
      Line := Line + Tab + Format('%-8s', [N.Data[STORAGE_MAX_DEPTH_INDEX]]);
      Line := Line + Tab + Format('%-9s', [N.Data[STORAGE_INIT_DEPTH_INDEX]]);
      Line := Line + Tab + Format('%-10s', [N.Data[STORAGE_GEOMETRY_INDEX]]);
      if  SameText(N.Data[STORAGE_GEOMETRY_INDEX], 'FUNCTIONAL') then
      begin
        Line := Line + Tab + Format('%-8s  ', [N.Data[STORAGE_ACOEFF_INDEX]]);
        Line := Line + Format('%-8s  ', [N.Data[STORAGE_AEXPON_INDEX]]);
        Line := Line + Format('%-8s', [N.Data[STORAGE_ACONST_INDEX]]);
      end
      else
      begin
        Line := Line + Tab + Format('%-28s', [N.Data[STORAGE_ATABLE_INDEX]]);
      end;
      Line := Line + Tab + Format('%-8s', [N.Data[STORAGE_PONDED_AREA_INDEX]]);
      Line := Line + Tab + Format('%-8s', [N.Data[STORAGE_EVAP_FACTOR_INDEX]]);
      Line := Line + Tab + Format('%-8s', [N.Data[STORAGE_SEEPAGE_INDEX]]);
      S.Add(Line);
    end;
end;


procedure ExportConduits(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I     : Integer;
  Line  : String;
  L     : TLink;
begin
  if Project.Lists[CONDUIT].Count = 0 then exit;
  S.Add('');
  S.Add('[CONDUITS]');
  //ne := ';;              ' + Tab + 'Inlet           ' + Tab + 'Outlet          ';
  //ne := Line + Tab + '          ' + Tab + 'Manning   ' + Tab + 'Inlet     ';
  //ne := Line + Tab + 'Outlet    ' + Tab + 'Init.     ' + Tab + 'Max.      ';
  //Add(Line);
  Line := ';;Conduit       ' + Tab + 'From Node       ' + Tab + 'To Node         ';
  Line := Line + Tab + 'Length    ' + Tab + 'Roughness ' + Tab + 'InOffset  ';
  Line := Line + Tab + 'OutOffset ' + Tab + 'InitFlow  ' + Tab + 'MaxFlow   ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------------' + Tab + '----------------';
  Line := Line + Tab + '----------' + Tab + '----------' + Tab + '----------';
  Line := Line + Tab + '----------' + Tab + '----------' + Tab + '----------';
  S.Add(Line);
  with Project.Lists[CONDUIT] do
    for I := 0 to Count-1 do
    begin
      L := TLink(Objects[I]);
      ExportComment(S, L.Data[COMMENT_INDEX]);
      Line := Format('%-16s', [Strings[I]]);
      Line := Line + Tab + Format('%-16s', [L.Node1.ID]);
      Line := Line + Tab + Format('%-16s', [L.Node2.ID]);
      Line := Line + Tab + Format('%-10s', [L.Data[CONDUIT_LENGTH_INDEX]]);
      Line := Line + Tab + Format('%-10s', [L.Data[CONDUIT_ROUGHNESS_INDEX]]);
      Line := Line + Tab + Format('%-10s', [L.Data[CONDUIT_INLET_HT_INDEX]]);
      Line := Line + Tab + Format('%-10s', [L.Data[CONDUIT_OUTLET_HT_INDEX]]);
      Line := Line + Tab + Format('%-10s', [L.Data[CONDUIT_INIT_FLOW_INDEX]]);
      Line := Line + Tab + Format('%-10s', [L.Data[CONDUIT_MAX_FLOW_INDEX]]);
      S.Add(Line);
    end;
end;


procedure ExportPumps(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I     : Integer;
  Line  : String;
  L     : TLink;
begin
  if Project.Lists[PUMP].Count = 0 then exit;
  S.Add('');
  S.Add('[PUMPS]');
  //Line := ';;              ' + Tab + 'Inlet           ' + Tab + 'Outlet          ';
  //Line := Line + Tab + 'Pump            ' + Tab + 'Init. ';
  //Line := Line + Tab + 'Startup ' + Tab + 'Shutoff ';
  //S.Add(Line);
  Line := ';;Pump          ' + Tab + 'From Node       ' + Tab + 'To Node         ';
  Line := Line + Tab + 'PumpCurve       ' + Tab + 'Status  ';
  Line := Line + Tab + 'Dstart  ' + Tab + 'Doff    ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------------' + Tab + '----------------';
  Line := Line + Tab + '----------------' + Tab + '------';
  Line := Line + Tab + '--------' + Tab + '--------';
  S.Add(Line);
  with Project.Lists[PUMP] do
    for I := 0 to Count-1 do
    begin
      L := TLink(Objects[I]);
      ExportComment(S, L.Data[COMMENT_INDEX]);
      Line := Format('%-16s', [Strings[I]]);
      Line := Line + Tab + Format('%-16s', [L.Node1.ID]);
      Line := Line + Tab + Format('%-16s', [L.Node2.ID]);
      if Length(L.Data[PUMP_CURVE_INDEX]) = 0 then
        Line := Line + Tab + '*               '
      else
        Line := Line + Tab + Format('%-16s', [L.Data[PUMP_CURVE_INDEX]]);
      Line := Line + Tab + Format('%-8s', [L.Data[PUMP_STATUS_INDEX]]);
      Line := Line + Tab + Format('%-8s', [L.Data[PUMP_STARTUP_INDEX]]);
      Line := Line + Tab + Format('%-8s', [L.Data[PUMP_SHUTOFF_INDEX]]);
      S.Add(Line);
    end;
end;


procedure ExportOrifices(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I     : Integer;
  Line  : String;
  L     : TLink;
begin
  if Project.Lists[ORIFICE].Count = 0 then exit;
  S.Add('');
  S.Add('[ORIFICES]');
  //Line := ';;              ' + Tab + 'Inlet           ' + Tab + 'Outlet          ';
  //Line := Line + Tab + 'Orifice     ' + Tab + 'Crest     ' + Tab + 'Disch.    ';
  //Line := Line + Tab + 'Flap' + Tab + 'Open/Close';
  //S.Add(Line);
  Line := ';;Orifice       ' + Tab + 'From Node       ' + Tab + 'To Node         ';
  Line := Line + Tab + 'Type        ' + Tab + 'CrestHt   ' + Tab + 'Qcoeff    ';
  Line := Line + Tab + 'Gated   ' + Tab + 'CloseTime ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------------' + Tab + '----------------';
  Line := Line + Tab + '------------' + Tab + '----------' + Tab + '----------';
  Line := Line + Tab + '--------' + Tab + '----------';
  S.Add(Line);
  with Project.Lists[ORIFICE] do
    for I := 0 to Count-1 do
    begin
      L := TLink(Objects[I]);
      ExportComment(S, L.Data[COMMENT_INDEX]);
      Line := Format('%-16s', [Strings[I]]);
      Line := Line + Tab + Format('%-16s', [L.Node1.ID]);
      Line := Line + Tab + Format('%-16s', [L.Node2.ID]);
      Line := Line + Tab + Format('%-12s', [L.Data[ORIFICE_TYPE_INDEX]]);
      Line := Line + Tab + Format('%-10s', [L.Data[ORIFICE_BOTTOM_HT_INDEX]]);
      Line := Line + Tab + Format('%-10s', [L.Data[ORIFICE_COEFF_INDEX]]);
      Line := Line + Tab + Format('%-8s', [L.Data[ORIFICE_FLAPGATE_INDEX]]);
      Line := Line + Tab + Format('%-10s', [L.Data[ORIFICE_ORATE_INDEX]]);
      S.Add(Line);
   end;
end;


procedure ExportWeirs(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I     : Integer;
  Line  : String;
  L     : TLink;
begin
  if Project.Lists[WEIR].Count = 0 then exit;
  S.Add('');
  S.Add('[WEIRS]');
//  Line := ';;              ' + Tab + 'Inlet           ' + Tab + 'Outlet          ';
//  Line := Line + Tab + 'Weir        ' + Tab + 'Crest     ' + Tab + 'Disch.    ';
//  Line := Line + Tab + 'Flap' + Tab + 'End     ' + Tab + 'End       ';
//  S.Add(Line);
  Line := ';;Weir          ' + Tab + 'From Node       ' + Tab + 'To Node         ';
  Line := Line + Tab + 'Type        ' + Tab + 'CrestHt   ' + Tab + 'Qcoeff    ';
  Line := Line + Tab + 'Gated   ' + Tab + 'EndCon  ' + Tab + 'EndCoeff  ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------------' + Tab + '----------------';
  Line := Line + Tab + '------------' + Tab + '----------' + Tab + '----------';
  Line := Line + Tab + '--------' + Tab + '--------' + Tab + '----------';
  S.Add(Line);
  with Project.Lists[WEIR] do
    for I := 0 to Count-1 do
    begin
      L := TLink(Objects[I]);
      ExportComment(S, L.Data[COMMENT_INDEX]);
      Line := Format('%-16s', [Strings[I]]);
      Line := Line + Tab + Format('%-16s', [L.Node1.ID]);
      Line := Line + Tab + Format('%-16s', [L.Node2.ID]);
      Line := Line + Tab + Format('%-12s', [L.Data[WEIR_TYPE_INDEX]]);
      Line := Line + Tab + Format('%-10s', [L.Data[WEIR_CREST_INDEX]]);
      Line := Line + Tab + Format('%-10s', [L.Data[WEIR_COEFF_INDEX]]);
      Line := Line + Tab + Format('%-8s',  [L.Data[WEIR_FLAPGATE_INDEX]]);
      Line := Line + Tab + Format('%-8s',  [L.Data[WEIR_CONTRACT_INDEX]]);
      Line := Line + Tab + Format('%-10s', [L.Data[WEIR_END_COEFF_INDEX]]);
      S.Add(Line);
    end;
end;


procedure ExportOutlets(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I     : Integer;
  Line  : String;
  L     : TLink;
begin
  if Project.Lists[OUTLET].Count = 0 then exit;
  S.Add('');
  S.Add('[OUTLETS]');
//Line := ';;              ' + Tab + 'Inlet           ' + Tab + 'Outlet          ';
//Line := Line + Tab + 'Outflow   ' + Tab + 'Outlet         ';
//Line := Line + Tab + 'Qcoeff/         ' + Tab + '          ' + Tab + 'Flap';
//S.Add(Line);
  Line := ';;Outlet        ' + Tab + 'From Node       ' + Tab + 'To Node         ';
  Line := Line + Tab + 'CrestHt   ' + Tab + 'Type           ';
  Line := Line + Tab + 'QTable/Qcoeff   ' + Tab + 'Qexpon    ' + Tab + 'Gated   ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------------' + Tab + '----------------';
  Line := Line + Tab + '----------' + Tab + '---------------';
  Line := Line + Tab + '----------------' + Tab + '----------' + Tab + '--------';
  S.Add(Line);
  with Project.Lists[OUTLET] do
    for I := 0 to Count-1 do
    begin
      L := TLink(Objects[I]);
      ExportComment(S, L.Data[COMMENT_INDEX]);
      Line := Format('%-16s', [Strings[I]]);
      Line := Line + Tab + Format('%-16s', [L.Node1.ID]);
      Line := Line + Tab + Format('%-16s', [L.Node2.ID]);
      Line := Line + Tab + Format('%-10s', [L.Data[OUTLET_CREST_INDEX]]);
      Line := Line + Tab + Format('%-15s', [L.Data[OUTLET_TYPE_INDEX]]);
      if  AnsiContainsText(L.Data[OUTLET_TYPE_INDEX], 'FUNCTIONAL') then
      begin
        Line := Line + Tab + Format('%-16s', [L.Data[OUTLET_QCOEFF_INDEX]]);
        Line := Line + Tab + Format('%-10s', [L.Data[OUTLET_QEXPON_INDEX]]);
      end
      else
      begin
        Line := Line + Tab + Format('%-16s', [L.Data[OUTLET_QTABLE_INDEX]]);
        Line := Line + Tab + '          ';
      end;
      Line := Line + Tab + Format('%-8s', [L.Data[OUTLET_FLAPGATE_INDEX]]);
      S.Add(Line);
    end;
end;


procedure ExportXsections(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I, J  : Integer;
  Line  : String;
  L     : TLink;
begin
  if Project.Lists[CONDUIT].Count + Project.Lists[ORIFICE].Count +
     Project.Lists[WEIR].Count  = 0 then exit;
  S.Add('');
  S.Add('[XSECTIONS]');
  Line := ';;Link          ' + Tab + 'Shape       ' + Tab + 'Geom1           ';
  Line := Line + Tab + 'Geom2     ' + Tab + 'Geom3     ' + Tab + 'Geom4     ';
  Line := Line + Tab + 'Barrels   ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '------------' + Tab + '----------------';
  Line := Line + Tab + '----------' + Tab + '----------' + Tab + '----------';
  Line := Line + Tab + '----------';
  S.Add(Line);
  with Project.Lists[CONDUIT] do
    for I := 0 to Count-1 do
    begin
      L := TLink(Objects[I]);
      Line := Format('%-16s', [Strings[I]]);
      Line := Line + Tab + Format('%-12s', [L.Data[CONDUIT_SHAPE_INDEX]]);
      if (Length(L.Data[CONDUIT_TSECT_INDEX]) > 0)
      and SameText(L.Data[CONDUIT_SHAPE_INDEX], 'IRREGULAR') then
        Line := Line + Tab + Format('%-16s', [L.Data[CONDUIT_TSECT_INDEX]])
      else
        Line := Line + Tab + Format('%-16s', [L.Data[CONDUIT_GEOM1_INDEX]]);
      for J := CONDUIT_GEOM2_INDEX to CONDUIT_BARRELS_INDEX do
        Line := Line + Tab + Format('%-10s', [L.Data[J]]);
      Line := Line + Tab + Format('%-10s', [L.Data[CONDUIT_CULVERT_INDEX]]);
      S.Add(Line);
    end;
  with Project.Lists[ORIFICE] do
    for I := 0 to Count-1 do
    begin
      L := TLink(Objects[I]);
      Line := Format('%-16s', [Strings[I]]);
      Line := Line + Tab + Format('%-12s', [L.Data[ORIFICE_SHAPE_INDEX]]);
      Line := Line + Tab + Format('%-16s', [L.Data[ORIFICE_HEIGHT_INDEX]]);
      if SameText(L.Data[ORIFICE_SHAPE_INDEX], 'CIRCULAR') then
        Line := Line + Tab + '0         '
      else
        Line := Line + Tab + Format('%-10s', [L.Data[ORIFICE_WIDTH_INDEX]]);
      Line := Line + Tab + '0         ' + Tab + '0';
      S.Add(Line);
    end;
  with Project.Lists[WEIR] do
    for I := 0 to Count-1 do
    begin
      L := TLink(Objects[I]);
      Line := Format('%-16s', [Strings[I]]);
      Line := Line + Tab + Format('%-12s', [L.Data[WEIR_SHAPE_INDEX]]);
      Line := Line + Tab + Format('%-16s', [L.Data[WEIR_HEIGHT_INDEX]]);
      Line := Line + Tab + Format('%-10s', [L.Data[WEIR_WIDTH_INDEX]]);
      Line := Line + Tab + Format('%-10s', [L.Data[WEIR_SLOPE_INDEX]]);
      Line := Line + Tab + Format('%-10s', [L.Data[WEIR_SLOPE_INDEX]]);
      S.Add(Line);
    end;
end;


procedure ExportTransects(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I: Integer;
  J: Integer;
  K: Integer;
  L: Integer;
  ID: String;
  Line: String;
  Tsect: TTransect;
begin
  if Project.Lists[TRANSECT].Count = 0 then exit;
  S.Add('');
  S.Add('[TRANSECTS]');
  S.Add(';;Transect Data in HEC-1 format');
  for I := 0 to Project.Lists[TRANSECT].Count-1 do
  begin
    ID := Project.Lists[TRANSECT].Strings[I];
    Tsect := TTransect(Project.Lists[TRANSECT].Objects[I]);
    K := Tsect.Xdata.Count;
    if K = 0 then continue;
    S.Add(';');
    ExportComment(S, Tsect.Comment);

    Line := 'NC';
    Line := Line + Tab + Format('%-8s', [Tsect.Data[TRANSECT_N_LEFT]]);
    Line := Line + Tab + Format('%-8s', [Tsect.Data[TRANSECT_N_RIGHT]]);
    Line := Line + Tab + Format('%-8s', [Tsect.Data[TRANSECT_N_CHANNEL]]);
    S.Add(Line);

    Line := 'X1';
    Line := Line + Tab + Format('%-16s ', [ID]);
    Line := Line + Tab + Format('%-8d', [K]);
    Line := Line + Tab + Format('%-8s', [Tsect.Data[TRANSECT_X_LEFT]]);
    Line := Line + Tab + Format('%-8s', [Tsect.Data[TRANSECT_X_RIGHT]]);
    Line := Line + Tab + '0.0     ' + Tab + '0.0     ';
    Line := Line + Tab + Format('%-8s', [Tsect.Data[TRANSECT_L_FACTOR]]);
    Line := Line + Tab + Format('%-8s', [Tsect.Data[TRANSECT_X_FACTOR]]);
    Line := Line + Tab + Format('%-8s', [Tsect.Data[TRANSECT_Y_FACTOR]]);
    S.Add(Line);

    Line := 'GR';
    L := 0;
    for J := 0 to K-1 do
    begin
      Line := Line + Tab + Format('%-8s', [Tsect.Ydata[J]]);
      Line := Line + Tab + Format('%-8s', [Tsect.Xdata[J]]);
      Inc(L);
      if L = 5 then
      begin
        S.Add(Line);
        Line := 'GR';
        L := 0;
      end;
    end;
    if L > 0 then S.Add(Line);
  end;
end;


procedure ExportLosses(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I     : Integer;
  Line  : String;
  L     : TLink;
begin
  if Project.Lists[CONDUIT].Count = 0 then exit;
  S.Add('');
  S.Add('[LOSSES]');
  Line := ';;Link          ' + Tab + 'Kin       ' + Tab + 'Kout      ';
  Line := Line + Tab + 'Kavg      ' + Tab + 'Flap Gate ' + Tab + 'SeepRate  ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------' + Tab + '----------';
  Line := Line + tab + '----------' + Tab + '----------' + Tab + '----------';
  S.Add(Line);
  with Project.Lists[CONDUIT] do
  for I := 0 to Count-1 do
  begin
    L := TLink(Objects[I]);
    if  SameText(L.Data[CONDUIT_ENTRY_LOSS_INDEX], '0')
    and SameText(L.Data[CONDUIT_EXIT_LOSS_INDEX], '0')
    and SameText(L.Data[CONDUIT_AVG_LOSS_INDEX], '0')
    and SameText(L.Data[CONDUIT_SEEPAGE_INDEX], '0')
    and SameText(L.Data[CONDUIT_CHECK_VALVE_INDEX], 'NO') then continue;
    Line := Format('%-16s', [Strings[I]]);
    Line := Line + Tab + Format('%-10s', [L.Data[CONDUIT_ENTRY_LOSS_INDEX]]);
    Line := Line + Tab + Format('%-10s', [L.Data[CONDUIT_EXIT_LOSS_INDEX]]);
    Line := Line + Tab + Format('%-10s', [L.Data[CONDUIT_AVG_LOSS_INDEX]]);
    Line := Line + Tab + Format('%-10s', [L.Data[CONDUIT_CHECK_VALVE_INDEX]]);
    Line := Line + Tab + Format('%-10s', [L.Data[CONDUIT_SEEPAGE_INDEX]]);                         //(5.0.023 - LR)
    S.Add(Line);
  end;
end;


procedure ExportPollutants(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I      : Integer;
  Line   : String;
  Pollut : TPollutant;
begin
  if Project.Lists[POLLUTANT].Count = 0 then exit;
  S.Add('');
  S.Add('[POLLUTANTS]');
//  Line := ';;              ' + Tab + 'Mass  ' + Tab + 'Rain      ';
//  Line := Line + Tab + 'GW        ' + Tab + 'I&I       ' + Tab + 'Decay     ';
//  Line := Line + Tab + 'Snow ' + Tab + 'Co-Pollut.      ' + Tab + 'Co-Pollut.';
//  Line := Line + Tab + 'DWF       ';
//  S.Add(Line);
  Line := ';;Pollutant     ' + Tab + 'Units ' + Tab + 'Cppt      ';
  Line := Line + Tab + 'Cgw       ' + Tab + 'Crdii     ' + Tab + 'Kdecay    ';
  Line := Line + Tab + 'SnowOnly  ' + Tab + 'Co-Pollutant    ' + Tab + 'Co-Frac   ';
  Line := Line + Tab + 'Cdwf      ' + Tab + 'Cinit     ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '------' + Tab + '----------';
  Line := Line + Tab + '----------' + Tab + '----------' + Tab + '----------';
  Line := Line + Tab + '----------' + Tab + '----------------' + Tab + '----------';
  Line := Line + Tab + '----------' + Tab + '----------';
  S.Add(Line);
  with Project.Lists[POLLUTANT] do
    for I := 0 to Count-1 do
    begin
      Pollut := TPollutant(Objects[I]);
      Line := Format('%-16s',[Strings[I]]);
      Line := Line + Tab + Format('%-6s',[Pollut.Data[POLLUT_UNITS_INDEX]]);
      Line := Line + Tab + Format('%-10s',[Pollut.Data[POLLUT_RAIN_INDEX]]);
      Line := Line + Tab + Format('%-10s',[Pollut.Data[POLLUT_GW_INDEX]]);
      Line := Line + Tab + Format('%-10s',[Pollut.Data[POLLUT_II_INDEX]]);
      Line := Line + Tab + Format('%-10s',[Pollut.Data[POLLUT_DECAY_INDEX]]);
      Line := Line + Tab + Format('%-10s',[Pollut.Data[POLLUT_SNOW_INDEX]]);
      if Length(Trim(Pollut.Data[POLLUT_COPOLLUT_INDEX])) > 0 then
      begin
        Line := Line + Tab + Format('%-16s',[Pollut.Data[POLLUT_COPOLLUT_INDEX]]);
        Line := Line + Tab + Format('%-10s',[Pollut.Data[POLLUT_FRACTION_INDEX]]);
      end
      else Line := Line + Tab + '*               ' + Tab + '0.0       ';
      Line := Line + Tab + Format('%-10s',[Pollut.Data[POLLUT_DWF_INDEX]]);
      Line := Line + Tab + Format('%-10s',[Pollut.Data[POLLUT_INIT_INDEX]]);
      S.Add(Line);
    end;
end;


procedure ExportLanduses(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I      : Integer;
  Line   : String;
  Lnduse : TLanduse;
begin
  if Project.Lists[LANDUSE].Count = 0 then exit;
  S.Add('');
  S.Add('[LANDUSES]');
  Line := ';;              ' + Tab + 'Cleaning  ' + Tab + 'Fraction  ' + Tab + 'Last      ';
  S.Add(Line);
  Line := ';;Land Use      ' + Tab + 'Interval  ' + Tab + 'Available ' + Tab + 'Cleaned   ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------' + Tab + '----------' + Tab + '----------';
  S.Add(Line);
  with Project.Lists[LANDUSE] do
    for I := 0 to Count-1 do
    begin
      Lnduse := TLanduse(Objects[I]);
      ExportComment(S, Lnduse.Data[COMMENT_INDEX]);
      Line := Format('%-16s',[Strings[I]]);
      Line := Line + Tab + Format('%-10s',[Lnduse.Data[LANDUSE_CLEANING_INDEX]]);
      Line := Line + Tab + Format('%-10s',[Lnduse.Data[LANDUSE_AVAILABLE_INDEX]]);
      Line := Line + Tab + Format('%-10s',[Lnduse.Data[LANDUSE_LASTCLEAN_INDEX]]);
      S.Add(Line);
    end;
end;


procedure ExportBuildup(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I, J, K: Integer;
  Lnduse : String;
  Line   : String;
  npsList: TStringlist;
  nps    : TNonpointSource;
begin
  if Project.Lists[LANDUSE].Count = 0 then exit;
  If Project.Lists[POLLUTANT].Count = 0 then exit;
  S.Add('');
  S.Add('[BUILDUP]');
  Line := ';;Land Use      ' + Tab + 'Pollutant       ' + Tab + 'Function  ';
  Line := Line + Tab + 'Coeff1    ' + Tab + 'Coeff2    ' + Tab + 'Coeff3    ';
  Line := Line + Tab + 'Normalizer';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------------' + Tab + '----------';
  Line := Line + Tab + '----------' + Tab + '----------' + Tab + '----------';
  Line := Line + Tab + '----------';
  S.Add(Line);
  with Project.Lists[LANDUSE] do
  for I := 0 to Count-1 do
  begin
    Lnduse := Strings[I];
    npsList := TLanduse(Objects[I]).NonpointSources;
    for J := 0 to npsList.Count-1 do
    begin
      nps := TNonpointSource(npsList.Objects[J]);
      Line := Format('%-16s', [Lnduse]);
      Line := Line + Tab + Format('%-16s', [npsList[J]]);
      for K := 0 to 4 do
        Line := Line + Tab + Format('%-10s', [nps.BuildupData[K]]);
      S.Add(Line);
    end;
  end;
end;


procedure ExportWashoff(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I, J, K: Integer;
  Lnduse : String;
  Line   : String;
  npsList: TStringlist;
  nps    : TNonpointSource;
begin
  if Project.Lists[LANDUSE].Count = 0 then exit;
  If Project.Lists[POLLUTANT].Count = 0 then exit;
  S.Add('');
  S.Add('[WASHOFF]');
//  Line := ';;              ' + Tab + '                ' + Tab + '          ';
//  Line := Line + Tab + '          ' + Tab + '          ' + Tab + 'Cleaning  ';
//  Line := Line + Tab + 'BMP       ';
//  S.Add(Line);
  Line := ';;Land Use      ' + Tab + 'Pollutant       ' + Tab + 'Function  ';
  Line := Line + Tab + 'Coeff1    ' + Tab + 'Coeff2    ' + Tab + 'Ecleaning ';
  Line := Line + Tab + 'Ebmp      ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------------' + Tab + '----------';
  Line := Line + Tab + '----------' + Tab + '----------' + Tab + '----------';
  Line := Line + Tab + '----------';
  S.Add(Line);
  with Project.Lists[LANDUSE] do
  for I := 0 to Count-1 do
  begin
    Lnduse := Strings[I];
    npsList := TLanduse(Objects[I]).NonpointSources;
    for J := 0 to npsList.Count-1 do
    begin
      nps := TNonpointSource(npsList.Objects[J]);
      Line := Format('%-16s', [Lnduse]);
      Line := Line + Tab + Format('%-16s', [npsList[J]]);
      for K := 0 to 4 do
        Line := Line + Tab + Format('%-10s', [nps.WashoffData[K]]);
      S.Add(Line);
    end;
  end;
end;


procedure ExportCoverages(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I, J: Integer;
  C: TSubcatch;
  Line: String;
begin
  if Project.Lists[SUBCATCH].Count = 0 then exit;
  if Project.Lists[LANDUSE].Count = 0 then exit;
  S.Add('');
  S.Add('[COVERAGES]');
  Line := ';;Subcatchment  ' + Tab + 'Land Use        ' + Tab + 'Percent   ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------------' + Tab + '----------';
  S.Add(Line);
  for I := 0 to Project.Lists[SUBCATCH].Count-1 do
  begin
    C := Project.GetSubcatch(SUBCATCH, I);
    for J := 0 to C.Landuses.Count-1 do
    begin
      Line := Format('%-16s', [C.ID]);
      Line := Line + Tab + Format('%-16s', [C.Landuses.Names[J]]);
      Line := Line + Tab + Format('%-10s', [C.Landuses.ValueFromIndex[J]]);
      S.Add(Line);
    end;
  end;
end;


procedure ExportLoadings(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I, J: Integer;
  C:    TSubcatch;
  Line: String;
begin
  if Project.Lists[SUBCATCH].Count = 0 then exit;
  if Project.Lists[POLLUTANT].Count = 0 then exit;
  S.Add('');
  S.Add('[LOADINGS]');
  Line := ';;Subcatchment  ' + Tab + 'Pollutant       ' + Tab + 'InitLoad  ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------------' + Tab + '----------';
  S.Add(Line);
  for I := 0 to Project.Lists[SUBCATCH].Count-1 do
  begin
    C := Project.GetSubcatch(SUBCATCH, I);
    for J := 0 to C.Loadings.Count-1 do
    begin
      Line := Format('%-16s', [C.ID]);
      Line := Line + Tab + Format('%-16s', [C.Loadings.Names[J]]);
      Line := Line + Tab + Format('%-10s', [C.Loadings.ValueFromIndex[J]]);
      S.Add(Line);
    end;
  end;
end;


procedure ExportTreatment(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I, J   : Integer;
  K, N   : Integer;
  Pollut : String;
  Func   : String;
  Line   : String;
  aNode  : TNode;
begin
  if TreatCount = 0 then exit;
  S.Add('');
  S.Add('[TREATMENT]');
  Line := ';;Node          ' + Tab + 'Pollutant       ' + Tab + 'Function  ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------------' + Tab + '----------';
  S.Add(Line);
  for I := JUNCTION to STORAGE do
  begin
    N := Project.Lists[I].Count - 1;
    for J := 0 to N do
    begin
      aNode := Project.GetNode(I, J);
      with aNode.Treatment do
      begin
        for K := 0 to Count-1 do
        begin
          Func := ValueFromIndex[K];
          if Length(Func) = 0 then continue;
          Pollut := Names[K];
          Line := Format('%-16s',[aNode.ID]);
          Line := Line + Tab + Format('%-16s', [Pollut]);
          Line := Line + Tab + Format('%s', [Func]);
          S.Add(Line);
        end;
      end;
    end;
  end;
end;


procedure ExportInflows(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I, J   : Integer;
  K, M   : Integer;
  Line   : String;
  Param  : String;
  TS     : String;
  Slist  : TStringlist;
  aNode  : TNode;
begin

  if DXFCount = 0 then exit;
  Slist := TStringlist.Create;
  try
    S.Add('');
    S.Add('[INFLOWS]');
//    Line := ';;              ' + Tab + '                ' + Tab + '                ';
//    Line := Line + Tab + 'Param   ' + Tab + 'Units   ' + Tab + 'Scale   ';
//    Line := Line + Tab + 'Baseline' + Tab + 'Baseline';
//    S.Add(Line);
    Line := ';;Node          ' + Tab + 'Inflow          ' + Tab + 'Time Series     ';
    Line := Line + Tab + 'Type    ' + Tab + 'Funits  ' + Tab + 'Fscale  ';
    Line := Line + Tab + 'Baseline' + Tab + 'Pattern';
    S.Add(Line);
    Line := ';;--------------' + Tab + '----------------' + Tab + '----------------';
    Line := Line + Tab + '--------' + Tab + '--------' + Tab + '--------';
    Line := Line + Tab + '--------' + Tab + '--------';
    S.Add(Line);
    for I := JUNCTION to STORAGE do
    begin
      for J := 0 to Project.Lists[I].Count - 1 do
      begin
        aNode := Project.GetNode(I, J);
        with aNode.DXInflow do
        begin
          for K := 0 to Count-1 do
          begin
            Param := Names[K];
            Slist.Clear;
            Slist.SetText(PChar(ValueFromIndex[K]));
            TS := Slist[0];
            if Length(TS) = 0 then TS := '""';
            Line := Format('%-16s', [aNode.ID]);
            Line := Line + Tab + Format('%-16s', [Param]);
            Line := Line + Tab + Format('%-16s',[TS]);
            for M := 1 to Slist.Count-1 do
              Line := Line + Tab + Format('%-8s', [Slist[M]]);
            S.Add(Line);
          end;
        end;
      end;
    end;
  finally
    Slist.Free;
  end;
end;


procedure ExportDWflows(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I, J      : Integer;
  K, M      : Integer;
  Line      : String;
  Param     : String;
  Slist     : TStringlist;
  aNode     : TNode;
begin
  if DWFCount = 0 then exit;
  Slist := TStringlist.Create;
  try
    S.Add('');
    S.Add('[DWF]');
//    Line := ';;              ' + Tab + '                ' + Tab + 'Average   ';
//    Line := Line + Tab + 'Time      ';
//    S.Add(Line);
    Line := ';;Node          ' + Tab + 'Parameter       ' + Tab + 'BaseDWF   ';
    Line := Line + Tab + 'Patterns  ';
    S.Add(Line);
    Line := ';;--------------' + Tab + '----------------' + Tab + '----------';
    Line := Line + Tab + '----------';
    S.Add(Line);
    for I := JUNCTION to STORAGE do
    begin
      for J := 0 to Project.Lists[I].Count - 1 do
      begin
        aNode := Project.GetNode(I, J);
        with aNode.DWInflow do
        begin
          for K := 0 to Count-1 do
          begin
            Param := Names[K];
            Slist.Clear;
            Slist.SetText(PChar(ValueFromIndex[K]));
            Line := Format('%-16s', [aNode.ID]);
            Line := Line + Tab + Format('%-16s', [Param]);
            Line := Line + Tab + Format('%-10s', [Slist[0]]);
            for M := 1 to Slist.Count-1 do
              Line := Line + Tab + '"' + Trim(Slist[M]) + '"';
            S.Add(Line);
          end;
        end;
      end;
    end;
  finally
    Slist.Free;
  end;
end;


procedure ExportIIflows(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I, J, N   : Integer;
  Line      : String;
  aNode     : TNode;
begin
  if RDIICount = 0 then exit;
  S.Add('');
  S.Add('[RDII]');
  Line := ';;Node          ' + Tab + 'Unit Hydrograph ' + Tab + 'Sewer Area';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------------' + Tab + '----------';
  S.Add(Line);
  for I := JUNCTION to STORAGE do
  begin
    N := Project.Lists[I].Count - 1;
    for J := 0 to N do
    begin
      aNode := Project.GetNode(I, J);
      if aNode.IIInflow.Count >= 2 then
      begin
        Line := Format('%-16s', [aNode.ID]);
        Line := Line + Tab + Format('%-16s', [aNode.IIInflow[0]]);
        Line := Line + Tab + Format('%-10s', [aNode.IIInflow[1]]);
        S.Add(Line);
      end;
    end;
  end;
end;


procedure ExportPatterns(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I, J: Integer;
  K, K1, K2: Integer;
  Line: String;
  aPattern: TPattern;
begin
  if Project.Lists[PATTERN].Count = 0 then exit;
  S.Add('');
  S.Add('[PATTERNS]');
  Line := ';;Pattern       ' + Tab + 'Type      ' + Tab + 'Multipliers';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------' + Tab + '-----------';
  S.Add(Line);
  with Project.Lists[PATTERN] do
  begin
    for I := 0 to Count-1 do
    begin
      aPattern := TPattern(Objects[I]);
      ExportComment(S, aPattern.Comment);
      Line := Format('%-16s', [Strings[I]]);
      Line := Line + Tab + Format('%-10s', [PatternTypes[aPattern.PatternType]]);
      if aPattern.PatternType = PATTERN_DAILY then K := 7 else K := 6;
      K2 := K;
      for J := 0 to K2-1 do
        Line := Line + Tab + Format('%-5s', [aPattern.Data[J]]);
      S.Add(Line);
      while K2 < aPattern.Count do
      begin
        K1 := K2;
        K2 := K1 + K;
        if K2 > aPattern.Count then K2 := aPattern.Count;
        Line := Format('%-16s', [Strings[I]]) + Tab + '          ';
        for J := K1 to K2-1 do
          Line := Line + Tab + Format('%-5s', [aPattern.Data[J]]);
        S.Add(Line);
      end;
      if I < Count-1 then S.Add(';');
    end;
  end;
end;


procedure ExportTimeseries(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I, J, N : Integer;
  Name    : String;
  Fname   : String;
  Line    : String;
  Tseries : TTimeseries;
begin
  if Project.Lists[TIMESERIES].Count = 0 then exit;
  S.Add('');
  S.Add('[TIMESERIES]');
  Line := ';;Time Series   ' + Tab + 'Date      ' + Tab + 'Time      ' + Tab + 'Value     ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------' + Tab + '----------' + Tab + '----------';
  S.Add(Line);
  with Project.Lists[TIMESERIES] do
    for I := 0 to Count-1 do
    begin
      Name := Strings[I];
      Tseries := TTimeseries(Objects[I]);
      ExportComment(S, Tseries.Comment);
      if Length(Tseries.Filename) > 0 then
      begin
        Fname := Tseries.Filename;
        if ExtractFilePath(Fname) = ''  then
          Fname := ExtractFilePath(InputFileName) + Fname;
        if SameText(ExtractFilePath(Fname), SaveToPath)
        then Fname := ExtractFileName(Fname);
        Fname := '"' + Fname + '"';
        Line := Format('%-16s', [Name]) + Tab + 'FILE' + Tab + Fname;
        S.Add(Line);
      end
      else
      begin
        N := MinIntValue([Tseries.Times.Count, Tseries.Values.Count]);
        for J := 0 to N-1 do
        begin
          Line := Format('%-16s', [Name]);
          Line := Line + Tab + Format('%-10s', [Tseries.Dates[J]]);
          Line := Line + Tab + Format('%-10s', [Tseries.Times[J]]);
          Line := Line + Tab + Format('%-10s', [Tseries.Values[J]]);
          S.Add(Line);
        end;
      end;
      if I < Count-1 then S.Add(';');
    end;
end;


procedure ExportCurves(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I,J,K,N,M : Integer;
  Line    : String;
  Name    : String;
  aCurve  : TCurve;
begin
  if Project.GetCurveCount = 0 then exit;
  S.Add('');
  S.Add('[CURVES]');
  Line := ';;Curve         ' + Tab + 'Type      ' + Tab + 'X-Value   ' + Tab + 'Y-Value   ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------' + Tab + '----------' + Tab + '----------';
  S.Add(Line);
  M := 0;
  for I := 0 to MAXCLASS do
  begin
    if Project.IsCurve(I) then with Project.Lists[I] do
    begin
      for J := 0 to Count-1 do
      begin
        Name := Strings[J];
        aCurve := TCurve(Objects[J]);
        if M = 0 then M := 1 else S.Add(';');
        ExportComment(S, aCurve.Comment);
        N := MinIntValue([aCurve.Xdata.Count, aCurve.Ydata.Count]);
        if N > 0 then
        begin
          Line := Format('%-16s', [Name]) + Tab +
                  Format('%-10s', [aCurve.CurveType]) + Tab +
                  Format('%-10s', [aCurve.Xdata[0]]) + Tab +
                  Format('%-10s', [aCurve.Ydata[0]]);
          S.Add(Line);
          for K := 1 to N-1 do
          begin
            Line := Format('%-16s', [Name]) + Tab + '          ' + Tab +
                    Format('%-10s', [aCurve.Xdata[K]]) + Tab +
                    Format('%-10s', [aCurve.Ydata[K]]);
            S.Add(Line);
          end;
        end;
      end;
    end;
  end;
end;


procedure ExportControls(S: TStringlist);
//-----------------------------------------------------------------------------
begin
  if Project.ControlRules.Count = 0 then Exit;
  S.Add('');
  S.Add('[CONTROLS]');
  S.Add(';;Control Rules');
  S.AddStrings(Project.ControlRules);
end;


procedure ExportReport(S: TStringlist);
//-----------------------------------------------------------------------------
begin
  S.Add('');
  S.Add('[REPORT]');
  S.Add(';;Reporting Options');
  S.Add('INPUT     ' + Tab + Project.Options.Data[REPORT_INPUT_INDEX]);
  S.Add('CONTROLS  ' + Tab + Project.Options.Data[REPORT_CONTROLS_INDEX]);
  ReportingForm.Export(S, Tab);
end;


procedure ExportFiles(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I, N: Integer;
  Fname: String;
  Line: String;
  TokList : TStringlist;
  Ntoks   : Integer;
begin
  N := Project.IfaceFiles.Count;
  if N = 0 then Exit;
  S.Add('');
  S.Add('[FILES]');
  S.Add(';;Interfacing Files');
  TokList := TStringList.Create;
  try
    for I := 0 to N-1 do
    begin
      Uutils.Tokenize(Project.IfaceFiles[I], TokList, Ntoks);
      if Ntoks < 3 then continue;
      Fname := TokList[2];
      if SameText(SaveToPath, ExtractFilePath(Fname))
      then Fname := ExtractFileName(Fname);
      Line := TokList[0] + Tab + TokList[1] + Tab + '"' + Fname + '"';
      S.Add(Line);
    end;
  finally
    TokList.Free;
  end;
end;


procedure ExportProfiles(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I, M, N   : Integer;
  aID       : String;
  Line      : String;
  LinksList : TStringlist;
begin
  if Project.ProfileNames.Count = 0 then exit;
  if Uglobals.TabDelimited then Tab := #9 else Tab := ' ';
  S.Add('');
  S.Add('[PROFILES]');
  Line := ';;Name          ' + Tab + 'Links     ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------';
  S.Add(Line);
  LinksList := TStringlist.Create;
  with Project do
  try
    for I := 0 to ProfileNames.Count-1 do
    begin
      aID := ProfileNames[I];
      LinksList.Clear;
      LinksList.SetText(PChar(ProfileLinks[I]));
      N := LinksList.Count;
      M := 0;
      Line := '';
      while M < N do
      begin
        if (M mod 5) = 0 then
        begin
          if M > 0 then S.Add(Line);
          Line := Format('"%-16s"', [aID]);
        end;
        Line := Line + Tab + LinksList[M];
        Inc(M);
      end;
      S.Add(Line);
    end;
  finally
    LinksList.Free;
  end;
end;


procedure ExportTags(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I: Integer;
  J: Integer;
  Line: String;
begin
  if Uglobals.TabDelimited then Tab := #9 else Tab := ' ';
  S.Add('');
  S.Add('[TAGS]');
  for J := 0 to Project.Lists[RAINGAGE].Count-1 do
  begin
    with Project.Lists[RAINGAGE].Objects[J] as TRaingage do
      if Length(Data[TAG_INDEX]) > 0 then
      begin
        Line := 'Gage      ' + Tab + Format('%-16s', [ID]) + Tab +
                Format('%-16s',[Data[TAG_INDEX]]);
        S.Add(Line);
      end;
  end;
  for J := 0 to Project.Lists[SUBCATCH].Count-1 do
  begin
    with Project.Lists[SUBCATCH].Objects[J] as TSubcatch do
      if Length(Data[TAG_INDEX]) > 0 then
      begin
        Line := 'Subcatch  ' + Format('%-16s', [ID]) + Tab +
                Format('%-16s', [Data[TAG_INDEX]]);
        S.Add(Line);
      end;
  end;
  for I := JUNCTION to STORAGE do
  begin
    for J := 0 to Project.Lists[I].Count-1 do
    begin
      with Project.GetNode(I, J) do
        if Length(Data[TAG_INDEX]) > 0 then
        begin
          Line := 'Node      ' + Tab + Format('%-16s', [ID]) + Tab +
                  Format('%-16s', [Data[TAG_INDEX]]);
          S.Add(Line);
        end;
    end;
  end;
  for I := CONDUIT to OUTLET do
  begin
    for J := 0 to Project.Lists[I].Count-1 do
    begin
      with Project.GetLink(I, J) do
        if Length(Data[TAG_INDEX]) > 0 then
        begin
          Line := 'Link      ' + Tab + Format('%-16s', [ID]) + Tab +
                  Format('%-16s', [Data[TAG_INDEX]]);
          S.Add(Line);
        end;
    end;
  end;
end;


procedure ExportMap(S: TStringlist);
//-----------------------------------------------------------------------------
var
  I, J, N, D: Integer;
  aID       : String;
  Line      : String;
  Fmt       : String;
  TrueFalse : Integer;                                                          
  Slist     : TStringlist;
  aGage     : TRainGage;
  aNode     : TNode;
  aVertex   : PVertex;
  aMapLabel : TMapLabel;
begin
  // Export map's dimensions
  if Uglobals.TabDelimited then Tab := #9 else Tab := ' ';
  S.Add('');
  S.Add('[MAP]');
  with MapForm.Map.Dimensions do
  begin
    D := Digits;
    Fmt := '%-18.' + IntToStr(Digits) + 'f';
    Line := 'DIMENSIONS' + Tab +
            FloatToStrF(LowerLeft.X,ffFixed,18,D) + Tab +
            FloatToStrF(LowerLeft.Y,ffFixed,18,D) + Tab +
            FloatToStrF(UpperRight.X,ffFixed,18,D) + Tab +
            FloatToStrF(UpperRight.Y,ffFixed,18,D);
    S.Add(Line);
    Line := 'Units     ' + Tab + MapUnits[Ord(Units)];
    S.Add(Line);
  end;

  // Export nodal coordinates
  S.Add('');
  S.Add('[COORDINATES]');
  Line := ';;Node          ' + Tab + 'X-Coord           ' + Tab + 'Y-Coord           ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '------------------' + Tab + '------------------';
  S.Add(Line);
  for I := JUNCTION to STORAGE do
  begin
    Slist := Project.Lists[i];
    N := Slist.Count - 1;
    for J := 0 to N do
    begin
      aNode := Project.GetNode(I, J);
      with aNode do
        if (X <> MISSING) and (Y <> MISSING) then
        begin
          Line := Format('%-16s', [Slist[J]]) + Tab +
                  Format(Fmt, [X]) + Tab +
                  Format(Fmt, [Y]);
          S.Add(Line);
        end;
    end;
  end;
  S.Add('');

  // Export link vertex coordinates
  S.Add('[VERTICES]');
  Line := ';;Link          ' + Tab + 'X-Coord           ' + Tab + 'Y-Coord           ';
  S.Add(Line);
  Line := ';;--------------' + Tab + '------------------' + Tab + '------------------';
  S.Add(Line);
  for I := CONDUIT to OUTLET do
  begin
    Slist := Project.Lists[I];
    for J := 0 to Slist.Count - 1 do
    begin
      aVertex := Project.GetLink(I, J).Vlist.First;
      while aVertex <> nil do
      begin
        Line := Format('%-16s', [Slist[J]]) + Tab +
                Format(Fmt, [aVertex^.X]) + Tab +
                Format(Fmt, [aVertex^.Y]);
        S.Add(Line);
        aVertex := aVertex^.Next;
      end;
    end;
  end;
  S.Add('');

  // Export vertex coordinates of subcatchment polygons
  Slist := Project.Lists[SUBCATCH];
  N := Slist.Count - 1;
  if N >= 0 then
  begin
    S.Add('[Polygons]');
    Line := ';;Subcatchment  ' + Tab + 'X-Coord           ' + Tab + 'Y-Coord           ';
    S.Add(Line);
    Line := ';;--------------' + Tab + '------------------' + Tab + '------------------';
    S.Add(Line);
    for J := 0 to N do
    begin
      aVertex := Project.GetSubcatch(SUBCATCH, J).Vlist.First;
      while aVertex <> nil do
      begin
        Line := Format('%-16s', [Slist[J]]) + Tab +
                Format(Fmt, [aVertex^.X]) + Tab +
                Format(Fmt, [aVertex^.Y]);
        S.Add(Line);
        aVertex := aVertex^.Next;
      end;
    end;
    S.Add('');
  end;

  // Export rain gage coordinates
  Slist := Project.Lists[RAINGAGE];
  N := Slist.Count - 1;
  if N >= 0 then
  begin
    S.Add( '[SYMBOLS]');
    Line := ';;Gage          ' + Tab + 'X-Coord           ' + Tab + 'Y-Coord           ';
    S.Add(Line);
    Line := ';;--------------' + Tab + '------------------' + Tab + '------------------';
    S.Add(Line);
    for J := 0 to N do
    begin
      aGage := Project.GetGage(J);
      with aGage do
        if (X <> MISSING) and (Y <> MISSING) then
        begin
          Line := Format('%-16s', [Slist[J]]) + Tab +
                  Format(Fmt, [X]) + Tab +
                  Format(Fmt, [Y]);
          S.Add(Line);
        end;
    end;
    S.Add('');
  end;

  // Export map label coordinates
  Slist := Project.Lists[MAPLABEL];
  N := Slist.Count - 1;
  if N >= 0 then
  begin
    S.Add( '[LABELS]');
    Line := ';;X-Coord         ' + Tab + 'Y-Coord           ' + Tab + 'Label           ';
    S.Add(Line);
    for J := 0 to N do
    begin
      aMapLabel := Project.GetMapLabel(J);
      with aMapLabel do
      begin
        aID := '""';
        if Anchor <> nil then aID := Anchor.ID;
        Line := Format(Fmt, [X]) + Tab +
                Format(Fmt, [Y]) + Tab + '"' + Slist[J] + '"' +
                Tab + aID + Tab + '"' + FontName + '"' + Tab +
                Format('%d', [FontSize]);
        if FontBold then TrueFalse := 1 else TrueFalse := 0;
        Line := Line + Tab + IntToStr(TrueFalse);
        if FontItalic then TrueFalse := 1 else TrueFalse := 0;
        Line := Line + Tab + IntToStr(TrueFalse);
        S.Add(Line);
      end;
    end;
    S.Add('');
  end;

  // Export backdrop image information
  with MapForm.Map.Backdrop do
  begin
    if Length(Filename) > 0 then
    begin
      S.Add('');
      S.Add('[BACKDROP]');
      S.Add('FILE      ' + Tab + '"' + Filename + '"');
      Line := 'DIMENSIONS' + Tab +
              FloatToStrF(LowerLeft.X,ffFixed,18,D) + Tab +
              FloatToStrF(LowerLeft.Y,ffFixed,18,D) + Tab +
              FloatToStrF(UpperRight.X,ffFixed,18,D) + Tab +
              FloatToStrF(UpperRight.Y,ffFixed,18,D);
      S.Add(Line);
    end;
  end;

end;


procedure ExportTempDir(S: TStringlist);
//-----------------------------------------------------------------------------
begin
  if Uglobals.TabDelimited then Tab := #9 else Tab := ' ';
  S.Add('');
  S.Add('[OPTIONS]');
  S.Add('TEMPDIR   ' + Tab + '"' + TempDir + '"');
end;


procedure ExportProject(S: TStringlist);
//-----------------------------------------------------------------------------
begin
  if Uglobals.TabDelimited then Tab := #9 else Tab := ' ';
  DXFCount    := 0;
  DWFCount    := 0;
  RDIICount   := 0;
  TreatCount  := 0;

  ExportTitle(S);
  ExportOptions(S);
  ExportFiles(S);
  ExportEvaporation(S);
  ExportTemperature(S);
  ExportRaingages(S);
  ExportSubcatchments(S);
  ExportSubAreas(S);
  ExportInfiltration(S);
  Ulid.ExportLIDs(S, Tab);
  Ulid.ExportLIDGroups(S, Tab, SaveToPath);
  ExportAquifers(S);
  ExportGroundwater(S);
  ExportSnowpacks(S);

  //*****************************************************
  // These sections must be exported in the order as shown
  //******************************************************
  ExportJunctions(S);
  ExportOutfalls(S);
  ExportDividers(S);
  ExportStorage(S);
  ExportConduits(S);
  ExportPumps(S);
  ExportOrifices(S);
  ExportWeirs(S);
  ExportOutlets(S);
  //******************************************************

  ExportXsections(S);
  ExportTransects(S);
  ExportLosses(S);
  ExportControls(S);
  ExportPollutants(S);
  ExportLanduses(S);
  ExportCoverages(S);
  ExportLoadings(S);
  ExportBuildup(S);
  ExportWashoff(S);
  ExportTreatment(S);
  ExportInflows(S);
  ExportDWflows(S);
  ExportHydrographs(S);
  ExportIIflows(S);
  ExportCurves(S);
  ExportTimeseries(S);
  ExportPatterns(S);
  ExportReport(S);
end;


function SaveOutput(Fname: String): Boolean;
//-----------------------------------------------------------------------------
var
  F1: String;
  F2: String;
begin
  // Make sure that report & output file don't have same name as input file
  Result := False;
  F1 := ChangeFileExt(Fname, '.rpt');
  F2 := ChangeFileExt(Fname, '.out');
  if (SameText(F1, Fname)) or (SameText(F2, Fname)) then Exit;

  // Exit if current temporary files have same names as permanent ones
  if (SameText(F1, TempReportFile) and SameText(F2, TempOutputFile)) then
  begin
    Result := True;
    Exit;
  end;

  // Rename current temporary report file
  DeleteFile(PChar(F1));
  if not RenameFile(TempReportFile, F1) then Exit;

  // Close & rename current temporary output file
  Uoutput.CloseOutputFile;
  DeleteFile(PChar(F2));
  if not RenameFile(TempOutputFile, F2) then Exit;

  // Reopen output file & clear temporary file names
  Uoutput.OpenOutputFile(F2);
  TempReportFile := '';
  TempOutputFile := '';
  Result := True;
end;


procedure SaveProject(Fname: String);
//-----------------------------------------------------------------------------
var
  S: TStringlist;
begin
  SaveToPath := ExtractFilePath(Fname);
  S := TStringlist.Create;
  try
    ExportProject(S);
    S.AddStrings(Project.Options.Report);
    ExportTags(S);
    ExportMap(S);
    ExportProfiles(S);
    S.SaveToFile(Fname);
  finally
    S.Free;
  end;
  SaveToPath := '';
  if CompareText(ExtractFileExt(Fname), '.ini') <> 0
  then Uinifile.SaveProjIniFile(ChangeFileExt(Fname, '.ini'));
end;

procedure SaveResults(Fname: String);
//-----------------------------------------------------------------------------
begin
  Uglobals.ResultsSaved := SaveOutput(Fname);
  if CompareText(ExtractFileExt(Fname), '.ini') <> 0
  then Uinifile.SaveProjIniFile(ChangeFileExt(Fname, '.ini'));
end;

procedure SaveHotstartFile(Fname: String);
//-----------------------------------------------------------------------------
const
  //Conversion factors for CFS, GPM, MGD, CMS, LPS, & MLD to CFS
  QCFs: array[0..5] of Single =
    (1.0, 448.831, 0.64632, 0.02832, 28.317, 2.4466);
var
  F: File;
  I, J, K, N: Integer;
  P: Integer;
  V: Integer;
  X: Single;
  S: String;
  QCF: Single;
  LCF: Single;

begin
  // Open a binary output file
  AssignFile(F, Fname);
  try
    Rewrite(F, 1);

    // Determine flow (QCF) and length (LCF) conversion factors
    QCF := QCFs[Uglobals.Qunits];
    if Uglobals.Qunits > 2 then LCF := Uglobals.METERSperFOOT
    else LCF := 1.0;

    // Write title & number of components
    S := 'SWMM5-HOTSTART2';
    N := Length(S);
    for I := 1 to N do BlockWrite(F, S[I], 1);
    N := Project.Lists[SUBCATCH].Count;
    BlockWrite(F, N, SizeOf(N));
    N := Project.GetNodeCount;
    BlockWrite(F, N, SizeOf(N));
    N := Project.GetLinkCount;
    BlockWrite(F, N, SizeOf(N));
    N := Project.Lists[POLLUTANT].Count;
    BlockWrite(F, N, SizeOf(N));
    BlockWrite(F, Qunits, SizeOf(Qunits));

    // Write GW state for each subcatchment at current time period
    for J := 0 to Project.Lists[SUBCATCH].Count-1 do
    begin
      // Upper zone theta is not accessible so write missing value code
      X := MISSING;
      BlockWrite(F, X, SizeOf(X));

      // If no output results available water table elev = missing
      K := Project.GetSubcatch(SUBCATCH, J).Zindex;
      if K < 0 then X := MISSING

      // Otherwise retrieve water table elev. from output file
      else begin
        V := GetVarIndex(GW_ELEV, SUBCATCHMENTS);
        X := Uoutput.GetSubcatchOutVal(V, CurrentPeriod, K)/LCF;
      end;
      BlockWrite(F, X, SizeOf(X));
    end;

    // Write selected results for each node at current time period
    for I := 0 to MAXCLASS do
    begin
      if Project.IsNode(I) then for J := 0 to Project.Lists[I].Count-1 do
      begin

        // If no output results for node then write defaults to file
        K := Project.GetNode(I, J).Zindex;
        if K < 0 then
        begin
          X := 0.0;
          BlockWrite(F, X, SizeOf(X));
          BlockWrite(F, X, SizeOf(X));
          for P := 0 to N-1 do BlockWrite(F, X, SizeOf(X));
        end

        // Otherwise retrieve hotstart values from output file
        else
        begin

          // Write node depth to file
          V := GetVarIndex(NODEDEPTH, NODES);
          X := Uoutput.GetNodeOutVal(V, CurrentPeriod, K)/LCF;
          BlockWrite(F, X, SizeOf(X));

          // Write node lateral inflow to file
          V := GetVarIndex(LATFLOW, NODES);
          X := Uoutput.GetNodeOutVal(V, CurrentPeriod, K)/QCF;
          BlockWrite(F, X, SizeOf(X));

          // Write concen. of each pollutant to file
          for P := 0 to N-1 do
          begin
            if P < Npolluts then
            begin
              V := GetVarIndex(NODEQUAL+P, NODES);
              X := Uoutput.GetNodeOutVal(V, CurrentPeriod, K);
            end
            else X := 0.0;
            BlockWrite(F, X, SizeOf(X));
          end;
        end;

        // Write extra set of 0's for backwards compatibility
        X := 0.0;
        for P := 0 to N-1 do BlockWrite(F, X, SizeOf(X));
      end;
    end;

    // Write selected results for each link at current time period
    for I := 0 to MAXCLASS do
    begin
      if Project.IsLink(I) then for J := 0 to Project.Lists[I].Count-1 do
      begin

        // If no output results for link then write defaults to file
        K := Project.GetLink(I, J).Zindex;
        if K < 0 then
        begin
          X := 0.0;
          BlockWrite(F, X, SizeOf(X));
          BlockWrite(F, X, SizeOf(X));
          X := 1.0;
          BlockWrite(F, X, SizeOf(X));
          X := 0.0;
          for P := 0 to Npolluts-1 do BlockWrite(F, X, SizeOf(X));
        end

        // Otherwise retrieve hotstart values from output file
        else
        begin

          // Write flow to file
          V := GetVarIndex(FLOW, LINKS);
          X := Uoutput.GetLinkOutVal(V, CurrentPeriod, K)/QCF;
          BlockWrite(F, X, SizeOf(X));

          // Write flow depth to file
          V := GetVarIndex(LINKDEPTH, LINKS);
          X := Uoutput.GetLinkOutVal(V, CurrentPeriod, K)/LCF;
          BlockWrite(F, X, SizeOf(X));

          // Write control setting to file (assumed fixed at 1.0)
          X := 1.0;
          BlockWrite(F, X, SizeOf(X));

          // Write concen. of each pollutant to file
          for P := 0 to N-1 do
          begin
            if P < Npolluts then
            begin
              V := GetVarIndex(LINKQUAL+P, LINKS);
              X := Uoutput.GetLinkOutVal(V, CurrentPeriod, K);
            end
            else X := 0.0;
            BlockWrite(F, X, SizeOf(X));
          end;
        end;
      end;
    end;

  except
    on EInOutError do
      MessageDlg('I/O error writing to hotstart file.', mtError, [mbOK], 0);
  end;
  CloseFile(F);
end;

end.
