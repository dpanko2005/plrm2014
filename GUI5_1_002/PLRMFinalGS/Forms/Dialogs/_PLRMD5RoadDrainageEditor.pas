unit _PLRMD5RoadDrainageEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.ComCtrls, UProject, GSUtils, GSTypes, GSPLRM, GSIO,
  GSCatchments,
  _PLRMD6ParcelDrainageAndBMPs;

type
  TPLRMRoadDrainageEditor = class(TForm)
    Image1: TImage;
    lblCatchArea: TLabel;
    lblRoadAcres: TLabel;
    edtICIA: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtDCIA: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    edtDINF: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    edtDPCH: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    edtDINFAveAnnInf: TEdit;
    edtDINFTotStorage: TEdit;
    edtDINFTotSurfArea: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    edtDPCHAveAnnInf: TEdit;
    edtDPCHAveSlope: TEdit;
    edtDPCHLen: TEdit;
    Label15: TLabel;
    edtDPCHWidth: TEdit;
    Label16: TLabel;
    edtDPCHStorDepth: TEdit;
    Label17: TLabel;
    edtShoulderAveAnnInfRate: TEdit;
    statBar: TStatusBar;
    btnOK: TButton;
    lblRoadImpervAcres: TLabel;
    procedure edtDCIAClick(Sender: TObject);
    procedure edtDINFClick(Sender: TObject);
    procedure edtDPCHClick(Sender: TObject);
    procedure edtDCIAKeyPress(Sender: TObject; var Key: Char);
    procedure edtDINFKeyPress(Sender: TObject; var Key: Char);
    procedure edtDPCHKeyPress(Sender: TObject; var Key: Char);
    procedure edtDINFTotSurfAreaKeyPress(Sender: TObject; var Key: Char);
    procedure edtDINFTotStorageKeyPress(Sender: TObject; var Key: Char);
    procedure edtDINFAveAnnInfKeyPress(Sender: TObject; var Key: Char);
    procedure edtDPCHLenKeyPress(Sender: TObject; var Key: Char);
    procedure edtDPCHWidthKeyPress(Sender: TObject; var Key: Char);
    procedure edtDPCHAveAnnInfKeyPress(Sender: TObject; var Key: Char);
    procedure edtDPCHStorDepthKeyPress(Sender: TObject; var Key: Char);
    procedure edtDPCHAveSlopeKeyPress(Sender: TObject; var Key: Char);
    procedure initFormContents(catch: String);
    procedure edtShoulderAveAnnInfRateKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);
    procedure restoreFormContents(catch: TPLRMCatch);
    procedure FormCreate(Sender: TObject);
    procedure edtDCIAKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    function checkAndUpDatePrcntAreas(): Boolean;
    procedure edtDINFKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtDPCHKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtShoulderAveAnnInfRateClick(Sender: TObject);
    procedure edtShoulderAveAnnInfRateKeyPress(Sender: TObject; var Key: Char);
    procedure edtICIAKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

function showRoadRoadDrainageEditorDialog(CatchID: String): Integer;

var
  FrmData: GSRoadDrainageInput;
  catchArea: Double;
  initCatchID: String;

implementation

{$R *.dfm}

var
  tempEdtSavedVal: String;
//  INFParams: GSInfiltrationFacility;
//  PCHParams: GSPervChannelFacility;
  // used to account for no road landuses in parcel grid as of 2014 set to two to
  // compensate for and align arrays that have full set of landuses
  luseOffset: Integer;

function showRoadRoadDrainageEditorDialog(CatchID: String): Integer;
var
  Frm: TPLRMRoadDrainageEditor;
  tempInt: Integer;
begin
  initCatchID := CatchID;
  Frm := TPLRMRoadDrainageEditor.Create(Application);
  try
    tempInt := Frm.ShowModal;
  finally
    Frm.Free;
  end;
  Result := tempInt;
end;

procedure TPLRMRoadDrainageEditor.btnOKClick(Sender: TObject);
var
  errMsgs: TStringList;
  errMsg: String;
  I: Integer;
  almostZero: Double;
