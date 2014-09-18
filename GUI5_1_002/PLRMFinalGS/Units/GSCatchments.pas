unit GSCatchments;

interface

uses
  SysUtils, Windows, Messages, Classes, Controls, Forms, Dialogs, XMLIntf,
  msxmldom, XMLDoc,
  StdCtrls, ComCtrls, Grids, GSUtils, GSTypes, Uproject, Math, GSNodes;

// 2014 added data structures for infiltration facility parameters
type
  GSInfiltrationFacility = record
    totSurfaceArea: double; // in sq.ft
    totStorage: double; // cu.ft
    aveAnnInfiltrationRate: double; // in/hr
  end;

  // 2014 added data structure for Pervious Channel facility parameter
type
  GSPervChannelFacility = record
    length: double; // ft
    width: double; // ft
    aveSlope: double; // %
    storageDepth: double; // in
    aveAnnInfiltrationRate: double; // in/hr
  end;

type
  GSRoadDrainageInput = record
    DCIA: double;
    ICIA: double;
    DINF: double;
    DPCH: double;
    shoulderAveAnnInfRate: double;
    INFFacility: GSInfiltrationFacility;
    PervChanFacility: GSPervChannelFacility;
    isAssigned: boolean; // sentinel flag for know when populated
  end;

type
  TDrngXtsData = record
    // entity: Integer; // 0 - global, 1 - n for catchments as catchment ID
    luseAreaNPrcnt: PLRMGridData;
    luseAreaNImpv: PLRMGridData;

    // catchment break down by % coverage of land uses
    // secRdsPrcnt: Double;
    // primRdsPrcnt: Double;
    sfrPrcnt: double;
    mfrPrcnt: double;
    cicuPrcnt: double;
    vegTPrcnt: double;
    othrPrcnt: double;

    // catchment break down by area of land uses
    // secRdsArea: Double;
    // primRdsArea: Double;
    sfrArea: double;
    mfrArea: double;
    cicuArea: double;
    vegTArea: double;
    othrArea: double;
  end;

type
  TPLRMHydPropsScheme = class
    // flags
    isSet: boolean;

    name: String;
    catchName: String;
    id: String;
    description: String;
    category: String;
    stype: Integer;
    // sType -0 - to outlet, 1 - to infiltration, 2 - to pervious dispersion
    snowPackID: String;
    luse: String;
    // added to seperate schemes of the same stype and belonging to the same catchment but assigned to dif luses

    // data from _PLRMD6DrngXtsDetail form
    drngHydProps: PLRMGridData;
    // Drainage area hydrologic properties grid values
    hydPropsHSC: PLRMGridData;
    // HSC hydrologic properties grid values for infiltration or pervious dispersion
    hydPropsGA: PLRMGridData; // Green-Ampt props grid values

    constructor Create;
    destructor Destroy; override;
    function writeSchemeXML(): IXMLNode;
    procedure readSchemeXML(iNode: IXMLNode);
    procedure readSchemeDb(schmExt: String; soilsInfData: PLRMGridData);
  end;

type
  TPLRMRdCondsScheme = class
    isSet: boolean;
    name: String;
    catchName: String; // catchment name + id
    id: String;
    description: String;
    stype: Integer;
    pollPotential: PLRMGridData;
    pollPotentialIDs: PLRMGridData;
    shoulderConds: PLRMGridData;
    rdReportCardPPS: PLRMGridData;
    rdReportCardSES: PLRMGridData;
    runoffConcs: PLRMGridData;
    pollDelFactors: PLRMGridData;

    constructor Create;
    destructor Destroy; override;
    function writeSchemeXML(): IXMLNode;
    procedure readSchemeXML(filePath: String); overload;
    procedure readSchemeXML(iNode: IXMLNode); overload;
    // function validate():TStringList;
  private
    // XML Related Variables
    rdShouldrTags: TStringList;
    reportCardTagsPPS: TStringList;
    reportCardTagsSES: TStringList;
    runoffConcsTags: TStringList;
    pollDelFactorTags: TStringList;
  end;

type
  SchemeArray = array [0 .. 2] of TPLRMHydPropsScheme;

type
  TPLRMCatch = class
    // identification
    id: Integer;
    name: String;
    tempOutNodeID: String;
    // temporarily holds node name when read in from xml till actual node is linked
    outNode: TPLRMNode;
    mySWMMIndex: Integer;
    area: double;
    slope: double;
    width: double;
    tempMinArea: double;
    widthFactor: double; // multiplied by area in width calculation
    widthPower: double; // exponent of area is width calculation
    maxWidth, tempFloLength, MaxFloLength: double;
    // max width is area calculation
    defInfStorDepth: double; // Default infiltration facility depth
    physclProps: PLRMGridData;
    ObjType: Integer;
    // Swmm assigned type used to retrieve obj in project lists
    ObjIndex: Integer;
    // SWmm assigned type index used to retrieve obj in project lists

    // flags
    hasPhysclProps: boolean;
    hasDefLuse: boolean;
    hasDefSoils: boolean;
    hasDefPSCs: boolean;
    hasDefDrnXtcs: boolean;
    hasDefRoadPolls, hasDefRoadDrainage, hasDefParcelAndDrainageBMPs,
      hasDefCustomBMPSizeData: boolean;
    // 2014 new property added to detect if change was made in soils so ksat can be recalculated
    hasChangedSoils: boolean;
    // 2014 added so can add default properties to GIS catchments when first loaded from xml, turned off after
    isGISCatchment: boolean;

    swmmCatch: Uproject.TSubCatch;
    swmmCatchDefProps: PLRMGridData;
    // Table of default swmm properties [propName,propValue,units]

    // _PLRMD1LandUseAssignments2
    landUseNames: TStringList;
    landUseData: PLRMGridData;

    // 2014
    // for holding default imperv/perv mannings, and depression storage
    defaultHydProps: dbReturnFields;
    // 2014
    totRoadAcres: double;
    totRoadImpervAcres: double;

    // _PLRMD2SoilsAssignments
    soilsMapUnitNames: TStringList;
    soilsMapUnitData: PLRMGridData;
    soilsInfData: PLRMGridData; // soils properties read in from database

    // _PLRM3PSCDef input
    secSchmID: Integer; // Secondary road scheme ID
    secSchmName: String; // Secondary road scheme Name

    primSchmID: Integer; // Primary road scheme ID
    primSchmName: String; // Primary road scheme Name

    rdRiskCats: PLRMGridData;
    bmpImpl: PLRMGridData;
    othrArea: double;
    othrPrcntToOut: double;
    othrPrcntImpv: double;

    // _PLRM4RoadConditions
    secRdRcSchm: TPLRMRdCondsScheme;
    primRdRcSchm: TPLRMRdCondsScheme;

    // _PLRM5RoadDrnXtcs input
    secRdDrng: PLRMGridData;
    primRdDrng: PLRMGridData;
    sfrDrng: PLRMGridData;
    mfrDrng: PLRMGridData;
    cicuDrng: PLRMGridData;
    vegTDrng: PLRMGridData;
    othrDrng: PLRMGridData;

    // _PLRM5RoadDrnXtcs input
    secRdSchm: TPLRMHydPropsScheme;
    primRdSchm: TPLRMHydPropsScheme;
    sfrSchm: TPLRMHydPropsScheme;
    mfrSchm: TPLRMHydPropsScheme;
    cicuSchm: TPLRMHydPropsScheme;
    vegTSchm: TPLRMHydPropsScheme;

    // 2014
    frm4of6SgRoadShoulderData: PLRMGridData;
    frm4of6SgRoadConditionData: PLRMGridData;
    frm4of6SgRoadCRCsData: PLRMGridData;

    // 2014 road drainage editior inputs
    frm5of6RoadDrainageEditorData: GSRoadDrainageInput;

    // 2014 _PLRMD6ParcelDrainageAndBMPs
    frm6of6SgBMPImplData: PLRMGridData;
    frm6of6SgNoBMPsData: PLRMGridData;
    frm6of6AreasData: TDrngXtsData;

    // 2014 _PLRMD6aBMPSizing.pas
    frm6of6aSgBMPSizeSFRData: PLRMGridData;
    frm6of6aSgBMPSizeMFRData: PLRMGridData;
    frm6of6aSgBMPSizeCICUData: PLRMGridData;

    secRdSchms: array [0 .. 2] of TPLRMHydPropsScheme;
    primRdSchms: array [0 .. 2] of TPLRMHydPropsScheme;
    sfrSchms: array [0 .. 2] of TPLRMHydPropsScheme;
    // more than needed for uniformity and possible future extension
    mfrSchms: array [0 .. 2] of TPLRMHydPropsScheme;
    // more than needed for uniformity and possible future extension
    cicuSchms: array [0 .. 2] of TPLRMHydPropsScheme;
    // more than needed for uniformity and possible future extension
    vegTSchms: array [0 .. 2] of TPLRMHydPropsScheme;
    // more than needed for uniformity and possible future extension
    othrSchms: array [0 .. 2] of TPLRMHydPropsScheme;
    // more than needed for uniformity and possible future extension
    catchHydPropSchemes: array of array of TPLRMHydPropsScheme;
    // used to store all of the above arrays (see constructor) for easy processing

    constructor Create;
    destructor Destroy; override;
    function getKSat(typeFlag: Integer): double;
    function getKSatPerv(typeFlag: Integer): double;
    function getKSatBMP(typeFlag: Integer): double;
    function getIMD(): double;
    function getSuct(): double;
    procedure updateSWMM();
    function catchToXML(projectLuseNames: TStringList;
      ProjectLuseCodes: TStringList): IXMLNode;
    procedure xmlToCatch(iNode: IXMLNode; hydSchemes: TStringList;
      rcSchemes: TStringList);

  public
    procedure updateCurCatchProps(newName: String; physclProps: PLRMGridData;
      outGSNode: TPLRMNode);
    // always use PLRMObj version so that PLRMObj catchment list is updated
    procedure copyHydSchemesToArray();
  end;

procedure freeListofHydpropSchemes(var SchmList: TStringList);

var
  luseOffset: Integer;
  swmmDefaultBlockXMLTags: array [0 .. 5] of String = (
    'Options',
    'Evaporation',
    'Temperature',
    'Aquifers',
    'GroundWater',
    'SnowPacks'
  );
  luseXMLTags: array [0 .. 3] of String = (
    'name',
    'percentArea',
    'percentImprv',
    'area'
  );
  soilsXMLTags: array [0 .. 2] of String = (
    'name',
    'percntArea',
    'acres'
  );
  soilsXMLTags2: array [0 .. 2] of String = (
    'ksat',
    'ssh',
    'smd'
  );
  rdRiskCatXMLTags: array [0 .. 2] of String = (
    'high',
    'medium',
    'low'
  );
  rdShouldrCondsXMLTags: array [0 .. 4] of String = (
    'highprcntUnimprovd',
    'prcntProtOnly',
    'prcntStabOnly',
    'prcntStabAndProt',
    'rdShouldrScore'
  );
  rdReportCardXMLTags: array [0 .. 1] of String = (
    'PollPotScore',
    'SweepEffctvScore'
  );
  runoffConcsXMLTags: array [0 .. 5] of String = (
    'TSS',
    'FSP',
    'TP',
    'SRP',
    'TN',
    'DIN'
  );
  pollDelFactorXMLTags: array [0 .. 1] of String = (
    'finesDisvd',
    'particulates'
  );
  bmpImplXMLTags: array [0 .. 2] of String = (
    'noBMPs',
    'srcCtrlCert',
    'bmpCert'
  );
  parcelAndRdMethXMLTags: array [0 .. 6] of String = (
    'prcntArea',
    'areaAc',
    'impervArea',
    'dcia',
    'ksat',
    'pervDepStor',
    'imprvDepStor'
  );
  drngSchmTypeXMLAttribTags: array [0 .. 2] of string = (
    'outSchmID',
    'infSchmID',
    'dspSchmID'
  );

  // 2014 new tags added to support new forms
  // 1. Step 4 of 6 Road Pollutants  [PLRMFinalGS\Forms\Dialogs\_PLRMD4RoadPollutants.pas] tags
  roadPollutantsRdShoulderTags: array [0 .. 3] of string = (
    'erodible',
    'protectd',
    'stable',
    'stableAndProtectd'
  );
  roadPollutantsRdConditionTags: array [0 .. 1] of string = (
    'percentArea',
    'conditionScore'
  );
  roadPollutantsRdCRCTags: array [0 .. 5] of string = (
    'TSS',
    'FSP',
    'TP',
    'SRP',
    'TN',
    'DIN'
  );
  // roadPollutantsCRCsTags: array [0 .. 5] of String = runoffConcsXMLTags;

  // 2014 new tags added to support new forms
  // 2. Step 5 of 6 Road Drainage Editor  [PLRMFinalGS\Forms\Dialogs\_PLRMD5RoadDrainageEditor.pas] tags

  // 2014 new tags added to support new forms
  // 3. Step 6 of 6 Parcel Drainage and BMPs Editor  [PLRMFinalGS\Forms\Dialogs\_PLRMD6ParcelDrainageAndBMPs.pas] tags
  parcelDrainageAndBMPsWithBMPTags: array [0 .. 1] of string = (
    'percentBMPs',
    'percentSrcCtrls'
  );
  parcelDrainageAndBMPsNoBMPTags: array [0 .. 2] of string = (
    'percentNoBMPs',
    'percentDCIA',
    'ksat'
  );

