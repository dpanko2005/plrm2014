unit _PLRM3PSCDef;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, xmldom, XMLIntf, msxmldom, XMLDoc,
  Dialogs, StdCtrls, ExtCtrls, jpeg, ComCtrls, _PLRM4RoadConditions, Grids, GSUtils, GSTypes, GSPLRM, GSCatchments,
  _PLRM5RoadDrnXtcs, UProject;

type TDrngXtsData = record
    entity : Integer; // 0 - global, 1 - n for catchments as catchment ID
    luseAreaNPrcnt : PLRMGridData;

    //catchment break down by % coverage of land uses
    secRdsPrcnt : Double;
    primRdsPrcnt : Double;
    sfrPrcnt : Double;
    mfrPrcnt : Double;
    cicuPrcnt : Double;
    vegTPrcnt : Double;
    othrPrcnt : Double;              

    // catchment break down by area of land uses
    secRdsArea : Double;
    primRdsArea : Double;
    sfrArea : Double;
    mfrArea : Double;
    cicuArea : Double;
    vegTArea : Double;
    othrArea : Double;

    // % of road as high risk
    secRdsHighR : Double;
    primRdsHighR : Double;
    // % of road as moderate risk
    secRdsModR : Double;
    primRdsModR : Double;
    // % of road as low risk
    secRdsLowR : Double;
    primRdsLowR : Double;

    // road land use conditions
    secRdsLuseScheme : Double;
    primRdsLuseScheme : Double;

    // road land use drainage characteristics
    secRdsDrngXtcs : Double;
    primRdsDrngXtcs : Double;
  end;

type TPLRMPCSDef = class(TForm)
    Image1: TImage;
    btnOk: TButton;
    btnCloseFrm: TButton;
    GroupBox1: TGroupBox;
    Label8: TLabel;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    Label3: TLabel;
    Label5: TLabel;
    Panel2: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Label17: TLabel;
    edtPrcntSecRdArea: TEdit;
    Edit3: TEdit;
    edtPrimRdArea: TEdit;
    edtSecRdArea: TEdit;
    Label2: TLabel;
    Label18: TLabel;
    Panel3: TPanel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label10: TLabel;
    Panel5: TPanel;
    btnEditPRds: TButton;
    btnEditSRds: TButton;
    cbxSecRdCondsSchm: TComboBox;
    cbxPrimRdCondsSchm: TComboBox;
    GroupBox4: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Panel6: TPanel;
    Label26: TLabel;
    Label27: TLabel;
    Panel8: TPanel;
    Label30: TLabel;
    Panel10: TPanel;
    btnDrngXtcsMfr: TButton;
    btnDrngXtcsSfr: TButton;
    cbxDrngXtcsSfr: TComboBox;
    cbxDrngXtcsMfr: TComboBox;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Panel7: TPanel;
    Label28: TLabel;
    Label29: TLabel;
    edtPrcntSfrArea: TEdit;
    edtPrcntMfrArea: TEdit;
    edtMfrArea: TEdit;
    edtSfrArea: TEdit;
    edtPrcntCicuArea: TEdit;
    edtCicuArea: TEdit;
    edtPrcntVegTArea: TEdit;
    edtVegTArea: TEdit;
    edtOthrArea: TEdit;
    edtPrcntOthrArea: TEdit;
    Label23: TLabel;
    Label38: TLabel;
    cbxDrngXtcsCicu: TComboBox;
    btnDrngXtcsCicu: TButton;
    cbxDrngXtcsVegT: TComboBox;
    btnDrngXtcsVegT: TButton;
    cbxDrngXtcsOthr: TComboBox;
    btnDrngXtcsOthr: TButton;
    statBar: TStatusBar;
    cbxGlobalSpecfc: TComboBox;
    edtPrcntPrimRdArea: TEdit;
    sgBMPImpl: TStringGrid;
    sgRdRiskCat: TStringGrid;
    Panel9: TPanel;
    btnApply: TButton;
    Panel11: TPanel;
    Label1: TLabel;
    lblCatchArea: TLabel;
    btnNewSecRdCondsSchm: TButton;
    btnNewPrimRdCondsSchm: TButton;
    btnLoadSRds: TButton;
    btnLoadPrds: TButton;
    Panel4: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure initFormContents(catch: String);
    function updateChkSum(const ArgsList : array of string ): string;
    procedure populateFrm( var FD : TDrngXtsData);
    procedure btnSecluseClick(Sender: TObject);
    procedure btnPrimluseClick(Sender: TObject);
    procedure sgBMPImplDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgBMPImplSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
    procedure sgRdRiskCatDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgRdRiskCatSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
    procedure btnOkClick(Sender: TObject);
   // procedure btnPreviewParcelCRCsClick(Sender: TObject);
    procedure btnEditSRdsClick(Sender: TObject);
    procedure btnEditPRdsClick(Sender: TObject);
    procedure btnCloseFrmClick(Sender: TObject);
    procedure UpdateAreas();
    procedure cbxGlobalSpecfcChange(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure cbxSecRdCondsSchmChange(Sender: TObject);
    procedure btnNewSecRdCondsSchmClick(Sender: TObject);
    procedure btnLoadSRdsClick(Sender: TObject);

    procedure btnNewPrimRdCondsSchmClick(Sender: TObject);
    procedure btnLoadPrdsClick(Sender: TObject);
    procedure cbxPrimRdCondsSchmChange(Sender: TObject);
    procedure sgBMPImplKeyPress(Sender: TObject; var Key: Char);
    procedure sgRdRiskCatKeyPress(Sender: TObject; var Key: Char);
    procedure sgRdRiskCatSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sgBMPImplSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);

  private
    { Private declarations }
    //procedure loadRdsCondsScheme(var cbx:TCombobox);
    procedure loadRdsCondsScheme(var cbx:TCombobox; filePath:String = '');overload;
    //procedure loadRdsCondsScheme(var cbx:TCombobox; schmID:Integer ; filePath:String = '');overload;
    procedure loadRdsCondsScheme(var Schm:TPLRMRdCondsScheme; schmID:Integer ; filePath:String; const ext:String; const stype:String);overload;

  public
    { Public declarations }
  end;
  procedure getSCandDrngXtrstcsInput(catchID: String);//: TDrngXtsData;

