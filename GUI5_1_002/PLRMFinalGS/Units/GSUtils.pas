unit GSUtils;
{$WARN SYMBOL_PLATFORM OFF}

interface

uses

  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,
  xmldom, XMLIntf, msxmldom, XMLDoc, Generics.Collections,
  StdCtrls, ComCtrls, Menus, ImgList, ShlObj, ShellApi, Registry,
  ExtCtrls, Grids, GSTypes, StrUtils, MSXML, Variants, FileCtrl, GSInifile;

type
  TCopyDataProc = procedure(oldnode, newnode: TTreenode);

function gsSelectDirectory(initDir: String): String;
procedure AddGridRow(inStr: String; Grd: TStringGrid; strColNum: Integer);
function BrowseURL(const URL: string): boolean;
function CopyFolderContents(const FromFolder: string; ToFolder: string): string;
procedure CopySubtree(sourcenode: TTreenode; target: TTreeview;
  targetnode: TTreenode; CopyProc: TCopyDataProc = nil);
function copyGridContents(const sg: TStringGrid): PLRMGridData; overload;
function copyGridContents(const strtCol: Integer; strtRow: Integer;
  const sg: TStringGrid): PLRMGridData; overload;
function copyGridContents(const strtCol: Integer; strtRow: Integer;
  var outStrList: TStringList; const sg: TStringGrid): PLRMGridData; overload;
function copyGridContents(const strtCol: Integer; strtRow: Integer;
  var outStrList: TStringList; const sg: TStringGrid; const valCol: Integer;
  const grtrThanVal: Double = 0): PLRMGridData; overload;
function copyContentsToGrid(const data: PLRMGridData; const strtCol: Integer;
  strtRow: Integer; var sg: TStringGrid): boolean;
function copyContentsToGridSubset(const data: PLRMGridData;
  const strtCol: Integer; strtRow: Integer; numColsToCopy: Integer;
  numRowsToCopy: Integer; var sg: TStringGrid): boolean;
function copyInvertedPLRMGridToStrGrid(const data: PLRMGridData;
  const strtCol: Integer; strtRow: Integer; var sg: TStringGrid): boolean;
function copyStringGridToInvertedPLRMGrid(const sg: TStringGrid): PLRMGridData;
function copyContentsToGridAddRows(const data: PLRMGridData;
  const strtCol: Integer; strtRow: Integer; var sg: TStringGrid): boolean;
function copyContentsToGridNChk(const data: PLRMGridData;
  const strtCol: Integer; strtRow: Integer; var sg: TStringGrid): boolean;

function dbFields2ToPLRMGridData(data: dbReturnFields2; strtRowIdx: Integer = 0)
  : PLRMGridData;

// transposes columns and rows
function PLRMGridDblToPLRMGridData(data: PLRMGridDataDbl;
  strtRowIdx: Integer = 0; formatStr: String = THREEDP): PLRMGridData; overload;
// does not transpose columns and rows
function PLRMGridDblToPLRMGridDataNT(data: PLRMGridDataDbl;
  formatStr: String = THREEDP): PLRMGridData; overload;

function dbFields3ToPLRMGridData(data: dbReturnFields3; strtRowIdx: Integer = 0)
  : PLRMGridData;
procedure DefaultCopyDataProc(oldnode, newnode: TTreenode);
function deleteFileGS(const filePath: String): Integer;
function deleteFileGSNoConfirm(const filePath: String): Integer;
function DelTree(DirName: string): boolean;
// procedure ForceDeleteDirAndContents(dir: string);
procedure deleteGridRow(searchStr: String; strColNum: Integer;
  initCellStr: string; var Grd: TStringGrid);
function FileLook(genSpec: string; myFileExt: string; Node: TTreenode;
  TV: TTreeview): boolean;
procedure gsCopyFile(srcPath: String; destPath: String;
  overWrite: boolean = true);
function FolderLookAddUserName(startPath: string; Node: TTreenode;
  TV: TTreeview): boolean;
function getFilesInFolder(const strtFolderPath: String; genSpec: String)
  : TStringList;
function getFoldersInFolder(const strtFolder: string): TStringList;
function getFilePath(Node: TTreenode; TV: TTreeview): string;
function gridContainsStr(searchStr: String; strColNum: Integer;
  Grd: TStringGrid): boolean;
function initGrid(const dataStr: String; const strtCol: Integer;
  strtRow: Integer; var sg: TStringGrid): boolean;
function gsVectorMultiply(dArr1: TStringList; dArr2: TStringList): Double;
procedure removeDirGS(const dirPath: String);
procedure sgGrayOnDrawCell(var Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; colNum: Integer; rowNum: Integer);
procedure sgGrayOnDrawCell2ColsOnly(var Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; colNum1: Integer; colNum2: Integer);
procedure sgGrayOnDrawCell2ColsNRow(var Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; colNum1: Integer; colNum2: Integer;
  rowNum: Integer);
procedure sgGrayOnDrawCell3ColsOnly(var Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; colNum1: Integer; colNum2: Integer;
  colNum3: Integer);
procedure sgSelectCellWthNonEditCol(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: boolean; colNum: Integer); overload;
procedure sgSelectCellWthNonEditCol(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: boolean; colNum1: Integer; colNum2: Integer;
  colNum3: Integer); overload;
procedure sgSelectCellWthNonEditColNRow(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: boolean; colNum: Integer; rowNum: Integer);
procedure sgGrayOnDrawCellColAndRow(var Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; colNum: Integer; rowNum: Integer);
procedure TransferLstBxItems(Dest: TListbox; var Source: TListbox);
procedure TransferAllLstBxItems(Dest, Source: TListbox);
procedure initPLRMPaths();
procedure updatePLRMPaths(newPrjDir: String);

// GUI Helper Routines
function getComboBoxSelValue(Sender: TObject): String; Overload;
function getComboBoxSelValue2(Sender: TObject): TObject; Overload;
procedure GridDeleteRow(RowNumber: Integer; var Grid: TStringGrid);
procedure updateGeneralCbxItems(var cbxDest: TCombobox;
  const cbxSource: TCombobox);
procedure gsEditKeyPress(Sender: TObject; var Key: Char;
  const exptdTypeCode: TExptdTypeCodes);
procedure gsEditKeyPressNoSpace(Sender: TObject; var Key: Char;
  const exptdTypeCode: TExptdTypeCodes);
procedure exportGridToTxt(delimiter: String; sg: TStringGrid;
  colLables: TStringList; rowLabels: TStringList; filePath: String); overload;
procedure exportGridToTxt(delimiter: String; sg: TStringGrid; sg2: TStringGrid;
  colLables: TStringList; rowLabels: TStringList; filePath: String); overload;

// XML Routines
function xmlToPlrmGridData(iNode: IXMLNode; tags: TStringList;
  colStart: Integer): PLRMGridData; overload;
function xmlAttachedChildNodesToPLRMGridData(parentNode: IXMLNode;
  childTagName: string; rowName: String; var data: PLRMGridData;
  tags: TStringList): PLRMGridData;
function cdataTextToXML(txt: String; nodeName: String): IXMLNode;
function checkNCreateDirectory(folderPath: String): boolean;
procedure copyCbxObjects(inCbx: TCombobox; var outLst: TStringList);
procedure copyHydSchmToCbx(var outCbx: TCombobox; inLst: TStringList);
function getUserProjectOrScenName(xmlFilePath: String; nodeTag: String): String;
function getDefaultCatchProps(): PLRMGridData;
function getXMLRootChildTagValue(tagName: String; filePath: String): String;
function loadXMLDlg(): String;
function LoadXmlDoc(const FileName: WideString): IXMLDOMDocument;
function makeSWMMSaveInpFile(inputFilePath: String;
  rptfilePath: String): boolean;
function openAndLoadSWMMInptFilefromXML(xmlFilePath: String): boolean;
function plrmGridDataToXML(nodeName: String; data: PLRMGridData;
  tags: TStringList; valColNum: Integer): IXMLNodeList; overload;
function createAndAttachChildNode(var parentNode: IXMLNode;
  childTagName: string; rowName: String; data: PLRMGridData; tags: TStringList;
  txtList: TStringList): IXMLNode;
function plrmGridDataToXML(nodeName: String; data: PLRMGridData;
  tags: TStringList; txtList: TStringList): IXMLNodeList; overload;
function plrmGridDataToXML3(nodeName: String; rowNodeName: String;
  data: PLRMGridData; attribTags: TStringList; txtValColumn: Integer): IXMLNode;
function plrmGridDataToXML(nodeName: String; rowNodeName: String;
  data: PLRMGridData; attribTags: TStringList; txtList: TStringList)
  : IXMLNode; overload;
function plrmGridDataToXML(topNodeLabel: String; data: PLRMGridData;
  tags: TStringList; txtList: TStringList; txtNodeLabelList: TStringList)
  : IXMLNodeList; overload;
function plrmGridDataToXML2(topNodeLabel: String; data: PLRMGridData;
  tags: TStringList; txtList: TStringList; txtNodeLabelList: TStringList)
  : IXMLNodeList; overload;
procedure reNameProjOrScen(xmlFilePath: String; nodeTag: String;
  newName: String);
function swmmInptFileRainGageToXML(gageID: String; filePath: String;
  gageType: String = 'VOLUME'; timeIntv: String = '1:00';
  snowCatch: String = '1.0'; dataSrcType: String = 'FILE'; param: String = 'IN')
  : IXMLNode;
function swmmInptFileSoilsToXML(nodeName: String; data: PLRMGridData;
  tags: TStringList; valColNum: Integer): IXMLNodeList;
procedure saveXmlDoc(saveToPath: String; XMLDoc: IXMLDocument;
  insertStrLine0: String; insertStrLine1: String);
procedure saveXmlDoc2(saveToPath: String; XMLDoc: IXMLDocument);
function swmmInptFileBuildUpToXML(): IXMLNode;
function swmmInptFileCurvesToXML(invtdCurveData: PLRMGridData;
  curveName: String; curveType: String; var outNode: IXMLNode): IXMLNode;
function swmmInptFileXMLToCurves(invtdCurveData: PLRMGridData; iNode: IXMLNode)
  : PLRMGridData;
function swmmInptFileLandUseToXML(nodeName: String; data: PLRMGridData;
  tags: TStringList; valColNum: Integer): IXMLNodeList; overload;
function swmmInptFileLandUseToXML(nodeName: String; data: PLRMGridData;
  tags: TStringList; valColNum: Integer; luseCodeLst: TStringList)
  : IXMLNodeList; overload;
function swmmInptFileLandUseToXML(): IXMLNode; overload;
function swmmInptFileLoadingsToXML(): IXMLNode;
function swmmInptFileLossesToXML(): IXMLNode;
function swmmInptFileMapToXML(): IXMLNode;
function swmmInptFilePollutantsToXML(): IXMLNode;
function swmmInptFileTagsToXML(): IXMLNode;
function swmmInptFileTempTimeSeriesToXML(const seriesName: String;
  const dataFilePath: String; const seriesType: String = 'FILE'): IXMLNode;
