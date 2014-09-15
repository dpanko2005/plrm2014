unit _PLRMD7GISTool;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Generics.Collections,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.ComCtrls, GSIO, GSUtils, GSTypes, GSPLRM, GSCatchments, GSGdal, GDal,
  GSInifile,
  UProject,
  Vcl.StdCtrls, Vcl.Grids, Vcl.ExtDlgs;

type
  TPLRMGISTool = class(TForm)
    Image1: TImage;
    statBar: TStatusBar;
    edtCatchShpPath: TEdit;
    Label2: TLabel;
    btnCatchShp: TButton;
    GroupBox1: TGroupBox;
    edtSlopeShpPath: TEdit;
    btnSlopeShp: TButton;
    lblSlopeShp: TLabel;
    edtLuseShpPath: TEdit;
    btnLuseShp: TButton;
    lblLuseShp: TLabel;
    edtSoilsShpPath: TEdit;
    btnSoilsShp: TButton;
    lblSoilsShp: TLabel;
    edtRoadConditionsShpPath: TEdit;
    btnRoadConditionsShp: TButton;
    lblRoadConditionsShp: TLabel;
    edtRoadShouldersShpPath: TEdit;
    btnRoadShouldersShp: TButton;
    lblRoadShouldersShp: TLabel;
    edtRunoffConnectivityShpPath: TEdit;
    btnConnectivityShp: TButton;
    lblConnectivityShp: TLabel;
    GroupBox2: TGroupBox;
    Panel12: TPanel;
    Label21: TLabel;
    pnlManualBMPs: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    sgManualBMPs: TStringGrid;
    Panel4: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    btnBMpsShp: TButton;
    edtBMPShpPath: TEdit;
    lblBMPShp: TLabel;
    btnCancel: TButton;
    btnRun: TButton;
    opnTxtFileDialog: TOpenTextFileDialog;
    rgpSimLength: TRadioGroup;
    lblRgpBMPs: TLabel;
    pnlManualBMPsCont: TPanel;
    lblCurrentItem: TLabel;
    lblPercentComplete: TLabel;
    progrBar: TProgressBar;

    procedure initFormContents();
    procedure enableControlsSavePath(idx: Integer; path: String;
      var nextBtn: TButton; nextLbl: TLabel;
      var pathDict: TDictionary<String, String>);
    function browseToShp(initialDir: String): String;
    function saveXMLFileDialog(initialDir: String): String;
    procedure FormCreate(Sender: TObject);
    procedure btnCatchShpClick(Sender: TObject);
    procedure btnLuseShpClick(Sender: TObject);
    procedure btnSoilsShpClick(Sender: TObject);
    procedure btnSlopeShpClick(Sender: TObject);
    procedure btnRoadConditionsShpClick(Sender: TObject);
    procedure btnRoadShouldersShpClick(Sender: TObject);
    procedure btnConnectivityShpClick(Sender: TObject);
    procedure btnBMpsShpClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure rgpSimLengthClick(Sender: TObject);
    procedure sgManualBMPsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgManualBMPsKeyPress(Sender: TObject; var Key: Char);
    procedure sgManualBMPsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure sgManualBMPsSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PLRMGISTool: TPLRMGISTool;
  gisShpFileDir, prevGridVal: String;
  shpPathInputs: array [0 .. 7] of TEdit;
  btnsArr: array [0 .. 7] of TButton;

implementation

{$R *.dfm}

uses
  _PLRMD7bGISStatus;

function TPLRMGISTool.browseToShp(initialDir: String): String;
var
  openDialog: TOpenDialog; // Open dialog variable
begin
  // Create the open dialog object - assign to our open dialog variable
  openDialog := TOpenDialog.Create(self);

  // Set up the starting directory to be the current one
  openDialog.initialDir := initialDir; // GetCurrentDir;

  // Only allow existing files to be selected
  openDialog.Options := [ofFileMustExist];

  // Allow only .shp files to be selected
  openDialog.Filter := 'All GIS Shapefiles|*.shp';

  // Select shp files as the starting filter type
  openDialog.FilterIndex := 1;

  // Display the open file dialog
  if openDialog.Execute then
  begin
    // ShowMessage('File : ' + openDialog.FileName);
    Result := openDialog.FileName;
  end
  else
  begin
    // ShowMessage('Open file was cancelled');
    Result := '';
  end;
  // Free up the dialog
  openDialog.Free;
end;

function TPLRMGISTool.saveXMLFileDialog(initialDir: String): String;
var
  saveDialog: TSaveDialog; // Save dialog variable