begin
  errMsgs := TStringList.Create();
  errMsg := '';
  almostZero := 0.001;

  // Begin validation
  // 1. check slope
  if (StrToFloat(edtDPCHAveSlope.Text) < almostZero) then
    errMsgs.add('Pervious dispersion channel slope must not be zero');

  // 2. if more that 0% draining to inf facility must provide inf size
  if (StrToFloat(edtDINF.Text) > almostZero) and
    ((StrToFloat(edtDINFTotSurfArea.Text) < almostZero) or
    (StrToFloat(edtDINFTotStorage.Text) < almostZero)) then
    errMsgs.add('Please provide dimensions for infiltration facility');

  // 2. if more that 0% draining to pch facility must provide inf size
  if (StrToFloat(edtDPCH.Text) > almostZero) and
    ((StrToFloat(edtDPCHLen.Text) < almostZero) or
    (StrToFloat(edtDPCHWidth.Text) < almostZero) or
    (StrToFloat(edtDPCHStorDepth.Text) < almostZero)) then
    errMsgs.add('Please provide dimensions for pervious channel');
  if (errMsgs.Count <> 0) then
  begin
    for I := 0 to errMsgs.Count - 1 do
      errMsg := errMsg + errMsgs[I] + sLineBreak;

    ShowMessage(errMsg);
    Exit;
  end;
  // save form inputs
  FrmData.DCIA := StrToFloat(edtDCIA.Text);
  FrmData.ICIA := StrToFloat(edtICIA.Text);
  FrmData.DINF := StrToFloat(edtDINF.Text);
  FrmData.DPCH := StrToFloat(edtDPCH.Text);
  FrmData.shoulderAveAnnInfRate := StrToFloat(edtShoulderAveAnnInfRate.Text);

  FrmData.INFFacility.totSurfaceArea := StrToFloat(edtDINFTotSurfArea.Text);
  FrmData.INFFacility.totStorage := StrToFloat(edtDINFTotStorage.Text);
  FrmData.INFFacility.aveAnnInfiltrationRate :=
    StrToFloat(edtDINFAveAnnInf.Text);

  FrmData.PervChanFacility.length := StrToFloat(edtDPCHLen.Text);
  FrmData.PervChanFacility.width := StrToFloat(edtDPCHWidth.Text);
  FrmData.PervChanFacility.aveSlope := StrToFloat(edtDPCHAveSlope.Text);
  FrmData.PervChanFacility.storageDepth := StrToFloat(edtDPCHStorDepth.Text);
  FrmData.PervChanFacility.aveAnnInfiltrationRate :=
    StrToFloat(edtDPCHAveAnnInf.Text);
  FrmData.isAssigned := True;

  PLRMObj.currentCatchment.frm5of6RoadDrainageEditorData := FrmData;

  if (not(assigned(PLRMObj.currentCatchment.soilsInfData))) then
    PLRMObj.currentCatchment.soilsInfData :=
      GSIO.getSoilsProps(PLRMObj.currentCatchment.soilsMapUnitData);
  GSPLRM.PLRMObj.currentCatchment.hasDefRoadDrainage := True;

  ModalResult := mrOk;
end;