function swmmInptFileWashOffToXML(): IXMLNode;
function swmmInptFileReportToXML(): IXMLNode;
function swmmBlockLinesToXML(swmmLines: TStringList; nodeName: String;
  var outNode: IXMLNode): IXMLNode;
function swmmDefaultsToXML(swmmDefaults: TStringList; maxFloLength: Double;
  widthPower: Double; widthFactor: Double; nodeName: String): IXMLNode;

function catchmentValidationTblToXML(): IXMLNode;
function nodeValidationTblToXML(): IXMLNode;

function Split(const delimiter: Char; Input: string;
  var ResultStrings: TStrings): TStrings;
procedure transformXMLToSwmm(xslFilePath: String; inXMLFilePath: String;
  outFilePath: String);
function xmlToPlrmGridData(iNode: IXMLNode; tags: TStringList)
  : PLRMGridData; overload;
function xmlAttribToPlrmGridData(iNode: IXMLNode; tags: TStringList)
  : PLRMGridData;
function lookUpCodeFrmName(const searchNames: PLRMGridData; searchCol: Integer;
  projectNamesList: TStringList; projectCodesList: TStringList): TStringList;
procedure FreeStringListObjects(const strings: TStrings);
procedure cleanUp();

const { ID num for accessing Icons for treeview from  imagelist }
  ISAUnknown = 0;
  ISAClosedFolder = 1; { only the folders will be used for this example }
  ISAOpenFolder = 2;
  defaultProjName = 'DefaultProject';
  defaultScnName = 'DefaultScenario';
  othrLandUseArrIndex = 6;
  roadLandUseArrIndex = 7;

  plrmFileExt = '.xml';
  ramScoreConst1 = 1974.5;
  ramScoreConst2 = -0.69;
  rsltsFormatStrLft = '%-26s';
  rsltsFormatStrRgt = '%18s';
  rsltsFormatDec183f = '%18.3f';
  rsltsFormatDec182f = '%18.2f';
  rsltsFormatDec181f = '%18.1f';
  rsltsFormatDec180f = '%18.0f';
  rsltsFormatDec172f = '%17.2f';
  rsltsFormatDec171f = '%17.1f';
  rsltsFormatDec170f = '%17.0f';
  rsltsFormatDec160f = '%16.0f';

var
  defaultXslPath: String;
  validateXslPath: String;
  luseNameCodeTable: PLRMGridData;
  shpFilesDict: TDictionary<String, String>;

  // 2014 for GIS tool shapefiles dictionary keys
  shpFileKeys: array [0 .. 7] of string = (
    'Catchments',
    'Slopes',
    'LandUses',
    'Soils',
    'RoadConditions',
    'RoadShoulders',
    'RunoffConnectivity',
    'BMps'
  );

  frmsLuses: array [0 .. 7] of string = (
    'Primary Road (ROW)',
    'Secondary Road (ROW)',
    'Single Family Residential',
    'Multi Family Residential',
    'CICU',
    'Vegetated Turf',
    'Other',
    'Roads'
  );
  frmsLuseTags: array [0 .. 7] of string = (
    'PrimaryRoads',
    'SecondaryRoads',
    'SingleFamilyResidential',
    'MultiFamilyResidential',
    'CICU',
    'Vgt',
    'othr',
    'Roads'

  );
  frmsLuseCodes: array [0 .. 7] of string = (
    'Prr',
    'Ser',
    'Sfr',
    'Mfr',
    'Cic',
    'Vgt',
    'Othr',
    'Road'
  );
  cats: array [0 .. 2] of String = (
    'High',
    'Moderate',
    'Low'
  );
  pollutantTags: array [0 .. 9] of string = (
    'code',
    'name',
    'massUnits',
    'rainConc',
    'gwConc',
    'iiConc',
    'decayCoef',
    'snowOnly',
    'coPollutName',
    'coPollutFrac'
  );
  currentRptFilePath: String;
  isPLRMStatusReportActive: boolean;
  snowPackNames: TStringList;
  swmmDefaults: TStringList;
  // e.g. impervious-n, pervious-n etc. From Database[defaultValues 6%]
  grnWaterXMLTags: array [0 .. 11] of String = (
    'id',
    'subcatch',
    'aquifer',
    'receivingNode',
    'surfElev',
    'grnWaterFlowCoeff',
    'grndWaterFlowExp',
    'surfWaterFlowCoeff',
    'surfWaterFlowExo',
    'surfGWIntCoef',
    'fxdSWDepth',
    'threshGWElev'
  );
  validationXMLTags: array [0 .. 5] of String = (
    'parameter',
    'min',
    'max',
    'units',
    'flag',
    'description'
  );

  defaultGISDir: String;
  defaultPLRMPath: String;
  defaultXMLDeclrtn: String;
  defaultPrjDir: String;
  defaultSchmDir: String;
  defaultEngnDir: String;
  defaultDataDir: String;
  defaultDBPath: String;
  defaultPrjPath: String;
  defaultGenSWmmInpPath: String;
  defaultUserSWmmInpPath: String;
  defaultUserSwmmRptPath: String;
  defaultValidateDir: String;
  defaultValidateFilePath: String;
  PLRMInitIni: String;
  HYDSCHMSDIR: String;
  RCONDSCHMSDIR: String;
  dbPath: String;

implementation

uses
  Fmain, Uimport, Uglobals, GSIO, UProject, Uoutput, GSFileManage, GSCatchments;
{$REGION 'XML methods'}

function catchmentValidationTblToXML(): IXMLNode;
var
  data: PLRMGridData;
  xmlTagList: TStringList;
  I: Integer;
begin
  xmlTagList := TStringList.Create();
  for I := 0 to High(validationXMLTags) do
    xmlTagList.add(validationXMLTags[I]);
  data := getCatchmentValidationRules();
  Result := plrmGridDataToXML3('catchmentValidation', 'rule', data,
    xmlTagList, 5);
  FreeAndNil(xmlTagList);
end;

function nodeValidationTblToXML(): IXMLNode;
var
  data: PLRMGridData;
  xmlTagList: TStringList;
  I: Integer;
begin
  xmlTagList := TStringList.Create();
  for I := 0 to High(validationXMLTags) do
    xmlTagList.add(validationXMLTags[I]);
  data := getNodeValidationRules();
  Result := plrmGridDataToXML3('nodeValidation', 'rule', data, xmlTagList, 5);
  FreeAndNil(xmlTagList);
end;

procedure exportGridToTxt(delimiter: String; sg: TStringGrid;
  colLables: TStringList; rowLabels: TStringList; filePath: String);
var
  I, J: Integer;
  tempstr: String;
  tempLst: TStringList;
begin
  tempLst := TStringList.Create();
  for I := 0 to colLables.Count - 2 do
  begin
    tempstr := tempstr + colLables[I] + delimiter;
  end;
  tempLst.add(tempstr + colLables[I]); // add titles
  for I := 0 to sg.RowCount - 1 do
  begin
    if rowLabels <> nil then
      tempstr := rowLabels[I]
    else
      tempstr := '';
    for J := 0 to sg.ColCount - 2 do // first and last items added outside loop
    begin
      tempstr := tempstr + sg.Cells[J, I] + delimiter;
    end;
    tempLst.add(tempstr + sg.Cells[J, I]);
  end;
  tempLst.SaveToFile(filePath);
  tempLst.Free;
end;

procedure exportGridToTxt(delimiter: String; sg: TStringGrid; sg2: TStringGrid;
  colLables: TStringList; rowLabels: TStringList; filePath: String);
var
  I, J: Integer;
  tempstr, headrLine: String;
  tempLst: TStringList;
begin
  tempLst := TStringList.Create();
  for I := 0 to colLables.Count - 2 do
  begin
    tempstr := tempstr + colLables[I] + delimiter;
  end;
  headrLine := (tempstr + colLables[I]);

  tempLst.add('Scenario Results');
  tempLst.add(headrLine); // add titles
  // add first string grid
  for I := 0 to sg.RowCount - 1 do
  begin
    if rowLabels <> nil then
      tempstr := rowLabels[I]
    else
      tempstr := '';
    for J := 0 to sg.ColCount - 2 do // first and last items added outside loop
    begin
      tempstr := tempstr + sg.Cells[J, I] + delimiter;
    end;
    tempLst.add(tempstr + sg.Cells[J, I]);
  end;
  // add second stringGrid
  tempLst.add(' ');
  tempLst.add
    ('Scenario Results: Basline and Percent Differences from Baseline');
  tempLst.add(headrLine); // add titles
  for I := 0 to sg2.RowCount - 1 do
  begin
    if rowLabels <> nil then
      tempstr := rowLabels[I]
    else
      tempstr := '';
    for J := 0 to sg2.ColCount - 2 do // first and last items added outside loop
    begin
      tempstr := tempstr + sg2.Cells[J, I] + delimiter;
    end;
    tempLst.add(tempstr + sg2.Cells[J, I]);
  end;
  tempLst.SaveToFile(filePath);
  tempLst.Free;
end;

procedure copyCbxObjects(inCbx: TCombobox; var outLst: TStringList);
var
  I: Integer;
Begin
  if outLst = nil then
    outLst := TStringList.Create();

  for I := 0 to inCbx.Items.Count - 1 do
  begin
    if assigned(inCbx.Items.Objects[I]) then
      outLst.AddObject((inCbx.Items.Objects[I] as TPLRMHydPropsScheme).name,
        inCbx.Items.Objects[I]);
  end;
End;

procedure copyHydSchmToCbx(var outCbx: TCombobox; inLst: TStringList);
var
  I: Integer;
Begin
  if outCbx = nil then
    exit;
  if inLst = nil then
    exit;

  for I := 0 to inLst.Count - 1 do
  begin
    if assigned(inLst.Objects[I]) then
      outCbx.Items.AddObject((inLst.Objects[I] as TPLRMHydPropsScheme).name,
        inLst.Objects[I]);
  end;
End;

// extracts user assigned project name from project xml file
function getUserProjectOrScenName(xmlFilePath: String; nodeTag: String): String;
var
  XMLDoc: IXMLDocument;
  rootNode: IXMLNode;
begin
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.loadFromFile(xmlFilePath);
  rootNode := XMLDoc.DocumentElement;
  Result := rootNode.ChildNodes[nodeTag].Text;
  XMLDoc := nil;
end;

procedure reNameProjOrScen(xmlFilePath: String; nodeTag: String;
  newName: String);
var
  XMLDoc: IXMLDocument;
  rootNode: IXMLNode;
begin
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.loadFromFile(xmlFilePath);
  rootNode := XMLDoc.DocumentElement;
  rootNode.ChildNodes[nodeTag].Text := newName;
  saveXmlDoc(xmlFilePath, XMLDoc, '', '');
  XMLDoc := nil;
end;

// adapted from http://delphi.about.com/cs/adptips2002/a/bltip1102_5.htm
function Split(const delimiter: Char; Input: string;
  var ResultStrings: TStrings): TStrings;
