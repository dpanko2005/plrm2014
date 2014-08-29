unit _PLRMD4RoadPollutants;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Math,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg, Vcl.ComCtrls, GSTypes, GSUtils, GSPLRM, GSIO, GSCatchments,
  _PLRMD5RoadDrainageEditor, UProject;

const
  defaultPollutantCount = 6;
  crcParamCoeffColNum = 4;
  crcParamExponColNum = 5;
  defaultVisiblePollutantCount = 3;
  defaultCondScore = 2.5;
  lowCondScore = 0.1;
  highCondScore = 5.0;
  // extra 10 px so scroll bars not shown prematurely
  defaultMaxGridHeight = 150 + 10;

type
  TPLRMRoadPollutants = class(TForm)
    Image1: TImage;
    lblCatchArea: TLabel;
    lblCatchID: TLabel;
    Panel12: TPanel;
    Label21: TLabel;
    Panel1: TPanel;
    sgRoadShoulderPercents: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel2: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    sgRoadConditions: TStringGrid;
    Panel3: TPanel;
    Label11: TLabel;
    Panel4: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    sgCRCs: TStringGrid;
    Panel5: TPanel;
    Label10: TLabel;
    Label12: TLabel;
    btnOk: TButton;
    Button2: TButton;
    statBar: TStatusBar;
    lblRoadImpervAcres: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure restoreFormContents(catch: TPLRMCatch);
    procedure initFormContents(catch: String);
    procedure sgRoadShoulderPercentsDrawCell(Sender: TObject;
      ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgCRCsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure sgRoadConditionsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgRoadConditionsKeyPress(Sender: TObject; var Key: Char);
    procedure sgCRCsKeyPress(Sender: TObject; var Key: Char);
    procedure sgRoadShoulderPercentsKeyPress(Sender: TObject; var Key: Char);
    procedure sgRoadShoulderPercentsSetEditText(Sender: TObject;
      ACol, ARow: Integer; const Value: string);
    procedure sgRoadConditionsSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure sgRoadShoulderPercentsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOkClick(Sender: TObject);
    procedure sgRoadShoulderPercentsSelectCell(Sender: TObject;
      ACol, ARow: Integer; var CanSelect: Boolean);
    procedure sgRoadConditionsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sgRoadConditionsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure updateCRCs();

  private
    { Private declarations }
  public
    { Public declarations }
  end;

function showRoadPollutantsDialog(CatchID: String): Integer;
function calcCRCs(sgRdShoulders: TStringGrid; sgRdConditions: TStringGrid)
  : PLRMGridDataDbl;
function calcRoadShoulderConc(errodible: Double; protectd: Double;
  stable: Double; stableProtected: Double; crcParams: array of Double): Double;
function calcRoadConditionConc(coeff: Double; exponent: Double;
  conditionScore: Double): Double;
function calcRoadConditionConcs(iRow: Integer; crcParams: PLRMGridDataDbl;
  conditionScore: Double): PLRMGridDataDbl;
function calcRoadShoulderConcs(iRow: Integer; crcParams: PLRMGridDataDbl;
  errodible: Double; protectd: Double; stable: Double; stableProtected: Double)
  : PLRMGridDataDbl;

var
  PLRMRoadPollutants: TPLRMRoadPollutants;
  catchArea: Double;
  initCatchID: String;
  // sgs: array [0 .. 6] of TStringGrid;
  curAcVals: array [0 .. 6] of Double;
  curImpPrctVals: array [0 .. 6] of Double;
  prevGridValue: String;
  tblDbCRCParams: PLRMGridDataDbl;
  tblCRCsCalculated: PLRMGridData;

implementation

{$R *.dfm}

// calculate road shoulder concentrations based on road shoulder percentage assignment
function calcRoadShoulderConcs(iRow: Integer; crcParams: PLRMGridDataDbl;
  errodible: Double; protectd: Double; stable: Double; stableProtected: Double)
  : PLRMGridDataDbl;
var
  idx: Long;
  rslt: PLRMGridDataDbl;
begin
  SetLength(rslt, 1, High(crcParams[0]) + 1);
  for idx := 0 to High(crcParams[0]) do
  begin
    rslt[0, idx] := calcRoadShoulderConc(errodible, protectd, stable,
      stableProtected, crcParams[idx]);
  end;
  Result := rslt;
end;

function calcRoadShoulderConc(errodible: Double; protectd: Double;
  stable: Double; stableProtected: Double; crcParams: array of Double): Double;
//var
//  A, B, C, D: Double;
begin
  Result := (errodible * crcParams[0] + protectd * crcParams[1] + stable *
    crcParams[2] + stableProtected * crcParams[3]) / 100;
end;

// calculate road condition concentrations based on road travel lane risk score
function calcRoadConditionConcs(iRow: Integer; crcParams: PLRMGridDataDbl;
  conditionScore: Double): PLRMGridDataDbl;
var
  idx: Long;
  rslt: PLRMGridDataDbl;
begin
  SetLength(rslt, 1, defaultPollutantCount);
  for idx := 0 to defaultPollutantCount - 1 do
  begin
    rslt[0, idx] := calcRoadConditionConc(crcParams[idx, crcParamCoeffColNum],
      crcParams[idx, crcParamExponColNum], conditionScore);
  end;
  Result := rslt;
end;

// calculate road condition concentrations based on road travel lane risk score
function calcRoadConditionConc(coeff: Double; exponent: Double;
  conditionScore: Double): Double;
begin
  Result := coeff * Exp(conditionScore * exponent);
end;

// compute crcs based on road shoulder concs and road condition concs
function calcCRCs(sgRdShoulders: TStringGrid; sgRdConditions: TStringGrid)
  : PLRMGridDataDbl;
var
  lastRow, iRow, idx: longInt;
  rslts: PLRMGridDataDbl;
  rdCondScore, erodible, protectd, stable, stableProtected: Double;
  rdConditionConc, rdShoulderConc: PLRMGridDataDbl;
begin

  // road shoulder assignments
  erodible := StrToFloat(sgRdShoulders.Cells[0, 0]);
  protectd := StrToFloat(sgRdShoulders.Cells[1, 0]);
  stable := StrToFloat(sgRdShoulders.Cells[2, 0]);
  stableProtected := StrToFloat(sgRdShoulders.Cells[3, 0]);

  SetLength(rslts, sgRdConditions.RowCount, defaultPollutantCount);

  // subtracting 2 below because last row not populated shown to let user know grid will grow
  // as new rows are entered
  lastRow := sgRdConditions.RowCount - 1;
  for iRow := 0 to lastRow do
  begin
    if (sgRdConditions.Cells[1, iRow] <> '') then
    begin
      rdCondScore := StrToFloat(sgRdConditions.Cells[1, iRow]);
      rdShoulderConc := calcRoadShoulderConcs(iRow, tblDbCRCParams, erodible,
        protectd, stable, stableProtected);
      rdConditionConc := calcRoadConditionConcs(iRow, tblDbCRCParams,
        rdCondScore);

      for idx := 0 to defaultPollutantCount - 1 do
      begin
        rslts[iRow, idx] := rdShoulderConc[0, idx] + rdConditionConc[0, idx];
      end
    end;
  end;
  Result := rslts;
end;

// compute crcs based on road shoulder concs and road condition concs
procedure TPLRMRoadPollutants.updateCRCs();
var
  rslts: PLRMGridDataDbl;
  iRow, jCol, j: longInt;
begin
  rslts := calcCRCs(sgRoadShoulderPercents, sgRoadConditions);
  // in delphi tstringgrid indexes are column first then row
  // SetLength(tblCRCsCalculated, High(rslts[0]) + 1, High(rslts) + 1);
  SetLength(tblCRCsCalculated, High(rslts) + 1, High(rslts[0]) + 1);

  for iRow := 0 to High(rslts) do
    for jCol := 0 to High(rslts[0]) do
    begin
      // in delphi tstringgrid indexes are column first then row
      tblCRCsCalculated[iRow, jCol] := FormatFloat(THREEDP, rslts[iRow, jCol]);
    end;

  // subtracting 2 below because last row not populated shown to let user know grid will grow
  // as new rows are entered
  // for iRow := 0 to sgCRCs.RowCount - 1 do
  for iRow := 0 to High(rslts) do
  begin
    j := 0;
    for jCol := 0 to High(rslts[0]) do
    begin
      // in delphi tstringgrid indexes are column first then row
      // only copy over values for FSP, TP and TN
      if ((jCol = 1) or (jCol = 2) or (jCol = 4)) then
      begin
        sgCRCs.Cells[j, iRow] := FormatFloat(ONEDP, rslts[iRow, jCol]);
        j := j + 1;
      end;
    end;
  end;
end;

function showRoadPollutantsDialog(CatchID: String): Integer;
var
  Frm: TPLRMRoadPollutants;
  tempInt: Integer;
begin
  initCatchID := CatchID;
  Frm := TPLRMRoadPollutants.Create(Application);
  try
    tempInt := Frm.ShowModal;
  finally
    Frm.Free;
  end;
  Result := tempInt;
end;

procedure TPLRMRoadPollutants.btnOkClick(Sender: TObject);
var
  I, j, K: Integer;
  tempStr: String;
begin
  { // validate road shoulder assignments
    if (StrToFloat(sgRoadShoulderPercents.Cells[0, 0]) <> 100) then
    begin
    ShowMessage('% of Road shoulder length" assignments must add up to 100%');
    Exit;
    end;

    // validate road shoulder assignments
    if (StrToFloat(sgRoadConditions.Cells[0, 0]) <> 100) then
    begin
    ShowMessage('% of Road conditions assignments must add up to 100%');
    Exit;
    end; }

  // validate condition score assignments
  // 1. make sure no two condition scores are the same
  for I := 0 to sgRoadConditions.RowCount - 2 do
  begin
    tempStr := sgRoadConditions.Cells[1, I];
    for j := 0 to sgRoadConditions.RowCount - 2 do
    begin
      if ((tempStr <> '') and (tempStr = sgRoadConditions.Cells[1, j]) and
        (j <> I) and (sgRoadConditions.Cells[0, I] <> '0') and
        (sgRoadConditions.Cells[0, j] <> '0')) then
      begin
        ShowMessage
          ('No two assigned road condition scores can be equal. Please check your road condition score assigmentes and try again');
        exit;
      end;
    end;
  end;

  // save grid data to current catchment and exit form
  GSPLRM.PLRMObj.currentCatchment.frm4of6SgRoadShoulderData :=
    GSUtils.copyGridContents(0, 0, sgRoadShoulderPercents);

  // also copies last empty row so delete last row of grid before copying
  { sgRoadConditions.RowCount := sgRoadConditions.RowCount - 1;
    GSPLRM.PLRMObj.currentCatchment.frm4of6SgRoadConditionData :=
    GSUtils.copyGridContents(0, 0, sgRoadConditions); }
  SetLength(GSPLRM.PLRMObj.currentCatchment.frm4of6SgRoadConditionData,
    sgRoadConditions.RowCount, sgRoadConditions.ColCount);
  // we dont want to copy last row so subtract 2 from row count
  // we dont want to copy rows with %Area assignments of 0 so filter out
  K := 0;
  for I := 0 to sgRoadConditions.RowCount - 1 do
  begin
    if (sgRoadConditions.Cells[0, I] <> '0') then
    begin
      for j := 0 to sgRoadConditions.ColCount - 1 do
        GSPLRM.PLRMObj.currentCatchment.frm4of6SgRoadConditionData[I, j] :=
          sgRoadConditions.Cells[j, I];
      // yes grid index is col first and then row
      inc(K);
    end
  end;
  SetLength(GSPLRM.PLRMObj.currentCatchment.frm4of6SgRoadConditionData, K,
    sgRoadConditions.ColCount);
  // copy crcs  and truncate to match truncated roadconditions length
  GSPLRM.PLRMObj.currentCatchment.frm4of6SgRoadCRCsData := tblCRCsCalculated;
  SetLength(GSPLRM.PLRMObj.currentCatchment.frm4of6SgRoadCRCsData, K,
    High(tblCRCsCalculated[0]) + 1);

  GSPLRM.PLRMObj.currentCatchment.hasDefRoadPolls := true;

  ModalResult := mrOk;
end;

procedure TPLRMRoadPollutants.FormCreate(Sender: TObject);
//var
//  I: Integer;
begin
  // default form labels and other info
  statBar.SimpleText := PLRMVERSION;
  Self.Caption := PLRMD4_TITLE;

  catchArea := PLRMObj.currentCatchment.area;
  lblCatchID.Caption := 'Catchment: ' + PLRMObj.currentCatchment.swmmCatch.ID;
  lblCatchArea.Caption := 'Catchment Area: ' + FormatFloat(ONEDP,
    StrToFloat(PLRMObj.currentCatchment.swmmCatch.Data
    [UProject.SUBCATCH_AREA_INDEX])) + ' ac';
  lblRoadImpervAcres.Caption := 'Road Impervious Acres: ' +
    FormatFloat('#0.0', PLRMObj.currentCatchment.totRoadImpervAcres) + ' acres';

  initFormContents(initCatchID);
  // always restore if PLRMObj.currentCatchment.hasDefRoadPolls = true then
  restoreFormContents(PLRMObj.currentCatchment);
  updateCRCs();
end;

procedure TPLRMRoadPollutants.restoreFormContents(catch: TPLRMCatch);
var
   j, iRow, jCol: Integer;
begin

  copyContentsToGrid(PLRMObj.currentCatchment.frm4of6SgRoadShoulderData, 0, 0,
    sgRoadShoulderPercents);

  // copyContentsToGridAddRows fxn does not work when there is just one row
  // to copy and the sg rowcount is 2 so copy manually
  if (High(PLRMObj.currentCatchment.frm4of6SgRoadConditionData) = 0) then
  begin
    for iRow := 0 to High
      (PLRMObj.currentCatchment.frm4of6SgRoadConditionData) do
      for jCol := 0 to sgRoadConditions.ColCount - 1 do
        sgRoadConditions.Cells[jCol, iRow] :=
          PLRMObj.currentCatchment.frm4of6SgRoadConditionData[iRow, jCol];
  end
  else
    copyContentsToGridAddRows
      (PLRMObj.currentCatchment.frm4of6SgRoadConditionData, 0, 0,
      sgRoadConditions);

  // add an additional row to road conditions grid so user knows it grows
  // check if row already and added and then add it
  if sgRoadConditions.Cells[1, sgRoadConditions.RowCount - 1] <> '' then
  begin
    sgRoadConditions.RowCount :=
      High(PLRMObj.currentCatchment.frm4of6SgRoadConditionData) + 2;
  end;

  // fxns above wont skip rows, so manually copy over the three visible pollutant CRCs FSP, TP and TN
  sgCRCs.RowCount := High(PLRMObj.currentCatchment.frm4of6SgRoadCRCsData) + 1;
  for iRow := 0 to High(PLRMObj.currentCatchment.frm4of6SgRoadCRCsData) do
  begin
    j := 0;
    for jCol := 0 to High(PLRMObj.currentCatchment.frm4of6SgRoadCRCsData[0]) do
    begin
      // in delphi tstringgrid indexes are column first then row
      // only copy over values for FSP, TP and TN
      if ((jCol = 1) or (jCol = 2) or (jCol = 4)) then
      begin
        sgCRCs.Cells[j, iRow] := PLRMObj.currentCatchment.frm4of6SgRoadCRCsData
          [iRow, jCol];
        j := j + 1;
      end;
    end;
  end;
end;

procedure TPLRMRoadPollutants.initFormContents(catch: String);
var
  idx, jdx: Integer;
  tempTbl: PLRMGridData;
begin

  // road shoulder erosion grid defaults
  sgRoadShoulderPercents.Cells[0, 0] := '100'; // 'Percent Erodible';
  sgRoadShoulderPercents.Cells[1, 0] := '0'; // 'Percent Protected Only';
  sgRoadShoulderPercents.Cells[2, 0] := '0'; // 'Percent Stabilized Only';
  sgRoadShoulderPercents.Cells[3, 0] := '0';
  // 'Percent Stabilized and Protected';

  // road conditions grid defaults
  sgRoadConditions.Cells[0, 0] := '100'; // 'Percent Erodible';
  sgRoadConditions.Cells[1, 0] := FloatToStr(defaultCondScore);
  // 'Percent Protected Only';

  sgRoadConditions.Cells[0, 1] := ''; // 'Percent Erodible';
  sgRoadConditions.Cells[1, 1] := ''; // 'Percent Protected Only';

  // look up crcParams from database and use those with the default road condition score
  // to calculate default crcs
  tempTbl := GSIO.getDBDataAsPLRMGridData('RoadCRCs2');

  // columns are 2 less cause 1'st column contains poll codes and 2nd col contains poll names
  // we only want actual parameter values so start reading from column index 2
  SetLength(tblDbCRCParams, High(tempTbl) + 1, High(tempTbl[0]) - 1);
  for idx := 0 to High(tempTbl) do
    for jdx := 2 to High(tempTbl[0]) do
    begin
      tblDbCRCParams[idx, jdx - 2] := StrToFloat(tempTbl[idx, jdx]);
    end;
end;

// Begin CRCs Grid Handlers
procedure TPLRMRoadPollutants.sgCRCsDrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  S: String;
var
  sg: TStringGrid;
begin
  sg := TStringGrid(Sender);

  sg.Canvas.Brush.Color := cl3DLight;
  sg.Canvas.FillRect(Rect);
  S := sg.Cells[ACol, ARow];
  sg.Canvas.Font.Color := clBlue;
  sg.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
end;

procedure TPLRMRoadPollutants.sgCRCsKeyPress(Sender: TObject; var Key: Char);
begin
  // gsEditKeyPress(Sender, Key, gemPosNumber);
end;

// Begin RoadConditionsGrid Handlers
procedure TPLRMRoadPollutants.sgRoadConditionsDrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  S: String;
var
  sg: TStringGrid;
begin
  sg := TStringGrid(Sender);
  if ((ACol = 0) and (ARow = 0)) then
  begin
    sg.Canvas.Brush.Color := cl3DLight;
    sg.Canvas.FillRect(Rect);
    S := sg.Cells[ACol, ARow];
    sg.Canvas.Font.Color := clBlue;
    sg.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure TPLRMRoadPollutants.sgRoadConditionsKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender, Key, gemPosNumber);
