unit _PLRMD6ParcelDrainageAndBMPs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Grids,
  Vcl.ExtCtrls, Vcl.Imaging.jpeg, GSUtils, GSTypes, GSPLRM, GSCatchments,
  UProject;

type
  TDrngXtsData = record
    entity: Integer; // 0 - global, 1 - n for catchments as catchment ID
    luseAreaNPrcnt: PLRMGridData;
    luseAreaNImpv: PLRMGridData;

    // catchment break down by % coverage of land uses
    secRdsPrcnt: Double;
    primRdsPrcnt: Double;
    sfrPrcnt: Double;
    mfrPrcnt: Double;
    cicuPrcnt: Double;
    vegTPrcnt: Double;
    othrPrcnt: Double;

    // catchment break down by area of land uses
    secRdsArea: Double;
    primRdsArea: Double;
    sfrArea: Double;
    mfrArea: Double;
    cicuArea: Double;
    vegTArea: Double;
    othrArea: Double;

    // % of road as high risk
    secRdsHighR: Double;
    primRdsHighR: Double;
    // % of road as moderate risk
    secRdsModR: Double;
    primRdsModR: Double;
    // % of road as low risk
    secRdsLowR: Double;
    primRdsLowR: Double;

    // road land use conditions
    secRdsLuseScheme: Double;
    primRdsLuseScheme: Double;

    // road land use drainage characteristics
    secRdsDrngXtcs: Double;
    primRdsDrngXtcs: Double;
  end;

type
  TPLRMParcelDrngAndBMPs = class(TForm)
    Image1: TImage;
    lblCatchArea: TLabel;
    lblCatchImprv: TLabel;
    Panel12: TPanel;
    Label21: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    sgNoBMPs: TStringGrid;
    Panel2: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    sgBMPImpl: TStringGrid;
    Panel3: TPanel;
    Label7: TLabel;
    Panel4: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Button1: TButton;
    btnOK: TButton;
    statBar: TStatusBar;
    Panel7: TPanel;
    Label28: TLabel;
    Label29: TLabel;
    edtTotSfrArea: TEdit;
    edtTotMfrArea: TEdit;
    edtImpMfrArea: TEdit;
    edtImpSfrArea: TEdit;
    edtTotCicuArea: TEdit;
    edtImpCicuArea: TEdit;
    edtTotVegTArea: TEdit;
    Panel11: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure initFormContents(catch: String);
    procedure UpdateAreas();
    procedure populateFrm(var FD: TDrngXtsData);
    procedure sgNoBMPsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgBMPImplKeyPress(Sender: TObject; var Key: Char);
    procedure sgBMPImplSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sgNoBMPsSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure sgBMPImplSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure sgBMPImplDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure restoreFormContents(catch: TPLRMCatch);
    procedure btnOKClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

function showPLRMParcelDrngAndBMPsDialog(CatchID: String): Integer;

var
  PLRMParcelDrngAndBMPs: TPLRMParcelDrngAndBMPs;
  catchArea: Double;
  initCatchID: String;
  FrmLuseConds: TDrngXtsData; // global data structure used to store form input
  prevGridVal: String;
  // used to account for no road landuses in parcel grid as of 2014 set to two to
  // compensate for and align arrays that have full set of landuses
  luseOffset: Integer;

implementation

{$R *.dfm}

uses GSIO;

// Note: current catchment should be set prior to calling try of this routine
procedure TPLRMParcelDrngAndBMPs.UpdateAreas();
var
  tempInt, I: Integer;
  totArea: Double;
  tempList: TStringList;
  tempOtherArea: Double;
  tempOtherImpvArea: Double;