implementation

uses
  _PLRMD3CatchProps, _PLRM7SWTs, Fmain, Uimport, Uglobals, GSIO;

{$REGION 'PLRMHydPropsScheme Class Methods' }

constructor TPLRMHydPropsScheme.Create();
begin
  isSet := false;
  id := '-1';
  snowPackID := '-1';
  SetLength(drngHydProps, 4, 3);
  SetLength(hydPropsHSC, 4, 3);
  SetLength(hydPropsGA, 3, 3);
end;

destructor TPLRMHydPropsScheme.Destroy;
begin
  // Free plrmgridata types
  drngHydProps := nil;
  hydPropsHSC := nil;
  hydPropsGA := nil;
  inherited;
end;

function TPLRMHydPropsScheme.writeSchemeXML(): IXMLNode;
var
  XMLDoc: IXMLDocument;
  iNode: IXMLNode;
  tempNode0: IXMLNode;
  tempNode1: IXMLNode;
  tempNode2: IXMLNode;
  tempNode3: IXMLNode;
  tempNode4: IXMLNode;
  tempNode5: IXMLNode;
  tempNode6: IXMLNode;
  tempNode7: IXMLNode;
  tempNode8: IXMLNode;
  tempNode9: IXMLNode;
  tempNode10: IXMLNode;
  tempNode11: IXMLNode;
begin
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := true;

  tempNode9 := XMLDoc.AddChild('PLRM');
  tempNode0 := tempNode9.AddChild('Schemes');
  iNode := tempNode0.AddChild('Scheme');
  iNode.Attributes['id'] := id;
  iNode.Attributes['name'] := name;
  iNode.Attributes['catchName'] := catchName;
  iNode.Attributes['luse'] := luse;
  iNode.Attributes['description'] := description;
  iNode.Attributes['category'] := category;
  iNode.Attributes['stype'] := stype;
  iNode.Attributes['snowPackID'] := snowPackID;

  tempNode11 := iNode.AddChild('ManningsImpervious', '');
  tempNode11.Attributes['default'] := drngHydProps[0, 0];
  tempNode11.Attributes['units'] := drngHydProps[0, 1];
  tempNode11.Text := drngHydProps[0, 2];

  tempNode1 := iNode.AddChild('ManningsPervious', '');
  tempNode1.Attributes['default'] := drngHydProps[1, 0];
  tempNode1.Attributes['units'] := drngHydProps[1, 1];
  tempNode1.Text := drngHydProps[1, 2];

  tempNode2 := iNode.AddChild('DepStoreImpervious', '');
  tempNode2.Attributes['default'] := drngHydProps[2, 0];
  tempNode2.Attributes['units'] := drngHydProps[2, 1];
  tempNode2.Text := drngHydProps[2, 2];

  tempNode3 := iNode.AddChild('DepStorePerv', '');
  tempNode3.Attributes['default'] := drngHydProps[3, 0];
  tempNode3.Attributes['units'] := drngHydProps[3, 1];
  tempNode3.Text := drngHydProps[3, 2];

  tempNode10 := iNode.AddChild('SnowMelt', '');
  tempNode10.Text := snowPackID;

  tempNode4 := iNode.AddChild('GreenAmpt', '');

  tempNode5 := tempNode4.AddChild('Ksat', '');
  tempNode5.Attributes['default'] := hydPropsGA[0, 0];
  tempNode5.Attributes['units'] := hydPropsGA[0, 1];
  tempNode5.Text := hydPropsGA[0, 2];

  tempNode6 := tempNode4.AddChild('Ssh', '');
  tempNode6.Attributes['default'] := hydPropsGA[1, 0];
  tempNode6.Attributes['units'] := hydPropsGA[1, 1];
  tempNode6.Text := hydPropsGA[1, 2];

  tempNode7 := tempNode4.AddChild('Smd', '');
  tempNode7.Attributes['default'] := hydPropsGA[2, 0];
  tempNode7.Attributes['units'] := hydPropsGA[2, 1];
  tempNode7.Text := hydPropsGA[2, 2];

  case stype of
    0:
      ; // do nothing areas draining to outlet
    1:
      begin
        tempNode8 := iNode.AddChild('UnitStorArea');
        tempNode8.Attributes['default'] := hydPropsHSC[0, 0];
        tempNode8.Attributes['units'] := hydPropsHSC[0, 1];
        tempNode8.Text := hydPropsHSC[0, 2];

        tempNode8 := iNode.AddChild('Ksat');
        tempNode8.Attributes['default'] := hydPropsHSC[1, 0];
        tempNode8.Attributes['units'] := hydPropsHSC[1, 1];
        tempNode8.Text := hydPropsHSC[1, 2];
      end;
    2:
      begin
        tempNode8 := iNode.AddChild('DspArea');
        tempNode8.Attributes['default'] := hydPropsHSC[0, 0];
        tempNode8.Attributes['units'] := hydPropsHSC[0, 1];
        tempNode8.Text := hydPropsHSC[0, 2];

        tempNode8 := iNode.AddChild('Slope');
        tempNode8.Attributes['default'] := hydPropsHSC[1, 0];
        tempNode8.Attributes['units'] := hydPropsHSC[1, 1];
        tempNode8.Text := hydPropsHSC[1, 2];

        tempNode8 := iNode.AddChild('Ksat');
        tempNode8.Attributes['default'] := hydPropsHSC[2, 0];
        tempNode8.Attributes['units'] := hydPropsHSC[2, 1];
        tempNode8.Text := hydPropsHSC[2, 2];

        tempNode8 := iNode.AddChild('PDAdepStor');
        tempNode8.Attributes['default'] := hydPropsHSC[3, 0];
        tempNode8.Attributes['units'] := hydPropsHSC[3, 1];
        tempNode8.Text := hydPropsHSC[3, 2];
      end;
  end;
  XMLDoc := nil;
  Result := tempNode9;
end;

procedure TPLRMHydPropsScheme.readSchemeDb(schmExt: String;
  soilsInfData: PLRMGridData);
var
  hydProps: dbReturnFields;
  gaProps: dbReturnFields;
begin
  hydProps := GSIO.getDefaults('"6%"');

  id := '-1';
  name := schmExt; // 'ParcelsInfProp25';
  catchName := 'TempName';
  luse := 'temp';
  description := 'Hydrologic Properties Scheme - To Infiltration HSC';

  if (schmExt = HSRDOUTSCHMEXT) then
  begin
    category := 'ToOutlet';
    stype := 0;
    snowPackID := 'Roads';
  end;
  if (schmExt = HSRDINFSCHMEXT) then
  begin
    gaProps := GSIO.getDefaults('"8%"');
    category := 'ToInfiltration';
    stype := 1;
    snowPackID := 'Roads';
  end;
  if (schmExt = HSRDDSPSCHMEXT) then
  begin
    gaProps := GSIO.getDefaults('"9%"');
    category := 'ToPerviousDispersion';
    stype := 2;
    snowPackID := 'Roads';
  end;
  if (schmExt = HSPCOTHRSCHMEXT) then
  begin
    category := 'ToOutlet';
    stype := 0;
    snowPackID := 'Parcels';
  end;
  if (schmExt = HSPCINFSCHMEXT) then
  begin
    gaProps := GSIO.getDefaults('"8%"');
    category := 'ToInfiltration';
    stype := 1;
    snowPackID := 'Parcels';
  end;

  drngHydProps[0, 0] := FormatFloat('#0.000', StrToFloat(hydProps[0][0]));
  drngHydProps[0, 1] := hydProps[0][1];
  drngHydProps[0, 2] := FormatFloat('#0.000', StrToFloat(hydProps[0][0]));

  drngHydProps[1, 0] := FormatFloat('#0.000', StrToFloat(hydProps[0][1]));
  drngHydProps[1, 1] := hydProps[1][1];;
  drngHydProps[1, 2] := FormatFloat('#0.000', StrToFloat(hydProps[0][1]));

  drngHydProps[2, 0] := FormatFloat('#0.0', StrToFloat(hydProps[0][2]));
  drngHydProps[2, 1] := hydProps[1][2];
  drngHydProps[2, 2] := FormatFloat('#0.0', StrToFloat(hydProps[0][2]));

  drngHydProps[3, 0] := FormatFloat('#0.0', StrToFloat(hydProps[0][3]));
  drngHydProps[3, 1] := hydProps[1][3];
  drngHydProps[3, 2] := FormatFloat('#0.0', StrToFloat(hydProps[0][3]));

  if (assigned(soilsInfData)) then
  begin
    // KSat
    hydPropsGA[0, 0] := FormatFloat('#0.000', StrToFloat(soilsInfData[0][1]));
    hydPropsGA[0, 1] := 'in/hr';
    hydPropsGA[0, 2] := FormatFloat('#0.000', StrToFloat(soilsInfData[0][1]));
    // Ssh
    hydPropsGA[1, 0] := FormatFloat('#0.000', StrToFloat(soilsInfData[0][2]));
    hydPropsGA[1, 1] := 'in';
    hydPropsGA[1, 2] := FormatFloat('#0.000', StrToFloat(soilsInfData[0][2]));
    // Smd
    hydPropsGA[2, 0] := FormatFloat('#0.000', StrToFloat(soilsInfData[0][3]));
    hydPropsGA[2, 1] := 'in';
    hydPropsGA[2, 2] := FormatFloat('#0.000', StrToFloat(soilsInfData[0][3]));
  end
  else
  begin
    // Values below overwritten later when catchment properties provided
    // KSat
    hydPropsGA[0, 0] := '-1';
    hydPropsGA[0, 1] := 'in/hr';
    hydPropsGA[0, 2] := '-1';
    // Ssh
    hydPropsGA[1, 0] := '-1';
    hydPropsGA[1, 1] := 'in';
    hydPropsGA[1, 2] := '-1';
    // Smd
    hydPropsGA[2, 0] := '-1';
    hydPropsGA[2, 1] := 'in';
    hydPropsGA[2, 2] := '-1';
  end;

  case stype of
    0:
      ; // do nothing areas draining to outlet
    1:
      begin
        // Unit storage area
        hydPropsHSC[0, 0] := FormatFloat('#0', StrToFloat(gaProps[0][0]));
        hydPropsHSC[0, 1] := gaProps[1][0];
        hydPropsHSC[0, 2] := FormatFloat('#0', StrToFloat(gaProps[0][0]));
        // KSat
        hydPropsHSC[1, 0] := FormatFloat('#0.00', StrToFloat(gaProps[0][1]));
        hydPropsHSC[1, 1] := gaProps[1][1];
        hydPropsHSC[1, 2] := FormatFloat('#0.00', StrToFloat(gaProps[0][1]));
      end;
    2:
      begin
        // DspArea
        hydPropsHSC[0, 0] := FormatFloat('#0', StrToFloat(gaProps[0][0]));
        hydPropsHSC[0, 1] := gaProps[1][0];
        hydPropsHSC[0, 2] := FormatFloat('#0', StrToFloat(gaProps[0][0]));
        // Slope
        hydPropsHSC[1, 0] := FormatFloat('#0.0', StrToFloat(gaProps[0][1]));
        hydPropsHSC[1, 1] := gaProps[1][1];
        hydPropsHSC[1, 2] := FormatFloat('#0.0', StrToFloat(gaProps[0][1]));

        // KSat   - use native soils rate
        // Jan 2010 edit to fix #232
        if (assigned(soilsInfData)) then
        begin
          hydPropsHSC[2, 0] := FormatFloat('#0.000',
            StrToFloat(soilsInfData[0][1]));
          hydPropsHSC[2, 1] := 'in/hr';
          hydPropsHSC[2, 2] := FormatFloat('#0.000',
            StrToFloat(soilsInfData[0][1]));
        end
        else
          Showmessage('Soils information is incomplete');

        // DepStorPerv
        hydPropsHSC[3, 0] := FormatFloat('#0.0', StrToFloat(gaProps[0][2]));
        hydPropsHSC[3, 1] := gaProps[1][2];
        hydPropsHSC[3, 2] := FormatFloat('#0.0', StrToFloat(gaProps[0][2]));
      end;
  end;
  isSet := true;
end;

// updated 10/18
procedure TPLRMHydPropsScheme.readSchemeXML(iNode: IXMLNode);
var
  hydProps: dbReturnFields;
  // gaProps: dbReturnFields;