end;

procedure TPLRMRoadPollutants.sgRoadConditionsKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  sg: TStringGrid;
  R, lastRow, startCol: longInt;
  conditionScore, acreSum, prcntSum, wtdSum: Double;
begin
  sg := Sender as TStringGrid;
  acreSum := 0;
  prcntSum := 0;
  wtdSum := 0;
  startCol := 0;
  lastRow := sg.RowCount - 1;

  for R := 0 to lastRow do
  begin
    // Sum up %road condition values
    if sg.Cells[startCol, R] = '' then
      sg.Cells[startCol, R] := '0';
    prcntSum := prcntSum + StrToFloat(sg.Cells[startCol, R]);

    // if %road condition entered automatically enter default condition score
    if ((sg.Cells[startCol, R] <> '') and (sg.Cells[startCol + 1, R] = '')) then
    begin
      sg.Cells[startCol + 1, R] := FormatFloat(ONEDP, defaultCondScore);
    end;

    // validate condition score 0.1<x<5.0
    conditionScore := StrToFloat(sg.Cells[startCol + 1, R]);
    // if ((conditionScore < lowCondScore) or (conditionScore > highCondScore))
    // no longer checking lower lower bound cause side effect does not allow entry of decimals preceded by 0
    if ((conditionScore < 0) or (conditionScore > highCondScore)) then
      sg.Cells[startCol + 1, R] := FormatFloat(ONEDP, defaultCondScore)
    else
  end;
  prcntSum := prcntSum - StrToFloat(sg.Cells[0, 0]);
  // for row zero do not edit percent sum column
  if (lastRow > 1) then
  begin
    sg.Cells[0, 0] := FormatFloat(ONEDP, 100 - prcntSum);
    // sg.Cells[0, 0] := FormatFloat(ONEDP, StrToFloat(sg.Cells[0, 0]) + 100 -
    // prcntSum);
  end;

  if (((100 - prcntSum) > 100) or ((100 - prcntSum) < 0)) then
  begin
    ShowMessage
      ('Cell values must not exceed 100% and the sum of all the values in this row must add up to 100%!');
    exit
  end;
  updateCRCs();
