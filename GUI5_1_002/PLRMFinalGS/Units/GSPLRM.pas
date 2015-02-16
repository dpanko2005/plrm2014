unit GSPLRM;

interface

uses
  SysUtils, Windows, Messages, Classes, Controls, Forms, Dialogs, XMLIntf,
  msxmldom, XMLDoc, Generics.Collections, StdCtrls, ComCtrls, Grids, GSUtils,
  GSTypes, Uproject, GSCatchments, GSNodes,
  GSGIS, SiAuto;

const
  MAXNODETYPES = 9;

const
  MAXSWMMDEFBLKS = 5;

const
  CATCHPREFIX = 'Catch';

type
  TPLRM = Class
    id: String;
    typeIndex: Integer;
    gageID: String;
    gageFilePath: String;
    temptrFilePath: String;

    widthFactor: Double; // multiplied by area in width calculation
    widthPower: Double; // exponent of area is width calculation
    maxFloLength: Double; // max width is area calculation

    // 2014 added to support GIS Catchments
    expectingGISCatch: Boolean;
    currentGISCatch: TPLRMCatch;

  public
    runType: Integer;
    simTypeID: Integer;
    projUserName: string;
    projFolder: string;
    hasActvScn: Boolean;
    RunStatusStopped: Integer;

    PLRMGISObj: TPLRMGIS;
    // file paths
    projXMLPath: String;
    // defaultValidateFilePath: String;
    scenarioXMLFilePath: String;
    curSWMMInptFilePath: String;
    userSWMMInptFilePath: String;
    userSWMMRptFilePath: String;
    dbPath: string;
    wrkdir: string;
    gisdir: string;

    dateCreated: String;
    dateModified: String;

    eipNum: string;
    implAgency: string;
    createdBy: string;
    metgridNum: Integer;
    numSimYears: Double;
    prjDescription: String;
    scenarioName: String;
    scenarioNotes: String;
    currentToolHint: string;
    catchments: TStringList;
    currentCatchment: TPLRMCatch;
    projectLandUseCodes: TStringList;
    projectLandUseNames: TStringList;

    nodeAndCatchNames: TStringList;
    // stores names of all objs used to check for duplicate names
    // Node variables
    nodes: TStringList;
    currentNode: TPLRMNode;
    nodesTypeLists: array [1 .. MAXNODETYPES] of TStringList;
    nodesTypeIndexes: array [1 .. MAXNODETYPES] of Integer;
    globalSchmID: Integer;

    // curRdCondsPropsSchmID: Integer;
    // rdCondsSchemes: TStringList;
    // curhydPropsSchmID: Integer;


    // hydPropsSchemes: TStringList;
    // hydPropsRdInfSchemes: TStringList;
    // // temporarily saves PLRM5RoadDrxnXtcs Form combo box schemes
    // hydPropsRdDspSchemes: TStringList;
    // // temporarily saves PLRM5RoadDrxnXtcs Form combo box schemes
    // hydPropsRdOutSchemes: TStringList;
    // // temporarily saves PLRM5RoadDrxnXtcs Form combo box schemes
    // hydPropsPcInfSchemes: TStringList;
    // // temporarily saves PLRM5RoadDrxnXtcs Form combo box schemes
    // hydPropsPcOutSchemes: TStringList;
    // // temporarily saves PLRM5RoadDrxnXtcs Form combo box schemes

    ObjCatSecondaryFlag: Integer;
    // used to distinguish between different jucntion types introduced by PLRM
    inputFileXMLNode: IXMLNode;

    swmmDefaultBlocks: array [0 .. MAXSWMMDEFBLKS] of TStringList;
    swmmDefaultBlockXML: array [0 .. MAXSWMMDEFBLKS] of IXMLNode;
    grndWaterBlockXML: IXMLNode;

    constructor Create();
    Destructor Destroy; override;
    function deleteObj(objType: Integer; objIndex: Integer): Boolean;
    procedure addSubCatch(S: Uproject.TSubCatch; objIndex: Integer);
    procedure updateCurCatchProps(oldName: String; newName: String;
      physclProps: PLRMGridData; outGSNode: TPLRMNode);
    procedure LinkObjsToSWMMObjs();
    procedure linkCatchsAndNodesToOtherNodes(catchs: TStringList;
      nodes: TStringList);
    procedure addNode(N: Uproject.TNode; objIndex: Integer);
    function loadFromXML(xmlFilePath: String): Boolean;
    function loadGISCatchmentsFromXML(xmlFilePath: String): Boolean;
    function loadFromPrjXML(xmlFilePath: String): Boolean;
    procedure launchPropEditForm(objType: Integer; objIndex: Integer);
    function getCurCatchLuseProp(strLuse: string; colNum: Integer;
      var status: Boolean): Double;
    function getCatchIndex(catchID: String): Integer;
    function getNodeIndex(nodeID: String; list: TStringList): Integer;
    function getAllNodes(): TStringList;
    function getSWTTypeNodes(swtType: Integer): TStringList;
    function writeInitProjectToXML(filePath: String;
      scnName: String = ''): Boolean;

    function ramSWTsToXML(var ownerNode:IXMLNode;nodeList: TStringList): IXMLNode;
    function ramParcelBMPsSrcCtrlToXML(var ownerNode:IXMLNode;catchmentsList: TStringList): IXMLNode;
    function ramRoadConditionToXML(var ownerNode:IXMLNode;catchmentsList: TStringList): IXMLNode;
    function plrmToXML(): Boolean;
    function plrmGISToXML(catchList: TStringList;
      saveToFilePath: String): Boolean;
    function updateScenarioXML(xmlFilePath: String): Boolean;
    function run(): Boolean;
    function chkNodesAndCatchs(): Boolean;
  end;

  // memory management
procedure FreeStringListObjects(const strings: TStrings);

var
  PLRMObj: TPLRM;
  swmmDefaultBlockXMLTags: array [0 .. MAXSWMMDEFBLKS] of String = (
    'Options',
    'Evaporation',
    'Temperature',
    'Aquifers',
    'GroundWater',
    'SnowPacks'
  );

implementation

uses
  _PLRMD3CatchProps, _PLRM7SWTs, Fmain, Uimport, Uglobals, GSIO, Uvalidate;

{$REGION 'PLRM class methods'}

constructor TPLRM.Create();
var
  I: Integer;
  tempList: TStringList;
  SearchRec: TSearchRec;
  widthCalcFactors: dbReturnFields;
