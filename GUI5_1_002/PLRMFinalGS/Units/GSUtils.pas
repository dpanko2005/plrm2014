unit GSUtils;

interface

uses

  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, Dialogs,xmldom, XMLIntf, msxmldom, XMLDoc,
  StdCtrls, ComCtrls, Menus, ImgList, ShlObj, ShellApi, FileCtrl, Registry,
  ExtCtrls, Grids,  GSTypes,StrUtils, MSXML;

 type TCopyDataProc = procedure(oldnode, newnode : TTreenode);

procedure AddGridRow(inStr:String; Grd:TStringGrid; strColNum:Integer);
function BrowseURL(const URL: string) : boolean;
function CopyFolderContents(const FromFolder: string;  ToFolder: string) : string;
procedure CopySubtree(sourcenode : TTreenode; target : TTreeview;  targetnode : TTreenode; CopyProc : TCopyDataProc = nil);
function copyGridContents( const sg :TStringGrid): PLRMGridData; overload;
function copyGridContents( const strtCol:integer; strtRow:integer; const sg :TStringGrid): PLRMGridData; overload;
function copyGridContents( const strtCol:integer; strtRow:integer; var outStrList: TStringList; const sg :TStringGrid): PLRMGridData; overload;
function copyGridContents( const strtCol:integer; strtRow:integer; var outStrList: TStringList; const sg :TStringGrid; const valCol:Integer; const grtrThanVal:Double=0): PLRMGridData; overload;
function copyContentsToGrid( const data:PLRMGridData; const strtCol:integer; strtRow:integer; var sg :TStringGrid): Boolean;
function copyInvertedPLRMGridToStrGrid(const data:PLRMGridData; const strtCol:integer; strtRow:integer; var sg :TStringGrid): Boolean;
function copyStringGridToInvertedPLRMGrid(const sg :TStringGrid): PLRMGridData;
function copyContentsToGridAddRows( const data:PLRMGridData; const strtCol:integer; strtRow:integer; var sg :TStringGrid): Boolean;
function copyContentsToGridNChk( const data:PLRMGridData; const strtCol:integer; strtRow:integer; var sg :TStringGrid): Boolean;
function dbFields2ToPLRMGridData(data:dbReturnFields2; strtRowIdx:Integer = 0):PLRMGridData;
function dbFields3ToPLRMGridData(data:dbReturnFields3; strtRowIdx:Integer = 0):PLRMGridData;
procedure DefaultCopyDataProc(oldnode, newnode : TTreenode);
function deleteFileGS(const filePath : String): Integer;
function deleteFileGSNoConfirm(const filePath : String): Integer;
function DelTree(DirName : string): Boolean;
procedure ForceDeleteDirAndContents(dir: string);
procedure deleteGridRow(searchStr:String; strColNum:Integer; initCellStr:string; var Grd:TStringGrid);
function FileLook(genSpec:string; myFileExt:string; Node:TTreeNode; TV:TTreeview):boolean;
procedure gsCopyFile(srcPath:String; destPath:String; overWrite:Boolean = true);
function FolderLookAddUserName(startPath:string; Node:TTreeNode; TV:TTreeview):boolean;
function getFilesInFolder(const strtFolderPath:String; genSpec:String):TStringList;
function getFoldersInFolder(const strtFolder:string):TStringList;
function getFilePath(Node : TTreeNode; TV:TTreeview):string;
function gridContainsStr(searchStr:String; strColNum:Integer; Grd:TStringGrid):boolean;
function initGrid( const dataStr:String; const strtCol:integer; strtRow:integer; var sg :TStringGrid): Boolean;
function gsVectorMultiply(dArr1 :TStringList; dArr2 : TStringList): Double;
procedure removeDirGS(const dirPath : String);
procedure sgGrayOnDrawCell( var Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState; colNum:Integer; rowNum:Integer);
procedure sgGrayOnDrawCell2ColsOnly( var Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState; colNum1:Integer; colNum2:Integer);
procedure sgGrayOnDrawCell2ColsNRow( var Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState; colNum1:Integer; colNum2:Integer; rowNum:Integer);
procedure sgGrayOnDrawCell3ColsOnly( var Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState; colNum1:Integer; colNum2:Integer; colNum3:Integer);
procedure sgSelectCellWthNonEditCol(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean; colNum:Integer); overload;
procedure sgSelectCellWthNonEditCol(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean; colNum1:Integer; colNum2:Integer;colNum3:Integer); overload;
procedure sgSelectCellWthNonEditColNRow(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean; colNum:Integer; rowNum:Integer);
procedure sgGrayOnDrawCellColAndRow( var Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState; colNum:Integer; rowNum:Integer);
procedure TransferLstBxItems(Dest:TListbox; var Source : TListBox);
procedure TransferAllLstBxItems(Dest, Source : TListBox);
procedure initPLRMPaths();
//GUI Helper Routines
function getComboBoxSelValue(Sender: TObject) : String; Overload;
function getComboBoxSelValue2(Sender: TObject) : TObject; Overload;
procedure GridDeleteRow(RowNumber: Integer; var Grid: TstringGrid);
procedure updateGeneralCbxItems(var cbxDest:TCombobox; const cbxSource :TCombobox);
procedure gsEditKeyPress(Sender: TObject; var Key: Char; const exptdTypeCode:TExptdTypeCodes);
procedure gsEditKeyPressNoSpace(Sender: TObject; var Key: Char; const exptdTypeCode:TExptdTypeCodes);
procedure exportGridToTxt(delimiter:String; sg:TStringGrid; colLables:TStringList; rowLabels:TStringList; filePath:String);overload;
procedure exportGridToTxt(delimiter:String; sg:TStringGrid; sg2:TStringGrid; colLables:TStringList; rowLabels:TStringList; filePath:String);overload;

//XML Routines
function cdataTextToXML(txt :String; nodeName:String):IXMLNode;
function checkNCreateDirectory(folderPath:String):Boolean;
procedure copyCbxObjects(inCbx:TCombobox; var outLst:TStringList);
procedure copyHydSchmToCbx(var outCbx:TCombobox; inLst:TStringList);
function getUserProjectOrScenName(xmlFilePath:String; nodeTag:String):String;
function getDefaultCatchProps():PLRMGridData;
function getXMLRootChildTagValue(tagName:String;filePath:String):String;
function loadXMLDlg():String;
function LoadXmlDoc(const FileName: WideString): IXMLDOMDocument;
function makeSWMMSaveInpFile(inputFilePath:String; rptfilePath : String):Boolean;
function openAndLoadSWMMInptFilefromXML(xmlFilePath:String):Boolean;
function plrmGridDataToXML(nodeName:String; data:PLRMGridData; tags:TStringList; valColNum:Integer):IXMLNodeList;overload;
function plrmGridDataToXML(nodeName:String; data:PLRMGridData; tags:TStringList; txtList:TStringList):IXMLNodeList;overload;
function plrmGridDataToXML3(nodeName:String; rowNodeName:String; data:PLRMGridData; attribTags:TStringList; txtValColumn:integer):IXMLNode;
function plrmGridDataToXML(nodeName:String; rowNodeName:String; data:PLRMGridData; attribTags:TStringList; txtList:TStringList):IXMLNode;overload;
function plrmGridDataToXML(topNodeLabel:String; data:PLRMGridData; tags:TStringList; txtList:TStringList; txtNodeLabelList:TStringList):IXMLNodeList;overload;
function plrmGridDataToXML2(topNodeLabel:String; data:PLRMGridData; tags:TStringList; txtList:TStringList; txtNodeLabelList:TStringList):IXMLNodeList;overload;
procedure reNameProjOrScen(xmlFilePath:String; nodeTag:String; newName:String);
function swmmInptFileRainGageToXML(gageID:String; filePath:String; gageType:String = 'VOLUME';timeIntv:String = '1:00'; snowCatch:String ='1.0'; dataSrcType:String = 'FILE'; param:String = 'IN'):IXMLNode;
function swmmInptFileSoilsToXML(nodeName:String; data:PLRMGridData; tags:TStringList; valColNum:Integer):IXMLNodeList;
procedure saveXmlDoc(saveToPath:String; xmlDoc: IXMLDocument; insertStrLine0:String; insertStrLine1:String);
procedure saveXmlDoc2(saveToPath:String; xmlDoc: IXMLDocument);
function swmmInptFileBuildUpToXML():IXMLNode;
function swmmInptFileCurvesToXML(invtdCurveData:PLRMGridData; curveName:String; curveType:String; var outNode:IXMLNode):IXMLNode;
function swmmInptFileXMLToCurves(invtdCurveData:PLRMGridData; iNode:IXMLNode):PLRMGridData;
function swmmInptFileLandUseToXML(nodeName:String; data:PLRMGridData; tags:TStringList; valColNum:Integer):IXMLNodeList;overload;
function swmmInptFileLandUseToXML(nodeName:String; data:PLRMGridData; tags:TStringList; valColNum:Integer;luseCodeLst:TStringList):IXMLNodeList;overload;
function swmmInptFileLandUseToXML():IXMLNode;overload;
function swmmInptFileLoadingsToXML():IXMLNode;
function swmmInptFileLossesToXML():IXMLNode;
function swmmInptFileMapToXML():IXMLNode;
function swmmInptFilePollutantsToXML():IXMLNode;
function swmmInptFileTagsToXML():IXMLNode;
function swmmInptFileTempTimeSeriesToXML(const seriesName:String; const dataFilePath:String; const seriesType:String = 'FILE'):IXMLNode;
function swmmInptFileWashOffToXML():IXMLNode;
function swmmInptFileReportToXML():IXMLNode;
function swmmBlockLinesToXML(swmmLines:TStringList; nodeName:String; var outNode:IXMLNode):IXMLNode;
function swmmDefaultsToXML(swmmDefaults:TStringList; maxFloLength:Double; widthPower:Double; widthFactor:Double; nodeName:String):IXMLNode;

