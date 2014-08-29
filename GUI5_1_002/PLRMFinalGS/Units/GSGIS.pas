unit GSGIS;

interface

uses
  SysUtils, Windows, Messages, Classes, Controls, Forms, Dialogs, XMLIntf,
  msxmldom, XMLDoc, Generics.Collections,
  StdCtrls, ComCtrls, Grids, GSUtils, GSTypes, Uproject, Math, GSNodes;

// 2014 - GISTool data
type
  PLRMGISData = record
    shpFilesDict: TDictionary<String, String>;
    manualBMPGridEntries: PLRMGridData;
  end;

type
  TPLRMGIS = class
    PLRMGISRec: PLRMGISData;

    constructor Create;
    destructor Destroy; override;

    function toXML(): IXMLNode;
    procedure fromXML(iNode: IXMLNode);
  end;

implementation

// class constructor
constructor TPLRMGIS.Create;
begin
  inherited Create;
end;

// class destructor
destructor TPLRMGIS.Destroy;
begin
end;

// serializes to XML
function TPLRMGIS.toXML(): IXMLNode;
var
  XMLDoc: IXMLDocument;
  iNode: IXMLNode;
  tempNode, tempNode2: IXMLNode;
  tempNodeList: IXMLNodeList;
  luseTagList: TStringList;
//  luseCodeList: TStringList;
  soilsTagList: TStringList;
  rdRiskTagList: TStringList;

  tempList: TStringList;
  tempList2: TStringList;
//  tempList3: TStringList;
//  tempListDrng0: TStringList;
//  tempListDrng1: TStringList;
//  tempListDrng2: TStringList;

//  tempTextListDrng0: TStringList;
//  tempTextListDrng1: TStringList;
//  tempTextListDrng2: TStringList;
//  runoffConcsTags: TStringList;

//  I, J: Integer;
//  tempStr: String;
  tempPair: TPair<String, String>;
begin
  if (assigned(PLRMGISRec.shpFilesDict) and (PLRMGISRec.shpFilesDict.Count < 1)) then
  begin
    Result := nil;
    exit;
  end;

  XMLDoc := TXMLDocument.Create(nil);
  XMLDoc.Active := true;

  iNode := XMLDoc.AddChild('GIS');

  // 1. serialize shapefile paths
  tempNode := iNode.AddChild('Paths', '');
  try

    for tempPair in PLRMGISRec.shpFilesDict do
    begin
      tempNode2 := tempNode.AddChild('Path', '');
      tempNode2.Attributes['key'] := tempPair.Key;
      tempNode2.Attributes['val'] := tempPair.Value;
    end;
    tempNode.Resync;

  finally
    PLRMGISRec.shpFilesDict.Free;
  end;

  Result := iNode;
  iNode := nil;
  tempNode := nil;
  tempNode2 := nil;
  tempNodeList := nil;
  luseTagList.Free;
  soilsTagList.Free;
  rdRiskTagList.Free;
  tempList.Free;
  tempList2.Free;
end;

// deserializes from XML
procedure TPLRMGIS.fromXML(iNode: IXMLNode);
begin

end;

end.