begin
  // PLRM Edit Jan 2010 edit added to track whether user working with scenario see #233
  hasActvScn := false;
  // Many of these are just temporary because this gets created at start up
  metgridNum := 1; // TO DO use appropriate default or none
  gageID := '1';
  runType := 0;
  simTypeID := 2; // default is short simulation
  // curhydPropsSchmID := -1;
  // curRdCondsPropsSchmID := -1;
  globalSchmID := -1;
  catchments := TStringList.Create;
  // hydPropsSchemes := TStringList.Create;
  // rdCondsSchemes := TStringList.Create;
  nodeAndCatchNames := TStringList.Create;
  createdBy := 'unknown';

  // Store list of landuses for later use
  projectLandUseCodes := TStringList.Create;
  projectLandUseCodes := getCodes('1%', 2);
  projectLandUseNames := TStringList.Create;
  projectLandUseNames := getCodes('1%', 1);

  // Initialize nodes
  nodes := TStringList.Create;
  for I := 1 to MAXNODETYPES do
    nodesTypeLists[I] := TStringList.Create;

  { if runType = 0 then // it is new scenario not opened from an input file
    // read in groundwater table formated as xml
    tempListGW := TStringList.Create();
    for I := 0 to High(grnWaterXMLTags) do
    tempListGW.Add(grnWaterXMLTags[I]);

    tempListGW2 := TStringList.Create();
    tempListGW2.Add('GW'); // arbitrary for naming purposes only
    grndWaterBlockXML := plrmGridDataToXML2('GroundWater',
    getDBDataAsPLRMGridData('GroundWater'), tempListGW, tempListGW2,
    tempListGW2)[0]; }
  swmmDefaults := TStringList.Create();
  tempList := TStringList.Create();
  swmmDefaults := getSWMMDefaults('"6%"', tempList, swmmDefaults);

  widthCalcFactors := GSIO.getDefaults('"4%"');
  maxFloLength := StrToFloat(widthCalcFactors[0][0]);
  widthPower := StrToFloat(widthCalcFactors[0][1]);
  widthFactor := StrToFloat(widthCalcFactors[0][2]);

  // Set Defaults
  projUserName := defaultProjName;
  dateCreated := DateTimeToStr(Now);
  dateModified := DateTimeToStr(Now);
  curSWMMInptFilePath := defaultGenSWmmInpPath;
  userSWMMInptFilePath := defaultUserSWmmInpPath;
  userSWMMRptFilePath := defaultUserSwmmRptPath;
  scenarioXMLFilePath := defaultPrjPath;

  // set default main xsl path to the path of any .xsl file in the /Engine folder
  if (FindFirst(defaultEngnDir + '\*.xsl', faAnyFile, SearchRec) = 0) then
  begin
    defaultXslPath := defaultEngnDir + '\' + SearchRec.Name;
    SysUtils.FindClose(SearchRec);
  end;

  // set default validation xsl path to the path of any .xsl file in the /Engine folder
  if (FindFirst(defaultValidateDir + '\*.xsl', faAnyFile, SearchRec) = 0) then
  begin
    validateXslPath := defaultValidateDir + '\' + SearchRec.Name;
    SysUtils.FindClose(SearchRec);
  end;

  // 2014 set default CAP xsl path to the path of any .xsl file in the /Engine/CAP folder
  if (FindFirst(defaultEngnDir + '\CAP\*.xsl', faAnyFile, SearchRec) = 0) then
  begin
    CAPXslPath := defaultEngnDir + '\CAP\' + SearchRec.Name;
    SysUtils.FindClose(SearchRec);
  end;

  // 2014 create obj to hold GIS data
  PLRMGISObj := TPLRMGIS.Create();

  projFolder := defaultPrjDir;
  wrkdir := defaultPrjDir;
  gisdir := defaultPrjDir;
  dbPath := defaultDBPath;
  eipNum := '0000';
  implAgency := 'unknown';
  createdBy := 'unknown user';
  prjDescription :=
    'Please provide an optional project and/or scenario description';
  scenarioName := defaultScnName;
  scenarioNotes := 'Provide optional scenario notes';
  FreeAndNil(tempList);
  { FreeAndNil(tempListGW);
    FreeAndNil(tempListGW2); }
end;

// TWords destructor - release storage
destructor TPLRM.Destroy;
var
  I: Integer;
begin

  // Release memory, if obtained
  FreeAndNil(nodeAndCatchNames); // simple Stringlist has only strings
  FreeStringListObjects(catchments);
  FreeStringListObjects(nodes);
  // FreeStringListObjects(rdCondsSchemes);
  FreeStringListObjects(projectLandUseCodes);
  FreeStringListObjects(projectLandUseNames);

  if assigned(currentCatchment) then
    currentCatchment := nil;
  // memory already freed when freeing list of catchments
  if assigned(currentNode) then
    currentNode := nil; // memory already freed when freeing list of nodes

  // inputFileXMLNode := nil;
  for I := 1 to MAXNODETYPES do
    FreeAndNil(nodesTypeLists[I]);

  for I := 0 to MAXSWMMDEFBLKS do
  begin
    FreeAndNil(swmmDefaultBlocks[I]);
    // swmmDefaultBlockXML[I] := nil;
  end;

  // 2014 create obj to hold GIS data
  if assigned(PLRMGISObj) then
    FreeAndNil(PLRMGISObj);

  inherited;
end;

function TPLRM.run(): Boolean;
var
  // sender:TObject;
  flag: Boolean;
  I: Integer;
  Catch: TPLRMCatch;
  Node: TPLRMNode;
begin

  // do not try to run if no objects have been created
  if assigned(catchments) and assigned(nodes) then
  begin
    if ((catchments.count = 0) or (nodes.count = 0)) then
    begin
      ShowMessage
        ('Please add catchment and node objects to the canvas before running the simulation');
      Result := false;
      exit;
    end
    else
      for I := 0 to catchments.count - 1 do
      begin
        Catch := catchments.Objects[I] as TPLRMCatch;
        if not(assigned(Catch.outNode)) then
        begin
          ShowMessage('Catchment: [' + Catch.Name +
            '] is not connected to any node');
          ShowMessage
            ('This scenario has been save and can be re-opened from the Project Manager');
          Result := false;
          exit;
        end;
      end;
    for I := 0 to nodes.count - 1 do
    begin
      Node := nodes.Objects[I] as TPLRMNode;
      if ((Node.objType <> 5) and (not(assigned(Node.outNode1)))) then
      begin
        ShowMessage('Node: [' + Node.userName +
          '] is not connected to any node');
        ShowMessage
          ('This scenario has been save and can be re-opened from the Project Manager');
        Result := false;
        exit;
      end;
    end;
  end;

  Try
    // Step 1 - formulate xml and save all info to swmm with running throug objects
    flag := PLRMObj.plrmToXML();
    if flag = false then
    begin
      ShowMessage('An error occured while trying to save the input file');
      Result := false;
      exit;
    end;

    // Step 2 - transform main xml file into validation file and display it
    transformXMLToSwmm(validateXslPath, scenarioXMLFilePath,
      defaultValidateFilePath);

    // Step 4 - 2014 transform main xml file into cap csv file.
    transformXMLToSwmm(CAPXslPath, scenarioXMLFilePath, defaultCAPFilePath);

    // Display result validation html file in browser
    // 2014 now added a button to trigger this no longer loaded automatically
    // BrowseURL(defaultValidateFilePath);

    // Step 3 - transform main xml file into swmm file
    transformXMLToSwmm(defaultXslPath, scenarioXMLFilePath,
      curSWMMInptFilePath);
    // Step 4 - open temporarily generated PLRM swmm input file
    MainForm.OpenFile(nil, curSWMMInptFilePath);
    // MainForm.OpenFile(sender,curSWMMInptFilePath);
    currentRptFilePath := userSWMMRptFilePath;
    // used in Fmain to copy tempfile to scenario directory

    // run outside this routine in fmain
  Except
    on E: Exception do
    begin
      ShowMessage('An Error occured, Exception message = ' + E.Message);
      // Result := false;
    end;
  end;
  Result := true;
end;

function TPLRM.chkNodesAndCatchs(): Boolean;
var
  // sender:TObject;
  // flag:Boolean;
  I: Integer;
  Catch: TPLRMCatch;
  Node: TPLRMNode;
begin

  // do not try to run if no objects have been created
  if assigned(catchments) and assigned(nodes) then
  begin
    if ((catchments.count = 0) or (nodes.count = 0)) then
    begin
      ShowMessage
        ('Please add catchment and node objects to the canvas before saving or running the simulation');
      Result := false;
      exit;
    end
    else
      for I := 0 to catchments.count - 1 do
      begin
        Catch := catchments.Objects[I] as TPLRMCatch;
        if not(assigned(Catch.outNode)) then
        begin
          ShowMessage('Catchment: [' + Catch.Name +
            '] is not connected to any node');
          ShowMessage
            ('This scenario has been save and can be re-opened from the Project Manager');
          Result := false;
          exit;
        end;
      end;
    for I := 0 to nodes.count - 1 do
    begin
      Node := nodes.Objects[I] as TPLRMNode;
      if ((Node.objType <> 5) and (not(assigned(Node.outNode1)))) then
      begin
        ShowMessage('Node: [' + Node.userName +
          '] is not connected to any node');
        ShowMessage
          ('This scenario has been save and can be re-opened from the Project Manager');
        Result := false;
        exit;
      end;
    end;
  end;
  Result := false;
end;

function TPLRM.ramSWTsToXML(var ownerNode:IXMLNode;nodeList: TStringList): IXMLNode;
var
  XMLDoc: IXMLDocument;
  iNode: IXMLNode;
  tempNode: IXMLNode;
  I: Integer;
  tempSWT: TPLRMNode;
const
  swtNames: array [0 .. 6] of string = ('NA', SWTDETBASIN, SWTINFBASIN,
    SWTWETBASIN, SWTGRNFILTR, SWTCRTFILTR, SWTTRTVAULT);
  // ramSwtNames: array [0 .. 6] of string = ('NA', 'DryBasin', 'WetBasin',
  // 'InfiltrationBasin', 'CartridgeFilter', 'TreatmentVault', 'BedFilter');