end;

procedure TPLRMRoadPollutants.sgRoadConditionsSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
//var
//  sg: TStringGrid;
begin
  // sg := Sender as TStringGrid;
  // prevGridValue := sg.Cells[ACol, ARow];
  GSUtils.sgSelectCellWthNonEditColNRow(Sender, ACol, ARow, CanSelect, 0, 0);
end;

procedure TPLRMRoadPollutants.sgRoadConditionsSetEditText(Sender: TObject;
  ACol, ARow: Integer; const Value: string);
var
  tempInfFootPrintArea: Double;
//  tempSum: Double;
//  iRow, tempNum: Integer;
  sg: TStringGrid;
begin
  sg := Sender as TStringGrid;
  if (sg.Cells[ACol, ARow] <> '') then
  begin
    // round condition score to 1 dp
    // sg.Cells[ACol, ARow] := FormatFloat(ONEDP, StrToFloat(Value));

    // if value was entered in last row of grid add one more row
    if ARow = sg.RowCount - 1 then
    begin
      sg.RowCount := sg.RowCount + 1;
      sg.Height := 10 + Min(Round((sg.RowCount + 1) * sg.Height / sg.RowCount),
        defaultMaxGridHeight); // add extra 10px to prevent permature scrollbars

      // also increase rowcount of sgCRCs
      sgCRCs.RowCount := sgCRCs.RowCount + 1;
      sgCRCs.Height := sg.Height;
    end;
  end;
