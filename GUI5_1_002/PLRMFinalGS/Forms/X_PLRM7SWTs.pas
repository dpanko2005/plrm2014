unit _PLRM7SWTs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, Grids, ComCtrls, GSPLRM,GSNodes;

type
  TSWTs = class(TForm)
    pgCtrl: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox5: TGroupBox;
    sgDetEffl: TStringGrid;
    GroupBox6: TGroupBox;
    Button1: TButton;
    sgDetDgnProps: TStringGrid;
    TabSheet2: TTabSheet;
    TabSheet6: TTabSheet;
    Image1: TImage;
    btnOk: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    Label8: TLabel;
    cbxSelDetNode: TComboBox;
    lblDetSchm: TLabel;
    StatusBar1: TStatusBar;
    tbxDetName: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    cbxDetOutlet: TComboBox;
    GroupBox3: TGroupBox;
    Image2: TImage;
    Image4: TImage;
    cbxSelInfNode: TComboBox;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    tbxInfName: TEdit;
    cbxInfOutlet: TComboBox;
    GroupBox2: TGroupBox;
    sgInfDgnProps: TStringGrid;
    Image3: TImage;
    cbxSelHydNode: TComboBox;
    Label9: TLabel;
    GroupBox7: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    tbxHydName: TEdit;
    cbxHydOutlet: TComboBox;
    GroupBox8: TGroupBox;
    lblHydSchm: TLabel;
    sgHydDgnProps: TStringGrid;
    GroupBox9: TGroupBox;
    sgHydEffl: TStringGrid;
    TabSheet5: TTabSheet;
    TabSheet3: TTabSheet;
    Label13: TLabel;
    cbxSelCrtNode: TComboBox;
    Image5: TImage;
    GroupBox10: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    tbxCrtName: TEdit;
    cbxCrtOutlet: TComboBox;
    GroupBox11: TGroupBox;
    lblFiltSchm: TLabel;
    sgCrtDgnProps: TStringGrid;
    Label17: TLabel;
    cbxSelWetNode: TComboBox;
    Image6: TImage;
    GroupBox13: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    tbxWetName: TEdit;
    cbxWetOutlet: TComboBox;
    GroupBox14: TGroupBox;
    lblWetlSchm: TLabel;
    Button5: TButton;
    sgWetDgnProps: TStringGrid;
    GroupBox15: TGroupBox;
    sgWetEffl: TStringGrid;
    GroupBox12: TGroupBox;
    sgCrtEffl: TStringGrid;
    TabSheet4: TTabSheet;
    Label36: TLabel;
    cbxSelGrnNode: TComboBox;
    GroupBox28: TGroupBox;
    Label37: TLabel;
    Label38: TLabel;
    tbxGrnName: TEdit;
    cbxGrnOutlet: TComboBox;
    Image13: TImage;
    GroupBox29: TGroupBox;
    Label39: TLabel;
    sgGrnDgnProps: TStringGrid;
    GroupBox30: TGroupBox;
    sgGrnEffl: TStringGrid;
    TabSheet7: TTabSheet;
    gbFlowDividers: TGroupBox;
    Label7: TLabel;
    Label12: TLabel;
    tbxFldName: TEdit;
    cbxFldLowFlowNode: TComboBox;
    tbxFldFlowRate: TEdit;
    Label16: TLabel;
    cbxFldHighFlowNode: TComboBox;
    Label20: TLabel;
    GroupBox4: TGroupBox;
    sgInfEffl: TStringGrid;
    lblInfSchm: TLabel;
    cbxSelFldNode: TComboBox;
    Image7: TImage;
    Label1: TLabel;
    TabSheet8: TTabSheet;
    gbJunctions: TGroupBox;
    Label21: TLabel;
    Label22: TLabel;
    Image8: TImage;
    Label25: TLabel;
    tbxJunName: TEdit;
    cbxJunOutNode: TComboBox;
    cbxSelJunNode: TComboBox;
    TabSheet9: TTabSheet;
    gbOutfalls: TGroupBox;
    Label24: TLabel;
    Image9: TImage;
    Label26: TLabel;
    tbxOutName: TEdit;
    cbxSelOutNode: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure lblDetSchmMouseEnter(Sender: TObject);
    procedure lblDetSchmMouseLeave(Sender: TObject);

    procedure lblMouseEnter(Sender: TObject);
    procedure lblMouseLeave(Sender: TObject);

    procedure lblDetSchmClick(Sender: TObject);
    procedure lblInfSchmClick(Sender: TObject);
    procedure lblHydSchmClick(Sender: TObject);
    procedure lblFiltSchmClick(Sender: TObject);
    procedure lblWetlSchmClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure genericApply(var cbxNode:TComboBox; var tbxName:TEdit; var cbxOutlet:TComboBox; var sgDgn:TStringGrid; var sgEffl:TStringGrid);
    procedure sgDetDgnPropsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgDetDgnPropsSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
    procedure sgDetEfflDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgDetEfflSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
    procedure cbxSelDetNodeOnChange(Sender: TObject);
    procedure cbxDetOutletOnChange(Sender: TObject);

    procedure sgInfDgnPropsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgInfDgnPropsSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
    procedure cbxSelInfNodeOnChange(Sender: TObject);

    procedure sgWetDgnPropsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgWetDgnPropsSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
    procedure sgWetEfflDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgWetEfflSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
    procedure cbxSelWetNodeOnChange(Sender: TObject);

    procedure sgGrnDgnPropsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgGrnDgnPropsSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
    procedure sgGrnEfflDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgGrnEfflSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
    procedure cbxSelGrnNodeOnChange(Sender: TObject);

    procedure sgCrtDgnPropsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgCrtDgnPropsSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
    procedure sgCrtEfflDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgCrtEfflSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
    procedure cbxSelCrtNodeOnChange(Sender: TObject);

    procedure sgHydDgnPropsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgHydDgnPropsSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
    procedure sgHydEfflDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgHydEfflSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
    procedure cbxSelHydNodeOnChange(Sender: TObject);

    procedure cbxSelFldNodeOnChange(Sender: TObject);
    procedure cbxOutNodeOnChange(Sender: TObject);
    procedure cbxFldHighFlowNodeOnChange(Sender: TObject);
    procedure cbxSelJunNodeOnChange(Sender: TObject);
    procedure cbxSelOutNodeOnChange(Sender: TObject);

      private
    { Private declarations }
    procedure initOrRestoreContents(var sgDgnProps:TStringGrid; var sgEffl:TStringGrid; qryStrCode:String;var cbxNode:TCombobox; var txtName:TEdit;var cbxOutlet:TCombobox);overload;
    procedure initOrRestoreContents(var sgDgnProps:TStringGrid; var sgEffl:TStringGrid;
                    qryStrCode:String;var cbxNode:TCombobox;var txtName:TEdit;var cbxOutlet:TCombobox; var Node:TPLRMNode);overload;
  public
    { Public declarations }
  end;