procedure TPLRMRoadDrainageEditor.restoreFormContents(catch: TPLRMCatch);
begin
  if (catch.frm5of6RoadDrainageEditorData.isAssigned) then
  begin
    edtDCIA.Text := FormatFloat(ZERODP,
      catch.frm5of6RoadDrainageEditorData.DCIA);
    edtICIA.Text := FormatFloat(ZERODP,
      catch.frm5of6RoadDrainageEditorData.ICIA);
    edtDINF.Text := FormatFloat(ZERODP,
      catch.frm5of6RoadDrainageEditorData.DINF);
    edtDPCH.Text := FormatFloat(ZERODP,
      catch.frm5of6RoadDrainageEditorData.DPCH);

    // if user assigned a custom infiltration rate use it, however if the soils were changed
    //then revert to using default inf rate from soils
    if (PLRMObj.currentCatchment.hasChangedSoils  = false) then
    begin
    {//TODO replace
    if(catch.frm5of6RoadDrainageEditorData.shoulderAveAnnInfRate < minKsat)then
       catch.frm5of6RoadDrainageEditorData.shoulderAveAnnInfRate := minKsat; }

      edtShoulderAveAnnInfRate.Text :=
        FormatFloat(ONEDP,
        catch.frm5of6RoadDrainageEditorData.shoulderAveAnnInfRate);

    end;

    edtDINFTotSurfArea.Text := FormatFloat(ZERODP,
      catch.frm5of6RoadDrainageEditorData.INFFacility.totSurfaceArea);
    edtDINFTotStorage.Text := FormatFloat(ZERODP,
      catch.frm5of6RoadDrainageEditorData.INFFacility.totStorage);
    edtDINFAveAnnInf.Text := FormatFloat(ONEDP,
      catch.frm5of6RoadDrainageEditorData.INFFacility.aveAnnInfiltrationRate);

    edtDPCHLen.Text := FormatFloat(ONEDP,
      catch.frm5of6RoadDrainageEditorData.PervChanFacility.length);
    edtDPCHWidth.Text := FormatFloat(ONEDP,
      catch.frm5of6RoadDrainageEditorData.PervChanFacility.width);
    edtDPCHAveSlope.Text := FormatFloat(ONEDP,
      catch.frm5of6RoadDrainageEditorData.PervChanFacility.aveSlope);
    edtDPCHStorDepth.Text := FormatFloat(ONEDP,
      catch.frm5of6RoadDrainageEditorData.PervChanFacility.storageDepth);
    edtDPCHAveAnnInf.Text := FormatFloat(ONEDP,
      catch.frm5of6RoadDrainageEditorData.PervChanFacility.
      aveAnnInfiltrationRate);
  end;
end;

procedure TPLRMRoadDrainageEditor.edtDCIAClick(Sender: TObject);
begin
  tempEdtSavedVal := edtDCIA.Text;
end;

procedure TPLRMRoadDrainageEditor.edtDCIAKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender, Key, gemPosNumber);
end;

function TPLRMRoadDrainageEditor.checkAndUpDatePrcntAreas(): Boolean;
var
  DCIA, ICIA, DINF, DPCH: Double;
begin
  DCIA := StrToFloat(edtDCIA.Text);
  ICIA := StrToFloat(edtICIA.Text);
  DINF := StrToFloat(edtDINF.Text);
  DPCH := StrToFloat(edtDPCH.Text);

  // update DCIA and then validate for accepted range of 0 - 100
  ICIA := 100 - (DCIA + DINF + DPCH);

  if ((DCIA + ICIA + DINF + DPCH) <> 100) then
  begin
    ShowMessage('Sum of DCIA, ICIA, DINF and DPCH must equal 100%');
    Result := False;
  end;

  if ((DCIA > 100) or (ICIA > 100) or (DINF > 100) or (DPCH > 100) or (DCIA < 0)
    or (ICIA < 0) or (DINF < 0) or (DPCH < 0)) then
  begin
    ShowMessage
      ('Valid values for DCIA, ICIA, DINF and DPCH are integers between 1 and 0');
    Result := False;
  end;

  edtICIA.Text := FormatFloat(ZERODP, ICIA);
  Result := True;
end;

procedure TPLRMRoadDrainageEditor.edtDCIAKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  checkAndUpDatePrcntAreas();
end;

procedure TPLRMRoadDrainageEditor.edtDINFAveAnnInfKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender, Key, gemPosNumber);
end;

procedure TPLRMRoadDrainageEditor.edtDINFClick(Sender: TObject);
begin
  tempEdtSavedVal := edtDINF.Text;
end;

procedure TPLRMRoadDrainageEditor.edtDINFKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender, Key, gemPosNumber);
end;

procedure TPLRMRoadDrainageEditor.edtDINFKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  checkAndUpDatePrcntAreas();
end;

procedure TPLRMRoadDrainageEditor.edtDINFTotStorageKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender, Key, gemPosNumber);
end;

