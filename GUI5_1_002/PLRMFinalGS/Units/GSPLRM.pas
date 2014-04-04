unit GSPLRM;

interface
uses
 SysUtils, Windows, Messages, Classes, Controls, Forms, Dialogs, XMLIntf, msxmldom, XMLDoc,
  StdCtrls, ComCtrls, Grids, GSUtils, GSTypes, Uproject, GSCatchments, GSNodes;

 const MAXNODETYPES = 9;
 const MAXSWMMDEFBLKS = 5;
 const CATCHPREFIX = 'Catch';

 type TPLRM = Class
  id:String;
  typeIndex:Integer;
  gageID:String;
  gageFilePath:String;
  temptrFilePath:String;

  widthFactor:Double; //multiplied by area in width calculation
  widthPower:Double; //exponent of area is width calculation
  maxFloLength:Double; //max width is area calculation

  public
    runType:Integer;
    simTypeID:Integer;
    projUserName:string;
    projFolder:string;
    hasActvScn:Boolean;
    RunStatusStopped:Integer;

    //file paths
    projXMLPath:String;
    scenarioXMLFilePath:String;
    curSWMMInptFilePath:String;
    userSWMMInptFilePath:String;
    userSWMMRptFilePath:String;
    dbPath: string;
    wrkdir: string;

    dateCreated:String;
    dateModified:String;

    eipNum: string;
    implAgency:string;
    createdBy:string;
    metgridNum: integer;
    prjDescription:String;
    scenarioName:String;
    scenarioNotes:String;
    currentToolHint:string;
    catchments : TStringList;
    currentCatchment : TPLRMCatch;
    projectLandUseCodes :TStringList;
    projectLandUseNames:TStringList;

    nodeAndCatchNames:TStringList; //stores names of all objs used to check for duplicate names
    //Node variables
    nodes : TStringList;
    currentNode : TPLRMNode;
    nodesTypeLists : array[1..MAXNODETYPES] of TStringList;
    nodesTypeIndexes : array[1..MAXNODETYPES] of Integer;
    globalSchmID:Integer;

    curRdCondsPropsSchmID : Integer;
    curRdCondsScheme :TPLRMRdCondsScheme;
    rdCondsSchemes: TStringList;
    curhydPropsSchmID:Integer;
    curHydPropsScheme :TPLRMHydPropsScheme;

    hydPropsSchemes: TStringList;
    hydPropsRdInfSchemes: TStringList;  // temporarily saves PLRM5RoadDrxnXtcs Form combo box schemes
    hydPropsRdDspSchemes: TStringList; // temporarily saves PLRM5RoadDrxnXtcs Form combo box schemes
    hydPropsRdOutSchemes: TStringList; // temporarily saves PLRM5RoadDrxnXtcs Form combo box schemes
    hydPropsPcInfSchemes: TStringList;// temporarily saves PLRM5RoadDrxnXtcs Form combo box schemes
    hydPropsPcOutSchemes: TStringList;// temporarily saves PLRM5RoadDrxnXtcs Form combo box schemes

    ObjCatSecondaryFlag:Integer; // used to distinguish between different jucntion types introduced by PLRM
    inputFileXMLNode :IXMLNode;

    swmmDefaultBlocks : array[0..MAXSWMMDEFBLKS] of TStringList;
    swmmDefaultBlockXML : array[0..MAXSWMMDEFBLKS] of IXMLNode;
    grndWaterBlockXML :IXMLNode;

    constructor Create();
    Destructor  Destroy; override;
    function deleteObj(objType:Integer; objIndex:Integer):Boolean;
    procedure addSubCatch(S:Uproject.TSubCatch; ObjIndex:Integer);
    procedure updateCurCatchProps(oldName:String; newName:String; physclProps:PLRMGridData; outGSNode :TPLRMNode);
    procedure LinkObjsToSWMMObjs();
    procedure linkCatchsAndNodesToOtherNodes(catchs:TStringList; nodes:TStringList);
    procedure addNode(N:Uproject.TNode; ObjIndex:Integer);
    function loadFromXML(xmlFilePath:String):Boolean;
    function loadFromPrjXML(xmlFilePath:String):Boolean;
    procedure loadHydPropsSchemeFromDb(schmExt:String; soilsInfData:PLRMGridData);
    procedure loadHydPropsSchemeFromXML(iNode:IXMLNode);overload;
    procedure loadRdCondsSchemeFromXML(filePath:String);overload;
    procedure loadRdCondsSchemeFromXML(iNode:IXMLNode);overload;
    procedure getHydSchemes(var Schm:TPLRMHydPropsScheme; sType:Integer; ext:String; parcelOrRoad:String; luse:String);
    procedure launchPropEditForm(ObjType:Integer; ObjIndex:Integer);
    function getCurCatchLuseProp(strLuse:string; colNum:Integer; var status:Boolean):Double;
    function getCatchIndex(catchID:String):Integer;
    function getNodeIndex(nodeID:String; list:TStringList):Integer;
    function getAllNodes(): TStringList;
    function getSWTTypeNodes(swtType: Integer) : TStringList;
    function writeInitProjectToXML(filePath:String; scnName:String = ''):Boolean;
    function plrmToXML():Boolean;
    function updateScenarioXML(xmlFilePath:String):Boolean;
    function run():Boolean;
    function chkNodesAndCatchs():Boolean;
  end;

 //memory management
 procedure FreeStringListObjects(const strings: TStrings);
 var
  PLRMObj :TPLRM;
  swmmDefaultBlockXMLTags : array[0..MAXSWMMDEFBLKS] of String = ('Options','Evaporation','Temperature','Aquifers','GroundWater','SnowPacks');
 implementation

 uses
   _PLRMD3CatchProps, _PLRM7SWTs, Fmain,Uimport,Uglobals, GSIO, Uvalidate;

 {$REGION 'PLRM class methods'}
constructor TPLRM.Create();
var
  I: Integer;
  tempList:TStringList;
  tempListGW:TStringList;
  tempListGW2:TStringList;
  SearchRec  : TSearchRec;
  widthCalcFactors:dbReturnFields;