procedure getSWTProps(nodeID:String; swtTypeNum:Integer);
function getSWTTypeNodes(swtType: Integer) : TStringList;
function getAllExceptCurrentNode(): TStringList;
function getNodeType(nodeType : Integer) : TStringList;
function getNodeNamefromNodeId(nodeID:String):String;

const
  ACTIVECOLOR = 12632256;
  PASSIVECOLOR = -16777211;

var
  SWTs: TSWTs;
  swtType:Integer;
  initNodeID:String;

implementation

{$R *.dfm}
uses
GSIO, GSUtils, GSTypes, UProject,UGlobals, _PLRMD4Schematics, UEdit, Umap, Fmap;

procedure getSWTProps(nodeID:String; swtTypeNum:Integer);
  var
    tempInt : Integer;
    I: Integer;
  begin
    initNodeID := nodeID;
    swtType := swtTypeNum ;
    SWTs := TSWTs.Create(Application);

    for I := 0 to SWTs.pgCtrl.PageCount - 1 do
      SWTs.pgCtrl.Pages[I].TabVisible := false;
    with PLRMObj.currentNode do
    begin

      if isSwt then SWTs.pgCtrl.Pages[swtType-1].TabVisible := true;
      case swmmNode.Ntype of  //for junctions outfalls and dividers only. SWTs addressed by above code
        DIVIDER:  //flow divider element is current element
        begin
          SWTs.tbxFldName.Text := UserName;
          SWTs.cbxSelFldNode.Items := getNodeType(DIVIDER); //diNodesList;
          tempInt :=   SWTs.cbxSelFldNode.Items.IndexOf(UserName);
          if (tempInt<>-1) then SWTs.cbxSelFldNode.ItemIndex:=tempInt;
          SWTs.cbxFldLowFlowNode.items := getAllExceptCurrentNode();
          SWTs.cbxFldHighFlowNode.items := getAllExceptCurrentNode();
          SWTs.cbxFldLowFlowNode.Text := getNodeNamefromNodeId(PLRMObj.currentNode.outNode1ID);
          SWTs.cbxFldHighFlowNode.Text := getNodeNamefromNodeId(PLRMObj.currentNode.outNode2ID);
          SWTs.pgCtrl.Pages[6].TabVisible := true;  // DIVIDERS
          if hasDgnProps = true then
          begin
            tempInt := PLRMObj.nodes.IndexOf(outNode1ID);
            if tempInt <> -1 then
              SWTs.cbxFldLowFlowNode.ItemIndex := SWTs.cbxFldLowFlowNode.Items.IndexOf((PLRMObj.nodes.Objects[tempInt] as TPLRMNode).userName);
            tempInt := PLRMObj.nodes.IndexOf(outNode2ID);
            if tempInt <> -1 then
              SWTs.cbxFldHighFlowNode.ItemIndex := SWTs.cbxFldHighFlowNode.Items.IndexOf((PLRMObj.nodes.Objects[tempInt] as TPLRMNode).userName);
          end
        end;
      JUNCTION: //junction elements is current element
      begin
        SWTs.tbxJunName.Text := PLRMObj.currentNode.UserName;
        SWTs.cbxSelJunNode.Items := getNodeType(JUNCTION);//juNodesList;
        tempInt :=   SWTs.cbxSelJunNode.Items.IndexOf(PLRMObj.currentNode.UserName);
        if (tempInt<>-1) then SWTs.cbxSelJunNode.ItemIndex:=tempInt;
        SWTs.cbxJunOutNode.items := getAllExceptCurrentNode();
        SWTs.cbxJunOutNode.Text := getNodeNamefromNodeId(PLRMObj.currentNode.outNode1ID);
        SWTs.pgCtrl.Pages[7].TabVisible := true;  // JUNCTIONS
        if hasDgnProps = true then
        begin
          tempInt := PLRMObj.nodes.IndexOf(outNode1ID);
          if tempInt <> -1 then
            SWTs.cbxJunOutNode.ItemIndex := SWTs.cbxJunOutNode.Items.IndexOf((PLRMObj.nodes.Objects[tempInt] as TPLRMNode).userName);
        end
      end;
      OUTFALL:  //outfall elements is current element
      begin
        SWTs.tbxOutName.Text := PLRMObj.currentNode.UserName;
        SWTs.cbxSelOutNode.Items := getNodeType(OUTFALL);//ofNodesList;
        tempInt :=   SWTs.cbxSelOutNode.Items.IndexOf(PLRMObj.currentNode.UserName);
        if (tempInt<>-1) then SWTs.cbxSelOutNode.ItemIndex:=tempInt;
        SWTs.cbxJunOutNode.items := getAllExceptCurrentNode();
        SWTs.cbxJunOutNode.Text := getNodeNamefromNodeId(PLRMObj.currentNode.outNode1ID);
        SWTs.pgCtrl.Pages[8].TabVisible := true;  // OUTFALLS
      end;
    end;
    end;
    try
      tempInt := SWTs.ShowModal;
    finally
      SWTs.Free;
    end;
