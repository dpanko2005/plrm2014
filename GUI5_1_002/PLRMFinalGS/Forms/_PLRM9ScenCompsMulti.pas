unit _PLRM9ScenCompsMulti;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, jpeg, ExtCtrls, Grids, GSTypes;

const
  searchStr = 'Average Annual Surface Loading';
  NUMPOLS = 7;

type
  TPLRMScenComps = class(TForm)
    Image1: TImage;
    statBar: TStatusBar;
    GroupBox6: TGroupBox;
    lblPrjName: TLabel;
    Label1: TLabel;
    cbxScenarios: TComboBox;
    lbxScnLeft: TListBox;
    lblLeftLbx: TLabel;
    btnToRight: TButton;
    btnToLeft: TButton;
    lbxScnRight: TListBox;
    lblRightLbx: TLabel;
    Button7: TButton;
    GroupBox1: TGroupBox;
    PageControl2: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    sgReltv: TStringGrid;
    Panel15: TPanel;
    Label7: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Panel1: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    sgAbslut: TStringGrid;
    Label18: TLabel;
    cbxProjects: TComboBox;
    Label2: TLabel;
    Panel2: TPanel;
    Label15: TLabel;
    Panel3: TPanel;
    Label4: TLabel;
    Label16: TLabel;
    Label3: TLabel;
    dlgSaveScheme: TSaveDialog;
    btnExptAbslut: TButton;
    btnExptRltv: TButton;
    Panel4: TPanel;
    Label17: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Panel5: TPanel;
    Label25: TLabel;
    Label26: TLabel;
    sgLoads: TStringGrid;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure cbxProjectsChange(Sender: TObject);
    procedure cbxScenariosChange(Sender: TObject);
    procedure btnToRightClick(Sender: TObject);
    procedure btnToLeftClick(Sender: TObject);
    function getScenarioSummary(filePath: String; searchLineStr: String;
      rowOffSet: Integer): PLRMGridData;
    procedure Button7Click(Sender: TObject);
    procedure sgAbslutDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure sgAbslutKeyPress(Sender: TObject; var Key: Char);
    procedure btnExptRltvClick(Sender: TObject);
    procedure btnExptAbslutClick(Sender: TObject);
    procedure upDateRsltGrids();
    procedure Panel4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure genericExportGridToTxt(Sender: TObject; sg: TStringGrid;
      strFilter: String; fileName: String); overload;
    procedure genericExportGridToTxt(Sender: TObject; sg: TStringGrid;
      sg2: TStringGrid; strFilter: String; fileName: String); overload;
  end;

var
  PLRMScenComps: TPLRMScenComps;
  data1: PLRMGridData; // stores baseline data
  data2: PLRMGridData; // stores baseline data
  prjName: String;
  scnName: String;
  rptFileName: String;

implementation

uses
  GSUtils;
{$R *.dfm}

procedure TPLRMScenComps.btnToRightClick(Sender: TObject);
var
  I: Integer;
  tempStr, scnDirname: String;
  tempStrLst: TStrings;
  curRowIdx: Integer;