function catchmentValidationTblToXML():IXMLNode;
function nodeValidationTblToXML():IXMLNode;

function Split(const Delimiter: Char;Input: string;var ResultStrings: TStrings):TStrings;
procedure transformXMLToSwmm(xslFilePath:String; inXMLFilePath:String; outFilePath:String);
function xmlToPlrmGridData(iNode:IXMLNode; tags:TStringList):PLRMGridData;
function xmlAttribToPlrmGridData(iNode:IXMLNode; tags:TStringList):PLRMGridData;
function lookUpCodeFrmName(const searchNames:PLRMGridData;searchCol:Integer; projectNamesList:TStringList; projectCodesList:TStringList):TStringList;
procedure FreeStringListObjects(const strings: TStrings) ;
procedure cleanUp();

const    {ID num for accessing Icons for treeview from  imagelist}
   ISAUnknown = 0;
   ISAClosedFolder = 1;   {only the folders will be used for this example}
   ISAOpenFolder = 2;
   defaultProjName = 'DefaultProject';
   defaultScnName = 'DefaultScenario';

   plrmFileExt = '.xml';
   ramScoreConst1 = 1974.5;
   ramScoreConst2 = -0.69;
   rsltsFormatStrLft = '%-25s';
   rsltsFormatStrRgt = '%18s';
   rsltsFormatDec183f = '%18.3f';
   rsltsFormatDec182f = '%18.2f';
   rsltsFormatDec181f = '%18.1f';
   rsltsFormatDec172f = '%17.2f';

var
  defaultXslPath : String;
  validateXslPath : String;
  luseNameCodeTable:PLRMGridData;
  frmsLuses : array[0..6] of string = ('Primary Road (ROW)','Secondary Road (ROW)','Single Family Residential','Multi Family Residential','CICU','Vegetated Turf', 'Other');
  frmsLuseTags : array[0..6] of string = ('PrimaryRoads','SecondaryRoads','SingleFamilyResidential','MultiFamilyResidential','CICU','Vgt','othr');
  frmsLuseCodes : array[0..6] of string = ('Prr','Ser','Sfr','Mfr','Cic','Vgt','Othr');
  cats : array[0..2] of String = ('High','Moderate','Low');
  pollutantTags: array[0..9] of string = ('code','name','massUnits', 'rainConc','gwConc','iiConc','decayCoef','snowOnly','coPollutName','coPollutFrac');
  currentRptFilePath:String;
  isPLRMStatusReportActive:Boolean;
  snowPackNames: TStringList;
  swmmDefaults: TStringList; // e.g. impervious-n, pervious-n etc. From Database[defaultValues 6%]
  grnWaterXMLTags : array[0..11] of String = ('id','subcatch','aquifer','receivingNode','surfElev','grnWaterFlowCoeff','grndWaterFlowExp','surfWaterFlowCoeff','surfWaterFlowExo','surfGWIntCoef','fxdSWDepth','threshGWElev');
  validationXMLTags :array[0..5] of String = ('parameter','min','max','units','flag','description');

  defaultPLRMPath:String;
  defaultXMLDeclrtn :String;
  defaultPrjDir:String;
  defaultSchmDir:String;
  defaultEngnDir :String;
  defaultDataDir:String;
  defaultDBPath:String;
  defaultPrjPath:String;
  defaultGenSWmmInpPath:String;
  defaultUserSWmmInpPath:String;
  defaultUserSwmmRptPath:String;
  defaultValidateDir:String;
  defaultValidateFilePath:String;
  PLRMInitIni:String;
  HYDSCHMSDIR:String;
  RCONDSCHMSDIR:String;
  dbPath:String;


implementation

uses
Fmain,Uimport,Uglobals,GSIO, UProject, Uoutput, GSFileManage, GSCatchments;
{$REGION 'XML methods'}

function catchmentValidationTblToXML():IXMLNode;
var
  data : PLRMGridData;
  xmlTagList :TStringList;
  I:Integer;
begin
  xmlTagList := TStringList.Create();
  for I := 0 to High(validationXMLTags) do
    xmlTagList.add(validationXMLTags[I]);
  data := getCatchmentValidationRules();
  Result := plrmGridDataToXML3('catchmentValidation','rule', data, xmlTagList, 5);
  FreeAndNil(xmlTagList);
end;

function nodeValidationTblToXML():IXMLNode;
var
  data : PLRMGridData;
  xmlTagList :TStringList;
  I:Integer;
begin
  xmlTagList := TStringList.Create();
  for I := 0 to High(validationXMLTags) do
    xmlTagList.add(validationXMLTags[I]);
  data := getNodeValidationRules();
  Result := plrmGridDataToXML3('nodeValidation','rule', data,xmlTagList, 5);
  FreeAndNil(xmlTagList);
end;

procedure exportGridToTxt(delimiter:String; sg:TStringGrid; colLables:TStringList; rowLabels:TStringList; filePath:String);
var
  I,J:Integer;
  tempstr:String;
  tempLst:TStringList;
begin
  tempLst := TStringList.Create();
  for I := 0 to colLables.Count - 2 do
  begin
     tempStr := tempStr + colLables[I] + delimiter;
  end;
  tempLst.Add(tempStr + colLables[I]); //add titles
  for I := 0 to sg.RowCount - 1 do
  begin
    if rowLabels <> nil then
      tempStr := rowLabels[i]
    else
      tempStr := '';
   for J := 0 to sg.ColCount - 2 do //first and last items added outside loop
   begin
    tempStr := tempStr + sg.Cells[J,I] + delimiter;
   end;
   tempLst.Add(tempStr + sg.Cells[J,I]);
  end;
  tempLst.SaveToFile(filePath) ;
  tempLst.Free;
end;

procedure exportGridToTxt(delimiter:String; sg:TStringGrid; sg2:TStringGrid; colLables:TStringList; rowLabels:TStringList; filePath:String);
var
  I,J:Integer;
  tempstr, headrLine:String;
  tempLst:TStringList;
begin
  tempLst := TStringList.Create();
  for I := 0 to colLables.Count - 2 do
  begin
     tempStr := tempStr + colLables[I] + delimiter;
  end;
  headrLine := (tempStr + colLables[I]);

  tempLst.Add('Scenario Results');
  tempLst.Add(headrLine); //add titles
  //add first string grid
  for I := 0 to sg.RowCount - 1 do
  begin
    if rowLabels <> nil then
      tempStr := rowLabels[i]
    else
      tempStr := '';
   for J := 0 to sg.ColCount - 2 do //first and last items added outside loop
   begin
    tempStr := tempStr + sg.Cells[J,I] + delimiter;
   end;
   tempLst.Add(tempStr + sg.Cells[J,I]);
  end;
  //add second stringGrid
  tempLst.Add(' ');
  tempLst.Add('Scenario Results: Basline and Percent Differences from Baseline');
  tempLst.Add(headrLine); //add titles
  for I := 0 to sg2.RowCount - 1 do
  begin
    if rowLabels <> nil then
      tempStr := rowLabels[i]
    else
      tempStr := '';
   for J := 0 to sg2.ColCount - 2 do //first and last items added outside loop
   begin
    tempStr := tempStr + sg2.Cells[J,I] + delimiter;
   end;
   tempLst.Add(tempStr + sg2.Cells[J,I]);
  end;
  tempLst.SaveToFile(filePath) ;
  tempLst.Free;
end;

procedure copyCbxObjects(inCbx:TCombobox; var outLst:TStringList);
var
  I:Integer;
Begin
  if outLst = nil then  outLst := TStringList.Create();

  for I := 0 to inCbx.Items.Count - 1 do
  begin
     if assigned(inCbx.Items.Objects [I]) then outLst.AddObject((inCbx.Items.Objects [I] as TPLRMHydPropsScheme).name,inCbx.Items.Objects [I]);
  end;
End;

procedure copyHydSchmToCbx(var outCbx:TCombobox; inLst:TStringList);
var
  I:Integer;
Begin
  if outCbx = nil then  exit;
  if inLst = nil then  exit;

  for I := 0 to inLst.Count - 1 do
  begin
     if assigned(inLst.Objects [I]) then outCbx.Items.AddObject((inLst.Objects [I] as TPLRMHydPropsScheme).name,inLst.Objects [I]);
  end;
End;

//extracts user assigned project name from project xml file
function getUserProjectOrScenName(xmlFilePath:String; nodeTag:String):String;
var
  xmlDoc :IXMLDocument;
  rootNode : IXMLNode;
begin
      xmlDoc := TXMLDocument.Create(nil);
      xmlDoc.loadFromFile(xmlFilePath);
      rootNode := xmlDoc.DocumentElement;
      Result :=rootNode.ChildNodes[nodeTag].Text;
      xmlDoc := nil;
end;

procedure reNameProjOrScen(xmlFilePath:String; nodeTag:String; newName:String);
var
  xmlDoc :IXMLDocument;
  rootNode : IXMLNode;
begin
      xmlDoc := TXMLDocument.Create(nil);
      xmlDoc.loadFromFile(xmlFilePath);
      rootNode := xmlDoc.DocumentElement;
      rootNode.ChildNodes[nodeTag].Text := newName;
      saveXmlDoc(xmlFilePath,xmlDoc, '','');
      xmlDoc := nil;
end;

//adapted from http://delphi.about.com/cs/adptips2002/a/bltip1102_5.htm
function Split(const Delimiter: Char;Input: string;var ResultStrings: TStrings):TStrings;
begin
   Assert(Assigned(ResultStrings)) ;
   ResultStrings.Clear;
   ResultStrings.Delimiter := Delimiter;
   ResultStrings.DelimitedText := Input;
   Result := ResultStrings;