begin
  //PLRM Edit Jan 2010 edit added to track whether user working with scenario see #233
  hasActvScn := false;
   //Many of these are just temporary because this gets created at start up
    metgridNum := 1; //TO DO use appropriate default or none
    gageID := '1';
    runType := 0;
    simTypeID := 2; //default is short simulation
    curhydPropsSchmID := -1;
    curRdCondsPropsSchmID := -1;
    globalSchmID := -1;
    catchments := TStringlist.Create;
    hydPropsSchemes := TStringList.Create;
    rdCondsSchemes:= TStringList.Create;
    nodeAndCatchNames := TStringList.Create;
    createdBy := 'unknown';

    //Store list of landuses for later use
    projectLandUseCodes := TStringList.Create;
    projectLandUseCodes := getCodes('1%',2);
    projectLandUseNames := TStringList.Create;
    projectLandUseNames := getCodes('1%',1);

    //instantiate lists for storing hydrologic propert scheme combox items
    if hydPropsPcOutSchemes = nil then hydPropsPcOutSchemes := TStringList.Create();
    if hydPropsPcInfSchemes = nil then hydPropsPcInfSchemes := TStringList.Create();

    if hydPropsRdOutSchemes = nil then hydPropsRdOutSchemes := TStringList.Create();
    if hydPropsRdInfSchemes = nil then hydPropsRdInfSchemes := TStringList.Create();
    if hydPropsRdDspSchemes = nil then hydPropsRdDspSchemes := TStringList.Create();

    //Initialize nodes
    nodes := TStringlist.Create;
    for I := 1 to MAXNODETYPES do
      nodesTypeLists[I] := TStringList.Create;

    if runType = 0 then //it is new scenario not opened from an input file
    //read in groundwater table formated as xml
    tempListGW := TStringList.Create();
    for I := 0 to High(grnWaterXMLTags) do
       tempListGW.Add(grnWaterXMLTags[I]);

    tempListGW2 := TStringList.Create();
    tempListGW2.Add('GW'); //arbitrary for naming purposes only
    grndWaterBlockXML := plrmGridDataToXML2('GroundWater',getDBDataAsPLRMGridData('GroundWater'),tempListGW,tempListGW2,tempListGW2)[0];
    swmmDefaults := TStringList.Create();
    tempList := TStringList.Create();
    swmmDefaults := getSWMMDefaults('"6%"', tempList,swmmDefaults);

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

    //set default main xsl path to the path of any .xsl file in the /Engine folder
    if (FindFirst(defaultEngnDir + '\*.xsl', faAnyFile, SearchRec) = 0) then
    begin
      defaultXslPath := defaultEngnDir + '\' + SearchRec.Name;
      SysUtils.FindClose(SearchRec) ;
    end;


    //set default validation xsl path to the path of any .xsl file in the /Engine folder
    if (FindFirst(defaultValidateDir + '\*.xsl', faAnyFile, SearchRec) = 0) then
    begin
      validateXslPath := defaultValidateDir + '\' + SearchRec.Name;
      SysUtils.FindClose(SearchRec) ;
    end;

    projFolder := defaultPrjDir;
    wrkdir := defaultPrjDir;
    dbPath := defaultDBPath;
    eipNum := '0000';
    implAgency :='unknown';
    createdBy := 'unknown user';
    prjDescription := 'Please provide an optional project and/or scenario description';
    scenarioName := defaultScnName;
    scenarioNotes :='Provide optional scenario notes';
    FreeAndNil(tempList);
    FreeAndNil(tempListGW);
    FreeAndNil(tempListGW2);
end;

// TWords destructor - release storage
destructor TPLRM.Destroy;
var
  I:Integer;
begin

  // Release memory, if obtained
  FreeAndNil(nodeAndCatchNames); //simple Stringlist has only strings
  FreeStringListObjects(catchments);
  FreeStringListObjects(nodes);
  FreeStringListObjects(rdCondsSchemes);
  FreeStringListObjects(projectLandUseCodes);
  FreeStringListObjects(projectLandUseNames);

  GSCatchments.freeListofHydpropSchemes(hydPropsSchemes);
  GSCatchments.freeListofHydpropSchemes(hydPropsRdInfSchemes);
  GSCatchments.freeListofHydpropSchemes(hydPropsRdDspSchemes);
  GSCatchments.freeListofHydpropSchemes(hydPropsRdOutSchemes);
  GSCatchments.freeListofHydpropSchemes(hydPropsPcInfSchemes);
  GSCatchments.freeListofHydpropSchemes(hydPropsPcOutSchemes);

  if assigned(currentCatchment) then currentCatchment := nil; //memory already freed when freeing list of catchments
  if assigned(currentNode) then currentNode := nil; //memory already freed when freeing list of nodes
  if assigned(curRdCondsScheme) then curRdCondsScheme := nil; //memory already freed when freeing list of rdcondschemes
  if assigned(curHydPropsScheme) then curHydPropsScheme := nil; //memory already freed when freeing list of hydpropschemes

  inputFileXMLNode := nil;
  for I := 0 to MAXNODETYPES do
    FreeAndNil(nodesTypeLists[I]);

  for I := 0 to MAXSWMMDEFBLKS do
  begin
    FreeAndNil(swmmDefaultBlocks[I]);
    swmmDefaultBlockXML[I] := nil;
  end;
  inherited;
end;