begin
  Assert(assigned(ResultStrings));
  ResultStrings.Clear;
  ResultStrings.delimiter := delimiter;
  ResultStrings.DelimitedText := Input;
  Result := ResultStrings;
end;

function makeSWMMSaveInpFile(inputFilePath: String;
  rptfilePath: String): boolean;
begin
  Mainform.PLRMSaveFile(inputFilePath);
  Result := true;
end;

function getXMLRootChildTagValue(tagName: String; filePath: String): String;
var
  XMLDoc: IXMLDocument;
  rootNode: IXMLNode;
begin
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.loadFromFile(filePath);
  rootNode := XMLDoc.DocumentElement;
  Result := rootNode.ChildNodes[tagName].Text;
  XMLDoc := nil;
end;

function openAndLoadSWMMInptFilefromXML(xmlFilePath: String): boolean;
var
  XMLDoc: IXMLDocument;
  rootNode: IXMLNode;
  outFilePath: String;
  // Sender: TObject;
begin
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.loadFromFile(xmlFilePath);
  rootNode := XMLDoc.DocumentElement;
  // 2014 changed to use relative paths rather than hardcoded paths in xml file
  // outFilePath := rootNode.ChildNodes['UserSWMMInpt'].Text;
  outFilePath := ExtractFilePath(xmlFilePath) + 'swmm.inp';
  // rootNode.ChildNodes['UserSWMMInpt'].Text;

  if fileExists(outFilePath) then
  begin
    Mainform.OpenFile(nil, outFilePath);
    Result := true;
    exit;
  end;
  XMLDoc := nil;
  Result := false;
end;

function LoadXmlDoc(const FileName: WideString): IXMLDOMDocument;
begin
  Result := CoDomDocument60.Create();
  Result.async := false;
  Result.load(FileName);
end;

procedure saveXmlDoc(saveToPath: String; XMLDoc: IXMLDocument;
  insertStrLine0: String; insertStrLine1: String);
var
  s: TStringList;
begin
  s := TStringList.Create();
  try
    s.Assign(XMLDoc.XML);
    if insertStrLine0 <> '' then
      s.Insert(0, '<?xml-stylesheet type="text/xsl" href="' +
        defaultXslPath + '"?>');
    if insertStrLine1 <> '' then
      s.Insert(0, '<?xml version="1.0"?>');
    s.SaveToFile(saveToPath);
    FreeStringListObjects(s);
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
      FreeStringListObjects(s);
    end;
  end;
end;

procedure saveXmlDoc2(saveToPath: String; XMLDoc: IXMLDocument);
begin
  try
    XMLDoc.SaveToFile(saveToPath);
  except
    on E: Exception do
    begin
      ShowMessage(E.Message);
    end;
  end;
end;

procedure transformXMLToSwmm(xslFilePath: String; inXMLFilePath: String;
  outFilePath: String);
var
  doc, xsl: IXMLDOMDocument;
  tempstr: String;
  s: TStringList;
begin
  try
    doc := LoadXmlDoc(inXMLFilePath);
    xsl := LoadXmlDoc(xslFilePath);
    tempstr := doc.transformNode(xsl)
  except
    on E: Exception do
      ShowMessage(E.Message)
  end;
  s := TStringList.Create;
  s.Text := tempstr;
  s.SaveToFile(outFilePath);
  s.Free;
end;

function loadXMLDlg(): String;
var
  opnFileDlg: TOpenDialog;
begin
  // opnFileDlg := TOpenDialog.Create(opnFileDlg);
  opnFileDlg := TOpenDialog.Create(nil);
  opnFileDlg.InitialDir := GetCurrentDir;
  opnFileDlg.Options := [ofFileMustExist];
  opnFileDlg.Filter := 'PLRM Scheme Files|*.xml';
  opnFileDlg.FilterIndex := 1;

  if opnFileDlg.Execute then
    Result := opnFileDlg.FileName;
end;

function swmmInptFileCurvesToXML(invtdCurveData: PLRMGridData;
  curveName: String; curveType: String; var outNode: IXMLNode): IXMLNode;
var
  root: IXMLNode;
  tempNode1: IXMLNode;
  I: Integer;
begin
  root := outNode.AddChild('Curve');
  root.Attributes['name'] := curveName;
  root.Attributes['curveType'] := curveType;
  for I := 1 to High(invtdCurveData[0]) do
  begin
    tempNode1 := root.AddChild('CurveEntry');
    tempNode1.Attributes['xval'] := invtdCurveData[0, I];
    tempNode1.Attributes['yval'] := invtdCurveData[1, I];
    if High(invtdCurveData) = 2 then
      tempNode1.Attributes['zval'] := invtdCurveData[2, I];
    // added for the vol dis curve
    tempNode1.Text := curveType;
  end;
  Result := root;
end;

function swmmInptFileXMLToCurves(invtdCurveData: PLRMGridData; iNode: IXMLNode)
  : PLRMGridData;
var
  tempNode1: IXMLNode;
  I: Integer;
  tempstr: String;
begin

  tempstr := iNode.Attributes['name'];
  if (AnsiEndsStr('VolDis', tempstr)) then
    SetLength(invtdCurveData, 3, iNode.ChildNodes.Count + 1)
  else
    SetLength(invtdCurveData, 2, iNode.ChildNodes.Count + 1);
  for I := 1 to iNode.ChildNodes.Count do
  begin
    tempNode1 := iNode.ChildNodes[I - 1];
    invtdCurveData[0, I] := tempNode1.Attributes['xval'];
    invtdCurveData[1, I] := tempNode1.Attributes['yval'];
    if High(invtdCurveData) = 2 then
      invtdCurveData[2, I] := tempNode1.Attributes['zval'];
    // added for the vol dis curve
  end;
  Result := invtdCurveData;
end;

function swmmInptFileBuildUpToXML(): IXMLNode;
var
  data: PLRMGridData;
  root: IXMLNode;
  tempNode1: IXMLNode;
  tempNode2: IXMLNode;
  XMLDoc: IXMLDocument;
  I: Integer;
begin
  data := getDBDataAsPLRMGridData(15);
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := true;
  root := XMLDoc.AddChild('BuildUp');
  for I := 0 to High(data) do
  begin
    tempNode1 := root.AddChild('BuildUpEntry');
    tempNode1.Attributes['landUse'] := data[I, 2];
    tempNode1.Attributes['pollutant'] := data[I, 3];

    tempNode2 := tempNode1.AddChild('Function');
    tempNode2.Text := data[I, 4];
    tempNode2.Attributes['coef1'] := data[I, 5];
    tempNode2.Attributes['coef2'] := data[I, 6];
    tempNode2.Attributes['coef3'] := data[I, 7];
    tempNode2.Attributes['normalizer'] := data[I, 8];
  end;
  Result := root;
end;

function swmmInptFileWashOffToXML(): IXMLNode;
var
  data: PLRMGridData;
  root: IXMLNode;
  tempNode1: IXMLNode;
  tempNode2: IXMLNode;
  XMLDoc: IXMLDocument;
  I: Integer;
begin
  data := getDBDataAsPLRMGridData(16);
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := true;
  root := XMLDoc.AddChild('WashOff');
  for I := 0 to High(data) do
  begin
    tempNode1 := root.AddChild('WashOffEntry');
    tempNode1.Attributes['landUse'] := data[I, 2];
    tempNode1.Attributes['pollutant'] := data[I, 3];

    tempNode2 := tempNode1.AddChild('Function');
    tempNode2.Text := data[I, 4];
    tempNode2.Attributes['coef1'] := data[I, 5];
    tempNode2.Attributes['coef2'] := data[I, 6];
    tempNode2.Attributes['cleanEff'] := data[I, 7];
    tempNode2.Attributes['bmpEff'] := data[I, 8];
  end;
  Result := root;
end;

function swmmInptFileLoadingsToXML(): IXMLNode;
var
  s: TStringList;
begin
  s := TStringList.Create();
  s.add('[LOADINGS]');
  s.add(';;Subcatchment  	Pollutant       	Loading');
  s.add(';;--------------	----------------	----------]]>');
  Result := cdataTextToXML(s.Text, 'Loadings');
  s.Free;
end;

function swmmInptFileTagsToXML(): IXMLNode;
var
  s: TStringList;
begin
  s := TStringList.Create();
  s.add('[TAGS]');
  Result := cdataTextToXML(s.Text, 'Tags');
  s.Free;
end;

function swmmInptFileTempTimeSeriesToXML(const seriesName: String;
  const dataFilePath: String; const seriesType: String = 'FILE'): IXMLNode;
var
  s: TStringList;
begin
  s := TStringList.Create();
  s.add('[TIMESERIES]');
  s.add(';;Name          	Type      	Path ');
  s.add(';;--------------	----------	--------------------');
  s.add(seriesName + '      ' + seriesType + '      "' + dataFilePath + '"');
  Result := cdataTextToXML(s.Text, 'TimeSeries');
  s.Free;
end;

function swmmInptFileReportToXML(): IXMLNode;
var
  s: TStringList;
begin
  s := TStringList.Create();
  s.add('[REPORTS]');
  s.add('INPUT     	NO');
  s.add('CONTROLS  	NO');
  s.add('SUBCATCHMENTS	NONE');
  s.add('NODES	NONE');
  s.add('LINKS	ALL');
  Result := cdataTextToXML(s.Text, 'Report');
  s.Free;
end;

function swmmInptFileMapToXML(): IXMLNode;
var
  s: TStringList;
begin
  s := TStringList.Create();
  s.add('[MAP]');
  s.add('DIMENSIONS 0.000 0.000 10000.000 10000.000');
  s.add('Units     	Feet ');
  Result := cdataTextToXML(s.Text, 'Map');
  s.Free;
end;

function swmmInptFileLossesToXML(): IXMLNode;
var
  s: TStringList;
begin
  s := TStringList.Create();
  s.add('[LOSSES]');
  s.add(';;Link          	Inlet     	Outlet    	Average   	Flap Gate');
  s.add(';;--------------	----------	----------	----------	----------');
  Result := cdataTextToXML(s.Text, 'Losses');
  s.Free;
end;

function cdataTextToXML(txt: String; nodeName: String): IXMLNode;
var
  root: IXMLNode;
  XMLDoc: IXMLDocument;
begin
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := true;
  root := XMLDoc.AddChild(nodeName);
  root.Text := txt;
  XMLDoc := nil;
  Result := root;
end;

function swmmDefaultsToXML(swmmDefaults: TStringList; maxFloLength: Double;
  widthPower: Double; widthFactor: Double; nodeName: String): IXMLNode;
var
  root: IXMLNode;
  tempNode: IXMLNode;
  tempNode1: IXMLNode;
  tempNode2: IXMLNode;
  tempNode3: IXMLNode;
  tempNode4: IXMLNode;
  tempNode5: IXMLNode;
  tempNode6: IXMLNode;
  XMLDoc: IXMLDocument;