begin
  {XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := true;
  iNode := XMLDoc.AddChild('CAPSWTs');}
  iNode := ownerNode.OwnerDocument.CreateNode('CAPSWTs', ntElement);

  // save dictionary contents as xml
  // for tempInt in UniqueSWTsDict.Keys do
  for I := 0 to nodeList.count - 1 do
  begin
    tempSWT := (nodeList.Objects[I] as TPLRMNode);
    if (tempSWT.objType = 7) then // then its a treatment node swt
    begin
      tempNode := iNode.AddChild('CAPBMPs', '');
      { tempNode.Attributes['P_BMP'] := swtNames[tempInt];
        tempNode.Attributes['P_BMPType'] := tempInt;
        tempNode.Attributes['BMP'] := ramSwtNames[tempInt]; }

      tempNode.Attributes['P_BMP'] := tempSWT.userName;
      tempNode.Attributes['P_BMPType'] := tempSWT.swtType;
      tempNode.Attributes['BMP'] := swtNames[tempSWT.swtType];
    end;
  end;
  Result := iNode;
end;

function TPLRM.ramParcelBMPsSrcCtrlToXML(var ownerNode:IXMLNode;catchmentsList: TStringList): IXMLNode;
var
  XMLDoc: IXMLDocument;
  iNode: IXMLNode;
  tempNode: IXMLNode;
  UniqueParcelsDict: TDictionary<String, Double>;
  tempPLRMTbl: PLRMGridData;
  tempDbl: Double;
  tempStr, tempKey, tempKey1, tempKey2, tempKey3, tempKey4, tempKey5,
    tempKey6: String;
  I, J: Integer;
  tempCatch: TPLRMCatch;
  tempCatchArea: Double;
  tempCatchSFRArea: Double;
  tempCatchMFRArea: Double;
  tempCatchCicuArea: Double;
begin

  tempCatchArea := 0;
  tempCatchSFRArea := 0;
  tempCatchMFRArea := 0;
  tempCatchCicuArea := 0;

  {XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := true;
  iNode := XMLDoc.AddChild('CAPParcelBMPsAndSrcCtrls');}
  iNode := ownerNode.OwnerDocument.CreateNode('CAPParcelBMPsAndSrcCtrls', ntElement);

  tempKey1 := 'SfrBMP';
  tempKey2 := 'SfrSC';
  tempKey3 := 'MfrBMP';
  tempKey4 := 'MfrSC';
  tempKey5 := 'CicBMP';
  tempKey6 := 'CicSC';

  // loop through catchments and prepare data summary for tahoe tools
  UniqueParcelsDict := TDictionary<String, Double>.Create();

  // set intial values to 0
  // sfr source control areas summed for all catchments
  UniqueParcelsDict.Add(tempKey1, 0);
  // sfr bmp areas summed for all catchments
  UniqueParcelsDict.Add(tempKey2, 0);
  // mfr source control areas summed for all catchments
  UniqueParcelsDict.Add(tempKey3, 0);
  // mfr bmp areas summed for all catchments
  UniqueParcelsDict.Add(tempKey4, 0);
  // cicu source control areas summed for all catchments
  UniqueParcelsDict.Add(tempKey5, 0);
  // cicu bmp areas summed for all catchments
  UniqueParcelsDict.Add(tempKey6, 0);

  for I := 0 to catchments.count - 1 do
  begin
    tempCatch := (catchments.Objects[I] as TPLRMCatch);
    tempCatchArea := tempCatchArea + tempCatch.area;
    // tabulate unique road condition score areas
    tempPLRMTbl := tempCatch.frm6of6SgBMPImplData;
    if (tempCatch.frm6of6AreasData.luseAreaNImpv[0 + luseOffset, 0] <> '') then
    begin
      tempCatchSFRArea := tempCatchSFRArea +
        StrToFloat(tempCatch.frm6of6AreasData.luseAreaNImpv[0 + luseOffset, 0]);
      tempDbl := UniqueParcelsDict[tempKey1] +
        (StrToFloat(tempPLRMTbl[0, 0]) *
        StrToFloat(tempCatch.frm6of6AreasData.luseAreaNImpv[0 + luseOffset,
        0]) / 100);
      UniqueParcelsDict[tempKey1] := tempDbl;

      tempDbl := UniqueParcelsDict[tempKey2] +
        (StrToFloat(tempPLRMTbl[0, 1]) *
        StrToFloat(tempCatch.frm6of6AreasData.luseAreaNImpv[0 + luseOffset,
        0]) / 100);
      UniqueParcelsDict[tempKey2] := tempDbl;
    end;
    if (tempCatch.frm6of6AreasData.luseAreaNImpv[1 + luseOffset, 0] <> '') then
    begin
      tempCatchMFRArea := tempCatchMFRArea +
        StrToFloat(tempCatch.frm6of6AreasData.luseAreaNImpv[1 + luseOffset, 0]);
      tempDbl := UniqueParcelsDict[tempKey3] +
        (StrToFloat(tempPLRMTbl[1, 0]) *
        StrToFloat(tempCatch.frm6of6AreasData.luseAreaNImpv[1 + luseOffset,
        0]) / 100);
      UniqueParcelsDict[tempKey3] := tempDbl;

      tempDbl := UniqueParcelsDict[tempKey4] +
        (StrToFloat(tempPLRMTbl[1, 1]) *
        StrToFloat(tempCatch.frm6of6AreasData.luseAreaNImpv[1 + luseOffset,
        0]) / 100);
      UniqueParcelsDict[tempKey4] := tempDbl;
    end;
    if (tempCatch.frm6of6AreasData.luseAreaNImpv[2 + luseOffset, 0] <> '') then
    begin
      tempCatchCicuArea := tempCatchCicuArea +
        StrToFloat(tempCatch.frm6of6AreasData.luseAreaNImpv[2 + luseOffset, 0]);
      tempDbl := UniqueParcelsDict[tempKey5] +
        (StrToFloat(tempPLRMTbl[2, 0]) *
        StrToFloat(tempCatch.frm6of6AreasData.luseAreaNImpv[2 + luseOffset,
        0]) / 100);
      UniqueParcelsDict[tempKey5] := tempDbl;

      tempDbl := UniqueParcelsDict[tempKey6] +
        (StrToFloat(tempPLRMTbl[2, 1]) *
        StrToFloat(tempCatch.frm6of6AreasData.luseAreaNImpv[2 + luseOffset,
        0]) / 100);
      UniqueParcelsDict[tempKey6] := tempDbl;
    end;
  end;

  // save dictionary contents as xml
  for tempStr in UniqueParcelsDict.Keys do
  begin
    tempNode := iNode.AddChild('CAPParcelBMPsSrcCtrl', '');
    tempNode.Attributes['item'] := tempStr;
    tempNode.Attributes['value'] :=
      FormatFloat(TWODP, UniqueParcelsDict[tempStr]);
  end;
  iNode.Attributes['count'] := UniqueParcelsDict.count;
  // iNode.Attributes['totalCatchmentArea'] := tempCatchArea;
  iNode.Attributes['totalSFRArea'] := tempCatchSFRArea;
  iNode.Attributes['totalMFRArea'] := tempCatchMFRArea;
  iNode.Attributes['totalCicuArea'] := tempCatchCicuArea;
  Result := iNode;
end;

function TPLRM.ramRoadConditionToXML(var ownerNode:IXMLNode;catchmentsList: TStringList): IXMLNode;
var
  XMLDoc: IXMLDocument;
  iNode: IXMLNode;
  tempNode: IXMLNode;
  UniqueRdCondDict: TDictionary<String, Double>;
  tempfrm4of6SgRoadConditionData: PLRMGridData;
  tempDbl: Double;
  tempStr, tempKey: String;
  I, J: Integer;