end;

// Begin RoadShoulderPercent Grid Handlers
procedure TPLRMRoadPollutants.sgRoadShoulderPercentsDrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  S: String;
  sg: TStringGrid;
begin
  sg := TStringGrid(Sender);
  if (ACol = 0) then
  begin
    sg.Canvas.Brush.Color := cl3DLight;
    sg.Canvas.FillRect(Rect);
    S := sg.Cells[ACol, ARow];
    sg.Canvas.Font.Color := clBlue;
    sg.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure TPLRMRoadPollutants.sgRoadShoulderPercentsKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender, Key, gemPosNumber);
end;

procedure TPLRMRoadPollutants.sgRoadShoulderPercentsKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
var
  sg: TStringGrid;
  C, lastCol: longInt;
  prcntSum: Double;
begin
  sg := TStringGrid(Sender);
  prcntSum := 0;
  lastCol := sg.ColCount - 1;
  for C := 1 to lastCol do
  begin
    // Sum up %road shoulder values
    if sg.Cells[C, 0] = '' then
      sg.Cells[C, 0] := '0.0';
    prcntSum := prcntSum + StrToFloat(sg.Cells[C, 0]);
  end;
  sg.Cells[0, 0] := FormatFloat(ONEDP, 100 - prcntSum);
  if (((100 - prcntSum) > 100) or ((100 - prcntSum) < 0)) then
  begin
    ShowMessage
      ('Cell values must not exceed 100% and the sum of all the values in this row must add up to 100%!');
    exit
  end;
  updateCRCs();
end;

procedure TPLRMRoadPollutants.sgRoadShoulderPercentsSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
//var
//  sg: TStringGrid;
begin
  // sg := Sender as TStringGrid;
  // prevGridValue := sg.Cells[ACol, ARow];
  GSUtils.sgSelectCellWthNonEditColNRow(Sender, ACol, ARow, CanSelect, 0, 0);
end;

procedure TPLRMRoadPollutants.sgRoadShoulderPercentsSetEditText(Sender: TObject;
  ACol, ARow: Integer; const Value: string);
//var
//  tempInfFootPrintArea: Double;
//  tempSum: Double;
//  icol: Integer;
//  sg: TStringGrid;
begin
  { sg := Sender as TStringGrid;
    tempSum := 0;

    if StrToFloat(sg.Cells[icol, ARow]) > 100 then
    sg.Cells[ACol, ARow] := '100'; }
end;

end.