begin
  hydProps := GSIO.getDefaults('"6%"');

  id := iNode.Attributes['id'];
  name := iNode.Attributes['name'];
  catchName := iNode.Attributes['catchName'];
  luse := iNode.Attributes['luse'];
  description := iNode.Attributes['description'];
  category := iNode.Attributes['category'];
  stype := iNode.Attributes['stype'];
  snowPackID := iNode.Attributes['snowPackID'];

  drngHydProps[0, 0] := FormatFloat('#0.000', StrToFloat(hydProps[0][0]));
  drngHydProps[0, 1] := hydProps[0][1];
  drngHydProps[0, 2] := FormatFloat('#0.000', StrToFloat(hydProps[0][0]));

  drngHydProps[1, 0] := FormatFloat('#0.000', StrToFloat(hydProps[0][1]));
  drngHydProps[1, 1] := hydProps[1][1];;
  drngHydProps[1, 2] := FormatFloat('#0.000', StrToFloat(hydProps[0][1]));

  drngHydProps[2, 0] := FormatFloat('#0.0', StrToFloat(hydProps[0][2]));
  drngHydProps[2, 1] := hydProps[1][2];
  drngHydProps[2, 2] := FormatFloat('#0.0', StrToFloat(hydProps[0][2]));

  drngHydProps[3, 0] := FormatFloat('#0.0', StrToFloat(hydProps[0][3]));
  drngHydProps[3, 1] := hydProps[1][3];
  drngHydProps[3, 2] := FormatFloat('#0.0', StrToFloat(hydProps[0][3]));

  hydPropsGA[0, 0] := iNode.ChildNodes['GreenAmpt'].ChildNodes['Ksat']
    .Attributes['default'];
  hydPropsGA[0, 1] := iNode.ChildNodes['GreenAmpt'].ChildNodes['Ksat']
    .Attributes['units'];
  hydPropsGA[0, 2] := iNode.ChildNodes['GreenAmpt'].ChildNodes['Ksat'].Text;

  hydPropsGA[1, 0] := iNode.ChildNodes['GreenAmpt'].ChildNodes['Ssh'].Attributes
    ['default'];
  hydPropsGA[1, 1] := iNode.ChildNodes['GreenAmpt'].ChildNodes['Ssh']
    .Attributes['units'];
  hydPropsGA[1, 2] := iNode.ChildNodes['GreenAmpt'].ChildNodes['Ssh'].Text;

  hydPropsGA[2, 0] := iNode.ChildNodes['GreenAmpt'].ChildNodes['Smd'].Attributes
    ['default'];
  hydPropsGA[2, 1] := iNode.ChildNodes['GreenAmpt'].ChildNodes['Smd']
    .Attributes['units'];
  hydPropsGA[2, 2] := iNode.ChildNodes['GreenAmpt'].ChildNodes['Smd'].Text;

  case stype of
    0:
      ; // do nothing areas draining to outlet
    1:
      begin
        // infiltration footprint
        hydPropsHSC[0, 0] := iNode.ChildNodes['UnitStorArea'].Attributes
          ['default'];
        hydPropsHSC[0, 1] := iNode.ChildNodes['UnitStorArea']
          .Attributes['units'];
        hydPropsHSC[0, 2] := iNode.ChildNodes['UnitStorArea'].Text;

        // infiltration ksat
        hydPropsHSC[1, 0] := iNode.ChildNodes['Ksat'].Attributes['default'];
        hydPropsHSC[1, 1] := iNode.ChildNodes['Ksat'].Attributes['units'];
        hydPropsHSC[1, 2] := iNode.ChildNodes['Ksat'].Text;
      end;
    2:
      begin
        // gaProps := GSIO.getDefaults('"9%"');
        hydPropsHSC[0, 0] := iNode.ChildNodes['DspArea'].Attributes['default'];
        hydPropsHSC[0, 1] := iNode.ChildNodes['DspArea'].Attributes['units'];
        hydPropsHSC[0, 2] := iNode.ChildNodes['DspArea'].Text;

        // Pervious Dispersion slope
        hydPropsHSC[1, 0] := iNode.ChildNodes['Slope'].Attributes['default'];
        hydPropsHSC[1, 1] := iNode.ChildNodes['Slope'].Attributes['units'];
        hydPropsHSC[1, 2] := iNode.ChildNodes['Slope'].Text;

        // Pervious Dispersion ksat
        hydPropsHSC[2, 0] := iNode.ChildNodes['Ksat'].Attributes['default'];
        hydPropsHSC[2, 1] := iNode.ChildNodes['Ksat'].Attributes['units'];
        hydPropsHSC[2, 2] := iNode.ChildNodes['Ksat'].Text;

        // Pervious Dispersion Depression Storage
        hydPropsHSC[3, 0] := iNode.ChildNodes['PDAdepStor'].Attributes
          ['default'];
        hydPropsHSC[3, 1] := iNode.ChildNodes['PDAdepStor'].Attributes['units'];
        hydPropsHSC[3, 2] := iNode.ChildNodes['PDAdepStor'].Text;

      end;
  end;
  isSet := true;
end;

procedure freeListofHydpropSchemes(var SchmList: TStringList);
var
  I: Integer;
  O: TObject;
begin
  // schemes may be pointers to other schemes so deallocate one at a time
  for I := 0 to SchmList.Count - 1 do
  begin
    O := SchmList.Objects[I];
    if ((assigned(O)) and ((O as TPLRMHydPropsScheme).drngHydProps <> nil)) then
      FreeAndNil(O);
  end;
  FreeAndNil(SchmList);
end;

{$ENDREGION}
{$REGION 'TPLRMRdCondsScheme Class Methods' }

constructor TPLRMRdCondsScheme.Create();
var
  I: Integer;
begin
  isSet := false;
  id := '-1';
  SetLength(pollPotential, 3, 3);
  SetLength(pollPotentialIDs, 3, 3);
  SetLength(shoulderConds, 3, 4);
  SetLength(rdReportCardPPS, 3, 1);
  SetLength(rdReportCardSES, 3, 1);
  SetLength(runoffConcs, 3, 5);
  SetLength(pollDelFactors, 3, 2);

  rdShouldrTags := TStringList.Create;
  reportCardTagsPPS := TStringList.Create;
  reportCardTagsSES := TStringList.Create;
  runoffConcsTags := TStringList.Create;
  pollDelFactorTags := TStringList.Create;

  reportCardTagsPPS.Add('PollPotScore');
  reportCardTagsSES.Add('SweepEffctvScore');

  for I := 0 to High(rdShouldrCondsXMLTags) do
    rdShouldrTags.Add(rdShouldrCondsXMLTags[I]);
  for I := 0 to High(runoffConcsXMLTags) do
    runoffConcsTags.Add(runoffConcsXMLTags[I]);
  for I := 0 to High(rdReportCardXMLTags) do
    pollDelFactorTags.Add(pollDelFactorXMLTags[I]);
end;

// TWords destructor - release storage
destructor TPLRMRdCondsScheme.Destroy;
begin
  // no need to free record types so skipped
  // free plrmgridata types
  pollPotential := nil;
  pollPotentialIDs := nil;
  shoulderConds := nil;
  rdReportCardPPS := nil;
  rdReportCardSES := nil;
  runoffConcs := nil;
  pollDelFactors := nil;
  FreeAndNil(rdShouldrTags);
  FreeAndNil(reportCardTagsPPS);
  FreeAndNil(reportCardTagsSES);
  FreeAndNil(runoffConcsTags);
  FreeAndNil(pollDelFactorTags);

  inherited;
end;

function TPLRMRdCondsScheme.writeSchemeXML(): IXMLNode;
var
  XMLDoc: IXMLDocument;
  iNode: IXMLNode;
  tempNode0: IXMLNode;
  tempNode1: IXMLNode;
  tempNode2: IXMLNode;
  tempNode3: IXMLNode;
  tempNode4: IXMLNode;
  tempNode5: IXMLNode;
  tempNode5b: IXMLNode;
  tempNode6: IXMLNode;
  tempNode7: IXMLNode;
  tempNode8: IXMLNode;
  tempLst: TStringList;
  tempNodeLst1: array [0 .. 2] of IXMLNode;
  tempNodeLst2: array [0 .. 2] of IXMLNode;
  tempNodeLst3: array [0 .. 2] of IXMLNode;
  tempNodeLst4: IXMLNodeList;
  tempNodeLst5: IXMLNodeList;
  tempNodeLst6: IXMLNodeList;
  tempNodeLst7: IXMLNodeList;
  I: Integer;

begin
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := true;

  tempNode8 := XMLDoc.AddChild('PLRM');
  tempNode3 := tempNode8.AddChild('Schemes');
  iNode := tempNode3.AddChild('Scheme');
  iNode.Attributes['id'] := id;
  iNode.Attributes['name'] := name;
  iNode.Attributes['catchName'] := catchName;
  iNode.Attributes['description'] := description;
  iNode.Attributes['stype'] := stype;

  // write abrasives application info
  tempNode0 := iNode.AddChild('RoadConditions', '');
  tempNode1 := tempNode0.AddChild('RoadAbbrasiveAppl', '');
  for I := 0 to High(cats) do
  begin
    tempNode1.Attributes[cats[I]] := pollPotentialIDs[I][0];
    tempNodeLst1[I] := tempNode1.AddChild(cats[I], '');
    tempNodeLst1[I].Text := pollPotential[I][0];
  end;

  tempNode0.Resync;

  // write sweeper type info
  tempNode2 := tempNode0.AddChild('SweeperType', '');
  for I := 0 to High(cats) do
  begin
    tempNode2.Attributes[cats[I]] := pollPotentialIDs[I][1];
    tempNodeLst2[I] := tempNode2.AddChild(cats[I], '');
    tempNodeLst2[I].Text := pollPotential[I][1];
  end;
  tempNode0.Resync;

  // write sweeping frequency info
  tempNode3 := tempNode0.AddChild('SweepingFreq', '');
  for I := 0 to High(cats) do
  begin
    tempNode3.Attributes[cats[I]] := pollPotentialIDs[I][2];
    tempNodeLst3[I] := tempNode3.AddChild(cats[I], '');
    tempNodeLst3[I].Text := pollPotential[I][2];
  end;
  tempNode0.Resync;

  tempLst := TStringList.Create;
  tempLst.Add(cats[0]);
  tempLst.Add(cats[1]);
  tempLst.Add(cats[2]);

  // write roadshoulder conditions info
  tempNodeLst4 := GSUtils.plrmGridDataToXML2('RoadShoulderConditions1',
    shoulderConds, rdShouldrTags, tempLst, tempLst);
  tempNode4 := iNode.AddChild('RoadShoulderConditions', '');
  for I := 0 to tempNodeLst4.Count - 1 do
    tempNode4.ChildNodes.Add(tempNodeLst4[I]);
  tempNode0.Resync;

  // write road report card  now split into PPS - pollutant potential score and SES - sweeper effectiveness score
  tempNodeLst5 := GSUtils.plrmGridDataToXML2('PPS', rdReportCardPPS,
    reportCardTagsPPS, tempLst, tempLst);
  tempNode5 := iNode.AddChild('PollutantPotentailScore', '');
  for I := 0 to tempNodeLst5.Count - 1 do
    tempNode5.ChildNodes.Add(tempNodeLst5[I]);
  tempNode0.Resync;

  tempNodeLst5 := GSUtils.plrmGridDataToXML2('SES', rdReportCardSES,
    reportCardTagsSES, tempLst, tempLst);
  tempNode5b := iNode.AddChild('SweeperEffectivenessScore', '');
  for I := 0 to tempNodeLst5.Count - 1 do
    tempNode5b.ChildNodes.Add(tempNodeLst5[I]);
  tempNode0.Resync;

  // write characteristic runoff concentrations
  tempNodeLst6 := GSUtils.plrmGridDataToXML2('RunoffConcentrations1',
    runoffConcs, runoffConcsTags, tempLst, tempLst);
  tempNode6 := iNode.AddChild('RunoffConcentrations', '');
  for I := 0 to tempNodeLst4.Count - 1 do
    tempNode6.ChildNodes.Add(tempNodeLst6[I]);
  tempNode0.Resync;

  // write pollutant delivery factors
  tempNodeLst7 := GSUtils.plrmGridDataToXML2('PollutantDeliveryFactors1',
    pollDelFactors, pollDelFactorTags, tempLst, tempLst);
  tempNode7 := iNode.AddChild('PollutantDeliveryFactors', '');
  for I := 0 to tempNodeLst7.Count - 1 do
    tempNode7.ChildNodes.Add(tempNodeLst7[I]);
  tempNode0.Resync;

  XMLDoc := nil;
  Result := tempNode8;
end;

procedure TPLRMRdCondsScheme.readSchemeXML(iNode: IXMLNode);
var
  tempNode1: IXMLNode;
  tempNode2: IXMLNode;
  tempNode3: IXMLNode;
  tempNodeLst1: array [0 .. 2] of IXMLNode;
  tempNodeLst2: array [0 .. 2] of IXMLNode;
  tempNodeLst3: array [0 .. 2] of IXMLNode;
  I: Integer;
begin
  stype := iNode.Attributes['stype'];
  if ((stype <> 3) or (stype <> 4)) then

    id := String(iNode.Attributes['id']);
  name := iNode.Attributes['name'];
  catchName := iNode.Attributes['catchName'];
  description := iNode.Attributes['description'];

  // read abrasives application info
  tempNode1 := iNode.ChildNodes['RoadConditions'].ChildNodes
    ['RoadAbbrasiveAppl'];
  for I := 0 to High(cats) do
  begin
    tempNodeLst1[I] := tempNode1.ChildNodes[cats[I]];
    pollPotential[I][0] := tempNodeLst1[I].Text;
    pollPotentialIDs[I][0] := tempNode1.Attributes[cats[I]];
  end;

  // read sweeper type info
  tempNode2 := iNode.ChildNodes['RoadConditions'].ChildNodes['SweeperType'];
  for I := 0 to High(cats) do
  begin
    tempNodeLst2[I] := tempNode2.ChildNodes[cats[I]];
    pollPotential[I][1] := tempNodeLst2[I].Text;
    pollPotentialIDs[I][1] := tempNode2.Attributes[cats[I]];
  end;

  // read sweeping frequency info
  tempNode3 := iNode.ChildNodes['RoadConditions'].ChildNodes['SweepingFreq'];
  for I := 0 to High(cats) do
  begin
    tempNodeLst3[I] := tempNode3.ChildNodes[cats[I]];
    pollPotential[I][2] := tempNodeLst3[I].Text;
    pollPotentialIDs[I][2] := tempNode3.Attributes[cats[I]];
  end;
  shoulderConds := GSUtils.xmlAttribToPlrmGridData
    (iNode.ChildNodes['RoadShoulderConditions'], rdShouldrTags);
  pollDelFactors := GSUtils.xmlAttribToPlrmGridData
    (iNode.ChildNodes['PollutantDeliveryFactors'], pollDelFactorTags);
  rdReportCardPPS := GSUtils.xmlAttribToPlrmGridData
    (iNode.ChildNodes['PollutantPotentailScore'], reportCardTagsPPS);
  rdReportCardSES := GSUtils.xmlAttribToPlrmGridData
    (iNode.ChildNodes['SweeperEffectivenessScore'], reportCardTagsSES);
  runoffConcs := GSUtils.xmlAttribToPlrmGridData
    (iNode.ChildNodes['RunoffConcentrations'], runoffConcsTags);