begin
  {XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := true;
  iNode := XMLDoc.AddChild('CAPRoadConditions');}
  iNode := ownerNode.OwnerDocument.CreateNode('CAPRoadConditions', ntElement);

  // loop through catchments and prepare data summary for tahoe tools
  UniqueRdCondDict := TDictionary<String, Double>.Create();
  for I := 0 to catchments.count - 1 do
  begin
    // tabulate unique road condition score areas
    tempfrm4of6SgRoadConditionData := (catchments.Objects[I] as TPLRMCatch)
      .frm4of6SgRoadConditionData;
    for J := 0 to High(tempfrm4of6SgRoadConditionData) do
    begin
      // store current key
      tempKey := tempfrm4of6SgRoadConditionData[J, 1];
      // check for blank rows
      if (tempKey <> '') then
      begin
        // rounding errors sometimes cause same keys to be stored differently eg 4 vs 4.00 so round all to 2 dp
        tempKey := FormatFloat(ONEDP, StrToFloat(tempKey));

        // see if key already recorded in dict
        if (UniqueRdCondDict.ContainsKey(tempKey)) then
        begin
          // get existing sum
          tempDbl := UniqueRdCondDict[tempKey];
          // update sum
          UniqueRdCondDict[tempKey] := tempDbl +
            StrToFloat(tempfrm4of6SgRoadConditionData[J, 0]) *
            (catchments.Objects[I] as TPLRMCatch).totRoadImpervAcres / 100;
        end
        else
          UniqueRdCondDict.Add(tempKey,
            StrToFloat(tempfrm4of6SgRoadConditionData[J, 0]) *
            (catchments.Objects[I] as TPLRMCatch).totRoadImpervAcres / 100);
      end;
    end;
  end;

  // save dictionary contents as xml
  for tempStr in UniqueRdCondDict.Keys do
  begin
    tempNode := iNode.AddChild('CAPRoadCondition', '');
    tempNode.Attributes['r_score'] := tempStr;
    tempNode.Attributes['r_area'] :=
      FormatFloat(TWODP, UniqueRdCondDict[tempStr]);
  end;
  iNode.Attributes['count'] := UniqueRdCondDict.count;
  Result := iNode;
end;

function TPLRM.plrmToXML(): Boolean;
var
  XMLDoc: IXMLDocument;
  iNode: IXMLNode;
  iCatchmentsNode, iTrueNodes: IXMLNode;
  tempNodeArry: array of IXMLNode;
  tempNodeArry2: array of IXMLNode;
  tempNodeArry3: array of IXMLNode;
  tempNodeArry4: array of IXMLNode;
  tempNodeArry5: array of IXMLNode;
  tempNodeList0: IXMLNodeList;
  tempNode0: IXMLNode; // very temporary node
  tempNode3: IXMLNode;
  tempNode4: IXMLNode;
  tempNode4b: IXMLNode;
  tempNode6: IXMLNode;
  tempNode7: IXMLNode;
  tempNode7b: IXMLNode;
  tempNode8: IXMLNode;
  tempNode9: IXMLNode;
  tempNode10: IXMLNode;
  tempNode19b: IXMLNode;
  tempNode20: IXMLNode; // CAP Road condition nodes
  tempNode21: IXMLNode; // CAP Parcel BMP & Src control nodes
  tempNode22: IXMLNode; // CAP SWTS

  catchmentValidationXMLNode: IXMLNode;
  nodeValidationXMLNode: IXMLNode;
  I: Integer;
  tempCount: Integer;
  tempListGW2: TStringList;
  tempListGW: TStringList;
begin
  SiMain.EnterMethod(Self, 'TPLRM.plrmToXML');
  Try
    // Step 1 - first make swmm save user inp file as swmm.inp
    makeSWMMSaveInpFile(userSWMMInptFilePath, userSWMMRptFilePath);

    for I := 0 to High(swmmDefaultBlocks) do
      swmmDefaultBlocks[I] := getSwmmDefaultBlocks(I, intToStr(simTypeID));

    {// loop through catchments and nodes to prepare data summary for tahoe tools
    tempNode20 := ramRoadConditionToXML(iNode,catchments);
    tempNode21 := ramParcelBMPsSrcCtrlToXML(iNode,catchments);
    tempNode22 := ramSWTsToXML(iNode,nodes);   }

    { SetLength(tempNodeArry3, 4);
      temptrFilePath := defaultDataDir + '\' + intToStr(metgridNum) + '_Temp.dat';
      tempNodeArry3[0] := swmmInptFileTempTimeSeriesToXML('TempTSeries',
      temptrFilePath);
      tempNodeArry3[1] := swmmInptFileReportToXML(iNode);
      tempNodeArry3[2] := swmmInptFileTagsToXML(iNode);
      tempNodeArry3[3] := swmmInptFileMapToXML(iNode); }

    XMLDoc := TXMLDocument.Create(nil);
    XMLDoc.Active := true;
    iNode := XMLDoc.AddChild('PLRM');

    // 2014 add GIS node
    if (assigned(PLRMGISObj.PLRMGISRec.shpFilesDict) and
      (PLRMGISObj.PLRMGISRec.shpFilesDict.count < 1)) then
      iNode.ChildNodes.Add(PLRMGISObj.toXML());

    tempNode0 := iNode.AddChild('Project');
    // Add project meta data
    tempNode0.Attributes['dateCreated'] := dateCreated;
    tempNode0.Attributes['dateModified'] := DateTimeToStr(Now);
    tempNode0.Attributes['name'] := projUserName;

    tempNode0 := iNode.AddChild('Metgrid');
    tempNode0.Text := intToStr(metgridNum);

    tempNode0 := iNode.AddChild('SimYears');
    tempNode0.Text := FloatToStr(numSimYears);

    tempNode0 := iNode.AddChild('UserSWMMInpt');
    tempNode0.Text := userSWMMInptFilePath;

    tempNode0 := iNode.AddChild('GenSWMMInpt');
    tempNode0.Text := curSWMMInptFilePath;

    tempNode0 := iNode.AddChild('WorkingDir');
    tempNode0.Text := wrkdir;

    tempNode0 := iNode.AddChild('CreatedBy');
    tempNode0.Text := createdBy;

    tempNode0 := iNode.AddChild('LocationDescription');
    tempNode0.Text := prjDescription;

    tempNode0 := iNode.AddChild('ScenName');
    tempNode0.Text := scenarioName;

    tempNode0 := iNode.AddChild('ScenDescription');
    tempNode0.Text := scenarioNotes;

    // 1,2,3,6,7,8. Write options, evap, temperature, aquifers, groundH2O, snowpacks
    for I := 0 to High(swmmDefaultBlocks) do
      swmmBlockLinesToXML(swmmDefaultBlocks[I],
        swmmDefaultBlockXMLTags[I], iNode);

    // add ground water
    // if runType = 0 then // it is new scenario not opened from an input file
    // read in groundwater table formated as xml
    tempListGW := TStringList.Create();
    for I := 0 to High(grnWaterXMLTags) do
      tempListGW.Add(grnWaterXMLTags[I]);

    tempListGW2 := TStringList.Create();
    tempListGW2.Add('GW'); // arbitrary for naming purposes only
    grndWaterBlockXML := plrmGridDataToXML2(iNode,'GroundWater',
      getDBDataAsPLRMGridData('GroundWater'), tempListGW, tempListGW2,
      tempListGW2)[0];
    iNode.ChildNodes.Add(grndWaterBlockXML);

    // 4.Add raingages
    gageFilePath := defaultDataDir + '\' + intToStr(metgridNum) + '_Precip.dat';
    // tempNodeList0 := swmmInptFileRainGageToXML(iNode,PLRMObj.gageID, gageFilePath);
    // tempCount := tempNodeList0.Count;
    // tempNode3 := tempNodeList0[0];
    tempNode3 := swmmInptFileRainGageToXML(iNode, PLRMObj.gageID, gageFilePath);
    iNode.ChildNodes.Add(tempNode3);

    // Write PLRM Swmm default constants
    tempNode6 := swmmDefaultsToXML(iNode, swmmDefaults, maxFloLength,
      widthPower, widthFactor, 'SWMMDefaults'); // Imperv N, pervN, etc
    XMLDoc.Resync;
    XMLDoc.ChildNodes[0].ChildNodes.Add(tempNode6);

    tempNode7 := swmmInptFileLossesToXML(iNode);
    tempNode8 := swmmInptFileLoadingsToXML(iNode);
    tempNode9 := swmmInptFileBuildUpToXML(iNode);
    tempNode10 := swmmInptFileWashOffToXML(iNode);
    tempNode19b := swmmInptFileLandUseToXML(iNode);

    SetLength(tempNodeArry3, 4);
    temptrFilePath := defaultDataDir + '\' + intToStr(metgridNum) + '_Temp.dat';
    tempNodeArry3[0] := swmmInptFileTempTimeSeriesToXML(iNode, 'TempTSeries',
      temptrFilePath);
    tempNodeArry3[1] := swmmInptFileReportToXML(iNode);
    tempNodeArry3[2] := swmmInptFileTagsToXML(iNode);
    tempNodeArry3[3] := swmmInptFileMapToXML(iNode);

    // 5.Add catchments
    iCatchmentsNode := XMLDoc.ChildNodes[0].AddChild('Catchments');
    XMLDoc.Resync;

    // 5.Prep catchments
    SetLength(tempNodeArry, catchments.count);
    for I := 0 to catchments.count - 1 do
    begin
      tempNodeArry[I] := (catchments.Objects[I] as TPLRMCatch)
        .catchToXML(iCatchmentsNode, projectLandUseNames, projectLandUseCodes);
    end;

    for I := 0 to catchments.count - 1 do
    begin
      if (assigned(tempNodeArry[I])) then
        XMLDoc.ChildNodes[0].ChildNodes['Catchments'].ChildNodes.Add
          (tempNodeArry[I]);
    end;
    XMLDoc.Resync;

    // 9,10,11,12 Add nodes
    iTrueNodes := XMLDoc.ChildNodes[0].AddChild('Nodes');
    XMLDoc.Resync;

    // Prep nodes
    SetLength(tempNodeArry2, nodes.count);
    for I := 0 to nodes.count - 1 do
    begin
      tempNodeArry2[I] := (nodes.Objects[I] as TPLRMNode).nodeToXML(iTrueNodes);
    end;

    for I := 0 to nodes.count - 1 do
    begin
      if (assigned(tempNodeArry2[I])) then
        XMLDoc.ChildNodes[0].ChildNodes['Nodes'].ChildNodes.Add
          (tempNodeArry2[I]);
    end;
    XMLDoc.Resync;

    // 17. Write losses
    XMLDoc.ChildNodes[0].ChildNodes.Add(tempNode7);

    // 18.Write Pollutants
    //XMLDoc.ChildNodes[0].ChildNodes.Add(swmmInptFilePollutantsToXML)
    tempNode7b := swmmInptFilePollutantsToXML(iNode);
    XMLDoc.ChildNodes[0].ChildNodes.Add(tempNode7b);

    // 19.Add project land uses
    tempNode4 := XMLDoc.ChildNodes[0].AddChild('LandUses');
    for I := 0 to projectLandUseCodes.count - 1 do
    begin
      tempNode4b := tempNode4.AddChild('LandUse');
      tempNode4b.Text := projectLandUseCodes[I];
    end;

    // 19b add parcel only land uses
    XMLDoc.ChildNodes[0].ChildNodes.Add(tempNode19b);

    // 20.Write coverages
    // Transformed from Catchments xml

    // 21. Write loadings
    XMLDoc.ChildNodes[0].ChildNodes.Add(tempNode8);
    // 22. Write buildup
    XMLDoc.ChildNodes[0].ChildNodes.Add(tempNode9);
    // 23. Write washoff
    XMLDoc.ChildNodes[0].ChildNodes.Add(tempNode10);
    // 24. Write treatment
    // 25. Write curves
    // 26. Write timeseries
    XMLDoc.ChildNodes[0].ChildNodes.Add(tempNodeArry3[0]);
    // 27. Write report
    XMLDoc.ChildNodes[0].ChildNodes.Add(tempNodeArry3[1]);
    // 28. Write tags
    XMLDoc.ChildNodes[0].ChildNodes.Add(tempNodeArry3[2]);
    // 29. Write map
    XMLDoc.ChildNodes[0].ChildNodes.Add(tempNodeArry3[3]);

    // 30. Write CAP nodes
    // loop through catchments and nodes to prepare data summary for tahoe tools
    tempNode20 := ramRoadConditionToXML(iNode,catchments);
    tempNode21 := ramParcelBMPsSrcCtrlToXML(iNode,catchments);
    tempNode22 := ramSWTsToXML(iNode,nodes);

    XMLDoc.ChildNodes[0].ChildNodes.Add(tempNode20);
    XMLDoc.ChildNodes[0].ChildNodes.Add(tempNode21);
    XMLDoc.ChildNodes[0].ChildNodes.Add(tempNode22);

    // 31. Write Schemes
    // if (rdCondsSchemes.count + hydPropsSchemes.count) > 0 then
    // begin
    // XMLDoc.ChildNodes[0].AddChild('Schemes');
    // XMLDoc.Resync;
    // // Write Road Condition Schemes
    // for I := 0 to rdCondsSchemes.count - 1 do
    // XMLDoc.ChildNodes[0].ChildNodes['Schemes'].ChildNodes.Add
    // (tempNodeArry4[I]);
    // // Write Hydro Properties Condition Schemes
    // for I := 0 to hydPropsSchemes.count - 1 do
    // XMLDoc.ChildNodes[0].ChildNodes['Schemes'].ChildNodes.Add
    // (tempNodeArry5[I]);
    // end;

    // 32. Write Catchment and Node validation rules
    // create catchment and node validation xmlNodes
    catchmentValidationXMLNode := catchmentValidationTblToXML(iNode);
    nodeValidationXMLNode := nodeValidationTblToXML(iNode);
    XMLDoc.ChildNodes[0].ChildNodes.Add(catchmentValidationXMLNode);
    XMLDoc.ChildNodes[0].ChildNodes.Add(nodeValidationXMLNode);

    if (curSWMMInptFilePath = '') then
      curSWMMInptFilePath := defaultGenSWmmInpPath;
    saveXmlDoc2(scenarioXMLFilePath, XMLDoc);
    Result := true;
  except
    on E: Exception do
    begin
      Result := false;
      ShowMessage('An Error occured, Exception message = ' + E.Message);
      SiMain.LeaveMethod(Self, 'TPLRM.plrmToXML');
    end;
  end;
  SiMain.LeaveMethod(Self, 'TPLRM.plrmToXML');