begin
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := true;
  root := XMLDoc.AddChild(nodeName);
  tempNode := root.AddChild('ImpervN');
  tempNode.Text := swmmDefaults[0];

  tempNode1 := root.AddChild('PervN');
  tempNode1.Text := swmmDefaults[1];

  tempNode2 := root.AddChild('ImpervS');
  tempNode2.Text := swmmDefaults[2];

  tempNode3 := root.AddChild('PervS');
  tempNode3.Text := swmmDefaults[3];

  // for calculation of catchment width W = Area ^ Power
  tempNode4 := root.AddChild('CatchFloLengthMax');
  tempNode4.Text := FormatFloat('0.##', maxFloLength);
  tempNode5 := root.AddChild('CatchWidthPower');
  tempNode5.Text := FormatFloat('0.##', widthPower);
  tempNode6 := root.AddChild('CatchWidthFactor');
  tempNode6.Text := FormatFloat('0.##', widthFactor);
  Result := root;
end;

function swmmBlockLinesToXML(swmmLines: TStringList; nodeName: String;
  var outNode: IXMLNode): IXMLNode;
var
  tempNode: IXMLNode;
begin
  Try
    tempNode := outNode.AddChild(nodeName);
    tempNode.Text := swmmLines.Text;
    Result := tempNode;
  Except
    on E: Exception do
    begin
      ShowMessage('An error occured while saving the swmm input file');
    end;
  end;

end;

function swmmInptFileRainGageToXML(gageID: String; filePath: String;
  gageType: String = 'VOLUME'; timeIntv: String = '1:00';
  snowCatch: String = '1.0'; dataSrcType: String = 'FILE'; param: String = 'IN')
  : IXMLNode;
var
  root: IXMLNode;
  tempNode2: IXMLNode;
  XMLDoc: IXMLDocument;
begin
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := true;
  root := XMLDoc.AddChild('Raingages');
  root.Attributes['name'] := gageID;
  root.Attributes['type'] := gageType;
  root.Attributes['timeInterval'] := timeIntv;
  root.Attributes['snowCatch'] := snowCatch;

  tempNode2 := root.ChildNodes['Raingage'].AddChild('DataSource');
  tempNode2.Text := filePath;
  tempNode2.Attributes['gageID'] := gageID;
  tempNode2.Attributes['type'] := dataSrcType;
  tempNode2.Attributes['param'] := param;
  Result := root;
end;

// Values in valColNum column become XML text and all else are attributes if
function swmmInptFileLandUseToXML(nodeName: String; data: PLRMGridData;
  tags: TStringList; valColNum: Integer; luseCodeLst: TStringList)
  : IXMLNodeList;
var
  I, J: Integer;
  root: IXMLNode;
  tempNode: IXMLNode;
  XMLDoc: IXMLDocument;
begin
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := true;
  root := XMLDoc.AddChild(nodeName);
  // name at this node does not matter just need a list of nodes
  for I := 0 to High(data) do
  begin
    tempNode := root.AddChild(nodeName);
    tempNode.Text := luseCodeLst[I];
    for J := 0 to High(data[0]) do
    begin
      tempNode.Attributes[tags[J]] := data[I][J];
    end;
  end;
  Result := root.ChildNodes;
end;

function swmmInptFileLandUseToXML(nodeName: String; data: PLRMGridData;
  tags: TStringList; valColNum: Integer): IXMLNodeList;
var
  I, J: Integer;
  root: IXMLNode;
  tempNode: IXMLNode;
  XMLDoc: IXMLDocument;
begin
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := true;
  root := XMLDoc.AddChild(nodeName);
  // name at this node does not matter just need a list of nodes
  for I := 0 to High(data) do
  begin
    tempNode := root.AddChild(nodeName);
    tempNode.Text := data[I][valColNum];
    for J := 0 to High(data[0]) do
    begin
      tempNode.Attributes[tags[J]] := data[I][J];
    end;
  end;
  Result := root.ChildNodes;
end;

function swmmInptFileLandUseToXML(): IXMLNode;
var
  data: PLRMGridData;
  root: IXMLNode;
  tempNode1: IXMLNode;
  XMLDoc: IXMLDocument;
  I: Integer;
begin
  data := getDBDataAsPLRMGridData(17);
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := true;
  root := XMLDoc.AddChild('ParcelLandUses');
  for I := 0 to High(data) do
  begin
    tempNode1 := root.AddChild('LandUse');
    tempNode1.Attributes['code'] := data[I, 1];
    tempNode1.Attributes['clnIntv'] := data[I, 2];
    tempNode1.Attributes['fracAvail'] := data[I, 3];
    tempNode1.Attributes['lastCln'] := data[I, 4];
  end;
  Result := root;
end;

function lookUpCodeFrmName(const searchNames: PLRMGridData; searchCol: Integer;
  projectNamesList: TStringList; projectCodesList: TStringList): TStringList;
var
  I, J: Integer;
  rslt: TStringList;
begin
  rslt := TStringList.Create;
  for I := 0 to High(searchNames) do
    for J := 0 to projectNamesList.Count - 1 do
    begin
      if (searchNames[I][searchCol] = projectNamesList[J]) then
      begin
        rslt.add(projectCodesList[J]);
        break;
      end;
    end;
  Result := rslt;
end;

function swmmInptFileSoilsToXML(nodeName: String; data: PLRMGridData;
  tags: TStringList; valColNum: Integer): IXMLNodeList;
var
  I, J: Integer;
  root: IXMLNode;
  tempNode: IXMLNode;
  XMLDoc: IXMLDocument;
begin

  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := true;
  root := XMLDoc.AddChild(nodeName);
  // name at this node does not matter just need a list of nodes
  for I := 0 to High(data) do
  begin
    tempNode := root.AddChild(nodeName);
    tempNode.Text := data[I][valColNum];
    for J := valColNum to tags.Count - 1 do
    begin
      tempNode.Attributes[tags[J]] := data[I][J];
    end;
  end;
  Result := root.ChildNodes;
end;

function swmmInptFilePollutantsToXML(): IXMLNode;
var
  data: PLRMGridData;
  textList, attribTags: TStringList;
  I: Integer;
begin
  try
    data := getDBDataAsPLRMGridData(11);
    textList := TStringList.Create;
    attribTags := TStringList.Create;

    for I := 0 to High(data) do
      textList.add(data[I, 1]); // pollutant name to be used as xml node text
    for I := 0 to High(pollutantTags) do
      attribTags.add(pollutantTags[I]);
    // pollutant name to be used as xml node text
    Result := plrmGridDataToXML('Pollutants', 'Pollutant', data, attribTags,
      textList);
  finally
    FreeAndNil(textList);
    FreeAndNil(attribTags);
  end;
end;

// Values in txtList become XML text and all else are attributes
function plrmGridDataToXML(nodeName: String; rowNodeName: String;
  data: PLRMGridData; attribTags: TStringList; txtList: TStringList): IXMLNode;
var
  I, J: Integer;
  root: IXMLNode;
  tempNode: IXMLNode;
  XMLDoc: IXMLDocument;
begin
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := true;
  root := XMLDoc.AddChild(nodeName);
  for I := 0 to High(data) do
  begin
    tempNode := root.AddChild(rowNodeName);
    tempNode.Text := txtList[I];
    for J := 0 to High(data[0]) do
      tempNode.Attributes[attribTags[J]] := data[I][J];
  end;
  Result := root;
end;

// 2014 utility function that takes plrmgriddata and creates child xml nodes
// attached to parent passed in
function createAndAttachChildNode(var parentNode: IXMLNode;
  childTagName: string; rowName: String; data: PLRMGridData; tags: TStringList;
  txtList: TStringList): IXMLNode;
var
  I: Integer;
  tempNode: IXMLNode;
  tempNodeList: IXMLNodeList;
begin
  tempNode := parentNode.AddChild(childTagName, '');
  tempNodeList := GSUtils.plrmGridDataToXML(rowName, data, tags, txtList);
  for I := 0 to tempNodeList.Count - 1 do
  begin
    tempNode.ChildNodes.add(tempNodeList[I]);
  end;
  tempNode.Resync;
end;

// 2014 utility function that takes xml parent node and reads plrmgriddata
// attached to parent passed in
function xmlAttachedChildNodesToPLRMGridData(parentNode: IXMLNode;
  childTagName: string; rowName: String; var data: PLRMGridData;
  tags: TStringList): PLRMGridData;
var
  // I: Integer;
  tempNode: IXMLNode;
  tempNodeList: IXMLNodeList;
  // tempData: PLRMGridData;
begin
  tempNode := parentNode.ChildNodes[childTagName];
  if (assigned(tempNode)) then
  begin
    data := xmlToPlrmGridData(tempNode, tags, 0);
  end;
  Result := data;
end;

function plrmGridDataToXML3(nodeName: String; rowNodeName: String;
  data: PLRMGridData; attribTags: TStringList; txtValColumn: Integer): IXMLNode;
var
  I, J: Integer;
  root: IXMLNode;
  tempNode: IXMLNode;
  XMLDoc: IXMLDocument;
begin
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := true;
  root := XMLDoc.AddChild(nodeName);
  for I := 0 to High(data) do
  begin
    tempNode := root.AddChild(rowNodeName);
    tempNode.Text := data[I][txtValColumn];
    for J := 0 to High(data[0]) do
      if J <> txtValColumn then
        tempNode.Attributes[attribTags[J]] := data[I][J];
  end;
  Result := root;
end;

// Values in txtList become XML text and all else are attributes
function plrmGridDataToXML(nodeName: String; data: PLRMGridData;
  tags: TStringList; txtList: TStringList): IXMLNodeList;
var
  I, J: Integer;
  root: IXMLNode;
  tempNode: IXMLNode;
  XMLDoc: IXMLDocument;
begin

  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := true;
  root := XMLDoc.AddChild(nodeName);
  // name at this node does not matter just need a list of nodes
  for I := 0 to High(data) do
  begin
    tempNode := root.AddChild(nodeName);
    tempNode.Text := txtList[I];
    for J := 0 to High(data[0]) do
      tempNode.Attributes[tags[J]] := data[I][J];
  end;
  Result := root.ChildNodes;
end;

function xmlToPlrmGridData(iNode: IXMLNode; tags: TStringList;
  colStart: Integer): PLRMGridData;
var
  I, J: Integer;
  data: PLRMGridData;
  numCols, numRows: Integer;
begin
  numRows := iNode.ChildNodes.Count; // includes text as column
  numCols := tags.Count; // includes text as column

  SetLength(data, numRows, numCols); // includes text as column
  for I := 0 to iNode.ChildNodes.Count - 1 do
  begin
    data[I][0] := iNode.ChildNodes[I].Text;
    for J := colStart to numCols - 1 do // High(data[0]) do
      if ((iNode.ChildNodes[I].Attributes[tags[J]]) <> Null) then
        data[I][J] := iNode.ChildNodes[I].Attributes[tags[J]];
  end;
  Result := data;
end;