end;

procedure TPLRMRdCondsScheme.readSchemeXML(filePath: String);
var
  XMLDoc: IXMLDocument;
  iNode: IXMLNode;
begin
  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.LoadFromFile(filePath);
  XMLDoc.Active := true;

  iNode := XMLDoc.ChildNodes['PLRM'].ChildNodes['Schemes'].ChildNodes['Scheme'];
  readSchemeXML(iNode);
  XMLDoc := nil;
end;

// function TPLRMRdCondsScheme.validate():TStringList;
// begin
//
// end;
{$ENDREGION}
{$REGION 'PLRMCatch class methods'}

// -----------------------------------------------------------------------------
// PLRMCatch class methods
// -----------------------------------------------------------------------------
constructor TPLRMCatch.Create;
var
  widthCalcFactors: dbReturnFields;
begin
  inherited Create;
  // initialize flags to false
  hasDefLuse := false;
  hasDefSoils := false;
  hasDefPSCs := false;
  hasDefDrnXtcs := false;
  hasDefRoadPolls := false;
  hasDefRoadDrainage := false;
  hasDefParcelAndDrainageBMPs := false;
  hasChangedSoils := false;
  // 2014
  isGISCatchment := false;

  landUseNames := TStringList.Create;
  soilsMapUnitNames := TStringList.Create;
  physclProps := GSUtils.getDefaultCatchProps();

  widthCalcFactors := GSIO.getDefaults('"4%"');
  // maxWidth := StrToFloat(widthCalcFactors[0][0]);
  MaxFloLength := StrToFloat(widthCalcFactors[0][0]);
  widthPower := StrToFloat(widthCalcFactors[0][1]);
  widthFactor := StrToFloat(widthCalcFactors[0][2]);
  defInfStorDepth := StrToFloat(widthCalcFactors[0][3]);
  tempMinArea := 0.001;
end;

destructor TPLRMCatch.Destroy;
var
  I: Integer;
begin

  // free arrays
  physclProps := nil;
  swmmCatchDefProps := nil;
  landUseData := nil;
  soilsMapUnitData := nil;
  soilsInfData := nil;
  rdRiskCats := nil;
  bmpImpl := nil;

  // free _PLRM5RoadDrnXtcs input
  secRdDrng := nil;
  primRdDrng := nil;
  sfrDrng := nil;
  mfrDrng := nil;
  cicuDrng := nil;
  vegTDrng := nil;
  othrDrng := nil;

  // free pointer to swmm catchment
  swmmCatch := nil;

  // free stringLists without objects
  FreeAndNil(landUseNames);
  FreeAndNil(soilsMapUnitNames);

  // Set schemes to nil, actual memory released in when Schemes destroyed
  // using scheme list. Not released here cause other catchments might still
  // be referencing them

  // Road condition schemes
  secRdRcSchm := nil;
  primRdRcSchm := nil;

  // Hyd prop schemes
  secRdSchm := nil;
  primRdSchm := nil;
  sfrSchm := nil;
  mfrSchm := nil;
  cicuSchm := nil;
  vegTSchm := nil;

  for I := 0 to 2 do
  begin
    // Set schemes to nil, actual memory released in when Schemes destroyed
    // using scheme list. Not released here cause other catchments might still
    // be referencing them
    secRdSchms[I] := nil;
    primRdSchms[I] := nil;
    sfrSchms[I] := nil;
    mfrSchms[I] := nil;
    cicuSchms[I] := nil;
    vegTSchms[I] := nil;
    othrSchms[I] := nil;
    // memory already free by another scheme pointing to same memeory
  end;

  for I := 0 to High(catchHydPropSchemes) do
  begin
    catchHydPropSchemes[I] := nil;
  end;

  inherited Destroy;
end;

procedure TPLRMCatch.copyHydSchemesToArray();
var
  I: Integer;
begin

  SetLength(catchHydPropSchemes, 7);
  for I := 0 to High(catchHydPropSchemes) do
    SetLength(catchHydPropSchemes[I], 3);

  catchHydPropSchemes[0, 0] := primRdSchms[0];
  catchHydPropSchemes[0, 1] := primRdSchms[1];
  catchHydPropSchemes[0, 2] := primRdSchms[2];

  catchHydPropSchemes[1, 0] := secRdSchms[0];
  catchHydPropSchemes[1, 1] := secRdSchms[1];
  catchHydPropSchemes[1, 2] := secRdSchms[2];

  catchHydPropSchemes[2, 0] := sfrSchms[0];
  catchHydPropSchemes[2, 1] := sfrSchms[1];
  catchHydPropSchemes[2, 2] := sfrSchms[2];

  catchHydPropSchemes[3, 0] := mfrSchms[0];
  catchHydPropSchemes[3, 1] := mfrSchms[1];
  catchHydPropSchemes[3, 2] := mfrSchms[2];

  catchHydPropSchemes[4, 0] := cicuSchms[0];
  catchHydPropSchemes[4, 1] := cicuSchms[1];
  catchHydPropSchemes[4, 2] := cicuSchms[2];

  catchHydPropSchemes[5, 0] := vegTSchms[0];
  catchHydPropSchemes[5, 1] := vegTSchms[1];
  catchHydPropSchemes[5, 2] := vegTSchms[2];

  catchHydPropSchemes[6, 0] := othrSchms[0];
  catchHydPropSchemes[6, 1] := othrSchms[1];
  catchHydPropSchemes[6, 2] := othrSchms[2];
end;

procedure TPLRMCatch.updateCurCatchProps(newName: String;
  physclProps: PLRMGridData; outGSNode: TPLRMNode);
begin
  name := newName;
  area := StrToFloat(physclProps[0, 1]);
  width := Power(area, widthPower);
  if (width > maxWidth) then
    width := maxWidth;
  slope := StrToFloat(physclProps[1, 1]);
  outNode := outGSNode;
  updateSWMM();
end;

procedure TPLRMCatch.updateSWMM();
var
  S: TSubCatch;
begin
  S := Project.Lists[SUBCATCH].Objects[ObjIndex] as TSubCatch;
  S.Data[SUBCATCH_AREA_INDEX] := FloatToStr(area);
  S.Data[SUBCATCH_WIDTH_INDEX] := FloatToStr(width);
  S.Data[SUBCATCH_SLOPE_INDEX] := FloatToStr(slope);
  if (assigned(outNode) and (outNode.userName <> '')) then
    S.Data[SUBCATCH_OUTLET_INDEX] := outNode.userName
  else
    S.Data[SUBCATCH_OUTLET_INDEX] := '*';
end;

function TPLRMCatch.catchToXML(projectLuseNames: TStringList;
  ProjectLuseCodes: TStringList): IXMLNode;
var
  XMLDoc: IXMLDocument;
  iNode: IXMLNode;
  tempNode, tempNode2, tempNode3: IXMLNode;
  tempNodeList: IXMLNodeList;
  luseTagList: TStringList;
  luseCodeList: TStringList;
  soilsTagList: TStringList;
  rdRiskTagList: TStringList;
  bmpImplTagList: TStringList;
  parcelAndRdMethTagList: TStringList;
  roadPollutantsRdShoulderTagList, roadPollutantsRdConditionTagList,
    parcelDrainageAndBMPsWithBMPTagList, parcelDrainageAndBMPsNoBMPTagList,
    roadPollutantsRdCRCTagList, rdShouldrCondsXMLTagList: TStringList;

  tempList: TStringList;
  tempList2: TStringList;
  tempList3: TStringList;
  tempListDrng0: TStringList;
  tempListDrng1: TStringList;
  tempListDrng2: TStringList;

  tempTextListDrng0: TStringList;
  tempTextListDrng1: TStringList;
  tempTextListDrng2: TStringList;
  runoffConcsTags: TStringList;

  I, J: Integer;
  schmIDs: array [0 .. 1] of Integer;
  tempBMPSizeGridArr: array [0 .. 2] of PLRMGridData;
  tempDrnGridArr: array [0 .. 6] of PLRMGridData;
  tempListDrngArr: array [0 .. 6] of TStringList;
  tempTextListDrngArr: array [0 .. 6] of TStringList;
  tempArea, tempToOutArea, tempToHscArea, tempHscArea, tempHscDepth,
    tempWidth: double;
  tempHSCParam: array [0 .. 2] of double;
  kSatMultplrs: dbReturnFields;