function TPLRM.run():Boolean;
  var
    sender:TObject;
    flag:Boolean;
    I:Integer;
    Catch:TPLRMCatch;
    Node:TPLRMNode;
  begin

  //do not try to run if no objects have been created
  if assigned(catchments) and assigned(nodes) then
  begin
    if ((catchments.count = 0) or (nodes.count = 0 ))then
    begin
      ShowMessage('Please add catchment and node objects to the canvas before running the simulation');
      Result := false;
      exit;
    end
    else
    for I:= 0 to catchments.Count - 1 do
    begin
      Catch := catchments.Objects[I] as TPLRMCatch;
       if not(assigned(Catch.outNode)) then
       begin
          ShowMessage('Catchment: [' + Catch.name + '] is not connected to any node');
          ShowMessage('This scenario has been save and can be re-opened from the Project Manager');
          Result := false;
          Exit;
       end;
    end;
    for I:= 0 to nodes.Count - 1 do
    begin
      Node := nodes.Objects[I] as TPLRMNode;
       if ((Node.ObjType <> 5) and (not(assigned(Node.outNode1)))) then
       begin
          ShowMessage('Node: [' + Node.userName + '] is not connected to any node');
          ShowMessage('This scenario has been save and can be re-opened from the Project Manager');
          Result := false;
          Exit;
       end;
    end;
  end;

   Try
    //Step 1 - formulate xml and save all info to swmm with running throug objects
    flag := PLRMObj.plrmToXMl();
    if flag = false then
    begin
      ShowMessage('An error occured while trying to save the input file');
      Result := false;
      Exit;
    end;

    //Step 2 - transform main xml file into validation file and display it
    transformXMLToSwmm(validateXslPath,scenarioXMLFilePath,defaultValidateFilePath);
    //Display result validation html file in browser
    BrowseURL(defaultValidateFilePath);
    //Step 2 - transform main xml file into swmm file
    transformXMLToSwmm(defaultXslPath,scenarioXMLFilePath,curSWMMInptFilePath);
    //Step 3 - open temporarily generated PLRM swmm input file
    MainForm.OpenFile(sender,curSWMMInptFilePath);
    currentRptFilePath :=  userSWMMRptFilePath; //used in Fmain to copy tempfile to scenario directory

    //run outside this routine in fmain
   Except
    on E : Exception do
    begin
     ShowMessage('An Error occured, Exception message = '+E.Message);
     Result := false;
    end;
   end;
   Result := true;
  end;

  function TPLRM.chkNodesAndCatchs():Boolean;
  var
    sender:TObject;
    flag:Boolean;
    I:Integer;
    Catch:TPLRMCatch;
    Node:TPLRMNode;
  begin

  //do not try to run if no objects have been created
  if assigned(catchments) and assigned(nodes) then
  begin
    if ((catchments.count = 0) or (nodes.count = 0 ))then
    begin
      ShowMessage('Please add catchment and node objects to the canvas before saving or running the simulation');
      Result := false;
      exit;
    end
    else
    for I:= 0 to catchments.Count - 1 do
    begin
      Catch := catchments.Objects[I] as TPLRMCatch;
       if not(assigned(Catch.outNode)) then
       begin
          ShowMessage('Catchment: [' + Catch.name + '] is not connected to any node');
          ShowMessage('This scenario has been save and can be re-opened from the Project Manager');
          Result := false;
          Exit;
       end;
    end;
    for I:= 0 to nodes.Count - 1 do
    begin
      Node := nodes.Objects[I] as TPLRMNode;
       if ((Node.ObjType <> 5) and (not(assigned(Node.outNode1)))) then
       begin
          ShowMessage('Node: [' + Node.userName + '] is not connected to any node');
          ShowMessage('This scenario has been save and can be re-opened from the Project Manager');
          Result := false;
          Exit;
       end;
    end;
  end;
  end;

