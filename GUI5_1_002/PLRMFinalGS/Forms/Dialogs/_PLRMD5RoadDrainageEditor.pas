unit _PLRMD5RoadDrainageEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.ComCtrls, UProject, GSUtils, GSTypes, GSPLRM, GSCatchments,
  _PLRMD6ParcelDrainageAndBMPs;

type
  TPLRMRoadDrainageEditor = class(TForm)
    Image1: TImage;
    lblCatchArea: TLabel;
    lblCatchImprv: TLabel;
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
  INFParams: GSInfiltrationFacility;
  PCHParams: GSPervChannelFacility;
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
end;

procedure TPLRMRoadDrainageEditor.btnOKClick(Sender: TObject);
begin
  // save form inputs
  FrmData.DCIA := strToFloat(edtDCIA.Text);
  FrmData.ICIA := strToFloat(edtICIA.Text);
  FrmData.DINF := strToFloat(edtDINF.Text);
  FrmData.DPCH := strToFloat(edtDPCH.Text);
  FrmData.shoulderAveAnnInfRate := strToFloat(edtShoulderAveAnnInfRate.Text);

  FrmData.INFFacility.totSurfaceArea := strToFloat(edtDINFTotSurfArea.Text);
  FrmData.INFFacility.totStorage := strToFloat(edtDINFTotStorage.Text);
  FrmData.INFFacility.aveAnnInfiltrationRate :=
    strToFloat(edtDINFAveAnnInf.Text);

  FrmData.PervChanFacility.length := strToFloat(edtDPCHLen.Text);
  FrmData.PervChanFacility.width := strToFloat(edtDPCHWidth.Text);
  FrmData.PervChanFacility.aveSlope := strToFloat(edtDPCHAveSlope.Text);
  FrmData.PervChanFacility.storageDepth := strToFloat(edtDPCHStorDepth.Text);
  FrmData.PervChanFacility.aveAnnInfiltrationRate :=
    strToFloat(edtDPCHAveAnnInf.Text);
  FrmData.isAssigned := True;

  PLRMObj.currentCatchment.frm5of6RoadDrainageEditorData := FrmData;
  // launch next form
  showPLRMParcelDrngAndBMPsDialog(PLRMObj.currentCatchment.name);

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
    edtShoulderAveAnnInfRate.Text :=
      FormatFloat(ONEDP,
      catch.frm5of6RoadDrainageEditorData.shoulderAveAnnInfRate);

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
  DCIA := strToFloat(edtDCIA.Text);
  ICIA := strToFloat(edtICIA.Text);
  DINF := strToFloat(edtDINF.Text);
  DPCH := strToFloat(edtDPCH.Text);

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

procedure TPLRMRoadDrainageEditor.edtShoulderAveAnnInfRateClick(
  Sender: TObject);
begin
  tempEdtSavedVal := edtShoulderAveAnnInfRate.Text;
end;

procedure TPLRMRoadDrainageEditor.edtShoulderAveAnnInfRateKeyPress(
  Sender: TObject; var Key: Char);
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
  Self.Caption := PLRM3_TITLE;

  lblCatchArea.Caption := 'Catchment ID: ' + PLRMObj.currentCatchment.swmmCatch.
    ID + '   [ Area: ' + PLRMObj.currentCatchment.swmmCatch.Data
    [UProject.SUBCATCH_AREA_INDEX] + 'ac ]';

  initFormContents(initCatchID); // also calls updateAreas
  restoreFormContents(PLRMObj.currentCatchment);
end;

procedure TPLRMRoadDrainageEditor.initFormContents(catch: String);
var
  idx, I: Integer;
  jdx: Integer;
begin
  edtDCIA.Text := intToStr(50);
  edtICIA.Text := intToStr(50);
  edtDINF.Text := intToStr(0);
  edtDPCH.Text := intToStr(0);

  edtShoulderAveAnnInfRate.Text := intToStr(0);
  edtDINFAveAnnInf.Text := '0.5';
  edtDPCHAveAnnInf.Text := '0.5';
end;

end.