begin
  // offset used to exclude primary and secondary roads in land use arrays and lists
  // now filtering out prim and sec roads in landuse query since replaced by "Roads" so set offset to 0
  luseOffset := 2;
  try
    // get ksat multipliers - current used to calc ksat for othr landuse
    kSatMultplrs := GSIO.getDefaults('"7%"');

    // 2014 GIS catchments have ObjIndex set to -1 so do not updateSWMM
    if ObjIndex <> -1 then
      updateSWMM(); // write catchment info to swmm

    luseTagList := TStringList.Create;
    luseCodeList := TStringList.Create;
    soilsTagList := TStringList.Create;
    rdRiskTagList := TStringList.Create;
    bmpImplTagList := TStringList.Create;
    parcelAndRdMethTagList := TStringList.Create;

    // 2014 new tags for new form modifications
    roadPollutantsRdShoulderTagList := TStringList.Create;
    roadPollutantsRdConditionTagList := TStringList.Create;
    roadPollutantsRdCRCTagList := TStringList.Create;

    parcelDrainageAndBMPsWithBMPTagList := TStringList.Create;
    parcelDrainageAndBMPsNoBMPTagList := TStringList.Create;

    tempList := TStringList.Create;
    tempList2 := TStringList.Create;
    tempList3 := TStringList.Create;
    runoffConcsTags := TStringList.Create;
    tempListDrng0 := TStringList.Create;
    tempListDrng1 := TStringList.Create;
    tempListDrng2 := TStringList.Create;

    tempTextListDrng0 := TStringList.Create;
    tempTextListDrng1 := TStringList.Create;
    tempTextListDrng2 := TStringList.Create;

    XMLDoc := TXMLDocument.Create(nil);
    XMLDoc.Active := true;

    iNode := XMLDoc.AddChild('Catchment');
    iNode.Attributes['id'] := id;
    iNode.Attributes['ObjIndex'] := intToStr(ObjIndex);
    iNode.Attributes['ObjType'] := intToStr(ObjType);
    iNode.Attributes['name'] := name;
    iNode.Attributes['hasDefLuse'] := hasDefLuse;
    iNode.Attributes['hasDefSoils'] := hasDefSoils;
    iNode.Attributes['hasDefPSCs'] := hasDefPSCs;
    iNode.Attributes['hasphysclProps'] := hasPhysclProps;
    iNode.Attributes['hasDefDrnXtcs'] := hasDefDrnXtcs;
    iNode.Attributes['hasDefRoadPolls'] := hasDefRoadPolls;
    iNode.Attributes['hasDefRoadDrainage'] := hasDefRoadDrainage;
    iNode.Attributes['hasDefParcelAndDrainageBMPs'] :=
      hasDefParcelAndDrainageBMPs;
    iNode.Attributes['hasDefCustomBMPSizeData'] := hasDefCustomBMPSizeData;

    if (ObjIndex <> -1) then
    begin
      iNode.Attributes['area'] := swmmCatch.Data[Uproject.SUBCATCH_AREA_INDEX];
      iNode.Attributes['slope'] := swmmCatch.Data
        [Uproject.SUBCATCH_SLOPE_INDEX];
    end
    else
    begin
      iNode.Attributes['area'] := FormatFloat(TWODP, area);
      iNode.Attributes['slope'] := FormatFloat(TWODP, slope);
    end;

    if assigned(outNode) then
    begin
      iNode.Attributes['outNode'] := outNode.userName;
      // must be the same as tempOutNodeID
      tempOutNodeID := outNode.userName;
    end
    else
      iNode.Attributes['outNode'] := '';

    iNode.Attributes['totOthrArea'] := FloatToStr(othrArea);

    for I := 0 to High(luseXMLTags) do
      luseTagList.Add(luseXMLTags[I]);

    for I := 0 to High(soilsXMLTags) do
      soilsTagList.Add(soilsXMLTags[I]);

    for I := 0 to High(rdRiskCatXMLTags) do
      rdRiskTagList.Add(rdRiskCatXMLTags[I]);

    for I := 0 to High(bmpImplXMLTags) do
      bmpImplTagList.Add(bmpImplXMLTags[I]);

    for I := 0 to High(parcelAndRdMethXMLTags) do
      parcelAndRdMethTagList.Add(parcelAndRdMethXMLTags[I]);

    // begin 2014 additions
    for I := 0 to High(roadPollutantsRdShoulderTags) do
      roadPollutantsRdShoulderTagList.Add(roadPollutantsRdShoulderTags[I]);

    for I := 0 to High(roadPollutantsRdConditionTags) do
      roadPollutantsRdConditionTagList.Add(roadPollutantsRdConditionTags[I]);

    for I := 0 to High(roadPollutantsRdCRCTags) do
      roadPollutantsRdCRCTagList.Add(roadPollutantsRdCRCTags[I]);

    for I := 0 to High(parcelDrainageAndBMPsWithBMPTags) do
      parcelDrainageAndBMPsWithBMPTagList.Add
        (parcelDrainageAndBMPsWithBMPTags[I]);

    for I := 0 to High(parcelDrainageAndBMPsNoBMPTags) do
      parcelDrainageAndBMPsNoBMPTagList.Add(parcelDrainageAndBMPsNoBMPTags[I]);
    // end 2014 additions

    // 2014 add defaults section for default catchment parameters soils depr stor etc
    tempNode3 := iNode.AddChild('Defaults', '');
    tempNode := tempNode3.AddChild('GreenAmpt', '');

    tempNode2 := tempNode.AddChild('Ksat', '');

    if (not(assigned(soilsInfData))) then
    begin
      if (assigned(soilsMapUnitData)) then
        soilsInfData := GSIO.getSoilsProps(soilsMapUnitData);
    end;

    if (assigned(soilsInfData)) then
    begin
      tempNode2.Attributes['default'] := soilsInfData[0, 1];
      tempNode2.Attributes['units'] := 'in/hr';
      tempNode2.Text := soilsInfData[0, 1];

      tempNode2 := tempNode.AddChild('Ssh', '');
      tempNode2.Attributes['default'] := soilsInfData[0, 2];
      tempNode2.Attributes['units'] := 'in';
      tempNode2.Text := soilsInfData[0, 2];

      tempNode2 := tempNode.AddChild('Smd', '');
      tempNode2.Attributes['default'] := soilsInfData[0, 3];
      tempNode2.Attributes['units'] := 'in';
      tempNode2.Text := soilsInfData[0, 3];
    end;

    luseCodeList := lookUpCodeFrmName(landUseData, 0, projectLuseNames,
      ProjectLuseCodes);
    // write all land uses info
    if (assigned(landUseData)) then
    begin
      tempNodeList := GSUtils.swmmInptFileLandUseToXML('LandUse', landUseData,
        luseTagList, 0, luseCodeList);
      FreeAndNil(luseCodeList);
      tempNode := iNode.AddChild('LandUses', '');
      for I := 0 to tempNodeList.Count - 1 do
        tempNode.ChildNodes.Add(tempNodeList[I]);
      tempNode.Resync;
    end;

    // write soils info
    if (assigned(soilsMapUnitData)) then
    begin
      tempNodeList := GSUtils.swmmInptFileSoilsToXML('Soil', soilsMapUnitData,
        soilsTagList, 0);
      tempNode := iNode.AddChild('Soils', '');
      for I := 0 to tempNodeList.Count - 1 do
        tempNode.ChildNodes.Add(tempNodeList[I]);
      tempNode.Resync;
    end;

    // push parcel land uses into utilty list for use below
    tempList2.Add(frmsLuseCodes[2]);
    tempList2.Add(frmsLuseCodes[3]);
    tempList2.Add(frmsLuseCodes[4]);
    tempList2.Add(frmsLuseCodes[5]);
    tempList2.Add(frmsLuseCodes[6]);

    // 2014 write step 4of6 Road Pollutants form contents
    // push parcel land uses into utilty list for use below
    if (assigned(frm4of6SgRoadShoulderData)) then
    begin
      // create parent tag
      tempNode := iNode.AddChild('frm4of6RoadPollutants', '');

      // create no Road Conditions child node
      // tempList3   is convenience function to allow reuse of same xml functions. Contents not needed
      // last row of  frm4of6SgRoadConditionData contains extra row that was displayed to let user know grid grows
      // so do not copy it. If you do default condition score may cause a duplicate landuse in [LANDUSE] block
      if (assigned(frm4of6SgRoadConditionData)) then
      begin
        for I := 0 to High(frm4of6SgRoadConditionData) do
          tempList3.Add(intToStr(I));
        GSUtils.createAndAttachChildNode(tempNode, 'rdConditions',
          'rdCondition', frm4of6SgRoadConditionData,
          roadPollutantsRdConditionTagList, tempList3);
      end;

      // create Road Shoulder Erosion child node
      // tempList3   is convenience function to allow reuse of same xml functions. Contents not needed
      if (assigned(frm4of6SgRoadShoulderData)) then
      begin
        for I := 0 to High(frm4of6SgRoadShoulderData) do
          tempList3.Add(intToStr(I));
        GSUtils.createAndAttachChildNode(tempNode, 'rdShoulderErosionPrcnts',
          'rdShoulderErosionPrcnt', frm4of6SgRoadShoulderData,
          roadPollutantsRdShoulderTagList, tempList3);
      end;

      // create no Road CRCs child node
      // tempList3   is convenience function to allow reuse of same xml functions. Contents not needed
      if (assigned(frm4of6SgRoadCRCsData)) then
      begin
        tempList3 := TStringList.Create();
        for I := 0 to High(frm4of6SgRoadCRCsData) do
          tempList3.Add(intToStr(I));
        GSUtils.createAndAttachChildNode(tempNode, 'rdCRCs', 'rdCRC',
          frm4of6SgRoadCRCsData, roadPollutantsRdCRCTagList, tempList3);
        tempNode.Resync;
      end;
    end;

    // 2014 write step 5of6 Raod Drainage Editor form inputs
    // *******************************************************************************
    // create parent tag
    tempNode3 := iNode.AddChild('frm5of6RoadDrainageEditor', '');
    tempNode := tempNode3.AddChild('AllRoads', '');

    // Ave annual inf rate for all road shoulders
    tempNode.Attributes['shoulderAveAnnInfRate'] :=
      frm5of6RoadDrainageEditorData.shoulderAveAnnInfRate;
    tempNode.Attributes['roadArea'] := totRoadAcres;
    tempNode.Attributes['roadImpervArea'] := totRoadImpervAcres;

    // DCIA  - directly connected impervious area
    tempNode2 := tempNode.AddChild('DCIA', '');
    tempNode2.Attributes['areaPrcnt'] :=
      FormatFloat(TWODP, frm5of6RoadDrainageEditorData.DCIA);

    // ICIA   - indirectly connected impervious area
    tempNode2 := tempNode.AddChild('ICIA', '');
    tempNode2.Attributes['areaPrcnt'] :=
      FormatFloat(TWODP, frm5of6RoadDrainageEditorData.ICIA);

    // DINF   - infiltration facility
    tempNode2 := tempNode.AddChild('DINF', '');
    tempNode2.Attributes['areaPrcnt'] :=
      FormatFloat(TWODP, frm5of6RoadDrainageEditorData.DINF);
    tempNode2.Attributes['totSurfArea'] :=
      frm5of6RoadDrainageEditorData.INFFacility.totSurfaceArea;
    tempNode2.Attributes['totStorage'] :=
      frm5of6RoadDrainageEditorData.INFFacility.totStorage;
    tempNode2.Attributes['aveAnnInfRate'] :=
      frm5of6RoadDrainageEditorData.INFFacility.aveAnnInfiltrationRate;

    // DPCH   - pervious drainage channel
    tempNode2 := tempNode.AddChild('DPCH', '');
    tempNode2.Attributes['areaPrcnt'] :=
      FormatFloat(TWODP, frm5of6RoadDrainageEditorData.DPCH);
    tempNode2.Attributes['length'] :=
      frm5of6RoadDrainageEditorData.PervChanFacility.length;
    tempNode2.Attributes['width'] :=
      frm5of6RoadDrainageEditorData.PervChanFacility.width;
    tempNode2.Attributes['aveSlope'] :=
      frm5of6RoadDrainageEditorData.PervChanFacility.aveSlope;
    tempNode2.Attributes['storageDepth'] :=
      frm5of6RoadDrainageEditorData.PervChanFacility.storageDepth;
    tempNode2.Attributes['aveAnnInfRate'] :=
      frm5of6RoadDrainageEditorData.PervChanFacility.aveAnnInfiltrationRate;
    tempNode.Resync;

    // create swmm inputs tag and nodes
    // **************************************************************
    tempNode := tempNode3.AddChild('swmmInputs', '');
    tempNode.Attributes['tag'] := 'Road';
    tempNode.Attributes['roadArea'] := totRoadAcres;
    tempNode.Attributes['roadImpervArea'] := totRoadImpervAcres;
    tempNode.Attributes['shoulderAveAnnInfRate'] :=
      frm5of6RoadDrainageEditorData.shoulderAveAnnInfRate;

    // OUT using DCIA + ICIA  - directly connected impervious area
    tempArea := (frm5of6RoadDrainageEditorData.ICIA +
      frm5of6RoadDrainageEditorData.DCIA) * totRoadAcres / 100;
    if (tempArea > tempMinArea) then
    begin
      tempNode2 := tempNode.AddChild('Out', '');
      tempNode2.Attributes['name'] := 'DCIA+ICIA';
      tempNode2.Attributes['areaPrcnt'] := frm5of6RoadDrainageEditorData.DCIA +
        frm5of6RoadDrainageEditorData.ICIA;
      tempNode2.Attributes['areaAc'] := tempArea;
      tempNode2.Attributes['impervArea'] :=
        (frm5of6RoadDrainageEditorData.ICIA +
        frm5of6RoadDrainageEditorData.DCIA) * totRoadImpervAcres / 100;

      // calc catchment width
      { tempArea := tempArea * 43560;
        // tempWidth := Math.Power(tempArea * widthFactor, widthPower);
        tempWidth := widthFactor * Math.Power(tempArea, widthPower);
        if tempWidth > maxWidth then
        tempWidth := maxWidth;
        // tempWidth := tempArea / tempFloLength; }

      tempArea := tempArea * 43560;
      tempFloLength := Math.Power(tempArea * widthFactor, widthPower);
      if tempFloLength > MaxFloLength then
        tempFloLength := MaxFloLength;
      tempWidth := tempArea / tempFloLength;
      tempNode2.Attributes['width'] := tempWidth;
    end;

    // ICIA   - indirectly connected impervious area
    // tempArea := frm5of6RoadDrainageEditorData.ICIA * totRoadAcres / 100;
    // if (tempArea > tempMinArea) then
    // begin
    tempArea := frm5of6RoadDrainageEditorData.ICIA * totRoadAcres / 100;
    tempNode2 := tempNode.AddChild('ICIA', '');
    tempNode2.Attributes['name'] := 'ICIA';
    tempNode2.Attributes['areaPrcnt'] := frm5of6RoadDrainageEditorData.ICIA;
    tempNode2.Attributes['areaAc'] := tempArea;
    tempNode2.Attributes['impervArea'] := frm5of6RoadDrainageEditorData.ICIA *
      totRoadImpervAcres / 100;

    // calc catchment width
    { tempArea := tempArea * 43560;
      // tempWidth := Math.Power(tempArea * widthFactor, widthPower);
      tempWidth := widthFactor * Math.Power(tempArea, widthPower);
      if tempWidth > maxWidth then
      tempWidth := maxWidth; }

    tempArea := tempArea * 43560;
    tempFloLength := Math.Power(tempArea * widthFactor, widthPower);
    if tempFloLength > MaxFloLength then
      tempFloLength := MaxFloLength;
    tempWidth := tempArea / tempFloLength;

    if (tempArea = 0) then
      // tempWidth := 0
      tempNode2.Attributes['width'] := tempWidth
    else
      // tempWidth := tempArea / tempFloLength;
      tempNode2.Attributes['width'] := tempWidth;
    // end;

    // DINF   - infiltration facility
    tempArea := frm5of6RoadDrainageEditorData.DINF * totRoadAcres / 100;
    if (tempArea > tempMinArea) then
    begin
      tempNode2 := tempNode.AddChild('Inf', '');
      tempNode2.Attributes['name'] := 'DINF';
      tempNode2.Attributes['areaPrcnt'] := frm5of6RoadDrainageEditorData.DINF;
      tempNode2.Attributes['areaAc'] := tempArea;
      tempNode2.Attributes['impervArea'] := frm5of6RoadDrainageEditorData.DINF *
        totRoadImpervAcres / 100;

      // calc catchment width
      tempArea := tempArea * 43560;
      tempFloLength := Math.Power(tempArea * widthFactor, widthPower);
      if tempFloLength > MaxFloLength then
        tempFloLength := MaxFloLength;
      tempWidth := tempArea / tempFloLength;

      { // tempWidth := Math.Power(tempArea * widthFactor, widthPower);
        tempWidth := widthFactor * Math.Power(tempArea, widthPower);
        if tempWidth > maxWidth then
        tempWidth := maxWidth;
        // tempWidth := tempArea / tempFloLength; }
      tempNode2.Attributes['width'] := tempWidth;
      // calc hsc width
      tempArea := frm5of6RoadDrainageEditorData.INFFacility.totSurfaceArea;
      { // tempWidth := Math.Power(tempArea * widthFactor, widthPower);
        tempWidth := widthFactor * Math.Power(tempArea, widthPower);
        if tempWidth > maxWidth then
        tempWidth := maxWidth; }

      tempArea := tempArea * 1;
      // no need to convert to sq.ft since alread in sq.ft 43560;
      tempFloLength := Math.Power(tempArea * widthFactor, widthPower);
      if tempFloLength > MaxFloLength then
        tempFloLength := MaxFloLength;
      tempWidth := tempArea / tempFloLength;

      if (tempArea < tempMinArea) then
        tempWidth := 0;
      // else
      // tempWidth := tempArea / tempFloLength;

      tempNode2.Attributes['hscWidth'] := tempWidth;

      tempNode2.Attributes['totSurfArea'] :=
        frm5of6RoadDrainageEditorData.INFFacility.totSurfaceArea;
      tempNode2.Attributes['totStorage'] :=
        frm5of6RoadDrainageEditorData.INFFacility.totStorage;
      tempNode2.Attributes['aveAnnInfRate'] :=
        frm5of6RoadDrainageEditorData.INFFacility.aveAnnInfiltrationRate;
    end;

    // DPCH   - pervious drainage channel
    tempArea := frm5of6RoadDrainageEditorData.DPCH * totRoadAcres / 100;
    if (tempArea > tempMinArea) then
    begin
      tempNode2 := tempNode.AddChild('Pch', '');
      tempNode2.Attributes['name'] := 'DPCH';
      tempNode2.Attributes['areaPrcnt'] := frm5of6RoadDrainageEditorData.DPCH;
      tempNode2.Attributes['areaAc'] := tempArea;
      tempNode2.Attributes['impervArea'] := frm5of6RoadDrainageEditorData.DPCH *
        totRoadImpervAcres / 100;

      // calc catchment width
      tempArea := tempArea * 43560;
      { tempWidth := widthFactor * Math.Power(tempArea, widthPower);
        if tempWidth > maxWidth then
        tempWidth := maxWidth; }

      tempFloLength := Math.Power(tempArea * widthFactor, widthPower);
      if tempFloLength > MaxFloLength then
        tempFloLength := MaxFloLength;
      tempWidth := tempArea / tempFloLength;

      tempNode2.Attributes['width'] := tempWidth;
      // calc hsc width
      //tempArea := frm5of6RoadDrainageEditorData.PervChanFacility.length *
      //  frm5of6RoadDrainageEditorData.PervChanFacility.width;
      // tempArea := tempArea;
      { tempFloLength := Math.Power(tempArea * widthFactor, widthPower);
        if tempFloLength > maxFloLength then
        tempFloLength := maxFloLength;
        tempWidth := tempArea / tempFloLength;
        tempNode2.Attributes['hscWidth'] := tempWidth; }
      tempNode2.Attributes['hscWidth'] :=
        2 * frm5of6RoadDrainageEditorData.PervChanFacility.width;

      tempNode2.Attributes['ftprintlength'] :=
        frm5of6RoadDrainageEditorData.PervChanFacility.length;
      tempNode2.Attributes['ftprintwidth'] :=
        frm5of6RoadDrainageEditorData.PervChanFacility.width;
      tempNode2.Attributes['aveSlope'] :=
        frm5of6RoadDrainageEditorData.PervChanFacility.aveSlope;
      tempNode2.Attributes['storageDepth'] :=
        frm5of6RoadDrainageEditorData.PervChanFacility.storageDepth;
      tempNode2.Attributes['aveAnnInfRate'] :=
        frm5of6RoadDrainageEditorData.PervChanFacility.aveAnnInfiltrationRate;
    end;
    tempNode.Resync;

    // 2014 write step 6of6 Parcel Drainage and BMPs form contents
    // ************************************************************************
    if (assigned(frm6of6SgBMPImplData) and assigned(frm6of6SgNoBMPsData)) then
    begin
      // create parent tag
      tempNode := iNode.AddChild('frm6of6ParcelDrainageAndBMPs', '');

      // create functioning BMPs child node
      GSUtils.createAndAttachChildNode(tempNode, 'functioningBMPs',
        'functioningBMP', frm6of6SgBMPImplData,
        parcelDrainageAndBMPsWithBMPTagList, tempList2);

      // create no BMPs child node
      GSUtils.createAndAttachChildNode(tempNode, 'noBMPs', 'noBMP',
        frm6of6SgNoBMPsData, parcelDrainageAndBMPsNoBMPTagList, tempList2);

      // create no BMP sizing child node
      tempNode3 := tempNode.AddChild('BMPSizingData', '');

      // add BMP sizing grandchild nodes
      if (hasDefCustomBMPSizeData) then
      begin
        tempBMPSizeGridArr[0] := frm6of6aSgBMPSizeSFRData;
        tempBMPSizeGridArr[1] := frm6of6aSgBMPSizeMFRData;
        tempBMPSizeGridArr[2] := frm6of6aSgBMPSizeCICUData;
        for I := 0 to High(tempBMPSizeGridArr) do
        begin
          tempNode2 := tempNode3.AddChild(tempList2[I], '');
          tempNode2.Attributes['hscStorageDepth'] := tempBMPSizeGridArr
            [I][0, 0];
          tempNode2.Attributes['hscAveAnnInfRate'] :=
            tempBMPSizeGridArr[I][1, 0];
          tempNode2.Text := tempList2[I];
        end;
      end;

      // create swmm inputs tag and nodes
      // **************************************************************
      tempNode := tempNode.AddChild('swmmInputs', '');
      // loop through and build swmm inputs section
      for I := 0 to High(frm6of6SgBMPImplData) do
      begin
        if (frm6of6AreasData.luseAreaNImpv[I + luseOffset][0] <> '') then
        begin
          tempNode3 := tempNode.AddChild('swmmInput', '');
          tempArea := StrToFloat(frm6of6AreasData.luseAreaNImpv
            [I + luseOffset][0]);
          if (tempArea > tempMinArea) then
          begin
            tempNode3.Attributes['percentBMPs'] := frm6of6SgBMPImplData[I, 0];
            tempNode3.Attributes['percentNoBMPs'] := frm6of6SgNoBMPsData[I, 0];
            tempNode3.Attributes['percentSrcCtrls'] :=
              frm6of6SgBMPImplData[I, 1];
            tempNode3.Attributes['areaAc'] := tempArea;
            tempNode3.Attributes['impervArea'] :=
              StrToFloat(frm6of6AreasData.luseAreaNImpv[I + luseOffset][1]);
            tempNode3.Attributes['percentDCIA'] := frm6of6SgNoBMPsData[I, 1];
            tempNode3.Attributes['ksat'] := frm6of6SgNoBMPsData[I, 2];

            tempToOutArea := tempArea * (StrToFloat(frm6of6SgBMPImplData[I, 1])
              + StrToFloat(frm6of6SgNoBMPsData[I, 0])) / 100;
            tempNode3.Attributes['areaAcToOut'] := tempToOutArea;

            tempToHscArea := tempArea *
              StrToFloat(frm6of6SgBMPImplData[I, 0]) / 100;
            tempNode3.Attributes['areaAcToHsc'] := tempToHscArea;

            if (I <= High(tempBMPSizeGridArr)) then
            begin
              tempHscArea :=
                StrToFloat(frm6of6AreasData.luseAreaNImpv[I + luseOffset][1]) *
                StrToFloat(frm6of6SgBMPImplData[I, 0]) * 0.01 *
                StrToFloat(tempBMPSizeGridArr[I][0, 0]) * 3630 / 2 / 43560;
            end
            else
            begin
              tempHscArea := 0;
            end;

            tempNode3.Attributes['hscArea'] := tempHscArea;

            // only SFR,MFR,CICU have BMP sizes
            // if ((I >= luseOffset) and (I-luseOffset <= High(tempBMPSizeGridArr))) then
            if (I <= High(tempBMPSizeGridArr)) then
            begin
              if (assigned(tempBMPSizeGridArr[I])) then
              begin
                tempNode3.Attributes['hscAveAnnInfRate'] :=
                  tempBMPSizeGridArr[I][1, 0];
                tempNode3.Attributes['hscStorageDepth'] :=
                  tempBMPSizeGridArr[I][0, 0];
              end;
            end;
            tempNode3.Text := tempList2[I];

            // calc *ToOut catchment width
            { tempWidth := widthFactor * Math.Power(tempToOutArea * 43560,
              widthPower);
              if tempWidth > maxWidth then
              tempWidth := maxWidth; }
            tempArea := tempToOutArea * 43560;
            tempFloLength := Math.Power(tempArea * widthFactor, widthPower);
            if tempFloLength > MaxFloLength then
              tempFloLength := MaxFloLength;
            tempWidth := tempArea / tempFloLength;
            tempNode3.Attributes['widthToOut'] := tempWidth;

            // calc *ToInf catchment width
            { tempWidth := widthFactor * Math.Power(tempToHscArea * 43560,
              widthPower);
              if tempWidth > maxWidth then
              tempWidth := maxWidth; }
            tempArea := tempToHscArea * 43560;
            tempFloLength := Math.Power(tempArea * widthFactor, widthPower);
            if tempFloLength > MaxFloLength then
              tempFloLength := MaxFloLength;
            tempWidth := tempArea / tempFloLength;
            tempNode3.Attributes['widthToInf'] := tempWidth;

            // calc hsc width
            // TODO confirm that hsc area - catchment area
            // tempWidth := Math.Power(tempArea * widthFactor, widthPower);
            { tempWidth := widthFactor * Math.Power(tempHscArea * 43560,
              widthPower);
              if tempWidth > maxWidth then
              tempWidth := maxWidth; }
            tempArea := tempHscArea * 43560;
            tempFloLength := Math.Power(tempArea * widthFactor, widthPower);
            if tempFloLength > MaxFloLength then
              tempFloLength := MaxFloLength;
            tempWidth := tempArea / tempFloLength;
            tempNode3.Attributes['hscWidth'] := tempWidth;
            if tempArea = 0 then
              tempNode3.Attributes['hscWidth'] := 0;

          end
          else
          begin
            // need to write to xml even though blank to maintain order and position need to align with landuses when we read back in
            tempNode3.Attributes['percentBMPs'] := '0';
            tempNode3.Attributes['percentNoBMPs'] := '0';
            tempNode3.Attributes['percentSrcCtrls'] := '0';
            tempNode3.Attributes['areaAc'] := '0';
            tempNode3.Attributes['impervArea'] := '0';
            tempNode3.Attributes['percentDCIA'] := '50';
            tempNode3.Attributes['ksat'] := '0';
            tempNode3.Attributes['hscArea'] := '0';
            tempNode3.Attributes['hscAveAnnInfRate'] := '0';
            tempNode3.Attributes['hscStorageDepth'] := '0';
            tempNode3.Text := tempList2[I];
            tempNode3.Attributes['width'] := '0';
            tempNode3.Attributes['hscWidth'] := '0';
          end;
        end;
      end;
      // write othr area which is not displayed in the frm5of6 grid to the user but must be modeled in swmm
      if (othrArea <> 0) then
      begin
        tempNode3 := tempNode.AddChild('swmmInput', '');
        tempNode3.Attributes['percentBMPs'] := '0';
        tempNode3.Attributes['percentNoBMPs'] := '100';
        tempNode3.Attributes['percentSrcCtrls'] := '0';
        tempNode3.Attributes['areaAc'] := othrArea;
        tempNode3.Attributes['impervArea'] := othrPrcntImpv;
        tempNode3.Attributes['percentDCIA'] := '50';

        // NB: For ksat multipliers othr comes after roads so not
        tempNode3.Attributes['ksat'] :=
          FormatFloat('0.##', (StrToFloat(soilsInfData[0, 1]) *
          StrToFloat(kSatMultplrs[0][othrLandUseArrIndex - 1])));

        tempNode3.Attributes['hscArea'] := '0';
        tempNode3.Attributes['hscAveAnnInfRate'] := '0';
        tempNode3.Attributes['hscStorageDepth'] := '0';
        tempNode3.Attributes['areaAcToOut'] := othrArea;
        tempNode3.Attributes['areaAcToHsc'] := '0';
        tempNode3.Attributes['widthToInf'] := '0';
        tempNode3.Text := 'Othr';
        tempArea := othrArea * 43560;
        tempFloLength := Math.Power(tempArea * widthFactor, widthPower);
        if tempFloLength > MaxFloLength then
          tempFloLength := MaxFloLength;
        tempWidth := tempArea / tempFloLength;

        { // tempWidth := Math.Power(tempArea * widthFactor, widthPower);
          tempWidth := widthFactor * Math.Power(tempArea, widthPower);
          if tempWidth > maxWidth then
          tempWidth := maxWidth;
          // tempWidth := tempArea / tempFloLength; }
        tempNode3.Attributes['width'] := tempWidth;
        tempNode3.Attributes['widthToOut'] := tempWidth;
        tempNode3.Attributes['hscWidth'] := '0';
      end;
      tempNode.Resync;
    end;

    // write road risk categories
    if (assigned(rdRiskCats)) then
    begin
      tempList.Add(frmsLuseCodes[0]);
      tempList.Add(frmsLuseCodes[1]);
      tempNodeList := GSUtils.plrmGridDataToXML('RoadRiskCat', rdRiskCats,
        rdRiskTagList, tempList);
      tempNode := iNode.AddChild('RoadRiskCategories', '');
      tempNode.Attributes['primSchmID'] := primSchmID;
      tempNode.Attributes['secSchmID'] := secSchmID;
      schmIDs[0] := primSchmID;
      schmIDs[1] := secSchmID;
      for I := 0 to tempNodeList.Count - 1 do
      begin
        tempNodeList[I].Attributes['schmID'] := schmIDs[I];
        tempNode.ChildNodes.Add(tempNodeList[I]);
      end;
      tempNode.Resync;
    end;

    // write bmp implementation
    if (assigned(bmpImpl)) then
    begin
      tempNodeList := GSUtils.plrmGridDataToXML('BmpImpl', bmpImpl,
        bmpImplTagList, tempList2);
      tempNode := iNode.AddChild('BmpImplementation', '');
      for I := 0 to tempNodeList.Count - 1 do
        tempNode.ChildNodes.Add(tempNodeList[I]);
      tempNode.Resync;
    end;
    //
    // write road and parcel methodology
    if hasDefDrnXtcs then
    begin
      tempNode := iNode.AddChild('ParcelAndRdMethXMLTags', '');

      // to be used for secondary and primary roads
      tempListDrng0.Add('Inf');
      tempListDrng0.Add('Dsp');
      tempListDrng0.Add('Out');

      // to be used for parcels
      tempListDrng1.Add('Inf');
      tempListDrng1.Add('Out');

      // to be used for pervious areas
      tempListDrng2.Add('Out');

      // text tags to be used for secondary and primary roads
      tempTextListDrng0.Add('Infiltration Areas');
      tempTextListDrng0.Add('Dispersion Areas');
      tempTextListDrng0.Add('Direct to outlet');

      // text tags to be used for parcels
      tempTextListDrng1.Add('Infiltration Areas');
      tempTextListDrng1.Add('Direct to outlet');

      // text tags to be used for pervious areas
      tempTextListDrng2.Add('Direct to outlet');

      tempListDrngArr[0] := tempListDrng0;
      tempListDrngArr[1] := tempListDrng0;
      tempListDrngArr[2] := tempListDrng1;
      tempListDrngArr[3] := tempListDrng1;
      tempListDrngArr[4] := tempListDrng1;
      tempListDrngArr[5] := tempListDrng2;
      tempListDrngArr[6] := tempListDrng2;

      tempTextListDrngArr[0] := tempTextListDrng0;
      tempTextListDrngArr[1] := tempTextListDrng0;
      tempTextListDrngArr[2] := tempTextListDrng1;
      tempTextListDrngArr[3] := tempTextListDrng1;
      tempTextListDrngArr[4] := tempTextListDrng1;
      tempTextListDrngArr[5] := tempTextListDrng2;
      tempTextListDrngArr[6] := tempTextListDrng2;

      tempDrnGridArr[0] := primRdDrng;
      tempDrnGridArr[1] := secRdDrng;
      tempDrnGridArr[2] := sfrDrng;
      tempDrnGridArr[3] := mfrDrng;
      tempDrnGridArr[4] := cicuDrng;
      tempDrnGridArr[5] := vegTDrng;
      tempDrnGridArr[6] := othrDrng;

      for I := 0 to High(frmsLuses) do
      begin
        tempNode2 := tempNode.AddChild(frmsLuseTags[I], '');
        tempNode2.Attributes['tag'] := frmsLuseCodes[I];
        tempHSCParam[0] := 0;
        // for inf
        tempHSCParam[1] := 0; // for dsp
        tempHSCParam[2] := 0; // for out
        case I of
          0: // Primary Roads
            begin
              if (primRdSchms[0] <> nil) then
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[0]] :=
                  primRdSchms[0].id
              else
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[0]] := '-1';
              if (primRdSchms[1] <> nil) then
              begin
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[1]] :=
                  primRdSchms[1].id;
                tempHSCParam[0] := StrToFloat(primRdSchms[1].hydPropsHSC[0, 2])
                  * StrToFloat(primRdDrng[0, 2]) * CONVCUFT;
                // inf numbers in first row of grid at index 0
              end
              else
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[1]] := '-1';
              if (primRdSchms[2] <> nil) then
              begin
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[2]] :=
                  primRdSchms[2].id;
                tempHSCParam[1] := StrToFloat(primRdSchms[2].hydPropsHSC[0, 2])
                // * strToFloat(primRdDrng[1,2])* CONVCUFT; //dsp numbers in second row of grid at index 1
              end
              else
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[2]] := '-1';
            end;
          1: // Secondary Roads
            begin
              if (secRdSchms[0] <> nil) then
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[0]] :=
                  secRdSchms[0].id
              else
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[0]] := '-1';
              if (secRdSchms[1] <> nil) then
              begin
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[1]] :=
                  secRdSchms[1].id;
                tempHSCParam[0] := StrToFloat(secRdSchms[1].hydPropsHSC[0, 2]) *
                  StrToFloat(secRdDrng[0, 2]) * CONVCUFT;
                // inf numbers in first row of grid at index 0
              end
              else
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[1]] := '-1';
              if (secRdSchms[2] <> nil) then
              begin
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[2]] :=
                  secRdSchms[2].id;
                tempHSCParam[1] := StrToFloat(secRdSchms[2].hydPropsHSC[0, 2])
                // * strToFloat(secRdDrng[1,2])* CONVCUFT; //dsp numbers in second row of grid at index 1
              end
              else
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[2]] := '-1';
            end;

          2: // SFR
            begin
              if (sfrSchms[0] <> nil) then
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[0]] :=
                  sfrSchms[0].id
              else
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[0]] := '-1';
              if (sfrSchms[1] <> nil) then
              begin
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[1]] :=
                  sfrSchms[1].id;
                tempHSCParam[0] := StrToFloat(sfrSchms[1].hydPropsHSC[0, 2]) *
                  StrToFloat(sfrDrng[0, 2]) * CONVCUFT;
                // inf numbers in second row of grid at index 0
              end
              else
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[1]] := '-1';
              tempNode2.Attributes[drngSchmTypeXMLAttribTags[2]] := '-1';
            end;
          3:
            // MFR
            begin
              if (mfrSchms[0] <> nil) then
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[0]] :=
                  mfrSchms[0].id
              else
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[0]] := '-1';
              if (mfrSchms[1] <> nil) then
              begin
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[1]] :=
                  mfrSchms[1].id;
                tempHSCParam[0] := StrToFloat(mfrSchms[1].hydPropsHSC[0, 2]) *
                  StrToFloat(mfrDrng[0, 2]) * CONVCUFT;
                // inf numbers in second row of grid at index 0
              end
              else
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[1]] := '-1';
              tempNode2.Attributes[drngSchmTypeXMLAttribTags[2]] := '-1';
            end;
          4:
            // CICU
            begin
              if (cicuSchms[0] <> nil) then
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[0]] :=
                  cicuSchms[0].id
              else
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[0]] := '-1';
              if (cicuSchms[1] <> nil) then
              begin
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[1]] :=
                  cicuSchms[1].id;
                tempHSCParam[0] := StrToFloat(cicuSchms[1].hydPropsHSC[0, 2]) *
                  StrToFloat(cicuDrng[0, 2]) * CONVCUFT;
                // inf numbers in second row of grid at index 0
              end
              else
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[1]] := '-1';
              tempNode2.Attributes[drngSchmTypeXMLAttribTags[2]] := '-1';
            end;
          5:
            // VegT
            begin
              if (vegTSchms[0] <> nil) then
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[0]] :=
                  vegTSchms[0].id
              else
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[0]] := '-1';
              tempNode2.Attributes[drngSchmTypeXMLAttribTags[1]] := '-1';
              tempNode2.Attributes[drngSchmTypeXMLAttribTags[2]] := '-1';
            end;
          6:
            // Othr
            begin
              if (othrSchms[0] <> nil) then
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[0]] :=
                  othrSchms[0].id
              else
                tempNode2.Attributes[drngSchmTypeXMLAttribTags[0]] := '-1';
              tempNode2.Attributes[drngSchmTypeXMLAttribTags[1]] := '-1';
              tempNode2.Attributes[drngSchmTypeXMLAttribTags[2]] := '-1';
            end;
        end;

        tempNodeList := GSUtils.plrmGridDataToXML('meth', tempDrnGridArr[I],
          parcelAndRdMethTagList, tempTextListDrngArr[I], tempListDrngArr[I]);
        for J := 0 to tempNodeList.Count - 1 do
        begin
          // get area, calc width if area is not 0 and add it as an attribute
          tempArea := StrToFloat(tempNodeList[J].Attributes['areaAc'])
            * CONVACFT;

          // 2014 if tempArea <> 0 then
          // 2014 do not attempt to model landuses with areas less than 0.001 acres
          if tempArea > 0.001 then
          begin
            // tempWidth := Math.Power(tempArea * widthFactor, widthPower);
            tempWidth := widthFactor * Math.Power(tempArea, widthPower);
            if tempWidth > maxWidth then
              tempWidth := maxWidth;
            // tempWidth := tempArea / tempFloLength;
            tempNodeList[J].Attributes['width'] :=
              FormatFloat('0.0', tempWidth);
          end;
          // tempWidth := 0;

          // calc hsc footprint area and width
          if J = 0 then
            tempHSCParam[J] := tempHSCParam[J] / (defInfStorDepth * CONVACFT)
          else
            tempHSCParam[J] := tempHSCParam[J] / CONVACFT;

          tempArea := tempHSCParam[J];
          // 2014 if tempArea <> 0 then
          // 2014 do not attempt to model hscs with areas less than 0.01 acres
          if tempArea > 0.001 then
          begin
            // tempWidth := Math.Power(tempArea * widthFactor, widthPower);
            tempWidth := widthFactor * Math.Power(tempArea, widthPower);
            if tempWidth > maxWidth then
              tempWidth := maxWidth;
            // tempWidth := (tempArea * CONVACFT) / tempFloLength;
            tempNodeList[J].Attributes['hscArea'] :=
              FormatFloat('0.000', tempArea);
            tempNodeList[J].Attributes['hscWidth'] :=
              FormatFloat('0.000', tempWidth);
          end;
          // tempWidth := 0;
          tempNode2.ChildNodes.Add(tempNodeList[J]);
        end;
        tempNode2.Resync;
      end;
    end;
    // end;
    Result := iNode;
    iNode := nil;
    tempNode := nil;
    tempNode2 := nil;
    tempNodeList := nil;
    luseTagList.Free;
    soilsTagList.Free;
    rdRiskTagList.Free;
    bmpImplTagList.Free;
    parcelAndRdMethTagList.Free;
    roadPollutantsRdShoulderTagList.Free;
    roadPollutantsRdConditionTagList.Free;

    tempList.Free;
    tempList2.Free;
    FreeAndNil(tempListDrng0);
    FreeAndNil(tempListDrng1);
    FreeAndNil(tempListDrng2);

    FreeAndNil(tempTextListDrng0);
    FreeAndNil(tempTextListDrng1);
    FreeAndNil(tempTextListDrng2);

  except
    on E: Exception do
    begin
      Showmessage('Exception class name = ' + E.ClassName);
      Showmessage('Exception message = ' + E.Message);
    end;
  end;
