unit _PLRMD3CatchProps;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, jpeg, ExtCtrls, Grids, DBGrids, GSTypes,
  _PLRM5RoadDrnXtcs;

type
  TCatchProps = class(TForm)
    btnOk: TButton;
    GroupBox1: TGroupBox;
    Image1: TImage;
    statBar: TStatusBar;
    sgProps: TStringGrid;
    Label8: TLabel;
    cbxGlobalSpecfc: TComboBox;
    btnDefLuse: TButton;
    btnDefSoils: TButton;
    GroupBox2: TGroupBox;
    btnDefLuseConds: TButton;
    btnApply: TButton;
    Button5: TButton;
    Label1: TLabel;
    Label2: TLabel;
    cbxNode: TComboBox;
    edtCatchName: TEdit;
    GroupBox3: TGroupBox;
    Image2: TImage;
    btnDefHydProps: TButton;
    btnDefRoadPolls: TButton;
    btnShowRoadDrainageEditor: TButton;
    btnShowParcelDrainageAndBMPEditor: TButton;
    procedure FormCreate(Sender: TObject);
    procedure sgPropsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure btnDefLuseClick(Sender: TObject);
    procedure btnDefSoilsClick(Sender: TObject);
    procedure sgPropsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure btnDefLuseCondsClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure cbxGlobalSpecfcChange(Sender: TObject);
    procedure cbxNodeChange(Sender: TObject);
    procedure btnDefHydPropsClick(Sender: TObject);
    procedure sgPropsKeyPress(Sender: TObject; var Key: Char);
    procedure edtCatchNameKeyPress(Sender: TObject; var Key: Char);
    procedure edtCatchNameChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function checkDupCatchName(): Boolean;
    procedure edtCatchNameExit(Sender: TObject);
    procedure edtCatchNameEnter(Sender: TObject);
    procedure btnDefRoadPollsClick(Sender: TObject);
    procedure btnShowRoadDrainageEditorClick(Sender: TObject);
    procedure btnShowParcelDrainageAndBMPEditorClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure getCatchProps(catchID: String);

var
  CatchPropsFrm: TCatchProps;
  allDrxXtcs: TPLRMDrngXtcsData;
  currentCatchOrigName: string; // 2014 addtition used to update schemes

implementation

{$R *.dfm}

uses
  GSIO, GSUtils, GSPLRM, GSNodes, GSCatchments, UProject, UGlobals,
  Uvalidate, _PLRMD1LandUseAssignmnt2, _PLRMD4RoadPollutants,
  _PLRMD2SoilsAssignmnt, _PLRM3PSCDef, _PLRMD5RoadDrainageEditor,
  _PLRMD6ParcelDrainageAndBMPs,
  FPropEd, UBrowser;

procedure getCatchProps(catchID: String);
// var
// tempInt: Integer;
begin
  initCatchID := catchID;
  CatchPropsFrm := TCatchProps.Create(Application);
  try
    CatchPropsFrm.ShowModal;
  finally
    CatchPropsFrm.Free;
  end;
end;

procedure TCatchProps.btnDefHydPropsClick(Sender: TObject);
begin
  // check if soils info entered for current catchment and advance if true
  if PLRMObj.currentCatchment.hasDefSoils = true then
  begin
    PLRMObj.currentCatchment.soilsInfData :=
      GSIO.getSoilsProps(PLRMObj.currentCatchment.soilsMapUnitData);
    allDrxXtcs := getDrngCondsInput(cbxGlobalSpecfc.Text);
    PLRMObj.currentCatchment.hasDefDrnXtcs := true;
    // btnOk.Enabled := btnDefHydProps.Enabled;
  end
  else
    ShowMessage
      ('Please go back and provide soils data for current catchment to proceed beyond this point');
end;

procedure TCatchProps.btnDefLuseClick(Sender: TObject);
var
  tempInt: Integer;
  // msg: String;