function TPLRM.plrmToXML():Boolean;
  var
   xmlDoc : IXMLDocument;
   iNode : IXMLNode;
   tempNodeArry: array of IXMLNode;
   tempNodeArry2: array of IXMLNode;
   tempNodeArry3: array of IXMLNode;
   tempNodeArry4: array of IXMLNode;
   tempNodeArry5: array of IXMLNode;
   tempNode3: IXMLNode;
   tempNode4: IXMLNode;
   tempNode4b: IXMLNode;
   tempNode6: IXMLNode;
   tempNode7: IXMLNode;
   tempNode8: IXMLNode;
   tempNode9: IXMLNode;
   tempNode10: IXMLNode;
   tempNode19b: IXMLNode;
   catchmentValidationXMLNode :IXMLNode;
   nodeValidationXMLNode :IXMLNode;
   I :Integer;
  begin
    Result := false;

    //Step 1 - first make swmm save user inp file as swmm.inp
    makeSWMMSaveInpFile(userSWMMInptFilePath, userSWMMRptFilePath);
    Try
      //TO DO - get raingage id from DB

      gageFilePath := defaultDataDir + '\' + intToStr(metgridNum) + '_Precip.dat';
      tempNode3 := swmmInptFileRainGageToXML(PLRMObj.gageID,gageFilePath);

      for I := 0 to High(swmmDefaultBlocks) do
        swmmDefaultBlocks[I] := getSwmmDefaultBlocks(I,intToStr(simTypeID));

      tempNode6 := swmmDefaultsToXML(swmmDefaults,maxFloLength,widthPower,widthFactor,'SWMMDefaults'); //Imperv N, pervN, etc
      tempNode7 := swmmInptFileLossesToXML();
      tempNode8 := swmmInptFileLoadingsToXML();
      tempNode9 := swmmInptFileBuildUpToXML();
      tempNode10 := swmmInptFileWashOffToXML();
      tempNode19b := swmmInptFileLandUseToXML();

      //5.Prep catchments
      SetLength(tempNodeArry,catchments.Count);
      for I := 0 to catchments.Count - 1 do
      begin
        tempNodeArry[I] := (catchments.Objects[I] as TPLRMCatch).catchToXML(projectLandUseNames,projectLandUseCodes);
      end;

      SetLength(tempNodeArry2,nodes.Count);
      for I := 0 to nodes.Count - 1 do
      begin
        tempNodeArry2[I] := (nodes.Objects[I] as TPLRMNode).nodeToXML;
      end;

      SetLength(tempNodeArry3,4);
      temptrFilePath :=  defaultDataDir + '\' + intToStr(metgridNum) + '_Temp.dat';
      tempNodeArry3[0] := swmmInptFileTempTimeSeriesToXML('TempTSeries', temptrFilePath);
      tempNodeArry3[1] := swmmInptFileReportToXML();
      tempNodeArry3[2] := swmmInptFileTagsToXML();
      tempNodeArry3[3] := swmmInptFileMapToXML();

      //Write Road Condition Schemes
      SetLength(tempNodeArry4,rdCondsSchemes.Count);
      for I := 0 to rdCondsSchemes.Count - 1 do
        tempNodeArry4[I] := ((rdCondsSchemes.Objects[I] as TPLRMRdCondsScheme).writeSchemeXML()).ChildNodes['Schemes'].ChildNodes['Scheme'];

      //Write Hydprop Condition Schemes
      SetLength(tempNodeArry5,hydPropsSchemes.Count);
      for I := 0 to hydPropsSchemes.Count - 1 do
        tempNodeArry5[I] := ((hydPropsSchemes.Objects[I] as TPLRMHydPropsScheme).writeSchemeXML()).ChildNodes['Schemes'].ChildNodes['Scheme'];;

      xmlDoc := TXMLDocument.Create(nil) ;
      xmlDoc.Active := true;
      iNode := xmlDoc.AddChild('PLRM');
      iNode.AddChild('Project');
      //Add project meta data
      iNode.ChildNodes['Project'].Attributes['dateCreated'] :=  dateCreated;
      iNode.ChildNodes['Project'].Attributes['dateModified'] :=  DateTimeToStr(Now);
      iNode.ChildNodes['Project'].Attributes['name'] :=  projUserName;
      iNode.ChildNodes['Metgrid'].Text :=  intToStr(metgridNum);
      iNode.ChildNodes['UserSWMMInpt'].Text :=  userSWMMInptFilePath;
      iNode.ChildNodes['GenSWMMInpt'].Text :=  curSWMMInptFilePath;
      iNode.ChildNodes['WorkingDir'].Text :=  wrkdir;
      iNode.ChildNodes['CreatedBy'].Text := createdBy;
      iNode.ChildNodes['LocationDescription'].Text := prjDescription;
      iNode.ChildNodes['ScenName'].Text :=  scenarioName;
      iNode.ChildNodes['ScenDescription'].Text :=  scenarioNotes;

      //1,2,3,6,7,8. Write options, evap, temperature, aquifers, groundH2O, snowpacks
      for I := 0 to High(swmmDefaultBlocks) do
        swmmBlockLinesToXML(swmmDefaultBlocks[I], swmmDefaultBlockXMLTags[I], iNode);
      //add ground water
      iNode.ChildNodes.Add(grndWaterBlockXML);

     //4.Add raingages
     iNode.ChildNodes.Add(tempNode3);

      //Write PLRM Swmm default constants
      xmlDoc.Resync;
      xmlDoc.ChildNodes[0].ChildNodes.Add(tempNode6);

      //5.Add catchments
      xmlDoc.ChildNodes[0].AddChild('Catchments');
      xmlDoc.Resync;
      for I := 0 to catchments.Count - 1 do
      begin
        if(assigned(tempNodeArry[I])) then xmlDoc.ChildNodes[0].ChildNodes['Catchments'].ChildNodes.Add(tempNodeArry[I]);
      end;
      xmlDoc.Resync;

      //9,10,11,12 Add nodes
      xmlDoc.ChildNodes[0].AddChild('Nodes');
      xmlDoc.Resync;
      for I := 0 to nodes.Count - 1 do
      begin
       if(assigned(tempNodeArry2[I])) then xmlDoc.ChildNodes[0].ChildNodes['Nodes'].ChildNodes.Add(tempNodeArry2[I]);
      end;
      xmlDoc.Resync;

      //17. Write losses
      xmlDoc.ChildNodes[0].ChildNodes.Add(tempNode7);

      //18.Write Pollutants
      xmlDoc.ChildNodes[0].ChildNodes.Add(swmmInptFilePollutantsToXML);

      //19.Add project land uses
      tempNode4 := xmlDoc.ChildNodes[0].AddChild('LandUses');
      for I := 0 to projectLandUseCodes.Count - 1 do
      begin
        tempNode4b := tempNode4.AddChild( 'LandUse');
        tempNode4b.Text := projectLandUseCodes[I];
      end;

       //19b add parcel only land uses
       xmlDoc.ChildNodes[0].ChildNodes.Add(tempNode19b);

      //20.Write coverages
      //Transformed from Catchments xml

      //21. Write loadings
      xmlDoc.ChildNodes[0].ChildNodes.Add(tempNode8);
      //22. Write buildup
      xmlDoc.ChildNodes[0].ChildNodes.Add(tempNode9);
      //23. Write washoff
      xmlDoc.ChildNodes[0].ChildNodes.Add(tempNode10);
      //24. Write treatment
      //25. Write curves
      //26. Write timeseries
      xmlDoc.ChildNodes[0].ChildNodes.Add(tempNodeArry3[0]);
      //27. Write report
      xmlDoc.ChildNodes[0].ChildNodes.Add(tempNodeArry3[1]);
      //28. Write tags
      xmlDoc.ChildNodes[0].ChildNodes.Add(tempNodeArry3[2]);
      //29. Write map
      xmlDoc.ChildNodes[0].ChildNodes.Add(tempNodeArry3[3]);

      //30. Write Schemes
      if (rdCondsSchemes.Count + hydPropsSchemes.Count) > 0 then
      begin
        xmlDoc.ChildNodes[0].AddChild('Schemes');
        xmlDoc.Resync;
      //Write Road Condition Schemes
        for I := 0 to rdCondsSchemes.Count - 1 do
          xmlDoc.ChildNodes[0].ChildNodes['Schemes'].ChildNodes.Add(tempNodeArry4[I]);
        //Write Hydro Properties Condition Schemes
        for I := 0 to hydPropsSchemes.Count - 1 do
          xmlDoc.ChildNodes[0].ChildNodes['Schemes'].ChildNodes.Add(tempNodeArry5[I]);
      end;

      //31. Write Catchment and Node validation rules
      //create catchment and node validation xmlNodes
      catchmentValidationXMLNode := catchmentValidationTblToXML();
      nodeValidationXMLNode := nodeValidationTblToXML();
      xmlDoc.ChildNodes[0].ChildNodes.Add(catchmentValidationXMLNode);
      xmlDoc.ChildNodes[0].ChildNodes.Add(nodeValidationXMLNode);

      if (curSWMMInptFilePath ='') then
      curSWMMInptFilePath := defaultGenSWmmInpPath;
      saveXmlDoc2(scenarioXMLFilePath, xmlDoc);
      Result := true;
  except
    on E : Exception do
    begin
      Result := false;
     ShowMessage('An Error occured, Exception message = ' + E.Message);
    end;
   end;
end;

function TPLRM.writeInitProjectToXML(filePath:String; scnName:String = ''):Boolean;
  var
   xmlDoc : IXMLDocument;
   iNode : IXMLNode;
  begin
    Result := false;
    Try

      xmlDoc := TXMLDocument.Create(nil) ;
      xmlDoc.Active := true;
      iNode := xmlDoc.AddChild('PLRM','');

      //Add project meta data
      iNode.ChildNodes['Project'].Attributes['dateCreated'] :=  dateCreated;
      iNode.ChildNodes['Project'].Attributes['dateModified'] :=  DateTimeToStr(Now);
      iNode.ChildNodes['ProjectUserName'].Text := projUserName;
      iNode.ChildNodes['ProjectXMLpath'].Text := projXMLPath;
      iNode.ChildNodes['ProjectFolderName'].Text := projFolder;
      iNode.ChildNodes['DatabasePath'].Text :=  dbPath;
      iNode.ChildNodes['EipNumber'].Text := eipNum;
      iNode.ChildNodes['Agency'].Text :=  implAgency;
      iNode.ChildNodes['CreatedBy'].Text := createdBy;
      iNode.ChildNodes['LocationDescription'].Text := prjDescription;
      iNode.ChildNodes['MetGridNumber'].Text :=  IntToStr(metgridNum);
      iNode.ChildNodes['SimTypeID'].Text := IntToStr(simTypeID);

      if scnName <> '' then iNode.ChildNodes['ScenName'].Text :=  scnName;

      if (filePath ='') then
        filePath := defaultPrjDir;
      saveXmlDoc(filePath, xmlDoc,defaultXMLDeclrtn, defaultXslPath);
      xmlDoc := nil;
      Result := true;
  Except
    on E : Exception do
    begin
      Result := false;
     ShowMessage('An Error occured, Exception message = ' + E.Message);
    end;
   end;
