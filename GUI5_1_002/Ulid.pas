unit Ulid;

{-------------------------------------------------------------------}
{                    Unit:    Ulid.pas                              }
{                    Project: EPA SWMM                              }
{                    Version: 5.1                                   }
{                    Date:    12/2/13     (5.1.000)                 }
{                    Author:  L. Rossman                            }
{                                                                   }
{   Delphi Pascal unit that manages data related to Low Impact      }
{   Development (LID) controls.                                     }
{-------------------------------------------------------------------}

interface

uses
  Classes, SysUtils, Controls, Uutils, Uproject, Uglobals, Dialogs;

const

  // LID Process Types
  BIO_CELL     = 0;
  RAIN_GARDEN  = 1;
  GREEN_ROOF   = 2;
  INFIL_TRENCH = 3;
  PERM_PAVE    = 4;
  RAIN_BARREL  = 5;
  VEG_SWALE    = 6;

  // LID Process Layers
  SURFACE_LAYER  = 0;
  PAVEMENT_LAYER = 1;
  SOIL_LAYER     = 2;
  STORAGE_LAYER  = 3;
  DRAIN_LAYER    = 4;
  DRAINMAT_LAYER = 5;

  // LID Unit Parameters
  UNIT_COUNT     = 0;
  UNIT_AREA      = 1;
  UNIT_WIDTH     = 2;
  INIT_MOISTURE  = 3;
  FROM_IMPERV    = 4;
  ROUTE_TO       = 5;
  RPT_FILE_NAME  = 6;
  RPT_FILE_PATH  = 7;
  MAX_LID_UNIT_PARAMS = 8;

  ProcessTypesLong: array[0..6] of String =
    ('Bio-Retention Cell', 'Rain Garden', 'Green Roof',
     'Infiltration Trench', 'Permeable Pavement',
     'Rain Barrel', 'Vegetative Swale');

  ProcessTypesMedium: array[0..6] of String =
    ('Bio-Retention', 'Rain Garden', 'Green Roof', 'Infil. Trench',
     'Perm. Pave', 'Rain Barrel', 'Veg. Swale');

  ProcessTypesShort: array[0..6] of String =
    ('BC', 'RG', 'GR', 'IT', 'PP', 'RB', 'VS');

  LayerTypes: array[0..5] of String =
    ('Surface', 'Pavement', 'Soil', 'Storage', 'Drain', 'DrainMat');

  DefSurfaceLayer: array[0..4] of String =
    ('0.0',        //Berm height
     '0.0',        //Vegetation Ratio
     '0.1',        //Roughness
     '1.0',        //Surface Slope
     '5');         //Side Slope

  DefPavementLayer: array[0..4] of String =
    ('4',          //Depth
     '0.15',       //Void Ratio
     '0',          //Impervious Ratio
     '100',        //Permeability
     '0');         //Clogging Factor

  DefSoilLayer: array[0..6] of String =
    ('12',         //Depth
     '0.5',        //Porosity
     '0.2',        //Field Capacity
     '0.1',        //Wilting Point
     '0.5',        //Sat. Hyd. Conductivity
     '10.0',       //Conductivity Coeff.
     '3.5');       //Suction Head

  DefStorageLayer: array[0..3] of String =
    ('12',         //Depth
     '0.75',       //Void Ratio
     '10',         //Conductivity
     '0');         //Clogging Factor

  DefDrainLayer: array[0..3] of String =
    ('0',          //Flow Coefficient
     '0.5',        //Flow Exponent
     '6',          //Drain Offset
     '6');         //Drain Delay

  DefDrainMatLayer: array[0..2] of String =
    ('3',          //Thickness
     '0.5',        //Void Fraction
     '0.1');       //Roughness

type

//----------
// LID class
//----------
  TLid = class(TObject)
    ProcessType  : Integer;
    SurfaceLayer : array [0..4] of String;
    PavementLayer: array [0..4] of String;
    SoilLayer    : array [0..6] of String;
    StorageLayer : array [0..3] of String;
    DrainLayer   : array [0..3] of String;
    DrainMatLayer: array [0..2] of String;
    constructor  Create;
  end;

//---------------
// LID Unit class
//---------------
  TLidUnit = class(TObject)
    Data: array[0..7] of String;
  end;