begin
  { if btnDefHydProps.Enabled then
    begin
    msg := 'Warning!' + #13 + #13 +
    'Viewing or editing Land Uses will require you to reconfirm ' + #13 +
    'your Land Use Conditions (Step 4) and then reenter' + #13 +
    'Drainage Conditions (Step 5) for this catchment.' + #13 +
    'Do you want to proceed to the Land Use Editor (Step 2)?';
    buttonSelected := MessageDlg(msg, mtCustom, [mbYes, mbNo, mbCancel], 0);
    if buttonSelected <> mrYes then
    Exit;
    end; }
  btnApplyClick(Sender);
  tempInt := getCatchLuseInput(PLRMObj.currentCatchment.name);
  if tempInt = mrOK then
  begin
    btnDefSoils.Enabled := true;
    btnDefLuseConds.Enabled := false;
    btnDefHydProps.Enabled := false;
    btnOk.Enabled := false;
    Self.btnDefSoilsClick(Sender);
  end;
  // if tempInt = mrOK then btnDefSoils.Enabled := true;
  // btnDefHydProps.Enabled := PLRMObj.currentCatchment.hasDefDrnXtcs;
  // btnOk.Enabled :=
end;

procedure TCatchProps.btnDefLuseCondsClick(Sender: TObject);
begin
  btnApplyClick(Sender);
  if (PLRMObj.currentCatchment.hasDefLuse = false) then
  begin
    ShowMessage('Please provide land use information first');
    Exit;
  end;
  getSCandDrngXtrstcsInput(PLRMObj.currentCatchment.name);
  btnDefHydProps.Enabled := true;
  btnOk.Enabled := false;
  btnDefHydPropsClick(Sender);
end;

procedure TCatchProps.btnDefRoadPollsClick(Sender: TObject);
var
  tempInt: Integer;
  // msg: String;
begin
  btnApplyClick(Sender);
  tempInt := showRoadPollutantsDialog(PLRMObj.currentCatchment.name);
  if tempInt = mrOK then
  begin
    // btnOk.Enabled := true;
    Self.btnShowRoadDrainageEditorClick(Sender);
    btnShowRoadDrainageEditor.Enabled := true;
  end;
end;

procedure TCatchProps.btnDefSoilsClick(Sender: TObject);
var
  tempInt: Integer;
  // msg: String;
begin
  // 2014 addition to warn user that ksat values will be overwritten
  { if btnDefHydProps.Enabled then
    begin
    msg := 'Warning!' + #13 + #13 +
    'Viewing or editing soils will ovewrite any custom ' + #13 +
    'Green-Ampt infiltration parameters you may have' + #13 +
    'previously entered.' + #13 + #13 +
    'Do you want to proceed to the Soils Editor (Step 5)?';
    buttonSelected := MessageDlg(msg, mtCustom, [mbYes, mbNo, mbCancel], 0);
    if buttonSelected <> mrYes then
    Exit;
    end; }

  btnApplyClick(Sender);
  tempInt := getCatchSoilsInput(PLRMObj.currentCatchment.name);
  if tempInt = mrOK then
  begin
    // btnDefLuseConds.Enabled := true;
    btnDefRoadPolls.Enabled := true;
    btnDefRoadPollsClick(Sender);
    // btnDefLuseCondsClick(Sender);
  end;
  // btnOk.Enabled := btnDefHydProps.Enabled;
end;

procedure TCatchProps.btnOkClick(Sender: TObject);
begin
  btnApplyClick(Sender);
  // make sure GIS catchments are intialized only once when first loaded from xml
  PLRMObj.currentCatchment.isGISCatchment := false;
  ModalResult := mrOK;
end;

procedure TCatchProps.btnApplyClick(Sender: TObject);
// var
// tempInt :Integer;
begin

  with PLRMObj.currentCatchment do
  begin
    // order matters this block before next block
    // tempInt := cbxGlobalSpecfc.items.IndexOf(name);
    // if tempInt <> -1 then cbxGlobalSpecfc.items[tempInt] := edtCatchName.Text;
    // cbxGlobalSpecfc.ItemIndex := tempInt;
    PLRMObj.currentCatchment.area := StrToFloat(sgProps.Cells[1, 1]);
    physclProps := copyGridContents(0, 1, sgProps);
    hasPhysclProps := true;
    // outNodeID := cbxNode.Text;
    PLRMObj.updateCurCatchProps(name, edtCatchName.Text, physclProps, outNode);
  end;

