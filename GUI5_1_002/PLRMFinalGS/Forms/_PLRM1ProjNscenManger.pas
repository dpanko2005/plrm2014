unit _PLRM1ProjNscenManger;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, jpeg, ExtCtrls, GSUtils, GSPLRM, GSTypes, DB,
  ADODB, GSDataAccess,
  _PLRM2ProjNscenEditor, StrUtils, XMLDoc, xmldom, XMLIntf, msxmldom;

type
  TProjNscenManager = class(TForm)
    Image1: TImage;
    GroupBox3: TGroupBox;
    TreeView1: TTreeView;
    f1BtnNwScn: TButton;
    f1BtnCpy: TButton;
    f1BtnDel: TButton;
    f1BtnLoad: TButton;
    f1BtnNxt: TButton;
    f1BtnCncl: TButton;
    f1BtnNwPrj: TButton;
    lblPrjPath: TLabel;
    statBar: TStatusBar;
    btnExitPlrm: TButton;

    procedure FormCreate(Sender: TObject);
    procedure f1BtnCpyClick(Sender: TObject);
    procedure TreeView1DblClick(Sender: TObject);
    procedure f1BtnCnclClick(Sender: TObject);
    procedure f1BtnLoadClick(Sender: TObject);
    procedure f1BtnNwScnClick(Sender: TObject);
    procedure f1BtnNwPrjClick(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure btnExitPlrmClick(Sender: TObject);
  private
    function GetNextPrjID(): String;
    function GetNextScnID(prjNode: TTreeNode): String;
  public
    { Public declarations }
    activeNode: TTreeNode; // active treenode
  end;

procedure getProjManager(firstTimeFlag: Integer = 0);
procedure getProjManagerWithMsg();

var
  ProjScenMangerFrm: TProjNscenManager;
  filespec: string;
  RootNode: TTreeNode;

implementation

uses
  Fmain, GSFileManage, Fmap;

{$R *.dfm}

procedure TProjNscenManager.btnExitPlrmClick(Sender: TObject);
begin
  MainForm.Close();
end;

procedure TProjNscenManager.f1BtnCnclClick(Sender: TObject);
begin
  Close;
  ModalResult := mrCancel;
end;

procedure TProjNscenManager.f1BtnCpyClick(Sender: TObject);
var
  scnFolderPath: String; // folder path
  scnFilePath: String; // full path to scenario.xml file
  scnFilePathOld: String;
  scnID: String; // automatically generated scenario name
  prjNode, scnNode, newPrjNode, newScnNode: TTreeNode;
  prjFolderPath: String; // project folder path
  prjFilePath: String; // full path to project.xml file
  prjID: String; // automatically generated project name
  newPrjID, newScnID: String;
  newPath: String;
  tmpUserName: String;
  tmpSL: TStringList;
  I: Integer;
  prjIdx: Integer;
  tmpScnName: String;

begin
  if not(assigned(TreeView1.selected)) then
    exit;
  if (TreeView1.selected = RootNode) then
  begin
    Application.MessageBox(PChar('Cannot copy root node'), 'APP');
    exit;
  end;

  activeNode := TreeView1.selected;
  // Determine what level the user is at
  if activeNode.Level = 0 then // at the project level
  begin
    // get project directory path
    prjNode := activeNode;
    prjID := PLRMTree.getPrjIDFromUserName(prjNode.Text);
    prjFolderPath := defaultPrjDir + '\' + prjID;
    // assign new project name
    newPrjID := GetNextPrjID();
    newPath := defaultPrjDir + '\' + newPrjID;

    newPath := CopyFolderContents(prjFolderPath, newPath);
    tmpUserName := 'CopyOf' + prjNode.Text;

    // Add new project to the treeview
    newPrjNode := TreeView1.Items.Add(RootNode, tmpUserName);
    activeNode := newPrjNode;
    // store in the form object so can be accessed by the project editor form

    // Load all available scenarios for the new project into the TreeView
    prjIdx := PLRMTree.PID.IndexOf(prjID);
    tmpSL := (PLRMTree.PrjNames.Objects[prjIdx] as TStringList);
    for I := 0 to tmpSL.Count - 1 do
    begin
      tmpScnName := tmpSL[I];
      TreeView1.Items.AddChild(newPrjNode, tmpScnName);
    end;

    // Delete copied Project.xml file because a new one will be created
    prjFilePath := newPath + '\' + prjID + '.xml';
    deleteFileGSNoConfirm(prjFilePath);
    // Update PLRMTree
    PLRMTree.copyPrj(prjID, newPrjID, tmpUserName);

    // Load project parameters from copied project
    prjFilePath := prjFolderPath + '\' + prjID + '.xml';
    PLRMObj.loadFromPrjXML(prjFilePath);

    // Launch project form and force user to provide the project information
    ProjNscenEditorFrm := TProjNscenEditor.Create(Application);
    with ProjNscenEditorFrm do
      try
        begin // it is a new scenario leave scenario editor blank except for project name and working directory
          // Populate project specific-info
          PLRMObj.projUserName := tmpUserName;
          PLRMObj.projFolder := newPath;
          PLRMObj.projXMLPath := prjFilePath;

          tbxProjName.Text := tmpUserName;
          tbxEIPNumber.Text := PLRMObj.eipNum;
          tbxImplAgency.Text := PLRMObj.implAgency;
          tbxProjDescription.Text := PLRMObj.prjDescription;
          tbxMetGrid.Text := PLRMObj.gageID;
          tbxDB.Text := PLRMObj.dbPath;
          grpbxScnInfo.Hide; // hide the scenario information
          btnNext.Hide; // hide the next button
          btnBack.Hide; // hide the back button
        end;
        // tempInt := ProjNscenEditorFrm.ShowModal;
        ProjNscenEditorFrm.ShowModal;
      finally
        Free;
      end;
  end
  else // it is a scenario node; copy within current project folder
  begin
    scnNode := activeNode;
    prjNode := scnNode.Parent;
    prjID := PLRMTree.getPrjIDFromUserName(prjNode.Text);
    prjFolderPath := defaultPrjDir + '\' + prjID;
    scnID := PLRMTree.getScenIDFromUserName(prjID, scnNode.Text);
    scnFolderPath := prjFolderPath + '\' + scnID;

    // assign new scenario name
    newScnID := GetNextScnID(prjNode);
    newPath := prjFolderPath + '\' + newScnID;

    // Copy folder
    newPath := CopyFolderContents(scnFolderPath, newPath);
    tmpUserName := 'CopyOf' + scnNode.Text;

    // Add new scenario to the treeview
    newScnNode := TreeView1.Items.AddChild(prjNode, tmpUserName);
    activeNode := newScnNode;
    // store in the form object so can be accessed by the project editor form

    // Rename copied Scenario.xml file
    scnFilePathOld := newPath + '\' + scnID + '.xml';
    scnFilePath := newPath + '\' + newScnID + '.xml';
    if RenameFile(scnFilePathOld, scnFilePath) = False then
      ShowMessage(scnFilePathOld + ' could not be renamed to ' + scnFilePath);

    PLRMObj.wrkdir := newPath;
    PLRMObj.scenarioName := tmpUserName;
    scnFilePath := newPath + '\' + newScnID + '.xml';

    // Save information to XML doc
    PLRMObj.scenarioXMLFilePath := scnFilePath;
    if FileExists(PLRMObj.scenarioXMLFilePath) = True then // update
      PLRMObj.updateScenarioXML(PLRMObj.scenarioXMLFilePath);

    // Update PLRMTree
    PLRMTree.addNewScn(prjID, newScnID, tmpUserName);
    TreeView1.Select(newScnNode);
    TreeView1DblClick(Sender);
  end;
end;

procedure TProjNscenManager.f1BtnLoadClick(Sender: TObject);
begin
  ProjScenMangerFrm.closeModal;
  ProjNscenEditorFrm := TProjNscenEditor.Create(self);
end;

procedure TProjNscenManager.f1BtnNwPrjClick(Sender: TObject);
var
  newPrjNode: TTreeNode;
  prjName, prjFolder: String;
  scnName: String;
  tempInt: Integer;
  scnFolderPath, scnFilePath: String;
begin
  prjName := GetNextPrjID();
  // Add new project to the treeview
  newPrjNode := TreeView1.Items.Add(RootNode, prjName);
  activeNode := newPrjNode;
  // store in the form object so can be accessed by the project editor form
  scnName := 'Scenario1';
  prjFolder := defaultPrjDir + '\' + prjName;

  // Launch project form and force user to provide the project information
  ProjNscenEditorFrm := TProjNscenEditor.Create(Application);
  with ProjNscenEditorFrm do
    try
      begin // it is a new scenario leave scenario editor blank except for project name and working directory
        // Populate project specific-info
        caption := PLRM2b_TITLE;
        PLRMObj.projUserName := prjName;
        PLRMObj.projFolder := prjFolder;

        tbxProjName.Text := prjName;
        tbxDB.Text := PLRMObj.dbPath;
        grpbxScnInfo.Hide; // hide the scenario information
        btnNext.Hide; // hide the next button
        btnBack.Hide; // hide the back button
      end;
      // //Update PLRMTree
      PLRMTree.addNewPrj(prjName, scnName);
      tempInt := ProjNscenEditorFrm.ShowModal;
    finally
      Free;
    end;

  if tempInt <> mrCancel then
  begin
    TreeView1.Items.AddChild(newPrjNode, scnName);
    scnFolderPath := prjFolder + '\' + scnName;
    checkNCreateDirectory(scnFolderPath);
    scnFilePath := scnFolderPath + '\' + scnName + '.xml';

    PLRMObj.scenarioXMLFilePath := scnFilePath;
    PLRMObj.writeInitProjectToXML(PLRMObj.scenarioXMLFilePath, scnName);
    TreeView1.AutoExpand := True;
  end
  else
    TreeView1.Items.Delete(activeNode);
  // remove the node that was added if user canceled in project editor

end;

procedure TProjNscenManager.f1BtnNwScnClick(Sender: TObject);
var
  // I, J: Integer;
  prjID: String;
  prjName: String;
  scenName: String;
  prjNode, newScnNode: TTreeNode;
  // finished : Boolean;
  // matchCount : Integer;
begin
  if TreeView1.selected = nil then
    ShowMessage
      ('Please select a Project or create a Project for the new Scenario')
  else
  begin

    activeNode := TreeView1.selected;
    if activeNode.Level = 0 then // it is a project node
    begin
      prjNode := activeNode;
      // Add a default scenario to selected project
      scenName := GetNextScnID(prjNode);

      TreeView1.AutoExpand := False;
      newScnNode := TreeView1.Items.AddChild(prjNode, scenName);

      // Update PLRM Tree
      prjName := prjNode.Text;
      prjID := PLRMTree.getPrjIDFromUserName(prjName);
      PLRMTree.addNewScn(prjID, scenName, scenName);
      TreeView1.Select(newScnNode);
      TreeView1DblClick(Sender);
    end
    else // it is a scenario node
      ShowMessage
        ('Please select a Project node or create a new Project to host the new Scenario');
  end;
end;

procedure TProjNscenManager.FormCreate(Sender: TObject);
// var
// projNames : TStringList; //List of matching project names
begin
  initPLRMPaths(); // initials paths and directories used throught plrm
  // Simulate SWMM file new which releases swmm obj as well as PLRMObj in fxn clearall in Fmain
  MainForm.MnuNewClick(Sender);
  FreeAndNil(PLRMObj);
  PLRMObj := TPLRM.Create;
  MainForm.caption := TXT_MAIN_CAPTION + '[Project Name: ' +
    PLRMObj.projUserName + '] [Scenario Name: ' + PLRMObj.scenarioName + ' ]';
  statBar.SimpleText := PLRMVERSION;
  self.caption := PLRM1_TITLE;

  TreeView1.ReadOnly := True;
  FolderLookAddUserName(defaultPrjDir, RootNode, TreeView1);
  TreeView1.AutoExpand := True;
end;

procedure TProjNscenManager.TreeView1Click(Sender: TObject);
var
  // tempInt:Integer;
  scnFolderPath: String; // folder path
  scnFilePath: String; // full path to scenario.xml file
  scnID: String; // automatically generated scenario name
  prjNode: TTreeNode;
  prjFolderPath: String; // project folder path
  // prjFilePath : String;  //full path to project.xml file
  prjID: String; // automatically generated project name
begin
  if TreeView1.selected = nil then
    exit;
  activeNode := TreeView1.selected;

  if activeNode.Level = 0 then // it is a project node
    prjNode := activeNode
  else
    prjNode := activeNode.Parent;

  prjID := PLRMTree.getPrjIDFromUserName(prjNode.Text);
  prjFolderPath := defaultPrjDir + '\' + prjID;

  if activeNode.Level <> 0 then // it is a project node
  begin
    scnID := PLRMTree.getScenIDFromUserName(prjID, activeNode.Text);
    scnFolderPath := prjFolderPath + '\' + scnID;
    scnFilePath := scnFolderPath + '\' + scnID + '.xml';
  end
  else
  begin
    scnFilePath := prjFolderPath;
  end;
  lblPrjPath.caption := 'Project or Scenario Files at: ' + scnFilePath;
end;

procedure TProjNscenManager.TreeView1DblClick(Sender: TObject);
var
  tempInt: Integer;
  scnFolderPath: String; // folder path
  scnFilePath: String; // full path to scenario.xml file
  scnID: String; // automatically generated scenario name
  prjNode, scenNode: TTreeNode;
  prjFolderPath: String; // project folder path
  prjFilePath: String; // full path to project.xml file
  prjID: String; // automatically generated project name
begin
  if TreeView1.selected = nil then
    exit;
  activeNode := TreeView1.selected;
  // public variable so can be accessed by the project editor form

  if activeNode.Level = 0 then // it is a project node
  begin
    prjNode := activeNode;
    // Load project info from project xml file
    prjID := PLRMTree.getPrjIDFromUserName(prjNode.Text);
    prjFolderPath := defaultPrjDir + '\' + prjID;
    prjFilePath := prjFolderPath + '\' + prjID + '.xml';
    PLRMObj.loadFromPrjXML(prjFilePath);
    ProjScenMangerFrm.Hide;
    // Launch project scenario editor form
    ProjNscenEditorFrm := TProjNscenEditor.Create(Application);
    with ProjNscenEditorFrm do
      try
        // Populate project specific-info
        caption := PLRM2b_TITLE;
        tbxProjName.Text := PLRMObj.projUserName;
        tbxEIPNumber.Text := PLRMObj.eipNum;
        tbxImplAgency.Text := PLRMObj.implAgency;
        tbxProjDescription.Text := PLRMObj.prjDescription;
        tbxMetGrid.Text := intToStr(PLRMObj.metgridNum);
        tbxDB.Text := PLRMObj.dbPath;
        { PLRM 2014 moved to TProjNscenEditor.FormCreate
          if PLRMObj.simTypeID = 2 then
          rgpSimLength.Buttons[0].Checked := true
          else
          rgpSimLength.Buttons[1].Checked := true; }

        grpbxScnInfo.Hide; // hide the scenario information
        btnNext.Hide; // hide the next button
        btnBack.Hide; // hide the back button
        // tempInt := ProjNscenEditorFrm.ShowModal;
        ProjNscenEditorFrm.ShowModal;
      finally
        Free;
      end;
    ProjScenMangerFrm.Show;
  end

  else // it is a scenario node
  begin
    scenNode := activeNode;
    prjNode := scenNode.Parent;
    prjID := PLRMTree.getPrjIDFromUserName(prjNode.Text);
    scnID := PLRMTree.getScenIDFromUserName(prjID, scenNode.Text);
    prjFolderPath := defaultPrjDir + '\' + prjID;
    prjFilePath := prjFolderPath + '\' + prjID + '.xml';

    // Check for folders, if they do not exist create them
    scnFolderPath := prjFolderPath + '\' + scnID;
    if checkNCreateDirectory(prjFolderPath) = True then
      checkNCreateDirectory(scnFolderPath);

    scnFilePath := scnFolderPath + '\' + scnID + '.xml';
    PLRMObj.wrkdir := scnFolderPath;
    PLRMObj.scenarioXMLFilePath := scnFilePath;
    ProjScenMangerFrm.closeModal;
    ProjNscenEditorFrm := TProjNscenEditor.Create(Application);

    with ProjNscenEditorFrm do
      try
        btnSave.Hide; // Hide the save button - used for project-only

        if (FileExists(prjFilePath) = False) then
          ShowMessage('Missing Project XML File!!') // load project information
        else
        begin
          // Populate project information
          PLRMObj.loadFromPrjXML(prjFilePath);
          tbxProjName.Text := PLRMObj.projUserName;
          tbxEIPNumber.Text := PLRMObj.eipNum;
          tbxImplAgency.Text := PLRMObj.implAgency;
          tbxProjDescription.Text := PLRMObj.prjDescription;
          tbxMetGrid.Text := intToStr(PLRMObj.metgridNum);
          tbxDB.Text := PLRMObj.dbPath;
        end;

        if (FileExists(scnFilePath) = False) then
        begin // it is a new scenario leave scenario editor blank except for working directory
          PLRMObj.createdBy := '';
          PLRMObj.scenarioName := scnID;
          PLRMObj.scenarioNotes := '';
        end
        else // it is an existing scenario
        begin
          // Load PLRMxml file
          PLRMObj.loadFromXML(scnFilePath);

          // Force working directory to handle the case where the scenario was copied
          PLRMObj.wrkdir := scnFolderPath;

          if (openAndLoadSWMMInptFilefromXML(scnFilePath) = True) then
            PLRMObj.LinkObjsToSWMMObjs();
          // change specific options from ini file
          with MapForm.Map.Options do
          begin
            ShowSubcatchIDs := True;
            ShowNodeIDs := True;
            ShowNodeSymbols := False;
            ShowNodeBorder := False;
            ShowNodeValues := True;
            SubcatchSize := 30;
            NotationSize := 12;
            NodeSize := 20;
          end;
          MapForm.RedrawMap;
        end;

        // Populate scenario information
        tbxCreatedBY.Text := PLRMObj.createdBy;
        tbxWrkDir.Text := PLRMObj.wrkdir;
        tbxScenName.Text := PLRMObj.scenarioName;
        mbxScenarioNotes.Text := PLRMObj.scenarioNotes;

        // PLRM 2014 moved to TProjNscenEditor.FormCreate
        { if PLRMObj.simTypeID = 2 then
          rgpSimLength.Buttons[0].Checked := true
          else
          rgpSimLength.Buttons[1].Checked := true; }

        // Set project fields to read-only and gray out
        tbxProjName.Color := cl3DLight;
        tbxDB.Color := cl3DLight;
        tbxEIPNumber.Color := cl3DLight;
        tbxImplAgency.Color := cl3DLight;
        tbxProjDescription.Color := cl3DLight;
        tbxMetGrid.Color := cl3DLight;
        rgpSimLength.Enabled := False;
        grpbxPrjInfo.Enabled := False;

        // Make working directory uneditable
        tbxWrkDir.Enabled := False; // True;
        tbxWrkDir.Color := cl3DLight;

        tempInt := ProjNscenEditorFrm.ShowModal;
        if tempInt = mrCancel then
          exit;

      finally
        Free;
      end;
    ModalResult := mrOK;
  end;
end;

function TProjNscenManager.GetNextPrjID(): String;
var
  tempName: String;
  prjName: String;
  I, J: Integer;
  finished: Boolean;
  matchCount: Integer;
begin
  finished := False;
  // Read in the name of all siblings and look for Project*, if found, increment to next available number
  J := 0; // New project number counter
  repeat
    J := J + 1;
    prjName := 'Project' + intToStr(J);
    matchCount := 0; // reset number of matched names for this iteration
    for I := 0 to PLRMTree.PID.Count - 1 do
    begin
      tempName := PLRMTree.PID[I];
      if AnsiCompareText(tempName, prjName) = 0 then // match found
      begin
        finished := False;
        matchCount := matchCount + 1;
      end;
    end;
    if matchCount = 0 then
      finished := True; // no matches, can now exit
  until finished;
  Result := prjName;

end;

function TProjNscenManager.GetNextScnID(prjNode: TTreeNode): String;
var
  prjUserName, prjID: String;
  tempName: String;
  scnID: String;
  I, J: Integer;
  finished: Boolean;
  matchCount: Integer;
  scnSL: TStringList;
  prjIdx: Integer;
begin
  finished := False;
  // Read in the name of all siblings and look for Scenario*, if found, increment to next available number
  prjUserName := prjNode.Text;
  prjID := PLRMTree.getPrjIDFromUserName(prjUserName);
  prjIdx := PLRMTree.PID.IndexOf(prjID);
  scnSL := (PLRMTree.PID.Objects[prjIdx] as TStringList);
  J := 0; // New scenario number counter
  repeat
    J := J + 1;
    scnID := 'Scenario' + intToStr(J);
    matchCount := 0; // number of matched names
    for I := 0 to scnSL.Count - 1 do
    begin
      tempName := scnSL[I];
      if AnsiCompareText(tempName, scnID) = 0 then
      // match found, increment counter exit for
      begin
        finished := False;
        matchCount := matchCount + 1
      end;
    end;
    if matchCount = 0 then
      finished := True; // no matches, can now exit
  until finished;
  Result := scnID;
end;

procedure getProjManager(firstTimeFlag: Integer = 0);
var
  buttonSelected: Integer;
begin
  buttonSelected := 0;
  if firstTimeFlag = 0 then
    buttonSelected :=
      MessageDlg('If you proceed the existing project will be closed.' + #13#10
      + 'If you would like to save your work, hit Cancel and' + #13#10 +
      'save when on main form. Proceed?', mtCustom, [mbYes, mbNo, mbCancel], 0);
  if ((buttonSelected = mrNo) or (buttonSelected = mrCancel)) then
    exit;

  ProjScenMangerFrm := TProjNscenManager.Create(Application);
  // tempInt := ProjScenMangerFrm.ShowModal;
  // plrm 2014 ProjScenMangerFrm.Show;
  ProjScenMangerFrm.Show;
  // ProjScenMangerFrm.ShowModal;
end;

// Added Jan 5 2010 as fix for #235
procedure getProjManagerWithMsg();
begin
  if PLRMObj.hasActvScn = True then
    exit;
  // ShowMessage('You are currently working outside a Project and a Scenario' + #13#10 + 'Please create or load a scenario to proceed');
  ShowMessage('You are working outside a Project and a Scenario.' + #13#10 +
    'Hit OK on this form and you will be returned to the' + #13#10 +
    'Project and Scenario Manager.' + #13#10 +
    'Please create or load a Scenario to proceed.');
  getProjManager(1);
end;

end.
