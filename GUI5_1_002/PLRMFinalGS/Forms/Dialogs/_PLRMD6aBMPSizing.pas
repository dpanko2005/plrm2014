unit _PLRMD6aBMPSizing;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls,
  Vcl.ComCtrls, Vcl.Imaging.jpeg, GSIO, GSUtils, GSTypes, GSPLRM, GSCatchments,
  UProject;

type
  TPLRMBMPSizing = class(TForm)
    Image1: TImage;
    statBar: TStatusBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label3: TLabel;
    Label9: TLabel;
    Label15: TLabel;
    Panel7: TPanel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Panel4: TPanel;
    Label17: TLabel;
    Label18: TLabel;
    Label5: TLabel;
    sgSFR: TStringGrid;
    PageControl2: TPageControl;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Panel2: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    sgMFR: TStringGrid;
    PageControl3: TPageControl;
    TabSheet3: TTabSheet;
    Label14: TLabel;
    Label16: TLabel;
    Label19: TLabel;
    Panel3: TPanel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Panel5: TPanel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    sgCICU: TStringGrid;
    btnOK: TButton;
    lblCatchArea: TLabel;
    lblCatchImprv: TLabel;
    procedure sgSFRDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure sgSFRKeyPress(Sender: TObject; var Key: Char);
    procedure sgSFRSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure initFormContents(catch: String);
    procedure restoreFormContents(catch: TPLRMCatch);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  // function showPLRMBMPSizingDialog(CatchID: String): Integer;
function showPLRMBMPSizingDialog(CatchID: String; silentMode: Boolean): Integer;

var
  PLRMBMPSizing: TPLRMBMPSizing;
  catchArea: Double;
  initCatchID: String;
  prevGridVal: String;
  // used to account for no road landuses in parcel grid as of 2014 set to two to
  // compensate for and align arrays that have full set of landuses
  luseOffset: Integer;
  // data structure to store form inputs
  // 0 - sgSFR, 1- sgMFR, 2- sgCICU
  frmData: array [0 .. 2] of PLRMGridData;

implementation

{$R *.dfm}

procedure TPLRMBMPSizing.FormCreate(Sender: TObject);
begin
  luseOffset := 2;
  statBar.SimpleText := PLRMVERSION;
  Self.Caption := PLRMD6a_TITLE;
  // SetLength(FrmLuseConds.luseAreaNImpv, High(frmsLuses) + 1, 2);

  lblCatchArea.Caption := 'Catchment ID: ' + PLRMObj.currentCatchment.swmmCatch.
    ID + '   [ Area: ' + PLRMObj.currentCatchment.swmmCatch.Data
    [UProject.SUBCATCH_AREA_INDEX] + 'ac ]';

  initFormContents(initCatchID); // also calls updateAreas
  if PLRMObj.currentCatchment.hasDefParcelAndDrainageBMPs = True then
    restoreFormContents(PLRMObj.currentCatchment);
end;

procedure TPLRMBMPSizing.initFormContents(catch: String);
var
  idx, I: Integer;
  jdx: Integer;
  tempInt: Integer;
  tempLst: TStringList;
  tempLst2: TStrings;

  hydProps: dbReturnFields;
  kSatMultplrs: dbReturnFields;
begin

  // populate default values colums
  sgSFR.Cells[0, 0] := '1';
  sgSFR.Cells[0, 1] := '0.5';

  sgMFR.Cells[0, 0] := '1';
  sgMFR.Cells[0, 1] := '0.5';

  sgCICU.Cells[0, 0] := '1';
  sgCICU.Cells[0, 1] := '0.5';

  // populate units colums
  sgSFR.Cells[1, 0] := 'in';
  sgSFR.Cells[1, 1] := 'in/hr';

  sgMFR.Cells[1, 0] := 'in';
  sgMFR.Cells[1, 1] := 'in/hr';

  sgCICU.Cells[1, 0] := 'in';
  sgCICU.Cells[1, 1] := 'in/hr';

  // populate user values colums
  sgSFR.Cells[2, 0] := '1';
  sgSFR.Cells[2, 1] := '0.5';

  sgMFR.Cells[2, 0] := '1';
  sgMFR.Cells[2, 1] := '0.5';

  sgCICU.Cells[2, 0] := '1';
  sgCICU.Cells[2, 1] := '0.5';

  sgSFR.Options := sgCICU.Options + [goEditing];
  sgMFR.Options := sgCICU.Options + [goEditing];
  sgCICU.Options := sgCICU.Options + [goEditing];
end;

procedure TPLRMBMPSizing.restoreFormContents(catch: TPLRMCatch);
begin
  if (PLRMObj.currentCatchment.hasDefCustomBMPSizeData) then
  begin
    copyContentsToGrid(PLRMObj.currentCatchment.frm6of6aSgBMPSizeSFRData, 2,
      0, sgSFR);
    copyContentsToGrid(PLRMObj.currentCatchment.frm6of6aSgBMPSizeMFRData, 2,
      0, sgMFR);
    copyContentsToGrid(PLRMObj.currentCatchment.frm6of6aSgBMPSizeCICUData, 2,
      0, sgCICU);
  end;
end;

procedure TPLRMBMPSizing.btnOKClick(Sender: TObject);
begin
  // save grid data to current catchment and exit form
  GSPLRM.PLRMObj.currentCatchment.frm6of6aSgBMPSizeSFRData :=
    GSUtils.copyGridContents(2, 0, sgSFR);
  GSPLRM.PLRMObj.currentCatchment.frm6of6aSgBMPSizeMFRData :=
    GSUtils.copyGridContents(2, 0, sgMFR);
  GSPLRM.PLRMObj.currentCatchment.frm6of6aSgBMPSizeCICUData :=
    GSUtils.copyGridContents(2, 0, sgCICU);

  GSPLRM.PLRMObj.currentCatchment.hasDefCustomBMPSizeData := True;
  ModalResult := mrOk;
end;

procedure TPLRMBMPSizing.sgSFRDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  GSUtils.sgGrayOnDrawCell3ColsOnly(Sender, ACol, ARow, Rect, State, 0, 1, 0);
end;

procedure TPLRMBMPSizing.sgSFRKeyPress(Sender: TObject; var Key: Char);
begin
  gsEditKeyPress(Sender, Key, gemPosNumber);
end;

procedure TPLRMBMPSizing.sgSFRSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  GSUtils.sgSelectCellWthNonEditCol(Sender, ACol, ARow, CanSelect, 0, 1, 0);
end;

function showPLRMBMPSizingDialog(CatchID: String; silentMode: Boolean): Integer;
var
  Frm: TPLRMBMPSizing;
  tempInt: Integer;
begin
  initCatchID := CatchID;
  Frm := TPLRMBMPSizing.Create(Application);
  if (silentMode) then
  begin
    Frm.Hide;
    // Frm.Show;
    Frm.initFormContents(PLRMObj.currentCatchment.swmmCatch.ID);
    Frm.btnOKClick(Application);
    // also calls updateAreas
    Result := 1;
    Frm.Close;
    Exit;
  end;
  // else
  // Frm.Visible := True;

  try
    tempInt := Frm.ShowModal;
  finally
    Frm.Free;
  end;
  Result := tempInt;
end;

end.