begin
  tempOtherArea := 0;
  tempOtherImpvArea := 0;
  tempList := TStringList.Create;
  // Add Landuses to StringList to allow indexof
  for I := 0 to High(frmsLuses) do
  begin
    tempList.Add(frmsLuses[I]);
  end;
  with PLRMObj.currentCatchment do
  begin
    totArea := StrToFloat(swmmCatch.Data[UProject.SUBCATCH_AREA_INDEX]);
    for I := 0 to landUseNames.Count - 1 do
    begin
      tempInt := tempList.IndexOf(landUseNames[I]);
      if (tempInt > -1) then
      begin
        FrmLuseConds.luseAreaNImpv[tempInt, 0] :=
          PLRMObj.currentCatchment.landUseData[I][3];
        FrmLuseConds.luseAreaNImpv[tempInt, 1] :=
          PLRMObj.currentCatchment.landUseData[I][2];
      end
      else // lump all other land uses into other areas
      begin
        tempOtherArea := tempOtherArea + StrToFloat(landUseData[I][3]);
        tempOtherImpvArea := tempOtherImpvArea + StrToFloat(landUseData[I][2]) *
          StrToFloat(landUseData[I][3]);
      end;
    end;
  end;
  FrmLuseConds.luseAreaNImpv[High(frmsLuses), 0] := FloatToStr(tempOtherArea);
  FrmLuseConds.luseAreaNImpv[High(frmsLuses), 1] :=
    FloatToStr(tempOtherImpvArea);
  PLRMObj.currentCatchment.othrArea := tempOtherArea;
  PLRMObj.currentCatchment.othrPrcntToOut := 100;
  // entire area drains directly to out
  if tempOtherArea = 0 then
    PLRMObj.currentCatchment.othrPrcntImpv := 0
  else
    PLRMObj.currentCatchment.othrPrcntImpv := tempOtherImpvArea / tempOtherArea;

  populateFrm(FrmLuseConds);

  { if PLRMObj.currentCatchment.rdRiskCats <> nil then
    begin
    //land uses may have been changed since rdRiskCats last stored. So we check and update numbers in rdRiskCats
    for I := 0 to sgRdRiskCat.RowCount -1 do
    begin
    if FrmLuseConds.luseAreaNImpv[I,0] = '0' then
    begin
    PLRMObj.currentCatchment.rdRiskCats[I,0] := '100';
    PLRMObj.currentCatchment.rdRiskCats[I,1] := '0';
    PLRMObj.currentCatchment.rdRiskCats[I,2] := '0';
    end;
    end;
    copyContentsToGrid( PLRMObj.currentCatchment.rdRiskCats, 0,0, sgRdRiskCat);
    end; }

  if PLRMObj.currentCatchment.bmpImpl <> nil then
  begin
    // land uses may have been changed since rdRiskCats last stored. So we check and update numbers in rdRiskCats
    for I := 0 to sgBMPImpl.RowCount - 1 do
    begin
      if FrmLuseConds.luseAreaNImpv[I + 2, 0] = '0' then
      begin
        PLRMObj.currentCatchment.bmpImpl[I, 0] := '100';
        PLRMObj.currentCatchment.bmpImpl[I, 1] := '0';
        PLRMObj.currentCatchment.bmpImpl[I, 2] := '0';
      end;
    end;
    copyContentsToGrid(PLRMObj.currentCatchment.bmpImpl, 0, 0, sgBMPImpl);
  end;
end;