var
  PLRMPCSDef: TPLRMPCSDef;
  FrmLuseConds : TDrngXtsData; //global data structure used to store form input
  initCatchID:String;
   secRdCondsScheme:TPLRMRdCondsScheme;
   primRdCondsScheme:TPLRMRdCondsScheme;
  allDrxXtcs : TPLRMDrngXtcsData;
  parcelCRCs : TParcelCRCArray;
  tempFlag :Integer;

  primRdWts : array[0..2] of double;
  secRdWts : array[0..2] of double;
  prevGridVal:String;
  parcelWts : array[0..5,0..2] of double;
implementation

uses GSIO;

{$R *.dfm}

procedure TPLRMPCSDef.btnCloseFrmClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TPLRMPCSDef.btnEditPRdsClick(Sender: TObject);
begin
    PLRMOBj.currentCatchment.primRdRcSchm := _PLRM4RoadConditions.getRoadCondition(PLRMOBj.currentCatchment.primRdRcSchm,'100')
end;

procedure TPLRMPCSDef.btnEditSRdsClick(Sender: TObject);
begin
    PLRMOBj.currentCatchment.secRdRcSchm := _PLRM4RoadConditions.getRoadCondition(PLRMOBj.currentCatchment.secRdRcSchm ,'101')
end;

procedure TPLRMPCSDef.btnLoadPrdsClick(Sender: TObject);
begin
  loadRdsCondsScheme(cbxPrimRdCondsSchm);
  if primRdCondsScheme <> nil then
  begin
    updateGeneralCbxItems(cbxSecRdCondsSchm, cbxPrimRdCondsSchm);
    if StrToInt(PLRMObj.curRdCondsScheme.id) = -1 then
    begin
      PLRMObj.curRdCondsPropsSchmID := PLRMObj.curRdCondsPropsSchmID + 1;
      PLRMObj.globalSchmID :=  PLRMObj.globalSchmID + 1;
      PLRMObj.curRdCondsScheme.id := IntToStr(PLRMObj.globalSchmID);
      PLRMObj.currentCatchment.secSchmID  := PLRMObj.globalSchmID;
    end
  end;
end;