end;

function TPLRM.updateScenarioXML(xmlFilePath:String):Boolean;
//This function updates the Scenario XML file with information collected in the scenario editor
var
  xmlDoc :IXMLDocument;
  rootNode : IXMLNode;
  s:TStringList;
begin
    try
      xmlDoc := TXMLDocument.Create(nil);
      xmlDoc.loadFromFile(xmlFilePath);
      rootNode := xmlDoc.DocumentElement;//.ChildNodes[0];
      //Save project information
      rootNode.ChildNodes['Project'].Attributes['dateCreated'] :=dateCreated;
      rootNode.ChildNodes['Project'].Attributes['dateModified'] :=dateModified;

      //Save basic scenario information
      rootNode.ChildNodes['CreatedBy'].Text := createdBy;
      rootNode.ChildNodes['WorkingDir'].Text :=  wrkdir;
      rootNode.ChildNodes['ScenName'].Text := scenarioName;
      rootNode.ChildNodes['ScenDescription'].Text :=  scenarioNotes
    finally
      //resave XML file
      s := TStringList.Create;
      s.Assign(XMLDoc.XML);
      s.SaveToFile(xmlFilePath);
      s.Free;
    end;
  Result := true
end;
  //loads the contents of plrm input file and creates object properties

function TPLRM.loadFromXML(xmlFilePath:String):Boolean;
var
  xmlDoc :IXMLDocument;
  rootNode : IXMLNode;
  tempNodeList:IXMLNodeList;
  I,J: Integer;
  tempCatch:TPLRMCatch;
  tempPLRMNode:TPLRMNode;
begin
    try
      xmlDoc := TXMLDocument.Create(nil);
      xmlDoc.loadFromFile(xmlFilePath);
      rootNode := xmlDoc.DocumentElement;//.ChildNodes[0];
      //Load project information

      dateCreated := rootNode.ChildNodes['Project'].Attributes['dateCreated'];
      dateModified := rootNode.ChildNodes['Project'].Attributes['dateModified'];
      curSWMMInptFilePath :=rootNode.ChildNodes['GenSWMMInpt'].Text;
      wrkdir := rootNode.ChildNodes['WorkingDir'].Text; //ML modified 4/14/09 because wrkdir is now the path to the Scenario folder
      createdBy := rootNode.ChildNodes['CreatedBy'].Text;
      scenarioName := rootNode.ChildNodes['ScenName'].Text;
      scenarioNotes := rootNode.ChildNodes['ScenDescription'].Text;

      //Load rdconds scheme information
      rdCondsSchemes.Clear;
      hydPropsSchemes.Clear;
      tempNodeList := rootNode.ChildNodes['Schemes'].ChildNodes;
      for I := 0 to tempNodeList.Count - 1 do
      begin
        if ((tempNodeList[I].Attributes['stype'] = '3') or (tempNodeList[I].Attributes['stype'] = '4')) then
          loadRdCondsSchemeFromXML(tempNodeList[I])
        else
          loadHydPropsSchemeFromXML(tempNodeList[I])
      end;

      //Load catchment information
      catchments.Clear;
      tempNodeList := xmlDoc.DocumentElement.ChildNodes['Catchments'].ChildNodes;
      for I := 0 to tempNodeList.Count - 1 do
      begin
          if (tempNodeList[I].NodeName ='Catchment') then
          begin
            tempCatch := TPLRMCatch.Create;
            PLRMObj.currentCatchment := tempCatch;
            catchments.AddObject(tempNodeList[I].Attributes['name'], tempCatch);
            nodeAndCatchNames.Add(tempNodeList[I].Attributes['name']);
            tempCatch.xmlToCatch(tempNodeList[I],hydPropsSchemes,rdCondsSchemes);

            //link catchment to its schemes
            for J := 0 to High(tempCatch.primRdSchms)do
              getHydSchemes(tempCatch.primRdSchms[J], J,HYDSCHMEXTS[J], 'Roads', 'Prr');
            for J := 0 to High(tempCatch.secRdSchms)do
              getHydSchemes(tempCatch.secRdSchms[J], J,HYDSCHMEXTS[J], 'Roads', 'Ser');
            for J := 0 to High(tempCatch.sfrSchms)-1 do
              getHydSchemes(tempCatch.sfrSchms[J], J,HYDSCHMEXTS[J+3], 'Parcels', 'Sfr');
            for J := 0 to High(tempCatch.mfrSchms)-1 do
              getHydSchemes(tempCatch.mfrSchms[J], J,HYDSCHMEXTS[J+3], 'Parcels', 'Mfr');//if tempCatch.mfrSchms[J] <> nil then getHydSchemes(tempCatch.mfrSchms[J], J,HYDSCHMEXTS[J+3], 'Parcels', 'Mfr');
            for J := 0 to High(tempCatch.cicuSchms)-1 do
              getHydSchemes(tempCatch.cicuSchms[J], J,HYDSCHMEXTS[J+3], 'Parcels', 'Cic');
              getHydSchemes(tempCatch.vegTSchms[0], 0,HYDSCHMEXTS[3], 'Parcels', 'Vgt');
              getHydSchemes(tempCatch.othrSchms[0], 0,HYDSCHMEXTS[3], 'Parcels', 'Othr');
          end;
      end;

      //Load nodes information
      nodes.Clear;
      tempNodeList := xmlDoc.DocumentElement.ChildNodes['Nodes'].ChildNodes;
      for I := 0 to tempNodeList.Count - 1 do
      begin
        if (tempNodeList[I].NodeName ='Node') then
        begin
          tempPLRMNode := TPLRMNode.Create;
          PLRMObj.currentNode := tempPLRMNode;
          nodes.AddObject(tempNodeList[I].Attributes['id'], tempPLRMNode);
          tempPLRMNode.xmlToNode(tempNodeList[I]);

          nodeAndCatchNames.Add(tempNodeList[I].Attributes['id']);
          tempPLRMNode.typeIndex := nodesTypeLists[tempPLRMNode.SWTType].AddObject(tempPLRMNode.userName, tempPLRMNode);
        end;
      end;
    finally
      XMLDoc := nil;
    end;
  Result := true