end;

procedure TSWTs.genericApply(var cbxNode:TComboBox; var tbxName:TEdit; var cbxOutlet:TComboBox; var sgDgn:TStringGrid; var sgEffl:TStringGrid);
  var
    tempInt :Integer;
begin
  with PLRMObj.currentNode do
  begin
      tempInt := cbxNode.items.IndexOf(userName);
      if tempInt <> -1 then cbxNode.items[tempInt] := tbxName.Text;
      cbxNode.ItemIndex := tempInt;
      userName := tbxName.Text;
      if cbxOutlet.ItemIndex <> -1 then
        outnode1Id := (GSUtils.getComboBoxSelValue2(cbxOutlet) as TPLRMNode).swmmNode.id
      else
        outnode1Id :='-1';
      designProps := copyGridContents(0,1,sgDgn);
      efflConcs := copyGridContents(0,1,sgEffl);
      PLRMObj.updateCurNodeProps(swmmNode.id, outNode1ID, designProps,efflConcs);
  end;
end;

procedure TSWTs.btnApplyClick(Sender: TObject);
var
  tempInt :Integer;
begin
  with PLRMObj.currentNode do
  begin
    //order matters this block before next block ??
  case PLRMObj.currentNode.SWTType of
    1://Detention basin
      genericApply(cbxSelDetNode,tbxDetName,cbxDetOutLet,sgDetDgnProps,sgDetEffl);
    2://Infiltration
      genericApply(cbxSelInfNode,tbxInfName,cbxInfOutLet,sgInfDgnProps,sgInfEffl);
    3://Wetland/Wetpond
      genericApply(cbxSelDetNode,tbxWetName,cbxWetOutLet,sgWetDgnProps,sgWetEffl);
    4://Granular Bed Filter
      genericApply(cbxSelDetNode,tbxGrnName,cbxGrnOutLet,sgGrnDgnProps,sgGrnEffl);
    5://Cartridge Filter
      genericApply(cbxSelCrtNode,tbxCrtName,cbxCrtOutLet,sgCrtDgnProps,sgCrtEffl);
    6://Hydrodynamic Devices
      genericApply(cbxSelHydNode,tbxHydName,cbxHydOutLet,sgHydDgnProps,sgHydEffl);
    7: //other nodes: junctions, outfalls, flow dividers
    begin
      case PLRMObj.currentNode.swmmNode.NType of
      DIVIDER:  //update flow divider parameters
        begin
          userName := tbxFldName.Text;
          if cbxFldLowFlowNode.ItemIndex <> -1 then
            outnode1Id := (GSUtils.getComboBoxSelValue2(cbxFldLowFlowNode) as TPLRMNode).swmmNode.id
          else
            outnode1Id :='-1';
          if cbxFldLowFlowNode.ItemIndex <> -1 then
            outNode2ID := (GSUtils.getComboBoxSelValue2(cbxFldHighFlowNode) as TPLRMNode).swmmNode.id
          else
            outNode2ID :='-1';
          maxFlow := tbxFldFlowRate.Text;
          PLRMObj.updateCurNodeProps(swmmNode.id, outNode1ID, outNode2ID, maxFlow);
        end;
      JUNCTION:  //update junction parameters
        begin
          userName := tbxJunName.Text;
          if cbxJunOutNode.ItemIndex <> -1 then
            outnode1Id := (GSUtils.getComboBoxSelValue2(cbxJunOutNode) as TPLRMNode).swmmNode.id
          else
            outnode1Id :='-1';

          PLRMObj.updateCurNodeProps(swmmNode.id, outNode1ID);
        end;
      OUTFALL:
        begin
          userName := tbxOutName.Text;
          PLRMObj.updateCurNodeProps(swmmNode.id);
        end;
      end;
    end;
  end;
  end;
  PLRMObj.currentNode.hasDgnProps:= true;
end;

procedure TSWTs.btnCancelClick(Sender: TObject);
begin
ModalResult := mrCancel;
end;

procedure TSWTs.btnOkClick(Sender: TObject);
begin
  btnApplyClick(Sender);
  ModalResult := mrOK;
end;

procedure TSWTs.FormCreate(Sender: TObject);
var
  //tempInt,I : Integer;
  dbProps :dbReturnFields3;
  data :PLRMGridData;
begin
     //0 = not a SWT, 1=Extended Detention Basin, 2=Infiltration Basin, 3=Wetland/Wetpond, 4=Granular Bed Filter, //5==Cartridge Filter, 6=Hydrodynamic Separator
     case swtType of
       1: initOrRestoreContents(sgDetDgnProps, sgDetEffl,'500',cbxSelDetNode, tbxDetName,cbxDetOutlet); //Detention
       2:initOrRestoreContents(sgInfDgnProps, sgInfEffl,'505',cbxSelInfNode, tbxInfName,cbxInfOutlet); //Infiltration
       3:initOrRestoreContents(sgWetDgnProps, sgWetEffl,'501',cbxSelWetNode, tbxWetName,cbxWetOutlet); //Wetland
       4: initOrRestoreContents(sgGrnDgnProps, sgGrnEffl,'502',cbxSelGrnNode, tbxGrnName,cbxGrnOutlet); //Granular bed Filter
       5:initOrRestoreContents(sgCrtDgnProps, sgCrtEffl,'503',cbxSelCrtNode, tbxCrtName,cbxCrtOutlet); //Cartridge Filter bed
       6:initOrRestoreContents(sgHydDgnProps, sgHydEffl,'504',cbxSelHydNode, tbxHydName,cbxHydOutlet); //Hydrodynamic device
     end;
