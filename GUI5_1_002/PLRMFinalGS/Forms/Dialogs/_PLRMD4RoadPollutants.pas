unit _PLRMD4RoadPollutants;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Math,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg, Vcl.ComCtrls, GSTypes, GSUtils, GSPLRM, UProject;

const
  defaultPollutantCount = 5;
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
    procedure FormCreate(Sender: TObject);
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
    procedure updateCalcs(sg: TStringGrid);
    procedure sgRoadShoulderPercentsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOkClick(Sender: TObject);
    procedure sgRoadShoulderPercentsSelectCell(Sender: TObject;
      ACol, ARow: Integer; var CanSelect: Boolean);
    procedure sgRoadConditionsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sgRoadConditionsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

function showRoadPollutantsDialog(CatchID: String): Integer;

var
  PLRMRoadPollutants: TPLRMRoadPollutants;
  catchArea: Double;
  initCatchID: String;
  sgs: array [0 .. 6] of TStringGrid;
  curAcVals: array [0 .. 6] of Double;
  curImpPrctVals: array [0 .. 6] of Double;
  prevGridValue: String;

implementation

{$R *.dfm}

// calculate road shoulder concentrations based on road shoulder percentage assignment
function calcRoadShoulderConc();
begin
  return 1;
end;

// calculate road condition concentrations based on road travel lane risk score
function calcRoadConditionConc();
begin
  result = 1;
end;

// comput crcs based on road shoulder concs and road condition concs
function calcCRCs(sgRdShoulders, sgRdConditions);
var
  lastRow, iRow: longInt;
  rslts: PLRMGridDataDbl;
  erodible, protectd, stable, stableProtected: Double;