begin
  // Create the save dialog object - assign to our save dialog variable
  saveDialog := TSaveDialog.Create(self);

  // Give the dialog a title
  saveDialog.Title := 'Save PLRM GIS Database File';

  // Set up the starting directory to be the current one
  saveDialog.initialDir := initialDir;

  // Allow only .txt and .doc file types to be saved
  saveDialog.Filter := 'All XML files|*.xml';

  // Set the default extension
  saveDialog.DefaultExt := 'xml';

  // Select text files as the starting filter type
  saveDialog.FilterIndex := 1;

  // Display the open file dialog
  if saveDialog.Execute then
  begin
    // ShowMessage('File : ' + saveDialog.FileName);
    Result := saveDialog.FileName;
  end
  else
  begin
    Result := '';
    // ShowMessage('Save file was cancelled');
  end;

  // Free up the dialog
  saveDialog.Free;
end;

procedure TPLRMGISTool.btnCancelClick(Sender: TObject);
begin
  shpFilesDict.Free;
  self.Close;
end;

procedure TPLRMGISTool.enableControlsSavePath(idx: Integer; path: String;
  var nextBtn: TButton; nextLbl: TLabel;
  var pathDict: TDictionary<String, String>);
begin
  shpPathInputs[idx].Text := path;
  nextBtn.Enabled := True;
  nextLbl.Enabled := True;
  if (pathDict.ContainsKey(shpFileKeys[idx])) then
    pathDict[shpFileKeys[idx]] := path
  else
    shpFilesDict.Add(shpFileKeys[idx], path);
end;

// 1. select catchments shp file
procedure TPLRMGISTool.btnCatchShpClick(Sender: TObject);
var
  tempStr: String;
begin
  // check if previous shp path save then start from its dir
  if (shpFilesDict.ContainsKey(shpFileKeys[0])) then
    gisShpFileDir := ExtractFilePath(shpFilesDict[shpFileKeys[0]]);

  tempStr := browseToShp(gisShpFileDir);
  if (tempStr <> '') then
  begin
    enableControlsSavePath(0, tempStr, btnSlopeShp, lblSlopeShp, shpFilesDict);
  end;
end;

// 2. select slopes shp file
procedure TPLRMGISTool.btnSlopeShpClick(Sender: TObject);
var
  tempStr: String;
begin
  tempStr := browseToShp(gisShpFileDir);
  if (tempStr <> '') then
  begin
    enableControlsSavePath(1, tempStr, btnLuseShp, lblLuseShp, shpFilesDict);
  end;
end;

// 3. select catchments landuses file
procedure TPLRMGISTool.btnLuseShpClick(Sender: TObject);
var
  tempStr: String;
begin
  tempStr := browseToShp(gisShpFileDir);
  if (tempStr <> '') then
  begin
    enableControlsSavePath(2, tempStr, btnSoilsShp, lblSoilsShp, shpFilesDict);
  end;
end;

// 4. select soils shp file
procedure TPLRMGISTool.btnSoilsShpClick(Sender: TObject);
var
  tempStr: String;
begin
  tempStr := browseToShp(gisShpFileDir);
  if (tempStr <> '') then
  begin
    enableControlsSavePath(3, tempStr, btnRoadConditionsShp,
      lblRoadConditionsShp, shpFilesDict);
  end;
end;

// 5. select road conditons file
procedure TPLRMGISTool.btnRoadConditionsShpClick(Sender: TObject);
var
  tempStr: String;
begin
  tempStr := browseToShp(gisShpFileDir);
  if (tempStr <> '') then
  begin
    enableControlsSavePath(4, tempStr, btnRoadShouldersShp, lblRoadShouldersShp,
      shpFilesDict);
  end;
end;

// 6. select road shoulders shp file
procedure TPLRMGISTool.btnRoadShouldersShpClick(Sender: TObject);
var
  tempStr: String;
begin
  tempStr := browseToShp(gisShpFileDir);
  if (tempStr <> '') then
  begin
    enableControlsSavePath(5, tempStr, btnConnectivityShp, lblConnectivityShp,
      shpFilesDict);
  end;
end;

procedure TPLRMGISTool.btnRunClick(Sender: TObject);
var
  tempStr: String;
  tempErrList: TStringList;
  hasManualBMPs: Boolean;
  didValidate: Boolean;