end;

// 2014 added to serialize GIS Tools inputs and outputs
function TPLRM.plrmGISToXML(catchList: TStringList;
  saveToFilePath: String): Boolean;
var
  XMLDoc: IXMLDocument;
  iNode, iCatchmentsNode: IXMLNode;
  tempNodeArry: array of IXMLNode;
  tempNode4: IXMLNode;
  tempNode4b: IXMLNode;
  I: Integer;
begin
  Try

    XMLDoc := TXMLDocument.Create(nil);
    XMLDoc.Active := true;
    iNode := XMLDoc.AddChild('PLRM');

    // 2014 add GIS node
    if (assigned(PLRMGISObj.PLRMGISRec.shpFilesDict) and
      (PLRMGISObj.PLRMGISRec.shpFilesDict.count < 1)) then
      iNode.ChildNodes.Add(PLRMGISObj.toXML());

    iNode.AddChild('Project');
    // Add project meta data
    iNode.ChildNodes['Project'].Attributes['dateCreated'] := dateCreated;
    iNode.ChildNodes['Project'].Attributes['dateModified'] :=
      DateTimeToStr(Now);
    iNode.ChildNodes['Project'].Attributes['name'] := projUserName;
    iNode.ChildNodes['Metgrid'].Text := intToStr(metgridNum);
    iNode.ChildNodes['UserSWMMInpt'].Text := userSWMMInptFilePath;
    iNode.ChildNodes['GenSWMMInpt'].Text := curSWMMInptFilePath;
    iNode.ChildNodes['WorkingDir'].Text := wrkdir;
    iNode.ChildNodes['CreatedBy'].Text := createdBy;
    iNode.ChildNodes['LocationDescription'].Text := prjDescription;
    iNode.ChildNodes['ScenName'].Text := scenarioName;
    iNode.ChildNodes['ScenDescription'].Text := scenarioNotes;
    XMLDoc.Resync;

    // 5.Add catchments
    iCatchmentsNode := XMLDoc.ChildNodes[0].AddChild('Catchments');
    XMLDoc.Resync;

    // 5.Prep catchments
    SetLength(tempNodeArry, catchList.count);
    for I := 0 to catchList.count - 1 do
    begin
      tempNodeArry[I] := (catchList.Objects[I] as TPLRMCatch)
        .catchToXML(iCatchmentsNode, projectLandUseNames, projectLandUseCodes);
    end;

    for I := 0 to catchList.count - 1 do
    begin
      if (assigned(tempNodeArry[I])) then
        XMLDoc.ChildNodes[0].ChildNodes['Catchments'].ChildNodes.Add
          (tempNodeArry[I]);
    end;
    XMLDoc.Resync;

    // 19.Add project land uses
    tempNode4 := XMLDoc.ChildNodes[0].AddChild('LandUses');
    for I := 0 to projectLandUseCodes.count - 1 do
    begin
      tempNode4b := tempNode4.AddChild('LandUse');
      tempNode4b.Text := projectLandUseCodes[I];
    end;

    saveXmlDoc2(saveToFilePath, XMLDoc);
    // XMLDoc := nil;
    Result := true;
  except
    on E: Exception do
    begin
      Result := false;
      ShowMessage('An Error occured, Exception message = ' + E.Message);
    end;
  end;