end;

function makeSWMMSaveInpFile(inputFilePath:String; rptfilePath : String):Boolean;
begin
  Mainform.PLRMSaveFile(inputFilePath);
  Result := true;
end;

function getXMLRootChildTagValue(tagName:String;filePath:String):String;
var
  xmlDoc :IXMLDocument;
  rootNode : IXMLNode;
begin
      xmlDoc := TXMLDocument.Create(nil);
      xmlDoc.loadFromFile(filePath);
      rootNode := xmlDoc.DocumentElement;
      Result := rootNode.ChildNodes[tagName].Text;
      xmlDoc := nil;
end;

function openAndLoadSWMMInptFilefromXML(xmlFilePath:String):Boolean;
var
  xmlDoc :IXMLDocument;
  rootNode : IXMLNode;
  outFilePath:String;
  Sender:TObject;
begin
      xmlDoc := TXMLDocument.Create(nil);
      xmlDoc.loadFromFile(xmlFilePath);
      rootNode := xmlDoc.DocumentElement;
      outFilePath :=rootNode.ChildNodes['UserSWMMInpt'].Text;
      if fileExists(outFilePath) then
      begin
        MainForm.OpenFile(Sender,outFilePath);
        Result := true;
        Exit;
      end;
      xmlDoc := nil;
      Result := false;
end;

function LoadXmlDoc(const FileName: WideString): IXMLDOMDocument;
begin
Result := CoDomDocument60.Create();
Result.async := False;
Result.load(FileName);
end;

procedure saveXmlDoc(saveToPath:String; xmlDoc: IXMLDocument; insertStrLine0:String; insertStrLine1:String);
var
  s:TStringList;
begin
   s := TStringList.Create();
   try
     s.Assign(xmlDoc.XML) ;
    if insertStrLine0 <> '' then s.Insert(0,'<?xml-stylesheet type="text/xsl" href="' + defaultXslPath + '"?>');
    if insertStrLine1 <> '' then s.Insert(0,'<?xml version="1.0"?>') ;
    s.SaveToFile(saveToPath) ;
    FreeStringListObjects(s);
  except
  on E: Exception do
  begin
    ShowMessage (E.Message );
    FreeStringListObjects(s);
  end;
  end;
end;
procedure saveXmlDoc2(saveToPath:String; xmlDoc: IXMLDocument);
begin
   try
    xmlDoc.SaveToFile(saveToPath);
  except
  on E: Exception do
  begin
    ShowMessage (E.Message );
  end;
  end;
end;
procedure transformXMLToSwmm(xslFilePath:String; inXMLFilePath:String; outFilePath:String);
var
  doc, xsl: IXMLDOMDocument;
  tempStr:String;
  s : TStringList;
begin
  try
  doc := LoadXmlDoc(inXMLFilePath);
  xsl := LoadXmlDoc(xslFilePath);
  tempStr := doc.transformNode(xsl)
  except
  on E: Exception do
    ShowMessage (E.Message )
  end;
  s := TStringList.Create;
  s.Text := tempStr ;
  s.SaveToFile(outFilePath) ;
  s.Free;
end;

function loadXMLDlg():String;
var
    opnFileDlg: TOpenDialog;
begin
    opnFileDlg := TOpenDialog.Create(opnFileDlg);
    opnFileDlg.InitialDir := GetCurrentDir;
    opnFileDlg.Options := [ofFileMustExist];
    opnFileDlg.Filter := 'PLRM Scheme Files|*.xml';
    opnFileDlg.FilterIndex := 1;

    if opnFileDlg.Execute then
      Result := opnfiledlg.FileName;
end;

function swmmInptFileCurvesToXML(invtdCurveData:PLRMGridData; curveName:String; curveType:String; var outNode:IXMLNode):IXMLNode;
  var
  root: IXMLNOde;
  tempNode1 : IXMLNode;
  I:Integer;
  begin
    root := outNode.AddChild('Curve');
    root.Attributes['name'] := curveName;
    root.Attributes['curveType'] := curveType;
    for I := 1 to High(invtdCurveData[0]) do
    begin
      tempNode1 := root.AddChild('CurveEntry');
      tempNode1.Attributes['xval'] := invtdCurveData[0,I];
      tempNode1.Attributes['yval'] := invtdCurveData[1,I];
      if High(invtdCurveData) = 2 then tempNode1.Attributes['zval'] := invtdCurveData[2,I]; //added for the vol dis curve
      tempNode1.text := curveType;
     end;
     Result := root;
end;

function swmmInptFileXMLToCurves(invtdCurveData:PLRMGridData; iNode:IXMLNode):PLRMGridData;
  var
  tempNode1 : IXMLNode;
  I:Integer;
  tempStr:String;
  begin

     tempStr := iNode.Attributes['name'];
    if (AnsiEndsStr('VolDis', tempStr)) then
      SetLength(invtdCurveData,3,iNode.ChildNodes.Count+1)
    else
      SetLength(invtdCurveData,2,iNode.ChildNodes.Count+1);
    for I := 1 to iNode.ChildNodes.Count do
    begin
      tempNode1 := iNode.ChildNodes[I-1];
      invtdCurveData[0,I]:=tempNode1.Attributes['xval'];
      invtdCurveData[1,I] := tempNode1.Attributes['yval'];
      if High(invtdCurveData) = 2 then invtdCurveData[2,I] := tempNode1.Attributes['zval']; //added for the vol dis curve
     end;
     Result := invtdCurveData;
end;

function swmmInptFileBuildUpToXML():IXMLNode;
  var
  data:PLRMGridData;
  root: IXMLNOde;
  tempNode1 : IXMLNode;
  tempNode2 : IXMLNode;
  xmlDoc : IXMLDocument;
  I:Integer;
  begin
    data := getDBDataAsPLRMGridData(15);
    xmlDoc := TXMLDocument.Create(nil) ;
    xmlDoc.Active := true;
    root := xmlDoc.AddChild('BuildUp');
    for I := 0 to High(data) do
    begin
      tempNode1 := root.AddChild('BuildUpEntry');
      tempNode1.Attributes['landUse'] := data[I,2];
      tempNode1.Attributes['pollutant'] := data[I,3];

      tempNode2 := tempNode1.AddChild('Function');
      tempNode2.text := data[I,4];
      tempNode2.Attributes['coef1'] := data[I,5];
      tempNode2.Attributes['coef2'] := data[I,6];
      tempNode2.Attributes['coef3'] := data[I,7];
      tempNode2.Attributes['normalizer'] := data[I,8];
     end;
     Result := root;
end;

function swmmInptFileWashOffToXML():IXMLNode;
  var
  data:PLRMGridData;
  root: IXMLNOde;
  tempNode1 : IXMLNode;
  tempNode2 : IXMLNode;
  xmlDoc : IXMLDocument;
  I :Integer;
  begin
    data := getDBDataAsPLRMGridData(16);
    xmlDoc := TXMLDocument.Create(nil) ;
    xmlDoc.Active := true;
    root := xmlDoc.AddChild('WashOff');
    for I := 0 to High(data) do
    begin
      tempNode1 := root.AddChild('WashOffEntry');
      tempNode1.Attributes['landUse'] := data[I,2];
      tempNode1.Attributes['pollutant'] := data[I,3];

      tempNode2 := tempNode1.AddChild('Function');
      tempNode2.text := data[I,4];
      tempNode2.Attributes['coef1'] := data[I,5];
      tempNode2.Attributes['coef2'] := data[I,6];
      tempNode2.Attributes['cleanEff'] := data[I,7];
      tempNode2.Attributes['bmpEff'] := data[I,8];
     end;
     Result := root;
end;

function swmmInptFileLoadingsToXML():IXMLNode;
  var
  S:TStringList;
  begin
    S := TStringList.Create();
    S.Add('[LOADINGS]');
    S.Add(';;Subcatchment  	Pollutant       	Loading');
    S.Add(';;--------------	----------------	----------]]>');
    Result := cdataTextToXML(S.Text,'Loadings');
    S.Free;
end;

function swmmInptFileTagsToXML():IXMLNode;
  var
  S:TStringList;
  begin
    S := TStringList.Create();
    S.Add('[TAGS]');
    Result := cdataTextToXML(S.Text,'Tags');
    S.Free;
end;

function swmmInptFileTempTimeSeriesToXML(const seriesName:String; const dataFilePath:String; const seriesType:String = 'FILE'):IXMLNode;
  var
  S:TStringList;
  begin
    S := TStringList.Create();
    S.Add('[TIMESERIES]');
    S.Add(';;Name          	Type      	Path ');
    S.Add(';;--------------	----------	--------------------');
    S.Add(seriesName + '      ' + seriesType + '      "' + dataFilePath + '"');
    Result := cdataTextToXML(S.Text,'TimeSeries');
    S.Free;
end;

function swmmInptFileReportToXML():IXMLNode;
  var
  S:TStringList;
  begin
    S := TStringList.Create();
    S.Add('[REPORTS]');
    S.Add('INPUT     	NO');
    S.Add('CONTROLS  	NO');
    S.Add('SUBCATCHMENTS	NONE');
    S.Add('NODES	NONE');
    S.Add('LINKS	ALL');
    Result := cdataTextToXML(S.Text,'Report');
    S.Free;
end;

function swmmInptFileMapToXML():IXMLNode;
  var
  S:TStringList;
  begin
    S := TStringList.Create();
    S.Add('[MAP]');
    S.Add('DIMENSIONS 0.000 0.000 10000.000 10000.000');
    S.Add('Units     	Feet ');
    Result := cdataTextToXML(S.Text,'Map');
    S.Free;