//------------------
// Shared procedures
//------------------
  function  EditLID(const I: Integer): String;
  procedure EditLIDGroup(const Index: Integer; var S: String; var Modified: Boolean);
  procedure ExportLIDs(S: TStringlist; const Tab: String);
  procedure ExportLIDGroups(S: TStringlist; const Tab: String;
            const SaveToPath: String);
  procedure FreeLIDUnits(LidUnits: TStringlist);
  function  GetPcntLidArea(I: Integer): Extended;
  function  GetPcntArea(Nunits: Integer; AreaStr: String): String;
  function  GetSubcatchArea: Extended;
  function  HasLIDType(SC: TSubcatch; const LIDType: Integer): Boolean;
  function  ReadLidData(TokList: TStringList; const Ntoks: Integer): Integer;
  function  ReadLidUsageData(theSubcatch: TSubcatch; TokList: TStringList;
            const Ntoks: Integer): Integer;
  procedure UpdateLIDName(const OldName: String; const NewName: String);

implementation

uses
  Ubrowser, Uupdate, Fmain, Dlid, Dlidgroup, Uimport;

//==============================================================================

constructor TLid.Create;
begin
  inherited Create;
  ProcessType := 0;
  Uutils.CopyStringArray(DefSurfaceLayer, SurfaceLayer);
  Uutils.CopyStringArray(DefPavementLayer, PavementLayer);
  Uutils.CopyStringArray(DefSoilLayer, SoilLayer);
  Uutils.CopyStringArray(DefStorageLayer, StorageLayer);
  Uutils.CopyStringArray(DefDrainLayer, DrainLayer);
  Uutils.CopyStringArray(DefDrainMatLayer, DrainMatLayer);
end;


function EditLID(const I: Integer): String;
//-----------------------------------------------------------------------------
//  Edits existing LID object with index I in data base
//  (or creates a new LID object if index < 0).
//-----------------------------------------------------------------------------
var
  OldName : String;
  NewName : String;
  theLID  : TLid;
  LidControlDlg: TLidControlDlg;
begin
  // If index >= 0 get corresponding LID object
  Result := '';
  if I >= 0 then with Project.Lists[LID] do
  begin
    theLID := TLid(Objects[I]);
    OldName := Strings[I];
  end

  // Otherwise create a new LID object
  else
  begin
    theLID := TLid.Create;
    OldName := '';
  end;

  // Edit the LID's properties
  LidControlDlg := TLidControlDlg.Create(Fmain.MainForm);
  with LidControlDlg do
  try
    // Set properties in the LID Editor form
    SetData(I, theLID);

    // If valid data entered
    if ShowModal = mrOK then
    begin
      // Retrieve properties from form
      GetData(NewName, theLID);
      Result := NewName;

      // For new LID, add it to data base
      if I < 0 then
      begin
        Project.Lists[LID].AddObject(NewName, theLID);
        Ubrowser.BrowserAddItem(LID, Project.Lists[LID].Count-1);
      end

      // Otherwise for existing LID, simply update the Browser
      else
      begin
        if not SameText(OldName, NewName) then
        begin
          UpdateLIDName(OldName, NewName);
          Project.Lists[LID].Strings[I] := NewName;
        end;
        Ubrowser.BrowserUpdate(LID, I);
      end;
      if Modified then MainForm.SetChangeFlags;
    end

    // If editing cancelled, then delete new LID if created
    else if I < 0 then theLID.Free;
  finally
    Free;
  end;
end;


procedure EditLIDGroup(const Index: Integer; var S: String;
  var Modified: Boolean);
//-----------------------------------------------------------------------------
//  Invokes the LID Group Editor form to edit LIDs in the current subcatchment
//-----------------------------------------------------------------------------
var
  theSubcatch: TSubcatch;
  LidGroupDlg: TLidGroupDlg;
begin
  theSubcatch := Project.GetSubcatch(SUBCATCH, Index);
  Modified := False;
  LidGroupDlg := TLidGroupDlg.Create(Fmain.MainForm);
  with LidGroupDlg do
  try
    // Set properties in the Editor form
    SetData(theSubcatch);

    // If valid data entered
    if ShowModal = mrOK then
    begin
      // Retrieve properties from form
      GetData(theSubcatch);
      Modified := HasChanged;
      S := IntToStr(theSubcatch.LIDs.Count);
    end;
  finally
    Free;
  end;
end;