procedure TPLRMPCSDef.btnLoadSRdsClick(Sender: TObject);
begin
  loadRdsCondsScheme(cbxSecRdCondsSchm);
  if primRdCondsScheme <> nil then
  begin
    updateGeneralCbxItems(cbxPrimRdCondsSchm, cbxSecRdCondsSchm);
    if StrToInt(PLRMObj.curRdCondsScheme.id) = -1 then
    begin
      PLRMObj.curRdCondsPropsSchmID := PLRMObj.curRdCondsPropsSchmID + 1;
      PLRMObj.globalSchmID :=  PLRMObj.globalSchmID + 1;
      PLRMObj.curRdCondsScheme.id := IntToStr(PLRMObj.globalSchmID);
      PLRMObj.currentCatchment.secSchmID  := PLRMObj.globalSchmID;
    end
  end;
end;

 procedure TPLRMPCSDef.loadRdsCondsScheme(var cbx:TCombobox; filePath:String = '');
var
   tempInt: Integer;
   opnFileDlg: TOpenDialog;
   Scheme: TPLRMRdCondsScheme;
   tempStr:String;
  begin

  if filePath = '' then
  begin
    opnFileDlg := TOpenDialog.Create(self);
    opnFileDlg.InitialDir := RCONDSCHMSDIR; //GetCurrentDir;
    opnFileDlg.Options := [ofFileMustExist];
    opnFileDlg.Filter := 'Road Condition Scheme Files(*.' + PRIMRCSCHEXT + ')|*.' + PRIMRCSCHEXT;
    opnFileDlg.FilterIndex := 1;
    if opnFileDlg.Execute then
      filePath := opnfiledlg.FileName
    else
      exit;
   end;

    PLRMObj.loadRdCondsSchemeFromXML(filePath);
    Scheme := PLRMObj.rdCondsSchemes.Objects[PLRMObj.curRdCondsPropsSchmID] as TPLRMRdCondsScheme;

    if ((cbx.Items = nil) or (cbx.Items.count = 0) or (cbx.Items.IndexOf(Scheme.name) = -1)) then
    begin
      ;
    end
    else
    begin
      tempStr := ExtractFileName(filePath);
      tempStr := StringReplace(tempStr, '.' + PRIMRCSCHEXT, '', [rfReplaceAll, rfIgnoreCase]);
      if (cbx.Items.IndexOf(tempStr) <> -1) then
      begin
        ShowMessage('A Scheme with the same name was encountered. Please rename the following scheme and try again: ' + filePath);
        exit;
      end
      else
      begin
        Scheme.name := tempStr;
      end;
    end;
    Scheme.id := intToStr(cbx.Items.count);
    tempInt := cbx.Items.AddObject(Scheme.name, Scheme);
    cbx.ItemIndex  := tempInt
end;

 procedure TPLRMPCSDef.loadRdsCondsScheme(var Schm:TPLRMRdCondsScheme; schmID:Integer ; filePath:String; const ext:String; const stype:String);
var
   tempStr:String;
  begin

    PLRMObj.loadRdCondsSchemeFromXML(filePath);
    Schm := PLRMObj.rdCondsSchemes.Objects[PLRMObj.curRdCondsPropsSchmID] as TPLRMRdCondsScheme;
    Schm.id := intToStr(schmID);
    tempStr := ExtractFileName(filePath);
    tempStr := StringReplace(tempStr, '.' + ext, '', [rfReplaceAll, rfIgnoreCase]);
    Schm.name := tempStr;
    Schm.stype := strToInt(stype);
    Schm.catchName := PLRMObj.currentCatchment.name;
end;

procedure TPLRMPCSDef.btnNewPrimRdCondsSchmClick(Sender: TObject);
begin
   primRdCondsScheme := _PLRM4RoadConditions.getRoadCondition(true,cbxPrimRdCondsSchm,'62%','100');
   if primRdCondsScheme <> nil then
   begin
       updateGeneralCbxItems(cbxSecRdCondsSchm, cbxPrimRdCondsSchm);
       if StrToInt(PLRMObj.curRdCondsScheme.id) = -1 then
       begin
        PLRMObj.curRdCondsPropsSchmID := PLRMObj.curRdCondsPropsSchmID + 1;
        PLRMObj.globalSchmID :=  PLRMObj.globalSchmID + 1;
        PLRMObj.curRdCondsScheme.id := IntToStr(PLRMObj.globalSchmID);
        PLRMObj.currentCatchment.secSchmID  := PLRMObj.globalSchmID;
      end
   end;
end;

