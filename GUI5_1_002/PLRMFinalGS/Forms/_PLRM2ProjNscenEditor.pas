unit _PLRM2ProjNscenEditor;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, Buttons, DB, ADODB, Grids, DBGrids,
  GSDataAccess,
  xmldom, XMLIntf, msxmldom, XMLDoc, FileCtrl, GSUtils, GSPLRM, ComCtrls,
  GSTypes, GSNodes, ShellApi;

type
  TProjNscenEditor = class(TForm)
    Image1: TImage;
    btnNext: TButton;
    btnCloseFrm: TButton;
    grpbxPrjInfo: TGroupBox;
    Label4: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    tbxMetGrid: TEdit;
    tbxProjName: TEdit;
    tbxDB: TEdit;
    btnSelDB: TBitBtn;
    tbxEIPNumber: TEdit;
    tbxProjDescription: TEdit;
    tbxImplAgency: TEdit;
    grpbxScnInfo: TGroupBox;
    Label2: TLabel;
    mbxScenarioNotes: TMemo;
    tbxScenName: TEdit;
    dlgOpenFile: TOpenDialog;
    btnBack: TButton;
    tbxWrkDir: TEdit;
    btnSelWrkDir: TBitBtn;
    Label8: TLabel;
    btnSave: TButton;
    Label10: TLabel;
    tbxCreatedBY: TEdit;
    statBar: TStatusBar;
    rgpSimLength: TRadioGroup;
    Label1: TLabel;
    btnMetGrid: TButton;
    procedure btnNextClick(Sender: TObject);
    procedure btnSelWrkDirClick(Sender: TObject);
    procedure btnSelDBClick(Sender: TObject);
    procedure btnCloseFrmClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label12Click(Sender: TObject);
    procedure Label12MouseEnter(Sender: TObject);
    procedure Label12MouseLeave(Sender: TObject);
    procedure rgpSimLengthClick(Sender: TObject);
    procedure btnMetGridClick(Sender: TObject);
    procedure tbxProjNameKeyPress(Sender: TObject; var Key: Char);
    procedure tbxScenNameKeyPress(Sender: TObject; var Key: Char);
    procedure tbxProjNameExit(Sender: TObject);
    procedure tbxScenNameExit(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ProjNscenEditorFrm: TProjNscenEditor;
  wrkDir: string;

implementation

uses
  Fmain, Uimport, Uglobals,
  GSIO, _PLRM1ProjNscenManger, _PLRM3PSCDef, GSFileManage, _PLRMDprogress;

{$R *.dfm}

procedure TProjNscenEditor.btnBackClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  ProjScenMangerFrm.Show;
end;

procedure TProjNscenEditor.btnCloseFrmClick(Sender: TObject);
begin
  Close;
  ModalResult := mrCancel;
end;

procedure TProjNscenEditor.btnMetGridClick(Sender: TObject);
var
  pdfpath: PAnsiChar;
begin
  pdfpath := PAnsiChar(AnsiString(extractFilePath(Application.ExeName) +
    'Grid_Map.pdf'));
  ShellExecute(Handle, 'Open', @pdfpath, nil, nil, SW_SHOW);
end;

procedure TProjNscenEditor.btnSaveClick(Sender: TObject);
// This saves the project specific information before scenario
var
  prjName: String;
  prjID: String;
  prjIdx: Integer;
begin
  if (tbxMetGrid.Text = '') OR (StrToInt(tbxMetGrid.Text) < 1) OR
    (StrToInt(tbxMetGrid.Text) > 1223) then
  begin
    ShowMessage('Please provide a Met Grid No. between 1 and 1223')
  end
  else
  begin

    // PLRM Edit Jan 2010 edit added to track whether user working with scenario see #233
    if (PLRMObj.projUserName <> tbxProjName.Text) then
    begin
      if (PLRMTree.checkProjNameUsed(tbxProjName.Text) = true) then
      begin
        ShowMessage
          ('The name you have provided is already in use. Please try another name');
        exit;
      end;
    end;
    Screen.Cursor := crHourglass; // because database query may take time

    // Save user's old project name
    prjName := PLRMObj.projUserName;
    prjID := PLRMTree.getPrjIDFromUserName(prjName);
    prjIdx := PLRMTree.PID.IndexOf(prjID);

    PLRMObj.dbPath := tbxDB.Text;
    PLRMObj.metGridNum := StrToInt(tbxMetGrid.Text);
    PLRMObj.gageID := tbxMetGrid.Text;
    PLRMObj.eipNum := tbxEIPNumber.Text;
    PLRMObj.implAgency := tbxImplAgency.Text;
    PLRMObj.createdBy := tbxCreatedBY.Text;
    PLRMObj.prjDescription := tbxProjDescription.Text;
    PLRMObj.projUserName := tbxProjName.Text;

    if rgpSimLength.Buttons[0].Checked = true then
      PLRMObj.simTypeID := 2
    else
      PLRMObj.simTypeID := 1;

    // Update the treeview with User's project name
    prjName := tbxProjName.Text;
    ProjScenMangerFrm.activeNode.Text := prjName;
    PLRMTree.PrjNames[prjIdx] := prjName;

    // Save the project information to a project xml file
    PLRMObj.projXMLPath := PLRMObj.projFolder + '\' + prjID + '.xml';
    if SysUtils.DirectoryExists(PLRMObj.projFolder) = False then
    // need to create both folders
      checkNCreateDirectory(PLRMObj.projFolder);
    PLRMObj.writeInitProjectToXML(PLRMObj.projXMLPath);
    ModalResult := mrOK;
  end;
end;

procedure TProjNscenEditor.btnSelDBClick(Sender: TObject);
begin
  dlgOpenFile.Filter :=
    'Access Database files (*.accdb)|(*.accdb)|Access Database files (*.accdbe)|(*.accdbe)|All files (*.*)|*.*';

  if dlgOpenFile.Execute then
    tbxDB.Text := dlgOpenFile.FileName;
end;

procedure TProjNscenEditor.btnSelWrkDirClick(Sender: TObject);
begin
  if SelectDirectory('Select working directory', defaultPLRMPath, wrkDir) then
    tbxWrkDir.Text := wrkDir;
end;

procedure TProjNscenEditor.FormCreate(Sender: TObject);
begin
  statBar.SimpleText := PLRMVERSION;
  if Caption = '' then
    Self.Caption := PLRM2_TITLE;
end;

procedure TProjNscenEditor.FormShow(Sender: TObject);
begin
  if PLRMObj.simTypeID = 2 then
    Self.rgpSimLength.Buttons[0].Checked := true
  else
    Self.rgpSimLength.Buttons[1].Checked := true;
end;

procedure TProjNscenEditor.Label12Click(Sender: TObject);
begin
  GSUtils.BrowseURL
    ('http://maps.google.com/maps?q=http://sites.google.com/site/unofficialplrm/Home/MetGrid_v2.kml?attredirects=0');
end;

procedure TProjNscenEditor.Label12MouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Height := (Sender as TLabel).Font.Height + 2;
end;

procedure TProjNscenEditor.Label12MouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Height := (Sender as TLabel).Font.Height - 2
end;

procedure TProjNscenEditor.rgpSimLengthClick(Sender: TObject);
begin
  // do nothing, not allowed to change
end;

procedure TProjNscenEditor.tbxProjNameExit(Sender: TObject);
begin
  // Added Jan 5 2010 as fix for #235
  if (PLRMObj.projUserName <> tbxProjName.Text) then
  begin
    if (PLRMTree.checkProjNameUsed(tbxProjName.Text) = true) then
      ShowMessage
        ('The name you have provided is already in use. Please try another name');
  end;
end;

procedure TProjNscenEditor.tbxProjNameKeyPress(Sender: TObject; var Key: Char);
begin
  gsEditKeyPressNoSpace(Sender, Key, gemPosNumber);
end;

procedure TProjNscenEditor.tbxScenNameExit(Sender: TObject);
begin
  // Added Jan 5 2010 as fix for #235
  if (PLRMObj.scenarioName <> tbxScenName.Text) then
  begin
    if (PLRMTree.checkScnNameUsed(tbxProjName.Text, tbxScenName.Text) = true)
    then
      ShowMessage
        ('The name you have provided is already in use. Please try another name');
  end;
end;

procedure TProjNscenEditor.tbxScenNameKeyPress(Sender: TObject; var Key: Char);
begin
  gsEditKeyPressNoSpace(Sender, Key, gemPosNumber);
end;

procedure TProjNscenEditor.btnNextClick(Sender: TObject);
var
  S: TstringList;
  tempInt: Integer;
  prjID: String;
  // prjIdx: Integer;
  scnID: String;

begin
  // PLRM Edit Jan 2010 edit added to track whether user working with scenario see #233
  if (PLRMObj.scenarioName <> tbxScenName.Text) then
  begin
    if (PLRMTree.checkScnNameUsed(tbxProjName.Text, tbxScenName.Text) = true)
    then
    begin
      ShowMessage
        ('The Scenario name you have provided is already in use. Please try another name');
      exit;
    end;
  end;
  // save simulation type
  if rgpSimLength.Buttons[0].Checked = true then
    PLRMObj.simTypeID := 2
  else
    PLRMObj.simTypeID := 1;

  if (tbxMetGrid.Text = '') OR (StrToInt(tbxMetGrid.Text) < 1) OR
    (StrToInt(tbxMetGrid.Text) > 1223) then
  begin
    ShowMessage('Please provide a Met Grid No. between 1 and 1223')
  end
  else
  begin

    PLRMObj.projUserName := ProjScenMangerFrm.activeNode.Parent.Text;
    prjID := PLRMTree.getPrjIDFromUserName(PLRMObj.projUserName);
    // prjIdx := PLRMTree.PID.IndexOf(prjID);
    scnID := PLRMTree.getScenIDFromUserName(prjID, PLRMObj.scenarioName);

    Screen.Cursor := crHourglass; // because database query may take time
    PLRMObj.dbPath := tbxDB.Text;
    PLRMObj.metGridNum := StrToInt(tbxMetGrid.Text);
    PLRMObj.gageID := tbxMetGrid.Text;

    // check if precip and temperature timeseries files exist
    S := TstringList.Create();
    S.Add(defaultDataDir + '\' + intToStr(PLRMObj.metGridNum) + '_Temp.dat');
    S.Add(defaultDataDir + '\' + intToStr(PLRMObj.metGridNum) + '_Precip.dat');
    if ((FileExists(S[0]) = False) or (FileExists(S[1]) = False)) then
    begin
      plrmProgress := TplrmProgress.Create(Application);
      // Create timeseries files if not already available
      tempInt := plrmProgress.ShowModal;
      plrmProgress.Free;
      if tempInt = mrCancel then
      begin
        Close;
        ModalResult := mrCancel;
        exit;
      end;
    end;

    PLRMObj.temptrFilePath := S[0];
    PLRMObj.gageFilePath := S[1];
    // PLRMObj.curSWMMInptFilePath := PLRMObj.wrkdir + '\tempSwmm.inp';
    PLRMObj.curSWMMInptFilePath := PLRMObj.wrkDir + '\' + GSTEMPSWMMINP;
    PLRMObj.userSWMMInptFilePath := PLRMObj.wrkDir + '\swmm.inp';
    PLRMObj.userSWMMRptFilePath := PLRMObj.wrkDir + '\swmm.rpt';

    PLRMObj.eipNum := tbxEIPNumber.Text;
    PLRMObj.implAgency := tbxImplAgency.Text;
    PLRMObj.createdBy := tbxCreatedBY.Text;
    PLRMObj.prjDescription := tbxProjDescription.Text;
    PLRMObj.scenarioName := tbxScenName.Text;
    PLRMObj.scenarioNotes := mbxScenarioNotes.Text;

    Uglobals.TempDir := PLRMObj.wrkDir;

    Screen.Cursor := crDefault; // return cursor to default

    // Save information tgo XML doc
    if FileExists(PLRMObj.scenarioXMLFilePath) = true then // update
      PLRMObj.updateScenarioXML(PLRMObj.scenarioXMLFilePath)
    else
      PLRMObj.plrmToXML;
    MainForm.Caption := Fmain.TXT_MAIN_CAPTION + '[Project Name: ' +
      PLRMObj.projUserName + '] [Scenario Name: ' + PLRMObj.scenarioName + ' ]';
    // PLRM Edit Jan 2010 edit added to track whether user working with scenario see #233
    PLRMObj.hasActvScn := true;
    ModalResult := mrOK;

    // PLRM 2014 additions to manipulate inteface
    MainForm.Menu := nil;
    MainForm.StatusBar.Visible := False;
    // MainForm.MDIChildren[0].SetBounds(100,100,100,100);
    MainForm.MDIChildren[0].WindowState := wsMaximized;
    MainForm.Enabled := true;
    // MainForm.WindowState := wsMaximized;

    ProjNscenEditorFrm.CloseModal;
    ProjScenMangerFrm.Close;
    FreeAndNil(S);
    PLRMTree.Free;
  end;
end;

end.