procedure ExportLIDs(S: TStringlist; const Tab: String);
//-----------------------------------------------------------------------------
//  Writes LID controls data to the project's input data listing.
//-----------------------------------------------------------------------------
var
  I     : Integer;
  J     : Integer;
  Line  : String;
  theLID: TLid;
begin
  if Project.Lists[LID].Count = 0 then exit;
  S.Add('');
  S.Add('[LID_CONTROLS]');
  Line := ';;              ' + Tab + 'Type/Layer' + Tab + 'Parameters';
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------' + Tab + '----------';
  S.Add(Line);

  with Project.Lists[LID] do
  begin

    for I := 0 to Count-1 do
    begin
      if I > 0 then S.Add('');
      theLID := TLid(Objects[I]);
      Line := Format('%-16s',[Strings[I]]) + Tab +
        ProcessTypesShort[theLID.ProcessType];
      S.Add(Line);

      if theLID.ProcessType <> RAIN_BARREL then
      begin
        Line := Format('%-16s',[Strings[I]]) + Tab + 'SURFACE   ';
        for J := 0 to High(theLID.SurfaceLayer) do
          Line := Line + Tab + Format('%-10s',[theLID.SurfaceLayer[J]]);
        S.Add(Line);
      end;

      if theLID.ProcessType = PERM_PAVE then
      begin
        Line := Format('%-16s',[Strings[I]]) + Tab + 'PAVEMENT  ';
        for J := 0 to High(theLID.PavementLayer) do
          Line := Line + Tab + Format('%-10s',[theLID.PavementLayer[J]]);
        S.Add(Line);
      end;

      if (theLID.ProcessType = BIO_CELL) or
         (theLID.ProcessType = RAIN_GARDEN) or
         (theLID.ProcessType = GREEN_ROOF) then
      begin
        Line := Format('%-16s',[Strings[I]]) + Tab + 'SOIL      ';
        for J := 0 to High(theLID.SoilLayer) do
          Line := Line + Tab + Format('%-10s',[theLID.SoilLayer[J]]);
        S.Add(Line);
      end;

      if (theLID.ProcessType <> VEG_SWALE) and
         (theLID.ProcessType <> RAIN_GARDEN) and
         (theLID.ProcessType <> GREEN_ROOF) then
      begin
        Line := Format('%-16s',[Strings[I]]) + Tab + 'STORAGE   ';
        for J := 0 to High(theLID.StorageLayer) do
          Line := Line + Tab + Format('%-10s',[theLID.StorageLayer[J]]);
        S.Add(Line);
        Line := Format('%-16s',[Strings[I]]) + Tab + 'DRAIN     ';
        for J := 0 to High(theLID.DrainLayer) do
          Line := Line + Tab + Format('%-10s',[theLID.DrainLayer[J]]);
        S.Add(Line);
      end;

      if theLID.ProcessType = GREEN_ROOF then
      begin
        Line := Format('%-16s',[Strings[I]]) + Tab + 'DRAINMAT  ';
        for J := 0 to High(theLID.DrainMatLayer) do
           Line := Line + Tab + Format('%-10s',[theLID.DrainMatLayer[J]]);
        S.Add(Line);
      end;

    end;
  end;
end;


procedure ExportLIDGroups(S: TStringlist; const Tab: String;
    const SaveToPath: String);
//-----------------------------------------------------------------------------
//  Writes LID utilization data to the project's input data listing.
//-----------------------------------------------------------------------------
var
  I,J,K  : Integer;
  Line   : String;
  RptFile: String;
  theSubcatch: TSubcatch;
  LidList: TStringList;
  LidUnit: TLidUnit;