end;

function TPLRM.writeInitProjectToXML(filePath: String;
  scnName: String = ''): Boolean;
var
  XMLDoc: IXMLDocument;
  iNode: IXMLNode;
begin
  // Result := false;
  Try

    XMLDoc := TXMLDocument.Create(nil);
    XMLDoc.Active := true;
    iNode := XMLDoc.AddChild('PLRM', '');

    // Add project meta data
    iNode.ChildNodes['Project'].Attributes['dateCreated'] := dateCreated;
    iNode.ChildNodes['Project'].Attributes['dateModified'] :=
      DateTimeToStr(Now);
    iNode.ChildNodes['ProjectUserName'].Text := projUserName;
    iNode.ChildNodes['ProjectXMLpath'].Text := projXMLPath;
    iNode.ChildNodes['ProjectFolderName'].Text := projFolder;
    iNode.ChildNodes['DatabasePath'].Text := dbPath;
    iNode.ChildNodes['EipNumber'].Text := eipNum;
    iNode.ChildNodes['Agency'].Text := implAgency;
    iNode.ChildNodes['CreatedBy'].Text := createdBy;
    iNode.ChildNodes['LocationDescription'].Text := prjDescription;
    iNode.ChildNodes['MetGridNumber'].Text := intToStr(metgridNum);
    iNode.ChildNodes['SimTypeID'].Text := intToStr(simTypeID);

    if scnName <> '' then
      iNode.ChildNodes['ScenName'].Text := scnName;

    if (filePath = '') then
      filePath := defaultPrjDir;
    saveXmlDoc(filePath, XMLDoc, defaultXMLDeclrtn, defaultXslPath);
    // XMLDoc := nil;
    Result := true;
  Except
    on E: Exception do
    begin
      Result := false;
      ShowMessage('An Error occured, Exception message = ' + E.Message);
    end;
  end;
end;

function TPLRM.updateScenarioXML(xmlFilePath: String): Boolean;
// This function updates the Scenario XML file with information collected in the scenario editor
var
  XMLDoc: IXMLDocument;
  rootNode: IXMLNode;
  S: TStringList;
begin
  try
    XMLDoc := TXMLDocument.Create(nil);
    XMLDoc.loadFromFile(xmlFilePath);
    rootNode := XMLDoc.DocumentElement; // .ChildNodes[0];
    // Save project information
    rootNode.ChildNodes['Project'].Attributes['dateCreated'] := dateCreated;
    rootNode.ChildNodes['Project'].Attributes['dateModified'] := dateModified;

    // Save basic scenario information
    rootNode.ChildNodes['CreatedBy'].Text := createdBy;
    rootNode.ChildNodes['WorkingDir'].Text := wrkdir;
    rootNode.ChildNodes['ScenName'].Text := scenarioName;
    rootNode.ChildNodes['ScenDescription'].Text := scenarioNotes
  finally
    // resave XML file
    S := TStringList.Create;
    S.Assign(XMLDoc.XML);
    S.SaveToFile(xmlFilePath);
    S.Free;
    // XMLDoc := nil;
  end;
  Result := true
end;
// loads the contents of plrm input file and creates object properties

function TPLRM.loadFromXML(xmlFilePath: String): Boolean;
var
  XMLDoc: IXMLDocument;
  rootNode: IXMLNode;
  tempNodeList: IXMLNodeList;
  I, J: Integer;
  tempCatch: TPLRMCatch;
  tempPLRMNode: TPLRMNode;
begin
  try
    XMLDoc := TXMLDocument.Create(nil);
    XMLDoc.loadFromFile(xmlFilePath);
    rootNode := XMLDoc.DocumentElement; // .ChildNodes[0];
    // Load project information

    dateCreated := rootNode.ChildNodes['Project'].Attributes['dateCreated'];
    dateModified := rootNode.ChildNodes['Project'].Attributes['dateModified'];
    curSWMMInptFilePath := rootNode.ChildNodes['GenSWMMInpt'].Text;
    wrkdir := rootNode.ChildNodes['WorkingDir'].Text;
    // ML modified 4/14/09 because wrkdir is now the path to the Scenario folder
    createdBy := rootNode.ChildNodes['CreatedBy'].Text;
    scenarioName := rootNode.ChildNodes['ScenName'].Text;
    scenarioNotes := rootNode.ChildNodes['ScenDescription'].Text;

    // Load catchment information
    catchments.Clear;
    tempNodeList := XMLDoc.DocumentElement.ChildNodes['Catchments'].ChildNodes;
    for I := 0 to tempNodeList.count - 1 do
    begin
      if (tempNodeList[I].NodeName = 'Catchment') then
      begin
        tempCatch := TPLRMCatch.Create;
        PLRMObj.currentCatchment := tempCatch;
        catchments.AddObject(tempNodeList[I].Attributes['name'], tempCatch);
        nodeAndCatchNames.Add(tempNodeList[I].Attributes['name']);
        tempCatch.xmlToCatch(tempNodeList[I]);
      end;
    end;

    // Load nodes information
    nodes.Clear;
    tempNodeList := XMLDoc.DocumentElement.ChildNodes['Nodes'].ChildNodes;
    for I := 0 to tempNodeList.count - 1 do
    begin
      if (tempNodeList[I].NodeName = 'Node') then
      begin
        tempPLRMNode := TPLRMNode.Create;
        PLRMObj.currentNode := tempPLRMNode;
        nodes.AddObject(tempNodeList[I].Attributes['id'], tempPLRMNode);
        tempPLRMNode.xmlToNode(tempNodeList[I]);

        nodeAndCatchNames.Add(tempNodeList[I].Attributes['id']);
        tempPLRMNode.typeIndex := nodesTypeLists[tempPLRMNode.swtType]
          .AddObject(tempPLRMNode.userName, tempPLRMNode);
      end;
    end;
  finally
    // XMLDoc := nil;
  end;
  Result := true
end;

function TPLRM.loadGISCatchmentsFromXML(xmlFilePath: String): Boolean;
var
  XMLDoc: IXMLDocument;
  rootNode: IXMLNode;
  tempNodeList: IXMLNodeList;
  I: Integer;
  tempCatch: TPLRMCatch;
  // tempPLRMNode: TPLRMNode;
begin
  try
    XMLDoc := TXMLDocument.Create(nil);
    XMLDoc.loadFromFile(xmlFilePath);
    rootNode := XMLDoc.DocumentElement;

    catchments.Clear;
    tempNodeList := XMLDoc.DocumentElement.ChildNodes['Catchments'].ChildNodes;
    for I := 0 to tempNodeList.count - 1 do
    begin
      if (tempNodeList[I].NodeName = 'Catchment') then
      begin
        tempCatch := TPLRMCatch.Create;
        // currentCatchment := tempCatch;
        catchments.AddObject(tempNodeList[I].Attributes['name'], tempCatch);
        nodeAndCatchNames.Add(tempNodeList[I].Attributes['name']);
        tempCatch.xmlToCatch(tempNodeList[I]);
      end;
    end;
  finally
    // XMLDoc := nil;
  end;
  Result := true
end;

function TPLRM.loadFromPrjXML(xmlFilePath: String): Boolean;
var
  XMLDoc: IXMLDocument;
  rootNode: IXMLNode;
begin
  try
    XMLDoc := TXMLDocument.Create(nil);
    XMLDoc.loadFromFile(xmlFilePath);
    rootNode := XMLDoc.DocumentElement; // .ChildNodes[0];
    // Load project information only
    dateCreated := rootNode.ChildNodes['Project'].Attributes['dateCreated'];
    dateModified := rootNode.ChildNodes['Project'].Attributes['dateModified'];
    projUserName := rootNode.ChildNodes['ProjectUserName'].Text;
    projXMLPath := rootNode.ChildNodes['ProjectXMLpath'].Text;
    projFolder := rootNode.ChildNodes['ProjectFolderName'].Text;
    dbPath := rootNode.ChildNodes['DatabasePath'].Text;
    eipNum := rootNode.ChildNodes['EipNumber'].Text;
    implAgency := rootNode.ChildNodes['Agency'].Text;
    prjDescription := rootNode.ChildNodes['LocationDescription'].Text;
    metgridNum := StrToInt(rootNode.ChildNodes['MetGridNumber'].Text);
    simTypeID := StrToInt(rootNode.ChildNodes['SimTypeID'].Text);
  finally
    // XMLDoc := nil;
  end;
  Result := true