procedure TPLRMParcelDrngAndBMPs.populateFrm(var FD: TDrngXtsData);
begin
  { if FrmLuseConds.luseAreaNImpv[0, 0] <> '' then
    edtSecRdArea.Text := FrmLuseConds.luseAreaNImpv[0, 0];
    if FrmLuseConds.luseAreaNImpv[1, 0] <> '' then
    edtprimRdArea.Text := FrmLuseConds.luseAreaNImpv[1, 0]; }

  if FrmLuseConds.luseAreaNImpv[0 + luseOffset, 0] <> '' then
    edtTotSfrArea.Text := FrmLuseConds.luseAreaNImpv[0 + luseOffset, 0];
  if FrmLuseConds.luseAreaNImpv[1 + luseOffset, 0] <> '' then
    edtTotMfrArea.Text := FrmLuseConds.luseAreaNImpv[1 + luseOffset, 0];
  if FrmLuseConds.luseAreaNImpv[2 + luseOffset, 0] <> '' then
    edtTotCicuArea.Text := FrmLuseConds.luseAreaNImpv[2 + luseOffset, 0];
  if FrmLuseConds.luseAreaNImpv[3 + luseOffset, 0] <> '' then
    edtTotVegTArea.Text := FrmLuseConds.luseAreaNImpv[3 + luseOffset, 0];
  { if FrmLuseConds.luseAreaNImpv[6, 0] <> '' then
    edtTotOthrArea.Text := FrmLuseConds.luseAreaNImpv[6, 0]; }

  { if FrmLuseConds.luseAreaNImpv[0, 1] <> '' then
    edtPrcntSecRdArea.Text := FrmLuseConds.luseAreaNImpv[0, 1];
    if FrmLuseConds.luseAreaNImpv[1, 1] <> '' then
    edtPrcntPrimRdArea.Text := FrmLuseConds.luseAreaNImpv[1, 1]; }

  if FrmLuseConds.luseAreaNImpv[0 + luseOffset, 1] <> '' then
    edtImpSfrArea.Text := FrmLuseConds.luseAreaNImpv[0 + luseOffset, 1];
  if FrmLuseConds.luseAreaNImpv[1 + luseOffset, 1] <> '' then
    edtImpMfrArea.Text := FrmLuseConds.luseAreaNImpv[1 + luseOffset, 1];
  if FrmLuseConds.luseAreaNImpv[2 + luseOffset, 1] <> '' then
    edtImpCicuArea.Text := FrmLuseConds.luseAreaNImpv[2 + luseOffset, 1];
  { if FrmLuseConds.luseAreaNImpv[5, 1] <> '' then
    edtImpVegTArea.Text := FrmLuseConds.luseAreaNImpv[5, 1];
    if FrmLuseConds.luseAreaNImpv[6, 1] <> '' then
    edtImpOthrArea.Text := FrmLuseConds.luseAreaNImpv[6, 1]; }
end;

procedure TPLRMParcelDrngAndBMPs.sgBMPImplDrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  S: String;
  sg: TStringGrid;
begin
  { sg := Sender as TStringGrid;
    if ((ACol = 0) or ((ACol = 1) and (ARow = 3))) then
    begin // or (ARow = 0 ))then begin
    sg.Canvas.Brush.Color := cl3DLight;
    sg.Canvas.FillRect(Rect);
    S := sg.Cells[ACol, ARow];
    sg.Canvas.Font.Color := clBlue;
    sg.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
    end; }
end;

procedure TPLRMParcelDrngAndBMPs.sgBMPImplKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender, Key, gemPosNumber);
end;

procedure TPLRMParcelDrngAndBMPs.sgBMPImplSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  prevGridVal := sgBMPImpl.Cells[ACol, ARow];
end;

procedure TPLRMParcelDrngAndBMPs.sgBMPImplSetEditText(Sender: TObject;
  ACol, ARow: Integer; const Value: string);
var
  tempSum, prevTotal: Double;
  sg: TStringGrid;
begin
  tempSum := 0.0;
  sg := Sender as TStringGrid;

  // then check sums to see if they will exceed 100%
  if ((sg.Cells[ACol, ARow] <> '') and (Value <> '')) then
  begin
    if 0 = ACol then
      tempSum := StrToFloat(Value) + StrToFloat(sg.Cells[1, ARow])
    else
      tempSum := StrToFloat(Value) + StrToFloat(sg.Cells[0, ARow]);

    if ((100 - tempSum) > 100) or ((100 - tempSum) < 0) then
    begin
      ShowMessage
        ('This row must add up to 100. Please enter a different number!');
      Exit;
    end
    else
      sgNoBMPs.Cells[0, ARow] := FloatToStr(100 - tempSum);
  end;
