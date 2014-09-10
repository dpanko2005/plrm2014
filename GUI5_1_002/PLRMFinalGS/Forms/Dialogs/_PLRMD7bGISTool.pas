unit _PLRMD7bGISTool;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.ComCtrls, GSTypes, GSPLRM, GSUtils, GSCatchments, GSInifile;

type
  TPLRMGISCatchDlg = class(TForm)
    statBar: TStatusBar;
    Image1: TImage;
    edtCatchShpPath: TEdit;
    Label2: TLabel;
    btnCatchShp: TButton;
    lblCatchments: TLabel;
    cbxCatchments: TComboBox;
    Image2: TImage;
    btnCancel: TButton;
    btnOK: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCatchShpClick(Sender: TObject);
    procedure cbxCatchmentsChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure loadGISCatchments(gisXMLFilePath: String);

  private
    { Private declarations }
    function BrowseToXML(initialDir: String): String;
  public
    { Public declarations }
  end;

var
  PLRMGISCatchDlg: TPLRMGISCatchDlg;

implementation

{$R *.dfm}

uses
  Fmain;

procedure TPLRMGISCatchDlg.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  Self.Close;
end;

procedure TPLRMGISCatchDlg.loadGISCatchments(gisXMLFilePath: String);
var
  tGPLRMObj: TPLRM;
begin
  tGPLRMObj := TPLRM.Create;
  tGPLRMObj.loadGISCatchmentsFromXML(gisXMLFilePath);
  if (assigned(tGPLRMObj.nodeAndCatchNames)) then
  begin
    cbxCatchments.items := tGPLRMObj.catchments;
    lblCatchments.Visible := True;
    cbxCatchments.Visible := True;
    edtCatchShpPath.Enabled := True;
  end
  else
    showMessage('Unable to load and proccess GIS Catchments Database');
end;

procedure TPLRMGISCatchDlg.btnCatchShpClick(Sender: TObject);
var
  tempStr: String;
begin

  tempStr := BrowseToXML('junk value');
  if (tempStr <> '') then
  begin
    loadGISCatchments(tempStr);
    edtCatchShpPath.Enabled := True;
    edtCatchShpPath.Text := tempStr;
    gisXMLFilePath := tempStr;
    SaveIniFile();
  end;
end;

procedure TPLRMGISCatchDlg.btnOKClick(Sender: TObject);
begin
  // setup already done in onchange of cbx so trigger catchment creation as
  // if user clicked reqular catchment button
  ModalResult := mrOk;
  Self.Close;
  MainForm.tbPLRMCatchClick(Sender);
end;

procedure TPLRMGISCatchDlg.cbxCatchmentsChange(Sender: TObject);
begin
  PLRMObj.currentGISCatch := GSUtils.getComboBoxSelValue2(Sender) as TPLRMCatch;
  if assigned(PLRMObj.currentGISCatch) then
  begin
    // set things up so GIS catchment created on the canvas rather than regular blank catchment
    PLRMObj.expectingGISCatch := True;
  end
  else
    showMessage(' Invalid catchment selection ');
end;

procedure TPLRMGISCatchDlg.FormCreate(Sender: TObject);
begin
  statBar.SimpleText := PLRMVERSION;
  ReadIniFile(); // updates gisXMLFilePath
  edtCatchShpPath.Text := gisXMLFilePath;
  if FileExists(gisXMLFilePath) then
  begin
    edtCatchShpPath.Enabled := True;
    loadGISCatchments(gisXMLFilePath);
  end
  else
    edtCatchShpPath.Enabled := False;
end;

function TPLRMGISCatchDlg.BrowseToXML(initialDir: String): String;
var
  openDialog: TOpenDialog; // Open dialog variable
begin
  // Create the open dialog object - assign to our open dialog variable
  openDialog := TOpenDialog.Create(Self);

  // Set up the starting directory to be the current one
  // openDialog.initialDir := initialDir; // GetCurrentDir;

  // Only allow existing files to be selected
  openDialog.Options := [ofFileMustExist];

  // Allow only .xml files to be selected
  openDialog.Filter := 'All PLRM GIS DB Files|*.xml';

  // Select xml files as the starting filter type
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

end.