procedure TPLRMPCSDef.btnNewSecRdCondsSchmClick(Sender: TObject);
begin
  secRdCondsScheme := _PLRM4RoadConditions.getRoadCondition(true,cbxSecRdCondsSchm,'63%','101');
  if secRdCondsScheme <> nil then
  begin
    updateGeneralCbxItems(cbxPrimRdCondsSchm, cbxSecRdCondsSchm);
    if StrToInt(PLRMObj.curRdCondsScheme.id) = -1 then
    begin
      PLRMObj.curRdCondsPropsSchmID := PLRMObj.curRdCondsPropsSchmID + 1;
      PLRMObj.globalSchmID :=  PLRMObj.globalSchmID + 1;
      PLRMObj.curRdCondsScheme.id := IntToStr(PLRMObj.globalSchmID);
      PLRMObj.currentCatchment.secSchmID  := PLRMObj.globalSchmID;
    end
  end;
end;

procedure TPLRMPCSDef.btnOkClick(Sender: TObject);
var
  I,J:Integer;
 begin
  btnApplyClick(Sender);
  //copy road risk category numbers from grid
  SetLength(PLRMObj.currentCatchment.rdRiskCats,sgRdRiskCat.RowCount,sgRdRiskCat.ColCount);
  SetLength(PLRMObj.currentCatchment.bmpImpl,sgBMPImpl.RowCount,sgBMPImpl.ColCount);
  for I := 0 to sgRdRiskCat.RowCount -1 do
    for J := 0 to sgRdRiskCat.ColCount - 1 do
    begin
      PLRMObj.currentCatchment.rdRiskCats[I,J] := sgRdRiskCat.Cells[J,I];
    end;
  //copy bmp implementation % area numbers for parcel
  for I := 0 to sgBMPImpl.RowCount -1 do
    for J := 0 to sgBMPImpl.ColCount - 1 do
    begin
      PLRMObj.currentCatchment.bmpImpl[I,J] := sgBMPImpl.Cells[J,I];
    end;
  ModalResult := mrOk;
end;

procedure TPLRMPCSDef.btnPrimluseClick(Sender: TObject);
begin
 // used to query for secondary land uses high mod low risk categories
  primRdCondsScheme := _PLRM4RoadConditions.getRoadCondition(false, cbxPrimRdCondsSchm, '62%','100');
   if (tempFlag = 10) or (tempFlag = 30) then
  begin
    tempFlag := 30; //both prim and sec assigned so enable preview crcs button
  end
  else
    tempFlag := 20;
end;

procedure TPLRMPCSDef.btnSecluseClick(Sender: TObject);
begin
 // used to query for secondary land uses high mod low risk categories
  secRdCondsScheme := _PLRM4RoadConditions.getRoadCondition(false, cbxSecRdCondsSchm,'63%','101');
  if (tempFlag = 20) or (tempFlag = 30) then
  begin
    tempFlag := 30; //both prim and sec assigned so enable preview crcs button
  end
  else
    tempFlag := 10;
end;

procedure TPLRMPCSDef.btnApplyClick(Sender: TObject);
begin
//fixed schemes - so primary scheme always 0 and secondary scheme always 1
  PLRMObj.currentCatchment.primSchmID := 0;
  PLRMObj.currentCatchment.secSchmID := 1;
  PLRMObj.currentCatchment.rdRiskCats := GSUtils.copyGridContents(0,0, sgRdRiskCat);
  PLRMObj.currentCatchment.bmpImpl := GSUtils.copyGridContents(0,0, sgBMPImpl);
end;

procedure TPLRMPCSDef.cbxGlobalSpecfcChange(Sender: TObject);
begin
   //set current catchment to the obj coresponding to selected value
    PLRMObj.currentCatchment := GSUtils.getComboBoxSelValue2(Sender) as TPLRMCatch;
    lblCatchArea.Caption := 'Catchment ID:' + PLRMObj.currentCatchment.swmmCatch.ID + '[Area: ' + PLRMobj.currentCatchment.swmmCatch.Data[UProject.SUBCATCH_AREA_INDEX] + 'ac]';
    initFormContents( PLRMObj.currentCatchment.swmmCatch.ID);
end;

procedure TPLRMPCSDef.cbxPrimRdCondsSchmChange(Sender: TObject);
begin
  PLRMObj.currentCatchment.primRdRcSchm := (GSUtils.getComboBoxSelValue2(cbxPrimRdCondsSchm)) as TPLRMRdCondsScheme;
  PLRMObj.curRdCondsPropsSchmID := (Sender as TCombobox).ItemIndex;
  PLRMObj.currentCatchment.primSchmID := PLRMObj.curRdCondsPropsSchmID
