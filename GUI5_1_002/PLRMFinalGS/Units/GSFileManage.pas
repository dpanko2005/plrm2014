unit GSFileManage;

interface

uses
  SysUtils, Windows, Messages, Classes, Controls, Forms, Dialogs, XMLIntf,
  msxmldom, XMLDoc,
  StdCtrls, ComCtrls, Grids, GSUtils, GSTypes, Uproject, GSCatchments, GSNodes,
  GSPLRM;

type
  TProjTree = Class
  public
    PID: TStringList;
    // project id string list with string lists of scenario IDs
    PrjNames: TStringList;
    // user supplied project names string list with string list of user scenario names

    function getPrjIDFromUserName(userPrjName: String): String;
    function getScenIDFromUserName(prjID: String; userScenName: String): String;
    procedure addNewPrj(defaultPrjID: String; defaultScenID: String);
    procedure addNewScn(prjID, scnID, scnUserName: String);
    procedure deleteScn(prjID, scnID, scnUserName: String);
    procedure renameScen(prjID: String; oldUserScenName: String;
      newUserScenName: String);
    procedure copyPrj(frmPrjID, newPrjID, newPrjUserName: String);
    function checkProjNameUsed(newPrjName: String): Boolean;
    function checkScnNameUsed(newPrjName: String; newScenName: String): Boolean;
    constructor Create();
    Destructor Destroy; override;
  end;

  // memory management
var
  PLRMTree: TProjTree;

implementation

uses
  GSIO, Uvalidate;

{$REGION 'PLRM class methods'}

constructor TProjTree.Create();
begin
  PID := TStringList.Create;
  PrjNames := TStringList.Create;

end;

destructor TProjTree.Destroy;
begin
  // Release memory, if obtained
  if PID <> nil then
    FreeStringListObjects(PID);
  if PrjNames <> nil then
    FreeStringListObjects(PrjNames);
  // Always call the parent destructor after running your own code
  inherited;
end;

function TProjTree.getPrjIDFromUserName(userPrjName: String): String;
var
  tempStr: String;
  tempInt: Integer;
begin
  tempInt := PLRMTree.PrjNames.IndexOf(userPrjName);
  if (tempInt <> -1) then
  begin
    tempStr := PLRMTree.PrjNames[tempInt];
    if userPrjName = tempStr then
      Result := PLRMTree.PID[tempInt];
  end;
end;

function TProjTree.getScenIDFromUserName(prjID: String;
  userScenName: String): String;
var
  scnID: String;
  tempSL: TStringList;
  prjIdx: Integer;
  scnName: String;
  I: Integer;
begin
  prjIdx := PLRMTree.PID.IndexOf(prjID);
  tempSL := (PLRMTree.PrjNames.Objects[prjIdx]) as TStringList;
  for I := 0 to tempSL.Count - 1 do
  begin
    scnName := tempSL[I];
    scnID := (PLRMTree.PID.Objects[prjIdx] as TStringList)[I];
    if userScenName = scnName then
      Result := scnID;
  end;
  if Result = '' then
    ShowMessage('No ID found for ' + userScenName);
end;

procedure TProjTree.addNewPrj(defaultPrjID: String; defaultScenID: String);
var
  tempSL1, tempSL2: TStringList;
begin
  tempSL1 := TStringList.Create;
  tempSL2 := TStringList.Create;
  tempSL1.Add(defaultScenID);
  tempSL2.Add(defaultScenID);
  PLRMTree.PID.AddObject(defaultPrjID, tempSL1);
  PLRMTree.PrjNames.AddObject(defaultPrjID, tempSL2);
end;

procedure TProjTree.copyPrj(frmPrjID, newPrjID, newPrjUserName: String);
var
  frmScnSL1, frmScnSL2, toScnSL1, toScnSL2: TStringList;
  // scenario IDs and scenario names, respectively
  prjIdx: Integer;
  I: Integer;
begin
  // get from project names
  prjIdx := PLRMTree.PID.IndexOf(frmPrjID);
  frmScnSL1 := (PLRMTree.PID.Objects[prjIdx] as TStringList);
  frmScnSL2 := (PLRMTree.PrjNames.Objects[prjIdx] as TStringList);

  toScnSL1 := TStringList.Create;
  toScnSL2 := TStringList.Create;
  for I := 0 to frmScnSL1.Count - 1 do
  begin
    toScnSL1.Add(frmScnSL1[I]);
    toScnSL2.Add(frmScnSL2[I]);
  end;
  PLRMTree.PID.AddObject(newPrjID, toScnSL1);
  PLRMTree.PrjNames.AddObject(newPrjUserName, toScnSL2);
end;

procedure TProjTree.addNewScn(prjID, scnID, scnUserName: String);
var
  prjIdx: Integer;
begin
  prjIdx := PLRMTree.PID.IndexOf(prjID);
  ((PLRMTree.PID.Objects[prjIdx]) as TStringList).Add(scnID);
  ((PLRMTree.PrjNames.Objects[prjIdx]) as TStringList).Add(scnUserName);
end;

procedure TProjTree.deleteScn(prjID, scnID, scnUserName: String);
var
  prjIdx: Integer;
  scnIdx:Integer;
begin
  prjIdx := PLRMTree.PID.IndexOf(prjID);

  scnIdx :=    ((PLRMTree.PID.Objects[prjIdx]) as TStringList).IndexOf(scnID);
  if(scnIdx <> -1) then
    ((PLRMTree.PID.Objects[prjIdx]) as TStringList).Delete(scnIdx);

  scnIdx :=    ((PLRMTree.PrjNames.Objects[prjIdx]) as TStringList).IndexOf(scnID);
  if(scnIdx <> -1) then
    ((PLRMTree.PrjNames.Objects[prjIdx]) as TStringList).Delete(scnIdx);
end;


procedure TProjTree.renameScen(prjID: String; oldUserScenName: String;
  newUserScenName: String);
var
  scnID: String;
  prjIdx: Integer;
  scnIdx: Integer;
begin
  prjIdx := PLRMTree.PID.IndexOf(prjID);
  scnID := PLRMTree.getScenIDFromUserName(prjID, oldUserScenName);
  scnIdx := ((PLRMTree.PID.Objects[prjIdx]) as TStringList).IndexOf(scnID);
  ((PLRMTree.PrjNames.Objects[prjIdx]) as TStringList)[scnIdx] :=
    newUserScenName;
end;

function TProjTree.checkProjNameUsed(newPrjName: String): Boolean;
var
  tempInt: Integer;
begin
  tempInt := PLRMTree.PrjNames.IndexOf(newPrjName);
  if tempInt <> -1 then
    Result := true
  else
    Result := false;
end;

function TProjTree.checkScnNameUsed(newPrjName: String;
  newScenName: String): Boolean;
var
  tempInt: Integer;
begin
  tempInt := PLRMTree.PrjNames.IndexOf(newPrjName);
  tempInt := ((PLRMTree.PrjNames.Objects[tempInt]) as TStringList)
    .IndexOf(newScenName);
  if tempInt <> -1 then
    Result := true
  else
    Result := false;
end;

end.
