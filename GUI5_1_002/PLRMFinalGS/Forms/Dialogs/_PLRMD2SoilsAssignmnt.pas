unit _PLRMD2SoilsAssignmnt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, Grids, ComCtrls, GSUTils, GSIO, GSTypes, UProject, GSPLRM, GSCatchments;

type
  TPLRMD2SoilsAssignmnt = class(TForm)
    statBar: TStatusBar;
    btnOK: TButton;
    btnCancel: TButton;
    btnHelp: TButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label4: TLabel;
    sgMapUnit: TStringGrid;
    Image1: TImage;
    Label1: TLabel;
    Label3: TLabel;
    lbxMapUnitFrom: TListBox;
    btnToRight: TButton;
    btnToLeft: TButton;
    btnAllToRight: TButton;
    btnAllToLeft: TButton;
    lbxMapUnitTo: TListBox;
    cbxGlobalSpecfc: TComboBox;
    Label8: TLabel;
    Label5: TLabel;
    lblCatchArea: TLabel;
    btnApply: TButton;
    procedure FormCreate(Sender: TObject);
    procedure rePopulateForm(catch: TPLRMCatch);
    procedure btnToRightClick(Sender: TObject);
    procedure btnToLeftClick(Sender: TObject);
    procedure btnAllToRightClick(Sender: TObject);
    procedure btnAllToLeftClick(Sender: TObject);
    procedure sgMapUnitDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgMapUnitSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure sgMapUnitKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cbxGlobalSpecfcChange(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure sgMapUnitKeyPress(Sender: TObject; var Key: Char);
    procedure sgMapUnitSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
      
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  function getCatchSoilsInput(catchID : String): Integer;
var
  FrmSoils: TPLRMD2SoilsAssignmnt;
  catchArea: Double;
  curGridContents : String;
  initCatchID: String;
  prevGridVal:String;
implementation

{$R *.dfm}

procedure updateGrid(catchArea:Double; Grd:TStringGrid);
var
  R, lastRow: LongInt;
  acreSum, prcntSum: Double;
begin
  lastRow := Grd.RowCount -1;
  //R := 0;
  //C := 0;
  acreSum := 0;
  prcntSum := 0;
  for R := 1 to lastRow do
  begin
    //Sum up %catchment area values
      if Grd.Cells[1,R] = '' then
         Grd.Cells[1,R] := '0';
      prcntSum := prcntSum +  StrToFloat(Grd.Cells[1,R]);

      Grd.Cells[2,R] := FloatToStr((StrToFloat(Grd.Cells[1,R])/100) * catchArea);
      acreSum := acreSum +   (StrToFloat(Grd.Cells[2,R]));
  end;
  Grd.Cells[0,0] := 'Sub-totals';
  Grd.Cells[1,0] := FloatToStr(prcntSum);
  Grd.Cells[2,0] := FloatToStr(acreSum);
end;

procedure TPLRMD2SoilsAssignmnt.btnAllToLeftClick(Sender: TObject);
var I:integer;
begin
    for I := 0 to lbxMapUnitTo.Items.Count - 1 do
         GSUtils.deleteGridRow(lbxMapUnitTo.Items[I], 0,'0',sgMapUnit);
     GSUtils.TransferAllLstBxItems(lbxMapUnitFrom, lbxMapUnitTo);
     updateGrid(catchArea,sgMapUnit);
end;

procedure TPLRMD2SoilsAssignmnt.btnAllToRightClick(Sender: TObject);
var I:integer;
begin
    GSUtils.TransferAllLstBxItems(lbxMapUnitTo, lbxMapUnitFrom);
    for I := 0 to lbxMapUnitTo.Items.Count - 1 do
      if (GSUtils.gridContainsStr(lbxMapUnitTo.Items[I],0, sgMapUnit) = false) then
        GSUtils.AddGridRow(lbxMapUnitTo.Items[I], sgMapUnit,0);
    updateGrid(catchArea,sgMapUnit);
end;

procedure TPLRMD2SoilsAssignmnt.btnApplyClick(Sender: TObject);
begin
     GSPLRM.PLRMObj.currentCatchment.soilsMapUnitData := GSUtils.copyGridContents(0,1,GSPLRM.PLRMObj.currentCatchment.soilsMapUnitNames, sgMapUnit);
     GSPLRM.PLRMObj.currentCatchment.hasDefSoils := true;
end;

procedure TPLRMD2SoilsAssignmnt.btnToLeftClick(Sender: TObject);
var I:integer;
begin
    if (lbxMapUnitTo.SelCount = 0) then
  begin
    ShowMessage('Please select an item first and then click a button');
    Exit;
  end;

    for I := 0 to lbxMapUnitTo.Items.Count - 1 do
      if lbxMapUnitTo.Selected[I] then
         GSUtils.deleteGridRow(lbxMapUnitTo.Items[I], 0,'0',sgMapUnit);
    GSUtils.TransferLstBxItems(lbxMapUnitFrom, lbxMapUnitTo);
    updateGrid(catchArea,sgMapUnit);
end;

procedure TPLRMD2SoilsAssignmnt.btnToRightClick(Sender: TObject);
var I:integer;
begin

  if (lbxMapUnitFrom.SelCount = 0) then
  begin
    ShowMessage('Please select an item first and then click a button');
    Exit;
  end;

     GSUtils.TransferLstBxItems(lbxMapUnitTo, lbxMapUnitFrom);
     for I := 0 to lbxMapUnitTo.Items.Count - 1 do
      if (GSUtils.gridContainsStr(lbxMapUnitTo.Items[I],0, sgMapUnit) = false) then
        GSUtils.AddGridRow(lbxMapUnitTo.Items[I], sgMapUnit,0);
     //updateGrid(catchArea,sgMapUnit);
end;

procedure TPLRMD2SoilsAssignmnt.cbxGlobalSpecfcChange(Sender: TObject);
begin
   //set current catchment to the obj coresponding to selected value
    btnAllToLeftClick(Sender); //empty grid of previous land use selections
    PLRMObj.currentCatchment := GSUtils.getComboBoxSelValue2(Sender) as TPLRMCatch;
    catchArea := StrToFloat(PLRMobj.currentCatchment.swmmCatch.Data[UProject.SUBCATCH_AREA_INDEX]);
    lblCatchArea.Caption := 'Selected Catchment Area is: ' + PLRMobj.currentCatchment.swmmCatch.Data[UProject.SUBCATCH_AREA_INDEX] + ' ac';
    if PLRMObj.currentCatchment.hasDefSoils = true then
      repopulateForm(PLRMObj.currentCatchment);
end;

procedure TPLRMD2SoilsAssignmnt.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TPLRMD2SoilsAssignmnt.btnOKClick(Sender: TObject);
begin
  if sgMapUnit.Cells[1,0] <> '100' then
  begin
    ShowMessage('"% of Catchment Area" assignments in Column 1 of the grid must add up to 100%"');
    Exit;
  end;
  //check that first row does not contain blank landuse cell
  if (sgMapUnit.Cells[0,1] = '')then
  begin
    ShowMessage('"Please add at least one soil type to proceed"');
    Exit;
  end;
  btnApplyClick(Sender);
  ModalResult := mrOK;
end;

procedure TPLRMD2SoilsAssignmnt.FormCreate(Sender: TObject);
var
  S : TStringList;
  tempInt : Integer;
begin
  statBar.SimpleText := PLRMVERSION;
  Self.Caption := PLRMD2_TITLE;

  tempInt := PLRMObj.getCatchIndex(initCatchID);
  //comes before lookup of index because lookup updates catchID if changed
  cbxGlobalSpecfc.items := PLRMObj.catchments; // loads catchments into combo box
  cbxGlobalSpecfc.ItemIndex := tempInt;
  PLRMObj.currentCatchment := PLRMObj.catchments.Objects[tempInt] as TPLRMCatch;
  //catchArea := StrToFloat(PLRMobj.currentCatchment.swmmCatch.Data[UProject.SUBCATCH_AREA_INDEX]);
  catchArea := PLRMObj.currentCatchment.area;
  //lblCatchArea.Caption := 'Selected Catchment Area is: ' + PLRMobj.currentCatchment.swmmCatch.Data[UProject.SUBCATCH_AREA_INDEX] + ' ac';
  lblCatchArea.Caption := 'Catchment ID: ' + PLRMObj.currentCatchment.swmmCatch.ID + '   [ Area: ' + PLRMobj.currentCatchment.swmmCatch.Data[UProject.SUBCATCH_AREA_INDEX] + 'ac ]';

  S := GSIO.getMapUnitMuName();
  lbxMapUnitFrom.Items := S;
  sgMapUnit.ColWidths[0] := 400;
  if PLRMObj.currentCatchment.hasDefSoils = true then
    rePopulateForm(PLRMObj.currentCatchment);
end;

procedure TPLRMD2SoilsAssignmnt.rePopulateForm(catch: TPLRMCatch);
var I, tempInt:Integer;
begin
  if catch.soilsMapUnitNames <> nil then
  begin
    for I := 0 to catch.soilsMapUnitNames.Count - 1 do
    begin
       tempInt := lbxMapUnitFrom.Items.IndexOf(catch.soilsMapUnitNames[I]);
       if (tempInt > -1) then
       begin
        lbxMapUnitFrom.Selected[tempInt] :=true;
        btnToRightClick(TObject.Create);
       end;
    end;
    GSUtils.copyContentsToGridNChk(PLRMObj.currentCatchment.soilsMapUnitData,0,1,sgMapUnit);
    //updateGrid(catchArea,sgMapUnit);
    updateGrid(PLRMObj.currentCatchment.area,sgMapUnit);
  end;
end;

function getCatchSoilsInput(catchID: String): Integer;
  var
    tempInt : Integer;
  begin
    initCatchID := catchID;
    FrmSoils := TPLRMD2SoilsAssignmnt.Create(Application);
    try
      tempInt := FrmSoils.ShowModal;
      //if tempInt = mrOK then
      //begin
        Result := tempInt; //Result := FrmSoils
      //end;
    finally
      FrmSoils.Free;
    end;
end;

procedure TPLRMD2SoilsAssignmnt.sgMapUnitDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var S : String;
begin
  if ((ACol<>1) or (ARow = 0 ))then begin //or (ARow = 0 ))then begin
    sgMapUnit.Canvas.Brush.Color := cl3DLight;
    sgMapUnit.Canvas.FillRect(Rect);
    S := sgMapUnit.Cells[ACol, ARow];
    sgMapUnit.Canvas.Font.Color := clBlue;
    sgMapUnit.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure TPLRMD2SoilsAssignmnt.sgMapUnitKeyPress(Sender: TObject;
  var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMD2SoilsAssignmnt.sgMapUnitKeyUp(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
      updateGrid(catchArea,sgMapUnit);
end;

procedure TPLRMD2SoilsAssignmnt.sgMapUnitSelectCell(Sender: TObject; ACol, ARow: Integer;  var CanSelect: Boolean);
begin
  prevGridVal := sgMapUnit.Cells[ACol,ARow];
  if (ACol=0) or (ARow = 0 ) or (ACol = 2 )then
    begin
      sgMapUnit.Options:=sgMapUnit.Options-[goEditing];
    end
  else
  begin
    sgMapUnit.Options:=sgMapUnit.Options+[goEditing];
  end;
end;
procedure TPLRMD2SoilsAssignmnt.sgMapUnitSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
  if sgMapUnit.Cells[ACol,ARow] = '' then Exit;

  if ACol = 1 then
  begin
    if (StrToFloat(sgMapUnit.Cells[ACol,ARow]) > 100) then
    begin
       //ShowMessage('The values in this row must add up to 100%!');
       ShowMessage('Cell values must not exceed 100% and the sum of all the values in this column must add up to 100%!');
       sgMapUnit.Cells[ACol,ARow] := prevGridVal;
       updateGrid(catchArea,sgMapUnit);
       Exit;
    end;
    
  end;
end;

end.