function xmlToPlrmGridData(iNode: IXMLNode; tags: TStringList): PLRMGridData;
var
  I, J: Integer;
  data: PLRMGridData;
  numCols, numRows: Integer;
begin
  numRows := iNode.ChildNodes.Count; // includes text as column
  numCols := tags.Count; // includes text as column

  SetLength(data, numRows, numCols); // includes text as column
  for I := 0 to iNode.ChildNodes.Count - 1 do
  begin
    data[I][0] := iNode.ChildNodes[I].Text;
    for J := 1 to numCols - 1 do // High(data[0]) do
      data[I][J] := iNode.ChildNodes[I].Attributes[tags[J]];
  end;
  Result := data;
end;

// Values in txtList become XML text and all else are attributes
function xmlAttribToPlrmGridData(iNode: IXMLNode; tags: TStringList)
  : PLRMGridData;
var
  I, J: Integer;
  data: PLRMGridData;
  numCols, numRows: Integer;
begin
  numRows := iNode.ChildNodes.Count; // includes text as column
  numCols := tags.Count; // includes text as column
  SetLength(data, numRows, numCols); // includes text as column
  for I := 0 to iNode.ChildNodes.Count - 1 do
  begin
    for J := 0 to numCols - 1 do // High(data[0]) do
      data[I][J] := iNode.ChildNodes[I].Attributes[tags[J]];
  end;
  Result := data;
end;

// Values in txtList become XML text and txtNodeLabelList are used as node labels, all else are attributes
function plrmGridDataToXML(topNodeLabel: String; data: PLRMGridData;
  tags: TStringList; txtList: TStringList; txtNodeLabelList: TStringList)
  : IXMLNodeList;
var
  I, J: Integer;
  root: IXMLNode;
  tempNode: IXMLNode;
  XMLDoc: IXMLDocument;
begin

  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := true;
  root := XMLDoc.AddChild(topNodeLabel);
  // name at this node does not matter just need a list of nodes
  for I := 0 to High(data) do
  begin
    tempNode := root.AddChild(txtNodeLabelList[I]);
    tempNode.Text := txtList[I];
    for J := 0 to High(data[0]) do
      tempNode.Attributes[tags[J]] := data[I][J];
  end;
  Result := root.ChildNodes;
end;

// Values in txtList become XML text and txtNodeLabelList are used as node labels, all else are attributes
function plrmGridDataToXML2(topNodeLabel: String; data: PLRMGridData;
  tags: TStringList; txtList: TStringList; txtNodeLabelList: TStringList)
  : IXMLNodeList;
var
  I, J: Integer;
  root: IXMLNode;
  tempNode: IXMLNode;
  XMLDoc: IXMLDocument;
begin

  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := true;
  root := XMLDoc.AddChild(topNodeLabel);
  // name at this node does not matter just need a list of nodes
  for I := 0 to High(data) do
  begin
    tempNode := root.AddChild(txtNodeLabelList[I]);
    tempNode.Text := txtList[I];
    for J := 0 to High(data[0]) do
      tempNode.Attributes[tags[J]] := data[I][J];
  end;
  Result := root.ChildNodes;
end;

// Values in valColNum column become attributes and column o becomes XML text
function plrmGridDataToXML(nodeName: String; data: PLRMGridData;
  tags: TStringList; valColNum: Integer): IXMLNodeList;
var
  I: Integer;
  root: IXMLNode;
  tempNode: IXMLNode;
  XMLDoc: IXMLDocument;
begin

  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := true;
  root := XMLDoc.AddChild(nodeName);
  // name at this node does not matter just need a list of nodes
  for I := 0 to High(data) do
  begin
    tempNode := root.AddChild(nodeName);
    tempNode.Text := data[I][0];
    tempNode.Attributes[tags[I]] := data[I][valColNum];
  end;
  Result := root.ChildNodes;
end;

{$ENDREGION}
{$REGION 'GUI Helper methods'}

// Based on code by Lew Rossman in unit PropEdit ln 504 +
// Use for stringGrids only
procedure gsEditKeyPress(Sender: TObject; var Key: Char;
  const exptdTypeCode: TExptdTypeCodes);