end;

procedure TSWTs.initOrRestoreContents(var sgDgnProps:TStringGrid; var sgEffl:TStringGrid;qryStrCode:String;var cbxNode:TCombobox; var txtName:TEdit; var cbxOutlet:TCombobox);
begin
    initOrRestoreContents(sgDgnProps,sgEffl,qryStrCode,cbxNode,txtName,cbxOutlet,PLRMObj.currentNode)
end;
procedure TSWTs.initOrRestoreContents(var sgDgnProps:TStringGrid; var sgEffl:TStringGrid;
                    qryStrCode:String;var cbxNode:TCombobox;var txtName:TEdit;var cbxOutlet:TCombobox; var Node:TPLRMNode);
var
  tempInt,I : Integer;
  dbProps :dbReturnFields3;
  data :PLRMGridData;
  outNodeList:TStringList;
begin
    Node.qryStrCode := qryStrCode; //store for later, written to xml and read back to help with restoration of dgn and effl data
    txtName.Text := Node.userName;
    cbxNode.Items := getSWTTypeNodes(swtType);//swtNodesList;
    cbxNode.ItemIndex := PLRMObj.getNodeIndex(Node.swmmNode.ID,PLRMObj.nodesTypeLists[swtType]);
    outNodeList :=  getAllExceptCurrentNode();
    cbxOutlet.Items := outNodeList;

    if Node.hasDgnProps = true then
    begin
      tempInt := PLRMObj.nodes.IndexOf(Node.outNode1ID);
      if tempInt <> -1 then
        cbxOutlet.ItemIndex := outNodeList.IndexOf((PLRMObj.nodes.Objects[tempInt] as TPLRMNode).userName);
      copyContentsToGridAddRows(PLRMObj.currentNode.designProps,0,1,sgDgnProps);
      copyContentsToGridAddRows(PLRMObj.currentNode.efflConcs,0,1, sgEffl);
    end
    else
    begin
      //Read design parameters from database
      dbProps := GSIO.getDesignParams(qryStrCode,2,3,4,3);
      data := dbFields3ToPLRMGridData(dbProps,0);
      copyContentsToGridAddRows(data,0,1,sgDgnProps);
      //Read BMP effluent qualities from database
      dbProps := GSIO.getEfflQuals(qryStrCode,2,5,4,5);
      data := dbFields3ToPLRMGridData(dbProps,0);
      copyContentsToGridAddRows(data,0,1,sgEffl);
    end;
    if PLRMObj.currentNode.xmlTagsDgn = nil then
      PLRMObj.currentNode.xmlTagsDgn:= GSIO.lookUpValFrmTable('SWTDesignParameters','xmlTag',7,false,'WHERE (SWT_Code like '+ qryStrCode + ') ORDER BY SWTDesignParameters.displayOrder');
    if PLRMObj.currentNode.xmlTagsEffl = nil then
      PLRMObj.currentNode.xmlTagsEffl:= GSIO.lookUpValFrmTable('SWTEffluentQualities','xmlTag',7,false,'WHERE (SWT_Code like '+ qryStrCode + ') ORDER BY SWTEffluentQualities.displayOrder');
    sgDgnProps.Cells[0,0] := 'Parameters';
    sgDgnProps.Cells[1,0] := 'Default Value';
    sgDgnProps.Cells[2,0] := 'Units';
    sgDgnProps.Cells[3,0] := 'User Value';

    sgEffl.Cells[0,0] := 'Pollutants of Concern';
    sgEffl.Cells[1,0] := 'Default Value';
    sgEffl.Cells[2,0] := 'Units';
    sgEffl.Cells[3,0] := 'User Value';
end;

{$REGION 'FUNCTIONS TO POSSIBLY MOVE TO GSPLRM'}
//NOTE WE MAY WANT TO MOVE THESE FUNCTIONS TO THE GSPLRM OBJECT
function getSWTTypeNodes(swtType: Integer) : TStringList;
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
   getSWTTypeNodes := tempNodeList;
end;

function getAllExceptCurrentNode(): TStringList;
var
  I : Integer;
  tempNode: TPLRMNode;
  tempNodeList: TStringList;
begin
    tempNodeList := TStringList.Create;
    for I := 0 to PLRMObj.nodes.Count - 1 do
     begin
      tempNode := (PLRMObj.nodes.Objects[I]) as TPLRMNode;
      if tempNode <> PLRMObj.currentNode then
        tempNodeList.AddObject(tempNode.userName,PLRMObj.nodes.Objects[I]);
     end;
    getAllExceptCurrentNode := tempNodeList;
end;

function getNodeType(nodeType : Integer) : TStringList;
var
  I : Integer;
  tempNode: TPLRMNode;
  tempNodeList: TStringList;
begin
    tempNodeList := TStringList.Create;
    for I := 0 to PLRMObj.nodes.Count - 1 do
     begin
      tempNode := (PLRMObj.nodes.Objects[I] as TPLRMNode);
      if tempNode.swmmNode.Ntype = nodeType then tempNodeList.AddObject(tempNode.userName,PLRMObj.nodes.Objects[I]);
     end;
    getNodeType := tempNodeList;