begin
  if (Project.Lists[SUBCATCH].Count = 0)
  or (Project.Lists[LID].Count = 0) then exit;

  S.Add('');
  S.Add('[LID_USAGE]');
  Line := ';;Subcatchment  ' + Tab + 'LID Process     ' + Tab;
  Line := Line + 'Number ' + Tab + 'Area      ' + Tab;
  Line := Line + 'Width     ' + Tab + 'InitSatur ' + Tab;
  Line := Line + 'FromImprv ' + Tab + 'ToPerv    ' + Tab;
  S.Add(Line);
  Line := ';;--------------' + Tab + '----------------' + Tab;
  Line := Line + '-------' + Tab + '----------' + Tab;
  Line := Line + '----------' + Tab + '----------' + Tab;
  Line := Line + '----------' + Tab + '----------' + Tab;
  S.Add(Line);

  with Project.Lists[SUBCATCH] do
  begin

    for I := 0 to Count-1 do
    begin
      theSubcatch := TSubcatch(Objects[I]);
      LidList := theSubcatch.LIDs;
      for J := 0 to LidList.Count-1 do
      begin
         Line := Format('%-16s',[Strings[I]]) + Tab + Format('%-16s',[LidList[J]]);
         LidUnit := TLidUnit(LidList.Objects[J]);
         Line := Line + Tab + Format('%-7s', [LidUnit.Data[0]]);
         for K := 1 to 5 do
           Line := Line + Tab + Format('%-10s',[LidUnit.Data[K]]);
         RptFile := Trim(LidUnit.Data[RPT_FILE_NAME]);
         if Length(RptFile) > 0 then
         begin
            RptFile := LidUnit.Data[RPT_FILE_PATH] + RptFile;
            if SameText(SaveToPath, ExtractFilePath(RptFile))
            then RptFile := ExtractFileName(RptFile);
            Line := Line + Tab + '"' + RptFile + '"';
         end;

         S.Add(Line);
      end;
    end;
  end;
end;


procedure FreeLIDUnits(LidUnits: TStringlist);
//-----------------------------------------------------------------------------
//  Frees all LID units in a group.
//-----------------------------------------------------------------------------
var
  I: Integer;
begin
  for I := 0 to LidUnits.Count-1 do
  begin
    TLidUnit(LidUnits.Objects[I]).Free;
  end;
  LidUnits.Clear;
end;


function GetPcntLidArea(I: Integer): Extended;
//-----------------------------------------------------------------------------
//  Finds percent of a subcatchment's area occupied by all LIDs.
//-----------------------------------------------------------------------------
var
  J            : Integer;
  S            : TSubcatch;
  LidList      : TStringList;
  LidUnit      : TLidUnit;
  LidArea      : Extended;
  Area         : Extended;
  ACF          : Extended;
begin
  if Uglobals.UnitSystem = Uglobals.usUS
  then ACF := 43560
  else ACF := 10000;
  try
    S := Project.GetSubcatch(SUBCATCH, I);
    Area := ACF * StrToFloat(S.Data[SUBCATCH_AREA_INDEX]);
    LidArea := 0;
    LidList := S.LIDs;
    for J := 0 to LidList.Count-1 do
    begin
      LidUnit := TLidUnit(LidList.Objects[J]);
      LidArea := LidArea + StrToFloat(LidUnit.Data[UNIT_COUNT]) *
                           StrToFloat(LidUnit.Data[UNIT_AREA]);
    end;
    if Area > 0 then Result := LidArea / Area * 100
    else if LidArea > 0 then Result := 100.0
    else Result := 0;
  except
    On EConvertError do Result := 0;
  end;
end;


function GetPcntArea(Nunits: Integer; AreaStr: String): String;
//-----------------------------------------------------------------------------
//  Finds percent of subcatchment area occupied by a single type of LID.
//-----------------------------------------------------------------------------
var
  A: Extended;               //Subcatchment area
  Alid: Extended;            //LID area
  PcntArea: Extended;        //% of subcatchment area occupied by the LID
  FmtStr: String;
begin
  try
    A := GetSubcatchArea;
    if A > 0 then
    begin
      Alid := StrToFloat(AreaStr) * Nunits;
      PcntArea :=  Alid / A * 100;
    end
    else PcntArea := 100.0;
    if PcntArea > 10 then FmtStr := '%0.1f' else FmtStr := '%0.3f';
    Result := Format(FmtStr, [PcntArea]);
  except
    On EConvertError do Result := 'N/A';
  end;
end;


function GetSubcatchArea: Extended;
//-----------------------------------------------------------------------------
//  Finds numeric area of currently selected subcatchment in sq ft or sq m.
//-----------------------------------------------------------------------------
var
  ACF: Extended;
  S: TSubcatch;
begin
  if Uglobals.UnitSystem = Uglobals.usUS
  then ACF := 43560
  else ACF := 10000;
  try
    S := Project.GetSubcatch(SUBCATCH, Project.CurrentItem[SUBCATCH]);
    Result := ACF * StrToFloat(S.Data[SUBCATCH_AREA_INDEX]);
  except
    On EConvertError do Result := 0;
  end;