end;

procedure TCatchProps.btnShowParcelDrainageAndBMPEditorClick(Sender: TObject);
var
  tempInt: Integer;
  // msg: String;
begin
  btnApplyClick(Sender);
  if (not(assigned(PLRMObj.currentCatchment.soilsInfData))) then
    PLRMObj.currentCatchment.soilsInfData :=
      GSIO.getSoilsProps(PLRMObj.currentCatchment.soilsMapUnitData);
  tempInt := showPLRMParcelDrngAndBMPsDialog(PLRMObj.currentCatchment.name);

  if tempInt = mrOK then
  begin
    btnOk.Enabled := true;
  end;

  // Reset property changed trackers
  PLRMObj.currentCatchment.hasChangedSoils := false;
end;

procedure TCatchProps.btnShowRoadDrainageEditorClick(Sender: TObject);
var
  tempInt: Integer;
  // msg: String;
begin
  btnApplyClick(Sender);
  if (not(assigned(PLRMObj.currentCatchment.soilsInfData))) then
    PLRMObj.currentCatchment.soilsInfData :=
      GSIO.getSoilsProps(PLRMObj.currentCatchment.soilsMapUnitData);
  tempInt := showRoadRoadDrainageEditorDialog(PLRMObj.currentCatchment.name);
  if tempInt = mrOK then
  begin
    Self.btnShowParcelDrainageAndBMPEditorClick(Sender);
    btnShowParcelDrainageAndBMPEditor.Enabled := true;
  end;
end;

procedure TCatchProps.Button5Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TCatchProps.cbxGlobalSpecfcChange(Sender: TObject);
var
  tempInt: Integer;
begin
  PLRMObj.currentCatchment := GSUtils.getComboBoxSelValue2(Sender)
    as TPLRMCatch;
  with PLRMObj.currentCatchment do
  begin
    edtCatchName.Text := name;
    copyContentsToGrid(physclProps, 0, 1, sgProps);
    // cbxNode.Text := outNodeID;
    if (assigned(outNode) and (outNode.userName <> '')) then
      cbxNode.Text := outNode.userName;

    btnDefLuse.Enabled := true; // always true
    btnDefSoils.Enabled := hasDefLuse; // only true if landuse info provided
    // btnDefLuseConds.Enabled := (hasDefSoils and hasDefLuse);

    tempInt := PLRMObj.catchments.IndexOf(name);
    BrowserUpdate(SUBCATCH, tempInt);
  end;
end;

procedure TCatchProps.cbxNodeChange(Sender: TObject);
var
  strVal: String;
  strErrVal: String;