begin
  didValidate := False;

  if (rgpSimLength.ItemIndex = 0) then
    hasManualBMPs := False
  else
    hasManualBMPs := True;

  // Ran validation check and display validation errors
  tempErrList := validateAll(shpFilesDict, progrBar, lblPercentComplete,
    lblCurrentItem, hasManualBMPs, sgManualBMPs);

  if (not(assigned(tempErrList)) or (tempErrList.Count < 1)) then
  begin // errs occured
    didValidate := True;
    tempErrList := TStringList.Create;
    lblCurrentItem.Visible := True;
    lblCurrentItem.Caption := 'Success - GIS validation completed successfully';
  end
  else
  begin
    tempErrList.Add('Please fix errors and try again');
    showGISProgressDialog(tempErrList, True);
  end;

  if (didValidate = True) then
  begin
    // check if previous shp path save then start from its dir
    if ((gisShpFileDir = '') and (shpFilesDict.ContainsKey(shpFileKeys[0])))
    then
      gisShpFileDir := ExtractFilePath(shpFilesDict[shpFileKeys[0]]);

    // let user specify path to save gis db xml file to
    tempStr := saveXMLFileDialog(gisShpFileDir);
    if (tempStr <> '') then
    begin
      gisXMLFilePath := tempStr;
    end
    else
      gisXMLFilePath := defaultGISDir + '\GIS.xml';

    // save form data
    PLRMObj.PLRMGISObj.PLRMGISRec.shpFilesDict := shpFilesDict;
    PLRMObj.PLRMGISObj.PLRMGISRec.manualBMPGridEntries :=
      GSUtils.copyGridContents(0, 0, sgManualBMPs);
    SaveIniFile();

    lblCurrentItem.Caption := 'Intiating GIS processing...';
    lblCurrentItem.Visible := True;
    lblPercentComplete.Visible := True;
    progrBar.Visible := True;

    // Begin actual GIS processing
    tempErrList := runGISOps(gisXMLFilePath, shpFilesDict, progrBar,
      lblPercentComplete, lblCurrentItem, hasManualBMPs, sgManualBMPs);

    if (not(assigned(tempErrList)) or (tempErrList.Count < 1)) then
    begin // errs occured
      tempErrList := TStringList.Create;
      lblCurrentItem.Caption := 'Success - GIS operations completed successfully';
      ShowMessage('Success - GIS operations completed successfully');
    end
    else
      showGISProgressDialog(tempErrList, True);
    self.Close;
  end;
end;

// 7. select connectivity shp file
procedure TPLRMGISTool.btnConnectivityShpClick(Sender: TObject);
var
  tempStr: String;
begin
  tempStr := browseToShp(gisShpFileDir);
  if (tempStr <> '') then
  begin
    rgpSimLength.Enabled := True;
    enableControlsSavePath(6, tempStr, btnBMpsShp, lblRgpBMPs, shpFilesDict);
    lblBMPShp.Enabled := True;
  end;
end;

// 8. select BMps shp file
procedure TPLRMGISTool.btnBMpsShpClick(Sender: TObject);
var
  tempStr: String;
begin
  tempStr := browseToShp(gisShpFileDir);
  if (tempStr <> '') then
  begin
    enableControlsSavePath(7, tempStr, btnBMpsShp, lblRgpBMPs, shpFilesDict);
    btnRun.Enabled := True;
  end;
end;

procedure TPLRMGISTool.FormCreate(Sender: TObject);
// var
// I: Integer;
// tempStr: AnsiString;
begin
  statBar.SimpleText := PLRMVERSION;
  self.Caption := PLRM7GIS_TITLE;
  initFormContents();
end;

procedure TPLRMGISTool.rgpSimLengthClick(Sender: TObject);
var
  idx: Integer;
  isShpMode: Boolean;
begin
  // isShpMode := True;
  idx := rgpSimLength.ItemIndex;
  Assert(idx >= 0); // Sanity check

  if (idx = 0) then // BMP shp input
    isShpMode := True
  else
    isShpMode := False;

  lblBMPShp.Visible := isShpMode;
  btnBMpsShp.Visible := isShpMode;
  edtBMPShpPath.Visible := isShpMode;
  pnlManualBMPs.Enabled := not(isShpMode);
  sgManualBMPs.Enabled := not(isShpMode);
  pnlManualBMPsCont.Visible := not(isShpMode);
end;