rdCondScore, rdConditionConc
begin

  // road shoulder assignments
  erodible = StrToFloat(sgRdShoulders.Cells[1, 0]);
  protectd = StrToFloat(sgRdShoulders.Cells[2, 0]);
  stable = StrToFloat(sgRdShoulders.Cells[3, 0]);
  stableProtected = StrToFloat(sgRdShoulders.Cells[4, 0]);

  SetLength(rslts, sgRoadConditions.RowCount, defaultPollutantCount));

  lastRow = sgRoadConditions.RowCount - 1;
  for iRow := 0 to lastRow do begin rdCondScore = sgRoadConditions
    (sgRdShoulders.Cells[1, iRow]);
  rdConditionConc = calcRoadConditionConc(rdCondScore);
  rdShoulderConc = calcRoadShoulderConc(erodible, protectd, stable,
    stableProtected); for idx := 0 to High(rdConditionConc) do begin rslts[iRow,
    idx] = rdShoulderConc[0, idx] + rdShoulderConc[0, idx]; end end;
  return rslts; end;

  procedure TPLRMRoadPollutants.updateCalcs(sg: TStringGrid);
  var iRow, I: Integer; prcntImpv: Double; area: Double; begin area := 0;
  prcntImpv := 0; for I := 0 to High(sgs) do if (sgs[I] = sg)
  then begin prcntImpv := curImpPrctVals[I]; area := curAcVals[I]; end;

  // only acreage and imperv acreage columns calculated
  for iRow := 0 to sg.RowCount - 1 do begin sg.Cells[1,
    iRow] := FormatFloat('0.##', (StrToFloat(sg.Cells[0, iRow]) * area / 100));
  sg.Cells[2, iRow] := FormatFloat('0.##',
    (StrToFloat(sg.Cells[1, iRow]) * prcntImpv / 100)); end; end;

  function showRoadPollutantsDialog(CatchID: String): Integer;
  var Frm: TPLRMRoadPollutants; tempInt: Integer; begin initCatchID := CatchID;
  Frm := TPLRMRoadPollutants.Create(Application); try tempInt := Frm.ShowModal;
  finally Frm.Free; end; end;

  procedure TPLRMRoadPollutants.btnOkClick(Sender: TObject); begin
  // validate road shoulder assignments
  if (StrToFloat(sgRoadShoulderPercents.Cells[0, 0]) <> 100)
  then begin ShowMessage
    ('% of Road shoulder length" assignments must add up to 100%'); Exit; end;

  // validate road shoulder assignments
  if (StrToFloat(sgRoadConditions.Cells[0, 0]) <> 100)
  then begin ShowMessage
    ('% of Road conditions assignments must add up to 100%'); Exit; end;

  ModalResult := mrOK; end;

  procedure TPLRMRoadPollutants.FormCreate(Sender: TObject);
  var idx: Integer; begin
  // default form labels and other info
  statBar.SimpleText := PLRMVERSION; Self.Caption := PLRM4_TITLE;
  catchArea := PLRMObj.currentCatchment.area;
  lblCatchID.Caption := 'Catchment: ' + PLRMObj.currentCatchment.swmmCatch.ID;
  lblCatchArea.Caption := 'Catchment Area: ' + FormatFloat(ONEDP,
    StrToFloat(PLRMObj.currentCatchment.swmmCatch.Data
    [UProject.SUBCATCH_AREA_INDEX])) + ' ac';

  // road shoulder erosion grid defaults
  sgRoadShoulderPercents.Cells[0, 0] := '100'; // 'Percent Erodible';
  sgRoadShoulderPercents.Cells[1, 0] := '0'; // 'Percent Protected Only';
  sgRoadShoulderPercents.Cells[2, 0] := '0'; // 'Percent Stabilized Only';
  sgRoadShoulderPercents.Cells[3, 0] := '1';
  // 'Percent Stabilized and Protected';

  // road conditions grid defaults
  sgRoadConditions.Cells[0, 0] := '100'; // 'Percent Erodible';
  sgRoadConditions.Cells[1, 0] := '2.5'; // 'Percent Protected Only';

  sgRoadConditions.Cells[0, 1] := ''; // 'Percent Erodible';
  sgRoadConditions.Cells[1, 1] := ''; // 'Percent Protected Only';

  end;

  // Begin CRCs Grid Handlers
  procedure TPLRMRoadPollutants.sgCRCsDrawCell(Sender: TObject;
    ACol, ARow: Integer;
  Rect:
    TRect;
  State:
    TGridDrawState); var S: String; var sg: TStringGrid;
  begin sg := TStringGrid(Sender);

  sg.Canvas.Brush.Color := cl3DLight; sg.Canvas.FillRect(Rect);
  S := sg.Cells[ACol, ARow]; sg.Canvas.Font.Color := clBlue;
  sg.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S); end;

  procedure TPLRMRoadPollutants.sgCRCsKeyPress(Sender: TObject;
  var
      Key: Char); begin
    // gsEditKeyPress(Sender, Key, gemPosNumber);
    end;

    // Begin RoadConditionsGrid Handlers
    procedure TPLRMRoadPollutants.sgRoadConditionsDrawCell(Sender: TObject;
      ACol, ARow: Integer;
      Rect: TRect;
      State: TGridDrawState); var S: String; var sg: TStringGrid;
    begin sg := TStringGrid(Sender);
    if ((ACol = 0) and (ARow = 0)) then begin sg.Canvas.Brush.Color :=
      cl3DLight; sg.Canvas.FillRect(Rect); S := sg.Cells[ACol, ARow];
    sg.Canvas.Font.Color := clBlue; sg.Canvas.TextOut(Rect.Left + 2,
      Rect.Top + 2, S); end; end;

    procedure TPLRMRoadPollutants.sgRoadConditionsKeyPress(Sender: TObject;
  var
      Key: Char); begin
    // gsEditKeyPress(Sender, Key, gemPosNumber);
    end;

    procedure TPLRMRoadPollutants.sgRoadConditionsKeyUp(Sender: TObject;
  var
      Key: Word;
      Shift: TShiftState); var sg: TStringGrid; R, lastRow, startCol: longInt;
    conditionScore, acreSum, prcntSum, wtdSum: Double;
    begin sg := Sender as TStringGrid; acreSum := 0; prcntSum := 0; wtdSum := 0;
    startCol := 0; lastRow := sg.RowCount - 1;

    for R := 1 to lastRow do begin
    // Sum up %road condition values
    if sg.Cells[startCol, R] = '' then sg.Cells[startCol, R] := '0';
    prcntSum := prcntSum + StrToFloat(sg.Cells[startCol, R]);

    // if %road condition entered automatically enter default condition score
    if ((sg.Cells[startCol, R] <> '') and (sg.Cells[startCol + 1, R] = ''))
    then begin sg.Cells[startCol + 1, R] := FormatFloat(ONEDP,
      defaultCondScore); end;

    // validate condition score 0.1<x<5.0
    conditionScore := StrToFloat(sg.Cells[startCol + 1, R]);
    if ((conditionScore < lowCondScore) or (conditionScore > highCondScore))
    then sg.Cells[startCol + 1, R] := FormatFloat(ONEDP,
      defaultCondScore) else end; sg.Cells[0, 0] := FormatFloat(ONEDP,
      100 - prcntSum); if (((100 - prcntSum) > 100) or ((100 - prcntSum) < 0))
    then begin ShowMessage
      ('Cell values must not exceed 100% and the sum of all the values in this row must add up to 100%!');
    Exit end; end;

    procedure TPLRMRoadPollutants.sgRoadConditionsSelectCell(Sender: TObject;
      ACol, ARow: Integer;
  var
      CanSelect: Boolean); var sg: TStringGrid;
    begin sg := Sender as TStringGrid; prevGridValue := sg.Cells[ACol, ARow];
    GSUtils.sgSelectCellWthNonEditColNRow(Sender, ACol, ARow, CanSelect,
      0, 0); end;

    procedure TPLRMRoadPollutants.sgRoadConditionsSetEditText(Sender: TObject;
      ACol, ARow: Integer;
  const
  Value:
    string); var tempInfFootPrintArea: Double; tempSum: Double; iRow: Integer;
  sg: TStringGrid; begin sg := Sender as TStringGrid;
  if (sg.Cells[ACol, ARow] <> '') then begin
  { // round condition score to 1 dp
    sg.Cells[ACol, ARow] := FormatFloat(ONEDP,
    StrToFloat(sg.Cells[ACol, ARow])); }

  // if value was entered in last row of grid add one more row
  if ARow = sg.RowCount - 1 then begin sg.RowCount := sg.RowCount + 1;
  sg.Height := 10 + Min(Round((sg.RowCount + 1) * sg.Height / sg.RowCount),
    defaultMaxGridHeight); // add extra 10px to prevent permature scrollbars

  // also increase rowcount of sgCRCs
  sgCRCs.RowCount := sgCRCs.RowCount + 1; sgCRCs.Height := sg.Height;
  end; end; end;

  // Begin RoadShoulderPercent Grid Handlers
  procedure TPLRMRoadPollutants.sgRoadShoulderPercentsDrawCell(Sender: TObject;
    ACol, ARow: Integer;
  Rect:
    TRect;
  State:
    TGridDrawState); var S: String; sg: TStringGrid;
  begin sg := TStringGrid(Sender);
  if (ACol = 0) then begin sg.Canvas.Brush.Color := cl3DLight;
  sg.Canvas.FillRect(Rect); S := sg.Cells[ACol, ARow];
  sg.Canvas.Font.Color := clBlue; sg.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2,
    S); end; end;

  procedure TPLRMRoadPollutants.sgRoadShoulderPercentsKeyPress(Sender: TObject;
  var
      Key: Char); begin gsEditKeyPress(Sender, Key, gemPosNumber); end;

    procedure TPLRMRoadPollutants.sgRoadShoulderPercentsKeyUp(Sender: TObject;
  var
      Key: Word;
      Shift: TShiftState); var sg: TStringGrid; C, lastCol: longInt;
    acreSum, prcntSum, wtdSum: Double; begin sg := TStringGrid(Sender);
    prcntSum := 0; lastCol := sg.ColCount - 1; for C := 1 to lastCol do begin
    // Sum up %road shoulder values
    if sg.Cells[C, 0] = '' then sg.Cells[C, 0] := '0.0';
    prcntSum := prcntSum + StrToFloat(sg.Cells[C, 0]); end;
    sg.Cells[0, 0] := FormatFloat(ONEDP, 100 - prcntSum);
    if (((100 - prcntSum) > 100) or ((100 - prcntSum) < 0))
    then begin ShowMessage
      ('Cell values must not exceed 100% and the sum of all the values in this row must add up to 100%!');
    Exit end;

    end;

    procedure TPLRMRoadPollutants.sgRoadShoulderPercentsSelectCell
      (Sender: TObject;
      ACol, ARow: Integer;
  var
      CanSelect: Boolean); var sg: TStringGrid;
    begin sg := Sender as TStringGrid; prevGridValue := sg.Cells[ACol, ARow];
    GSUtils.sgSelectCellWthNonEditColNRow(Sender, ACol, ARow, CanSelect,
      0, 0); end;

    procedure TPLRMRoadPollutants.sgRoadShoulderPercentsSetEditText
      (Sender: TObject;
      ACol, ARow: Integer;
  const
  Value:
    string); var tempInfFootPrintArea: Double; tempSum: Double; icol: Integer;
  sg: TStringGrid; begin
  { sg := Sender as TStringGrid;
    tempSum := 0;

    if StrToFloat(sg.Cells[icol, ARow]) > 100 then
    sg.Cells[ACol, ARow] := '100'; }
  end;

  end.
