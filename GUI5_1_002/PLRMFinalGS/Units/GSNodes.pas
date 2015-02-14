unit GSNodes;

interface
uses
 SysUtils, Windows, Messages, Classes, Controls, Forms, Dialogs, XMLIntf, msxmldom, XMLDoc,
  StdCtrls, ComCtrls, Grids, GSUtils, GSTypes, Uproject;

  const dgnTblValColNum = 3;
  const efflTblValColNum = 3;
  const efflFracTblValColNum = 3;
 type TPLRMNode = class
  isSwt:boolean;
  hasEffl:boolean; //false for all non swts and infiltration
  hasDgnProps:Boolean;

  typeIndex:Integer; //sequential number in order of creation starting from 0 for all objs of same type used with nodesTypeLists
  allNodeindex:Integer;  //sequential number in order of creation starting from 0 for all nodes used with nodes list

  userName : String;

  //7 - its not swt 1 - detention, 2 - infiltration 3-wetbasin 4-bedfilter 5-cartridge filter 6-treatment vault
  SWTType : Integer;
  ObjType:Integer; //SWMM ObjectType for retrieval from Project.Lists
  ObjIndex:Integer; //SWMM ObjectIndex for retrieval from Project.Lists
  qryStrCode:String; //matches SWT_Code in database 500-Detention, 501-WetBasin etc
  invertElv:Integer;

  swmmNode : Uproject.TNode;
  dwnLink : Uproject.TLink;
  dwnLinkID : String;
  divertLinkID : String;
  divertLink : Uproject.TLink; //secondary link to high flow outlet for flow dividers

  designProps : PLRMGridData;
  efflConcs : PLRMGridData;
  cecValFracs : PLRMGridData;
  tempOutNode1ID : String;  //temporarily stores primary outlet node id
  tempOutNode2ID : String; //temporarily stores secondary outlet node id (e.g., high flow outlet node for flow divider)
  outNode1 :TPLRMNode;
  outNode2 :TPLRMNode;
  maxFlow : String; //maximum flow - used as cutoff flow for flow splitter
  userCustomizedCurveFlag : Boolean;

  volumeDischarge : PLRMGridData; //used for det. basins, infil basins, and surcharge basins only
  stageArea1 : PLRMGridData; //used for det. basins, infil basins, and surcharge basins only
  stageArea2: PLRMGridData; //used for permanent pool basins only
  stageTmtDischarge : PLRMGridData; //used for det. basins, infil basins, and surcharge basins only
  stageInfDischarge : PLRMGridData; //used for det. basins & infil basins only


  xmlTagsEffl:TStringList;
  xmlTagsDgn:TStringList;
  xmlTagsCurves:TStringList;

  constructor Create;
  destructor  Destroy; override;
  function nodeToXML():IXMLNode;
  procedure xmlToNode(iNode:IXMLNode);
  //function validate():TStringList;
 end;

implementation
uses
 Uglobals, GSIO;
{$REGION 'PLRMNode class methods'}
//-----------------------------------------------------------------------------
// PLRMNode class methods
//-----------------------------------------------------------------------------
constructor TPLRMNode.Create;
begin
  inherited Create;
  qryStrCode:= '-1';
  invertElv := 0;
  isSWT:= true;  //overwritten later for non swts
  hasEffl := true; //overwritten later  for infiltration and non swts
  hasDgnProps:=false;
  maxFlow:='0';
  qryStrCode:='-1';
  divertLinkID := '-1';
  dwnLinkID := '-1';
end;

destructor TPLRMNode.Destroy;
begin

  //set swmm object pointers to nil but don't free since swmm will free
  swmmNode := nil;
  dwnLink := nil;
  divertLink := nil;

  //free plrmgridata types
  designProps := nil;
  efflConcs := nil;
  volumeDischarge := nil;
  stageArea1 := nil;
  stageArea2 := nil;
  stageTmtDischarge := nil;
  stageInfDischarge := nil;

  FreeAndNil(xmlTagsEffl);
  FreeAndNil(xmlTagsDgn);
  FreeAndNil(xmlTagsCurves);

  inherited Destroy;
end;