end;

  function getNodeNamefromNodeId(nodeID:String):String;
  var
    tempNode : TPLRMNode;
    I : Integer;
  begin
    Result := nodeID;
    if nodeID <> '' then
      begin
      I := PLRMObj.nodes.IndexOf(nodeID);
      tempNode := (PLRMObj.nodes.Objects[I] as TPLRMNode);
      Result := tempNode.userName;
      end;
  end;

{$ENDREGION}

{$REGION 'Detention Basin Form Event Handlers'}
//-----------------------------------------------------------------------------
// Detention Basin Form Event Handlers
//-----------------------------------------------------------------------------
procedure TSWTs.lblDetSchmMouseEnter(Sender: TObject);
begin
   lblDetSchm.Font.Size := 10;
   lblDetSchm.Font.Color := clGreen;
end;

procedure TSWTs.lblDetSchmMouseLeave(Sender: TObject);
begin
  lblDetSchm.Font.Size := 9;
  lblDetSchm.Font.Color := clBlue;
end;

procedure TSWTs.lblDetSchmClick(Sender: TObject);
begin
    getSchmForm(1);
end;

procedure TSWTs.sgDetDgnPropsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var S : String;
begin
  if (ACol<3) then begin
    sgDetDgnProps.Canvas.Brush.Color := cl3DLight;
    sgDetDgnProps.Canvas.FillRect(Rect);
    S := sgDetDgnProps.Cells[ACol, ARow];
    sgDetDgnProps.Canvas.Font.Color := clBlue;
    sgDetDgnProps.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure TSWTs.sgDetDgnPropsSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
begin
  if (ACol<3) then
    begin
      sgDetDgnProps.Options:=sgDetDgnProps.Options-[goEditing];
      ShowMessage('This cell is not editable. Please select another cell!');
    end
  else
  begin
    sgDetDgnProps.Options:=sgDetDgnProps.Options+[goEditing];
  end;
end;

procedure TSWTs.sgDetEfflDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var S : String;
begin
  if (ACol<3) then begin
    sgDetEffl.Canvas.Brush.Color := cl3DLight;
    sgDetEffl.Canvas.FillRect(Rect);
    S := sgDetEffl.Cells[ACol, ARow];
    sgDetEffl.Canvas.Font.Color := clBlue;
    sgDetEffl.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure TSWTs.sgDetEfflSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
begin
  if (ACol<3) then
    begin
      sgDetEffl.Options:=sgDetEffl.Options-[goEditing];
      ShowMessage('This cell is not editable. Please select another cell!');
    end
  else  sgDetEffl.Options:=sgDetEffl.Options+[goEditing];
end;

procedure TSWTs.cbxSelDetNodeOnChange(Sender: TObject);
var tempInt: Integer; swtNodesList : TStringList; outNodesList : TStringList;
begin
  PLRMObj.currentNode := GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode;
  outNodesList := getAllExceptCurrentNode();
  swtNodesList := getSWTTypeNodes(swtType);
  with PLRMObj.currentNode do
  begin
    tbxDetName.Text := UserName;
    cbxSelDetNode.Items := swtNodesList;
    cbxDetOutlet.Text := getNodeNamefromNodeId(outNode1ID);
    cbxDetOutlet.Items := outNodesList;
  end;
end;

procedure TSWTs.cbxDetOutletOnChange(Sender: TObject);
var
swmmIndex : Integer;
tempID : String;
downLink : Uproject.TLink;
upNode : TPLRMNode;
dwnNode : TPLRMNode;
PointList: array[0..1] of TPoint;
mapObj : Umap.TMap;
mapForm : Fmap.TMapForm;
begin
   mapObj := FMap.MapForm.Map;
   mapForm := Fmap.MapForm;
   //Check to see if link exists, if so remove it
   if (PLRMObj.currentNode.dwnLink is Uproject.TLink) then
      begin;
      swmmIndex := Project.Lists[CONDUIT].IndexOf(PLRMObj.currentNode.dwnLink.ID);
      mapForm.EraseObject(CONDUIT,swmmIndex);
      end;
   upNode := PLRMObj.currentNode;
   dwnNode := (GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode);
   PointList[0] := Point(mapObj.GetXpix(upNode.swmmNode.X), mapObj.GetYpix(upNode.swmmNode.Y));
   PointList[1] := Point(mapObj.GetXpix(dwnNode.swmmNode.X), mapObj.GetYpix(dwnNode.swmmNode.Y));
   Uedit.AddLink(CONDUIT,upNode.swmmNode,dwnNode.swmmNode,PointList,0,tempID);
   swmmIndex := Project.Lists[CONDUIT].IndexOf(tempID);
   downLink := Project.GetLink(CONDUIT, swmmIndex);
   PLRMObj.currentNode := upNode;
   PLRMObj.currentNode.dwnLink := downLink;
   PLRMObj.currentNode.outNode1ID := dwnNode.swmmNode.id;
   //cbxDetOutlet.Text := dwnNode.userName;
   btnApplyClick(Sender);
end;

 {$ENDREGION}

{$REGION 'Infiltration Basin Form Event Handlers'}
//-----------------------------------------------------------------------------
// Infiltration Basin Form Event Handlers
//-----------------------------------------------------------------------------
procedure TSWTs.lblInfSchmClick(Sender: TObject);
begin
   getSchmForm(2);
end;

procedure TSWTs.sgInfDgnPropsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var S : String;
begin
  if (ACol<3) then begin
    sgInfDgnProps.Canvas.Brush.Color := cl3DLight;
    sgInfDgnProps.Canvas.FillRect(Rect);
    S := sgInfDgnProps.Cells[ACol, ARow];
    sgInfDgnProps.Canvas.Font.Color := clBlue;
    sgInfDgnProps.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure TSWTs.sgInfDgnPropsSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