begin
  PLRMObj.currentCatchment.outNode := GSUtils.getComboBoxSelValue2(Sender)
    as TPLRMNode;
  if assigned(PLRMObj.currentCatchment.outNode) then
    strVal := PLRMObj.currentCatchment.outNode.userName;
  // strVal := (GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode).userName;
  if strVal = '' then
    strVal := '*';
  // PLRMObj.currentCatchment.outNodeID := strVal;
  PropEditForm.Editor.PLRMEditProperty(1, 5, #13, strVal);
  // Edits the outlet entry in property editor grid
  ValidateEditor(6, strVal, strErrVal);
end;

function TCatchProps.checkDupCatchName(): Boolean;
var
  tempInt, I, J: Integer;
  strErrVal: String;
begin
  if PLRMObj.currentCatchment.name <> edtCatchName.Text then
  begin
    tempInt := PLRMObj.nodeAndCatchNames.IndexOf(edtCatchName.Text);
    if tempInt <> -1 then
    begin
      ShowMessage
        ('The object name you have provided is already in use. Please try another name');
      edtCatchName.Text := PLRMObj.currentCatchment.name;
      Result := false;
      Exit;
    end
    else
    begin

      tempInt := cbxGlobalSpecfc.items.IndexOf(PLRMObj.currentCatchment.name);
      if tempInt <> -1 then
      begin
        cbxGlobalSpecfc.items[tempInt] := edtCatchName.Text;
        cbxGlobalSpecfc.ItemIndex := tempInt;
      end;

      tempInt := PLRMObj.nodeAndCatchNames.IndexOf
        (PLRMObj.currentCatchment.name);
      PLRMObj.nodeAndCatchNames[tempInt] := edtCatchName.Text;

      tempInt := PLRMObj.catchments.IndexOf(PLRMObj.currentCatchment.name);
      PLRMObj.catchments[tempInt] := edtCatchName.Text;

      PLRMObj.currentCatchment.name := edtCatchName.Text;

      // change catchment names in road condition schemes
      if PLRMObj.currentCatchment.primRdRcSchm <> nil then
        PLRMObj.currentCatchment.primRdRcSchm.catchName := edtCatchName.Text;
      if PLRMObj.currentCatchment.secRdRcSchm <> nil then
        PLRMObj.currentCatchment.secRdRcSchm.catchName := edtCatchName.Text;
      // change catchment names in hyd prop schemes
      for I := 0 to High(PLRMObj.currentCatchment.catchHydPropSchemes) do
      begin
        for J := 0 to High(PLRMObj.currentCatchment.catchHydPropSchemes[I]) do
        begin
          if (PLRMObj.currentCatchment.catchHydPropSchemes[I][J] <> nil) then
            PLRMObj.currentCatchment.catchHydPropSchemes[I][J].catchName :=
              edtCatchName.Text;
        end;
      end;

      // update name in swmm
      EditorObject := SUBCATCH;
      // lets swmm functions know we are working with catchments
      EditorIndex := PLRMObj.currentCatchment.ObjIndex;
      tempInt := Project.Lists[SUBCATCH].IndexOf(edtCatchName.Text);
      if tempInt = -1 then
        Project.Lists[SUBCATCH][EditorIndex] := edtCatchName.Text;
      ValidateEditor(0, PLRMObj.currentCatchment.name, strErrVal);
    end;
  end;
  Result := true;
end;

procedure TCatchProps.edtCatchNameChange(Sender: TObject);
begin
  // checkDupCatchName();
end;

procedure TCatchProps.edtCatchNameEnter(Sender: TObject);
begin
  // 2014 set global currentCatchOrigName value so we can remember what the original name of
  // catchment was and use it to search and update schemes if the user changes it
  currentCatchOrigName := edtCatchName.Text;
end;

procedure TCatchProps.edtCatchNameExit(Sender: TObject);
var
  HydSchm: TPLRMHydPropsScheme; // 2014
  RdSchm: TPLRMRdCondsScheme; // 2014
  I: Integer;
begin
  checkDupCatchName();

  // 2014 when catchment name changes update hydProp schemes to reflect new catchment names
  if ((PLRMObj.hydPropsSchemes <> nil)) then
  begin
    for I := 0 to PLRMObj.hydPropsSchemes.Count - 1 do
    begin
      HydSchm := PLRMObj.hydPropsSchemes.Objects[I] as TPLRMHydPropsScheme;
      // if the catchment name for the scheme matches the old catchment name, update it
      if (HydSchm.catchName = currentCatchOrigName) then
        HydSchm.catchName := PLRMObj.currentCatchment.name;
    end;
  end;

  // 2014 when catchment name changes update rdCond schemes to reflect new catchment names
  if ((PLRMObj.rdCondsSchemes <> nil)) then
  begin
    for I := 0 to PLRMObj.rdCondsSchemes.Count - 1 do
    begin
      RdSchm := PLRMObj.rdCondsSchemes.Objects[I] as TPLRMRdCondsScheme;
      // if the catchment name for the scheme matches the old catchment name, update it
      if (RdSchm.catchName = currentCatchOrigName) then
        RdSchm.catchName := PLRMObj.currentCatchment.name;
    end;
  end;
end;

procedure TCatchProps.edtCatchNameKeyPress(Sender: TObject; var Key: Char);
begin
  gsEditKeyPressNoSpace(Sender, Key, gemPosNumber);
end;

procedure TCatchProps.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // FreeStringListObjects(cbxNode.items);
end;

procedure TCatchProps.FormCreate(Sender: TObject);
var
  tempInt: Integer;
  // flag: Boolean;
  data: PLRMGridData;
begin
  statBar.SimpleText := PLRMVERSION;
  Self.Caption := PLRMD0_TITLE;

  tempInt := PLRMObj.getCatchIndex(initCatchID);
  PLRMObj.currentCatchment := PLRMObj.catchments.Objects[tempInt] as TPLRMCatch;
  edtCatchName.Text := initCatchID;
  with PLRMObj.currentCatchment do
  begin
    // comes before lookup of index because lookup updates catchID if changed
    cbxGlobalSpecfc.items := PLRMObj.catchments;
    // loads catchments into combo box
    cbxGlobalSpecfc.ItemIndex := tempInt;

    cbxNode.Text := '';
    cbxNode.items := PLRMObj.getAllNodes; // PLRMObj.nodes;
    // tempInt := cbxNode.items.IndexOf(outNodeID);
    tempInt := -1;
    if outNode <> nil then
      tempInt := cbxNode.items.IndexOf(outNode.userName);
    if hasPhysclProps = true then
      if tempInt <> -1 then
      begin
        cbxNode.ItemIndex := tempInt;
      end;

    data := physclProps;
    copyContentsToGrid(data, 0, 1, sgProps);
    sgProps.Cells[0, 0] := 'Parameters';
    sgProps.Cells[1, 0] := 'Values';
    sgProps.Cells[2, 0] := 'Units';
    btnDefLuse.Enabled := true; // always true
    btnDefSoils.Enabled := hasDefLuse; // only true if landuse info provided
    // btnDefLuseConds.Enabled := (hasDefSoils and hasDefLuse);
    // btnDefHydProps.Enabled := (hasDefSoils and hasDefLuse and hasDefDrnXtcs);

    btnDefRoadPolls.Enabled := hasDefRoadPolls;
    btnShowRoadDrainageEditor.Enabled := hasDefRoadDrainage;
    btnShowParcelDrainageAndBMPEditor.Enabled := hasDefParcelAndDrainageBMPs;

    // btnOk.Enabled := btnDefHydProps.Enabled;
    btnOk.Enabled := btnShowParcelDrainageAndBMPEditor.Enabled;

    // for GIS catchments force user to cycle through catchment modules so that numbers
    // properly updated, especial soils properties, ksat, etc
    if PLRMObj.currentCatchment.isGISCatchment then
    begin
      btnDefSoils.Enabled := false;
      btnDefRoadPolls.Enabled := false;
      btnShowRoadDrainageEditor.Enabled := false;
      btnShowParcelDrainageAndBMPEditor.Enabled := false;
      btnOk.Enabled := false;
    end;
  end;
end;

procedure TCatchProps.sgPropsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  S: String;
begin
  if ((ACol = 0) or (ACol = 2) or (ARow = 0)) then
  begin // or (ARow = 0 ))then begin
    sgProps.Canvas.Brush.Color := cl3DLight;
    sgProps.Canvas.FillRect(Rect);
    S := sgProps.Cells[ACol, ARow];
    sgProps.Canvas.Font.Color := clBlue;
    sgProps.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure TCatchProps.sgPropsKeyPress(Sender: TObject; var Key: Char);
begin
  gsEditKeyPress(Sender, Key, gemPosNumber);
  // if any of the input changes invalidate and have user go back through forms
  btnDefLuse.Enabled := true; // always true
  btnDefSoils.Enabled := false;
  btnDefLuseConds.Enabled := false;
  btnDefHydProps.Enabled := false;
  btnDefRoadPolls.Enabled := false;
  btnShowRoadDrainageEditor.Enabled := false;
  btnShowParcelDrainageAndBMPEditor.Enabled := false;
  btnOk.Enabled := false;
end;

procedure TCatchProps.sgPropsSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  if ((ACol = 0) or (ACol = 2) or (ARow = 0)) then
  begin
    sgProps.Options := sgProps.Options - [goEditing];
    ShowMessage(CELLNOEDIT);
  end
  else
  begin
    sgProps.Options := sgProps.Options + [goEditing];
  end;
end;

end.