procedure TPLRMGISTool.sgManualBMPsDrawCell(Sender: TObject;
  ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  S: String;
  sg: TStringGrid;
begin
  sg := Sender as TStringGrid;
  if ((ACol = 0) or ((ACol = 2) and (ARow = 3))) then
  begin
    sg.Canvas.Brush.Color := cl3DLight;
    sg.Canvas.FillRect(Rect);
    S := sg.Cells[ACol, ARow];
    sg.Canvas.Font.Color := clBlue;
    sg.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure TPLRMGISTool.sgManualBMPsKeyPress(Sender: TObject; var Key: Char);
begin
  gsEditKeyPress(Sender, Key, gemPosNumber);
  btnRun.Enabled := True;
end;

procedure TPLRMGISTool.sgManualBMPsSelectCell(Sender: TObject;
  ACol, ARow: Integer; var CanSelect: Boolean);
begin
  prevGridVal := sgManualBMPs.Cells[ACol, ARow];
  GSUtils.sgSelectCellWthNonEditCol(Sender, ACol, ARow, CanSelect, 0, 0, 0);
  GSUtils.sgSelectCellWthNonEditColNRow(Sender, ACol, ARow, CanSelect, 2, 3);
end;

procedure TPLRMGISTool.sgManualBMPsSetEditText(Sender: TObject;
  ACol, ARow: Integer; const Value: string);
var
  tempSum: Double;
  sg: TStringGrid;
begin
  // tempSum := 0.0;
  sg := Sender as TStringGrid;

  // then check sums to see if they will exceed 100%
  if ((sg.Cells[ACol, ARow] <> '') and (Value <> '') and (ACol <> 0)) then
  begin
    if 1 = ACol then
      tempSum := StrToFloat(Value) + StrToFloat(sg.Cells[2, ARow])
    else
      tempSum := StrToFloat(Value) + StrToFloat(sg.Cells[1, ARow]);

    if ((100 - tempSum) > 100) or ((100 - tempSum) < 0) then
    begin
      ShowMessage
        ('This row must add up to 100. Please enter a different number!');
      Exit;
    end
    else
      sg.Cells[0, ARow] := FloatToStr(100 - tempSum);
  end;
end;

procedure TPLRMGISTool.initFormContents();
var
  I, numberOfShapeFiles: Integer;
  tempEnabledState: Boolean;
begin
  numberOfShapeFiles := 7;

  // save array of buttons for convenient looping
  btnsArr[0] := btnCatchShp;
  btnsArr[1] := btnSlopeShp;
  btnsArr[2] := btnLuseShp;
  btnsArr[3] := btnSoilsShp;
  btnsArr[4] := btnRoadConditionsShp;
  btnsArr[5] := btnRoadShouldersShp;
  btnsArr[6] := btnConnectivityShp;
  btnsArr[7] := btnBMpsShp;

  shpPathInputs[0] := edtCatchShpPath;
  shpPathInputs[1] := edtSlopeShpPath;
  shpPathInputs[2] := edtLuseShpPath;
  shpPathInputs[3] := edtSoilsShpPath;
  shpPathInputs[4] := edtRoadConditionsShpPath;
  shpPathInputs[5] := edtRoadShouldersShpPath;
  shpPathInputs[6] := edtRunoffConnectivityShpPath;
  shpPathInputs[7] := edtBMPShpPath;

  // create data structure for holding shp file paths
  if (not(assigned(shpFilesDict))) then
  begin
    shpFilesDict := TDictionary<String, String>.Create();
    ReadIniFile();
  end;

  shpPathInputs[0] := edtCatchShpPath;
  shpPathInputs[1] := edtSlopeShpPath;
  shpPathInputs[2] := edtLuseShpPath;
  shpPathInputs[3] := edtSoilsShpPath;
  shpPathInputs[4] := edtRoadConditionsShpPath;
  shpPathInputs[5] := edtRoadShouldersShpPath;
  shpPathInputs[6] := edtRunoffConnectivityShpPath;
  shpPathInputs[7] := edtBMPShpPath;

  // retrieve previously saved shp file paths if exists
  for I := 0 to High(shpFileKeys) do
  begin
    if (shpFilesDict.ContainsKey(shpFileKeys[I])) then
      shpPathInputs[I].Text := shpFilesDict[shpFileKeys[I]];
    btnsArr[I].Enabled := True;
    btnsArr[I].Visible := True;
  end;

  // populate no bmp implementation grid with initial values
  sgManualBMPs.Cells[0, 0] := '93';
  sgManualBMPs.Cells[0, 1] := '81';
  sgManualBMPs.Cells[0, 2] := '95';
  sgManualBMPs.Cells[0, 3] := '100';

  sgManualBMPs.Cells[1, 0] := '0';
  sgManualBMPs.Cells[1, 1] := '0';
  sgManualBMPs.Cells[1, 2] := '0';
  sgManualBMPs.Cells[1, 3] := '0';

  sgManualBMPs.Cells[2, 0] := '7';
  sgManualBMPs.Cells[2, 1] := '19';
  sgManualBMPs.Cells[2, 2] := '5';
  sgManualBMPs.Cells[2, 3] := '0';

  sgManualBMPs.Options := sgManualBMPs.Options + [goEditing];

  lblCurrentItem.Visible := False;
  lblPercentComplete.Visible := False;
  progrBar.Visible := False;

  tempEnabledState := btnsArr[0].Enabled and btnsArr[1].Enabled and
    btnsArr[2].Enabled and btnsArr[3].Enabled and btnsArr[4].Enabled and
    btnsArr[5].Enabled and btnsArr[6].Enabled and btnsArr[7].Enabled;

  btnRun.Enabled := tempEnabledState;
  lblRgpBMPs.Enabled := tempEnabledState;
  rgpSimLength.Enabled := tempEnabledState;
end;

end.
