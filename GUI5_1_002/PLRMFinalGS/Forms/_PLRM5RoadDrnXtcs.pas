unit _PLRM5RoadDrnXtcs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, xmldom, XMLIntf, msxmldom, XMLDoc,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, jpeg, Grids, GSUtils, GSTypes, GSPLRM, GSCatchments, UProject,
  _PLRM6DrngXtsDetail, Buttons;

type
  TPLRMDrainageConditions = class(TForm)
    Image1: TImage;
    btnCancel: TButton;
    btnOK: TButton;
    statBar: TStatusBar;
    btnApply: TButton;
    pgCtrlParcelRds: TPageControl;
    TabSheet4: TTabSheet;
    GroupBox2: TGroupBox;
    Panel8: TPanel;
    sgSFR: TStringGrid;
    Panel7: TPanel;
    Label20: TLabel;
    Label21: TLabel;
    lblSfrHdr: TLabel;
    Panel2: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    lblMfrHdr: TLabel;
    Panel5: TPanel;
    Label17: TLabel;
    Label18: TLabel;
    lblCicHdr: TLabel;
    Panel6: TPanel;
    Label16: TLabel;
    lblVegHdr: TLabel;
    Panel10: TPanel;
    sgMFR: TStringGrid;
    Panel11: TPanel;
    sgCICU: TStringGrid;
    Panel12: TPanel;
    sgVeg: TStringGrid;
    Label30: TLabel;
    Label9: TLabel;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    Panel1: TPanel;
    sgPrimRds: TStringGrid;
    Panel3: TPanel;
    Label12: TLabel;
    Label13: TLabel;
    lblPrrHdr: TLabel;
    Label28: TLabel;
    cbxGlobalSpecfc: TComboBox;
    Panel16: TPanel;
    lblSerHdr: TLabel;
    Label15: TLabel;
    Label26: TLabel;
    Label29: TLabel;
    Panel19: TPanel;
    sgSecRds: TStringGrid;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    lblCatchArea: TLabel;
    lblCatchImprv: TLabel;
    Label37: TLabel;
    lblOthHdr: TLabel;
    sgOthr: TStringGrid;
    Button2: TButton;
    Button4: TButton;
    Button6: TButton;
    Button8: TButton;
    Button12: TButton;
    Button18: TButton;
    Button21: TButton;
    Label5: TLabel;
    Label14: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label27: TLabel;
    Label38: TLabel;
    Label39: TLabel;

    procedure initFormContents(catch: TPLRMCatch);
    procedure restoreFormContents(catch: TPLRMCatch);
    procedure sgGenDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgGenParcelDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgGenRdDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgRoadGenSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure sgParcelGenSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure sgGenRdSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure cbxGlobalSpecfcChange(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnRdSecInfEditClick(Sender: TObject);
    procedure btnRdSecDspEditClick(Sender: TObject);
    procedure btnEditSFRInfClick(Sender: TObject);
    procedure btnEditMFRInfClick(Sender: TObject);
    procedure btnEditCICUInfClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure sgGenSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
    procedure sgVegDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure checkAndSelectCbxItm(var cbx:TCombobox; scheme:TPLRMHydPropsScheme; schms:TStringList);
    procedure updateCalcs(sg:TStringGrid);
    procedure btnRdPrimInfEditClick(Sender: TObject);
    procedure btnRdPrimDspEditClick(Sender: TObject);
    procedure btnRdPrimOutEditClick(Sender: TObject);
    procedure btnEditOthrOutClick(Sender: TObject);
    procedure sgPrimRdsKeyPress(Sender: TObject; var Key: Char);
    procedure sgSFRKeyPress(Sender: TObject; var Key: Char);
    procedure sgMFRKeyPress(Sender: TObject; var Key: Char);
    procedure sgCICUKeyPress(Sender: TObject; var Key: Char);
    procedure sgVegKeyPress(Sender: TObject; var Key: Char);
    procedure sgOthrKeyPress(Sender: TObject; var Key: Char);
    procedure sgSecRdsKeyPress(Sender: TObject; var Key: Char);

    procedure getHydSchemes(var Schm:TPLRMHydPropsScheme; sType:Integer; ext:String; parcelOrRoad:String; luse:String);

  private
    { Private declarations }
  public
    { Public declarations }
    procedure loadHydPropsSchemeDb(var Schm:TPLRMHydPropsScheme;ext:String);
    end;
function getDrngCondsInput(catchID: String): TPLRMDrngXtcsData;

var
  Frm: TPLRMDrainageConditions;
  initCatchID: String;
  curCatchArea:Double;
  curAcVals :array[0..6] of Double;
  curImpPrctVals :array[0..6] of Double;
  sgs: array[0..6] of TStringGrid;
  prevGridValue : String;
implementation

uses GSIO;

{$R *.dfm}

  procedure TPLRMDrainageConditions.btnOKClick(Sender: TObject);
  begin
    btnApplyClick(Sender);
    if not(assigned(PLRMObj.currentCatchment.catchHydPropSchemes)) then
       PLRMObj.currentCatchment.copyHydSchemesToArray;
    ModalResult := mrOk;
  end;

  procedure TPLRMDrainageConditions.btnApplyClick(Sender: TObject);
  begin
  GSPLRM.PLRMObj.currentCatchment.secRdDrng := GSUtils.copyGridContents(0,0, sgSecRds);
  GSPLRM.PLRMObj.currentCatchment.primRdDrng := GSUtils.copyGridContents(0,0, sgPrimRds);
  GSPLRM.PLRMObj.currentCatchment.sfrDrng := GSUtils.copyGridContents(0,0, sgSFR);
  GSPLRM.PLRMObj.currentCatchment.mfrDrng := GSUtils.copyGridContents(0,0, sgMFR);
  GSPLRM.PLRMObj.currentCatchment.cicuDrng := GSUtils.copyGridContents(0,0, sgCICU);
  GSPLRM.PLRMObj.currentCatchment.vegTDrng := GSUtils.copyGridContents(0,0, sgVeg);
  GSPLRM.PLRMObj.currentCatchment.othrDrng := GSUtils.copyGridContents(0,0, sgOthr);
  GSPLRM.PLRMObj.currentCatchment.hasDefDrnXtcs :=true;

  end;

  procedure TPLRMDrainageConditions.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

{$REGION 'Parcels' }

//MFR Schemes Edit
  procedure TPLRMDrainageConditions.btnEditMFRInfClick(Sender: TObject);
  begin
    PLRMObj.currentCatchment.mfrSchms[1]:= getSDrngXtsScheme(PLRMObj.currentCatchment.mfrSchms[1],false,1);
  end;

//SFR schemes Edit
procedure TPLRMDrainageConditions.btnEditSFRInfClick(Sender: TObject);
begin
  PLRMObj.currentCatchment.sfrSchms[1]:= getSDrngXtsScheme(PLRMObj.currentCatchment.sfrSchms[1],false,1);
end;

//CICU Schemes Edit
  procedure TPLRMDrainageConditions.btnEditCICUInfClick(Sender: TObject);
  begin
    PLRMObj.currentCatchment.cicuSchms[1]:= getSDrngXtsScheme(PLRMObj.currentCatchment.cicuSchms[1],false,1);
  end;

  //Othr scheme edit
procedure TPLRMDrainageConditions.btnEditOthrOutClick(Sender: TObject);
  begin
    PLRMObj.currentCatchment.othrSchms[0]:= getSDrngXtsScheme(PLRMObj.currentCatchment.othrSchms[0],false,0);
  end;
{$ENDREGION}

{$REGION 'Roads' }

{$REGION 'Secondary Roads' }

//Secondary roads Edit
  procedure TPLRMDrainageConditions.btnRdSecInfEditClick(Sender: TObject);
  begin
    PLRMObj.currentCatchment.secRdSchms[1]:= getSDrngXtsScheme(PLRMObj.currentCatchment.secRdSchms[1],true,1);
  end;

  procedure TPLRMDrainageConditions.btnRdSecDspEditClick(Sender: TObject);
  begin
    PLRMObj.currentCatchment.secRdSchms[2]:= getSDrngXtsScheme(PLRMObj.currentCatchment.secRdSchms[2],true,2);
  end;
{$ENDREGION}

{$REGION 'Primary Roads' }
// Primary roads edit
  procedure TPLRMDrainageConditions.btnRdPrimInfEditClick(Sender: TObject);
  begin
    PLRMObj.currentCatchment.primRdSchms[1]:= getSDrngXtsScheme(PLRMObj.currentCatchment.primRdSchms[1],true,1);
  end;

  procedure TPLRMDrainageConditions.btnRdPrimDspEditClick(Sender: TObject);
  begin
    PLRMObj.currentCatchment.primRdSchms[2]:= getSDrngXtsScheme(PLRMObj.currentCatchment.primRdSchms[2],true,2);
  end;
  procedure TPLRMDrainageConditions.btnRdPrimOutEditClick(Sender: TObject);
  begin
    PLRMObj.currentCatchment.primRdSchms[0]:= getSDrngXtsScheme(PLRMObj.currentCatchment.primRdSchms[0],true,0);
  end;
{$ENDREGION}
{$ENDREGION}

procedure TPLRMDrainageConditions.cbxGlobalSpecfcChange(Sender: TObject);
begin
   //set current catchment to the obj coresponding to selected value
    PLRMObj.currentCatchment := GSUtils.getComboBoxSelValue2(Sender) as TPLRMCatch;
    lblCatchArea.Caption := 'Selected Catchment Area is: ' + PLRMobj.currentCatchment.swmmCatch.Data[UProject.SUBCATCH_AREA_INDEX] + 'ac';

    if PLRMObj.currentCatchment.hasDefSoils = false then
    begin
      ShowMessage('Please select another catchment or go back and provide soils data for current catchment');
      Exit;
    end;
      initFormContents(PLRMobj.currentCatchment);
end;

procedure TPLRMDrainageConditions.initFormContents(catch: TPLRMCatch);
  var
    hasLuse :array[0..6] of Boolean;
    I,J : Integer;
    prcnt : Double;
    hydProps :dbReturnFields;
    kSatMultplrs :dbReturnFields;
  begin

        hydProps := GSIO.getDefaults('"6%"');
        kSatMultplrs := GSIO.getDefaults('"7%"');

  with PLRMObj.currentCatchment do
  begin
    for I := 0 to High(sgs) do
    begin
      //maybe overwritten below in if statement by design
      //included for the sake of readability and to avoid else statement:
      for J := 0 to 1 do
      begin
        //% of area column row 0
        sgs[I].Cells[0,J] := '0';
        //initial values of area(ac) column row 0
        sgs[I].Cells[1,J] := '0';
        //imperv imperv area(ac) column row 0
        sgs[I].Cells[2,J] := '0';
        //default dcia
        sgs[I].Cells[3,J] := '100';
        if ((J = 1) and (I > 1)) then sgs[I].Cells[3,J] := '50'; // hardcoded default dcia for non hsc catchs

        //default ksat vals  8/14/09 apply ksat reduction factors from database
        sgs[I].Cells[4,J] := FormatFloat('0.##',(StrToFloat(soilsInfData[0,1]) * StrToFloat(kSatMultplrs[0][I])));
        //default slopes
        //sgs[I].Cells[5,J] := FloatToStr(PLRMObj.currentCatchment.slope); //swmmCatch.Data[UProject.SUBCATCH_SLOPE_INDEX];
        //default pervious area depression storage
        sgs[I].Cells[5,J] := hydProps[0][2];   //note that row 0 and 1 are mannings values in hydProps
        //default impervious area depression storage
        sgs[I].Cells[6,J] := hydProps[0][3];
      end;
    end;

//Road areas drain to pervious dispersion defaults
  sgSecRds.Cells[0,2] := '100';
  sgSecRds.Cells[1,2] := '0';
  sgSecRds.Cells[2,2] := '0';
  sgSecRds.Cells[3,2] := '50'; // hardcoded default dcia for non hsc catchs

  sgSecRds.Cells[4,2] := FormatFloat('0.##',StrToFloat(soilsInfData[0,1]) * StrToFloat(kSatMultplrs[0][1])); // 8/14/09 apply ksat reduction factors from database
  //default pervious area depression storage
  sgSecRds.Cells[5,2] := hydProps[0][2];   //note that row 0 and 1 are mannings values in hydProps
  //default impervious area depression storage
  sgSecRds.Cells[6,2] := hydProps[0][3];

  sgPrimRds.Cells[0,2] := '100';
  sgPrimRds.Cells[1,2] := '0';
  sgPrimRds.Cells[2,2] := '0';
  sgPrimRds.Cells[3,2] := '50'; // hardcoded default dcia for non hsc catchs

  sgPrimRds.Cells[4,2] := FormatFloat('0.##',StrToFloat(soilsInfData[0,1])  * StrToFloat(kSatMultplrs[0][0]));
  //default pervious area depression storage
  sgPrimRds.Cells[5,2] := hydProps[0][2];   //note that row 0 and 1 are mannings values in hydProps
  //default impervious area depression storage
  sgPrimRds.Cells[6,2] := hydProps[0][3];

  //area(ac) column
  for I := 0 to High(curAcVals) do
  begin
     curAcVals[I] := PLRMobj.getCurCatchLuseProp(GSUtils.frmsLuses[I],3,hasLuse[I]);
     curImpPrctVals[I] := PLRMobj.getCurCatchLuseProp(GSUtils.frmsLuses[I],2,hasLuse[I]);
  end;

  //primary road areas
  if hasLuse[0] = true then
  begin
    sgPrimRds.Cells[1,2] := FormatFloat('0.##',curAcVals[0]);
    sgPrimRds.Cells[2,2] := FormatFloat('0.##',curImpPrctVals[0]*curAcVals[0]/100);
  end;
  //secondary road areas
  if hasLuse[1] = true then
  begin
    sgSecRds.Cells[1,2] := FormatFloat('0.##',curAcVals[1]);
    sgSecRds.Cells[2,2] := FormatFloat('0.##',curImpPrctVals[1]*curAcVals[1]/100);
  end;


  for J := 2 to High(sgs)-1 do
  begin
    if hasLuse[J] = true then
    begin
        prcnt :=  StrToFloat(bmpImpl[J-2,2]);
        sgs[J].Cells[0,0] := bmpImpl[J-2,2];
        sgs[J].Cells[0,1] := FloatToStr(100 - prcnt);
        sgs[J].Cells[1,0] := FormatFloat('0.##',(prcnt*curAcVals[J]/100));
        sgs[J].Cells[1,1] := FormatFloat('0.##',((100 - prcnt)*curAcVals[J]/100));
        sgs[J].Cells[2,0] := FormatFloat('0.##',(prcnt*curImpPrctVals[J]*curAcVals[J]/100/100));
        sgs[J].Cells[2,1] := FormatFloat('0.##',((100-prcnt)*curImpPrctVals[J]*curAcVals[J]/100/100));
    end;
  end;
    //Vgt grid has only one row so different
    J := High(sgs) -1;
    prcnt :=  StrToFloat(bmpImpl[J-2,2]);
    sgVeg.Cells[0,0] := '100';
    sgVeg.Cells[1,0] := FormatFloat('0.##',((100 - prcnt)*curAcVals[J]/100));
    sgVeg.Cells[2,0] := FormatFloat('0.##',((100-prcnt)*curImpPrctVals[J]*curAcVals[J]/100/100));
    sgVeg.Cells[3,0] := '50';

    //Othr grid also has only one row so different
    J := High(sgs);
    prcnt :=  100;
    sgOthr.Cells[0,0] := '100';
    sgOthr.Cells[1,0] := FormatFloat('0.##',(PLRMObj.currentCatchment.othrArea));
    sgOthr.Cells[2,0] := FormatFloat('0.##',(PLRMObj.currentCatchment.othrPrcntImpv));
    sgOthr.Cells[3,0] := '50';
   // lblCatchArea.Caption := 'Selected Catchment Area is: ' + FloatToStr(area) + 'ac';

   lblPrrHdr.Caption := 'Primary Roads ( ' + FormatFloat('0.##',strToFloat(sgPrimRds.Cells[1,2])) + ' acres)';
   lblSerHdr.Caption := 'Secondary Roads ( ' + FormatFloat('0.##',strToFloat( sgSecRds.Cells[1,2])) + ' acres)';
   lblSfrHdr.Caption := 'Single Family Residential ( ' + FormatFloat('0.##',strToFloat( sgSFR.Cells[1,1])) + ' acres)';
   lblMfrHdr.Caption := 'Multi-Family Residential ( ' + FormatFloat('0.##',strToFloat( sgMFR.Cells[1,1])) + ' acres)';
   lblCicHdr.Caption := 'CICU ( ' + FormatFloat('0.##',strToFloat(sgCICU.Cells[1,1])) + ' acres)';
   lblVegHdr.Caption := 'Vegetated Turf ( ' + FormatFloat('0.##',strToFloat(sgVeg.Cells[1,0])) + ' acres)';
   lblOthHdr.Caption := 'All Others ( ' + FormatFloat('0.##',strToFloat(sgOthr.Cells[1,0])) + ' acres)';
  end;
end;

procedure TPLRMDrainageConditions.restoreFormContents(catch: TPLRMCatch);
  var
    hasLuse :array[0..6] of Boolean;
    I,J : Integer;
    prcnt : Double;
    test:boolean;
  begin

    with PLRMObj.currentCatchment do
    begin
      if (assigned(PLRMObj.currentCatchment.primRdDrng)) then
      //if ((assigned(PLRMObj.currentCatchment.primRdDrng)) and (GSPLRM.PLRMObj.currentCatchment.hasChangedSoils = false)) then
      begin
        hasLuse[0] := true;
        copyContentsToGridNChk(PLRMObj.currentCatchment.primRdDrng,0,0,sgPrimRds);
      end;
      if (assigned(PLRMObj.currentCatchment.secRdDrng)) then
      //if ((assigned(PLRMObj.currentCatchment.secRdDrng)) and (GSPLRM.PLRMObj.currentCatchment.hasChangedSoils = false)) then
      begin
        hasLuse[1] := true;
        copyContentsToGridNChk(PLRMObj.currentCatchment.secRdDrng,0,0,sgSecRds);
      end;
      if (assigned(PLRMObj.currentCatchment.sfrDrng)) then
      //if ((assigned(PLRMObj.currentCatchment.sfrDrng)) and (GSPLRM.PLRMObj.currentCatchment.hasChangedSoils = false)) then
      begin
        hasLuse[2] := true;
        copyContentsToGridNChk(PLRMObj.currentCatchment.sfrDrng,0,0,sgSFR);
      end;
      if (assigned(PLRMObj.currentCatchment.mfrDrng)) then
      //if ((assigned(PLRMObj.currentCatchment.mfrDrng)) and (GSPLRM.PLRMObj.currentCatchment.hasChangedSoils = false)) then
      begin
        hasLuse[3] := true;
        copyContentsToGridNChk(PLRMObj.currentCatchment.mfrDrng,0,0,sgMFR);
      end;
      if (assigned(PLRMObj.currentCatchment.cicuDrng)) then
      //if ((assigned(PLRMObj.currentCatchment.cicuDrng)) and (GSPLRM.PLRMObj.currentCatchment.hasChangedSoils = false)) then
      begin
        hasLuse[4] := true;
        copyContentsToGridNChk(PLRMObj.currentCatchment.cicuDrng,0,0,sgCICU);
      end;
      if (assigned(PLRMObj.currentCatchment.vegTDrng)) then
      //if ((assigned(PLRMObj.currentCatchment.vegTDrng)) and (GSPLRM.PLRMObj.currentCatchment.hasChangedSoils = false)) then
      begin
        hasLuse[5] := true;
        copyContentsToGridNChk(PLRMObj.currentCatchment.vegTDrng,0,0,sgVeg);
      end;
      if (assigned(PLRMObj.currentCatchment.othrDrng)) then
      //if ((assigned(PLRMObj.currentCatchment.othrDrng)) and (GSPLRM.PLRMObj.currentCatchment.hasChangedSoils = false)) then
      begin
        hasLuse[6] := true;
        copyContentsToGridNChk(PLRMObj.currentCatchment.othrDrng,0,0,sgOthr);
      end;

      //area(ac) column
      for I := 0 to High(curAcVals) do
      begin
        curAcVals[I] := PLRMobj.getCurCatchLuseProp(GSUtils.frmsLuses[I],3,hasLuse[I]);
        curImpPrctVals[I] := PLRMobj.getCurCatchLuseProp(GSUtils.frmsLuses[I],2,hasLuse[I]);
      end;

      //primary road areas
      if hasLuse[0] = true then
      begin
        sgPrimRds.Cells[1,2] := FormatFloat('0.##',(curAcVals[0]));
        sgPrimRds.Cells[2,2] := FormatFloat('0.##',(curImpPrctVals[0]*curAcVals[0]/100));
      end;
      //secondary road areas
      if hasLuse[1] = true then
      begin
        sgSecRds.Cells[1,2] := FormatFloat('0.##',(curAcVals[1]));
        sgSecRds.Cells[2,2] := FormatFloat('0.##',(curImpPrctVals[1]*curAcVals[1]/100));
      end;

      for J := 2 to High(sgs)-1 do
      begin
        if hasLuse[J] = true then
        begin
          prcnt :=  StrToFloat(bmpImpl[J-2,2]);
          sgs[J].Cells[0,0] := bmpImpl[J-2,2];
          sgs[J].Cells[0,1] := FloatToStr(100 - prcnt);
          sgs[J].Cells[1,0] := FormatFloat('0.##',(prcnt*curAcVals[J]/100));
          sgs[J].Cells[1,1] := FormatFloat('0.##',((100 - prcnt)*curAcVals[J]/100));
          sgs[J].Cells[2,0] := FormatFloat('0.##',(prcnt*curImpPrctVals[J]*curAcVals[J]/100/100));
          sgs[J].Cells[2,1] := FormatFloat('0.##',((100-prcnt)*curImpPrctVals[J]*curAcVals[J]/100/100));
      end;
    end;
    //Vgt grid has only one row so different
    J := High(sgs) -1;
    prcnt :=  StrToFloat(bmpImpl[J-2,2]);
    sgVeg.Cells[0,0] := '100';
    sgVeg.Cells[1,0] := FormatFloat('0.##',((100 - prcnt)*curAcVals[J]/100));
    sgVeg.Cells[2,0] := FormatFloat('0.##',((100-prcnt)*curImpPrctVals[J]*curAcVals[J]/100/100));

    //Othr grid also has only one row so different
    J := High(sgs);
    prcnt :=  100;
    sgOthr.Cells[0,0] := '100';
    sgOthr.Cells[1,0] := FormatFloat('0.##',(PLRMObj.currentCatchment.othrArea));
    sgOthr.Cells[2,0] := FormatFloat('0.##',(PLRMObj.currentCatchment.othrPrcntImpv * PLRMObj.currentCatchment.othrArea/100));

   lblPrrHdr.Caption := 'Primary Roads ( ' + FormatFloat('0.##',curAcVals[0]) + ' acres)';
   lblSerHdr.Caption := 'Secondary Roads ( ' + FormatFloat('0.##',curAcVals[1]) + ' acres)';
   lblSfrHdr.Caption := 'Single Family Residential ( ' + FormatFloat('0.##',curAcVals[2]) + ' acres)';
   lblMfrHdr.Caption := 'Multi-Family Residential ( ' + FormatFloat('0.##',curAcVals[3]) + ' acres)';
   lblCicHdr.Caption := 'CICU ( ' + FormatFloat('0.##',curAcVals[4]) + ' acres)';
   lblVegHdr.Caption := 'Vegetated Turf ( ' + FormatFloat('0.##',curAcVals[5]) + ' acres)';
   lblOthHdr.Caption := 'All Others ( ' + FormatFloat('0.##',strToFloat(sgOthr.Cells[1,0])) + ' acres)';

   updateCalcs(sgPrimRds);
   updateCalcs(sgSecRds);
  end;
end;

procedure TPLRMDrainageConditions.FormCreate(Sender: TObject);
var
  tempInt,I : Integer;
begin
    statBar.SimpleText := PLRMVERSION;
    Self.Caption := PLRM5_TITLE;
    lblCatchArea.Caption := 'Catchment ID: ' + PLRMObj.currentCatchment.swmmCatch.ID + '   [ Area: ' + PLRMobj.currentCatchment.swmmCatch.Data[UProject.SUBCATCH_AREA_INDEX] + 'ac ]';

    //use arrays for less verbose code
    sgs[0] := sgPrimRds;
    sgs[1] := sgSecRds;
    sgs[2] := sgSFR;
    sgs[3] := sgMFR;
    sgs[4] := sgCICU;
    sgs[5] := sgVeg;
    sgs[6] := sgOthr;

    tempInt := PLRMObj.getCatchIndex(initCatchID);
    cbxGlobalSpecfc.items := PLRMObj.catchments; // loads catchments into combo box
    cbxGlobalSpecfc.ItemIndex := tempInt;
    PLRMObj.currentCatchment := PLRMObj.catchments.Objects[tempInt] as TPLRMCatch;
    curCatchArea := StrToFloat(PLRMobj.currentCatchment.swmmCatch.Data[UProject.SUBCATCH_AREA_INDEX]);


  for I := 0 to High(PLRMObj.currentCatchment.primRdSchms)do
    getHydSchemes(PLRMObj.currentCatchment.primRdSchms[I], I,HYDSCHMEXTS[I], 'Roads', 'Prr');

  for I := 0 to High(PLRMObj.currentCatchment.secRdSchms)do
    getHydSchemes(PLRMObj.currentCatchment.secRdSchms[I], I,HYDSCHMEXTS[I], 'Roads', 'Ser');

   for I := 0 to High(PLRMObj.currentCatchment.sfrSchms)-1 do
    getHydSchemes(PLRMObj.currentCatchment.sfrSchms[I], I,HYDSCHMEXTS[I+3], 'Parcels', 'Sfr');

  for I := 0 to High(PLRMObj.currentCatchment.mfrSchms)-1 do
    getHydSchemes(PLRMObj.currentCatchment.mfrSchms[I], I,HYDSCHMEXTS[I+3], 'Parcels', 'Mfr');

  for I := 0 to High(PLRMObj.currentCatchment.cicuSchms)-1 do
    getHydSchemes(PLRMObj.currentCatchment.cicuSchms[I], I,HYDSCHMEXTS[I+3], 'Parcels', 'Cic');

  getHydSchemes(PLRMObj.currentCatchment.vegTSchms[0], 0,HYDSCHMEXTS[3], 'Parcels', 'Vgt');
  getHydSchemes(PLRMObj.currentCatchment.othrSchms[0], 0,HYDSCHMEXTS[3], 'Parcels', 'Othr');
  initFormContents(PLRMobj.currentCatchment);
  restoreFormContents(PLRMobj.currentCatchment);

end;

procedure TPLRMDrainageConditions.getHydSchemes(var Schm:TPLRMHydPropsScheme; sType:Integer; ext:String; parcelOrRoad:String; luse:String);
var
  I:Integer;
  TempSchm:TPLRMHydPropsScheme;
begin
    if (Schm <> nil) then  exit;
    //check to see if schemes available from input file and map to catchment schemes
    if (PLRMObj.hydPropsSchemes.Count <> 0) then
    begin
      for I := 0 to PLRMObj.hydPropsSchemes.Count - 1 do
      begin
          TempSchm := PLRMObj.hydPropsSchemes.Objects[I] as TPLRMHydPropsScheme;
          if ((TempSchm.luse = luse) and (TempSchm.stype = stype) and (TempSchm.snowPackID = parcelOrRoad) and (TempSchm.catchName = PLRMObj.currentCatchment.name )) then Schm := TempSchm;
      end;
    end;

    //if no match load default scheme from file
    if (Schm = nil) then
    begin
      loadHydPropsSchemeDb(Schm, ext);
      Schm.luse := luse;
    end;
end;

procedure TPLRMDrainageConditions.checkAndSelectCbxItm(var cbx:TCombobox; scheme:TPLRMHydPropsScheme; schms:TStringList);
var
  tempInt :Integer;
begin
  if (scheme <> nil) then
  begin
    tempInt := schms.indexOf(scheme.name);
    if (tempInt <> -1) then
      cbx.ItemIndex := tempInt
    else
      cbx.ItemIndex := 0;
  end
  else
      cbx.ItemIndex := 0;
end;

  procedure TPLRMDrainageConditions.sgCICUKeyPress(Sender: TObject;
  var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMDrainageConditions.sgGenDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
  begin
  GSUtils.sgGrayOnDrawCell3ColsOnly(Sender,ACol,ARow,Rect,State,1,1,2);
  GSUtils.sgGrayOnDrawCellColAndRow(Sender,ACol, ARow,Rect,State,0,1);
  end;

  procedure TPLRMDrainageConditions.sgGenParcelDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
  begin
  GSUtils.sgGrayOnDrawCell3ColsOnly(Sender,ACol,ARow,Rect,State,0,1,2);
  end;

  procedure TPLRMDrainageConditions.sgRoadGenSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  GSUtils.sgSelectCellWthNonEditCol(Sender,ACol, ARow,CanSelect,1,1,2);
  GSUtils.sgSelectCellWthNonEditColNRow(Sender,ACol, ARow,CanSelect,0,2);
end;

procedure TPLRMDrainageConditions.sgSecRdsKeyPress(Sender: TObject;
  var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMDrainageConditions.sgSFRKeyPress(Sender: TObject; var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMDrainageConditions.sgParcelGenSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  GSUtils.sgSelectCellWthNonEditCol(Sender,ACol, ARow,CanSelect,0,1,2);
end;

  procedure TPLRMDrainageConditions.sgPrimRdsKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMDrainageConditions.sgGenSetEditText(Sender: TObject; ACol,  ARow: Integer; const Value: string);
var
  tempInfFootPrintArea : double;
    tempSum : double;
    irow: Integer;
    sg:TStringGrid;
begin
    sg := Sender as TStringGrid;
    tempSum := 0;
    if sg.Cells[ACol, ARow] <> '' then
    begin
      if ACol = 0  then
      begin
        for irow := 0 to sg.RowCount-2 do
        begin
          if ARow <> irow  then
            tempSum := tempSum + StrToFloat(sg.Cells[ACol, irow])
          else
            tempSum := tempSum + StrToFloat(Value);
          if ((100 - tempSum) > 100) or ((100 - tempSum) < 0) then
          begin
            //ShowMessage('This row must add up to 100. Please enter a different number!');
            ShowMessage('Cell values must not exceed 100% and the sum of all the values in this column must add up to 100%!');
            sg.Cells[ACol,ARow] := prevGridValue;
            Exit;
          end;

          //2014 check for inf facility areas that are really small resulting from
          //subcatments that have small pervious areas
          tempInfFootPrintArea := StrToFloat(sg.Cells[0, 0]) * StrToFloat(sg.Cells[1, 0])/StrToFloat(prevGridValue);
           if ((ACol = 0) and (tempInfFootPrintArea <0.01) and (tempInfFootPrintArea > 0)) then
          begin
            ShowMessage('WARNING: This change will result in an infiltration facility with an area less than 0.01 acres.');
            //sg.Cells[ACol,ARow] := prevGridValue;
            Exit;
          end
        end;
        sg.Cells[0, sg.RowCount-1] := FormatFloat('0.###',(100 - tempSum)); //update last row of first column
        updateCalcs(sg);
      end;

      if ACol = 3 then
      begin
        if (StrToFloat(sg.Cells[ACol,ARow]) > 100) then
        begin
          ShowMessage('Cell values in this column must not exceed 100% !');
          sg.Cells[ACol,ARow] := prevGridValue;
          Exit;
        end;
      end;
    end;
end;

  procedure TPLRMDrainageConditions.sgMFRKeyPress(Sender: TObject; var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMDrainageConditions.sgOthrKeyPress(Sender: TObject;
  var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMDrainageConditions.sgVegDrawCell(Sender: TObject; ACol,  ARow: Integer; Rect: TRect; State: TGridDrawState);
  begin
   GSUtils.sgGrayOnDrawCell3ColsOnly(Sender,ACol,ARow,Rect,State,0,1,2);
  end;

  procedure TPLRMDrainageConditions.sgVegKeyPress(Sender: TObject; var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMDrainageConditions.updateCalcs(sg:TStringGrid);
var
    irow,I: Integer;
    prcntImpv:Double;
    area:Double;
begin
  area := 0;
  prcntImpv := 0;
  for I := 0 to High(sgs) do
    if (sgs[I] = sg) then
    begin
        prcntImpv := curImpPrctVals[I];
        area := curAcVals[I];
    end;

  //only acreage and imperv acreage columns calculated
  for irow := 0 to sg.RowCount-1 do
  begin
    sg.Cells[1, irow] := FormatFloat('0.##',(StrToFloat(sg.Cells[0, irow]) * area/100));
    sg.Cells[2, irow] := FormatFloat('0.##',(StrToFloat(sg.Cells[1, irow]) * prcntImpv/100));
    end;
end;

//used for road grids that need the first column to be editable but not the last cell in the first column
  procedure TPLRMDrainageConditions.sgGenRdSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
  var
    sg:TStringGrid;
begin
  sg := Sender as TStringGrid;
  prevGridValue := sg.Cells[ACol,ARow];
  GSUtils.sgSelectCellWthNonEditCol(Sender,ACol, ARow,CanSelect,1,1,2);
  GSUtils.sgSelectCellWthNonEditColNRow(Sender,ACol, ARow,CanSelect,0,2);
end;
 //used for road grids that need the first column to be editable but not the last cell in the first column

  procedure TPLRMDrainageConditions.sgGenRdDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  GSUtils.sgGrayOnDrawCell3ColsOnly(Sender,ACol,ARow,Rect,State,1,1,2);
  GSUtils.sgGrayOnDrawCellColAndRow(Sender,ACol, ARow,Rect,State,0,2);
end;

  function getDrngCondsInput(catchID: String): TPLRMDrngXtcsData;
  var
    PLRMDrngXts: TPLRMDrainageConditions;
    data : TPLRMDrngXtcsData;
    tempInt : Integer;
  begin
    initCatchID := catchID;
    PLRMDrngXts := TPLRMDrainageConditions.Create(Application);

    try
      tempInt := PLRMDrngXts.ShowModal;
      if tempInt = mrOK then
      begin
        Result := data
      end;
    finally
      PLRMDrngXts.Free;
    end;
    Result := data;
  end;

 procedure TPLRMDrainageConditions.loadHydPropsSchemeDb(var Schm:TPLRMHydPropsScheme;ext:String);
  begin
    PLRMObj.loadHydPropsSchemeFromDb(ext, PLRMObj.currentCatchment.soilsInfData);
    Schm := PLRMObj.hydPropsSchemes.Objects[PLRMObj.curhydPropsSchmID] as TPLRMHydPropsScheme;
    Schm.catchName := PLRMObj.currentCatchment.name ;
    end;
end.