function TPLRMNode.nodeToXML():IXMLNode;
var
   xmlDoc : IXMLDocument;
   iNode : IXMLNode;
   tempNode:IXMLNode;
   tempNodeList:IXMLNodeList;
   tempNode2:IXMLNode;
   tempNodeList2:IXMLNodeList;
   tempNodeList3:IXMLNodeList;
   tempNode3:IXMLNode;
   I:Integer;
   dbProps :dbReturnFields3;
  begin
    xmlDoc := TXMLDocument.Create(nil) ;
    xmlDoc.Active := true;

    iNode := xmlDoc.AddChild('Node');
    iNode.Attributes['id'] := string(swmmNode.id);
    iNode.Attributes['name'] := userName;
    iNode.Attributes['NodeType'] := intToStr(SWTType);
    iNode.Attributes['ObjIndex'] := intToStr(ObjIndex);
    iNode.Attributes['ObjType'] := intToStr(ObjType);
    if Assigned(dwnLink) then
      iNode.Attributes['LinkID'] := dwnLinkID
    else
      iNode.Attributes['LinkID'] := '-1';

    if Assigned(divertLink) then
      iNode.Attributes['DivertLinkID'] := divertLinkID
    else
      iNode.Attributes['DivertLinkID'] := '-1';


    iNode.Attributes['isSWT'] := isSWT;
    iNode.Attributes['InvertEl'] := intToStr(invertElv);
    iNode.Attributes['hasDgnProps'] := hasDgnProps;
    if ((assigned(outNode1)) and (outNode1.username <> ''))then
      iNode.Attributes['downNode1'] := outNode1.userName
    else
      iNode.Attributes['downNode1'] := '-1';

    if ((assigned(outNode2)) and (outNode2.username <> ''))then
      iNode.Attributes['downNode2'] := outNode2.userName
    else
      iNode.Attributes['downNode2'] := '-1';

    iNode.Attributes['maxFlow'] := maxFlow;
    iNode.Attributes['qryStrCode'] := qryStrCode;
    iNode.Attributes['CustomCurves'] := userCustomizedCurveFlag;
    iNode.Attributes['hasEffl'] := hasEffl;
    iNode.Attributes['X'] := swmmNode.X;
    iNode.Attributes['Y'] := swmmNode.Y;
    iNode.Text := userName;

    if ((isSWT = true) and Assigned(designProps)) then
    begin
      //Read design properties
      if xmlTagsDgn = nil then
        xmlTagsDgn:= GSIO.lookUpValFrmTable('SWTDesignParameters','xmlTag',7,false,'WHERE (SWT_Code like '+ qryStrCode + ') ORDER BY SWTDesignParameters.displayOrder');
      tempNodeList := GSUtils.plrmGridDataToXML('dngParam', designProps,xmlTagsDgn,dgnTblValColNum);
      tempNode := iNode.AddChild('DesignParamters', '');
      for I := 0 to tempNodeList.Count - 1 do
        tempNode.ChildNodes.Add(tempNodeList[I]);
      tempNode.Resync;

      //write effl quals
      if((hasEffl = true) and Assigned(efflConcs) and (SWTType <> 2)) then
      begin
        if (xmlTagsEffl = nil)  then
          xmlTagsEffl:= GSIO.lookUpValFrmTable('SWTCECs','xmlTag',7,false,'WHERE (SWT_Code like '+ qryStrCode + ') ORDER BY SWTCECs.displayOrder');
        tempNodeList2 := GSUtils.plrmGridDataToXML('efflQual', efflConcs,xmlTagsEffl,efflTblValColNum);
        tempNode2 := iNode.AddChild('EfflQuals', '');
        for I := 0 to tempNodeList2.Count - 1 do
          tempNode2.ChildNodes.Add(tempNodeList2[I]);
        tempNode2.Resync;
      end;

      //write effl qual factors
      dbProps := GSIO.getEfflQuals('507',2,5,4,5);
      cecValFracs := dbFields3ToPLRMGridData(dbProps,0);
      if((hasEffl = true) and Assigned(efflConcs) and (SWTType <> 2)) then
      begin
        if (xmlTagsEffl = nil)  then
          xmlTagsEffl:= GSIO.lookUpValFrmTable('SWTCECs','xmlTag',7,false,'WHERE (SWT_Code like '+ qryStrCode + ') ORDER BY SWTCECs.displayOrder');
        tempNodeList3 := GSUtils.plrmGridDataToXML('efflQualFracs', cecValFracs,xmlTagsEffl,efflFracTblValColNum);
        tempNode2 := iNode.AddChild('EfflQualsFracs', '');
        for I := 0 to tempNodeList3.Count - 1 do
          tempNode2.ChildNodes.Add(tempNodeList3[I]);
        tempNode2.Resync;
      end;
      if Assigned(volumeDischarge) then
      begin
        tempNode3 := iNode.AddChild('Curves', '');
        swmmInptFileCurvesToXML(stageArea1, userName+ '_SaSur','Storage',tempNode3);
        swmmInptFileCurvesToXML(stageArea2, userName+ '_SaWet','Storage',tempNode3);
        swmmInptFileCurvesToXML(stageTmtDischarge, userName+ '_SdTrt','Rating',tempNode3);
        swmmInptFileCurvesToXML(stageInfDischarge, userName+ '_SdInf','Rating',tempNode3);
        swmmInptFileCurvesToXML(volumeDischarge, userName+ 'VolDis','NA',tempNode3);//Used internally only and not by swmm
        tempNode3.Resync;
      end;
    end;

    //xmlDoc := nil;
    // dont set to nil iNode := nil;
    //tempNode := nil;
    //tempNodeList:= nil;
    //tempNode2:= nil;
    //tempNodeList2:= nil;
    //tempNode3:= nil;

    Result:= iNode;
  end;

  procedure TPLRMNode.xmlToNode(iNode:IXMLNode);
  var
    dbProps :dbReturnFields3;
    I :Integer;
    id:String;
  begin
    id := iNode.Attributes['id'];
    userName := iNode.Attributes['name'];
    SWTType := strToInt(iNode.Attributes['NodeType']);
    isSWT := iNode.Attributes['isSWT'];
    invertElv := strToInt(iNode.Attributes['InvertEl']);
    hasDgnProps := iNode.Attributes['hasDgnProps'];
    tempOutNode1ID := iNode.Attributes['downNode1'];
    tempOutNode2ID := iNode.Attributes['downNode2'];
    maxFlow := iNode.Attributes['maxFlow'];
    qryStrCode :=  iNode.Attributes['qryStrCode'];
    ObjIndex := strToInt(iNode.Attributes['ObjIndex']);
    ObjType := strToInt(iNode.Attributes['ObjType']);
    dwnLinkID := iNode.Attributes['LinkID'];
    divertLinkID := iNode.Attributes['DivertLinkID'];
    userCustomizedCurveFlag := iNode.Attributes['CustomCurves'];
    hasEffl := iNode.Attributes['hasEffl'];

    if (isSWT = true) then
    begin
        //Read design parameters from database user value col to be overwritten below
      dbProps := GSIO.getDesignParams(qryStrCode,2,3,4,3);
      designProps := dbFields3ToPLRMGridData(dbProps,0);
      if xmlTagsDgn = nil then
        xmlTagsDgn:= GSIO.lookUpValFrmTable('SWTDesignParameters','xmlTag',7,false,'WHERE (SWT_Code like '+ qryStrCode + ') ORDER BY SWTDesignParameters.displayOrder');
      for I := 0 to xmlTagsDgn.Count - 1 do
        designProps[I][dgnTblValColNum] := iNode.ChildNodes['DesignParamters'].ChildNodes[I].Attributes[xmlTagsDgn[I]];

      //Read effluent quals from database user value col to be overwritten below
      dbProps := GSIO.getEfflQuals(qryStrCode,2,5,4,5);
      efflConcs := dbFields3ToPLRMGridData(dbProps,0);

      if((hasEffl = true) and Assigned(efflConcs) and (SWTType <> 2)) then
      begin
        if xmlTagsEffl = nil then
        begin
          xmlTagsEffl:= GSIO.lookUpValFrmTable('SWTCECs','xmlTag',7,false,'WHERE (SWT_Code like '+ qryStrCode + ') ORDER BY SWTCECs.displayOrder');
        end;
        for I := 0 to xmlTagsEffl.Count - 1 do
          efflConcs[I][efflTblValColNum] := iNode.ChildNodes['EfflQuals'].ChildNodes[I].Attributes[xmlTagsEffl[I]];
      end;
      //Read curves from XML
        if ((SWTType <= 4)) then  //omit cartridge filters, hydrodynamic devices, and non swts
        begin
          if (iNode.ChildNodes['Curves'].HasChildNodes) then
          begin
            stageArea1 := swmmInptFileXMLToCurves(stageArea1, iNode.ChildNodes['Curves'].ChildNodes[0]);
            stageArea2 := swmmInptFileXMLToCurves(stageArea2, iNode.ChildNodes['Curves'].ChildNodes[1]);
            stageTmtDischarge := swmmInptFileXMLToCurves(stageTmtDischarge, iNode.ChildNodes['Curves'].ChildNodes[2]);
            stageInfDischarge := swmmInptFileXMLToCurves(stageInfDischarge, iNode.ChildNodes['Curves'].ChildNodes[3]);
            volumeDischarge := swmmInptFileXMLToCurves(volumeDischarge, iNode.ChildNodes['Curves'].ChildNodes[4]);

            volumeDischarge[0,0] := 'Volume (cf)';
            volumeDischarge[1,0] := 'Treatment Rate (cfs)';
            volumeDischarge[2,0] := 'Infilt. Rate (in/hr)';
            
            stageArea1[0,0] := 'Depth (ft)';
            stageArea1[1,0] := 'Area (sf)';
            stageArea2[0,0] := 'Depth (ft)';
            stageArea2[1,0] := 'Area (sf)';
            stageTmtDischarge[0,0] := 'Head (ft)';
            stageTmtDischarge[1,0] := 'Outflow (cfs)';
            stageInfDischarge[0,0] := 'Head (ft)';
            stageInfDischarge[1,0] := 'Outflow (cfs)';
          end;
        end;
    end;
  end;

 {$ENDREGION}
end.