end;

function swmmInptFileLossesToXML():IXMLNode;
  var
  S:TStringList;
  begin
    S := TStringList.Create();
    S.Add('[LOSSES]');
    S.Add(';;Link          	Inlet     	Outlet    	Average   	Flap Gate');
    S.Add(';;--------------	----------	----------	----------	----------');
    Result := cdataTextToXML(S.Text,'Losses');
    S.Free;
end;

function cdataTextToXML(txt :String; nodeName:String):IXMLNode;
  var
  root: IXMLNOde;
  xmlDoc : IXMLDocument;
  begin
    xmlDoc := TXMLDocument.Create(nil) ;
    xmlDoc.Active := true;
    root := xmlDoc.AddChild(nodeName);
    root.Text := txt;
    xmlDoc := nil;
    Result := root;
end;

function swmmDefaultsToXML(swmmDefaults:TStringList; maxFloLength:Double; widthPower:Double; widthFactor:Double; nodeName:String):IXMLNode;
var
  root: IXMLNOde;
  tempNode : IXMLNode;
  tempNode1 : IXMLNode;
  tempNode2 : IXMLNode;
  tempNode3 : IXMLNode;
  tempNode4 : IXMLNode;
  tempNode5 : IXMLNode;
  tempNode6 : IXMLNode;
  xmlDoc : IXMLDocument;
  begin
    xmlDoc := TXMLDocument.Create(nil) ;
    xmlDoc.Active := true;
    root := xmlDoc.AddChild(nodeName);
    tempNode := root.AddChild('ImpervN');
    tempNode.Text := swmmDefaults[0];

    tempNode1 := root.AddChild('PervN');
    tempNode1.Text := swmmDefaults[1];

    tempNode2 := root.AddChild('ImpervS');
    tempNode2.Text := swmmDefaults[2];

    tempNode3 := root.AddChild('PervS');
    tempNode3.Text := swmmDefaults[3];

    //for calculation of catchment width W = Area ^ Power
    tempNode4 := root.AddChild('CatchFloLengthMax');
    tempNode4.Text := FormatFloat('0.##',maxFloLength);
    tempNode5 := root.AddChild('CatchWidthPower');
    tempNode5.Text := FormatFloat('0.##',widthPower);
    tempNode6 := root.AddChild('CatchWidthFactor');
    tempNode6.Text := FormatFloat('0.##',widthFactor);
    Result := root;
end;

function swmmBlockLinesToXML(swmmLines:TStringList; nodeName:String; var outNode:IXMLNode):IXMLNode;
var
  tempNode : IXMLNode;
  begin
    Try
      tempNode := outNode.AddChild(nodeName);
      tempNode.Text := swmmLines.Text;
      Result := tempNode;
    Except
    on E : Exception do
    begin
      ShowMessage('An error occured while saving the swmm input file');
    end;
   end;

end;

function swmmInptFileRainGageToXML(gageID:String; filePath:String; gageType:String = 'VOLUME';timeIntv:String = '1:00'; snowCatch:String ='1.0'; dataSrcType:String = 'FILE'; param:String = 'IN'):IXMLNode;
var
  root: IXMLNOde;
  tempNode2 : IXMLNode;
 xmlDoc : IXMLDocument;
  begin
    xmlDoc := TXMLDocument.Create(nil) ;
    xmlDoc.Active := true;
    root := xmlDoc.AddChild('Raingages');
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

//Values in valColNum column become XML text and all else are attributes if
function swmmInptFileLandUseToXML(nodeName:String; data:PLRMGridData; tags:TStringList; valColNum:Integer;luseCodeLst:TStringList):IXMLNodeList;
var
  I,J : Integer;
  root: IXMLNOde;
  tempNode : IXMLNode;
 xmlDoc : IXMLDocument;
  begin
    xmlDoc := TXMLDocument.Create(nil) ;
    xmlDoc.Active := true;
    root := xmlDoc.AddChild(NodeName); // name at this node does not matter just need a list of nodes
    for I :=0  to High(data) do
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

function swmmInptFileLandUseToXML(nodeName:String; data:PLRMGridData; tags:TStringList; valColNum:Integer):IXMLNodeList;
var
  I,J : Integer;
  root: IXMLNOde;
  tempNode : IXMLNode;
  xmlDoc : IXMLDocument;
  begin
    xmlDoc := TXMLDocument.Create(nil) ;
    xmlDoc.Active := true;
    root := xmlDoc.AddChild(NodeName); // name at this node does not matter just need a list of nodes
    for I :=0  to High(data) do
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

function swmmInptFileLandUseToXML():IXMLNode;
  var
  data:PLRMGridData;
  root: IXMLNOde;
  tempNode1 : IXMLNode;
  xmlDoc : IXMLDocument;
  I :Integer;
  begin
    data := getDBDataAsPLRMGridData(17);
    xmlDoc := TXMLDocument.Create(nil) ;
    xmlDoc.Active := true;
    root := xmlDoc.AddChild('ParcelLandUses');
    for I := 0 to High(data) do
    begin
      tempNode1 := root.AddChild('LandUse');
      tempNode1.Attributes['code'] := data[I,1];
      tempNode1.Attributes['clnIntv'] := data[I,2];
      tempNode1.Attributes['fracAvail'] := data[I,3];
      tempNode1.Attributes['lastCln'] := data[I,4];
     end;
     Result := root;
end;

function lookUpCodeFrmName(const searchNames:PLRMGridData;searchCol:Integer; projectNamesList:TStringList; projectCodesList:TStringList):TStringList;
var
  I,J:Integer;
  rslt:TStringList;
begin
  rslt := TStringList.Create;
    for I := 0 to High(searchNames) do
      for J := 0 to projectNamesList.Count - 1 do
      begin
        if (searchNames[I][searchCol] = projectNamesList[J]) then
        begin
          rslt.Add(projectCodesList[J]);
          break;
        end;
      end;
      Result := rslt;
end;

function swmmInptFileSoilsToXML(nodeName:String; data:PLRMGridData; tags:TStringList; valColNum:Integer):IXMLNodeList;
var
  I,J : Integer;
  root: IXMLNOde;
  tempNode : IXMLNode;
  xmlDoc : IXMLDocument;
  begin

    xmlDoc := TXMLDocument.Create(nil) ;
    xmlDoc.Active := true;
    root := xmlDoc.AddChild(NodeName); // name at this node does not matter just need a list of nodes
    for I :=0  to High(data) do
    begin
      tempNode := root.AddChild(nodeName);
      tempNode.Text := data[I][valColNum];
      for J := valColNum to tags.Count-1 do
      begin
          tempNode.Attributes[tags[J]] := data[I][J];
      end;
     end;
     Result := root.ChildNodes;
end;

function swmmInptFilePollutantsToXML():IXMLNode;
  var
    data:plrmGridData;
    textList,attribTags:TStringList;
    I: Integer;
  begin
    try
      data := getDBDataAsPLRMGridData(11);
      textList := TStringList.create;
      attribTags := TStringList.create;

      for I := 0 to High(data) do
        textList.Add(data[I,1]);//pollutant name to be used as xml node text
      for I := 0 to High(pollutantTags) do
        attribTags.Add(pollutantTags[I]);//pollutant name to be used as xml node text
      Result := plrmGridDataToXML('Pollutants','Pollutant',data,attribTags,textList);
    finally
      FreeAndNil(textList);
      FreeAndNil(attribTags);
    end;
end;

//Values in txtList become XML text and all else are attributes
function plrmGridDataToXML(nodeName:String; rowNodeName:String; data:PLRMGridData; attribTags:TStringList; txtList:TStringList):IXMLNode;
var
  I,J : Integer;
  root: IXMLNOde;
  tempNode : IXMLNode;
  xmlDoc : IXMLDocument;
  begin
    xmlDoc := TXMLDocument.Create(nil) ;
    xmlDoc.Active := true;
    root := xmlDoc.AddChild(NodeName);
    for I :=0  to High(data) do
    begin
      tempNode := root.AddChild(rowNodeName);
      tempNode.Text := txtList[I];
      for J := 0 to High(data[0]) do
        tempNode.Attributes[attribTags[J]] := data[I][J];
     end;
     Result := root;
end;

function plrmGridDataToXML3(nodeName:String; rowNodeName:String; data:PLRMGridData; attribTags:TStringList; txtValColumn:integer):IXMLNode;
var
  I,J : Integer;
  root: IXMLNOde;
  tempNode : IXMLNode;
  xmlDoc : IXMLDocument;
begin
    xmlDoc := TXMLDocument.Create(nil) ;
    xmlDoc.Active := true;
    root := xmlDoc.AddChild(NodeName);
    for I :=0  to High(data) do
    begin
      tempNode := root.AddChild(rowNodeName);
      tempNode.Text := data[I][txtValColumn];
      for J := 0 to High(data[0]) do
        if J <> txtValColumn then
          tempNode.Attributes[attribTags[J]] := data[I][J];
     end;
     Result := root;
end;

//Values in txtList become XML text and all else are attributes
function plrmGridDataToXML(nodeName:String; data:PLRMGridData; tags:TStringList; txtList:TStringList):IXMLNodeList;
var
  I,J : Integer;
  root: IXMLNOde;
  tempNode : IXMLNode;
  xmlDoc : IXMLDocument;
  begin

    xmlDoc := TXMLDocument.Create(nil) ;
    xmlDoc.Active := true;
    root := xmlDoc.AddChild(NodeName); // name at this node does not matter just need a list of nodes
    for I :=0  to High(data) do
    begin
      tempNode := root.AddChild(nodeName);
      tempNode.Text := txtList[I];
      for J := 0 to High(data[0]) do
        tempNode.Attributes[tags[J]] := data[I][J];
     end;
     Result := root.ChildNodes;