end;

// Finds catchment and if not already in list adds it
function TPLRM.getCatchIndex(catchID: String): Integer;
var
  position: Integer;
begin
  position := catchments.IndexOf(catchID);
  if position = -1 then
  begin
    ShowMessage('Catchment does not exist');
  end;
  Result := position;
end;

// Finds node and if not already in list adds it
function TPLRM.getNodeIndex(nodeID: String; list: TStringList): Integer;
var
  position: Integer;
  I: Integer;
begin
  position := list.IndexOf(nodeID);
  if position = -1 then
  begin
    for I := 0 to list.count - 1 do
    begin
      if ((list.Objects[I] as TPLRMNode).swmmNode.id = nodeID) then
      begin
        list.AddObject(nodeID, list.Objects[I]);
        list.Delete(I);
        position := I;
        Result := position;
        exit;
      end;
    end;

  end;
  Result := position;
end;

procedure TPLRM.addSubCatch(S: Uproject.TSubCatch; objIndex: Integer);
var
  newCatch: TPLRMCatch;
  position: Integer;
  strErrVal: String;
var
  tempInt: Integer;
begin

  // 2014 additions to support GIS catchment loading
  if (expectingGISCatch = true) then
  begin
    newCatch := currentGISCatch;
    newCatch.Name := currentGISCatch.Name;
    newCatch.isGISCatchment := true;
  end
  else
  begin
    newCatch := TPLRMCatch.Create;
    newCatch.Name := CATCHPREFIX + intToStr(catchments.count + 1);
  end;

  newCatch.swmmCatch := S;
  newCatch.objType := SUBCATCH;
  newCatch.objIndex := objIndex;

  while nodeAndCatchNames.IndexOf(newCatch.Name) <> -1 do
    newCatch.Name := newCatch.Name + intToStr(catchments.count + 1);

  position := catchments.AddObject(newCatch.Name, newCatch);
  newCatch.id := position;
  currentCatchment := catchments.Objects[position] as TPLRMCatch;
  currentCatchment.mySWMMIndex := position;
  // moved to create of TPlrm catch
  updateCurCatchProps(newCatch.Name, newCatch.Name, newCatch.physclProps, nil);
  // use star until outlet node is assigned '*'
  EditorObject := SUBCATCH;
  // lets swmm functions know we are working with catchments
  EditorIndex := newCatch.objIndex;
  tempInt := Project.Lists[SUBCATCH].IndexOf(newCatch.Name);
  if tempInt = -1 then
    Project.Lists[SUBCATCH][objIndex] := newCatch.Name;
  ValidateEditor(0, newCatch.Name, strErrVal);
  nodeAndCatchNames.Add(newCatch.Name);

  // 2014
  if (expectingGISCatch = true) then
  begin
    // to prevent the user from repeatedly adding the same GIS catchment
    // select selector button after drawing catchment
    MainForm.SelectorButtonClick();
  end;
  expectingGISCatch := false;
end;

function TPLRM.deleteObj(objType: Integer; objIndex: Integer): Boolean;
var
  tempInt, I, J, K: Integer;
  tempCatch: TPLRMCatch;
  tempNode: TPLRMNode;
  foundFlag: Boolean;
  foundIndex: Integer;
  tempObj: TObject;
begin
  foundIndex := -1;
  // delete from catchments
  foundFlag := false;
  if assigned(catchments) then
  begin
    I := 0;
    while I < catchments.count do
    begin
      tempCatch := (catchments.Objects[I] as TPLRMCatch);
      if ((foundFlag = false) and (tempCatch.objType = objType) and
        (tempCatch.objIndex = objIndex)) then
      begin
        tempObj := catchments.Objects[I];
        tempInt := nodeAndCatchNames.IndexOf
          ((catchments.Objects[I] as TPLRMCatch).Name);
        if tempInt <> -1 then
          nodeAndCatchNames.Delete(tempInt);
        catchments.Delete(I);
        if assigned(tempObj) then
          FreeAndNil(tempObj);
        foundFlag := true;
        foundIndex := I;
        Break;
      end;
      I := I + 1;
    end;
    // decrement all indexes of that were greater than that of deleted object to fill in for deleted object
    for I := foundIndex to catchments.count - 1 do
      if foundFlag = true then
        (catchments.Objects[I] as TPLRMCatch).objIndex :=
          (catchments.Objects[I] as TPLRMCatch).objIndex - 1;
  end;

  // delete from nodes
  foundFlag := false;
  if assigned(nodes) then
  begin
    I := 0;
    while I < nodes.count do
    begin
      tempNode := (nodes.Objects[I] as TPLRMNode);
      if ((foundFlag = false) and (tempNode.objType = objType) and
        (tempNode.objIndex = objIndex)) then
      begin
        tempInt := nodesTypeLists[tempNode.swtType].IndexOf(tempNode.userName);
        If tempInt <> -1 then
          nodesTypeLists[tempNode.swtType].Delete(tempInt);
        tempInt := nodeAndCatchNames.IndexOf((nodes.Objects[I] as TPLRMNode)
          .userName);
        if tempInt <> -1 then
          nodeAndCatchNames.Delete(tempInt);
        nodes.Delete(I);
        // search all catchments and set all references to the current node to nil
        for K := 0 to catchments.count - 1 do
        begin
          if ((catchments.Objects[K] as TPLRMCatch).outNode = tempNode) then
            (catchments.Objects[K] as TPLRMCatch).outNode := nil;
        end;

        // next, search all nodes and set all references to the current node to nil
        for K := 0 to nodes.count - 1 do
        begin
          if ((nodes.Objects[K] as TPLRMNode).outNode1 = tempNode) then
            (nodes.Objects[K] as TPLRMNode).outNode1 := nil;
          if ((nodes.Objects[K] as TPLRMNode).outNode2 = tempNode) then
            (nodes.Objects[K] as TPLRMNode).outNode2 := nil;
        end;
        if assigned(tempNode) then
          FreeAndNil(tempNode);
        // foundFlag := true;
        // foundIndex := I;
        J := I;
        // now that it is found decrement the indexes of all nodes of the same type that are larger
        while J < nodes.count do
        begin
          tempNode := (nodes.Objects[J] as TPLRMNode);
          if ((tempNode.objType = objType) and (tempNode.objIndex > objIndex))
          then
            (nodes.Objects[J] as TPLRMNode).objIndex :=
              (nodes.Objects[J] as TPLRMNode).objIndex - 1;
          J := J + 1;
        end;
        Break;
      end;
      I := I + 1;
    end;
  end;
  Result := true;
end;

procedure TPLRM.addNode(N: Uproject.TNode; objIndex: Integer);
var
  newNode: TPLRMNode;
  namePrefix: String;
  strErrVal: String;
begin
  newNode := TPLRMNode.Create;
  newNode.swmmNode := N;
  newNode.objType := N.Ntype;
  newNode.objIndex := objIndex;

  // determine swt type uses length of button hint string to figure out
  // what button was pushed
  newNode.isSwt := true;
  case Length(currentToolHint) of
    8:
      newNode.swtType := 3; // WetBasin
    9:
      newNode.swtType := 1; // Dry Basin
    10:
      newNode.swtType := 4; // Bed Filter
    16:
      newNode.swtType := 5; // Cartridge Filter
    15:
      newNode.swtType := 6; // Treatment vault
    18:
      begin
        newNode.swtType := 2; // Infiltration Basin
        newNode.hasEffl := false;
      end;
    19:
      newNode.swtType := 3; // Wetland / Wet basin
  else
    begin
      newNode.isSwt := false;
      newNode.hasEffl := false;
      newNode.swtType := 7; // All others, junctions, outfalls, dividers
    end;
  end;
  case N.Ntype of
    JUNCTION:
      namePrefix := 'Junction';
    OUTFALL:
      namePrefix := 'Outfall';
    DIVIDER:
      namePrefix := 'Divider';
    STORAGE:
      begin
        case newNode.swtType of
          1:
            namePrefix := SWTDETBASIN;
          2:
            namePrefix := SWTINFBASIN;
          3:
            namePrefix := SWTWETBASIN;
          4:
            namePrefix := SWTGRNFILTR;
          5:
            namePrefix := SWTCRTFILTR;
          6:
            namePrefix := SWTTRTVAULT;
        end;
      end;

  end;

  newNode.userName := namePrefix +
    intToStr(nodesTypeLists[newNode.swtType].count + 1);
  while nodeAndCatchNames.IndexOf(newNode.userName) <> -1 do
    newNode.userName := newNode.userName + intToStr(catchments.count + 1);

  newNode.typeIndex := nodesTypeLists[newNode.swtType]
    .AddObject(newNode.userName, newNode);
  newNode.allNodeindex := nodes.AddObject(newNode.userName, newNode);
  EditorObject := newNode.objType;
  // lets swmm functions know we are working with specified node type
  EditorIndex := newNode.objIndex;
  ValidateEditor(0, newNode.userName, strErrVal);
  nodeAndCatchNames.Add(newNode.userName);