end;

procedure TPLRMPCSDef.cbxSecRdCondsSchmChange(Sender: TObject);
begin
  PLRMObj.currentCatchment.secRdRcSchm := (GSUtils.getComboBoxSelValue2(cbxSecRdCondsSchm)) as TPLRMRdCondsScheme;
  PLRMObj.curRdCondsPropsSchmID := (Sender as TCombobox).ItemIndex;
  PLRMObj.currentCatchment.secSchmID := PLRMObj.curRdCondsPropsSchmID;
end;

function TPLRMPCSDef.updateChkSum(const ArgsList : array of string ): string;
var
  n     : integer;
  sum   : double;
begin
  sum := 0;
  for n := Low( ArgsList ) to High( ArgsList ) do
  begin
      if ArgsList[n] <> '' then
        sum := sum + StrToFloat(ArgsList[n]);
  end;
  if sum < 0.001  then
    Result := '0'
  else
    Result := format('%g', [sum]);
end;

procedure TPLRMPCSDef.initFormContents(catch: String);
  var
  idx, I: Integer;
  jdx: Integer;
  tempInt: Integer;
  tempLst : TStringList;
  tempLst2 : TStrings;
  Schm :TPLRMRdCondsScheme;
  begin

  //clear old numbers for new numbers
  for I := 0 to High(FrmLuseConds.luseAreaNPrcnt) do
  begin
    FrmLuseConds.luseAreaNPrcnt[I,0]:= '0';
    FrmLuseConds.luseAreaNPrcnt[I,1]:= '0';
  end;


  edtSecRdArea.Text := '0';
  edtprimRdArea.Text := '0';
  edtSfrArea.Text := '0';
  edtMfrArea.Text := '0';
  edtCicuArea.Text := '0';
  edtVegTArea.Text := '0';
  edtOthrArea.Text := '0';

  edtPrcntSecRdArea.Text := '0';
  edtPrcntPrimRdArea.Text := '0';
  edtPrcntSfrArea.Text := '0';
  edtPrcntMfrArea.Text := '0';
  edtPrcntCicuArea.Text := '0';
  edtPrcntVegTArea.Text := '0';
  edtPrcntOthrArea.Text := '0';

    //populate road risk category grid with initial values
    sgRdRiskCat.Cells[0,0] := '100';
    sgRdRiskCat.Cells[0,1] := '100';
    sgRdRiskCat.Cells[1,0] := '0';
    sgRdRiskCat.Cells[1,1] := '0';
    sgRdRiskCat.Cells[2,0] := '0';
    sgRdRiskCat.Cells[2,1] := '0';
    sgRdRiskCat.Options:=sgBMPImpl.Options+[goEditing];

    //populate bmp implementation grid with initial values
    sgBMPImpl.Cells[0,0] := '100';
    sgBMPImpl.Cells[0,1] := '100';
    sgBMPImpl.Cells[0,2] := '100';
    sgBMPImpl.Cells[0,3] := '100';
    sgBMPImpl.Cells[0,4] := '100';

    for idx := 0 to sgBMPImpl.Rowcount - 1 do
      for jdx := 1 to sgBMPImpl.colCount - 1 do
      begin
        sgBMPImpl.Cells[jdx,idx] := '0';
      end;
    sgBMPImpl.Options:=sgBMPImpl.Options+[goEditing];

  tempInt := PLRMObj.getCatchIndex(catch);
  cbxGlobalSpecfc.items := PLRMObj.catchments; // loads catchments into combo box
  cbxGlobalSpecfc.ItemIndex := tempInt;
  PLRMObj.currentCatchment := PLRMObj.catchments.Objects[tempInt] as TPLRMCatch;

  if ((PLRMObj.currentCatchment.secRdRcSchm = nil) or (PLRMObj.currentCatchment.primRdRcSchm = nil)) then
  begin

    //check to see if schemes available from input file and map to catchment schemes
    if (PLRMObj.rdCondsSchemes.Count <> 0) then
    begin
      for I := 0 to PLRMObj.rdCondsSchemes.Count - 1 do
      begin
        Schm := PLRMObj.rdCondsSchemes.Objects[I] as TPLRMRdCondsScheme;
        if ((Schm.stype = 3) and (Schm.catchName = PLRMObj.currentCatchment.name )) then PLRMObj.currentCatchment.primRdRcSchm := Schm;
        if ((Schm.stype = 4) and (Schm.catchName = PLRMObj.currentCatchment.name)) then PLRMObj.currentCatchment.secRdRcSchm := Schm;
      end;
    end;


    //if no match load default primary road scheme - schmID = 0
     if (PLRMObj.currentCatchment.primRdRcSchm = nil) then
     begin
        tempLst := getFilesInFolder(RCONDSCHMSDIR, '*.' + PRIMRCSCHEXT);
        if (assigned(tempLst) and (tempLst <> nil)) then
        loadRdsCondsScheme(PLRMObj.currentCatchment.primRdRcSchm,PLRMObj.rdCondsSchemes.count,RCONDSCHMSDIR + '\' + tempLst[0],PRIMRCSCHEXT,'3');
        PLRMObj.currentCatchment.primRdRcSchm.isSet := true;
        PLRMObj.currentCatchment.primRdRcSchm.description := 'This is the road conditions scheme';
        PLRMObj.currentCatchment.primRdRcSchm := _PLRM4RoadConditions.getRoadConditionSilent(PLRMOBj.currentCatchment.primRdRcSchm,'100');
     end;
    //load default secondary road scheme - schmid = 1
    if (PLRMObj.currentCatchment.secRdRcSchm = nil) then
    begin
      tempLst2 := getFilesInFolder(RCONDSCHMSDIR, '*.' + SECRCSCHEXT);
      if (assigned(tempLst2) and (tempLst2 <> nil)) then
      loadRdsCondsScheme(PLRMObj.currentCatchment.secRdRcSchm,PLRMObj.rdCondsSchemes.count,RCONDSCHMSDIR + '\' + tempLst2[0],SECRCSCHEXT,'4');
      PLRMObj.currentCatchment.secRdRcSchm.isSet := true;
      PLRMObj.currentCatchment.secRdRcSchm.description := 'This is the road conditions scheme';
      PLRMObj.currentCatchment.secRdRcSchm := _PLRM4RoadConditions.getRoadConditionSilent(PLRMOBj.currentCatchment.secRdRcSchm ,'101');
    end;
 end;

  UpdateAreas;
  end;

//Note: current catchment is set in onchange event of combobox prior to entry of this routine
procedure TPLRMPCSDef.UpdateAreas();
var
  tempInt,I : Integer;
  totArea : Double;
  tempList : TStringList;
  tempOtherArea : Double;
  tempOtherImpvArea:Double;
  begin
    tempOtherArea := 0;
    tempOtherImpvArea:=0;
    tempList := TStringList.Create;
    //Add Landuses to StringList to allow indexof
    for I := 0 to High(frmsLuses) do
    begin
      tempList.Add(frmsLuses[I]);
    end;
    with PLRMObj.currentCatchment do
    begin
      totArea :=  StrToFloat(swmmCatch.Data[UProject.SUBCATCH_AREA_INDEX]);
      for I := 0 to landUseNames.Count-1 do
      begin
        tempInt := tempList.IndexOf(landUseNames[I]);
        if (tempInt > -1) then
        begin
          FrmLuseConds.luseAreaNPrcnt[tempInt,0]:= PLRMObj.currentCatchment.landUseData[I][3];
          FrmLuseConds.luseAreaNPrcnt[tempInt,1]:= FloatToStr(100 * StrToFloat(FrmLuseConds.luseAreaNPrcnt[tempInt,0])/totArea);
        end
        else //lump all other land uses into other areas
        begin
          tempOtherArea := tempOtherArea +   StrToFloat(landUseData[I][3]);
          tempOtherImpvArea := tempOtherImpvArea +   StrToFloat(landUseData[I][2])* StrToFloat(landUseData[I][3]);
        end;
      end;
    end;
    FrmLuseConds.luseAreaNPrcnt[High(frmsLuses),0]:= FloatToStr(tempOtherArea);
    FrmLuseConds.luseAreaNPrcnt[High(frmsLuses),1]:= FloatToStr(100 * tempOtherArea/totArea);
    PLRMObj.currentCatchment.othrArea := tempOtherArea;
    PLRMObj.currentCatchment.othrPrcntToOut := 100; //entire area drains directly to out
    if tempOtherArea = 0 then
      PLRMObj.currentCatchment.othrPrcntImpv := 0
    else
      PLRMObj.currentCatchment.othrPrcntImpv := tempOtherImpvArea/tempOtherArea;

    populateFrm(FrmLuseConds);

    if PLRMObj.currentCatchment.rdRiskCats <> nil then
    begin
      //land uses may have been changed since rdRiskCats last stored. So we check and update numbers in rdRiskCats
      for I := 0 to sgRdRiskCat.RowCount -1 do
      begin
        if FrmLuseConds.luseAreaNPrcnt[I,0] = '0' then
        begin
          PLRMObj.currentCatchment.rdRiskCats[I,0] := '100';
          PLRMObj.currentCatchment.rdRiskCats[I,1] := '0';
          PLRMObj.currentCatchment.rdRiskCats[I,2] := '0';
        end;
      end;
      copyContentsToGrid( PLRMObj.currentCatchment.rdRiskCats, 0,0, sgRdRiskCat);
    end;

    if PLRMObj.currentCatchment.bmpImpl <> nil then
    begin
      //land uses may have been changed since rdRiskCats last stored. So we check and update numbers in rdRiskCats
      for I := 0 to sgBMPImpl.RowCount -1 do
      begin
        if FrmLuseConds.luseAreaNPrcnt[I+2,0] = '0' then
        begin
          PLRMObj.currentCatchment.bmpImpl[I,0] := '100';
          PLRMObj.currentCatchment.bmpImpl[I,1] := '0';
          PLRMObj.currentCatchment.bmpImpl[I,2] := '0';
        end;
      end;
      copyContentsToGrid( PLRMObj.currentCatchment.bmpImpl, 0,0, sgBMPImpl);
    end;
  end;

procedure TPLRMPCSDef.FormCreate(Sender: TObject);
begin
  statBar.SimpleText := PLRMVERSION;
  Self.Caption := PLRM3_TITLE;
  SetLength(FrmLuseConds.luseAreaNPrcnt,High(frmsLuses)+1,2);
  initFormContents(initCatchID); //also calls updateAreas
  lblCatchArea.Caption := 'Catchment ID: ' + PLRMObj.currentCatchment.swmmCatch.ID + '   [ Area: ' + PLRMobj.currentCatchment.swmmCatch.Data[UProject.SUBCATCH_AREA_INDEX] + 'ac ]';

end;

procedure getSCandDrngXtrstcsInput(catchID: String);//: TDrngXtsData;
  var
    PLRMDrngXts: TPLRMPCSDef;
    //tempInt : Integer;
  begin
    initCatchID := catchID;
    PLRMDrngXts := TPLRMPCSDef.Create(Application);
    try
      PLRMDrngXts.ShowModal;
    finally
      PLRMDrngXts.Free;
    end;
  end;

procedure TPLRMPCSDef.populateFrm( var FD : TDrngXtsData);
  begin
    if FrmLuseConds.luseAreaNPrcnt[0,0] <> '' then edtSecRdArea.Text := FrmLuseConds.luseAreaNPrcnt[0,0];
    if FrmLuseConds.luseAreaNPrcnt[1,0] <> '' then edtprimRdArea.Text := FrmLuseConds.luseAreaNPrcnt[1,0];

    if FrmLuseConds.luseAreaNPrcnt[2,0] <> '' then edtSfrArea.Text := FrmLuseConds.luseAreaNPrcnt[2,0];
    if FrmLuseConds.luseAreaNPrcnt[3,0] <> '' then edtMfrArea.Text := FrmLuseConds.luseAreaNPrcnt[3,0];
    if FrmLuseConds.luseAreaNPrcnt[4,0] <> '' then edtCicuArea.Text := FrmLuseConds.luseAreaNPrcnt[4,0];
    if FrmLuseConds.luseAreaNPrcnt[5,0] <> '' then edtVegTArea.Text := FrmLuseConds.luseAreaNPrcnt[5,0];
    if FrmLuseConds.luseAreaNPrcnt[6,0] <> '' then edtOthrArea.Text := FrmLuseConds.luseAreaNPrcnt[6,0];

    if FrmLuseConds.luseAreaNPrcnt[0,1] <> '' then edtPrcntSecRdArea.Text := FrmLuseConds.luseAreaNPrcnt[0,1];
    if FrmLuseConds.luseAreaNPrcnt[1,1] <> '' then edtPrcntPrimRdArea.Text := FrmLuseConds.luseAreaNPrcnt[1,1];

    if FrmLuseConds.luseAreaNPrcnt[2,1] <> '' then edtPrcntSfrArea.Text := FrmLuseConds.luseAreaNPrcnt[2,1];
    if FrmLuseConds.luseAreaNPrcnt[3,1] <> '' then edtPrcntMfrArea.Text := FrmLuseConds.luseAreaNPrcnt[3,1];
    if FrmLuseConds.luseAreaNPrcnt[4,1] <> '' then edtPrcntCicuArea.Text := FrmLuseConds.luseAreaNPrcnt[4,1];
    if FrmLuseConds.luseAreaNPrcnt[5,1] <> '' then edtPrcntVegTArea.Text := FrmLuseConds.luseAreaNPrcnt[5,1];
    if FrmLuseConds.luseAreaNPrcnt[6,1] <> '' then edtPrcntOthrArea.Text := FrmLuseConds.luseAreaNPrcnt[6,1];

  end;

procedure TPLRMPCSDef.sgBMPImplDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var S : String;
begin
  if (ACol=0) then begin //or (ARow = 0 ))then begin
    sgBMPImpl.Canvas.Brush.Color := cl3DLight;
    sgBMPImpl.Canvas.FillRect(Rect);
    S := sgBMPImpl.Cells[ACol, ARow];
    sgBMPImpl.Canvas.Font.Color := clBlue;
    sgBMPImpl.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure TPLRMPCSDef.sgBMPImplKeyPress(Sender: TObject; var Key: Char);
begin
  gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMPCSDef.sgBMPImplSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  prevGridVal := sgBMPImpl.Cells[ACol,ARow];
end;

procedure TPLRMPCSDef.sgBMPImplSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
  var
    tempSum : double;
    idx: Integer;
begin
tempSum := 0.0;
    if sgBMPImpl.Cells[ACol, ARow] <> '' then
    begin
      for idx := 1 to 2 do
        if idx = ACol then
          tempSum := tempSum + StrToFloat(Value)
        else
          tempSum := tempSum + StrToFloat(sgBMPImpl.Cells[idx, ARow]);
      if ((100 - tempSum) > 100) or ((100 - tempSum) < 0) then
      begin
        ShowMessage('This row must add up to 100. Please enter a different number!');
        sgBMPImpl.Cells[ACol, ARow] := prevGridVal;
        Exit;
      end
      else
        sgBMPImpl.Cells[0, ARow] := FloatToStr(100 - tempSum);
    end;
end;

procedure TPLRMPCSDef.sgRdRiskCatDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var S : String;
begin
  if (ACol=0) then begin
    sgRdRiskCat.Canvas.Brush.Color := cl3DLight;
    sgRdRiskCat.Canvas.FillRect(Rect);
    S := sgRdRiskCat.Cells[ACol, ARow];
    sgRdRiskCat.Canvas.Font.Color := clBlue;
    sgRdRiskCat.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure TPLRMPCSDef.sgRdRiskCatKeyPress(Sender: TObject; var Key: Char);
begin
  gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMPCSDef.sgRdRiskCatSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  prevGridVal := sgRdRiskCat.Cells[ACol,ARow];
end;

procedure TPLRMPCSDef.sgRdRiskCatSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
 var
    tempSum : double;
    idx: Integer;
begin
tempSum := 0.0;
    if sgRdRiskCat.Cells[ACol, ARow] <> '' then
    begin
      for idx := 1 to 2 do
        if idx = ACol then
          tempSum := tempSum + StrToFloat(Value)
        else
          tempSum := tempSum + StrToFloat(sgRdRiskCat.Cells[idx, ARow]);
      if ((100 - tempSum) > 100) or ((100 - tempSum) < 0) then
      begin
        ShowMessage('This row must add up to 100. Please enter a different number!');
        sgRdRiskCat.Cells[ACol, ARow] := prevGridVal;
        Exit;
      end
      else
      begin
        sgRdRiskCat.Cells[0, ARow] := FloatToStr(100 - tempSum);
        if Arow = 0 then secRdWts[ACol] := StrToFloat(Value);
        if Arow = 1 then primRdWts[ACol] := StrToFloat(Value);
      end;             
    end;
end;

end.