// -----------------------------------------------------------------------------
// Used by OnKeyPress events for TStringGrids to handle edits
// based on Lew R. procedure TPropEdit.EditKeyPress(Sender: TObject; var Key: Char);
// -----------------------------------------------------------------------------
begin
  // allow backspace and enter  and decimal
  if (Key = #8) or (Key = #13) or (Key = '.') then
    exit;

  // if (Key in [' ', '"', ';']) then
  if (CharInSet(Key, [' ', '"', ';'])) then
    Key := #0; // ignore spaces

  // allow 0 - 9 and numpad 0 to numpad 9
  // if (not(CharInSet(Key, [#48 .. #57]))) then
  if (not(Key in [#48 .. #57])) then
    Key := #0;
end;

procedure gsEditKeyPressNoSpace(Sender: TObject; var Key: Char;
  const exptdTypeCode: TExptdTypeCodes);
// -----------------------------------------------------------------------------
// Used by OnKeyPress events for Textboxes use for names to handle edits
// based on Lew R. procedure TPropEdit.EditKeyPress(Sender: TObject; var Key: Char);
// -----------------------------------------------------------------------------
begin
  // allow backspace and enter
  if (Key = #8) or (Key = #13) then
    exit;

  if (CharInSet(Key, ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j'])) then
    exit;
  if (CharInSet(Key, ['k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't'])) then
    exit;
  if (CharInSet(Key, ['u', 'v', 'w', 'x', 'y', 'z'])) then
    exit;
  { if (Key in ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j']) then exit;
    if (Key in ['k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't']) then exit;
    if (Key in ['u', 'v', 'w', 'x', 'y', 'z']) then exit; }

  // disallow punctuation
  if (CharInSet(Key, ['"', ';', '?', '/', '!', '\', '|', '[', ']', '=', '<',
    '>', ':', '^', '@'])) then
    // if (Key in ['"', ';', '?', '/', '!', '\', '|', '[', ']', '=','<','>',':','^','@']) then
    Key := #0;
  if exptdTypeCode = gemNoSpace then
    if (Key = ' ') then
      Key := #0;

  // allow 0 - 9 and numpad 0 to numpad 9
  if (not(Key in [#48 .. #105])) then
    Key := #0;
end;

// Combobox must contain strings and objects
procedure updateGeneralCbxItems(var cbxDest: TCombobox;
  const cbxSource: TCombobox);
var
  I: Integer;
begin
  for I := 0 to cbxSource.Items.Count - 1 do
  begin
    if cbxDest.Items.IndexOf(cbxSource.Items[I]) = -1 then
      cbxDest.Items.AddObject(cbxSource.Items[I], cbxSource.Items.Objects[I]);
  end;
end;

function gridContainsStr(searchStr: String; strColNum: Integer;
  Grd: TStringGrid): boolean;
var
  R, C: LongInt;
begin
  for R := 0 to Grd.RowCount - 1 do
  begin
    C := 0;
    if Grd.Cells[C, R] = searchStr then
    begin
      Result := true;
      exit;
    end;
  end;
  Result := false;
end;

// Based on SWMM5   TGridEditFrame.DeleteOneRow;
procedure deleteGridRow(searchStr: String; strColNum: Integer;
  initCellStr: string; var Grd: TStringGrid);
var
  R, C, lastRow: LongInt;
begin
  lastRow := Grd.RowCount - 1;
  for R := 1 to lastRow do
  begin
    if Grd.Cells[0, R] = searchStr then
    begin
      for C := Grd.FixedCols to Grd.ColCount - 1 do
      begin
        Grd.Cells[C, R] := Grd.Cells[C, lastRow];
        Grd.Cells[C, lastRow] := initCellStr;
      end;

      Grd.RowCount := Grd.RowCount - 1;
      exit;
    end;
  end;
end;

procedure AddGridRow(inStr: String; Grd: TStringGrid; strColNum: Integer);
var
  lastRow: LongInt;
begin
  if Grd.Cells[0, 1] = '' then
  begin
    Grd.Cells[0, 1] := inStr;
    exit
  end;
  lastRow := Grd.RowCount;
  Grd.RowCount := Grd.RowCount + 1;
  Grd.Cells[strColNum, lastRow] := inStr;
end;

procedure AddSoilsGridRow(inStr: String; Grd: TStringGrid; strColNum: Integer);
var
  lastRow: LongInt;
begin
  if Grd.Cells[0, 1] = '' then
  begin
    Grd.Cells[0, 1] := inStr;
    exit
  end;
  lastRow := Grd.RowCount;
  Grd.RowCount := Grd.RowCount + 1;
  Grd.Cells[strColNum, lastRow] := inStr;
end;

// TODO Adapted from http://www.delphicorner.f9.co.uk/articles/comps6.htm
procedure TransferLstBxItems(Dest: TListbox; var Source: TListbox);
var
  I: Integer;
begin
  with Source do
  begin
    for I := 0 to Items.Count - 1 do
      if Selected[I] then
        Dest.Items.add(Items[I]);

    for I := 0 to Dest.Items.Count - 1 do
      Items.Delete(Items.IndexOf(Dest.Items[I]));
  end;
end;

procedure TransferAllLstBxItems(Dest, Source: TListbox);
var
  I: Integer;
begin
  with Source do
  begin
    for I := 0 to Items.Count - 1 do
      Dest.Items.add(Items[I]);

    for I := 0 to Dest.Items.Count - 1 do
      Items.Delete(Items.IndexOf(Dest.Items[I]));
  end;
end;

// Copies data
function copyContentsToGrid(const data: PLRMGridData; const strtCol: Integer;
  strtRow: Integer; var sg: TStringGrid): boolean;
var
  irow: Integer;
  icol: Integer;
begin
  Result := false;
  if data <> nil then
    if High(data) = sg.RowCount - (1 + strtRow) then
      if data[0] <> nil then
        if (High(data[0]) = sg.ColCount - (1 + strtCol)) then
        begin
          for irow := strtRow to sg.RowCount - 1 do
            for icol := strtCol to sg.ColCount - 1 do
              sg.Cells[icol, irow] := data[irow - strtRow, icol - strtCol];
          // yes grid index is col first and then row
          Result := true;
        end;

end;

// copies a limited number of rows and columns to grid
function copyContentsToGridSubset(const data: PLRMGridData;
  const strtCol: Integer; strtRow: Integer; numColsToCopy: Integer;
  numRowsToCopy: Integer; var sg: TStringGrid): boolean;
var
  irow: Integer;
  icol: Integer;
begin
  Result := false;
  if data <> nil then
    if data[0] <> nil then
    begin
      for irow := strtRow to strtRow + numRowsToCopy do
        for icol := strtCol to strtCol + numColsToCopy do
          sg.Cells[icol, irow] := data[irow - strtRow, icol - strtCol];
      // yes grid index is col first and then row
      Result := true;
    end;
end;

function copyInvertedPLRMGridToStrGrid(const data: PLRMGridData;
  const strtCol: Integer; strtRow: Integer; var sg: TStringGrid): boolean;
var
  irow: Integer;
  icol: Integer;
  // chk : integer;
begin
  Result := false;
  if data <> nil then
    // chk:=High(data);
    if High(data) = sg.ColCount - (1 + strtCol) then
      if data[0] <> nil then
        if (High(data[0]) = sg.RowCount - (1 + strtRow)) then
        begin
          for irow := strtRow to sg.RowCount - 1 do
            for icol := strtCol to sg.ColCount - 1 do
              sg.Cells[icol, irow] := data[icol - strtCol, irow - strtRow];
          Result := true;
        end;

end;

function copyContentsToGridNChk(const data: PLRMGridData;
  const strtCol: Integer; strtRow: Integer; var sg: TStringGrid): boolean;
var
  irow: Integer;
  icol: Integer;
begin
  Result := false;
  sg.RowCount := High(data) + 1 + strtRow;
  if data <> nil then
    if data[0] <> nil then
    begin
      for irow := strtRow to sg.RowCount - 1 do
        for icol := strtCol to sg.ColCount - 1 do
          sg.Cells[icol, irow] := data[irow - strtRow, icol - strtCol];
      // yes grid index is col first and then row
      Result := true;
    end;

end;

function copyContentsToGridAddRows(const data: PLRMGridData;
  const strtCol: Integer; strtRow: Integer; var sg: TStringGrid): boolean;
// var
// irow : integer;
// icol : integer;
begin
  if data <> nil then
    while High(data) > sg.RowCount - (1 + strtRow) do
    begin
      sg.RowCount := sg.RowCount + 1;
    end;
  Result := copyContentsToGrid(data, strtCol, strtRow, sg);
end;

function initGrid(const dataStr: String; const strtCol: Integer;
  strtRow: Integer; var sg: TStringGrid): boolean;
var
  irow: Integer;
  icol: Integer;
begin
  for irow := strtRow to sg.RowCount - 1 do
    for icol := strtCol to sg.ColCount - 1 do
      sg.Cells[icol, irow] := dataStr;
  Result := true;
end;

// Copies the contents of a string grid into a 2-D array
function copyGridContents(const sg: TStringGrid): PLRMGridData;
var
  irow: Integer;
  icol: Integer;
  rsltArry: PLRMGridData;
begin
  SetLength(rsltArry, sg.RowCount, sg.ColCount);
  for irow := 0 to sg.RowCount - 1 do
  begin
    for icol := 0 to sg.ColCount - 1 do
      rsltArry[irow, icol] := sg.Cells[icol, irow]
      // yes grid index is col first and then row
  end;
  Result := rsltArry;
end;

// Copies the contents of a string grid into a 2-D array
function copyGridContents(const strtCol: Integer; strtRow: Integer;
  const sg: TStringGrid): PLRMGridData;
var
  irow: Integer;
  icol: Integer;
  rsltArry: PLRMGridData;
begin
  SetLength(rsltArry, sg.RowCount - strtRow, sg.ColCount - strtCol);
  for irow := strtRow to sg.RowCount - 1 do
  begin
    for icol := strtCol to sg.ColCount - 1 do
      rsltArry[irow - strtRow, icol - strtCol] := sg.Cells[icol, irow]
      // yes grid index is col first and then row
  end;
  Result := rsltArry;
end;

function copyStringGridToInvertedPLRMGrid(const sg: TStringGrid): PLRMGridData;
var
  irow: Integer;
  icol: Integer;
  rsltArry: PLRMGridData;
begin
  SetLength(rsltArry, sg.ColCount, sg.RowCount);
  for irow := 0 to sg.RowCount - 1 do
  begin
    for icol := 0 to sg.ColCount - 1 do
      rsltArry[icol, irow] := sg.Cells[icol, irow]
  end;
  Result := rsltArry;
end;

// Copies the contents of a string grid into a 2-D array with strings in 1st column into StringList
function copyGridContents(const strtCol: Integer; strtRow: Integer;
  var outStrList: TStringList; const sg: TStringGrid): PLRMGridData;
var
  irow: Integer;
  icol: Integer;
  rsltArry: PLRMGridData;
  rsltList: TStringList;
begin
  rsltList := TStringList.Create;
  SetLength(rsltArry, sg.RowCount - 1, sg.ColCount - strtCol);
  for irow := strtRow to sg.RowCount - 1 do
  begin
    rsltList.add(sg.Cells[0, irow]);
    for icol := strtCol to sg.ColCount - 1 do
      rsltArry[irow - strtRow, icol - strtCol] := sg.Cells[icol, irow]
      // yes grid index is col first and then row
  end;
  outStrList := rsltList;
  Result := rsltArry;
end;

// Copies the contents of a string grid into a 2-D array with strings in 1st column into StringList
// Copies only when values valColumn are greater than or equal to leastVal
function copyGridContents(const strtCol: Integer; strtRow: Integer;
  var outStrList: TStringList; const sg: TStringGrid; const valCol: Integer;
  const grtrThanVal: Double = 0): PLRMGridData;
var
  irow: Integer;
  icol: Integer;
  rsltArry, tempArry: PLRMGridData;
  rsltList: TStringList;
  I, J, tempInt: Integer;
begin
  rsltList := TStringList.Create;
  SetLength(tempArry, sg.RowCount - 1, sg.ColCount - strtCol);
  tempInt := 0;
  for irow := strtRow to sg.RowCount - 1 do
  begin
    if (strToFloat(sg.Cells[valCol, irow]) > grtrThanVal) then
    begin
      tempInt := tempInt + 1;
      rsltList.add(sg.Cells[0, irow]);
      for icol := strtCol to sg.ColCount - 1 do
        tempArry[tempInt - 1, icol - strtCol] := sg.Cells[icol, irow]
        // grid index is col first and then row
    end;
  end;
  SetLength(rsltArry, tempInt, sg.ColCount - strtCol);
  for I := 0 to High(rsltArry) do
    for J := 0 to High(rsltArry[I]) do
      rsltArry[I, J] := tempArry[I, J];
  outStrList := rsltList;
  Result := rsltArry;
end;

procedure DefaultCopyDataProc(oldnode, newnode: TTreenode);
begin
  newnode.Assign(oldnode);
end;

procedure CopySubtree(sourcenode: TTreenode; target: TTreeview;
  targetnode: TTreenode; CopyProc: TCopyDataProc = nil);
var
  anchor: TTreenode;
  child: TTreenode;
begin { CopySubtree }
  Assert(assigned(sourcenode), 'CopySubtree:sourcenode cannot be nil');
  Assert(assigned(target), 'CopySubtree: target treeview cannot be nil');
  Assert((targetnode = nil) or (targetnode.TreeView = target),
    'CopySubtree: targetnode has to be a node in the target treeview.');

  if (sourcenode.TreeView = target) and (targetnode.HasAsParent(sourcenode) or
    (sourcenode = targetnode)) then
    raise Exception.Create('CopySubtree cannot copy a subtree to one of the ' +
      'subtrees nodes.');

  if not assigned(CopyProc) then
    CopyProc := DefaultCopyDataProc;

  anchor := target.Items.AddChild(targetnode, sourcenode.Text);
  DefaultCopyDataProc(sourcenode, anchor);
  child := sourcenode.GetFirstChild;
  while assigned(child) do
  begin
    CopySubtree(child, target, anchor, CopyProc);
    child := child.getNextSibling;
  end; // While
end; // CopySubtree

function getComboBoxSelValue(Sender: TObject): String;
var
  idx: Integer;
  value: String;
begin
  idx := TCombobox(Sender).ItemIndex;
  value := String(TCombobox(Sender).Items.Objects[idx]);
  Result := value
end;

function getComboBoxSelValue2(Sender: TObject): TObject;
var
  idx: Integer;
  value: TObject;
begin
  idx := TCombobox(Sender).ItemIndex;
  if idx = -1 then
    exit;
  value := TCombobox(Sender).Items.Objects[idx];
  Result := value
end;

procedure sgGrayOnDrawCell(var Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; colNum: Integer; rowNum: Integer);
var
  s: String;
var
  sg: TStringGrid;
begin
  sg := (Sender as TStringGrid);
  if ((ACol = colNum) or (ARow = rowNum)) then
  begin
    sg.Canvas.Brush.Color := cl3DLight;
    sg.Canvas.FillRect(Rect);
    s := sg.Cells[ACol, ARow];
    sg.Canvas.Font.Color := clBlue;
    sg.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, s);
  end;
end;

procedure sgGrayOnDrawCell2ColsNRow(var Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; colNum1: Integer; colNum2: Integer;
  rowNum: Integer);
var
  s: String;
var
  sg: TStringGrid;
begin
  sg := (Sender as TStringGrid);
  if ((ACol = colNum1) or (ACol = colNum2) or (ARow = rowNum)) then
  begin
    sg.Canvas.Brush.Color := cl3DLight;
    sg.Canvas.FillRect(Rect);
    s := sg.Cells[ACol, ARow];
    sg.Canvas.Font.Color := clBlue;
    sg.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, s);
  end;
end;

procedure sgGrayOnDrawCell2ColsOnly(var Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; colNum1: Integer; colNum2: Integer);
var
  s: String;
var
  sg: TStringGrid;
begin
  sg := (Sender as TStringGrid);
  if ((ACol = colNum1) or (ACol = colNum2)) then
  begin
    sg.Canvas.Brush.Color := cl3DLight;
    sg.Canvas.FillRect(Rect);
    s := sg.Cells[ACol, ARow];
    sg.Canvas.Font.Color := clBlue;
    sg.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, s);
  end;
end;

procedure sgGrayOnDrawCell3ColsOnly(var Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; colNum1: Integer; colNum2: Integer;
  colNum3: Integer);
var
  s: String;
var
  sg: TStringGrid;
begin
  sg := (Sender as TStringGrid);
  if ((ACol = colNum1) or (ACol = colNum2) or (ACol = colNum3)) then
  begin
    sg.Canvas.Brush.Color := cl3DLight;
    sg.Canvas.FillRect(Rect);
    s := sg.Cells[ACol, ARow];
    sg.Canvas.Font.Color := clBlue;
    sg.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, s);
  end;
end;

// Displays message box saying cell is uneditable if in the 1st column
procedure sgSelectCellWthNonEditCol(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: boolean; colNum: Integer);
begin
  if ACol = colNum then
  begin
    ShowMessage(CELLNOEDIT);
  end
  else
  begin
  end;
end;

procedure FreeObjects(const strings: TStrings);
var
  s: Integer;
  o: TObject;
begin
  for s := 0 to Pred(strings.Count) do
  begin
    o := strings.Objects[s];
    FreeAndNil(o);
  end;
end;

// Displays message box saying cell is uneditable if in the specified columns
procedure sgSelectCellWthNonEditCol(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: boolean; colNum1: Integer; colNum2: Integer; colNum3: Integer);
var
  sg: TStringGrid;
begin
  sg := TStringGrid(Sender);
  if ((ACol = colNum1) or (ACol = colNum2) or (ACol = colNum3)) then
  begin
    sg.Options := sg.Options - [goEditing];
    ShowMessage(CELLNOEDIT);
  end
  else
  begin
    sg.Options := sg.Options + [goEditing];
  end;
end;

// Displays message box saying cell is uneditable if in the specified column and specified row column
procedure sgSelectCellWthNonEditColNRow(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: boolean; colNum: Integer; rowNum: Integer);
var
  sg: TStringGrid;
begin
  sg := TStringGrid(Sender);
  if ((ACol = colNum) and (ARow = rowNum)) then
  begin
    sg.Options := sg.Options - [goEditing];
    ShowMessage(CELLNOEDIT);
  end
  else
    sg.Options := sg.Options + [goEditing];
end;

// Grays cells in grid if in the specified column and specified row column
procedure sgGrayOnDrawCellColAndRow(var Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState; colNum: Integer; rowNum: Integer);
var
  s: String;
var
  sg: TStringGrid;
begin
  sg := (Sender as TStringGrid);
  if ((ACol = colNum) and (ARow = rowNum)) then
  begin
    sg.Canvas.Brush.Color := cl3DLight;
    sg.Canvas.FillRect(Rect);
    s := sg.Cells[ACol, ARow];
    sg.Canvas.Font.Color := clBlue;
    sg.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, s);
  end;
end;

// http://www.delphitricks.com/source-code/components/delete_a_row_in_a_tstringgrid.html
procedure GridDeleteRow(RowNumber: Integer; var Grid: TStringGrid);
var
  I: Integer;
begin
  Grid.Row := RowNumber;
  if (Grid.Row = Grid.RowCount - 1) then
    { On the last row }
    Grid.RowCount := Grid.RowCount - 1
  else
  begin
    { Not the last row }
    for I := RowNumber to Grid.RowCount - 1 do
      Grid.Rows[I].Assign(Grid.Rows[I + 1]);
    Grid.RowCount := Grid.RowCount - 1;
  end;
end;
{$ENDREGION}

function gsSelectDirectory(initDir: String): String;
begin
  if Win32MajorVersion >= 6 then
    with TFileOpenDialog.Create(nil) do
      try
        Title := 'Select Directory';
        Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem];
        OkButtonLabel := 'Select';
        DefaultFolder := initDir;
        FileName := initDir;
        if Execute then
        begin
          // ShowMessage(FileName);
          Result := FileName;
        end;
      finally
        Free;
      end
  else
  begin
    if selectDirectory('Select Directory', ExtractFileDrive(initDir), initDir,
      [sdNewUI, sdNewFolder], Nil) then
    begin
      ShowMessage(initDir);
      Result := initDir;
    end;
  end;
end;

procedure initPLRMPaths();
begin
  defaultPLRMPath := StringReplace(ExtractFileDir(Application.ExeName),
    '\Engine', '', [rfReplaceAll, rfIgnoreCase]);
  defaultXMLDeclrtn := '<?xml version="1.0"?>';

  // if default project workspace path has not been updated from .ini file then use the default and save it to the
  // ini file
  if (defaultPrjDir = '') then
  begin
    defaultPrjDir := defaultPLRMPath + '\Projects';
    SaveIniFile();
  end;

  defaultGISDir := defaultPLRMPath + '\GIS';
  defaultSchmDir := defaultPLRMPath + '\Schemes';
  defaultEngnDir := defaultPLRMPath + '\Engine';
  PLRMInitIni := defaultEngnDir + '\swmm.ini';
  defaultDataDir := defaultPLRMPath + '\Data';

  defaultDBPath := defaultDataDir + '\PLRM_v2.0.accdb';
  defaultPrjPath := defaultPrjDir + '\temp.xml';
  // defaultGenSWmmInpPath := defaultPrjDir + '\tempSwmm.inp';
  defaultGenSWmmInpPath := defaultPrjDir + '\' + GSTEMPSWMMINP;
  defaultUserSWmmInpPath := defaultPrjDir + '\swmm.inp';
  defaultUserSwmmRptPath := defaultPrjDir + '\swmm.rpt';
  defaultValidateDir := defaultEngnDir + '\Validation';
  defaultValidateFilePath := defaultValidateDir + '\validation.html';

  dbPath := defaultDBPath;
  initDbPath();
  HYDSCHMSDIR := defaultEngnDir +
    '\DefaultSchemes\Hydroloic Properties Schemes';
  RCONDSCHMSDIR := defaultEngnDir + '\DefaultSchemes\Road Condition Schemes';
end;

// 2014 added to allow projects folder path to be changed
procedure updatePLRMPaths(newPrjDir: String);
begin
  // defaultPLRMPath := StringReplace(ExtractFileDir(Application.ExeName),
  // '\Engine', '', [rfReplaceAll, rfIgnoreCase]);
  // defaultXMLDeclrtn := '<?xml version="1.0"?>';

  defaultPrjDir := newPrjDir;
  // update ini file
  SaveIniFile();

  // defaultSchmDir := defaultPLRMPath + '\Schemes';
  // defaultEngnDir := defaultPLRMPath + '\Engine';
  // PLRMInitIni := defaultEngnDir + '\swmm.ini';
  // defaultDataDir := defaultPLRMPath + '\Data';
  // defaultDBPath := defaultDataDir + '\PLRM_v1.0.accdb';
  // defaultDBPath := defaultDataDir + '\PLRM_v2.0.accdb';
  defaultPrjPath := defaultPrjDir + '\temp.xml';
  // defaultGenSWmmInpPath := defaultPrjDir + '\tempSwmm.inp';
  defaultGenSWmmInpPath := defaultPrjDir + '\' + GSTEMPSWMMINP;
  defaultUserSWmmInpPath := defaultPrjDir + '\swmm.inp';
  defaultUserSwmmRptPath := defaultPrjDir + '\swmm.rpt';
  // defaultValidateDir := defaultEngnDir + '\Validation';
  // defaultValidateFilePath := defaultValidateDir + '\validation.html';

  // dbPath := defaultDBPath;
  // initDbPath();
  // HYDSCHMSDIR := defaultEngnDir +
  // '\DefaultSchemes\Hydroloic Properties Schemes';
  // RCONDSCHMSDIR := defaultEngnDir + '\DefaultSchemes\Road Condition Schemes';
end;

function dbFields2ToPLRMGridData(data: dbReturnFields2; strtRowIdx: Integer = 0)
  : PLRMGridData;
var
  I, J: Integer;
  rslt: PLRMGridData;
begin
  SetLength(rslt, (data[0].Count - strtRowIdx), High(data) + 1);
  for I := strtRowIdx to data[0].Count - 1 do
    for J := 0 to High(rslt[0]) do
      rslt[I - strtRowIdx][J] := data[J][I];
  Result := rslt;
end;

// transposes columns and rows
function PLRMGridDblToPLRMGridData(data: PLRMGridDataDbl;
  strtRowIdx: Integer = 0; formatStr: String = THREEDP): PLRMGridData;
var
  I, J: Integer;
  rslt: PLRMGridData;
begin
  SetLength(rslt, (High(data[0]) - strtRowIdx + 1), High(data) + 1);
  for I := strtRowIdx to High(data[0]) do
    for J := 0 to High(rslt[0]) do
      rslt[I - strtRowIdx][J] := FormatFloat(formatStr, data[J][I]);
  Result := rslt;
end;

// does not transpose columns and rows
function PLRMGridDblToPLRMGridDataNT(data: PLRMGridDataDbl;
  formatStr: String = THREEDP): PLRMGridData;
var
  I, J: Integer;
  rslt: PLRMGridData;
begin
  SetLength(rslt, High(data) + 1, High(data[0]) + 1);
  for I := 0 to High(data) do
    for J := 0 to High(data[0]) do
      rslt[I, J] := FormatFloat(formatStr, data[I, J]);
  Result := rslt;
end;

function dbFields3ToPLRMGridData(data: dbReturnFields3; strtRowIdx: Integer = 0)
  : PLRMGridData;
var
  I, J: Integer;
  rslt: PLRMGridData;
begin
  SetLength(rslt, (data[0].Count - strtRowIdx), High(data) + 1);
  for I := strtRowIdx to data[0].Count - 1 do
    for J := 0 to High(rslt[0]) do
      rslt[I - strtRowIdx][J] := data[J][I];
  Result := rslt;
end;

{ Adapted from: http://www.awitness.org/delphi_pascal_tutorial/index.html 09/25/08
  scan the directories and subdirectories for files
  and folders and insert them onto the Treeview }
function FileLook(genSpec: string; myFileExt: string; Node: TTreenode;
  TV: TTreeview): boolean;
var
  tempNode: TTreenode;
  validres: Integer;
  SearchRec: TSearchRec;
  dirPath, FullName, Flname: string;
begin

  dirPath := ExtractFilePath(genSpec);
  Result := DirectoryExists(dirPath);
  If not Result then
    exit;
  Flname := ExtractFileName(genSpec);
  validres := FindFirst(genSpec, faAnyFile, SearchRec);
  while validres = 0 do
  begin
    If (SearchRec.name[1] <> '.') then
    begin { not a dotted directory }
      FullName := dirPath + LowerCase(SearchRec.name);
      { add folder/file as child of current Node }
      If ((SearchRec.Attr and faDirectory > 0) or
        (AnsiContainsStr(SearchRec.name, myFileExt))) then
        tempNode := TV.Items.AddChild(Node, SearchRec.name);
      If (SearchRec.Attr and faDirectory > 0) then
      begin { is a folder }
        tempNode.ImageIndex := ISAClosedFolder;
        tempNode.SelectedIndex := ISAOpenFolder;
        FileLook(FullName + '\' + Flname, myFileExt, tempNode, TV);
      end
      else { not a folder must be a file }
    end;
    validres := FindNext(SearchRec);
    { continue scanning current folder for files and other folders }
  end;
  // ML Added 4/13/09. Must free up resources used by these successful finds
  SysUtils.FindClose(SearchRec);
end;

function FolderLookAddUserName(startPath: string; Node: TTreenode;
  TV: TTreeview): boolean;
var
  projSL: TStringList;
  scenSL: TStringList; // this string holds the scenario IDs (e.g., scenario1)
  scenSL2: TStringList; // this string list holds the user scenario names
  tempNode: TTreenode;
  scenPath: String;
  I, J: Integer;
  tempstr: String;
  tempPrjName: String; // temporary user name for project
  SearchRec: TSearchRec;
  prjIdx, tempInt: Integer;
  projNames: TStringList;
  // stores project names on tree used with projFolders list below to facilitate deletion
  projFolders: TStringList;
  // stores project folder names corresponding to project names on tree to facilitate deletion
  scenFolders: TStringList;
  // stores scenario folder names corresponding to scenario names on tree to facilitate deletion
  scenFilePaths: TStringList; // ditto
  scenNames: TStringList;
  // stores scenario names on tree used with scenFolders list below to facilitate deletion

begin
  Result := DirectoryExists(startPath);
  If not Result then
    exit;

  PLRMTree := TProjTree.Create;

  if not(assigned(projNames)) then
    projNames := TStringList.Create;
  if not(assigned(projFolders)) then
    projFolders := TStringList.Create;
  if not(assigned(scenNames)) then
    scenNames := TStringList.Create;
  if not(assigned(scenFolders)) then
    scenFolders := TStringList.Create;
  if not(assigned(scenFilePaths)) then
    scenFilePaths := TStringList.Create;

  projSL := getFoldersInFolder(startPath);
  // if the directory is empty exit
  If projSL.Count < 1 then
  begin
    exit;
  end;

  // remove all the items currently in the treeview before adding new ones
  TV.Items.Clear();

  // Add project and scenario folders to TreeView
  for I := 0 to projSL.Count - 1 do
  begin
    // check if directory contains project file if not do not add to list
    if (FindFirst(startPath + '\' + projSL[I] + '\*.xml', faAnyFile,
      SearchRec) = 0) then
    begin
      projFolders.add(startPath + '\' + projSL[I]);
      tempPrjName := getUserProjectOrScenName(startPath + '\' + projSL[I] + '\'
        + SearchRec.name, 'ProjectUserName');
      prjIdx := projNames.add(tempPrjName);
      tempNode := TV.Items.AddChild(Node, projNames[prjIdx]);
      scenPath := startPath + '\' + projSL[I];

      scenSL2 := TStringList.Create;
      If DirectoryExists(scenPath) then
      begin
        scenSL := getFoldersInFolder(scenPath);
        for J := 0 to scenSL.Count - 1 do
        begin
          // check if scenario contains scenario file if not do not add to list
          if (FindFirst(scenPath + '\' + scenSL[J] + '\scenario*.xml',
            faAnyFile, SearchRec) = 0) then
          begin
            scenFolders.add(scenPath + '\' + scenSL[J]);
            tempInt := scenFilePaths.add(scenPath + '\' + scenSL[J] + '\' +
              SearchRec.name);
            tempstr := getUserProjectOrScenName(scenFilePaths[tempInt],
              'ScenName');
            scenNames.add(tempstr + projNames[prjIdx]);
            TV.Items.AddChild(tempNode, tempstr);
            scenSL2.add(tempstr);
          end;
        end;
        PLRMTree.PID.AddObject(projSL[I], scenSL);
        PLRMTree.PrjNames.AddObject(tempPrjName, scenSL2);
      end;
    end;
  end;
  // Must free up resources used by these successful finds
  SysUtils.FindClose(SearchRec);
  FreeAndNil(projNames);
  FreeAndNil(projFolders);
  FreeAndNil(scenFolders);
  FreeAndNil(scenFilePaths);
  FreeAndNil(scenNames);
  FreeAndNil(projSL);

  // scenSL := nil; //Memory release via prjNames when tree destroyed
  // scenSL2 := nil; //Memory release via prjNames when tree destroyed

end;

// http://www.delphi3000.com/articles/article_2049.asp?SK=
function CopyFolderContents(const FromFolder: string; ToFolder: string): string;
var
  Fo: TSHFileOpStruct;
  buffer: array [0 .. 4096] of Char;
  p: pchar;
  dir: string;
  FileName: string;
begin
  FillChar(buffer, sizeof(buffer), #0);
  p := @buffer;
  StrECopy(p, pchar(FromFolder)); // this is folder that you want to copy
  FillChar(Fo, sizeof(Fo), #0);
  Fo.Wnd := Application.Handle;
  Fo.wFunc := FO_COPY;
  Fo.pFrom := @buffer;
  // check if destination already exists

  while (fileExists(ToFolder)) do
  begin
    dir := ExtractFileDir(ToFolder);
    FileName := ExtractFileName(ToFolder);
    ToFolder := dir + '\CopyOf' + FileName;
  end;
  Fo.pTo := pchar(ToFolder); // this is where the folder will go
  Fo.fFlags := 0;
  if ((SHFileOperation(Fo) <> 0) or (Fo.fAnyOperationsAborted <> false)) then
    ShowMessage('File copy process cancelled');
  Result := ToFolder;
end;

{ DP added recursive backtrack from a node to the root, keeping track of node names
  with the assumtion that the node names represent directory or filenames and the root
  is the root folder }
function getFilePath(Node: TTreenode; TV: TTreeview): string;
begin
  If (Node.Parent = nil) then
  begin
    Result := defaultPrjDir + '\' + Node.Text;
    exit;
  end
  else
  begin
    Result := getFilePath(Node.Parent, TV) + '\' + Node.Text;
    exit;
  end;
end;

function checkNCreateDirectory(folderPath: String): boolean;
begin
  if DirectoryExists(folderPath) = false then
  // need to create, but check for project folder first
  begin
    if not CreateDir(folderPath) then
    begin
      ShowMessage('Failed to add ' + folderPath + '. Error: ' +
        IntToStr(GetLastError));
      Result := false;
      exit;
    end;
  end;
  Result := true;
end;

procedure removeDirGS(const dirPath: String);
// ML rewrote this function 4/13/09
begin
  if RemoveDir(dirPath) then
    ShowMessage('Directory' + dirPath + ' removed OK')
  else
    ShowMessage('Remove directory failed with error : ' +
      IntToStr(GetLastError));
end;

// adapted from http://delphi.about.com/cs/adptips1999/a/bltip1199_2.htm
Function DelTree(DirName: string): boolean;
var
  SHFileOpStruct: TSHFileOpStruct;
  DirBuf: array [0 .. 255] of Char;
begin
  try
    FillChar(SHFileOpStruct, sizeof(SHFileOpStruct), 0);
    FillChar(DirBuf, sizeof(DirBuf), 0);
    StrPCopy(DirBuf, DirName);
    with SHFileOpStruct do
    begin
      Wnd := 0;
      pFrom := @DirBuf;
      wFunc := FO_DELETE;
      fFlags := FOF_ALLOWUNDO;
      fFlags := fFlags or FOF_NOCONFIRMATION;
      fFlags := fFlags or FOF_SILENT;
    end;
    Result := (SHFileOperation(SHFileOpStruct) = 0);
  except
    Result := false;
  end;
end;

function deleteFileGS(const filePath: String): Integer;
begin
  if fileExists(filePath) then
    ShowMessage(filePath + ' will be deleted')
  else
  begin
    ShowMessage(filePath + ' does not exist');
    Result := 0;
    exit;
  end;

  DeleteFile(pchar(filePath));
  // check to see if file deleted successfully
  if fileExists(filePath) then
  begin
    ShowMessage('could not delete file:' + filePath +
      ' check to see if file is open!');
    Result := -1;
  end
  else
  begin
    ShowMessage(filePath + ' successfully deleted');
    Result := 1
  end;
end;

function deleteFileGSNoConfirm(const filePath: String): Integer;
begin
  if fileExists(filePath) = false then
  begin
    ShowMessage(filePath + ' does not exist');
    Result := 0;
    exit;
  end;

  DeleteFile(pchar(filePath));
  // check to see if file deleted successfully
  if fileExists(filePath) then
  begin
    Result := -1;
  end
  else
  begin
    Result := 1
  end;
end;

function gsVectorMultiply(dArr1: TStringList; dArr2: TStringList): Double;
var
  I: Integer;
  rslt: Double;
begin
  rslt := 0;
  for I := 0 to dArr1.Count - 1 do
  begin
    rslt := rslt + (strToFloat(dArr1[I]) * strToFloat(dArr2[I]));
  end;
  Result := rslt;
end;

// From: http://delphi.about.com/cs/adptips2004/a/bltip0504_4.htm
// Accessed: 12/08
function BrowseURL(const URL: string): boolean;
var
  Browser: string;
begin
  Result := true;
  Browser := '';
  with TRegistry.Create do
    try
      RootKey := HKEY_CLASSES_ROOT;
      Access := KEY_QUERY_VALUE;
      if OpenKey('\htmlfile\shell\open\command', false) then
        Browser := ReadString('');
      CloseKey;
    finally
      Free;
    end;
  if Browser = '' then
  begin
    Result := false;
    exit;
  end;
  Browser := Copy(Browser, Pos('"', Browser) + 1, Length(Browser));
  Browser := Copy(Browser, 1, Pos('"', Browser) - 1);
  ShellExecute(0, 'open', pchar(Browser), pchar(URL), nil, SW_SHOW);
end;

function getDefaultCatchProps(): PLRMGridData;
var
  dbProps: dbReturnFields2;
begin
  dbProps := getDefaults('"5%"', 1, 2, 3);
  Result := dbFields2ToPLRMGridData(dbProps, 0);
end;

function getFoldersInFolder(const strtFolder: string): TStringList;
var
  validres: Integer;
  SearchRec: TSearchRec;
  rslt: TStringList;
  genSpec: String;
begin
  rslt := TStringList.Create;
  If not DirectoryExists(strtFolder) then
  begin
    ShowMessage(strtFolder + ' folder not found. Now exiting');
    Result := nil;
    exit;
  end;
  genSpec := strtFolder + '\' + '*.*';
  validres := FindFirst(genSpec, faDirectory, SearchRec);
  while validres = 0 do
  begin
    If (SearchRec.name[1] <> '.') then
    begin { not a dotted directory }
      If (SearchRec.Attr and faDirectory > 0) then { is a folder }
        rslt.add(SearchRec.name);
    end;
    validres := FindNext(SearchRec);
    { continue scanning current folder for other folders }

  end;
  Result := rslt;
  // ML Added 4/13/09. Must free up resources used by these successful finds
  SysUtils.FindClose(SearchRec);
end;

// adapted from http://delphi.about.com/od/vclusing/a/findfile.htm
function getFilesInFolder(const strtFolderPath: String; genSpec: String)
  : TStringList;
var
  validres: Integer;
  SearchRec: TSearchRec;
  rslt: TStringList;
begin
  rslt := TStringList.Create;
  If not DirectoryExists(strtFolderPath) then
  begin
    ShowMessage(strtFolderPath + ' folder not found. Now exiting');
    Result := nil;
    exit;
  end;
  genSpec := strtFolderPath + '\' + genSpec;
  validres := FindFirst(genSpec, faAnyFile, SearchRec);
  if (validres = 0) then
    try
      repeat
        rslt.add(SearchRec.name);
      until FindNext(SearchRec) <> 0;
    finally
      SysUtils.FindClose(SearchRec);
    end;
  Result := rslt;
end;

procedure cleanUp();
begin
  FreeAndNil(snowPackNames);
  FreeAndNil(swmmDefaults);
  closeDatabase;
end;

procedure FreeStringListObjects(const strings: TStrings);
var
  s: Integer;
  o: TObject;
begin
  for s := 0 to Pred(strings.Count) do
  begin
    o := strings.Objects[s];
    FreeAndNil(o);
  end;
end;

procedure gsCopyFile(srcPath: String; destPath: String;
  overWrite: boolean = true);
begin
  CopyFile(pchar(srcPath), pchar(destPath), not(overWrite));
end;

end.