begin
  if (ACol<3) then
    begin
      sgInfDgnProps.Options:=sgInfDgnProps.Options-[goEditing];
      ShowMessage('This cell is not editable. Please select another cell!');
    end
  else
  begin
    sgInfDgnProps.Options:=sgInfDgnProps.Options+[goEditing];
  end;
end;

procedure TSWTs.cbxSelInfNodeOnChange(Sender: TObject);
var tempInt: Integer; swtNodesList : TStringList; outNodesList : TStringList;
begin
  PLRMObj.currentNode := GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode;
  outNodesList := getAllExceptCurrentNode();
  swtNodesList := getSWTTypeNodes(swtType);
  with PLRMObj.currentNode do
  begin
    tbxInfName.Text := UserName;
    cbxSelInfNode.Items := swtNodesList;
    //initOrRestoreContents(sgInfDgnProps, sgInfEffl,'505');
    cbxInfOutlet.Text := getNodeNamefromNodeId(outNode1ID);
    cbxInfOutlet.Items := outNodesList;
  end;
end;

{$ENDREGION}

{$REGION 'Wetland/Wetpond Form Event Handlers'}
//-----------------------------------------------------------------------------
// Wetland/Wetpond Form Event Handlers
//-----------------------------------------------------------------------------
procedure TSWTs.lblWetlSchmClick(Sender: TObject);
begin
   getSchmForm(5);
end;

procedure TSWTs.sgWetDgnPropsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var S : String;
begin
  if (ACol<3) then begin
    sgWetDgnProps.Canvas.Brush.Color := cl3DLight;
    sgWetDgnProps.Canvas.FillRect(Rect);
    S := sgWetDgnProps.Cells[ACol, ARow];
    sgWetDgnProps.Canvas.Font.Color := clBlue;
    sgWetDgnProps.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure TSWTs.sgWetDgnPropsSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
begin
  if (ACol<3) then
    begin
      sgWetDgnProps.Options:=sgWetDgnProps.Options-[goEditing];
      ShowMessage('This cell is not editable. Please select another cell!');
    end
  else
  begin
    sgWetDgnProps.Options:=sgWetDgnProps.Options+[goEditing];
  end;
end;

procedure TSWTs.sgWetEfflDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var S : String;
begin
  if (ACol<3) then begin
    sgWetEffl.Canvas.Brush.Color := cl3DLight;
    sgWetEffl.Canvas.FillRect(Rect);
    S := sgWetEffl.Cells[ACol, ARow];
    sgWetEffl.Canvas.Font.Color := clBlue;
    sgWetEffl.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure TSWTs.sgWetEfflSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
begin
  if (ACol<3) then
    begin
      sgWetEffl.Options:=sgWetEffl.Options-[goEditing];
      ShowMessage('This cell is not editable. Please select another cell!');
    end
  else
  begin
    sgWetEffl.Options:=sgWetEffl.Options+[goEditing];
  end;
end;

procedure TSWTs.cbxSelWetNodeOnChange(Sender: TObject);
var tempInt: Integer; swtNodesList : TStringList; outNodesList : TStringList;
begin
  PLRMObj.currentNode := GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode;
  outNodesList := getAllExceptCurrentNode();
  swtNodesList := getSWTTypeNodes(swtType);
  with PLRMObj.currentNode do
  begin
    tbxWetName.Text := UserName;
    cbxSelWetNode.Items := swtNodesList;
    cbxWetOutlet.Text := getNodeNamefromNodeId(outNode1ID);
    cbxWetOutlet.Items := outNodesList;
  end;
end;

{$ENDREGION}

{$REGION 'Granular Bed Filter Form Event Handlers'}
//-----------------------------------------------------------------------------
// Granular Bed Filter Form Event Handlers
//-----------------------------------------------------------------------------

procedure TSWTs.sgGrnDgnPropsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var S : String;
begin
  if (ACol<3) then begin
    sgGrnDgnProps.Canvas.Brush.Color := cl3DLight;
    sgGrnDgnProps.Canvas.FillRect(Rect);
    S := sgGrnDgnProps.Cells[ACol, ARow];
    sgGrnDgnProps.Canvas.Font.Color := clBlue;
    sgGrnDgnProps.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure TSWTs.sgGrnDgnPropsSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
begin
  if (ACol<3) then
    begin
      sgGrnDgnProps.Options:=sgGrnDgnProps.Options-[goEditing];
      ShowMessage('This cell is not editable. Please select another cell!');
    end
  else
  begin
    sgGrnDgnProps.Options:=sgGrnDgnProps.Options+[goEditing];
  end;
end;

procedure TSWTs.sgGrnEfflDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var S : String;
begin
  if (ACol<3) then begin
    sgGrnEffl.Canvas.Brush.Color := cl3DLight;
    sgGrnEffl.Canvas.FillRect(Rect);
    S := sgGrnEffl.Cells[ACol, ARow];
    sgGrnEffl.Canvas.Font.Color := clBlue;
    sgGrnEffl.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure TSWTs.sgGrnEfflSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
begin
  if (ACol<3) then
    begin
      sgGrnEffl.Options:=sgGrnEffl.Options-[goEditing];
      ShowMessage('This cell is not editable. Please select another cell!');
    end
  else
  begin
    sgGrnEffl.Options:=sgGrnEffl.Options+[goEditing];
  end;
end;

procedure TSWTs.lblFiltSchmClick(Sender: TObject);
begin
    getSchmForm(4);
end;