end;

function TPLRM.loadFromPrjXML(xmlFilePath:String):Boolean;
var
  xmlDoc :IXMLDocument;
  rootNode : IXMLNode;
begin
    try
      xmlDoc := TXMLDocument.Create(nil);
      xmlDoc.loadFromFile(xmlFilePath);
      rootNode := xmlDoc.DocumentElement;//.ChildNodes[0];
      //Load project information only
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
      simTypeID :=  StrToInt(rootNode.ChildNodes['SimTypeID'].Text);
    finally
      XMLDoc := nil;
    end;
  Result := true
end;

procedure TPLRM.loadHydPropsSchemeFromDb(schmExt:String; soilsInfData:PLRMGridData);
  var
    scheme:TPLRMHydPropsScheme;
  begin
    scheme := TPLRMHydPropsScheme.Create;
    scheme.readSchemeDb(schmExt, soilsInfData);
    scheme.id :=   IntToStr(hydPropsSchemes.count); //need to renumber schemes so that no holes exist
    curHydPropsSchmID := hydPropsSchemes.AddObject(scheme.id,scheme);
    globalSchmID := StrToInt(scheme.id);//globalSchmID + 1;
    curHydPropsScheme := scheme;
  end;

  procedure TPLRM.loadHydPropsSchemeFromXML(iNode:IXMLNode);
  var
    scheme:TPLRMHydPropsScheme;
  begin
    if (strToInt(iNode.Attributes['stype']) > 2) then Exit;  //the it is a road conditions scheme with stype =3 so exit
    scheme := TPLRMHydPropsScheme.Create;
    scheme.readSchemeXML(iNode);
    curHydPropsSchmID := hydPropsSchemes.AddObject(scheme.id,scheme);
    globalSchmID := StrToInt(scheme.id);//globalSchmID + 1;
    curHydPropsScheme := scheme;
    if AnsiCompareStr(scheme.snowPackID,'Roads') = 0 then
    begin
      case scheme.stype of
        0: hydPropsRdOutSchemes.AddObject(scheme.name, scheme);
        1: hydPropsRdInfSchemes.AddObject(scheme.name, scheme);
        2: hydPropsRdDspSchemes.AddObject(scheme.name, scheme);
      end;
    end
    else
    begin
      case scheme.stype of
        0: hydPropsPcOutSchemes.AddObject(scheme.name, scheme);
        1: hydPropsPcInfSchemes.AddObject(scheme.name, scheme);
      end;
    end;


  end;

  procedure TPLRM.loadRdCondsSchemeFromXML(filePath:String);
  var
    scheme:TPLRMRdCondsScheme;
  begin
    scheme := TPLRMRdCondsScheme.Create;
    scheme.readSchemeXML(filePath);
    curRdCondsPropsSchmID := rdCondsSchemes.AddObject(scheme.id,scheme);
    globalSchmID := StrToInt(scheme.id);//globalSchmID + 1;
  end;

  procedure TPLRM.loadRdCondsSchemeFromXML(iNode:IXMLNode);
  var
    scheme:TPLRMRdCondsScheme;
  begin
    scheme := TPLRMRdCondsScheme.Create;
    scheme.readSchemeXML(iNode);
    curRdCondsPropsSchmID := rdCondsSchemes.AddObject(scheme.id,scheme);
    globalSchmID := StrToInt(scheme.id);//globalSchmID + 1;
  end;

procedure TPLRM.getHydSchemes(var Schm:TPLRMHydPropsScheme; sType:Integer; ext:String; parcelOrRoad:String; luse:String);
var
  I:Integer;
  TempSchm:TPLRMHydPropsScheme;
  tempLst :TStringList;
begin
    if (Schm <> nil) then  exit;
    //check to see if schemes available from input file and map to catchment schemes
    if (PLRMObj.hydPropsSchemes.Count <> 0) then
    begin
      for I := 0 to PLRMObj.hydPropsSchemes.Count - 1 do
      begin
          TempSchm := PLRMObj.hydPropsSchemes.Objects[I] as TPLRMHydPropsScheme;
          if ((TempSchm.luse = luse) and (TempSchm.stype = stype) and (TempSchm.snowPackID = parcelOrRoad) and (TempSchm.catchName = PLRMObj.currentCatchment.name )) then Schm := TempSchm;
      end;
    end;

    //if no match load default scheme from file
    if (Schm = nil) then
    begin
      //tempLst := getFilesInFolder(HYDSCHMSDIR, '*.' + ext);
      //if (assigned(tempLst) and (tempLst <> nil)) then
      //loadHydPropsSchemeFromDb(ext, PLRMObj.currentCatchment.soilsInfData);
      //Schm.luse := luse;
    end;
    FreeAndNil(tempLst);
end;

  //Finds catchment and if not already in list adds it
function TPLRM.getCatchIndex(catchID:String):Integer;
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

    //Finds node and if not already in list adds it
function TPLRM.getNodeIndex(nodeID:String; list:TStringList):Integer;
  var
    position: Integer;
    I : Integer;
  begin
    position := list.IndexOf(nodeID);
    if position = -1 then
    begin
      for I := 0 to list.Count - 1 do
      begin
        if ((list.Objects[I] as TPLRMNode).swmmNode.ID = nodeID) then
        begin
           list.AddObject(nodeID, list.Objects[I]);
           list.Delete(I);
           position := I;
           Result := position;
           Exit;
        end;
      end;

    end;
    Result := position;
  end;