end;


function HasLIDType(SC: TSubcatch; const LIDType: Integer): Boolean;
//-----------------------------------------------------------------------------
//  Checks if a subcatchment was assigned a specific type of LID process.
//-----------------------------------------------------------------------------
var
  I, J: Integer;
  LidList: TStringList;
begin
  Result := False;
  LidList := SC.LIDs;
  for J := 0 to LidList.Count-1 do
  begin
    I := Project.Lists[LID].IndexOf(LidList[J]);
    if I >= 0 then
    begin
      if LIDType = TLid(Project.Lists[LID].Objects[I]).ProcessType then
      begin
        Result := True;
        Exit;
      end;
    end;
  end;
end;


function ReadSurfaceData(TokList: TStringList; const Ntoks: Integer;
  theLID: TLid): Integer;
//-----------------------------------------------------------------------------
//  Reads Surface Layer data for an LID process from a tokenized line of input.
//-----------------------------------------------------------------------------
var
  I: Integer;
begin
  Result := 0;
  if Ntoks-2 <= High(DefSurfaceLayer)
  then Result := Uimport.ErrMsg(ITEMS_ERR, '')
  else for I := 0 to High(DefSurfaceLayer) do
    theLID.SurfaceLayer[I] := TokList[I+2];
end;


function ReadPavementData(TokList: TStringList; const Ntoks: Integer;
  theLID: TLid): Integer;
//-----------------------------------------------------------------------------
//  Reads Pavement Layer data for an LID process from a tokenized line of input.
//-----------------------------------------------------------------------------
var
  I: Integer;
begin
  Result := 0;
  if Ntoks-2 <= High(DefPavementLayer)
  then Result := Uimport.ErrMsg(ITEMS_ERR, '')
  else for I := 0 to High(DefPavementLayer) do
    theLID.PavementLayer[I] := TokList[I+2];
end;


function ReadSoilData(TokList: TStringList; const Ntoks: Integer;
  theLID: TLid): Integer;
//-----------------------------------------------------------------------------
//  Reads Soil Layer data for an LID process from a tokenized line of input.
//-----------------------------------------------------------------------------
var
  I: Integer;
begin
  Result := 0;
  if Ntoks-2 <= High(DefSoilLayer)
  then Result := Uimport.ErrMsg(ITEMS_ERR, '')
  else for I := 0 to High(DefSoilLayer) do
    theLID.SoilLayer[I] := TokList[I+2];
end;


function ReadStorageData(TokList: TStringList; const Ntoks: Integer;
  theLID: TLid): Integer;
//-----------------------------------------------------------------------------
//  Reads Storage Layer data for an LID process from a tokenized line of input.
//-----------------------------------------------------------------------------
var
  I: Integer;
begin
  Result := 0;
  if Ntoks-2 <= High(DefStorageLayer)
  then Result := Uimport.ErrMsg(ITEMS_ERR, '')
  else for I := 0 to High(DefStorageLayer) do
    theLID.StorageLayer[I] := TokList[I+2];
end;


function ReadDrainData(TokList: TStringList; const Ntoks: Integer;
  theLID: TLid): Integer;
//-----------------------------------------------------------------------------
//  Reads Underdrain data for an LID process from a tokenized line of input.
//-----------------------------------------------------------------------------
var
  I: Integer;
begin
  Result := 0;
  if Ntoks-2 <= High(DefDrainLayer)
  then Result := Uimport.ErrMsg(ITEMS_ERR, '')
  else for I := 0 to High(DefDrainLayer) do
    theLID.DrainLayer[I] := TokList[I+2];
end;


function ReadDrainMatData(TokList: TStringList; const Ntoks: Integer;
  theLID: TLid): Integer;
//-----------------------------------------------------------------------------
//  Reads Drainage Mat data for an LID process from a tokenized line of input.
//-----------------------------------------------------------------------------
var
  I: Integer;
begin
  Result := 0;
  if Ntoks-2 <= High(DefDrainMatLayer)
  then Result := Uimport.ErrMsg(ITEMS_ERR, '')
  else for I := 0 to High(DefDrainMatLayer) do
    theLID.DrainMatLayer[I] := TokList[I+2];
end;


