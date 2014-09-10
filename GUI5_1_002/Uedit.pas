unit Uedit;
        
{-------------------------------------------------------------------}
{                    Unit:    Uedit.pas                             }
{                    Project: EPA SWMM                              }
{                    Version: 5.1                                   }
{                    Date:    12/2/13      (5.1.000)                }
{                    Author:  L. Rossman                            }
{                                                                   }
{   Delphi Pascal unit that adds and edits objects in a SWMM        }
{   project's database.                                             }
{-------------------------------------------------------------------}

interface

uses SysUtils, Windows, Forms, Messages, Classes, Graphics,
     Controls, Dialogs, Uglobals, Uproject, Uutils, Uvertex;

procedure AddGage(const X: Extended; const Y: Extended);
procedure AddLabel(const X: Extended; const Y: Extended; const S: String);
procedure AddLink(const Ltype: Integer; Node1, Node2: TNode;
          PointList: array of TPoint; N: Integer); overload;  //PLRM modification added overload
procedure AddLink(const Ltype: Integer; Node1, Node2: TNode;
          PointList: array of TPoint; N: Integer; var ID: String); overload; //PLRM addition to add optional output
procedure AddNode(const Ntype: Integer; const X: Extended; const Y: Extended);
procedure AddObject(const ObjType: Integer);
procedure AddSubcatch(PointList: array of TPoint; N: Integer);

procedure EditComment(const Title: string; var S: String; var Modified: Boolean);
function  EditCurve(const ObjType: Integer; const Index: Integer): String;
procedure EditGroundwater(const Index: Integer; var S: String;
          var Modified: Boolean);
function  EditHydrograph(const Index: Integer): String;
procedure EditInfiltration(const Index: Integer; var Modified: Boolean);
procedure EditLabelFont(const Index: Integer; var Modified: Boolean);
procedure EditLoadings(const Index: Integer; var S: String;
          var Modified: Boolean);
procedure EditNodalInflows(const ObjType: Integer; const Index: Integer;
          var S: String; var Modified: Boolean);
procedure EditObject(const ObjType: Integer);
function  EditPattern(const I: Integer): String;
procedure EditRainFileName(const Index: Integer; var S: String;
          var Modified: Boolean);
function  EditSnowpack(const I: Integer): String;
procedure EditStorageInfil(const Index: Integer; var S: String;
          var Modified: Boolean);
procedure EditSubLanduses(const Index: Integer; var S: String;
          var Modified: Boolean);
function  EditTimeseries(const Index: Integer): String;
function  EditTransect(const I: Integer): String;
procedure EditTreatment(const ObjType: Integer; const Index: Integer;
          var S: String; var Modified: Boolean);
procedure EditXsection(const ObjType: Integer; const Index: Integer;
          var S: String; var Modified: Boolean);
procedure UpdateEditor(const ObjType: Integer; const Index: Integer);


implementation

uses
  Fmain, Fmap, Fproped, Dpollut, Dlanduse, Daquifer, Dinfil, Doptions, Dloads,
  Dtsect,  Dtseries, Dcurve, Dcontrol, Dsubland, Dpattern, Dxsect, Dgwater,
  Dinflows, Dclimate, Dsnow, Dnotes, Dunithyd, Dtreat, Ubrowser, Uoutput,
  Uupdate, Uvalidate, Dreporting, Ulid,                                               //(5.0.014 - LR)
  GSPLRM; //plrm

const
  TXT_VALUE = 'Value';
  TXT_LABEL_EDITOR = 'Label Editor';
  TXT_OPEN_RAIN_FILE = 'Open Rain Data File';
  TXT_RAIN_FILE_FILTER = 'Rain data files (*.DAT)|*.DAT|All files|*.*';
  TXT_RAIN_FILE_EXTEN = 'dat';
  MSG_NOPOLLUTS  = 'No pollutants have been defined yet for this project.';
  MSG_NOLANDUSES = 'No land uses have been defined yet for this project.';

procedure EditClimatology(const I: Integer); forward;
procedure EditPollutant(const I: Integer); forward;
procedure EditLanduse(const I: Integer); forward;
procedure EditAquifer(const I: Integer); forward;


//=============================================================================
//                      Object Addition Routines
//=============================================================================

procedure AddGage(const X: Extended; const Y: Extended);
//-----------------------------------------------------------------------------
// Adds a new rain gage object to the database.
//-----------------------------------------------------------------------------
var
  I  : Integer;
  ID : String;
  Rgage : TRaingage;
begin
  ID := Project.GetNextID(RAINGAGE);
  Rgage := TRaingage.Create;
  Rgage.X := X;
  Rgage.Y := Y;
  Uutils.CopyStringArray(Project.DefProp[RAINGAGE].Data, Rgage.Data);
  Project.Lists[RAINGAGE].AddObject(ID, Rgage);
  I := Project.Lists[RAINGAGE].Count - 1;
  Rgage.ID := PChar(Project.Lists[RAINGAGE].Strings[I]);
  MapForm.DrawObject(RAINGAGE, I);
  Ubrowser.BrowserAddItem(RAINGAGE, I);
end;


procedure AddSubcatch(PointList: array of TPoint; N: Integer);
//-----------------------------------------------------------------------------
// Adds a new subcatchment to the database.
//-----------------------------------------------------------------------------
var
  S      : TSubcatch;
  ID     : String;
  I      : Integer;
  J      : Integer;
  Vx, Vy : Extended;
begin
  // Get a default ID label for the subcatchment
  ID := Project.GetNextID(SUBCATCH);

  // Create a subcatchment object & add it to the Project
  S := TSubcatch.Create;
  Project.Lists[SUBCATCH].AddObject(ID, S);
  I := Project.Lists[SUBCATCH].Count - 1;
  S.ID := PChar(Project.Lists[SUBCATCH].Strings[I]);
  Uutils.CopyStringArray(Project.DefProp[SUBCATCH].Data, S.Data);

  //PLRM Edit - add catchment to PLRM Obj as well
  PLRMObj.addSubCatch(S,I);

  // Save the coordinates of the subcatchment's vertex points
  for J := N-1 downto 0 do
  begin
    Vx := MapForm.Map.GetX(PointList[J].X);
    Vy := MapForm.Map.GetY(PointList[J].Y);
    S.Vlist.Add(Vx, Vy);
  end;

  // Compute the subcatchment's centroid and bounding area
  S.SetCentroid;
  if Uglobals.AutoLength
  then S.Data[SUBCATCH_AREA_INDEX] := MapForm.Map.GetSubcatchAreaStr(I);

  // Assign the subcatchment a map color
  S.Zindex := -1;
  if (Uglobals.CurrentSubcatchVar = NOVIEW)
  or (CurrentSubcatchVar >= SUBCATCHOUTVAR1)
  then S.ColorIndex := -1
  else Uoutput.SetSubcatchColor(S,
    SubcatchVariable[Uglobals.CurrentSubcatchVar].SourceIndex);

  // Draw the subcatchment on the map and update the Data Browser
  // (must update map before Browser)
  MapForm.DrawObject(SUBCATCH, I);
  Ubrowser.BrowserAddItem(SUBCATCH, I);
end;


procedure AddLink(const Ltype: Integer; Node1, Node2: TNode;
  PointList: array of TPoint; N: Integer); overload;  //PLRM modified added overload, see below
//-----------------------------------------------------------------------------
// Adds a new link to the database.
//-----------------------------------------------------------------------------
var
  L  : TLink;
  I  : Integer;
  Vx,
  Vy: Extended;
  ID : String;
begin
  // Create the link object and assign default properties to it
  L := TLink.Create;
  Uutils.CopyStringArray(Project.DefProp[Ltype].Data, L.Data);
  L.Ltype := Ltype;

  // Assign end nodes to the link
  if (Node1 <> nil) and (Node2 <> nil) then
  begin
    L.Node1 := Node1;
    L.Node2 := Node2;
  end;

  // Save the coordinates of the link's vertex points
  for I := 1 to N do
  begin
    Vx := MapForm.Map.GetX(PointList[I].X);
    Vy := MapForm.Map.GetY(PointList[I].Y);
    L.Vlist.Add(Vx, Vy);
  end;

  // Initialize output result index and ID label
  L.Zindex := -1;
  ID := Project.GetNextID(Ltype);

  // Add the link to the list of the project's objects
  Project.Lists[Ltype].AddObject(ID, L);
  I := Project.Lists[Ltype].Count - 1;
  L.ID := PChar(Project.Lists[Ltype].Strings[I]);

  // Compute the link's length if AutoLength is on
  if (Ltype = CONDUIT) and Uglobals.AutoLength then
    L.Data[CONDUIT_LENGTH_INDEX] := MapForm.Map.GetLinkLengthStr(Ltype, I);

  // Assign the link a map color
  if (Uglobals.CurrentLinkVar = NOVIEW)
  or (Uglobals.CurrentLinkVar >= LINKOUTVAR1)
  then L.ColorIndex := -1
  else Uoutput.SetLinkColor(L,
    LinkVariable[Uglobals.CurrentLinkVar].SourceIndex);

  // Draw the link on the map and update the Data Browser
  // (must update map before Browser)
  MapForm.DrawObject(Ltype, I);
  Ubrowser.BrowserAddItem(Ltype, I);
end;

procedure AddLink(const Ltype: Integer; Node1, Node2: TNode;
  PointList: array of TPoint; N: Integer; var ID : String); overload;  //PLRM modified added overload
//-----------------------------------------------------------------------------
// Adds a new link to the database.
//-----------------------------------------------------------------------------
var
  L  : TLink;
  I  : Integer;
  Vx,
  Vy: Extended;
  //ID : String;     //PLRM modification
begin
  // Create the link object and assign default properties to it
  L := TLink.Create;
  Uutils.CopyStringArray(Project.DefProp[Ltype].Data, L.Data);
  L.Ltype := Ltype;

  // Assign end nodes to the link
  if (Node1 <> nil) and (Node2 <> nil) then
  begin
    L.Node1 := Node1;
    L.Node2 := Node2;
  end;

  // Save the coordinates of the link's vertex points
  for I := 1 to N do
  begin
    Vx := MapForm.Map.GetX(PointList[I].X);
    Vy := MapForm.Map.GetY(PointList[I].Y);
    L.Vlist.Add(Vx, Vy);
  end;

  // Initialize output result index and ID label
  L.Zindex := -1;
  ID := Project.GetNextID(Ltype);

  // Add the link to the list of the project's objects
  Project.Lists[Ltype].AddObject(ID, L);
  I := Project.Lists[Ltype].Count - 1;
  L.ID := PChar(Project.Lists[Ltype].Strings[I]);

  // Compute the link's length if AutoLength is on
  if (Ltype = CONDUIT) and Uglobals.AutoLength then
    L.Data[CONDUIT_LENGTH_INDEX] := MapForm.Map.GetLinkLengthStr(Ltype, I);

  // Assign the link a map color
  if (Uglobals.CurrentLinkVar = NOVIEW)
  or (Uglobals.CurrentLinkVar >= LINKOUTVAR1)
  then L.ColorIndex := -1
  else Uoutput.SetLinkColor(L,
    LinkVariable[Uglobals.CurrentLinkVar].SourceIndex);

  // Draw the link on the map and update the Data Browser
  // (must update map before Browser)
  MapForm.DrawObject(Ltype, I);
  Ubrowser.BrowserAddItem(Ltype, I);
end;

procedure AddNode(const Ntype: Integer; const X: Extended; const Y: Extended);
//-----------------------------------------------------------------------------
// Adds a new node to the database.
//-----------------------------------------------------------------------------
var
  I  : Integer;
  N  : TNode;
  ID : String;
begin
  // Get a default ID label for the node
  ID := Project.GetNextID(Ntype);

  // Create a Node with default properties
  N := TNode.Create;
  N.Ntype := Ntype;
  N.X := X;
  N.Y := Y;
  N.Zindex := -1;
  Uutils.CopyStringArray(Project.DefProp[Ntype].Data, N.Data);

  // Add the node to the list of the project's objects
  Project.Lists[Ntype].AddObject(ID, N);
  I := Project.Lists[Ntype].Count - 1;
  N.ID := PChar(Project.Lists[Ntype].Strings[I]);

  // Assign the node a map color
  N.ColorIndex := -1;
  if (Uglobals.CurrentNodeVar = NOVIEW)
  or (Uglobals.CurrentNodeVar >= NODEOUTVAR1)
  then N.ColorIndex := -1
  else Uoutput.SetNodeColor(N,
    NodeVariable[Uglobals.CurrentNodeVar].SourceIndex);

  //PLRM Addition
  PLRMObj.addNode(N,I);

  // Draw the node on map and update the Data Browser
  // (must update map before Browser)
  MapForm.DrawObject(Ntype, I);
  Ubrowser.BrowserAddItem(Ntype, I);
end;


procedure AddLabel(const X: Extended; const Y: Extended; const S: String);
//-----------------------------------------------------------------------------
// Adds a new map label to the database.
//-----------------------------------------------------------------------------
var
  I : Integer;
  L : TMapLabel;
begin
  L := TMapLabel.Create;
  L.X := X;
  L.Y := Y;
  Project.Lists[MAPLABEL].AddObject(S, L);
  I := Project.Lists[MAPLABEL].Count - 1;
  L.Text := PChar(Project.Lists[MAPLABEL].Strings[I]);
  MapForm.DrawObject(MAPLABEL, I);
  Ubrowser.BrowserAddItem(MAPLABEL, I);
end;


procedure AddObject(const ObjType: Integer);
//-----------------------------------------------------------------------------
// Adds a new object of type ObjType to the database.
//-----------------------------------------------------------------------------
//var
//  N1, N2: TNode;
//  A: array[0..0] of TPoint;
begin
  case ObjType of
    // For non-visual objects, call its editor with no reference
    // to any existing item
    POLLUTANT:     EditPollutant(-1);
    LANDUSE:       EditLanduse(-1);
    AQUIFER:       EditAquifer(-1);
    SNOWPACK:      EditSnowpack(-1);
    LID:           Ulid.EditLID(-1);
    CONTROLCURVE..
    TIDALCURVE:    EditCurve(ObjType, -1);
    TIMESERIES:    EditTimeseries(-1);
    HYDROGRAPH:    EditHydrograph(-1);
    PATTERN:       EditPattern(-1);
    TRANSECT:      EditTransect(-1);
  end;
end;


//=============================================================================
//                        Editing Routines
//=============================================================================

procedure EditLabel(const Index: Integer);
//-----------------------------------------------------------------------------
//  Edits a map label with position Index in list of labels.
//-----------------------------------------------------------------------------
var
  L : TMapLabel;
begin
  // Load current properties into the PropList stringlist
  with Project do
  begin
    L := GetMapLabel(Index);
    PropList.Clear;
    PropList.Add(GetID(MAPLABEL, Index));
    PropList.Add(Format('%.3f', [L.X]));
    PropList.Add(Format('%.3f', [L.Y]));
    if L.Anchor = nil then PropList.Add('')
    else PropList.Add(L.Anchor.ID);
    PropList.Add(L.FontName);
  end;

  // Update the Property Editor form
  PropEditForm.Caption := TXT_LABEL_EDITOR;
  PropEditForm.Editor.SetProps(LabelProps, Project.PropList);
end;


procedure GetLabelFont(const Index: Integer; F: TFont);
//-----------------------------------------------------------------------------
//  Assigns the font properties of a map label to a font object.
//-----------------------------------------------------------------------------
begin
  with Project.GetMapLabel(Index) do
  begin
    F.Name := FontName;
    F.Size := FontSize;
    F.Style := [];
    if FontBold then F.Style := F.Style + [fsBold];
    if FontItalic then F.Style := F.Style + [fsItalic];
  end;
end;


procedure EditLabelFont(const Index: Integer; var Modified: Boolean);
//-----------------------------------------------------------------------------
//  Edits the font for a map label using the MainForm's FontDialog control.
//-----------------------------------------------------------------------------
begin
  Modified := False;
  with MainForm.FontDialog do
  begin
    GetLabelFont(Index, Font);
    if Execute then
    begin
      MapForm.EraseLabel(Index);
      with Project.GetMapLabel(Index) do
      begin
        FontName := Font.Name;
        FontSize := Font.Size;
        if (fsBold in Font.Style) then FontBold := True
        else FontBold := False;
        if (fsItalic in Font.Style) then FontItalic := True
        else FontItalic := False;
      end;
      MapForm.DrawObject(MAPLABEL, Index);
      UpdateEditor(MAPLABEL, Project.CurrentItem[MAPLABEL]);
      Modified := True;
    end;
  end;
end;


procedure EditRaingage(const Index: Integer);
//-----------------------------------------------------------------------------
//  Edits a rain gage at position Index in the list of rain gages.
//-----------------------------------------------------------------------------
var
  I : Integer;
  G : TRaingage;
begin
  // Set the caption of the Property Editor window
  PropEditForm.Caption := ObjectLabels[RAINGAGE] + ' ' +
    Project.GetID(RAINGAGE, Index);

  // Get a pointer to the rain gage object
  G := Project.GetGage(Index);

  // Place current input data values in the PropList stringlist
  with Project do
  begin
    PropList.Clear;
    PropList.Add(G.ID);
    if G.X = MISSING then PropList.Add('')
    else PropList.Add(Format('%.3f', [G.X]));
    if G.Y = MISSING then PropList.Add('')
    else PropList.Add(Format('%.3f', [G.Y]));
    for I := COMMENT_INDEX to High(RaingageProps) do PropList.Add(G.Data[I]);
  end;

  // Update the Property Editor form
  RaingageProps[GAGE_SERIES_NAME].List := Project.Lists[TIMESERIES].Text;
  PropEditForm.Editor.SetProps(RaingageProps, Project.PropList);
end;


procedure EditSubcatch(const Index: Integer);
//-----------------------------------------------------------------------------
//  Edits a subcatchment at position Index in the list of subcatchments.
//-----------------------------------------------------------------------------
var
  S: TSubcatch;
  I: Integer;
  T: String;
begin
  // Set the caption of the Property Editor window
  PropEditForm.Caption := ObjectLabels[SUBCATCH] + ' '
    + Project.GetID(SUBCATCH, Index);

  // Get a pointer to the subcatchment object
  S := Project.GetSubcatch(SUBCATCH, Index);

  // Place current input data values in the PropList stringlist
  with Project do
  begin
    PropList.Clear;
    PropList.Add(S.ID);
    if S.X = MISSING then PropList.Add('')
    else PropList.Add(Format('%.3f', [S.X]));
    if S.Y = MISSING then PropList.Add('')
    else PropList.Add(Format('%.3f', [S.Y]));
    for I := COMMENT_INDEX to High(SubcatchProps) do PropList.Add(S.Data[I]);
    PropList.Strings[SUBCATCH_INFIL_INDEX] :=
      Project.Options.Data[INFILTRATION_INDEX];
    if S.Groundwater.Count > 0 then T := 'YES' else T := 'NO';
    PropList.Strings[SUBCATCH_GWATER_INDEX] := T;
    PropList.Strings[SUBCATCH_LID_INDEX] := IntToStr(S.LIDs.Count);
  end;

  // Update the Property Editor window
  SubcatchProps[SUBCATCH_RAINGAGE_INDEX].List := Project.Lists[RAINGAGE].Text;
  SubcatchProps[SUBCATCH_SNOWPACK_INDEX].List := Project.Lists[SNOWPACK].Text;
  PropEditForm.Editor.SetProps(SubcatchProps, Project.PropList);
end;


procedure EditNode(const Ntype: Integer; const Index: Integer);
//-----------------------------------------------------------------------------
//  Edits a node of type Ntype at position Index in the list of nodes.
//-----------------------------------------------------------------------------
var
  I         : Integer;
  LastIndex : Integer;
  N         : TNode;
begin
  // Set the caption of the Property Editor window
  PropEditForm.Caption := ObjectLabels[Ntype] + ' ' +
    Project.GetID(Ntype, Index);

  // Get a pointer to the node object
  N := Project.GetNode(Ntype, Index);

  // Place current input data values in the PropList stringlist
  with Project do
  begin
    PropList.Clear;
    PropList.Add(N.ID);
    if N.X = MISSING then PropList.Add('')
    else PropList.Add(Format('%.3f', [N.X]));
    if N.Y = MISSING then PropList.Add('')
    else PropList.Add(Format('%.3f', [N.Y]));

    case Ntype of
      JUNCTION:   LastIndex := High(JunctionProps);
      OUTFALL:    LastIndex := High(OutfallProps);
      DIVIDER:    LastIndex := High(DividerProps);
      STORAGE:    LastIndex := High(StorageProps);
      else        LastIndex := -1;
    end;
    for I := COMMENT_INDEX to LastIndex do PropList.Add(N.Data[I]);
  end;

  // Update the Property Editor window
  case Ntype of
    JUNCTION:
      PropEditForm.Editor.SetProps(JunctionProps, Project.PropList);
    OUTFALL:
      begin
        OutfallProps[OUTFALL_TIDE_TABLE_INDEX].List :=
          Project.Lists[TIDALCURVE].Text;
        OutfallProps[OUTFALL_TIME_SERIES_INDEX].List :=
          Project.Lists[TIMESERIES].Text;
        PropEditForm.Editor.SetProps(OutfallProps,  Project.PropList);
      end;
    DIVIDER:
      begin
        DividerProps[DIVIDER_TABLE_INDEX].List :=
          Project.Lists[DIVERSIONCURVE].Text;
        PropEditForm.Editor.SetProps(DividerProps,  Project.PropList);
      end;
    STORAGE:
      begin
        StorageProps[STORAGE_ATABLE_INDEX].List :=
          Project.Lists[STORAGECURVE].Text;
        PropEditForm.Editor.SetProps(StorageProps,  Project.PropList);
      end;
  end;
end;


procedure EditLink(const Ltype: Integer; const Index: Integer);
//-----------------------------------------------------------------------------
//  Edits a link of type Ltype at position Index in the list of links.
//-----------------------------------------------------------------------------
var
  I         : Integer;
  LastIndex : Integer;
  S         : String;
  L         : TLink;
begin
  // Set the caption of the Property Editor window
  S := Project.GetID(Ltype, Index);
  PropEditForm.Caption := ObjectLabels[Ltype] + ' ' + S;

  // Get a pointer to the link object
  L := Project.GetLink(Ltype, Index);

  // Place current data into the PropList stringlist
  with Project do
  begin
    PropList.Clear;
    PropList.Add(s);
    if L.Node1 = nil then PropList.Add('')
    else PropList.Add(L.Node1.ID);
    if L.Node2 = nil then PropList.Add('')
    else PropList.Add(L.Node2.ID);
    case Ltype of
      CONDUIT:    LastIndex := High(ConduitProps);
      PUMP:       LastIndex := High(PumpProps);
      ORIFICE:    LastIndex := High(OrificeProps);
      WEIR:       LastIndex := High(WeirProps);
      OUTLET:     LastIndex := High(OutletProps);
      else        LastIndex := -1;
    end;
    for I := 3 to LastIndex do PropList.Add(L.Data[I]);
  end;

  // Update the Property Editor form
  case Ltype of
    CONDUIT: PropEditForm.Editor.SetProps(ConduitProps, Project.PropList);
    PUMP:
      begin
        PumpProps[PUMP_CURVE_INDEX].List := Project.Lists[PUMPCURVE].Text;
        PropEditForm.Editor.SetProps(PumpProps, Project.PropList);
      end;
    ORIFICE: PropEditForm.Editor.SetProps(OrificeProps, Project.PropList);
    WEIR:    PropEditForm.Editor.SetProps(WeirProps, Project.PropList);
    OUTLET:
      begin
        OutletProps[OUTLET_QTABLE_INDEX].List := Project.Lists[RATINGCURVE].Text;
        PropEditForm.Editor.SetProps(OutletProps, Project.PropList);
      end;
  end;
end;


procedure EditNodalInflows(const ObjType: Integer; const Index: Integer;
  var S: String; var Modified: Boolean);
//-----------------------------------------------------------------------------
//  Edits nodal inflows for node of type ObjType with position Index.
//-----------------------------------------------------------------------------
var
  aNode: TNode;
  InflowsForm: TInflowsForm;
begin
  Modified := False;
  InflowsForm := TInflowsForm.Create(Application);
  with InflowsForm do
  try
    SetData(ObjType, Index);
    if ShowModal = mrOK then
    begin
      GetData(ObjType, Index);
      aNode := Project.GetNode(ObjType, Index);
      if aNode.DXInflow.Count > 0 then S := 'YES'
      else if aNode.DWInflow.Count > 0 then S := 'YES'
      else if aNode.IIInflow.Count > 0 then S := 'YES'
      else S := 'NO';
      aNode.Data[NODE_INFLOWS_INDEX] := S;
      Modified := HasChanged;
    end;
  finally
    Free;
  end;
end;


procedure EditTreatment(const ObjType: Integer; const Index: Integer;
  var S: String; var Modified: Boolean);
//-----------------------------------------------------------------------------
//  Edits pollutant treatment for node of type ObjType with position Index.
//-----------------------------------------------------------------------------
var
  aNode: TNode;
  TreatmentForm: TTreatmentForm;
begin
  Modified := False;
  if Project.Lists[POLLUTANT].Count = 0 then
  begin
    MessageDlg(MSG_NOPOLLUTS, mtINFORMATION, [mbOK], 0);
    exit;
  end;
  TreatmentForm := TTreatmentForm.Create(Application);
  with TreatmentForm do
  try
    SetData(ObjType, Index);
    if ShowModal = mrOK then
    begin
      GetData(ObjType, Index);
      aNode := Project.GetNode(ObjType, Index);
      if aNode.Treatment.Count > 0 then S := 'YES'
      else S := 'NO';
      aNode.Data[NODE_TREAT_INDEX] := S;
      Modified := HasChanged;
    end;
  finally
    Free;
  end;
end;


procedure EditXsection(const ObjType: Integer; const Index: Integer;
  var S: String; var Modified: Boolean);
//-----------------------------------------------------------------------------
// Edits cross section properties for object of type ObjType
// with position Index.
//-----------------------------------------------------------------------------
var
  aLink: TLink;
  XsectionForm: TXsectionForm;
begin
  Modified := False;
  if (ObjType = CONDUIT) then
  begin
    XsectionForm := TXsectionForm.Create(Application);
    with XsectionForm do
    try
      aLink := Project.GetLink(ObjType, Index);
      with aLink do
        SetData(Data[CONDUIT_SHAPE_INDEX], Data[CONDUIT_GEOM1_INDEX],
                Data[CONDUIT_GEOM2_INDEX], Data[CONDUIT_GEOM3_INDEX],
                Data[CONDUIT_GEOM4_INDEX], Data[CONDUIT_BARRELS_INDEX],
                Data[CONDUIT_TSECT_INDEX]);
      if ShowModal = mrOK then
      begin
        with aLink do
        begin
          GetData(Data[CONDUIT_SHAPE_INDEX], Data[CONDUIT_GEOM1_INDEX],
                  Data[CONDUIT_GEOM2_INDEX], Data[CONDUIT_GEOM3_INDEX],
                  Data[CONDUIT_GEOM4_INDEX], Data[CONDUIT_BARRELS_INDEX],
                  Data[CONDUIT_TSECT_INDEX]);
          S := Data[CONDUIT_SHAPE_INDEX];
          Uupdate.UpdateLinkColor(ObjType, Index, CONDUIT_GEOM1_INDEX);
        end;
        Modified := HasChanged;
        if Modified = True then EditLink(CONDUIT, Index);
      end;
    finally
      Free;
    end;
  end;
end;


procedure EditClimatology(const I: Integer);
//-----------------------------------------------------------------------------
//  Edits temperature, evaporation, wind speed, & snowmelt data.
//-----------------------------------------------------------------------------
var
  ClimatologyForm: TClimatologyForm;
begin
  ClimatologyForm := TClimatologyForm.Create(Application);
  with ClimatologyForm do
  try
    SetData(I);
    if ShowModal = mrOK then
    begin
      GetData;
      if HasChanged then MainForm.SetChangeFlags;
    end;
  finally
    Free;
  end;
end;


procedure EditPollutant(const I: Integer);
//-----------------------------------------------------------------------------
//  Edits existing Pollutant object with index I in data base
//  (or creates a new Pollutant object if index < 0).
//-----------------------------------------------------------------------------
var
  OldName : String;
  NewName : String;
  Pollut  : TPollutant;
  PollutantForm: TPollutantForm;
begin
  // If index >= 0 get corresponding Pollutant object
  if I >= 0 then
  begin
    Pollut := TPollutant(Project.Lists[POLLUTANT].Objects[I]);
    OldName := Project.Lists[POLLUTANT].Strings[I];
  end

  // Otherwise create a new Pollutant object
  else
  begin
    Pollut := TPollutant.Create;
    OldName := '';
  end;

  // Edit the pollutant's properties
  PollutantForm := TPollutantForm.Create(Application);
  with PollutantForm do
  try
    // Set properties in the Pollutant Editor form
    SetData(I, Pollut);

    // If valid pollutant data entered
    if (ShowModal = mrOK) and HasChanged then
    begin
      // Retrieve properties from form
      GetData(NewName, Pollut);

      // For new pollutant, add it to data base
      if I < 0 then
      begin
        Project.Lists[POLLUTANT].AddObject(NewName, Pollut);
        Ubrowser.BrowserAddItem(POLLUTANT, Project.Lists[POLLUTANT].Count-1);
      end

      // Otherwise for existing pollutant
      else
      begin
        // If name changed, then change all references to name in other objects
        if not SameText(OldName, NewName) then
        begin
          Uupdate.UpdatePollutName(OldName, NewName);
          Project.Lists[POLLUTANT].Strings[I] := NewName;
        end;

        // Update pollutant display in Browser panel
        Ubrowser.BrowserUpdate(POLLUTANT, I);
      end;
      MainForm.SetChangeFlags;
    end

    // If editing cancelled, then delete new pollutant if created
    else if I < 0 then Pollut.Free;
  finally
    Free;
  end;
end;


procedure EditLanduse(const I: Integer);
//-----------------------------------------------------------------------------
//  Edits existing Landuse object with index I in data base
//  (or creates a new Landuse object if index < 0).
//-----------------------------------------------------------------------------
var
  Item: Integer;
  OldName: String;
  NewName: String;
  LanduseForm: TLanduseForm;
begin
  if I >= 0 then OldName := Project.Lists[LANDUSE].Strings[I];
  LanduseForm := TLanduseForm.Create(Application);
  with LanduseForm do
  try
    SetData(I);
    if ShowModal = mrOK then
    begin
      GetData(I);
      if I < 0 then
      begin
        Item := Project.Lists[LANDUSE].Count - 1;
        Ubrowser.BrowserAddItem(LANDUSE, Item);
      end
      else
      begin
        NewName := Project.Lists[LANDUSE].Strings[I];
        if not SameText(OldName, NewName) then
          Uupdate.UpdateLanduseName(OldName, NewName);
        MainForm.ItemListBox.Refresh;
      end;
      if HasChanged then MainForm.SetChangeFlags;
    end;
  finally
    Free;
  end;
end;


procedure EditAquifer(const I: Integer);
//-----------------------------------------------------------------------------
//  Edits existing Aquifer object with index I in data base
//  (or creates a new Aquifer object if index < 0).
//-----------------------------------------------------------------------------
var
  OldName : String;
  NewName : String;
  A       : TAquifer;
  AquiferForm: TAquiferForm;
begin
  // If index >= 0 get corresponding Aquifer object
  if I >= 0 then with Project.Lists[AQUIFER] do
  begin
    A := TAquifer(Objects[I]);
    OldName := Strings[I];
  end

  // Otherwise create a new Aquifer object
  else
  begin
    A := TAquifer.Create;
    OldName := '';
  end;

  // Edit the aquifer's properties
  AquiferForm := TAquiferForm.Create(Application);
  with AquiferForm do
  try
    // Set properties in the Aquifer Editor form
    SetData(I, A);

    // If valid aquifer data entered
    if ShowModal = mrOK then
    begin
      // Retrieve properties from form
      GetData(NewName, A);

      // For new aquifer, add it to data base
      if I < 0 then
      begin
        Project.Lists[AQUIFER].AddObject(NewName, A);
        Ubrowser.BrowserAddItem(AQUIFER, Project.Lists[AQUIFER].Count-1);
      end

      // Otherwise for existing aquifer, simply update the Browser
      else
      begin
        if not SameText(OldName, NewName) then
        begin
          Uupdate.UpdateAquiferName(OldName, NewName);
          Project.Lists[AQUIFER].Strings[I] := NewName;
        end;
        Ubrowser.BrowserUpdate(AQUIFER, I);
      end;
      MainForm.SetChangeFlags;
    end

    // If editing cancelled, then delete new aquifer if created
    else if I < 0 then A.Free;
  finally
    Free;
  end;
end;


function EditSnowpack(const I: Integer): String;
//-----------------------------------------------------------------------------
//  Edits existing Snowpack object with index I in data base
//  (or creates a new Snowpack object if index < 0).
//-----------------------------------------------------------------------------
var
  OldName : String;
  NewName : String;
  SP : TSnowpack;
  SnowpackForm: TSnowpackForm;
begin
  // If index >= 0 get corresponding Snowpack object
  Result := '';
  if I >= 0 then with Project.Lists[SNOWPACK] do
  begin
    SP := TSnowpack(Objects[I]);
    OldName := Strings[I];
  end

  // Otherwise create a new Snowpack object
  else
  begin
    SP := TSnowpack.Create;
    OldName := '';
  end;

  // Edit the snow pack's properties
  SnowpackForm := TSnowpackForm.Create(Application);
  with SnowpackForm do
  try
    // Set properties in the Snowpack Editor form
    SetData(I, SP);

    // If valid snow pack data entered
    if ShowModal = mrOK then
    begin
      // Retrieve properties from form
      GetData(NewName, SP);
      Result := NewName;

      // For new snow pack, add it to data base
      if I < 0 then
      begin
        Project.Lists[SNOWPACK].AddObject(NewName, SP);
        Ubrowser.BrowserAddItem(SNOWPACK, Project.Lists[SNOWPACK].Count-1);
      end

      // Otherwise for existing snow pack, simply update the Browser
      else
      begin
        if not SameText(OldName, NewName) then
        begin
          Uupdate.UpdateSnowpackName(OldName, NewName);
          Project.Lists[SNOWPACK].Strings[I] := NewName;
        end;
        Ubrowser.BrowserUpdate(SNOWPACK, I);
      end;
      if Modified then MainForm.SetChangeFlags;
    end

    // If editing cancelled, then delete new snow pack if created
    else if I < 0 then SP.Free;
  finally
    Free;
  end;
end;


function EditTransect(const I: Integer): String;
//-----------------------------------------------------------------------------
//  Edits existing channel Transect object with index I in data base
//  (or creates a new Transect object if index < 0).
//-----------------------------------------------------------------------------
var
  Oldname : String;
  NewName : String;
  Tsect   : TTransect;
  TransectForm: TTransectForm;
begin
  // If index I >= 0 get corresponding Transect object
  Result := '';
  if I >= 0 then with Project.Lists[TRANSECT] do
  begin
    Tsect := TTransect(Objects[I]);
    OldName := Strings[I];
  end

  // Otherwise create a new Transect object
  else
  begin
    Tsect := TTransect.Create;
    OldName := '';
    Tsect.Data[TRANSECT_N_CHANNEL] :=
      Project.DefProp[CONDUIT].Data[CONDUIT_ROUGHNESS_INDEX];
    Tsect.Data[TRANSECT_N_LEFT] := Tsect.Data[TRANSECT_N_CHANNEL];
    Tsect.Data[TRANSECT_N_RIGHT] := Tsect.Data[TRANSECT_N_CHANNEL];
  end;

  // Create the transect editor form
  TransectForm := TTransectForm.Create(Application);
  with TransectForm do
  try
    // Set properties in the Transect Editor form
    SetData(I, OldName, Tsect);

    // If valid transect data entered
    if ShowModal = mrOK then
    begin
      // Retrieve properties from form
      GetData(NewName, Tsect);
      Result := NewName;

      // For new transect, add it to data base
      if I < 0 then
      begin
        Project.Lists[TRANSECT].AddObject(NewName, Tsect);
        Ubrowser.BrowserAddItem(TRANSECT, Project.Lists[TRANSECT].Count-1);
      end

      // For existing transect, update the Browser
      else
      begin
        if not SameText(OldName, NewName) then
        begin
          Uupdate.UpdateTransectName(OldName, NewName);
          Project.Lists[TRANSECT].Strings[I] := NewName;
        end;
        MainForm.ItemListBox.Refresh;
      end;
      if Modified then MainForm.SetChangeFlags;
    end

    // If editing cancelled, then delete new transect
    else if I < 0 then Tsect.Free;
  finally
    Free;
  end;
end;


function EditPattern(const I: Integer): String;
//-----------------------------------------------------------------------------
//  Edits existing Time Pattern object with index I in data base
//  (or creates a new Time Pattern object if index < 0).
//-----------------------------------------------------------------------------
var
  P : TPattern;
  OldName : String;
  NewName : String;
  PatternForm: TPatternForm;
begin
  // If index I >= 0 get corresponding Pattern object
  Result := '';
  if I >= 0 then with Project.Lists[PATTERN] do
  begin
    P := TPattern(Objects[I]);
    OldName := Strings[I];
  end

  // Otherwise create a new Pattern object
  else
  begin
    P := TPattern.Create;
    OldName := '';
  end;

  // Create the pattern editor form
  PatternForm := TPatternForm.Create(Application);
  with PatternForm do
  try
    SetData(I, P);
    if ShowModal = mrOK then
    begin
      GetData(NewName, P);

      // For new pattern, add it to data base
      Result := NewName;
      if I < 0 then
      begin
        Project.Lists[PATTERN].AddObject(NewName, P);
        Ubrowser.BrowserAddItem(PATTERN, Project.Lists[PATTERN].Count - 1);
      end

      // For existing pattern, update the Browser
      else
      begin
        if not SameText(OldName, Newname) then
        begin
          Uupdate.UpdatePatternName(OldName, NewName);
          Project.Lists[PATTERN].Strings[I] := NewName;
          MainForm.ItemListBox.Refresh;
        end;
      end;
      MainForm.SetChangeFlags;
    end

    // If editing cancelled, then delete new pattern
    else if I < 0 then P.Free;
  finally
    Free;
  end;
end;


procedure EditRainFileName(const Index: Integer; var S: String;
  var Modified: Boolean);
//-----------------------------------------------------------------------------
//  Gets the name of a rain gage's data file using the MainForm's
//  OpenTextFileDialog control.
//-----------------------------------------------------------------------------
var
  aGage: TRaingage;
begin
  aGage := Project.GetGage(Index);
  S := aGage.Data[GAGE_FILE_NAME];
  Modified := False;
  with MainForm.OpenTextFileDialog do
  begin
    Title := TXT_OPEN_RAIN_FILE;
    Filter := TXT_RAIN_FILE_FILTER;
    DefaultExt := TXT_RAIN_FILE_EXTEN;
    InitialDir := ExtractFileDir(S);
    if Length(InitialDir) = 0 then InitialDir := ProjectDir;
    if Length(S) > 0 then Filename := S
    else Filename := '*.' + DefaultExt;
    Options := Options + [ofFileMustExist];
    if Execute then
    begin
      if not SameText(S, Filename) then
      begin
        S := Filename;
        aGage.Data[GAGE_FILE_NAME] := Filename;
        Modified := True;
      end;
    end;
    DefaultExt := '';
  end;
end;


procedure EditInfiltration(const Index: Integer; var Modified: Boolean);
//-----------------------------------------------------------------------------
//  Edits infiltration data for a subcatchment.
//-----------------------------------------------------------------------------
var
  S: TSubcatch;
  InfilForm: TInfilForm;
begin
  Modified := False;
  InfilForm := TInfilForm.Create(Application);
  with InfilForm do
  try
    S := Project.GetSubcatch(SUBCATCH, Index);
    SetInfilModel(Project.Options.Data[INFILTRATION_INDEX]);
    SetData(S.InfilData, False);
    if ShowModal = mrOK then
    begin
      GetData(S.InfilData);
      Modified := HasChanged;
    end;
  finally
    Free;
  end;
end;


procedure EditStorageInfil(const Index: Integer; var S: String;
          var Modified: Boolean);
//-----------------------------------------------------------------------------
//  Edits infiltration data for a storage node.
//-----------------------------------------------------------------------------
var
  N: TNode;
  X: Single;
  InfilForm: TInfilForm;
begin
  Modified := False;
  InfilForm := TInfilForm.Create(Application);
  with InfilForm do
  try
    N := Project.GetNode(STORAGE, Index);
    SetInfilModel(InfilOptions[1]);
    SetData(N.InfilData, False);
    if ShowModal = mrOK then
    begin
      GetData(N.InfilData);
      Modified := HasChanged;
    end;
  finally
    Free;
  end;
  Uutils.GetSingle(N.InfilData[1], X);
  if (X > 0) then S := 'YES' else S := 'NO';
end;

procedure EditLoadings(const Index: Integer; var S: String;
  var Modified: Boolean);
//-----------------------------------------------------------------------------
//  Edits initial pollutant buildup for a subcatchment.
//-----------------------------------------------------------------------------
var
  K: Integer;
  C: TSubcatch;
  InitLoadingsForm: TInitLoadingsForm;
begin
  Modified := False;
  if Project.Lists[POLLUTANT].Count = 0 then
  begin
    MessageDlg(MSG_NOPOLLUTS, mtINFORMATION, [mbOK], 0);
    Exit;
  end;
  C := Project.GetSubcatch(SUBCATCH, Index);
  InitLoadingsForm := TInitLoadingsForm.Create(Application);
  with InitLoadingsForm do
  try
    SetData(C);
    if ShowModal = mrOK then
    begin
      GetData(C, K);
      if K > 0 then S := 'YES' else S := 'NO';
      C.Data[SUBCATCH_LOADING_INDEX] := S;
      Modified := HasChanged;
    end;
  finally
    Free;
  end;
end;


procedure EditSubLanduses(const Index: Integer; var S: String;
  var Modified: Boolean);
//-----------------------------------------------------------------------------
//  Edits assignment of landuses to a subcatchment.
//-----------------------------------------------------------------------------
var
  K: Integer;
  C: TSubcatch;
  SubLandusesForm: TSubLandusesForm;
begin
  Modified := False;
  if Project.Lists[LANDUSE].Count = 0 then
  begin
    MessageDlg(MSG_NOLANDUSES, mtINFORMATION, [mbOK], 0);
    Exit;
  end;
  C := Project.GetSubcatch(SUBCATCH, Index);
  SubLandusesForm := TSubLandusesForm.Create(Application);
  with SubLandusesForm do
  try
    SetData(C.Landuses);
    if ShowModal = mrOK then
    begin
      GetData(C.LandUses, K);
      S := IntToStr(K);
      C.Data[SUBCATCH_LANDUSE_INDEX] := S;
      Modified := HasChanged;
    end;
  finally
    Free;
  end;
end;


procedure EditGroundwater(const Index: Integer; var S: String;
  var Modified: Boolean);
//-----------------------------------------------------------------------------
//  Edits groundwater parameters for a subcatchment.
//-----------------------------------------------------------------------------
var
  C: TSubcatch;
  GroundWaterForm: TGroundWaterForm;
begin
  Modified := False;
  GroundWaterForm := TGroundWaterForm.Create(Application);
  with GroundWaterForm do
  try
    SetData(Index);
    if ShowModal = mrOK then
    begin
      GetData(Index);
      Modified := HasChanged;
    end;
  finally
    Free;
  end;
  C := Project.GetSubcatch(SUBCATCH, Index);
  if C.Groundwater.Count = 0 then S := 'NO' else S := 'YES';
end;


function EditTimeseries(const Index: Integer): String;
//-----------------------------------------------------------------------------
//  Edits data for a Time Series object.
//-----------------------------------------------------------------------------
var
  OldName : String;
  NewName : String;
  Series : TTimeseries;
  TimeseriesForm: TTimeseriesForm;
begin
  // If index >= 0 get corresponding time series object
  Result := '';
  if Index >= 0 then with Project.Lists[TIMESERIES] do
  begin
    Series := TTimeseries(Objects[Index]);
    OldName := Strings[Index];
  end

  // Otherwise create a new time series object
  else
  begin
    Series := TTimeseries.Create;
    OldName := '';
  end;

  TimeseriesForm := TTimeseriesForm.Create(Application);
  with TimeseriesForm do
  try
    SetData(Index, OldName, Series);
    if ShowModal = mrOK then
    begin
      GetData(Newname, Series);
      Result := NewName;

      // For new time series, add it to data base
      if Index < 0 then
      begin
        Project.Lists[TIMESERIES].AddObject(NewName, Series);
        Ubrowser.BrowserAddItem(TIMESERIES, Project.Lists[TIMESERIES].Count-1);
      end

      // For existing time series, update the Browser
      else
      begin
        // If name changed, then change all references to name in other objects
        if not SameText(OldName, NewName) then
        begin
          Uupdate.UpdateTseriesName(OldName, NewName);
          Project.Lists[TIMESERIES].Strings[Index] := NewName;
          MainForm.ItemListBox.Refresh;
        end;
      end;
      if Modified then MainForm.SetChangeFlags;
    end

    // If editing cancelled, then delete new timeseries
    else if Index < 0 then Series.Free;
  finally
    Free;
  end;
end;


function EditCurve(const ObjType: Integer; const Index: Integer): String;
//-----------------------------------------------------------------------------
//  Edits data for a Curve object.
//-----------------------------------------------------------------------------
var
  OldName : String;
  NewName : String;
  C : TCurve;
  CurveDataForm: TCurveDataForm;
begin
  // If index >= 0 get corresponding Curve object
  Result := '';
  if Index >= 0 then with Project.Lists[ObjType] do
  begin
    C := TCurve(Objects[Index]);
    OldName := Strings[Index];
  end

  // Otherwise create a new Curve object
  else
  begin
    C := TCurve.Create;
    OldName := '';
  end;

  CurveDataForm := TCurveDataForm.Create(Application);
  with CurveDataForm do
  try
    SetData(ObjType, Index, OldName, C);
    if ShowModal = mrOK then
    begin
      GetData(NewName, C);
      Result := NewName;

      // For new curve, add it to data base
      if Index < 0 then
      begin
        Project.Lists[ObjType].AddObject(NewName, C);
        Ubrowser.BrowserAddItem(ObjType, Project.Lists[ObjType].Count-1);
      end

      // For existing curve, update the Browser
      else
      begin
        // If name changed, then change all references to name in other objects
        if not SameText(OldName, NewName) then
        begin
          Uupdate.UpdateCurveName(OldName, NewName);
          Project.Lists[ObjType].Strings[Index] := NewName;
          MainForm.ItemListBox.Refresh;
        end;
      end;
      if Modified then MainForm.SetChangeFlags;
    end

    // If editing cancelled, then delete new curve
    else if Index < 0 then C.Free;
  finally
    Free;
  end;
end;


function EditHydrograph(const Index: Integer): String;
//-----------------------------------------------------------------------------
//  Edits data for an RDII Unit Hydrograph object.
//-----------------------------------------------------------------------------
var
  OldName : String;
  NewName : String;
  H : THydrograph;
  UnitHydForm : TUnitHydForm;
begin
  // If index >= 0 get corresponding Hydrograph object
  Result := '';
  if Index >= 0 then with Project.Lists[HYDROGRAPH] do
  begin
    H := THydrograph(Objects[Index]);
    OldName := Strings[Index];
  end

  // Otherwise create a new Hydrograph object
  else
  begin
    H := THydrograph.Create;
    OldName := '';
  end;

  UnitHydForm := TUnitHydForm.Create(Application);
  with UnitHydForm do
  try
    SetData(Index, H);
    if ShowModal = mrOK then
    begin
      GetData(NewName, H);
      Result := NewName;

      // For new hydrograph, add it to data base
      if Index < 0 then
      begin
        Project.Lists[HYDROGRAPH].AddObject(NewName, H);
        Ubrowser.BrowserAddItem(HYDROGRAPH, Project.Lists[HYDROGRAPH].Count-1);
      end

      // For existing hydrograph, update the Browser
      else
      begin
        if not SameText(OldName, NewName) then
        begin
          Uupdate.UpdateHydrographName(OldName, NewName);
          Project.Lists[HYDROGRAPH].Strings[Index] := NewName;
        end;
        MainForm.ItemListBox.Refresh;
      end;
      if Modified then MainForm.SetChangeFlags;
    end

    // If editing cancelled, then delete new hydrograph
    else if Index < 0 then H.Free;
  finally
    Free;
  end;
end;


procedure EditControls(const Index: Integer);
//-----------------------------------------------------------------------------
//  Edits rule-based controls.
//-----------------------------------------------------------------------------
var
  ControlsForm: TControlsForm;
begin
  ControlsForm := TControlsForm.Create(Application);
  with ControlsForm do
  try
    if Index >= 0 then FindRule(Project.Lists[CONTROL].Strings[Index]);
    if ShowModal = mrOK then
    begin
      Project.GetControlRuleNames;
      CurrentList := CONTROL;
      Ubrowser.BrowserUpdate(CONTROL, Project.CurrentItem[CONTROL]);
    end;
  finally
    Free;
  end;
end;


procedure EditOptions;
//-----------------------------------------------------------------------------
//  Edits analysis options.
//-----------------------------------------------------------------------------
var
  I: Integer;
  Updated: Boolean;
  AnalysisOptionsForm: TAnalysisOptionsForm;
begin
  Updated := False;
  I := Project.CurrentItem[OPTION];
  if SameText(Project.Lists[OPTION].Strings[I], 'Reporting') then
  begin
    ReportingForm.Show;
    Exit;
  end;

  if I < 0 then I := 0;
  AnalysisOptionsForm := TAnalysisOptionsForm.Create(Application);
  with AnalysisOptionsForm do
  try
    SetOptions(I);
    if ShowModal = mrOK then
    begin
      GetOptions;
      Updated := HasChanged;
    end;
  finally
    Free;
  end;
  if Updated then
  begin
    MainForm.SetChangeFlags;
  end;
end;


procedure EditNotes;
//-----------------------------------------------------------------------------
//  Edits project title/notes.
//-----------------------------------------------------------------------------
var
  NotesEditorForm: TNotesEditorForm;
begin
  NotesEditorForm := TNotesEditorForm.Create(Application);
  with NotesEditorForm do
  try
    setProjectNotes(Project.Lists[NOTES]);
    if (ShowModal = mrOK) and HasChanged then
    begin
      getProjectNotes(Project.Lists[NOTES]);
      Project.Title := '';
      Project.HasItems[NOTES] := False;
      if Project.Lists[NOTES].Count > 0 then
      begin
        Project.HasItems[NOTES] := True;
        Project.Title := Project.Lists[NOTES].Strings[0];
      end;
      Uglobals.HasChanged := True;
      with MainForm do
      begin
        with PageSetupDialog.Header do
          if Uglobals.TitleAsHeader
          then Text := Project.Title
          else Text := '';
        PageSetup;
      end;
      CurrentList := OPTION;
      Ubrowser.BrowserUpdate(NOTES, Project.CurrentItem[NOTES]);
    end;
  finally
    Free;
  end;
end;


procedure EditComment(const Title: string; var S: String; var Modified: Boolean);
//-----------------------------------------------------------------------------
//  Edits an object's Comment property.
//-----------------------------------------------------------------------------
var
  NotesEditorForm: TNotesEditorForm;
begin
  NotesEditorForm := TNotesEditorForm.Create(Application);
  with NotesEditorForm do
  try
    SetComment(Title, S);
    if ShowModal = mrOK then
    begin
      GetComment(S);
      Modified := HasChanged;
    end;
  finally
    Free;
  end;
end;


procedure EditObject(const ObjType: Integer);
//-----------------------------------------------------------------------------
//  Edits data for object of type ObjType.
//-----------------------------------------------------------------------------
begin
  // Save current object class index and item index in global variables
  EditorObject := ObjType;
  EditorIndex := Project.CurrentItem[ObjType];

  // Hide the Property Editor form if not applicable
  if not Project.IsVisual(ObjType) then PropEditForm.Hide;

  // Use appropriate editor for selected item
  case ObjType of

    // Use the Property Editor form for visual objects
    RAINGAGE..MAPLABEL:
    begin
      PropEditForm.Show;
      UpdateEditor(EditorObject, EditorIndex);
      PropEditForm.BringToFront;
      PropEditForm.Editor.Edit;
      //PLRM Edits
      PropEditForm.Hide;
      PLRMOBj.launchPropEditForm(EditorObject, EditorIndex);
    end;

    // Use specific dialog form editor for other objects
    NOTES:       EditNotes;
    CLIMATE:     EditClimatology(EditorIndex);
    POLLUTANT:   EditPollutant(EditorIndex);
    LANDUSE:     EditLanduse(EditorIndex);
    AQUIFER:     EditAquifer(EditorIndex);
    SNOWPACK:    EditSnowpack(EditorIndex);
    PATTERN:     EditPattern(EditorIndex);
    LID:         Ulid.EditLID(EditorIndex);
    CONTROLCURVE..
    TIDALCURVE:  EditCurve(ObjType, EditorIndex);
    TIMESERIES:  EditTimeseries(EditorIndex);
    HYDROGRAPH:  EditHydrograph(EditorIndex);
    TRANSECT:    EditTransect(EditorIndex);
    CONTROL:     EditControls(EditorIndex);
    OPTION:      EditOptions;
  end;
end;


procedure UpdateEditor(const ObjType: Integer; const Index: Integer);
//-----------------------------------------------------------------------------
//  Updates the contents of the Property Editor form for a specific object.
//-----------------------------------------------------------------------------
begin
  EditorObject := ObjType;
  EditorIndex := Index;
  with PropEditForm do
  begin
    if Visible then
    begin
      Editor.ColHeading2 := TXT_VALUE;
      case ObjType of
        RAINGAGE:               EditRaingage(Index);
        SUBCATCH:               EditSubcatch(Index);
        JUNCTION..STORAGE:      EditNode(ObjType,Index);
        CONDUIT..OUTLET:        EditLink(ObjType,Index);
        MAPLABEL:               EditLabel(Index);
      end;
    end;
  end;
end;

end.