end;

function xmlToPlrmGridData(iNode:IXMLNode; tags:TStringList):PLRMGridData;
var
  I,J : Integer;
  data:PLRMGridData;
  numCols, numRows:Integer;
  begin
    numRows := iNode.ChildNodes.Count; // includes text as column
    numCols := tags.Count;// includes text as column

    SetLength(data, numRows, numCols);// includes text as column
    for I :=0  to iNode.ChildNodes.Count - 1 do
    begin
      data[I][0] := iNode.ChildNodes[I].Text;
      for J := 1 to numCols-1 do //High(data[0]) do
       data[I][J] :=  iNode.ChildNodes[I].Attributes[tags[J]];
     end;
     Result := data;
end;

//Values in txtList become XML text and all else are attributes
function xmlAttribToPlrmGridData(iNode:IXMLNode; tags:TStringList):PLRMGridData;
var
  I,J : Integer;
  data:PLRMGridData;
  numCols, numRows:Integer;
  begin
    numRows := iNode.ChildNodes.Count; // includes text as column
    numCols := tags.Count;// includes text as column
    SetLength(data, numRows, numCols);// includes text as column
    for I :=0  to iNode.ChildNodes.Count - 1 do
    begin
      for J := 0 to numCols-1 do //High(data[0]) do
       data[I][J] :=  iNode.ChildNodes[I].Attributes[tags[J]];
     end;
     Result := data;
end;

//Values in txtList become XML text and txtNodeLabelList are used as node labels, all else are attributes
function plrmGridDataToXML(topNodeLabel:String; data:PLRMGridData; tags:TStringList; txtList:TStringList; txtNodeLabelList:TStringList):IXMLNodeList;
var
  I,J : Integer;
  root: IXMLNOde;
  tempNode : IXMLNode;
  xmlDoc : IXMLDocument;
  begin

    xmlDoc := TXMLDocument.Create(nil) ;
    xmlDoc.Active := true;
    root := xmlDoc.AddChild(topNodeLabel); // name at this node does not matter just need a list of nodes
    for I :=0  to High(data) do
    begin
      tempNode := root.AddChild(txtNodeLabelList[I]);
      tempNode.Text := txtList[I];
      for J := 0 to High(data[0]) do
        tempNode.Attributes[tags[J]] := data[I][J];
     end;
     Result := root.ChildNodes;
end;

//Values in txtList become XML text and txtNodeLabelList are used as node labels, all else are attributes
function plrmGridDataToXML2(topNodeLabel:String; data:PLRMGridData; tags:TStringList; txtList:TStringList; txtNodeLabelList:TStringList):IXMLNodeList;
var
  I,J : Integer;
  root: IXMLNOde;
  tempNode : IXMLNode;
 xmlDoc : IXMLDocument;
  begin

    xmlDoc := TXMLDocument.Create(nil) ;
    xmlDoc.Active := true;
    root := xmlDoc.AddChild(topNodeLabel); // name at this node does not matter just need a list of nodes
    for I :=0  to High(data) do
    begin
      tempNode := root.AddChild(txtNodeLabelList[I]);
      tempNode.Text := txtList[I];
      for J := 0 to High(data[0]) do
        tempNode.Attributes[tags[J]] := data[I][J];
     end;
     Result := root.ChildNodes;
end;

//Values in valColNum column become attributes and column o becomes XML text
function plrmGridDataToXML(nodeName:String; data:PLRMGridData; tags:TStringList; valColNum:Integer):IXMLNodeList;
var
  I : Integer;
  root: IXMLNOde;
  tempNode : IXMLNode;
  xmlDoc : IXMLDocument;
  begin

    xmlDoc := TXMLDocument.Create(nil) ;
    xmlDoc.Active := true;
    root := xmlDoc.AddChild(NodeName); // name at this node does not matter just need a list of nodes
    for I :=0  to High(data) do
    begin
      tempNode := root.AddChild(nodeName);
      tempNode.Text := data[I][0];
      tempNode.Attributes[tags[I]] := data[I][valColNum];
    end;
    Result := root.ChildNodes;
end;


{$ENDREGION}