end;

procedure TPLRMParcelDrngAndBMPs.sgNoBMPsDrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  S: String;
  sg: TStringGrid;
begin
  sg := Sender as TStringGrid;
  if ((ACol = 0) or ((ACol = 1) and (ARow = 3))) then
  begin // or (ARow = 0 ))then begin
    sg.Canvas.Brush.Color := cl3DLight;
    sg.Canvas.FillRect(Rect);
    S := sg.Cells[ACol, ARow];
    sg.Canvas.Font.Color := clBlue;
    sg.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure TPLRMParcelDrngAndBMPs.sgNoBMPsSetEditText(Sender: TObject;
  ACol, ARow: Integer; const Value: string);
var
  tempSum: Double;
  sg: TStringGrid;
begin
  { tempSum := 0.0;
    sg := Sender as TStringGrid;
    // then check sums to see if they will exceed 100%
    if ((sgBMPImpl.Cells[ACol, ARow] <> '') and (Value <> '')) then
    begin
    tempSum := tempSum + StrToFloat(Value) + StrToFloat(sgBMPImpl.Cells[0, ARow]
    ) + StrToFloat(sgBMPImpl.Cells[1, ARow]);
    if ((100 - tempSum) > 100) or ((100 - tempSum) < 0) then
    begin
    ShowMessage
    ('This row must add up to 100. Please enter a different number!');
    sg.Cells[ACol, ARow] := prevGridVal;
    Exit;
    end
    else
    sgNoBMPs.Cells[0, ARow] := FloatToStr(100 - tempSum);
    end; }
end;

procedure TPLRMParcelDrngAndBMPs.btnOKClick(Sender: TObject);
begin
  // save grid data to current catchment and exit form
  GSPLRM.PLRMObj.currentCatchment.frm6of6SgBMPImplData :=
    GSUtils.copyGridContents(0, 0, sgBMPImpl);
  GSPLRM.PLRMObj.currentCatchment.frm6of6SgNoBMPsData :=
    GSUtils.copyGridContents(0, 0, sgNoBMPs);
  ModalResult := mrOk;
end;



function showPLRMParcelDrngAndBMPsDialog(CatchID: String): Integer;
var
  Frm: TPLRMParcelDrngAndBMPs;
  tempInt: Integer;
begin
  initCatchID := CatchID;
  Frm := TPLRMParcelDrngAndBMPs.Create(Application);
  try
    tempInt := Frm.ShowModal;
  finally
    Frm.Free;
  end;
end;

procedure TPLRMParcelDrngAndBMPs.initFormContents(catch: String);
var
  idx, I: Integer;
  jdx: Integer;
  tempInt: Integer;
  tempLst: TStringList;
  tempLst2: TStrings;
  // Schm: TPLRMRdCondsScheme;
  // hydProps: dbReturnFields;
  kSatMultplrs: dbReturnFields;