procedure TPLRMRoadDrainageEditor.edtDINFTotSurfAreaKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender, Key, gemPosNumber);
end;

procedure TPLRMRoadDrainageEditor.edtDPCHAveAnnInfKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender, Key, gemPosNumber);
end;

procedure TPLRMRoadDrainageEditor.edtDPCHAveSlopeKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender, Key, gemPosNumber);
end;

procedure TPLRMRoadDrainageEditor.edtDPCHClick(Sender: TObject);
begin
  tempEdtSavedVal := edtDPCH.Text;
end;

procedure TPLRMRoadDrainageEditor.edtDPCHKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender, Key, gemPosNumber);
end;

procedure TPLRMRoadDrainageEditor.edtDPCHKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  checkAndUpDatePrcntAreas();
end;

procedure TPLRMRoadDrainageEditor.edtDPCHLenKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender, Key, gemPosNumber);
end;

procedure TPLRMRoadDrainageEditor.edtDPCHStorDepthKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender, Key, gemPosNumber);
end;

procedure TPLRMRoadDrainageEditor.edtDPCHWidthKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender, Key, gemPosNumber);
end;

procedure TPLRMRoadDrainageEditor.edtICIAKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender, Key, gemPosNumber);
end;

procedure TPLRMRoadDrainageEditor.edtShoulderAveAnnInfRateClick
  (Sender: TObject);
begin
  tempEdtSavedVal := edtShoulderAveAnnInfRate.Text;
end;

procedure TPLRMRoadDrainageEditor.edtShoulderAveAnnInfRateKeyPress
  (Sender: TObject; var Key: Char);
begin
  gsEditKeyPress(Sender, Key, gemPosNumber);
end;

procedure TPLRMRoadDrainageEditor.edtShoulderAveAnnInfRateKeyUp(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  // TODO - validate inf rate

end;

procedure TPLRMRoadDrainageEditor.FormCreate(Sender: TObject);
begin
  luseOffset := 2;
  statBar.SimpleText := PLRMVERSION;
  Self.Caption := PLRMD5_TITLE;

  lblCatchArea.Caption := 'Catchment ID: ' + PLRMObj.currentCatchment.swmmCatch.
    ID + '   [ Area: ' + PLRMObj.currentCatchment.swmmCatch.Data
    [UProject.SUBCATCH_AREA_INDEX] + 'acres ]';

  initFormContents(initCatchID); // also calls updateAreas
  if PLRMObj.currentCatchment.hasDefRoadDrainage = True then
    restoreFormContents(PLRMObj.currentCatchment);
  lblRoadAcres.Caption := 'Road Acres: ' + FormatFloat('#0.0',
    PLRMObj.currentCatchment.totRoadAcres) + ' acres';
  lblRoadImpervAcres.Caption := 'Road Impervious Acres: ' +
    FormatFloat('#0.0', PLRMObj.currentCatchment.totRoadImpervAcres) + ' acres';
end;

procedure TPLRMRoadDrainageEditor.initFormContents(catch: String);
var
//  idx, I: Integer;
//  jdx: Integer;
  hydProps: dbReturnFields;
  kSatMultplrs: dbReturnFields;
begin
  edtDCIA.Text := intToStr(50);
  edtICIA.Text := intToStr(50);
  edtDINF.Text := intToStr(0);
  edtDPCH.Text := intToStr(0);

  edtShoulderAveAnnInfRate.Text := intToStr(0);
  edtDINFAveAnnInf.Text := '0.5';
  edtDPCHAveAnnInf.Text := '0.5';
  edtDPCHAveSlope.Text := '1.0';

  hydProps := GSIO.getDefaults('"6%"');
  kSatMultplrs := GSIO.getDefaults('"7%"');

  if (assigned(PLRMObj.currentCatchment.soilsInfData)) then
  begin
    edtShoulderAveAnnInfRate.Text :=
      FormatFloat('0.##', (StrToFloat(PLRMObj.currentCatchment.soilsInfData[0,
      1]) * StrToFloat(kSatMultplrs[0][1])));
  end;
end;

end.