{$REGION 'GUI Helper methods'}
//Based on code by Lew Rossman in unit PropEdit ln 504 +
//Use for stringGrids only
procedure gsEditKeyPress(Sender: TObject; var Key: Char; const exptdTypeCode:TExptdTypeCodes);
//-----------------------------------------------------------------------------
// Used by OnKeyPress events for TStringGrids to handle edits
//based on Lew R. procedure TPropEdit.EditKeyPress(Sender: TObject; var Key: Char);
//-----------------------------------------------------------------------------
begin
  //allow backspace and enter  and decimal
  if (Key = #8) or (Key = #13) or (Key = '.') then exit;

  if (Key in [' ', '"', ';']) then
    Key := #0; //ignore spaces

    //allow 0 - 9 and numpad 0 to numpad 9
  if (not(Key in [#48..#57]) ) then
    Key := #0;

  with Sender as TStringGrid do
  begin
  end;
end;

procedure gsEditKeyPressNoSpace(Sender: TObject; var Key: Char; const exptdTypeCode:TExptdTypeCodes);
//-----------------------------------------------------------------------------
// Used by OnKeyPress events for Textboxes use for names to handle edits
//based on Lew R. procedure TPropEdit.EditKeyPress(Sender: TObject; var Key: Char);
//-----------------------------------------------------------------------------
begin
  //allow backspace and enter
  if (Key = #8) or (Key = #13) then exit;

  if (Key in ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j']) then exit;
  if (Key in ['k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't']) then exit;
  if (Key in ['u', 'v', 'w', 'x', 'y', 'z']) then exit;

//disallow punctuation
  if (Key in ['"', ';', '?', '/', '!', '\', '|', '[', ']', '=','<','>',':','^','@']) then
    Key := #0;
  if exptdTypeCode = gemNoSpace then
    if (Key = ' ') then Key := #0;
  
    //allow 0 - 9 and numpad 0 to numpad 9
  if (not(Key in [#48..#105]) ) then
    Key := #0;
end;


//Combobox must contain strings and objects
procedure updateGeneralCbxItems(var cbxDest:TCombobox; const cbxSource :TCombobox);
  var
    I:Integer;
begin
    for I := 0 to cbxSource.Items.Count - 1 do
    begin
      if cbxDest.Items.IndexOf(cbxSource.Items[I]) = -1 then
        cbxDest.Items.AddObject(cbxSource.Items[I], cbxSource.Items.Objects[I]);
    end;
end;

function gridContainsStr(searchStr:String; strColNum:Integer; Grd:TStringGrid):boolean;
var
  R, C: LongInt;
begin
  for R := 0 to Grd.RowCount - 1 do
  begin
    C:= 0;
    if Grd.Cells[C,R] = searchStr then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

//Based on SWMM5   TGridEditFrame.DeleteOneRow;
procedure deleteGridRow(searchStr:String; strColNum:Integer; initCellStr:string; var Grd:TStringGrid);
var
  R, C, lastRow: LongInt;
begin
  lastRow := Grd.RowCount -1;
  for R := 1 to lastRow do
  begin
    if Grd.Cells[0,R] = searchStr then
    begin
       for C := Grd.FixedCols to Grd.ColCount - 1 do
       begin
          Grd.Cells[C,R] := Grd.Cells[C,lastRow];
          Grd.Cells[C,lastRow] := initCellStr;
       end;

      Grd.RowCount := Grd.RowCount - 1;
      Exit;
    end;
  end;
end;

procedure AddGridRow(inStr:String; Grd:TStringGrid; strColNum:Integer);
var
  lastRow: LongInt;
begin
  if Grd.Cells[0,1] = '' then
  begin
    Grd.Cells[0,1] := inStr;
    Exit
  end;
  lastRow := Grd.RowCount;
  Grd.RowCount := Grd.RowCount + 1;
  Grd.Cells[strColNum,lastRow] := inStr;
end;

procedure AddSoilsGridRow(inStr:String; Grd:TStringGrid; strColNum:Integer);
var
  lastRow: LongInt;
begin
  if Grd.Cells[0,1] = '' then
  begin
    Grd.Cells[0,1] := inStr;
    Exit
  end;
  lastRow := Grd.RowCount;
  Grd.RowCount := Grd.RowCount + 1;
  Grd.Cells[strColNum,lastRow] := inStr;
end;

//TODO Adapted from http://www.delphicorner.f9.co.uk/articles/comps6.htm
procedure TransferLstBxItems(Dest:TListbox; var Source : TListBox);
var
  I : Integer;
begin
  with Source do
  begin
    for I := 0 to Items.Count - 1 do
      if Selected[I] then
        Dest.Items.Add(Items[I]);

    for I := 0 to Dest.Items.Count - 1  do
        Items.Delete(Items.IndexOf(Dest.Items[I]));
  end;
end;

procedure TransferAllLstBxItems(Dest, Source : TListBox);
var
  I : Integer;
begin
  with Source do
  begin
    for I := 0 to Items.Count - 1 do
        Dest.Items.Add(Items[I]);

    for I := 0 to Dest.Items.Count - 1  do
        Items.Delete(Items.IndexOf(Dest.Items[I]));
  end;
end;

//Copies data
function copyContentsToGrid( const data:PLRMGridData; const strtCol:integer; strtRow:integer; var sg :TStringGrid): Boolean;
var
  irow : integer;
  icol : integer;
begin
   if data <> nil then
    if High(data) = sg.RowCount - (1+strtRow) then
      if data[0] <> nil then
        if (High(data[0]) = sg.ColCount -(1+strtCol)) then
        begin
          for irow := strtRow to sg.RowCount - 1 do
            for icol := strtCol to sg.ColCount - 1 do
              sg.Cells[icol,irow] := data[irow-strtRow,icol-strtCol]; //yes grid index is col first and then row
          Result := True;
        end;
   Result := False
end;
function copyInvertedPLRMGridToStrGrid(const data:PLRMGridData; const strtCol:integer; strtRow:integer; var sg :TStringGrid): Boolean;
var
  irow : integer;
  icol : integer;
  //chk : integer;
begin
   if data <> nil then
   //chk:=High(data);
    if High(data) = sg.ColCount - (1+strtCol) then
      if data[0] <> nil then
        if (High(data[0]) = sg.RowCount -(1+strtRow)) then
        begin
          for irow := strtRow to sg.RowCount - 1 do
            for icol := strtCol to sg.ColCount - 1 do
              sg.Cells[icol,irow] := data[icol-strtCol,irow-strtRow];
          Result := True;
        end;
   Result := False
end;

function copyContentsToGridNChk( const data:PLRMGridData; const strtCol:integer; strtRow:integer; var sg :TStringGrid): Boolean;
var
  irow : integer;
  icol : integer;
begin
  sg.RowCount := High(data) + 1+ strtRow;
   if data <> nil then
      if data[0] <> nil then
      begin
        for irow := strtRow to sg.RowCount - 1 do
            for icol := strtCol to sg.ColCount - 1 do
              sg.Cells[icol,irow] := data[irow-strtRow,icol-strtCol]; //yes grid index is col first and then row
        Result := True;
      end;
   Result := False
end;
function copyContentsToGridAddRows( const data:PLRMGridData; const strtCol:integer; strtRow:integer; var sg :TStringGrid): Boolean;
//var
//  irow : integer;
//  icol : integer;
begin
   if data <> nil then
    while High(data) > sg.RowCount - (1+strtRow) do
    begin
       sg.RowCount := sg.RowCount + 1;
    end;
   Result := copyContentsToGrid( data,strtCol,strtRow,sg);
end;

function initGrid( const dataStr:String; const strtCol:integer; strtRow:integer; var sg :TStringGrid): Boolean;
var
  irow : integer;
  icol : integer;
begin
    for irow := strtRow to sg.RowCount - 1 do
      for icol := strtCol to sg.ColCount - 1 do
        sg.Cells[icol,irow] := dataStr;
    Result := True;
end;

//Copies the contents of a string grid into a 2-D array
function copyGridContents( const sg :TStringGrid): PLRMGridData;
var
  irow : integer;
  icol : integer;
  rsltArry : PLRMGridData;
begin
   SetLength(rsltArry, sg.RowCount, sg.ColCount);
  for irow := 0 to sg.RowCount - 1 do
  begin
    for icol := 0 to sg.ColCount - 1 do
      rsltArry[irow,icol] := sg.Cells[icol,irow] //yes grid index is col first and then row
  end;
  Result := rsltArry;
end;

//Copies the contents of a string grid into a 2-D array
function copyGridContents( const strtCol:integer; strtRow:integer; const sg :TStringGrid): PLRMGridData;
var
  irow : integer;
  icol : integer;
  rsltArry : PLRMGridData;
begin
   SetLength(rsltArry, sg.RowCount-strtRow, sg.ColCount-strtCol);
  for irow := strtRow to sg.RowCount - 1 do
  begin
    for icol := strtCol to sg.ColCount - 1 do
      rsltArry[irow-strtRow,icol-strtCol] := sg.Cells[icol,irow] //yes grid index is col first and then row
  end;
  Result := rsltArry;
end;

function copyStringGridToInvertedPLRMGrid(const sg :TStringGrid): PLRMGridData;
var
  irow : integer;
  icol : integer;
  rsltArry : PLRMGridData;
begin
   SetLength(rsltArry, sg.ColCount,sg.RowCount);
  for irow := 0 to sg.RowCount - 1 do
  begin
    for icol := 0 to sg.ColCount - 1 do
      rsltArry[icol,irow] := sg.Cells[icol,irow]
  end;
  Result := rsltArry;
end;
//Copies the contents of a string grid into a 2-D array with strings in 1st column into StringList
function copyGridContents( const strtCol:integer; strtRow:integer; var outStrList: TStringList; const sg :TStringGrid): PLRMGridData;
var
  irow : integer;
  icol : integer;
  rsltArry : PLRMGridData;
  rsltList : TStringList;
begin
  rsltList := TStringList.Create;
  SetLength(rsltArry, sg.RowCount-1, sg.ColCount-strtCol);
  for irow := strtRow to sg.RowCount - 1 do
  begin
    rsltList.Add(sg.Cells[0,irow]);
    for icol := strtCol to sg.ColCount - 1 do
      rsltArry[irow-strtRow,icol-strtCol] := sg.Cells[icol,irow] //yes grid index is col first and then row
  end;
  outStrList := rsltList;
  Result := rsltArry;
end;
//Copies the contents of a string grid into a 2-D array with strings in 1st column into StringList
//Copies only when values valColumn are greater than or equal to leastVal
function copyGridContents( const strtCol:integer; strtRow:integer; var outStrList: TStringList; const sg :TStringGrid; const valCol:Integer; const grtrThanVal:Double=0): PLRMGridData;
var
  irow : integer;
  icol : integer;
  rsltArry,tempArry : PLRMGridData;
  rsltList : TStringList;
  I,J, tempInt: Integer;
begin
  rsltList := TStringList.Create;
  SetLength(tempArry, sg.RowCount-1, sg.ColCount-strtCol);
  tempInt := 0;
  for irow := strtRow to sg.RowCount - 1 do
  begin
    if (strToFloat(sg.Cells[valCol,irow]) > grtrThanVal) then
    begin
      tempInt := tempInt + 1;
      rsltList.Add(sg.Cells[0,irow]);
      for icol := strtCol to sg.ColCount - 1 do
        tempArry[tempInt -1,icol-strtCol] := sg.Cells[icol,irow] //grid index is col first and then row
    end;
  end;
  SetLength(rsltArry, tempInt, sg.ColCount-strtCol);
  for I := 0 to High(rsltArry) do
    for J := 0 to High(rsltArry[I]) do
      rsltArry[I,J] := tempArry[I,J];
  outStrList := rsltList;
  Result := rsltArry;
end;

procedure DefaultCopyDataProc(oldnode, newnode : TTreenode);
begin
  newnode.Assign(oldnode);
end;

procedure CopySubtree(sourcenode : TTreenode; target : TTreeview;  targetnode : TTreenode; CopyProc : TCopyDataProc = nil);
var
  anchor : TTreenode;
  child : TTreenode;
begin { CopySubtree }
  Assert(Assigned(sourcenode),
    'CopySubtree:sourcenode cannot be nil');
  Assert(Assigned(target),
    'CopySubtree: target treeview cannot be nil');
  Assert((targetnode = nil) or (targetnode.TreeView = target),
    'CopySubtree: targetnode has to be a node in the target treeview.');

  if (sourcenode.TreeView = target) and
    (targetnode.HasAsParent(sourcenode) or (sourcenode =
    targetnode)) then
    raise Exception.Create('CopySubtree cannot copy a subtree to one of the ' +
      'subtrees nodes.');

  if not Assigned(CopyProc) then
    CopyProc := DefaultCopyDataProc;

  anchor := target.Items.AddChild(targetnode, sourcenode.Text);
  DefaultCopyDataProc(sourcenode, anchor);
  child := sourcenode.GetFirstChild;
  while Assigned(child) do
  begin
    CopySubtree(child, target, anchor, CopyProc);
    child := child.getNextSibling;
  end; // While
end; // CopySubtree

function getComboBoxSelValue(Sender: TObject) : String;
var
  idx : Integer;
  value : String;
begin
  idx := TComboBox(Sender).ItemIndex;
  value := String(TComboBox(Sender).Items.Objects[idx]);
  Result := value
end;

function getComboBoxSelValue2(Sender: TObject) : TObject;
var
  idx : Integer;
  value : TObject;
begin
  idx := TComboBox(Sender).ItemIndex;
  if idx = -1 then exit;  
  value := TComboBox(Sender).Items.Objects[idx];
  Result := value
end;

procedure sgGrayOnDrawCell( var Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState; colNum:Integer; rowNum:Integer);
var S : String;
var sg :TStringGrid;
begin
  sg := (Sender as TStringGrid);
  if ((ACol=colNum) or (ARow = rowNum ))then begin
    sg.Canvas.Brush.Color := cl3DLight;
    sg.Canvas.FillRect(Rect);
    S := sg.Cells[ACol, ARow];
    sg.Canvas.Font.Color := clBlue;
    sg.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure sgGrayOnDrawCell2ColsNRow( var Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState; colNum1:Integer; colNum2:Integer; rowNum:Integer);
var S : String;
var sg :TStringGrid;
begin
  sg := (Sender as TStringGrid);
  if ((ACol=colNum1) or (ACol=colNum2) or (ARow = rowNum ))then begin
    sg.Canvas.Brush.Color := cl3DLight;
    sg.Canvas.FillRect(Rect);
    S := sg.Cells[ACol, ARow];
    sg.Canvas.Font.Color := clBlue;
    sg.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure sgGrayOnDrawCell2ColsOnly( var Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState; colNum1:Integer; colNum2:Integer);
var S : String;
var sg :TStringGrid;
begin
  sg := (Sender as TStringGrid);
  if ((ACol=colNum1) or (ACol=colNum2))then begin
    sg.Canvas.Brush.Color := cl3DLight;
    sg.Canvas.FillRect(Rect);
    S := sg.Cells[ACol, ARow];
    sg.Canvas.Font.Color := clBlue;
    sg.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;
procedure sgGrayOnDrawCell3ColsOnly( var Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState; colNum1:Integer; colNum2:Integer; colNum3:Integer);
var S : String;
var sg :TStringGrid;
begin
  sg := (Sender as TStringGrid);
  if ((ACol=colNum1) or (ACol=colNum2) or (ACol=colNum3))then begin
    sg.Canvas.Brush.Color := cl3DLight;
    sg.Canvas.FillRect(Rect);
    S := sg.Cells[ACol, ARow];
    sg.Canvas.Font.Color := clBlue;
    sg.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

//Displays message box saying cell is uneditable if in the 1st column
procedure sgSelectCellWthNonEditCol(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean; colNum:Integer);
begin
  if ACol=colNum then
    begin
      ShowMessage(CELLNOEDIT);
    end
  else
  begin
  end;
end;

  procedure FreeObjects(const strings: TStrings) ;
  var
    s : integer;
    o : TObject;
  begin
    for s := 0 to Pred(strings.Count) do
    begin
      o := strings.Objects[s];
      FreeAndNil(o) ;
    end;
  end;


  //Displays message box saying cell is uneditable if in the specified columns
procedure sgSelectCellWthNonEditCol(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean; colNum1:Integer; colNum2:Integer;colNum3:Integer);
var sg :TStringGrid;
begin
 if ((ACol=colNum1) or (ACol=colNum2) or (ACol=colNum3))then
    begin
      sg.Options:=sg.Options-[goEditing];
      ShowMessage(CELLNOEDIT);
    end
  else
  begin
    sg.Options:=sg.Options+[goEditing];
  end;
end;

//Displays message box saying cell is uneditable if in the specified column and specified row column
procedure sgSelectCellWthNonEditColNRow(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean; colNum:Integer; rowNum:Integer);
var sg :TStringGrid;
begin
 if ((ACol=colNum) and (ARow=rowNum))then
    begin
      sg.Options:=sg.Options-[goEditing];
      ShowMessage(CELLNOEDIT);
  end;
end;

//Grays cells in grid if in the specified column and specified row column
procedure sgGrayOnDrawCellColAndRow( var Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState; colNum:Integer; rowNum:Integer);
var S : String;
var sg :TStringGrid;
begin
  sg := (Sender as TStringGrid);
  if ((ACol=colNum) and (ARow = rowNum ))then begin
    sg.Canvas.Brush.Color := cl3DLight;
    sg.Canvas.FillRect(Rect);
    S := sg.Cells[ACol, ARow];
    sg.Canvas.Font.Color := clBlue;
    sg.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

//http://www.delphitricks.com/source-code/components/delete_a_row_in_a_tstringgrid.html
procedure GridDeleteRow(RowNumber: Integer; var Grid: TstringGrid);
var
  i: Integer;
begin
  Grid.Row := RowNumber;
  if (Grid.Row = Grid.RowCount - 1) then
    { On the last row}
    Grid.RowCount := Grid.RowCount - 1
  else
  begin
    { Not the last row}
    for i := RowNumber to Grid.RowCount - 1 do
        Grid.Rows[i].Assign(Grid.Rows[i+1]);
    Grid.RowCount := Grid.RowCount - 1;
  end;
end;
{$ENDREGION}

procedure initPLRMPaths();
begin

   defaultPLRMPath := StringReplace(ExtractFileDir(Application.ExeName), '\Engine' , '',[rfReplaceAll, rfIgnoreCase]);
   defaultXMLDeclrtn := '<?xml version="1.0"?>';
   defaultPrjDir := defaultPLRMPath + '\Projects';
   defaultSchmDir := defaultPLRMPath + '\Schemes';
   defaultEngnDir := defaultPLRMPath + '\Engine';
   PLRMInitIni := defaultEngnDir + '\swmm.ini';
   defaultDataDir := defaultPLRMPath + '\Data';
   defaultDBPath := defaultDataDir + '\PLRM_v1.0.accdb';
   defaultPrjPath := defaultPrjDir + '\temp.xml';
   defaultGenSWmmInpPath := defaultPrjDir + '\tempSwmm.inp';
   defaultUserSWmmInpPath := defaultPrjDir + '\swmm.inp';
   defaultUserSwmmRptPath := defaultPrjDir + '\swmm.rpt';
   defaultValidateDir := defaultEngnDir + '\Validation';
   defaultValidateFilePath := defaultValidateDir + '\validation.html';

    dbPath := defaultDBPath;
    initDbPath();
    HYDSCHMSDIR := defaultEngnDir + '\DefaultSchemes\Hydroloic Properties Schemes';
    RCONDSCHMSDIR := defaultEngnDir + '\DefaultSchemes\Road Condition Schemes';
end;

 function dbFields2ToPLRMGridData(data:dbReturnFields2; strtRowIdx:Integer = 0):PLRMGridData;
var
  I,J:Integer;
  rslt:PLRMGridData;
begin
  SetLength(rslt, (data[0].Count - strtRowIdx),High(data)+1);
  for I := strtRowIdx to data[0].Count-1 do
    for J := 0 to High(rslt[0]) do
      rslt[I-strtRowIdx][J] := data[J][I];
  Result := rslt;
end;
 function dbFields3ToPLRMGridData(data:dbReturnFields3; strtRowIdx:Integer = 0):PLRMGridData;
var
  I,J:Integer;
  rslt:PLRMGridData;
begin
  SetLength(rslt, (data[0].Count - strtRowIdx),High(data)+1);
  for I := strtRowIdx to data[0].Count-1 do
    for J := 0 to High(rslt[0]) do
      rslt[I-strtRowIdx][J] := data[J][I];
  Result := rslt;
end;

{Adapted from: http://www.awitness.org/delphi_pascal_tutorial/index.html 09/25/08
scan the directories and subdirectories for files
and folders and insert them onto the Treeview}
function FileLook(genSpec:string; myFileExt:string; Node:TTreeNode; TV:TTreeview):boolean;
var
  TempNode : TTreeNode;
  validres:integer;
  SearchRec  : TSearchRec;
  DirPath, FullName, Flname : string;
begin

  DirPath:=ExtractFilePath(genSpec);
  Result:= DirectoryExists(DirPath);
  If not Result then exit;
  Flname:=ExtractFileName(genSpec);
  validres := FindFirst(genSpec, faAnyFile, SearchRec);
  while validres=0 do
  begin
    If (SearchRec.Name[1] <> '.') then
    begin {not a dotted directory}
        FullName:=DirPath + LowerCase(SearchRec.Name);
        {add folder/file as child of current Node}
        If ((SearchRec.Attr and faDirectory>0) or (AnsiContainsStr(SearchRec.Name, myFileExt))) then TempNode := TV.Items.AddChild(Node, SearchRec.Name);
        If (SearchRec.Attr and faDirectory>0) then
        begin{is a folder}
          TempNode.ImageIndex := ISAClosedFolder;
          TempNode.SelectedIndex := ISAOpenFolder;
          FileLook(FullName+'\'+Flname, myFileExt,TempNode, TV);
        end
        else  {not a folder must be a file}
        end;
        validres:=FindNext(SearchRec);  {continue scanning current folder for files and other folders}
     end;
   // ML Added 4/13/09. Must free up resources used by these successful finds
   SysUtils.FindClose(SearchRec);
end;

function FolderLookAddUserName(startPath:string; Node:TTreeNode; TV:TTreeview):boolean;
var
  projSL : TStringList;
  scenSL : TStringList; //this string holds the scenario IDs (e.g., scenario1)
  scenSL2: TStringList; //this string list holds the user scenario names
  tempNode : TTreeNode;
  scenPath : String;
  I,J : Integer;
  tempStr : String;
  tempPrjName : String; //temporary user name for project
  SearchRec  : TSearchRec;
  prjIdx, scnIdx, tempInt:Integer;
  projNames :TStringList; //stores project names on tree used with projFolders list below to facilitate deletion
  projFolders :TStringList; //stores project folder names corresponding to project names on tree to facilitate deletion
  scenFolders : TStringList; //stores scenario folder names corresponding to scenario names on tree to facilitate deletion
  scenFilePaths : TStringList; //ditto
  scenNames :TStringList; //stores scenario names on tree used with scenFolders list below to facilitate deletion


begin
  Result:= DirectoryExists(startPath);
  If not Result then exit;

  PLRMTree := TProjTree.Create;

  if not(Assigned(projNames)) then projNames := TStringList.Create;
  if not(Assigned(projFolders)) then projFolders := TStringList.Create;
  if not(Assigned(scenNames)) then scenNames := TStringList.Create;
  if not(Assigned(scenFolders)) then scenFolders := TStringList.Create;
  if not(Assigned(scenFilePaths)) then scenFilePaths := TStringList.Create;

  projSL := getFoldersInFolder(startPath);
  //Add project and scenario folders to TreeView
  for I := 0 to projSL.Count - 1 do
  begin
    //check if directory contains project file if not do not add to list
    if (FindFirst(defaultPrjDir + '\' + projSL[i] + '\*.xml', faAnyFile, SearchRec) = 0) then
    begin
      projFolders.Add(defaultPrjDir + '\' + projSL[i]);
      tempPrjName := getUserProjectOrScenName(defaultPrjDir + '\' + projSL[i] + '\' + SearchRec.Name, 'ProjectUserName');
      prjIdx := projNames.Add(tempPrjName);
      tempNode := TV.Items.AddChild(Node,projNames[prjIdx]);
      scenPath := startPath + '\' + projSL[I];

      scenSL2 := TStringList.Create;
      If DirectoryExists(scenPath) then
      begin
        scenSL := getFoldersInFolder(scenPath);
        for J := 0 to scenSL.Count - 1 do
        begin
          //check if scenario contains scenario file if not do not add to list
          if (FindFirst(scenPath + '\' + scenSL[j] + '\scenario*.xml', faAnyFile, SearchRec) = 0) then
          begin
            scenFolders.Add(scenPath + '\' + scenSL[j]);
            tempInt := scenFilePaths.Add(scenPath + '\' + scenSL[j] + '\' + SearchRec.Name);
            tempStr := getUserProjectOrScenName(scenFilePaths[tempInt], 'ScenName');
            scnIdx := scenNames.Add(tempStr + projNames[prjIdx]);
            TV.Items.AddChild(tempNode,tempStr);
            scenSL2.Add(tempStr);
          end;
        end;
        PLRMTree.PID.AddObject(projSL[I],scenSL);
        PLRMTree.PrjNames.AddObject(tempPrjName,scenSL2);
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

  scenSL := nil; //Memory release via prjNames when tree destroyed
  scenSL2 := nil; //Memory release via prjNames when tree destroyed

end;


//http://www.delphi3000.com/articles/article_2049.asp?SK=
function CopyFolderContents(const FromFolder: string; ToFolder: string) : string;
var
  Fo      : TSHFileOpStruct;
  buffer  : array[0..4096] of char;
  p       : pchar;
  dir     : string;
  fileName : string;
begin
  FillChar(Buffer, sizeof(Buffer), #0);
  p := @buffer;
  StrECopy(p, PChar(FromFolder)); //this is folder that you want to copy
  FillChar(Fo, sizeof(Fo), #0);
  Fo.Wnd    := Application.Handle;
  Fo.wFunc  := FO_COPY;
  Fo.pFrom  := @Buffer;
  //check if destination already exists  

  while (FileExists(ToFolder) ) do
  begin
    dir := ExtractFileDir(ToFolder);
    fileName := ExtractFileName(ToFolder);
    ToFolder := dir + '\CopyOf' + fileName;
  end;
  Fo.pTo    := PChar(ToFolder); //this is where the folder will go
  Fo.fFlags := 0;
  if ((SHFileOperation(Fo) <> 0) or (Fo.fAnyOperationsAborted <> false)) then
    ShowMessage('File copy process cancelled');
  Result := ToFolder;
end;

{DP added recursive backtrack from a node to the root, keeping track of node names
with the assumtion that the node names represent directory or filenames and the root
is the root folder}
function getFilePath(Node : TTreeNode; TV:TTreeview):string;
begin
  If (Node.Parent = nil) then
  begin
    Result := defaultPrjDir + '\' + Node.Text;
    exit;
  end
  else
  begin
    Result :=  getFilePath(Node.Parent, TV) + '\' + Node.Text;
    exit;
  end;
end;

function checkNCreateDirectory(folderPath:String):Boolean;
begin
  if DirectoryExists(folderPath) = False then //need to create, but check for project folder first
  begin
    if not CreateDir(folderPath) then
    begin
      ShowMessage('Failed to add '+ folderPath + '. Error: '+IntToStr(GetLastError));
      Result := false;
      Exit;
    end;
  end;
  Result := true;
end;

procedure removeDirGS(const dirPath : String);        //ML rewrote this function 4/13/09
begin
  if RemoveDir(dirPath) then ShowMessage('Directory' + dirPath + ' removed OK')
  else ShowMessage('Remove directory failed with error : '+ IntToStr(GetLastError));
end;

////adapted from http://training.codeface.com.br/?p=12
procedure ForceDeleteDirAndContents(dir: string);
var
  i: integer;
  sDirectory: string;
  sr: TSearchRec;
begin
  sDirectory := IncludeTrailingPathDelimiter( dir );
  i := FindFirst(sDirectory + '\*.*',faAnyFile,sr );
  while i = 0 do
  begin
    if ( sr.Attr and faDirectory ) = faDirectory then
    RemoveDir( sDirectory+sr.Name )
    else
    begin
      //DP if not DeleteFile( PAnsiChar(sDirectory+sr.Name) ) then
      if not DeleteFile( PWideChar(sDirectory+sr.Name) ) then
      begin
        FileSetAttr (PAnsiChar(sDirectory+sr.Name), 0); { reset all flags }
        //DP DeleteFile (PAnsiChar(sDirectory+sr.Name));
        DeleteFile (PWideChar(sDirectory+sr.Name))
      end;
  end;
  i := FindNext( sr );
  end;
  FindClose( sr.FindHandle );
  removeDirGS(dir);
end;

//adapted from http://delphi.about.com/cs/adptips1999/a/bltip1199_2.htm
Function DelTree(DirName : string): Boolean;
var
  SHFileOpStruct : TSHFileOpStruct;
  DirBuf : array [0..255] of char;
begin
  try
   Fillchar(SHFileOpStruct,Sizeof(SHFileOpStruct),0) ;
   FillChar(DirBuf, Sizeof(DirBuf), 0 ) ;
   StrPCopy(DirBuf, DirName) ;
   with SHFileOpStruct do begin
    Wnd := 0;
    pFrom := @DirBuf;
    wFunc := FO_DELETE;
    fFlags := FOF_ALLOWUNDO;
    fFlags := fFlags or FOF_NOCONFIRMATION;
    fFlags := fFlags or FOF_SILENT;
   end;
    Result := (SHFileOperation(SHFileOpStruct) = 0) ;
   except
    Result := False;
  end;
end;

function deleteFileGS(const filePath : String): Integer;
begin
  if FileExists(filePath)then
    ShowMessage(filePath + ' will be deleted')
  else
  begin
    ShowMessage(filePath + ' does not exist');
    Result := 0;
    exit;
  end;

  DeleteFile(PChar(filePath));
  //check to see if file deleted successfully
  if FileExists(filePath)then
  begin
    ShowMessage('could not delete file:' + filePath + ' check to see if file is open!');
    Result := -1;
  end
  else
  begin
    ShowMessage(filePath + ' successfully deleted');
    Result := 1
  end;
end;

function deleteFileGSNoConfirm(const filePath : String): Integer;
begin
  if FileExists(filePath)=False then
  begin
    ShowMessage(filePath + ' does not exist');
    Result := 0;
    exit;
  end;

  DeleteFile(PChar(filePath));
  //check to see if file deleted successfully
  if FileExists(filePath)then
  begin
    Result := -1;
  end
  else
  begin
    Result := 1
  end;
end;


function gsVectorMultiply(dArr1 :TStringList; dArr2 : TStringList): Double;
var
  I : Integer;
  rslt : Double;
begin
  rslt := 0;
  for I := 0 to dArr1.Count - 1 do
  begin
     rslt := rslt + (StrToFloat(dArr1[I]) * StrToFloat(dArr2[I]));
  end;
  Result := rslt;
end;

//From: http://delphi.about.com/cs/adptips2004/a/bltip0504_4.htm
//Accessed: 12/08
function BrowseURL(const URL: string) : boolean;
var
   Browser: string;
begin
   Result := True;
   Browser := '';
   with TRegistry.Create do
   try
     RootKey := HKEY_CLASSES_ROOT;
Access := KEY_QUERY_VALUE;
     if OpenKey('\htmlfile\shell\open\command', False) then
       Browser := ReadString('') ;
     CloseKey;
   finally
     Free;
   end;
   if Browser = '' then
   begin
     Result := False;
     Exit;
   end;
   Browser := Copy(Browser, Pos('"', Browser) + 1, Length(Browser)) ;
   Browser := Copy(Browser, 1, Pos('"', Browser) - 1) ;
   ShellExecute(0, 'open', PChar(Browser), PChar(URL), nil, SW_SHOW) ;
end;

function getDefaultCatchProps():PLRMGridData;
  var
  dbProps :dbReturnFields2;
 begin
  dbProps:= getDefaults('"5%"',1,2,3);
  Result := dbFields2ToPLRMGridData(dbProps,0);
 end;

function getFoldersInFolder(const strtFolder:string):TStringList;
var
  validres:integer;
  SearchRec  : TSearchRec;
  rslt:TStringList;
  genSpec:String;
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
  while validres=0 do
  begin
    If (SearchRec.Name[1] <> '.') then
    begin {not a dotted directory}
        If (SearchRec.Attr and faDirectory>0) then{is a folder}
           rslt.Add(SearchRec.Name);
    end;
    validres:=FindNext(SearchRec);  {continue scanning current folder for other folders}

  end;
  Result := rslt;
  // ML Added 4/13/09. Must free up resources used by these successful finds
  SysUtils.FindClose(SearchRec);
end;

// adapted from http://delphi.about.com/od/vclusing/a/findfile.htm
function getFilesInFolder(const strtFolderPath:String; genSpec:String):TStringList ;
var
  validres:integer;
  SearchRec  : TSearchRec;
  rslt:TStringList;
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
      rslt.Add(SearchRec.Name) ;
   until FindNext(SearchRec) <> 0;
  finally
   SysUtils.FindClose(SearchRec) ;
  end;
  Result := rslt;
end;


procedure cleanUp();
begin
    FreeAndNil(snowPackNames);
    FreeAndNil(swmmDefaults);
    closeDatabase;
end;

procedure FreeStringListObjects(const strings: TStrings) ;
  var
    s : integer;
    o : TObject;
  begin
    for s := 0 to Pred(strings.Count) do
    begin
      o := strings.Objects[s];
      FreeAndNil(o) ;
    end;
  end;

procedure gsCopyFile(srcPath:String; destPath:String; overWrite:Boolean = true);
begin
  CopyFile(PChar(srcPath), PChar(destPath), not(overWrite));
end;
end.