procedure TPLRM.addSubCatch(S:Uproject.TSubCatch; ObjIndex:Integer);
  var
    newCatch: TPLRMCatch;
    position: Integer;
    strErrVal:String;
    var tempInt:Integer;
  begin
    newCatch := TPLRMCatch.Create;
    newCatch.swmmCatch := S;
    newCatch.ObjType:= SUBCATCH;
    newCatch.ObjIndex:= ObjIndex;

    newCatch.name := CATCHPREFIX + intToStr(catchments.count+1);
    while nodeAndCatchNames.IndexOf(newCatch.name) <> - 1 do
      newCatch.name := newCatch.name + intToStr(catchments.count+1);

    position := catchments.AddObject(newCatch.name, newCatch);
    newCatch.id := position;
    currentCatchment := catchments.Objects[position] as TPLRMCatch;
    currentCatchment.mySWMMIndex := position;
    //moved to create of TPlrm catch
    updateCurCatchProps(newCatch.name, newCatch.name,newCatch.physclProps,nil); //use star until outlet node is assigned '*'
    EditorObject := SUBCATCH; // lets swmm functions know we are working with catchments
    EditorIndex := newCatch.ObjIndex;
    tempInt := Project.Lists[SUBCATCH].IndexOf(newCatch.name);
    if tempInt = -1 then Project.Lists[SUBCATCH][ObjIndex] := newCatch.name;
    ValidateEditor(0,newCatch.name,strErrVal);
    nodeAndCatchNames.Add(newCatch.name);
  end;

  function TPLRM.deleteObj(objType:Integer; objIndex:Integer):Boolean;
  var
    tempInt,I,J,K:Integer;
    tempCatch: TPLRMCatch;
    tempNode: TPLRMNode;
    foundFlag: Boolean;
    foundIndex: Integer;
    tempObj: TObject;
  begin

    //delete from catchments
    foundFlag := false;
    if assigned(catchments) then
    begin
      I := 0;
      while I < catchments.count do
      begin
        tempCatch := (catchments.Objects[I] as TPLRMCatch);
        if ((foundFlag = false) and (tempCatch.ObjType = objType) and (tempCatch.ObjIndex = objIndex)) then
        begin
           tempObj := catchments.Objects[I];
          tempInt := nodeAndCatchNames.IndexOf((catchments.Objects[I] as TPLRMCatch).name);
          if tempInt <> -1 then nodeAndCatchNames.Delete(tempInt);
          catchments.Delete(I);
          if assigned(tempObj) then FreeAndNil(tempObj);
          foundFlag := true;
          foundIndex := I;
          Break;
        end;
        I := I + 1;
      end;
      //decrement all indexes of that were greater than that of deleted object to fill in for deleted object
      for I := foundIndex to catchments.Count - 1 do
        if foundFlag = true then
          (catchments.Objects[I] as TPLRMCatch).ObjIndex := (catchments.Objects[I] as TPLRMCatch).ObjIndex - 1;
    end;

    //delete from nodes
    foundFlag := false;
    if assigned(nodes) then
    begin
      I := 0;
      while I < nodes.Count do
      begin
        tempNode := (nodes.Objects[I] as TPLRMNode);
        if ((foundFlag = false) and (tempNode.ObjType = objType) and (tempNode.ObjIndex = objIndex)) then
        begin
          tempInt := nodesTypeLists[tempNode.SWTType].IndexOf(tempNode.userName);
          If tempInt <> -1 then nodesTypeLists[tempNode.SWTType].Delete(tempInt);
          tempInt := nodeAndCatchNames.IndexOf((nodes.Objects[I] as TPLRMNode).userName);
          if tempInt <> -1 then nodeAndCatchNames.Delete(tempInt);
          nodes.Delete(I);
          //search all catchments and set all references to the current node to nil
          for K := 0 to Catchments.Count - 1 do
          begin
            if ((Catchments.Objects[K] as TPLRMCatch).outNode = tempNode) then
                (Catchments.Objects[K] as TPLRMCatch).outNode := nil;
          end;

          //next, search all nodes and set all references to the current node to nil
          for K := 0 to Nodes.Count - 1 do
          begin
            if ((nodes.Objects[K] as TPLRMNode).outNode1 = tempNode) then
                (nodes.Objects[K] as TPLRMNode).outNode1 := nil;
            if ((nodes.Objects[K] as TPLRMNode).outNode2 = tempNode) then
                (nodes.Objects[K] as TPLRMNode).outNode2 := nil;
          end;
          if assigned(tempNode) then FreeAndNil(tempNode);
          foundFlag := true;
          foundIndex := I;
          J:=I;
          //now that it is found decrement the indexes of all nodes of the same type that are larger
          while J < nodes.Count do
          begin
            tempNode := (nodes.Objects[J] as TPLRMNode);
            if ((tempNode.ObjType = objType) and (tempNode.ObjIndex > objIndex)) then
              (nodes.Objects[J] as TPLRMNode).ObjIndex := (nodes.Objects[J] as TPLRMNode).ObjIndex - 1;
            J := J + 1;
          end;
          Break;
        end;
      I := I + 1;
    end;
    end;
  end;

procedure TPLRM.addNode(N:Uproject.TNode; ObjIndex:Integer);
  var
    newNode: TPLRMNode;
    namePrefix : String;
    strErrVal:String;
  begin
    newNode := TPLRMNode.Create;
    newNode.swmmNode := N;
    newNode.ObjType:= N.Ntype;
     newNode.ObjIndex:= ObjIndex;

    //determine swt type
    newNode.isSwt := true;
    case Length(currentToolHint) of
       8: newNode.SWTType := 3;  //WetBasin
       9: newNode.SWTType := 1;  //Dry Basin
       10: newNode.SWTType := 4;  //Bed Filter
       16: newNode.SWTType := 5; //Cartridge Filter
       15: newNode.SWTType := 6; //Treatment vault
      18:
       begin
        newNode.SWTType := 2; //Infiltration Basin
        newNode.hasEffl := false;
       end;
      else
       begin
        newNode.isSwt :=false;
        newNode.hasEffl := false;
        newNode.SWTType := 7; //All others, junctions, outfalls, dividers
        end;
    end;
    case  N.NType of
      JUNCTION:
          namePrefix := 'Junction';
      OUTFALL:
          namePrefix := 'Outfall';
      DIVIDER:
          namePrefix := 'Divider';
      STORAGE:
        begin
          case newNode.SWTType of
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

    newNode.userName := namePrefix + intToStr(nodesTypeLists[newNode.SWTType].Count+1);
    while nodeAndCatchNames.IndexOf(newNode.userName) <> - 1 do
      newNode.userName := newNode.userName + intToStr(catchments.count+1);

    newNode.typeIndex := nodesTypeLists[newNode.SWTType].AddObject(newNode.userName, newNode);
    newNode.allNodeindex := nodes.AddObject(newNode.userName, newNode);
    EditorObject := newNode.ObjType; // lets swmm functions know we are working with specified node type
    EditorIndex := newNode.ObjIndex;
    ValidateEditor(0,newNode.userName,strErrVal);
    nodeAndCatchNames.Add(newNode.userName);
  end;

 function TPLRM.getAllNodes(): TStringList;