procedure TSWTs.cbxSelGrnNodeOnChange(Sender: TObject);
var tempInt: Integer; swtNodesList : TStringList; outNodesList : TStringList;
begin
  PLRMObj.currentNode := GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode;
  outNodesList := getAllExceptCurrentNode();
  swtNodesList := getSWTTypeNodes(swtType);
  with PLRMObj.currentNode do
  begin
    tbxGrnName.Text := UserName;
    cbxSelGrnNode.Items := swtNodesList;
    //initOrRestoreContents(sgGrnDgnProps, sgGrnEffl,'502');
    cbxGrnOutlet.Text := getNodeNamefromNodeId(outNode1ID);
    cbxGrnOutlet.Items := outNodesList;
  end;
end;

{$ENDREGION}

{$REGION 'Cartridge Filter Form Event Handlers'}
//-----------------------------------------------------------------------------
// Cartridge Filter Form Event Handlers
//-----------------------------------------------------------------------------

procedure TSWTs.sgCrtDgnPropsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var S : String;
begin
  if (ACol<3) then begin
    sgCrtDgnProps.Canvas.Brush.Color := cl3DLight;
    sgCrtDgnProps.Canvas.FillRect(Rect);
    S := sgCrtDgnProps.Cells[ACol, ARow];
    sgCrtDgnProps.Canvas.Font.Color := clBlue;
    sgCrtDgnProps.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure TSWTs.sgCrtDgnPropsSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
begin
  if (ACol<3) then
    begin
      sgCrtDgnProps.Options:=sgCrtDgnProps.Options-[goEditing];
      ShowMessage('This cell is not editable. Please select another cell!');
    end
  else
  begin
    sgCrtDgnProps.Options:=sgCrtDgnProps.Options+[goEditing];
  end;
end;

procedure TSWTs.sgCrtEfflDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var S : String;
begin
  if (ACol<3) then begin
    sgCrtEffl.Canvas.Brush.Color := cl3DLight;
    sgCrtEffl.Canvas.FillRect(Rect);
    S := sgCrtEffl.Cells[ACol, ARow];
    sgCrtEffl.Canvas.Font.Color := clBlue;
    sgCrtEffl.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure TSWTs.sgCrtEfflSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
begin
  if (ACol<3) then
    begin
      sgCrtEffl.Options:=sgCrtEffl.Options-[goEditing];
      ShowMessage('This cell is not editable. Please select another cell!');
    end
  else
  begin
    sgCrtEffl.Options:=sgCrtEffl.Options+[goEditing];
  end;
end;

procedure TSWTs.cbxSelCrtNodeOnChange(Sender: TObject);
var tempInt: Integer; swtNodesList : TStringList; outNodesList : TStringList;
begin
  PLRMObj.currentNode := GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode;
  outNodesList := getAllExceptCurrentNode();
  swtNodesList := getSWTTypeNodes(swtType);
  with PLRMObj.currentNode do
  begin
    tbxCrtName.Text := UserName;
    cbxSelCrtNode.Items := swtNodesList;
    cbxCrtOutlet.Text := getNodeNamefromNodeId(outNode1ID);
    cbxCrtOutlet.Items := outNodesList;
  end;
end;

{$ENDREGION}

{$REGION 'Hydrodynamic Separator Form Event Handlers'}
//-----------------------------------------------------------------------------
// Hydrodynamic Separator Form Event Handlers
//-----------------------------------------------------------------------------

procedure TSWTs.sgHydDgnPropsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var S : String;
begin
  if (ACol<3) then begin
    sgHydDgnProps.Canvas.Brush.Color := cl3DLight;
    sgHydDgnProps.Canvas.FillRect(Rect);
    S := sgHydDgnProps.Cells[ACol, ARow];
    sgHydDgnProps.Canvas.Font.Color := clBlue;
    sgHydDgnProps.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure TSWTs.sgHydDgnPropsSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
begin
  if (ACol<3) then
    begin
      sgHydDgnProps.Options:=sgHydDgnProps.Options-[goEditing];
      ShowMessage('This cell is not editable. Please select another cell!');
    end
  else
  begin
    sgHydDgnProps.Options:=sgHydDgnProps.Options+[goEditing];
  end;
end;

procedure TSWTs.sgHydEfflDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
var S : String;
begin
  if (ACol<3) then begin
    sgHydEffl.Canvas.Brush.Color := cl3DLight;
    sgHydEffl.Canvas.FillRect(Rect);
    S := sgHydEffl.Cells[ACol, ARow];
    sgHydEffl.Canvas.Font.Color := clBlue;
    sgHydEffl.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure TSWTs.sgHydEfflSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
begin
  if (ACol<3) then
    begin
      sgHydEffl.Options:=sgHydEffl.Options-[goEditing];
      ShowMessage('This cell is not editable. Please select another cell!');
    end
  else
  begin
    sgHydEffl.Options:=sgHydEffl.Options+[goEditing];
  end;
end;
procedure TSWTs.lblHydSchmClick(Sender: TObject);
begin
   getSchmForm(3);
end;

procedure TSWTs.cbxSelHydNodeOnChange(Sender: TObject);
var tempInt: Integer; swtNodesList : TStringList; outNodesList : TStringList;
begin
  PLRMObj.currentNode := GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode;
  outNodesList := getAllExceptCurrentNode();
  swtNodesList := getSWTTypeNodes(swtType);
  with PLRMObj.currentNode do
  begin
    tbxHydName.Text := UserName;
    cbxSelHydNode.Items := swtNodesList;
    cbxHydOutlet.Text := getNodeNamefromNodeId(outNode1ID);
    cbxHydOutlet.Items := outNodesList;
  end;