begin

  // edtSecRdArea.Text := '0';
  // edtprimRdArea.Text := '0';
  edtTotSfrArea.Text := '0';
  edtTotMfrArea.Text := '0';
  edtTotCicuArea.Text := '0';
  edtTotVegTArea.Text := '0';
  // edtTotOthrArea.Text := '0';

  // edtImpSecRdArea.Text := '0';
  // edtImpPrimRdArea.Text := '0';
  edtImpSfrArea.Text := '0';
  edtImpMfrArea.Text := '0';
  edtImpCicuArea.Text := '0';
  // edtImpVegTArea.Text := '0';
  // edtImpOthrArea.Text := '0';

  { // populate road risk category grid with initial values
    sgRdRiskCat.Cells[0, 0] := '100';
    sgRdRiskCat.Cells[0, 1] := '100';
    sgRdRiskCat.Cells[1, 0] := '0';
    sgRdRiskCat.Cells[1, 1] := '0';
    sgRdRiskCat.Cells[2, 0] := '0';
    sgRdRiskCat.Cells[2, 1] := '0';
    sgRdRiskCat.Options := sgBMPImpl.Options + [goEditing]; }

  // populate bmp implementation grid with initial values
  sgBMPImpl.Cells[0, 0] := '0';
  sgBMPImpl.Cells[0, 1] := '0';
  sgBMPImpl.Cells[0, 2] := '0';
  sgBMPImpl.Cells[0, 3] := '0';

  sgBMPImpl.Cells[1, 0] := '0';
  sgBMPImpl.Cells[1, 1] := '0';
  sgBMPImpl.Cells[1, 2] := '0';
  sgBMPImpl.Cells[1, 3] := '0';

  // populate no bmp implementation grid with initial values
  sgNoBMPs.Cells[0, 0] := '100';
  sgNoBMPs.Cells[0, 1] := '100';
  sgNoBMPs.Cells[0, 2] := '100';
  sgNoBMPs.Cells[0, 3] := '100';

  sgNoBMPs.Cells[1, 0] := '0';
  sgNoBMPs.Cells[1, 1] := '0';
  sgNoBMPs.Cells[1, 2] := '0';
  sgNoBMPs.Cells[1, 3] := '0';
  // sgBMPImpl.Cells[0, 4] := '100';

  sgBMPImpl.Options := sgBMPImpl.Options + [goEditing];

  tempInt := PLRMObj.getCatchIndex(catch);
  // cbxGlobalSpecfc.items := PLRMObj.catchments;
  // loads catchments into combo box
  // cbxGlobalSpecfc.ItemIndex := tempInt;
  PLRMObj.currentCatchment := PLRMObj.catchments.Objects[tempInt] as TPLRMCatch;

  // hydProps := GSIO.getDefaults('"6%"');
  kSatMultplrs := GSIO.getDefaults('"7%"');

  for I := 0 to sgNoBMPs.RowCount - 1 do
  begin
    // default dcia
    sgNoBMPs.Cells[1, I] := '50';

    // default ksat vals  8/14/09 apply ksat reduction factors from database
    if (assigned(PLRMObj.currentCatchment.soilsInfData)) then
    begin
      sgNoBMPs.Cells[2, I] := FormatFloat('0.##',
        (StrToFloat(PLRMObj.currentCatchment.soilsInfData[0, 1]) *
        StrToFloat(kSatMultplrs[0][I + luseOffset])));
    end;
  end;

  // clear old numbers for new numbers
  for I := 0 to High(FrmLuseConds.luseAreaNImpv) do
  begin
    FrmLuseConds.luseAreaNImpv[I, 0] := '0';
    FrmLuseConds.luseAreaNImpv[I, 1] := '0';
  end;

  UpdateAreas;
end;

procedure TPLRMParcelDrngAndBMPs.restoreFormContents(catch: TPLRMCatch);
begin
  copyContentsToGrid(PLRMObj.currentCatchment.frm6of6SgBMPImplData, 0, 0,
    sgBMPImpl);
  copyContentsToGrid(PLRMObj.currentCatchment.frm6of6SgNoBMPsData, 0, 0,
    sgNoBMPs);
end;

procedure TPLRMParcelDrngAndBMPs.FormCreate(Sender: TObject);
begin
  luseOffset := 2;
  statBar.SimpleText := PLRMVERSION;
  Self.Caption := PLRM3_TITLE;
  SetLength(FrmLuseConds.luseAreaNImpv, High(frmsLuses) + 1, 2);

  lblCatchArea.Caption := 'Catchment ID: ' + PLRMObj.currentCatchment.swmmCatch.
    ID + '   [ Area: ' + PLRMObj.currentCatchment.swmmCatch.Data
    [UProject.SUBCATCH_AREA_INDEX] + 'ac ]';

  initFormContents(initCatchID); // also calls updateAreas
  restoreFormContents(PLRMObj.currentCatchment);
end;

end.