var
  I : Integer;
  tempNodeList: TStringList;
begin
    tempNodeList := TStringList.Create;
    for I := 0 to PLRMObj.nodes.Count - 1 do
      tempNodeList.AddObject((nodes.Objects[I] as TPLRMNode).userName,PLRMObj.nodes.Objects[I]);
    Result := tempNodeList;
end;

function TPLRM.getSWTTypeNodes(swtType: Integer) : TStringList;
var
  I : Integer;
  tempNode: TPLRMNode;
  tempNodeList: TStringList;
begin
   tempNodeList := TStringList.Create;
   for I := 0 to PLRMObj.nodes.Count - 1 do
    begin
      tempNode := (PLRMObj.nodes.Objects[I] as TPLRMNode);
      if tempNode.SWTType = swtType then tempNodeList.AddObject(tempNode.userName, tempNode);
    end;
    tempNode := nil;
    //let calling fxn free tempNodeList := nill;
   getSWTTypeNodes := tempNodeList;
end;

procedure TPLRM.LinkObjsToSWMMObjs();
var
  I: Integer;
  TempNode:TPLRMNode;
  Catch:TPLRMCatch;
  swmmIndex:Integer;
begin
  for I := 0 to nodes.Count - 1 do
  begin
    TempNode := (nodes.Objects[I] as TPLRMNode);
    TempNode.swmmNode := Project.Lists[TempNode.ObjType].Objects[TempNode.ObjIndex] as TNode;
    swmmIndex := Project.Lists[CONDUIT].IndexOf(TempNode.dwnLinkID);
    if swmmIndex <> -1 then TempNode.dwnLink := Project.GetLink(CONDUIT, swmmIndex);

    if (TempNode.divertLinkID <> '-1') then
    begin
      swmmIndex := Project.Lists[CONDUIT].IndexOf(TempNode.divertLinkID);
      if swmmIndex <> -1 then TempNode.divertLink := Project.GetLink(CONDUIT, swmmIndex);
    end;

  end;
  //Link catchments to nodes
  linkCatchsAndNodesToOtherNodes(catchments,nodes);
  for I := 0 to catchments.Count - 1 do
  begin
    Catch := (catchments.Objects[I] as TPLRMCatch);
    Catch.swmmCatch := Project.Lists[Catch.ObjType].Objects[Catch.ObjIndex] as TSubCatch;
  end;
end;

function TPLRM.getCurCatchLuseProp(strLuse:string; colNum:Integer; var status:Boolean):Double;
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

procedure TPLRM.updateCurCatchProps(oldName:String; newName:String; physclProps:PLRMGridData; outGSNode :TPLRMNode);  // always use PLRMObj version so that PLRMObj catchment list is updated
var
  tempInt:Integer;
begin
  tempInt := catchments.IndexOf(oldName);
  catchments[tempInt] := newName;
  (catchments.Objects[tempInt] as TPLRMCatch).updateCurCatchProps(newName, physclProps, outGSNode);
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

 procedure TPLRM.launchPropEditForm(ObjType:Integer; ObjIndex:Integer);
 //----------------------
// Object category codes  from Uproject.pas
//----------------------
//  NOTES        = 0; OPTION       = 1; RAINGAGE     = 2;  SUBCATCH     = 3;  JUNCTION     = 4;
//  OUTFALL      = 5; DIVIDER      = 6; STORAGE      = 7;  CONDUIT      = 8;  PUMP         = 9;
//  ORIFICE      = 10;WEIR         = 11; OUTLET       = 12;MAPLABEL     = 13;
var
  catchID :String;
 begin
      //line below needed to change current node to one clicked on the map
      if (ObjType >= 4) AND (ObjType <= 7) then  //Only nodes
      begin
         currentNode := nodes.Objects[nodes.IndexOf(Project.getNode(ObjType,ObjIndex).ID)] as TPLRMNode;
      end;
      case ObjType of
         SUBCATCH:
         begin
          catchID := (catchments.Objects[ObjIndex] as TPLRMCatch).name;
          getCatchProps(catchID);
          catchID := (catchments.Objects[ObjIndex] as TPLRMCatch).name;//name can change so read back in
          currentCatchment := catchments.Objects[catchments.IndexOf(catchID)] as TPLRMCatch;
         end;
         JUNCTION:
          begin
          currentNode := nodes.Objects[nodes.IndexOf((Project.Lists[JUNCTION].Objects[ObjIndex] as TNode).ID)] as TPLRMNode;
          getSWTProps(currentNode.userName, currentNode.SWTType);
          end;
         OUTFALL:
          begin
           currentNode := nodes.Objects[nodes.IndexOf((Project.Lists[OUTFALL].Objects[ObjIndex] as TNode).ID)] as TPLRMNode;
           getSWTProps(currentNode.userName, currentNode.SWTType);

          end;
		  DIVIDER:
          begin
           currentNode := nodes.Objects[nodes.IndexOf((Project.Lists[DIVIDER].Objects[ObjIndex] as TNode).ID)] as TPLRMNode;
           getSWTProps(currentNode.userName, currentNode.SWTType);
          end;
    STORAGE:
		begin
           getSWTProps(currentNode.userName, currentNode.SWTType);
          end;
	end;
 end;

  procedure TPLRM.linkCatchsAndNodesToOtherNodes(catchs:TStringList; nodes:TStringList);
  var
    I,J:integer;
    TempNode:TPLRMNode;
    TempNode1:TPLRMNode;
    TempCatch:TPLRMCatch;
  begin

    //Link catchments to their downstream nodes
     for I := 0 to catchs.Count - 1 do
     begin
      TempCatch :=  (catchs.Objects[I] as TPLRMCatch);
      for J := 0 to nodes.Count - 1 do
      begin
         TempNode := nodes.Objects[J] as TPLRMNode;
         if TempNode.userName = TempCatch.tempOutNodeID then
          TempCatch.outNode := TempNode;
      end;
     end;

     //Link nodes to their downstream nodes
     for I := 0 to nodes.Count - 1 do
     begin
      TempNode :=  (nodes.Objects[I] as TPLRMNode);
      for J := 0 to nodes.Count - 1 do
      begin
         TempNode1 := nodes.Objects[J] as TPLRMNode;
         if TempNode.tempOutNode1ID  = TempNode1.userName then
          TempNode.outNode1 := TempNode1;
         if TempNode.tempOutNode2ID = TempNode1.userName then
          TempNode.outNode2 := TempNode1;
      end;
     end;
  end;
{$ENDREGION}

end.