function ReadLidData(TokList: TStringList; const Ntoks: Integer): Integer;
//-----------------------------------------------------------------------------
//  Reads a tokenized line of input for an LID process.
//-----------------------------------------------------------------------------
var
  I, J, K: Integer;
  theLID: TLid;
begin
//Check for start of new LID
  Result := 0;
  if Ntoks < 2 then Result := Uimport.ErrMsg(ITEMS_ERR, '')
  else if Ntoks = 2 then
  begin

  //Parse process type
    K := -1;
    for I := 0 to High(ProcessTypesShort) do
      if SameText(TokList[1], ProcessTypesShort[I]) then K := I;
    if K < 0 then
    begin
      Result := Uimport.ErrMsg(KEYWORD_ERR, TokList[1]);
      Exit;
    end;

  //Add LID to project
    theLID := TLid.Create;
    theLID.ProcessType := K;
    Project.Lists[LID].AddObject(TokList[0], theLID);
  end

//Process layer data
  else
  begin

  //Check that LID exists
    with Project.Lists[LID] do
    begin
      I := IndexOf(TokList[0]);
      if I < 0 then
      begin
        Result := Uimport.ErrMsg(LID_ERR, TokList[0]);
        Exit;
      end;
      theLID := TLID(Objects[I]);

    //Check for valid layer type
      K := -1;
      for J := 0 to High(LayerTypes) do
      if SameText(TokList[1], LayerTypes[J]) then K := J;
      if K < 0 then
      begin
        Result := Uimport.ErrMsg(KEYWORD_ERR, TokList[1]);
        Exit;
      end;

    //Parse parameter values
      case K of
      SURFACE_LAYER:  Result := ReadSurfaceData(TokList, Ntoks, theLID);
      PAVEMENT_LAYER: Result := ReadPavementData(TokList, Ntoks, theLID);
      SOIL_LAYER:     Result := ReadSoilData(TokList, Ntoks, theLID);
      STORAGE_LAYER:  Result := ReadStorageData(TokList, Ntoks, theLID);
      DRAIN_LAYER:    Result := ReadDrainData(TokList, Ntoks, theLID);
      DRAINMAT_LAYER: Result := ReadDrainMatData(TokList, Ntoks, theLID);       //(5.0.023)
      end;
    end;
  end;
end;


function ReadLidUsageData(theSubcatch: TSubcatch; TokList: TStringList;
                          const Ntoks: Integer): Integer;
//-----------------------------------------------------------------------------
//  Reads a tokenized line of LID usage data for a subcatchment.
//-----------------------------------------------------------------------------
var
  J: Integer;
  LidUnit: TLidUnit;
  FileName: String;
  FilePath: String;
begin
//Check for correct number of tokens
  Result := 0;
  if Ntoks < 8 then
  begin
    Result := Uimport.ErrMsg(ITEMS_ERR, '');
    Exit;
  end;

//Create a LID unit for the given subcatchment
  LidUnit := TLidUnit.Create;

//Add data to the LID unit
  for J := 0 to 5 do LidUnit.Data[J] := TokList[J+2];
  if Ntoks > 8 then
  begin
    FilePath := ExtractFilePath(TokList[8]);
    FileName := ExtractFileName(TokList[8]);
    if FilePath = ''
    then FilePath := ExtractFilePath(Uglobals.InputFileName);
    LidUnit.Data[RPT_FILE_NAME] := FileName;
    LidUnit.Data[RPT_FILE_PATH] := FilePath;
  end;

//Add the unit the to subcatchment's list of LIDs
  theSubcatch.LIDs.AddObject(TokList[1], LidUnit);
end;


procedure UpdateLIDName(const OldName: String; const NewName: String);
//-----------------------------------------------------------------------------
//  Replaces all references to LID OldName with NewName
//-----------------------------------------------------------------------------
var
  I,J: Integer;
  IsBlank: Boolean;
  LIDList: TStringList;
begin
  IsBlank := (Length(NewName) = 0);
  for J := 0 to Project.Lists[SUBCATCH].Count - 1 do
  begin
    LIDList := Project.GetSubcatch(SUBCATCH, J).LIDs;
    for I := LIDList.Count-1 downto 0 do
    begin
      if SameText(LIDList[I], OldName) then
      begin
        if IsBlank then
        begin
          TLidUnit(LIDList.Objects[I]).Free;
          LIDList.Delete(I);
        end
        else LIDList[I] := NewName;
      end;
    end;
  end;
end;

end.