end;

procedure TPLRMCatch.xmlToCatch(iNode: IXMLNode; hydSchemes: TStringList;
  rcSchemes: TStringList);
var
  luseTagList, tempList: TStringList;
  soilsTagList: TStringList;
  rdRiskTagList: TStringList;
  bmpImplTagList: TStringList;
  parcelAndRdMethTagList: TStringList;
  roadPollutantsRdShoulderTagList, roadPollutantsRdConditionTagList,
    parcelDrainageAndBMPsWithBMPTagList, parcelDrainageAndBMPsNoBMPTagList,
    roadPollutantsRdCRCTagList, rdShouldrCondsXMLTagList: TStringList;
  I, tempInt: Integer;
  tempNode, tempNode2: IXMLNode;
  tempDrnGridArr: array [0 .. High(GSUtils.frmsLuses)] of PLRMGridData;
  tempBMPSizeGridArr: array [0 .. 2] of PLRMGridData;
  // tempId: array [0 .. 2] of Integer;
begin
  // offset used to exclude primary and secondary roads in land use arrays and lists
  luseOffset := 2;

  luseTagList := TStringList.Create;
  soilsTagList := TStringList.Create;
  rdRiskTagList := TStringList.Create;
  bmpImplTagList := TStringList.Create;
  parcelAndRdMethTagList := TStringList.Create;

  // 2014 new tags for new form modifications
  roadPollutantsRdShoulderTagList := TStringList.Create;
  roadPollutantsRdConditionTagList := TStringList.Create;
  roadPollutantsRdCRCTagList := TStringList.Create;

  parcelDrainageAndBMPsWithBMPTagList := TStringList.Create;
  parcelDrainageAndBMPsNoBMPTagList := TStringList.Create;

  id := iNode.Attributes['id']; // represents index of object in swmm
  name := iNode.Attributes['name'];
  hasDefLuse := iNode.Attributes['hasDefLuse'];
  hasDefSoils := iNode.Attributes['hasDefSoils'];
  hasDefPSCs := iNode.Attributes['hasDefPSCs'];
  hasDefDrnXtcs := iNode.Attributes['hasDefDrnXtcs'];
  hasPhysclProps := iNode.Attributes['hasphysclProps'];

  hasDefRoadPolls := iNode.Attributes['hasDefRoadPolls'];
  hasDefRoadDrainage := iNode.Attributes['hasDefRoadDrainage'];
  hasDefParcelAndDrainageBMPs := iNode.Attributes
    ['hasDefParcelAndDrainageBMPs'];
  hasDefCustomBMPSizeData := iNode.Attributes['hasDefCustomBMPSizeData'];

  ObjIndex := strToInt(iNode.Attributes['ObjIndex']);
  ObjType := strToInt(iNode.Attributes['ObjType']);
  othrArea := StrToFloat(iNode.Attributes['totOthrArea']);

  physclProps[0, 1] := iNode.Attributes['area'];
  physclProps[1, 1] := iNode.Attributes['slope'];

  tempOutNodeID := iNode.Attributes['outNode'];
  area := StrToFloat(physclProps[0, 1]);
  slope := StrToFloat(physclProps[1, 1]);

  for I := 0 to High(luseXMLTags) do
    luseTagList.Add(luseXMLTags[I]);

  for I := 0 to High(soilsXMLTags) do
    soilsTagList.Add(soilsXMLTags[I]);

  for I := 0 to High(rdRiskCatXMLTags) do
    rdRiskTagList.Add(rdRiskCatXMLTags[I]);

  for I := 0 to High(bmpImplXMLTags) do
    bmpImplTagList.Add(bmpImplXMLTags[I]);

  for I := 0 to High(parcelAndRdMethXMLTags) do
    parcelAndRdMethTagList.Add(parcelAndRdMethXMLTags[I]);
  // begin 2014 additions
  for I := 0 to High(roadPollutantsRdShoulderTags) do
    roadPollutantsRdShoulderTagList.Add(roadPollutantsRdShoulderTags[I]);

  for I := 0 to High(roadPollutantsRdConditionTags) do
    roadPollutantsRdConditionTagList.Add(roadPollutantsRdConditionTags[I]);

  for I := 0 to High(roadPollutantsRdCRCTags) do
    roadPollutantsRdCRCTagList.Add(roadPollutantsRdCRCTags[I]);

  for I := 0 to High(parcelDrainageAndBMPsWithBMPTags) do
    parcelDrainageAndBMPsWithBMPTagList.Add
      (parcelDrainageAndBMPsWithBMPTags[I]);

  for I := 0 to High(parcelDrainageAndBMPsNoBMPTags) do
    parcelDrainageAndBMPsNoBMPTagList.Add(parcelDrainageAndBMPsNoBMPTags[I]);
  // end 2014 additions

  // read land uses info
  landUseData := xmlAttribToPlrmGridData(iNode.ChildNodes['LandUses'],
    luseTagList);
  for I := 0 to High(landUseData) do
    landUseNames.Add(landUseData[I, 0]);
  // read soils info
  soilsMapUnitData := xmlToPLRMGridData(iNode.ChildNodes['Soils'],
    soilsTagList);
  for I := 0 to High(soilsMapUnitData) do
    soilsMapUnitNames.Add(soilsMapUnitData[I, 0]);

  // 2014 read step 4of6 Road Pollutants form contents
  // access parent tag
  tempNode := iNode.ChildNodes['frm4of6RoadPollutants'];
  if (assigned(tempNode)) then
  begin

    // create Road Shoulder Erosion child node
    GSUtils.xmlAttachedChildNodesToPLRMGridData(tempNode,
      'rdShoulderErosionPrcnts', 'rdShoulderErosionPrcnt',
      frm4of6SgRoadShoulderData, roadPollutantsRdShoulderTagList);

    // create no Road Conditions child node
    GSUtils.xmlAttachedChildNodesToPLRMGridData(tempNode, 'rdConditions',
      'rdCondition', frm4of6SgRoadConditionData,
      roadPollutantsRdConditionTagList);

    // create no Road CRCs child node
    GSUtils.xmlAttachedChildNodesToPLRMGridData(tempNode, 'rdCRCs', 'rdCRC',
      frm4of6SgRoadCRCsData, roadPollutantsRdCRCTagList);
  end;

  // 2014 write step 5of6 Raod Drainage Editor form inputs
  // create parent tag
  tempNode := iNode.ChildNodes['frm5of6RoadDrainageEditor'];
  tempNode := tempNode.ChildNodes['AllRoads'];
  if (assigned(tempNode)) then
  begin

    // Ave annual inf rate for all road shoulders
    frm5of6RoadDrainageEditorData.shoulderAveAnnInfRate :=
      StrToFloat(tempNode.Attributes['shoulderAveAnnInfRate']);
    totRoadAcres := StrToFloat(tempNode.Attributes['roadArea']);
    totRoadImpervAcres := StrToFloat(tempNode.Attributes['roadImpervArea']);

    // DCIA  - directly connected impervious area
    tempNode2 := tempNode.ChildNodes['DCIA'];
    if (assigned(tempNode2)) then
    begin
      frm5of6RoadDrainageEditorData.DCIA :=
        StrToFloat(tempNode2.Attributes['areaPrcnt']);
    end;

    // ICIA   - indirectly connected impervious area
    tempNode2 := tempNode.ChildNodes['ICIA'];
    if (assigned(tempNode2)) then
    begin
      frm5of6RoadDrainageEditorData.ICIA :=
        StrToFloat(tempNode2.Attributes['areaPrcnt']);
    end;

    // DINF   - infiltration facility
    tempNode2 := tempNode.ChildNodes['DINF'];
    if (assigned(tempNode2)) then
    begin
      frm5of6RoadDrainageEditorData.DINF :=
        StrToFloat(tempNode2.Attributes['areaPrcnt']);
      frm5of6RoadDrainageEditorData.INFFacility.totSurfaceArea :=
        StrToFloat(tempNode2.Attributes['totSurfArea']);
      frm5of6RoadDrainageEditorData.INFFacility.totStorage :=
        StrToFloat(tempNode2.Attributes['totStorage']);
      frm5of6RoadDrainageEditorData.INFFacility.aveAnnInfiltrationRate :=
        StrToFloat(tempNode2.Attributes['aveAnnInfRate']);
    end;

    // DPCH   - pervious drainage channel
    tempNode2 := tempNode.ChildNodes['DPCH'];
    if (assigned(tempNode2)) then
    begin
      frm5of6RoadDrainageEditorData.DPCH :=
        StrToFloat(tempNode2.Attributes['areaPrcnt']);
      frm5of6RoadDrainageEditorData.PervChanFacility.length :=
        StrToFloat(tempNode2.Attributes['length']);
      frm5of6RoadDrainageEditorData.PervChanFacility.width :=
        StrToFloat(tempNode2.Attributes['width']);
      frm5of6RoadDrainageEditorData.PervChanFacility.aveSlope :=
        StrToFloat(tempNode2.Attributes['aveSlope']);
      frm5of6RoadDrainageEditorData.PervChanFacility.storageDepth :=
        StrToFloat(tempNode2.Attributes['storageDepth']);
      frm5of6RoadDrainageEditorData.PervChanFacility.aveAnnInfiltrationRate :=
        StrToFloat(tempNode2.Attributes['aveAnnInfRate']);
    end;

    // sentinel
    frm5of6RoadDrainageEditorData.isAssigned := true;
  end;

  // 2014 read step 6of6 Parcel Drainage and BMPs form contents
  // access parent tag
  tempNode := iNode.ChildNodes['frm6of6ParcelDrainageAndBMPs'];
  if (assigned(tempNode)) then
  begin
    // create functioning BMPs child node
    GSUtils.xmlAttachedChildNodesToPLRMGridData(tempNode, 'functioningBMPs',
      'functioningBMP', frm6of6SgBMPImplData,
      parcelDrainageAndBMPsWithBMPTagList);

    // create no BMPs child node
    GSUtils.xmlAttachedChildNodesToPLRMGridData(tempNode, 'noBMPs', 'noBMP',
      frm6of6SgNoBMPsData, parcelDrainageAndBMPsNoBMPTagList);

    // add BMP sizing grandchild nodes
    if (hasDefCustomBMPSizeData) then
    begin
      // tempNode := iNode.ChildNodes['frm6of6ParcelDrainageAndBMPs'];
      tempNode := tempNode.ChildNodes['BMPSizingData'];
      if (assigned(tempNode)) then
      begin

        SetLength(frm6of6aSgBMPSizeSFRData, 2, 1);
        SetLength(frm6of6aSgBMPSizeMFRData, 2, 1);
        SetLength(frm6of6aSgBMPSizeCICUData, 2, 1);
        tempBMPSizeGridArr[0] := frm6of6aSgBMPSizeSFRData;
        tempBMPSizeGridArr[1] := frm6of6aSgBMPSizeMFRData;
        tempBMPSizeGridArr[2] := frm6of6aSgBMPSizeCICUData;
        for I := 0 to High(tempBMPSizeGridArr) do
        begin
          tempNode2 := tempNode.ChildNodes[frmsLuseCodes[I + luseOffset]];
          if (assigned(tempNode2)) then
          begin
            tempBMPSizeGridArr[I][0, 0] := tempNode2.Attributes
              ['hscStorageDepth'];
            tempBMPSizeGridArr[I][1, 0] := tempNode2.Attributes
              ['hscAveAnnInfRate'];
          end;
        end;
      end;
    end;
  end;

  // read in select swmm inputs so that if user opens old file and immediately trys to
  // run we can recreate swmm inputs section of step 6 of 6
  tempNode := iNode.ChildNodes['frm6of6ParcelDrainageAndBMPs'];
  tempNode := tempNode.ChildNodes['swmmInputs'];

  // loop through and read area and imperv acres from swmm inputs section
  SetLength(frm6of6AreasData.luseAreaNImpv, High(frmsLuseCodes) + 1, 2);

  // setup land use code look up
  tempList := TStringList.Create;
  // Add Landuses to StringList to allow indexof
  for I := 0 to High(frmsLuseCodes) do
  begin
    tempList.Add(frmsLuseCodes[I]);
  end;

  for I := 0 to tempNode.ChildNodes.Count - 1 do
  begin
    tempNode2 := tempNode.ChildNodes[I];
    if (tempNode2.Attributes['areaAc'] <> '0') then
    begin
      tempInt := tempList.IndexOf(tempNode2.Text);
      if (tempInt > -1) then
      begin
        frm6of6AreasData.luseAreaNImpv[tempInt][0] := tempNode2.Attributes
          ['areaAc'];
        frm6of6AreasData.luseAreaNImpv[tempInt][1] := tempNode2.Attributes
          ['impervArea'];
      end;
    end;
  end;

  // read road risk categories
  if assigned(iNode.ChildNodes['RoadRiskCategories']) then
  begin
    rdRiskCats := GSUtils.xmlAttribToPlrmGridData
      (iNode.ChildNodes['RoadRiskCategories'], rdRiskTagList);
    if (iNode.ChildNodes['RoadRiskCategories'].HasAttribute('secSchmID')) then
      secSchmID := iNode.ChildNodes['RoadRiskCategories'].Attributes
        ['secSchmID'];
    if (iNode.ChildNodes['RoadRiskCategories'].HasAttribute('primSchmID')) then
      primSchmID := iNode.ChildNodes['RoadRiskCategories'].Attributes
        ['primSchmID'];
  end;
  if assigned(iNode.ChildNodes['BmpImplementation']) then
    bmpImpl := GSUtils.xmlAttribToPlrmGridData
      (iNode.ChildNodes['BmpImplementation'], bmpImplTagList);

  for I := 0 to High(frmsLuses) do
  begin
    tempNode := iNode.ChildNodes['ParcelAndRdMethXMLTags'].ChildNodes
      [frmsLuseTags[I]];
    if (assigned(tempNode)) then
    begin
      tempDrnGridArr[I] := GSUtils.xmlAttribToPlrmGridData(tempNode,
        parcelAndRdMethTagList);
      // tempId[0] := hydSchemes.IndexOf(tempNode.Attributes[drngSchmTypeXMLAttribTags[0]]);
      // tempId[1] := hydSchemes.IndexOf(tempNode.Attributes[drngSchmTypeXMLAttribTags[1]]);
      // tempId[2] := hydSchemes.IndexOf(tempNode.Attributes[drngSchmTypeXMLAttribTags[2]]);
    end;
  end;
  primRdDrng := tempDrnGridArr[0];
  secRdDrng := tempDrnGridArr[1];
  sfrDrng := tempDrnGridArr[2];
  mfrDrng := tempDrnGridArr[3];
  cicuDrng := tempDrnGridArr[4];
  vegTDrng := tempDrnGridArr[5];
  othrDrng := tempDrnGridArr[6];

end;

// Typeflag = 0 - drng area ksat, 1 - bmp ksat
function TPLRMCatch.getKSat(typeFlag: Integer): double;
begin
  if typeFlag = 0 then
    Result := StrToFloat(soilsInfData[0][0])
  else
    Result := StrToFloat(soilsInfData[0][1])
end;

function TPLRMCatch.getKSatPerv(typeFlag: Integer): double;
begin
  Result := StrToFloat(soilsInfData[0][0])
end;

function TPLRMCatch.getKSatBMP(typeFlag: Integer): double;
begin
  Result := StrToFloat(soilsInfData[0][1])
end;

function TPLRMCatch.getIMD(): double;
begin
  Result := StrToFloat(soilsInfData[0][3]);
end;

function TPLRMCatch.getSuct(): double;
begin
  Result := StrToFloat(soilsInfData[0][4]);
end;
{$ENDREGION}

end.