end;


{$ENDREGION}

{$REGION 'Other Nodes Form Event Handlers'}
//-----------------------------------------------------------------------------
// Other Nodes Form Event Handlers
//-----------------------------------------------------------------------------

procedure TSWTs.cbxSelFldNodeOnChange(Sender: TObject);
var tempInt: Integer; diNodesList : TStringList; outNodesList : TStringList;
begin
  PLRMObj.currentNode := GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode;
  outNodesList := getAllExceptCurrentNode();
  diNodesList := getNodeType(DIVIDER);
  with PLRMObj.currentNode do
  begin
    tbxFldName.Text := UserName;
    cbxSelFldNode.Items := diNodesList;
    cbxFldLowFlowNode.Text := getNodeNamefromNodeId(outNode1ID);
    cbxFldHighFlowNode.Text := getNodeNamefromNodeId(outNode2ID);
    tbxFldFlowRate.Text := maxFlow;
  end;
end;

procedure TSWTs.cbxOutNodeOnChange(Sender: TObject);  //This procedure can be used for all outlet nodes
var
swmmIndex : Integer;
tempID : String;
downLink : Uproject.TLink;
upNode : TPLRMNode;
dwnNode : TPLRMNode;
PointList: array[0..1] of TPoint;
mapObj : Umap.TMap;
mapForm : Fmap.TMapForm;
begin
   mapObj := FMap.MapForm.Map;
   mapForm := Fmap.MapForm;
   //Check to see if link exists, if so remove it
   if (PLRMObj.currentNode.dwnLink is Uproject.TLink) then
      begin;
      swmmIndex := Project.Lists[CONDUIT].IndexOf(PLRMObj.currentNode.dwnLink.ID);
      mapForm.EraseObject(CONDUIT,swmmIndex);
      end;
   upNode := PLRMObj.currentNode;
   dwnNode := (GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode);
   PointList[0] := Point(mapObj.GetXpix(upNode.swmmNode.X), mapObj.GetYpix(upNode.swmmNode.Y));
   PointList[1] := Point(mapObj.GetXpix(dwnNode.swmmNode.X), mapObj.GetYpix(dwnNode.swmmNode.Y));
   Uedit.AddLink(CONDUIT,upNode.swmmNode,dwnNode.swmmNode,PointList,0,tempID);
   swmmIndex := Project.Lists[CONDUIT].IndexOf(tempID);
   downLink := Project.GetLink(CONDUIT, swmmIndex);
   PLRMObj.currentNode := upNode;
   PLRMObj.currentNode.dwnLink := downLink;
   PLRMObj.currentNode.outNode1ID := dwnNode.swmmNode.id;
   btnApplyClick(Sender);
end;

procedure TSWTs.cbxFldHighFlowNodeOnChange(Sender: TObject);
var
swmmIndex : Integer;
tempIndex : Integer;
tempID : String;
downLink : Uproject.TLink;
upNode : TPLRMNode;
dwnNode : TPLRMNode;
PointList: array[0..1] of TPoint;
mapObj : Umap.TMap;
mapForm : Fmap.TMapForm;
begin
   mapObj := FMap.MapForm.Map;
   mapForm := Fmap.MapForm;
   //Check to see if link exists, if so remove it
   if (PLRMObj.currentNode.divertLink is Uproject.TLink) then
      begin;
      swmmIndex := Project.Lists[CONDUIT].IndexOf(PLRMObj.currentNode.divertLink.ID);
      mapForm.EraseObject(CONDUIT,swmmIndex);
      end;
   upNode := PLRMObj.currentNode;
   dwnNode := (GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode);

   PointList[0] := Point(mapObj.GetXpix(upNode.swmmNode.X), mapObj.GetYpix(upNode.swmmNode.Y));
   PointList[1] := Point(mapObj.GetXpix(dwnNode.swmmNode.X), mapObj.GetYpix(dwnNode.swmmNode.Y));
   Uedit.AddLink(CONDUIT,upNode.swmmNode,dwnNode.swmmNode,PointList,0,tempID);
   swmmIndex := Project.Lists[CONDUIT].IndexOf(tempID);
   downLink := Project.GetLink(CONDUIT, swmmIndex);
   PLRMObj.currentNode := upNode;
   PLRMObj.currentNode.divertLink := downLink;
   btnApplyClick(Sender);
end;


procedure TSWTs.cbxSelJunNodeOnChange(Sender: TObject);
var tempInt: Integer; juNodesList : TStringList; outNodesList : TStringList;
begin
  PLRMObj.currentNode := GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode;
  outNodesList := getAllExceptCurrentNode();
  juNodesList := getNodeType(JUNCTION);
  with PLRMObj.currentNode do
  begin
    tbxJunName.Text := UserName;
    cbxSelJunNode.Items := juNodesList;
    cbxJunOutNode.Text := getNodeNamefromNodeId(outNode1ID);
  end;
end;


procedure TSWTs.cbxSelOutNodeOnChange(Sender: TObject);
var tempInt: Integer; ofNodesList : TStringList;
begin
  PLRMObj.currentNode := GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode;
  ofNodesList := getNodeType(OUTFALL);
  with PLRMObj.currentNode do
  begin
    tbxOutName.Text := UserName;
    cbxSelOutNode.Items := ofNodesList;
  end;

end;


{$ENDREGION}

//generalized event handles

procedure TSWTs.lblMouseEnter(Sender: TObject);
begin
   (Sender as TLabel).Font.Size := 10;
   (Sender as TLabel).Font.Color := clGreen;
end;

procedure TSWTs.lblMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Size := 9;
  (Sender as TLabel).Font.Color := clBlue;
end;


end.