begin

  if (lbxScnLeft.ItemIndex = -1) then
  begin
    ShowMessage('Please select an item first and then click a button');
    Exit;
  end;
  tempStr := lbxScnLeft.Items[lbxScnLeft.ItemIndex];
  tempStrLst := TStringList.Create();
  Split('(', tempStr, tempStrLst);
  scnName := tempStrLst[0];

  tempStr := tempStrLst[1];
  Split(')', tempStr, tempStrLst);
  scnDirname := tempStrLst[0];

  GSUtils.TransferLstBxItems(lbxScnRight, lbxScnLeft);
  btnToLeft.enabled := true;
  // data2 := getScenarioSummary(defaultPrjDir + '\' + prjName + '\' + scnDirname + '\' + GSRPTFILENAME,searchStr,5);
  data2 := getScenarioSummary(defaultPrjDir + '\' + prjName + '\' + scnDirname +
    '\' + GSDETAILRPTFILENAME, searchStr, 5);
  // data2 := getScenarioSummary(defaultPrjDir + '\' + prjName + '\' + scnDirname + '\' + 'swmm.prpt',searchStr,5);
  if data2 = nil then
    Exit;

  curRowIdx := sgAbslut.RowCount;

  sgLoads.RowCount := sgAbslut.RowCount + 1;
  sgAbslut.RowCount := sgAbslut.RowCount + 1;
  sgReltv.RowCount := sgReltv.RowCount + 1;

  sgLoads.Cells[0, curRowIdx] := scnName;
  sgAbslut.Cells[0, curRowIdx] := scnName;
  sgReltv.Cells[0, curRowIdx] := scnName;
  for I := 0 to High(data1[0]) do
  begin
    sgLoads.Cells[I + 1, curRowIdx] :=
      FormatFloat('0.0', strToFloat(data2[0, I]));
    sgAbslut.Cells[I + 1, curRowIdx] :=
      FormatFloat('0.0', strToFloat(data1[0, I]) - strToFloat(data2[0, I]));
    if strToFloat(data1[0, I]) = 0.0 then
      sgReltv.Cells[I + 1, curRowIdx] := '0'
    else
      sgReltv.Cells[I + 1, curRowIdx] :=
        FormatFloat('0.0', 100 * (strToFloat(sgAbslut.Cells[I + 1, curRowIdx]) /
        strToFloat(data1[0, I]))) + '%';
  end;
  FreeAndNil(tempStrLst);
end;

procedure TPLRMScenComps.genericExportGridToTxt(Sender: TObject;
  sg: TStringGrid; strFilter: String; fileName: String);
var
  // tempStr :String;
  colLabels, rowLabels: TStringList;
  I: Integer;
begin
  if lbxScnRight.Items.count < 1 then
  begin
    ShowMessage('Add Scenarios to compare before attempting to export')
  end;

  dlgSaveScheme.FilterIndex := 1;
  dlgSaveScheme.InitialDir := defaultPrjDir;
  dlgSaveScheme.fileName := prjName + fileName;
  dlgSaveScheme.Filter := strFilter;

  colLabels := TStringList.Create();
  rowLabels := nil;
  // rowLabels := TStringList.Create();

  for I := 0 to High(SCNCOMPTXTFILEHDRS) do
    colLabels.Add(SCNCOMPTXTFILEHDRS[I]);

  if dlgSaveScheme.Execute then
  begin
    exportGridToTxt(',', sg, colLabels, rowLabels, dlgSaveScheme.fileName);
    // exportGridToTxt(',',sgAbslut,colLabels, rowLabels, dlgSaveScheme.FileName);
  end;
  FreeAndNil(colLabels);
  FreeAndNil(rowLabels);
end;

procedure TPLRMScenComps.genericExportGridToTxt(Sender: TObject;
  sg: TStringGrid; sg2: TStringGrid; strFilter: String; fileName: String);
var
  // tempStr :String;
  colLabels, rowLabels: TStringList;
  I: Integer;
begin
  if lbxScnRight.Items.count < 1 then
  begin
    ShowMessage('Add Scenarios to compare before attempting to export');
    Exit;
  end;

  dlgSaveScheme.FilterIndex := 1;
  dlgSaveScheme.InitialDir := defaultPrjDir;
  dlgSaveScheme.fileName := prjName + fileName;
  dlgSaveScheme.Filter := strFilter;

  colLabels := TStringList.Create();
  rowLabels := nil;
  // rowLabels := TStringList.Create();

  for I := 0 to High(SCNCOMPTXTFILEHDRS) do
    colLabels.Add(SCNCOMPTXTFILEHDRS[I]);

  if dlgSaveScheme.Execute then
  begin
    exportGridToTxt(',', sg, sg2, colLabels, rowLabels, dlgSaveScheme.fileName);
  end;
  FreeAndNil(colLabels);
  FreeAndNil(rowLabels);
end;

procedure TPLRMScenComps.Button7Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TPLRMScenComps.btnExptAbslutClick(Sender: TObject);
begin
  genericExportGridToTxt(Sender, sgLoads, sgAbslut,
    'Scenario Comparison-Absolute(*.csv)', ' Scenario Comparison-Absolute');
end;

procedure TPLRMScenComps.btnExptRltvClick(Sender: TObject);
begin
  genericExportGridToTxt(Sender, sgLoads, sgReltv,
    'Scenario Comparison-Relative(*.csv)', ' Scenario Comparison-Relative');
end;

procedure TPLRMScenComps.btnToLeftClick(Sender: TObject);
var
  I: Integer;
  tempStrLst: TStrings;
begin
  if (lbxScnRight.SelCount = 0) then
  begin
    ShowMessage('Please select an item first and then click a button');
    Exit;
  end;
  tempStrLst := TStringList.Create();
  for I := 0 to lbxScnRight.Items.count - 1 do
  begin
    if lbxScnRight.Selected[I] then
    begin
      Split('(', lbxScnRight.Items[I], tempStrLst);
      GSUtils.deleteGridRow(tempStrLst[0], 0, '0', sgAbslut);
      GSUtils.deleteGridRow(tempStrLst[0], 0, '0', sgReltv);
      GSUtils.deleteGridRow(tempStrLst[0], 0, '0', sgLoads);
    end;
  end;
  GSUtils.TransferLstBxItems(lbxScnLeft, lbxScnRight);
  if lbxScnRight.Items.count = 0 then
    (Sender as TButton).enabled := false;
end;

procedure TPLRMScenComps.cbxProjectsChange(Sender: TObject);
var
  tempInt, I, J: Integer;
  tempStr: String;
  tempStrLst: TStrings;
  S: TStringList;
  ScnNames: TStringList;
  filesList: TStringList;
begin
  tempInt := cbxProjects.ItemIndex;
  cbxScenarios.Text := '';
  tempStr := cbxProjects.Items[tempInt];
  tempStrLst := TStringList.Create();
  Split('(', tempStr, tempStrLst);

  tempStr := tempStrLst[1];
  Split(')', tempStr, tempStrLst);
  prjName := tempStrLst[0];

  S := getFoldersInFolder(defaultPrjDir + '\' + prjName);
  ScnNames := TStringList.Create();
  for I := 0 to S.count - 1 do
  begin
    filesList := getFilesInFolder(defaultPrjDir + '\' + prjName + '\' +
      S[I], '*.xml');
    // if not(fileExists(defaultPrjDir + '\' + prjName + '\' + S[I] + '\' + filesList[0])) then
    if (filesList.count = 0) then
    begin
      ShowMessage('Scenario ' + S[I] + ' at' + defaultPrjDir + '\' + prjName +
        '\' + S[I] +
        ' is invalid. Please delete the scenario folder and try again');
      Exit;
    end;

    ScnNames.Add(getXMLRootChildTagValue('ScenName',
      defaultPrjDir + '\' + prjName + '\' + S[I] + '\' + filesList[0]) + '(' +
      S[I] + ')');
    filesList.Clear;
  end;
  cbxScenarios.Items := ScnNames;

  lbxScnLeft.Items := cbxScenarios.Items;
  lblPrjName.Caption := prjName + ' (with ' + intToStr(cbxScenarios.Items.count)
    + ' scenarios)';
  lbxScnLeft.enabled := false;
  lblLeftLbx.enabled := false;
  lblRightLbx.enabled := false;
  lbxScnRight.enabled := false;
  btnToRight.enabled := false;
  btnToLeftClick(btnToLeft); // clears grids rows 1 and 2
  for I := 0 to NUMPOLS do // clear grids row 0
  begin
    for J := 0 to sgAbslut.RowCount - 1 do
    begin
      sgAbslut.Cells[I, J] := '';
      sgReltv.Cells[I, J] := '';
      sgLoads.Cells[I, J] := '';
    end;
  end;
  GSUtils.TransferAllLstBxItems(lbxScnLeft, lbxScnRight);

  // 2014 resent grid lengths to prevent phantom rows
  sgLoads.RowCount := 1;
  sgAbslut.RowCount := 1;
  sgReltv.RowCount := 1;

  FreeAndNil(filesList);
  FreeAndNil(tempStrLst);
  FreeAndNil(S);

end;

procedure TPLRMScenComps.cbxScenariosChange(Sender: TObject);
var
  tempInt, I: Integer;
  tempStr, scnDirname: String;
  tempStrLst: TStrings;
begin
  tempInt := cbxScenarios.ItemIndex;
  if tempInt = -1 then
    Exit;

  tempStr := cbxScenarios.Items[tempInt];
  tempStrLst := TStringList.Create();

  Split('(', tempStr, tempStrLst);
  scnName := tempStrLst[0];

  tempStr := tempStrLst[1];
  Split(')', tempStr, tempStrLst);
  scnDirname := tempStrLst[0];

  // Split('(',tempStr,tempStrLst);
  //
  // //tempStr :=  tempStrLst[1];
  // tempStr :=  tempStrLst[0]; //10/18
  // Split(')',tempStr,tempStrLst);
  // scnName :=tempStrLst[0];
  //
  // //10/18
  // tempStr :=  tempStrLst[1];
  // Split(')',tempStr,tempStrLst);
  // scnDirname :=tempStrLst[0];

  lbxScnLeft.Items := cbxScenarios.Items;
  // added so that lbxScnleft items do not get deleted after addition of fxnality allowing baseline scn to be changed

  lbxScnLeft.Items.Delete(tempInt);
  lbxScnLeft.enabled := true;
  lblLeftLbx.enabled := true;
  lblRightLbx.enabled := true;
  lbxScnRight.enabled := true;
  btnToRight.enabled := true;
  // 10/ 18 data1 := getScenarioSummary(defaultPrjDir + '\' + prjName + '\' + scnName + '\' + 'swmm.prpt',searchStr,5);
  // data1 := getScenarioSummary(defaultPrjDir + '\' + prjName + '\' + scnDirname + '\' + 'swmm.prpt',searchStr,5);
  data1 := getScenarioSummary(defaultPrjDir + '\' + prjName + '\' + scnDirname +
    '\' + GSDETAILRPTFILENAME, searchStr, 5);
  if data1 = nil then
    Exit;

  // 2014 resent grid lengths to prevent phantom rows
  sgLoads.RowCount := 1;
  sgAbslut.RowCount := 1;
  sgReltv.RowCount := 1;

  sgLoads.Cells[0, 0] := scnName;
  sgAbslut.Cells[0, 0] := scnName;
  sgReltv.Cells[0, 0] := scnName;
  for I := 0 to High(data1[0]) do
  begin
    sgLoads.Cells[I + 1, 0] := FormatFloat('0.0', strToFloat(data1[0, I]));
    sgAbslut.Cells[I + 1, 0] := FormatFloat('0.0', strToFloat(data1[0, I]));
    sgReltv.Cells[I + 1, 0] := FormatFloat('0.0', strToFloat(data1[0, I]));
  end;
  FreeAndNil(tempStrLst);
  // update absolue and relative grids when baseline changes
  upDateRsltGrids();

  //delete list box items cause starting over
  for I := 0 to lbxScnRight.Items.Count - 1 do
  begin
      lbxScnRight.Items.Clear; //(I);
  end;
end;

// when baseline scenario changes need to update all calcs
procedure TPLRMScenComps.upDateRsltGrids();
var
  I, J: Integer;
  // scnDirname:String;
  // tempStrLst:TStrings;
  // curRowIdx:Integer;
begin
  if sgAbslut.RowCount < 2 then
    Exit;

  for I := 1 to sgAbslut.RowCount do
  begin
    for J := 0 to High(data1[0]) do
    begin
      // sgLoads.Cells[J+1,curRowIdx] := FormatFloat('0.0',strToFloat(data2[0,J]));
      sgAbslut.Cells[J + 1, I] := FormatFloat('0.0', strToFloat(data1[0, J]) -
        strToFloat(data2[0, J]));
      if strToFloat(data1[0, J]) = 0.0 then
        sgReltv.Cells[J + 1, I] := '0'
      else
        sgReltv.Cells[J + 1, I] :=
          FormatFloat('0.0', 100 * (strToFloat(sgAbslut.Cells[J + 1, I]) /
          strToFloat(data1[0, J]))) + '%';
    end;
  end;
end;

procedure TPLRMScenComps.FormCreate(Sender: TObject);
var
  // data:PLRMGridData;
  S, filesList, PrjNames: TStringList;
  I: Integer;
begin
  // S := TStringList.Create();
  If not DirectoryExists(defaultPrjDir) then
  begin
    ShowMessage(defaultPrjDir + ' folder not found. Now exiting');
    Exit;
  end;
  S := getFoldersInFolder(defaultPrjDir);
  PrjNames := TStringList.Create();
  for I := 0 to S.count - 1 do
  begin
    if (S[I] <> defaultRegFolderName) then
    begin
      filesList := getFilesInFolder(defaultPrjDir + '\' + S[I], '*.xml');
      PrjNames.Add(getXMLRootChildTagValue('ProjectUserName',
        defaultPrjDir + '\' + S[I] + '\' + filesList[0]) + '(' + S[I] + ')');
      filesList.Clear;
    end;
  end;
  cbxProjects.Items := PrjNames;

  //resize string grid cells so scenarios with long names have more room
  with sgLoads do
  ColWidths[0] := ClientWidth - (ColWidths[1] * 7 );

  with sgReltv do
  ColWidths[0] := ClientWidth - (ColWidths[1] * 7 );

  with sgAbslut do
  ColWidths[0] := ClientWidth - (ColWidths[1]* 7 );
end;

function TPLRMScenComps.getScenarioSummary(filePath: String;
  searchLineStr: String; rowOffSet: Integer): PLRMGridData;
var
  S: TStrings;
  tempInt: Integer;
  tempStr: String;
  rslt: PLRMGridData;
  I: Integer;
begin
  S := TStringList.Create;
  if not(FileExists(filePath)) then
  begin
    ShowMessage
      ('scenario file not found. Please run the simulation to generate results for comparison');
    Result := nil;
    Exit
  end;
  S.LoadFromFile(filePath);
  tempInt := S.indexOf(searchLineStr);
  if tempInt = -1 then
  begin
    ShowMessage
      ('A valid results file was not found at the specified location. Re-run PLRM and try again');
    Result := nil;
    Exit;
  end;
  // tempStr := S[tempInt + rowOffset];
  tempStr := S[S.count - 3];
  S := Split(' ', tempStr, S);
  SetLength(rslt, 1, S.count - 2);
  for I := 2 to S.count - 1 do
    rslt[0][I - 2] := S[I];
  Result := rslt;
end;

procedure TPLRMScenComps.Panel4Click(Sender: TObject);
begin

end;

// Grays out 1st row of the grid to signify that it is the baseline scenario
procedure TPLRMScenComps.sgAbslutDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var
  S: String;
begin
  if ((ARow = 0)) then
  begin // or (ARow = 0 ))then begin
    (Sender as TStringGrid).Canvas.Brush.Color := clMenuBar;
    (Sender as TStringGrid).Canvas.FillRect(Rect);
    S := (Sender as TStringGrid).Cells[ACol, ARow];
    (Sender as TStringGrid).Canvas.Font.Color := clBlue;
    (Sender as TStringGrid).Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure TPLRMScenComps.sgAbslutKeyPress(Sender: TObject; var Key: Char);
begin
  gsEditKeyPress(Sender, Key, gemPosNumber);
  // discard all keys
  Key := #0;
end;

end.