end;

function TPLRM.getAllNodes(): TStringList;
var
  I: Integer;
  tempNodeList: TStringList;
begin
  tempNodeList := TStringList.Create;
  for I := 0 to PLRMObj.nodes.count - 1 do
    tempNodeList.AddObject((nodes.Objects[I] as TPLRMNode).userName,
      PLRMObj.nodes.Objects[I]);
  Result := tempNodeList;
end;

function TPLRM.getSWTTypeNodes(swtType: Integer): TStringList;
var
  I: Integer;
  tempNode: TPLRMNode;
  tempNodeList: TStringList;
begin
  tempNodeList := TStringList.Create;
  for I := 0 to PLRMObj.nodes.count - 1 do
  begin
    tempNode := (PLRMObj.nodes.Objects[I] as TPLRMNode);
    if tempNode.swtType = swtType then
      tempNodeList.AddObject(tempNode.userName, tempNode);
  end;
  // tempNode := nil;
  // let calling fxn free tempNodeList := nill;
  getSWTTypeNodes := tempNodeList;
end;

procedure TPLRM.LinkObjsToSWMMObjs();
var
  I: Integer;
  tempNode: TPLRMNode;
  Catch: TPLRMCatch;
  swmmIndex: Integer;
begin
  for I := 0 to nodes.count - 1 do
  begin
    tempNode := (nodes.Objects[I] as TPLRMNode);
    // 2014 added check for nil before use
    if (assigned(Project.Lists[tempNode.objType]) and
      (Project.Lists[tempNode.objType].count > 0)) then
    begin
      tempNode.swmmNode := Project.Lists[tempNode.objType].Objects
        [tempNode.objIndex] as TNode;
      swmmIndex := Project.Lists[CONDUIT].IndexOf(tempNode.dwnLinkID);
      if swmmIndex <> -1 then
        tempNode.dwnLink := Project.GetLink(CONDUIT, swmmIndex);
    end;

    if (tempNode.divertLinkID <> '-1') then
    begin
      swmmIndex := Project.Lists[CONDUIT].IndexOf(tempNode.divertLinkID);
      if swmmIndex <> -1 then
        tempNode.divertLink := Project.GetLink(CONDUIT, swmmIndex);
    end;

  end;
  // Link catchments to nodes
  linkCatchsAndNodesToOtherNodes(catchments, nodes);
  for I := 0 to catchments.count - 1 do
  begin
    Catch := (catchments.Objects[I] as TPLRMCatch);
    // 2014 added check for nil before use
    if (assigned(Project.Lists[Catch.objType]) and
      (Project.Lists[Catch.objType].count > 0)) then
    begin
      Catch.swmmCatch := Project.Lists[Catch.objType].Objects[Catch.objIndex]
        as TSubCatch;
    end;
  end;
end;

function TPLRM.getCurCatchLuseProp(strLuse: string; colNum: Integer;
  var status: Boolean): Double;
var
  tempInt: Integer;
begin
  tempInt := currentCatchment.landUseNames.IndexOf(strLuse);
  if (tempInt > -1) then
  begin
    Result := StrToFloat(currentCatchment.landUseData[tempInt][colNum]);
    status := true;
  end
  else
  begin
    Result := 0;
    status := false;
  end;
end;

procedure TPLRM.updateCurCatchProps(oldName: String; newName: String;
  physclProps: PLRMGridData; outGSNode: TPLRMNode);
// always use PLRMObj version so that PLRMObj catchment list is updated
var
  tempInt: Integer;
begin
  tempInt := catchments.IndexOf(oldName);
  catchments[tempInt] := newName;
  (catchments.Objects[tempInt] as TPLRMCatch).updateCurCatchProps(newName,
    physclProps, outGSNode);
end;

procedure FreeStringListObjects(const strings: TStrings);
var
  S: Integer;
  o: TObject;
begin
  for S := 0 to Pred(strings.count) do
  begin
    o := strings.Objects[S];
    FreeAndNil(o);
  end;
end;

procedure TPLRM.launchPropEditForm(objType: Integer; objIndex: Integer);
// ----------------------
// Object category codes  from Uproject.pas
// ----------------------
// NOTES        = 0; OPTION       = 1; RAINGAGE     = 2;  SUBCATCH     = 3;  JUNCTION     = 4;
// OUTFALL      = 5; DIVIDER      = 6; STORAGE      = 7;  CONDUIT      = 8;  PUMP         = 9;
// ORIFICE      = 10;WEIR         = 11; OUTLET       = 12;MAPLABEL     = 13;
var
  catchID: String;
begin
  // line below needed to change current node to one clicked on the map
  if (objType >= 4) AND (objType <= 7) then // Only nodes
  begin
    currentNode := nodes.Objects
      [nodes.IndexOf(Project.getNode(objType, objIndex).id)] as TPLRMNode;
  end;
  case objType of
    SUBCATCH:
      begin
        catchID := (catchments.Objects[objIndex] as TPLRMCatch).Name;
        getCatchProps(catchID);
        catchID := (catchments.Objects[objIndex] as TPLRMCatch).Name;
        // name can change so read back in
        currentCatchment := catchments.Objects[catchments.IndexOf(catchID)
          ] as TPLRMCatch;
      end;
    JUNCTION:
      begin
        currentNode := nodes.Objects
          [nodes.IndexOf((Project.Lists[JUNCTION].Objects[objIndex] as TNode)
          .id)] as TPLRMNode;
        getSWTProps(currentNode.userName, currentNode.swtType);
      end;
    OUTFALL:
      begin
        currentNode := nodes.Objects
          [nodes.IndexOf((Project.Lists[OUTFALL].Objects[objIndex] as TNode).id)
          ] as TPLRMNode;
        getSWTProps(currentNode.userName, currentNode.swtType);

      end;
    DIVIDER:
      begin
        currentNode := nodes.Objects
          [nodes.IndexOf((Project.Lists[DIVIDER].Objects[objIndex] as TNode).id)
          ] as TPLRMNode;
        getSWTProps(currentNode.userName, currentNode.swtType);
      end;
    STORAGE:
      begin
        getSWTProps(currentNode.userName, currentNode.swtType);
      end;
  end;
end;

procedure TPLRM.linkCatchsAndNodesToOtherNodes(catchs: TStringList;
  nodes: TStringList);
var
  I, J: Integer;
  tempNode: TPLRMNode;
  TempNode1: TPLRMNode;
  tempCatch: TPLRMCatch;
begin

  // Link catchments to their downstream nodes
  for I := 0 to catchs.count - 1 do
  begin
    tempCatch := (catchs.Objects[I] as TPLRMCatch);
    for J := 0 to nodes.count - 1 do
    begin
      tempNode := nodes.Objects[J] as TPLRMNode;
      if tempNode.userName = tempCatch.tempOutNodeID then
        tempCatch.outNode := tempNode;
    end;
  end;

  // Link nodes to their downstream nodes
  for I := 0 to nodes.count - 1 do
  begin
    tempNode := (nodes.Objects[I] as TPLRMNode);
    for J := 0 to nodes.count - 1 do
    begin
      TempNode1 := nodes.Objects[J] as TPLRMNode;
      if tempNode.tempOutNode1ID = TempNode1.userName then
        tempNode.outNode1 := TempNode1;
      if tempNode.tempOutNode2ID = TempNode1.userName then
        tempNode.outNode2 := TempNode1;
    end;
  end;
end;
{$ENDREGION}

end.
