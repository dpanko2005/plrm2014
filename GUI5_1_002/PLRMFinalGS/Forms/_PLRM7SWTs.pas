unit _PLRM7SWTs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, Grids, ComCtrls, GSPLRM,GSNodes, GSTypes;

type
  TSWTs = class(TForm)
    pgCtrl: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox5: TGroupBox;
    sgDetEffl: TStringGrid;
    GroupBox6: TGroupBox;
    btnDischargeCurveDet: TButton;
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
    statBar: TStatusBar;
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
    btnDischargeCurveWet: TButton;
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
    btnDischargeCurveInf: TButton;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure renameSWT(strName:String);
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
    procedure btnDischargeCurveWetClick(Sender: TObject);
    procedure btnDischargeCurveDetClick(Sender: TObject);
    procedure btnDischargeCurveInfClick(Sender: TObject);
    procedure btnDischargeCurveGrnClick(Sender: TObject);
    procedure sgInfDgnPropsKeyPress(Sender: TObject; var Key: Char);
    procedure sgInfEfflKeyPress(Sender: TObject; var Key: Char);
    procedure sgWetDgnPropsKeyPress(Sender: TObject; var Key: Char);
    procedure sgWetEfflKeyPress(Sender: TObject; var Key: Char);
    procedure sgGrnDgnPropsKeyPress(Sender: TObject; var Key: Char);
    procedure sgGrnEfflKeyPress(Sender: TObject; var Key: Char);
    procedure sgCrtDgnPropsKeyPress(Sender: TObject; var Key: Char);
    procedure sgCrtEfflKeyPress(Sender: TObject; var Key: Char);
    procedure sgHydDgnPropsKeyPress(Sender: TObject; var Key: Char);
    procedure sgHydEfflKeyPress(Sender: TObject; var Key: Char);
    procedure genericNameChange(Sender: TObject; var Node:TPLRMNode; namesList:TStringList; Cbx:TCombobox);
    procedure tbxDetNameKeyPress(Sender: TObject; var Key: Char);
    procedure tbxInfNameKeyPress(Sender: TObject; var Key: Char);
    procedure tbxWetNameKeyPress(Sender: TObject; var Key: Char);
    procedure tbxGrnNameKeyPress(Sender: TObject; var Key: Char);
    procedure tbxCrtNameKeyPress(Sender: TObject; var Key: Char);
    procedure tbxHydNameKeyPress(Sender: TObject; var Key: Char);
    procedure tbxFldNameKeyPress(Sender: TObject; var Key: Char);
    procedure tbxJunNameKeyPress(Sender: TObject; var Key: Char);
    procedure tbxOutNameKeyPress(Sender: TObject; var Key: Char);
    procedure tbxDetNameExit(Sender: TObject);
    procedure tbxInfNameExit(Sender: TObject);
    procedure tbxWetNameExit(Sender: TObject);
    procedure tbxGrnNameExit(Sender: TObject);
    procedure tbxCrtNameExit(Sender: TObject);
    procedure tbxHydNameExit(Sender: TObject);
    procedure tbxFldNameExit(Sender: TObject);
    procedure tbxJunNameExit(Sender: TObject);
    procedure tbxOutNameExit(Sender: TObject);

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
  okFlag:Boolean; //fix to prevent showing of warning when ok button is clicked and surcharge vol is zero
  tempSWTName:String; //stores swt name when form loads and restores it if user hit cancel.

implementation

{$R *.dfm}
uses
GSIO, GSUtils, UProject,UGlobals, _PLRMD4Schematics, UEdit, Umap, Fmap,_PLRMD5VolumeDischarge,Uvalidate;

procedure getSWTProps(nodeID:String; swtTypeNum:Integer);
  var
    tempInt : Integer;
    I: Integer;
  begin
    initNodeID := nodeID;
    swtType := swtTypeNum ;
    SWTs := TSWTs.Create(Application);
    SWTs.Caption := SWTFORMHEADERS[swtType-1];

    for I := 0 to SWTs.pgCtrl.PageCount - 1 do
      SWTs.pgCtrl.Pages[I].TabVisible := false;
    with PLRMObj.currentNode do
    begin

      if isSwt then
      begin
        SWTs.pgCtrl.Pages[swtType-1].TabVisible := true;
        SWTs.pgCtrl.Pages[swtType-1].Caption := SWTNames[swtType-1];
      end;
      case swmmNode.Ntype of  //for junctions outfalls and dividers only. SWTs addressed by above code
        DIVIDER:  //flow divider element is current element
        begin
          SWTs.tbxFldName.Text := UserName;
          SWTs.tbxFldFlowRate.Text := maxFlow;
          SWTs.cbxSelFldNode.Items := getNodeType(DIVIDER); //diNodesList;
          tempInt :=   SWTs.cbxSelFldNode.Items.IndexOf(UserName);
          if (tempInt<>-1) then SWTs.cbxSelFldNode.ItemIndex:=tempInt;
          SWTs.cbxFldLowFlowNode.items := getAllExceptCurrentNode();
          SWTs.cbxFldHighFlowNode.items := getAllExceptCurrentNode();
          SWTs.pgCtrl.Pages[6].TabVisible := true;  // DIVIDERS
          SWTs.Caption := SWTFORMHEADERS[6];
          if hasDgnProps = true then
          begin
            if ((assigned(PLRMObj.currentNode.outNode1)) and (PLRMObj.currentNode.outNode1.username <>'')) then
            begin
              tempInt := PLRMObj.nodes.IndexOf(outNode1.username);
              if tempInt <> -1 then
                SWTs.cbxFldLowFlowNode.ItemIndex := SWTs.cbxFldLowFlowNode.Items.IndexOf(outNode1.userName);
            end;

            if ((assigned(outNode2)) and (outNode2.username <>'')) then
            begin
              tempInt := PLRMObj.nodes.IndexOf(outNode2.username);
              if tempInt <> -1 then
                SWTs.cbxFldHighFlowNode.ItemIndex := SWTs.cbxFldHighFlowNode.Items.IndexOf(outNode2.userName);
            end;
          end
        end;
      JUNCTION: //junction elements is current element
      begin
        SWTs.tbxJunName.Text := PLRMObj.currentNode.UserName;
        SWTs.cbxSelJunNode.Items := getNodeType(JUNCTION);//juNodesList;
        tempInt :=   SWTs.cbxSelJunNode.Items.IndexOf(PLRMObj.currentNode.UserName);
        if (tempInt<>-1) then SWTs.cbxSelJunNode.ItemIndex:=tempInt;
        SWTs.cbxJunOutNode.items := getAllExceptCurrentNode();
        SWTs.pgCtrl.Pages[7].TabVisible := true;  // JUNCTIONS
        SWTs.Caption := SWTFORMHEADERS[7];
        if hasDgnProps = true then
        begin
          if ((assigned(outNode1)) and (outNode1.username <>'')) then
          begin
            tempInt := PLRMObj.nodes.IndexOf(outNode1.username);
            if tempInt <> -1 then
              SWTs.cbxJunOutNode.ItemIndex := SWTs.cbxJunOutNode.Items.IndexOf(outNode1.userName);
          end;
        end
      end;
      OUTFALL:  //outfall elements is current element
      begin
        SWTs.tbxOutName.Text := PLRMObj.currentNode.UserName;
        SWTs.cbxSelOutNode.Items := getNodeType(OUTFALL);//ofNodesList;
        tempInt :=   SWTs.cbxSelOutNode.Items.IndexOf(PLRMObj.currentNode.UserName);
        if (tempInt<>-1) then SWTs.cbxSelOutNode.ItemIndex:=tempInt;
        SWTs.pgCtrl.Pages[8].TabVisible := true;  // OUTFALLS
        SWTs.Caption := SWTFORMHEADERS[8];
      end;
    end;
    end;
    try
      SWTs.ShowModal;
    finally
      SWTs.Free;
    end;
end;

procedure createAreaDischargeGrids(DgnPropsGrid:TStringGrid; SWTNum:Integer;
     var volDisGrid,stageAreaGrid1,stageAreaGrid2,stageDisTmtGrid,stageDisInfGrid:PLRMGridData);
//This subroutine creates simple volume discharge, stage-area, and stage-discharge curves
// based on user volumes, areas, drawdown times, and infiltration rates. If the user
// has modified their curve then this procedure SHOULD NOT BE CALLED
var
  VolInc : Double; //incremental volume
  VolCum : Double; //cumulative volume
  TotDepth1 : Double; //Total depth of detention, infiltration, or surcharge basins
  TotDepth2 : Double; //Total depth of permanent pool
  StgInc1 : Double; //incremental stage for detention, infiltration, or surcharge basins
  Stage1 : Double; // stage for detention, infiltration, or surcharge basins
  StgInc2 : Double; //incremental stage for permanent pool
  Stage2 : Double; // stage for permanent pool
  WQV: Double;  //water quality volume or surcharge volume
  PPV: Double;  //permenant pool volume
  DDT: Double;  //drawdown time
  Area1: Double; //Footprint area of basin available for infiltration or evap.
  Area2: Double; //Footprint area of basin available for infiltration or evap.
  Inf: Double;  //User infiltration rate
  DisRate : Double; //Curve discharge rate
  InfRate : Double; // Curve infiltration rate
  I : Integer;
  numRows: Integer;
  begin
  Inf := 0.0;
    case SWTNum of
       1: //Detention
       begin
         // Read in water quality volume and drawdown time from form grid
         WQV := StrToFloat(DgnPropsGrid.Cells[USERVALCOL,DETWQVROW]); //user-provided volume
         PPV := 0; //not applicable
         DDT := StrToFloat(DgnPropsGrid.Cells[USERVALCOL,DETDDTROW]); //user-provided drawdown time
         Area1 := StrToFloat(DgnPropsGrid.Cells[USERVALCOL,DETAREAROW]); //user-provided footprint
         if Area1 = 0 then Area1 := 0.001;
         Area2 := 0;
         TotDepth1 := WQV/Area1;
         TotDepth2 := 0;
         Inf := StrToFloat(DgnPropsGrid.Cells[USERVALCOL,DETINFROW]); //user-provided infiltration rate
       end;
       2: //Infiltration
       begin
         // Read in water quality volume and drawdown time from form grid
         WQV := StrToFloat(DgnPropsGrid.Cells[USERVALCOL,INFWQVROW]); //user-provided volume
         PPV := 0; //not applicable
         DDT := -1; //not applicable
         Area1 := StrToFloat(DgnPropsGrid.Cells[USERVALCOL,INFAREAROW]); //user-provided footprint
         if Area1 = 0 then Area1 := 0.001;
         Area2 := 0;
         TotDepth1 := WQV/Area1;
         TotDepth2 := 0;
         Inf := StrToFloat(DgnPropsGrid.Cells[USERVALCOL,INFINFROW]); //user-provided infiltration rate
       end;
       3: //WetBasin
       begin
         // Read in water quality volume and drawdown time from form grid
         WQV := StrToFloat(DgnPropsGrid.Cells[USERVALCOL,WETSURVROW]);//user-provided surcharge volume
         //if WQV=0 then WQV:=-1; //no surcharge
         PPV := StrToFloat(DgnPropsGrid.Cells[USERVALCOL,WETPPVROW]); //user-provided perm. pool volume
         DDT := StrToFloat(DgnPropsGrid.Cells[USERVALCOL,WETDDTROW]); //user-provided drawdown time
         Area2 := StrToFloat(DgnPropsGrid.Cells[USERVALCOL,WETAREAROW]); //user-provided footprint used for perm pool
         if Area2 = 0  then Area2 := 0.001;
         //TotDepth1 := 2;  Dan P change based on AP comments 7/17/09
         TotDepth2 := PPV/Area2;

         //Dan P change based on AP comments 7/17/09
         if WQV = 0 then
         begin
          TotDepth1 := 2;
          DDT:=0;  //ML Change 8/30/09
          Area1 := Area2;
         end
         else
         begin
          //TotDepth1 :=WQV/Area2;
          TotDepth1 := 2;   //ML Change 8/30/09

         Area1 := WQV/TotDepth1;  // surcharge area
         end;

         //2014 comment out cause producing -ve numbers in swmm output Inf := -1; //not applicable
         Inf := 0; //not applicable
       end;
       4: //Bed Filter
       begin
         // Read in water quality volume and drawdown time from form grid
         WQV := StrToFloat(DgnPropsGrid.Cells[USERVALCOL,GRNEQVROW]);//user-provided surcharge volume
         PPV := 0; //not applicable
         DDT := -1; //not applicable
         Area1 := StrToFloat(DgnPropsGrid.Cells[USERVALCOL,GRNAREAROW]); //user-provided footprint
         if Area1 = 0 then Area1 := 0.001;
         Area2 := 0;
         TotDepth1 := WQV/Area1;
         TotDepth2 := 0;
         Inf := StrToFloat(DgnPropsGrid.Cells[USERVALCOL,GRNINFROW]); //treatment flow rate in/hr
       end;

       5:; //Cartridge Filter bed
       6:; //Hydrodynamic device
    end;

    //Setup Volume-Discharge Curve
    numRows := 12; //hardcoding for now
    VolInc := WQV/(numRows-3); //Currently 11 rows, but could change.
    SetLength(volDisGrid, 3, numRows);
    //volDisGrid := PLRMGridData.Create;
    volDisGrid[0,0] := 'Volume (cf)';
    volDisGrid[1,0] := 'Treatment Rate (cfs)';
    volDisGrid[2,0] := 'Infilt. Rate (in/hr)';

    StgInc1 := TotDepth1/(numRows-3);

    StgInc2 := TotDepth2/(numRows-3);
    //Stage2 := 0.0;
    SetLength(stageAreaGrid1, 2, numRows);
    SetLength(stageAreaGrid2, 2, numRows);
    SetLength(stageDisTmtGrid, 2, numRows);
    SetLength(stageDisInfGrid, 2, numRows);
    stageAreaGrid1[0,0] := 'Depth (ft)';
    stageAreaGrid1[1,0] := 'Area (sf)';
    stageAreaGrid2[0,0] := 'Depth (ft)';
    stageAreaGrid2[1,0] := 'Area (sf)';
    stageDisTmtGrid[0,0] := 'Head (ft)';
    stageDisTmtGrid[1,0] := 'Outflow (cfs)';
    stageDisInfGrid[0,0] := 'Head (ft)';
    stageDisInfGrid[1,0] := 'Outflow (cfs)';

    //Initial values
    VolCum := 0.0;
    Stage1 := 0.0;
    Stage2 := 0.0;
    DisRate := 0.0;
    InfRate := 0.0;
    for I := 1 to High(volDisGrid[1]) do //numRows do
    begin
      //if ((I=2) and (Area1 <> 0)) then
      if (I=2) then
      //Set first volume and stage to very small number
      begin
         volDisGrid[0,I] := FormatFloat('0.###',0.001*WQV); // 0.1% of WQV
         stageAreaGrid1[0,I] := FormatFloat('0.#####',0.001*TotDepth1);
         stageAreaGrid2[0,I] := FormatFloat('0.#####',0.001*TotDepth2);
         stageDisTmtGrid[0,I] := FormatFloat('0.#####',0.001*TotDepth1);
         stageDisInfGrid[0,I] := FormatFloat('0.#####',0.001*TotDepth1);

      end;
      if (I = 1) or (I>2) then
       begin
       //Fixed volume and stage columns
       volDisGrid[0,I] := FormatFloat('0.###',VolCum); //cumulative volume
       stageAreaGrid1[0,I] := FormatFloat('0.#####', Stage1); //cumulative stage
       stageAreaGrid2[0,I] := FormatFloat('0.#####',Stage2); //cumulative stage
       stageDisTmtGrid[0,I] := FormatFloat('0.#####',Stage1); //cumulative stage
       stageDisInfGrid[0,I] := FormatFloat('0.#####',Stage1); //cumulative stage
       VolCum := VolCum+VolInc;
       Stage1 := Stage1+StgInc1;
       Stage2 := Stage2+StgInc2;
       end;

       //Volume-Discharge Curve
       volDisGrid[1,I] := FormatFloat('0.#####', DisRate);
       volDisGrid[2,I] := FormatFloat('0.#####',InfRate);
       //Stage-Area Curve for ED Basin, Inf Basin, or Surcharge Basin
       stageAreaGrid1[1,I] := FormatFloat('0.#####', Area1); //constant area
       //Stage-Area Curve for Permanent Pool Basin
       stageAreaGrid2[1,I] := FormatFloat('0.#####',Area2); //constant area
       //Stage-Discharge Curve for Treatment
       stageDisTmtGrid[1,I] := volDisGrid[1,I];
       //Stage-Discharge Curve for Infiltration
       //2014 wrong conversion from sq.ft.in/hr to cfs stageDisInfGrid[1,I] := FormatFloat('0.#####',(12*InfRate*Area1)/3600); // constant infiltration outflow in cfs
       stageDisInfGrid[1,I] := FormatFloat('0.#####',(InfRate*Area1)/(12*3600)); // constant infiltration outflow in cfs

       InfRate := Inf; // constant infiltration rate in/hr
       if (DDT <> -1) then
       begin
         //InfRate := 0;
         if (DDT = 0) then
          DisRate := 0
        else
          DisRate := (WQV/DDT)/3600; //constant treatment outflow in cfs
       end
       else
        DisRate := InfRate; // for infiltration and bed filters DDT = -1 so use inf as primary discharge mechanism
    end;
  end;


procedure TSWTs.genericApply(var cbxNode:TComboBox; var tbxName:TEdit; var cbxOutlet:TComboBox; var sgDgn:TStringGrid; var sgEffl:TStringGrid);
  var
    volDis,stgAr1,stgAr2,stgDis1,stgDis2 : PLRMGridData;
begin
  with PLRMObj.currentNode do
  begin
      userName := cbxNode.Text;
      if cbxOutlet.ItemIndex <> -1 then
        outNode1 := (GSUtils.getComboBoxSelValue2(cbxOutlet) as TPLRMNode)
      else
        outNode1 := nil;

      designProps := copyGridContents(0,1,sgDgn);
      efflConcs := copyGridContents(0,1,sgEffl);
      if SWTType<5 then
      begin
        if userCustomizedCurveFlag = False then
        begin
        createAreaDischargeGrids(sgDgn,SWTType,volDis,stgAr1,stgAr2,stgDis1,stgDis2);
        volumeDischarge := volDis;
        stageArea1 := stgAr1;
        stageArea2 := stgAr2;
        stageTmtDischarge := stgDis1;
        stageInfDischarge := stgDis2;
        end;
      end;
  end;
end;

procedure TSWTs.btnApplyClick(Sender: TObject);
var
  tempNode:TPLRMNode;
  strErrVal:String;
begin
  tempNode := PLRMObj.currentNode;
  with PLRMObj.currentNode do
  begin
    //order matters this block before next block ??
  case PLRMObj.currentNode.SWTType of
    1://Detention basin
      genericApply(cbxSelDetNode,tbxDetName,cbxDetOutLet,sgDetDgnProps,sgDetEffl);
    2://Infiltration
      genericApply(cbxSelInfNode,tbxInfName,cbxInfOutLet,sgInfDgnProps,sgInfEffl);
    3://WetBasin
      genericApply(cbxSelWetNode,tbxWetName,cbxWetOutLet,sgWetDgnProps,sgWetEffl);
    4://Bed Filter
      genericApply(cbxSelGrnNode,tbxGrnName,cbxGrnOutLet,sgGrnDgnProps,sgGrnEffl);
    5://Cartridge Filter
      genericApply(cbxSelCrtNode,tbxCrtName,cbxCrtOutLet,sgCrtDgnProps,sgCrtEffl);
    6://Hydrodynamic Devices
      genericApply(cbxSelHydNode,tbxHydName,cbxHydOutLet,sgHydDgnProps,sgHydEffl);
    7: //other nodes: junctions, outfalls, flow dividers
    begin
      case PLRMObj.currentNode.swmmNode.NType of
      DIVIDER:  //update flow divider parameters
        begin
          userName := cbxSelFldNode.Text;
          if cbxFldLowFlowNode.ItemIndex <> -1 then
            outNode1 := (GSUtils.getComboBoxSelValue2(cbxFldLowFlowNode) as TPLRMNode)
          else
            outNode1 := nil;
          if cbxFldHighFlowNode.ItemIndex <> -1 then
            outNode2 := (GSUtils.getComboBoxSelValue2(cbxFldHighFlowNode) as TPLRMNode)
          else
            outNode2 := nil;
          maxFlow := tbxFldFlowRate.Text;
        end;
      JUNCTION:  //update junction parameters
        begin
          userName := cbxSelJunNode.Text;
          if cbxJunOutNode.ItemIndex <> -1 then
            outNode1 := (GSUtils.getComboBoxSelValue2(cbxJunOutNode) as TPLRMNode)
          else
            outNode1 := nil;
        end;
      OUTFALL:
        begin
          userName := cbxSelOutNode.Text;
        end;
      end;
    end;
  end;

  //assume node name changed and update swmm accordingly
  EditorObject := ObjType; // lets swmm functions know we are working with specified node type
  EditorIndex := ObjIndex;
  ValidateEditor(0,userName,strErrVal);
  PLRMObj.currentNode := tempNode;  //above code changes current node, so revert back
  end;
  PLRMObj.currentNode.hasDgnProps:= true;

end;

procedure TSWTs.btnCancelClick(Sender: TObject);
//var
//tempInt:Integer;
begin
  renameSWT(tempSWTName);
  ModalResult := mrCancel;
end;

procedure TSWTs.btnOkClick(Sender: TObject);
var
  tempNode:TPLRMNode;
begin
  okFlag := true;
  tempNode := PLRMObj.currentNode;
  btnApplyClick(Sender);
  PLRMObj.currentNode := tempNode;
   case PLRMObj.currentNode.SWTType of
    1://Detention basin
      btnDischargeCurveDetClick(Sender);
    2://Infiltration
      btnDischargeCurveInfClick(Sender);
    3://WetBasin
      btnDischargeCurveWetClick(Sender);
    4://Bed Filter
      btnDischargeCurveGrnClick(Sender);
    end;
    if Assigned(VolumeDischargeForm) then
    begin
      //VolumeDischargeForm.btnAutoCalcClick(Sender);
      VolumeDischargeForm.Close;
    end;
  ModalResult := mrOK;
end;

procedure TSWTs.FormCreate(Sender: TObject);
begin
  okFlag := false;
  statBar.SimpleText := PLRMVERSION;
  Self.Caption := PLRM7_TITLE;

    tempSWTName := PLRMObj.currentNode.userName; //used on cancel to restore old name
     //Note tempOutNodeCbx2 set to nil in GetProps prior to call this routine
     //0 = not a SWT, 1=Extended Detention Basin, 2=Infiltration Basin, 3=WetBasin, 4=Bed Filter, //5==Cartridge Filter, 6=Hydrodynamic Separator
     case swtType of
       1:
       begin
        initOrRestoreContents(sgDetDgnProps, sgDetEffl,'500',cbxSelDetNode, tbxDetName,cbxDetOutlet); //Detention
       end;
       2:
       begin
        initOrRestoreContents(sgInfDgnProps, sgInfEffl,'505',cbxSelInfNode, tbxInfName,cbxInfOutlet); //Infiltration
       end;
       3:
       begin
        initOrRestoreContents(sgWetDgnProps, sgWetEffl,'501',cbxSelWetNode, tbxWetName,cbxWetOutlet); //WetBasin
       end;
       4:
       begin
        initOrRestoreContents(sgGrnDgnProps, sgGrnEffl,'502',cbxSelGrnNode, tbxGrnName,cbxGrnOutlet); //Bed Filter
       end;
       5:
       begin
        initOrRestoreContents(sgCrtDgnProps, sgCrtEffl,'503',cbxSelCrtNode, tbxCrtName,cbxCrtOutlet); //Cartridge Filter bed
       end;
       6:
       begin
        initOrRestoreContents(sgHydDgnProps, sgHydEffl,'504',cbxSelHydNode, tbxHydName,cbxHydOutlet); //Hydrodynamic device
       end;
     end;
end;

procedure TSWTs.initOrRestoreContents(var sgDgnProps:TStringGrid; var sgEffl:TStringGrid;qryStrCode:String;var cbxNode:TCombobox; var txtName:TEdit; var cbxOutlet:TCombobox);
begin

    initOrRestoreContents(sgDgnProps,sgEffl,qryStrCode,cbxNode,txtName,cbxOutlet,PLRMObj.currentNode)
end;
procedure TSWTs.initOrRestoreContents(var sgDgnProps:TStringGrid; var sgEffl:TStringGrid;
                    qryStrCode:String;var cbxNode:TCombobox;var txtName:TEdit;var cbxOutlet:TCombobox; var Node:TPLRMNode);
var
  tempInt : Integer;
  dbProps :dbReturnFields3;
  data :PLRMGridData;
  outNodeList:TStringList;
begin
    Node.qryStrCode := qryStrCode; //store for later, written to xml and read back to help with restoration of dgn and effl data
    txtName.Text := Node.userName;
    cbxNode.Items := getSWTTypeNodes(swtType);//swtNodesList;
    tempInt :=  cbxNode.Items.IndexOf(Node.userName);
    if (tempInt <>-1) then  cbxNode.ItemIndex := tempInt;//then
    //cbxNode.ItemIndex := PLRMObj.getNodeIndex(Node.userName,PLRMObj.nodesTypeLists[swtType]);
    outNodeList :=  getAllExceptCurrentNode();
    cbxOutlet.Items := outNodeList;

    if ((Node.hasDgnProps = true) and assigned(Node.designProps)) then
    begin
      //tempInt := PLRMObj.nodes.IndexOf(Node.outNode1ID);
      if assigned(PLRMObj.currentNode.outNode1) and (PLRMObj.currentNode.outNode1.userName <> '') then
      begin
        tempInt := outNodeList.IndexOf(PLRMObj.currentNode.outNode1.userName);
        if tempInt <> -1 then
          cbxOutlet.ItemIndex := outNodeList.IndexOf(PLRMObj.currentNode.outNode1.userName);
      end;
        //cbxOutlet.ItemIndex := outNodeList.IndexOf((PLRMObj.nodes.Objects[tempInt] as TPLRMNode).userName);
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
    if ((PLRMObj.currentNode.xmlTagsDgn = nil) or (PLRMObj.currentNode.xmlTagsDgn.Count < 1)) then
      PLRMObj.currentNode.xmlTagsDgn:= GSIO.lookUpValFrmTable('SWTDesignParameters','xmlTag',7,false,'WHERE (SWT_Code like '+ qryStrCode + ')');
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
    //tempNode := nil;
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
     //tempNode := nil;
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
if (nodeID <> '') AND (nodeID <> '-1') then
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
    getSchmForm(PLRMObj.currentNode.SWTType);
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
      ShowMessage(CELLNOEDIT);
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
      ShowMessage(CELLNOEDIT);
    end
  else  sgDetEffl.Options:=sgDetEffl.Options+[goEditing];
end;

procedure TSWTs.cbxSelDetNodeOnChange(Sender: TObject);
var
  //tempInt: Integer;
  swtNodesList : TStringList; outNodesList : TStringList;
begin
  PLRMObj.currentNode := GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode;
  outNodesList := getAllExceptCurrentNode();
  swtNodesList := getSWTTypeNodes(swtType);
  with PLRMObj.currentNode do
  begin
    tbxDetName.Text := UserName;
    cbxSelDetNode.Items := swtNodesList;
    if (assigned(outNode1) and (outNode1.userName <> '')) then cbxDetOutlet.Text := outNode1.userName;
    cbxDetOutlet.Items := outNodesList;
  end;
end;

procedure TSWTs.cbxDetOutletOnChange(Sender: TObject);
var
swmmIndex : Integer;
tempID : String;
downLink : Uproject.TLink;
upNode, tempNode : TPLRMNode;
dwnNode : TPLRMNode;
PointList: array[0..1] of TPoint;
mapObj : Umap.TMap;
mapForm : Fmap.TMapForm;
begin
    //save current node so that we can revert later
  tempNode := PLRMObj.currentNode;
   mapObj := FMap.MapForm.Map;
   mapForm := Fmap.MapForm;
   //Check to see if link exists, if so remove it
   if (PLRMObj.currentNode.dwnLink is Uproject.TLink) then
   begin;
      swmmIndex := Project.Lists[CONDUIT].IndexOf(PLRMObj.currentNode.dwnLink.ID);
      if swmmIndex <> -1 then
      begin
        mapForm.EraseObject(CONDUIT,swmmIndex);
        PLRMObj.currentNode := tempNode; // needed after every swmm op that redraws
      end;
   end;
   upNode := PLRMObj.currentNode;
   dwnNode := (GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode);
   PointList[0] := Point(mapObj.GetXpix(upNode.swmmNode.X), mapObj.GetYpix(upNode.swmmNode.Y));
   PointList[1] := Point(mapObj.GetXpix(dwnNode.swmmNode.X), mapObj.GetYpix(dwnNode.swmmNode.Y));
   Uedit.AddLink(CONDUIT,upNode.swmmNode,dwnNode.swmmNode,PointList,0,tempID);
   swmmIndex := Project.Lists[CONDUIT].IndexOf(tempID);
   downLink := Project.GetLink(CONDUIT, swmmIndex);
   //PLRMObj.currentNode := upNode;
   PLRMObj.currentNode := tempNode;
   PLRMObj.currentNode.dwnLink := downLink;
   PLRMObj.currentNode.dwnLinkID := PLRMObj.currentNode.dwnLink.ID;
   if not(assigned(PLRMObj.currentNode.divertLink)) then
    PLRMObj.currentNode.divertLinkID := '-1';
   PLRMObj.currentNode.outNode1 := dwnNode;
   btnApplyClick(Sender);
   PLRMObj.currentNode := tempNode;

end;

procedure TSWTs.btnDischargeCurveDetClick(Sender: TObject);
var
WQV : Double; //water quality design volume
Area : Double; //footprint area
begin

  //Read in volume and area from grid
  WQV := StrToFloat(SWTs.sgDetDgnProps.Cells[USERVALCOL,DETWQVROW]); //user-provided volume
  Area := StrToFloat(SWTs.sgDetDgnProps.Cells[USERVALCOL,DETAREAROW]);//user-provided area

  if WQV = 0 then
    begin
    ShowMessage('Please provide a nonzero water quality volume');
    end
  else if Area = 0 then
    begin
    ShowMessage('Please provide a nonzero footprint area');
    end
  else
    begin
     btnApplyClick(Sender);
     //Load volume discharge data into form
     VolumeDischargeForm := TVolumeDischargeForm.Create(Application);
     VolumeDischargeForm.Show;
    end;
end;

 {$ENDREGION}

{$REGION 'Infiltration Basin Form Event Handlers'}
//-----------------------------------------------------------------------------
// Infiltration Basin Form Event Handlers
//-----------------------------------------------------------------------------
procedure TSWTs.lblInfSchmClick(Sender: TObject);
begin
   getSchmForm(PLRMObj.currentNode.SWTType);
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

procedure TSWTs.sgInfDgnPropsKeyPress(Sender: TObject; var Key: Char);
begin
  gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TSWTs.sgInfDgnPropsSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
begin
  if (ACol<3) then
    begin
      sgInfDgnProps.Options:=sgInfDgnProps.Options-[goEditing];
      ShowMessage(CELLNOEDIT);
    end
  else
  begin
    sgInfDgnProps.Options:=sgInfDgnProps.Options+[goEditing];
  end;
end;

procedure TSWTs.sgInfEfflKeyPress(Sender: TObject; var Key: Char);
begin
  gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TSWTs.cbxSelInfNodeOnChange(Sender: TObject);
var
  //tempInt: Integer;
  swtNodesList : TStringList; outNodesList : TStringList;
begin
  PLRMObj.currentNode := GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode;
  outNodesList := getAllExceptCurrentNode();
  swtNodesList := getSWTTypeNodes(swtType);
  with PLRMObj.currentNode do
  begin
    tbxInfName.Text := UserName;
    cbxSelInfNode.Items := swtNodesList;
    //initOrRestoreContents(sgInfDgnProps, sgInfEffl,'505');
    //cbxInfOutlet.Text := getNodeNamefromNodeId(outNode1ID);
    cbxInfOutlet.Items := outNodesList;
    if (assigned(outNode1) and (outNode1.userName <> '')) then cbxInfOutlet.Text := outNode1.userName;
  end;
end;

procedure TSWTs.btnDischargeCurveInfClick(Sender: TObject);
var
WQV : Double;  //water quality design volume
//DDT : Double;  //drawdown time
Area : Double; //footprint area
Inf : Double;  //infiltration rate
//sgVolDis, sgStgArea, sgDisTmnt, sgDisInf : TStringGrid;
begin

  //Read in volume and area from grid
  WQV := StrToFloat(SWTs.sgInfDgnProps.Cells[USERVALCOL,INFWQVROW]); //user-provided volume
  Area := StrToFloat(SWTs.sgInfDgnProps.Cells[USERVALCOL,INFAREAROW]);//user-provided area
  Inf := StrToFloat(SWTs.sgInfDgnProps.Cells[USERVALCOL,INFINFROW]);//user-provided infiltration rate

  if WQV = 0 then
    begin
    ShowMessage('Please provide a nonzero water quality volume');
    end
  else if Area = 0 then
    begin
    ShowMessage('Please provide a nonzero footprint area');
    end
  else if Inf = 0 then
    begin
    ShowMessage('Please provide a nonzero infiltration rate');
    end
  else
    begin
     btnApplyClick(Sender);
     //Load volume discharge data into form
     VolumeDischargeForm := TVolumeDischargeForm.Create(Application);
     VolumeDischargeForm.sgVolDischarge.ColWidths[1] :=0;
     VolumeDischargeForm.Show;
    end;
end;

{$ENDREGION}

{$REGION 'WetBasin Form Event Handlers'}
//-----------------------------------------------------------------------------
// WetBasin Form Event Handlers
//-----------------------------------------------------------------------------
procedure TSWTs.lblWetlSchmClick(Sender: TObject);
begin
   getSchmForm(PLRMObj.currentNode.SWTType);
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

procedure TSWTs.sgWetDgnPropsKeyPress(Sender: TObject; var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TSWTs.sgWetDgnPropsSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
begin
  if (ACol<3) then
    begin
      sgWetDgnProps.Options:=sgWetDgnProps.Options-[goEditing];
      ShowMessage(CELLNOEDIT);
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

procedure TSWTs.sgWetEfflKeyPress(Sender: TObject; var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TSWTs.sgWetEfflSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
begin
  if (ACol<3) then
    begin
      sgWetEffl.Options:=sgWetEffl.Options-[goEditing];
      ShowMessage(CELLNOEDIT);
    end
  else
  begin
    sgWetEffl.Options:=sgWetEffl.Options+[goEditing];
  end;
end;



procedure TSWTs.tbxCrtNameExit(Sender: TObject);
begin
genericNameChange(Sender,PLRMObj.currentNode, PLRMObj.nodeAndCatchNames,cbxSelCrtNode);
end;

procedure TSWTs.tbxCrtNameKeyPress(Sender: TObject; var Key: Char);
begin
  gsEditKeyPressNoSpace(Sender,Key,gemPosNumber) ;
end;

procedure TSWTs.tbxDetNameExit(Sender: TObject);
begin
  genericNameChange(Sender,PLRMObj.currentNode, PLRMObj.nodeAndCatchNames,cbxSelDetNode);
end;

procedure TSWTs.tbxDetNameKeyPress(Sender: TObject; var Key: Char);
begin
  gsEditKeyPressNoSpace(Sender,Key,gemPosNumber) ;
end;

procedure TSWTs.tbxFldNameExit(Sender: TObject);
begin
  genericNameChange(Sender,PLRMObj.currentNode, PLRMObj.nodeAndCatchNames,cbxSelFldNode);
end;

procedure TSWTs.tbxFldNameKeyPress(Sender: TObject; var Key: Char);
begin
  gsEditKeyPressNoSpace(Sender,Key,gemPosNumber) ;
end;

procedure TSWTs.tbxGrnNameExit(Sender: TObject);
begin
  genericNameChange(Sender,PLRMObj.currentNode, PLRMObj.nodeAndCatchNames,cbxSelGrnNode);
end;

procedure TSWTs.tbxGrnNameKeyPress(Sender: TObject; var Key: Char);
begin
  gsEditKeyPressNoSpace(Sender,Key,gemPosNumber) ;
end;

procedure TSWTs.tbxHydNameExit(Sender: TObject);
begin
  genericNameChange(Sender,PLRMObj.currentNode, PLRMObj.nodeAndCatchNames,cbxSelHydNode);
end;

procedure TSWTs.tbxHydNameKeyPress(Sender: TObject; var Key: Char);
begin
  gsEditKeyPressNoSpace(Sender,Key,gemPosNumber) ;
end;

procedure TSWTs.tbxInfNameExit(Sender: TObject);
begin
  genericNameChange(Sender,PLRMObj.currentNode, PLRMObj.nodeAndCatchNames,cbxSelInfNode);
end;

procedure TSWTs.tbxInfNameKeyPress(Sender: TObject; var Key: Char);
begin
  gsEditKeyPressNoSpace(Sender,Key,gemPosNumber) ;
end;

procedure TSWTs.tbxJunNameExit(Sender: TObject);
begin
  genericNameChange(Sender,PLRMObj.currentNode, PLRMObj.nodeAndCatchNames,cbxSelJunNode);
end;

procedure TSWTs.tbxJunNameKeyPress(Sender: TObject; var Key: Char);
begin
  gsEditKeyPressNoSpace(Sender,Key,gemPosNumber) ;
end;

procedure TSWTs.tbxOutNameExit(Sender: TObject);
begin
  genericNameChange(Sender,PLRMObj.currentNode, PLRMObj.nodeAndCatchNames,cbxSelOutNode);
end;

procedure TSWTs.tbxOutNameKeyPress(Sender: TObject; var Key: Char);
begin
  gsEditKeyPressNoSpace(Sender,Key,gemPosNumber) ;
end;

procedure TSWTs.tbxWetNameExit(Sender: TObject);
begin
genericNameChange(Sender,PLRMObj.currentNode, PLRMObj.nodeAndCatchNames,cbxSelWetNode);
end;

procedure TSWTs.tbxWetNameKeyPress(Sender: TObject; var Key: Char);
begin
  gsEditKeyPressNoSpace(Sender,Key,gemPosNumber) ;
end;

procedure TSWTs.genericNameChange(Sender: TObject; var Node:TPLRMNode; namesList:TStringList; Cbx:TCombobox);
var
  tempInt :Integer;
  strErrVal:String;
  tempTbx:TEdit;
  tempNode:TPLRMNode;
begin
    tempTbx := Sender as TEdit;
    if tempTbx.Text = '' then exit;

    if Node.userName <> tempTbx.Text then
    begin
      tempInt := namesList.IndexOf(tempTbx.Text);
      if tempInt <> -1 then
      begin
        ShowMessage('The object name you have provided is already in use. Please try another name');
        tempTbx.Text := Node.userName
      end
      else
      begin

         tempInt := Cbx.items.IndexOf(Node.userName);
         if tempInt <> - 1 then
         begin
          Cbx.items[tempInt] := tempTbx.Text;
          Cbx.ItemIndex := tempInt;
         end;

         tempInt := namesList.IndexOf(Node.userName);
         namesList[tempInt] := tempTbx.Text;

         tempInt := PLRMObj.nodes.IndexOf(Node.userName);
         PLRMObj.nodes[tempInt] := tempTbx.Text;

         tempInt := PLRMObj.nodesTypeLists[Node.SWTType].IndexOf(Node.userName);
         PLRMObj.nodesTypeLists[Node.SWTType][tempInt] := tempTbx.Text;

         Node.userName :=  tempTbx.Text;

         //update name in swmm
         EditorObject := Node.ObjType; // lets swmm functions know we are working with specified node type
         EditorIndex := Node.ObjIndex;
         tempNode := PLRMObj.currentNode;
         ValidateEditor(0,Node.userName,strErrVal);
         PLRMObj.currentNode := tempNode;
      end;
    end;
end;

procedure TSWTs.renameSWT(strName:String);
var
  tempInt:Integer;
  strErrVal:String;
  tempNode:TPLRMNode;
begin
    if strName = '' then exit;

    if PLRMObj.currentNode.userName <> strName then
    begin
      tempInt := PLRMObj.nodeAndCatchNames.IndexOf(PLRMObj.currentNode.userName);
      PLRMObj.nodeAndCatchNames[tempInt] := strName;

      tempInt := PLRMObj.nodes.IndexOf(PLRMObj.currentNode.userName);
      PLRMObj.nodes[tempInt] := strName;

      tempInt := PLRMObj.nodesTypeLists[PLRMObj.currentNode.SWTType].IndexOf(PLRMObj.currentNode.userName);
      PLRMObj.nodesTypeLists[PLRMObj.currentNode.SWTType][tempInt] := strName;

      PLRMObj.currentNode.userName :=  strName;

      //update name in swmm
      EditorObject := PLRMObj.currentNode.ObjType; // lets swmm functions know we are working with specified node type
      EditorIndex := PLRMObj.currentNode.ObjIndex;
      tempNode := PLRMObj.currentNode;
      ValidateEditor(0,PLRMObj.currentNode.userName,strErrVal);
      PLRMObj.currentNode := tempNode;
    end;
end;

procedure TSWTs.cbxSelWetNodeOnChange(Sender: TObject);
var
  //tempInt: Integer;
  swtNodesList : TStringList; outNodesList : TStringList;
begin
  PLRMObj.currentNode := GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode;
  outNodesList := getAllExceptCurrentNode();
  swtNodesList := getSWTTypeNodes(swtType);
  with PLRMObj.currentNode do
  begin
    tbxWetName.Text := UserName;
    cbxSelWetNode.Items := swtNodesList;
    cbxWetOutlet.Items := outNodesList;
    if (assigned(outNode1) and (outNode1.userName <> '')) then cbxWetOutlet.Text := outNode1.userName;
  end;
end;


procedure TSWTs.btnDischargeCurveWetClick(Sender: TObject); //WetBasin Discharge Curve
var
SURV : Double; //surcharge design volume
Area : Double; //footprint area
begin

  //Read in volume and area from grid
  SURV := StrToFloat(SWTs.sgWetDgnProps.Cells[USERVALCOL,WETSURVROW]); //user-provided volume
  Area := StrToFloat(SWTs.sgWetDgnProps.Cells[USERVALCOL,WETAREAROW]);//user-provided area

  if ((SURV = 0) and (okFlag = false)) then
    begin
      ShowMessage('This button applies to the surcharge storage. Please provide a nonzero surcharge volume if you would like to specify a custom curve');
      okFlag := false;
    end
  else if Area = 0 then
    begin
    ShowMessage('Please provide a nonzero footprint area');
    end
  else
    begin
     btnApplyClick(Sender);
     //Load volume discharge data into form
     VolumeDischargeForm := TVolumeDischargeForm.Create(Application);
     VolumeDischargeForm.sgVolDischarge.ColWidths[2] :=0;
     VolumeDischargeForm.Show;
     //VolumeDischargeForm.ShowModal;
    end;
end;

{$ENDREGION}

{$REGION 'Bed Filter Form Event Handlers'}
//-----------------------------------------------------------------------------
// Bed Filter Form Event Handlers
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

procedure TSWTs.sgGrnDgnPropsKeyPress(Sender: TObject; var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TSWTs.sgGrnDgnPropsSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
begin
  if (ACol<3) then
    begin
      sgGrnDgnProps.Options:=sgGrnDgnProps.Options-[goEditing];
      ShowMessage(CELLNOEDIT);
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

procedure TSWTs.sgGrnEfflKeyPress(Sender: TObject; var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TSWTs.sgGrnEfflSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
begin
  if (ACol<3) then
    begin
      sgGrnEffl.Options:=sgGrnEffl.Options-[goEditing];
      ShowMessage(CELLNOEDIT);
    end
  else
  begin
    sgGrnEffl.Options:=sgGrnEffl.Options+[goEditing];
  end;
end;

procedure TSWTs.lblFiltSchmClick(Sender: TObject);
begin
    getSchmForm(PLRMObj.currentNode.SWTType);
end;

procedure TSWTs.cbxSelGrnNodeOnChange(Sender: TObject);
var
  swtNodesList : TStringList; outNodesList : TStringList;
begin
  PLRMObj.currentNode := GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode;
  outNodesList := getAllExceptCurrentNode();
  swtNodesList := getSWTTypeNodes(swtType);
  with PLRMObj.currentNode do
  begin
    tbxGrnName.Text := UserName;
    cbxSelGrnNode.Items := swtNodesList;
    cbxGrnOutlet.Items := outNodesList;
    if (assigned(outNode1) and (outNode1.userName <> '')) then cbxGrnOutlet.Text := outNode1.userName;
  end;
end;

procedure TSWTs.btnDischargeCurveGrnClick(Sender: TObject); //Bed Discharge Curve
var
EQV : Double; //surcharge design volume
Area : Double; //footprint area
Inf : Double; //infiltration rate
begin
  //Read in volume and area from grid
  EQV := StrToFloat(SWTs.sgGrnDgnProps.Cells[USERVALCOL,GRNEQVROW]); //user-provided volume
  Area := StrToFloat(SWTs.sgGrnDgnProps.Cells[USERVALCOL,GRNAREAROW]);//user-provided area
  Inf := StrToFloat(SWTs.sgGrnDgnProps.Cells[USERVALCOL,GRNINFROW]);//user-provided infiltration rate

  if EQV = 0 then
    begin
    ShowMessage('Please provide a nonzero equalization volume');
    end
  else if Area = 0 then
    begin
    ShowMessage('Please provide a nonzero footprint area');
    end
  else if Inf = 0 then
    begin
    ShowMessage('Please provide a nonzero infiltration rate');
    end
  else
    begin
     btnApplyClick(Sender);
     //Load volume discharge data into form
     VolumeDischargeForm := TVolumeDischargeForm.Create(Application);
     VolumeDischargeForm.sgVolDischarge.ColWidths[1] :=0;
     VolumeDischargeForm.Show;
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

procedure TSWTs.sgCrtDgnPropsKeyPress(Sender: TObject; var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TSWTs.sgCrtDgnPropsSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
begin
  if (ACol<3) then
    begin
      sgCrtDgnProps.Options:=sgCrtDgnProps.Options-[goEditing];
      ShowMessage(CELLNOEDIT);
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

procedure TSWTs.sgCrtEfflKeyPress(Sender: TObject; var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TSWTs.sgCrtEfflSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
begin
  if (ACol<3) then
    begin
      sgCrtEffl.Options:=sgCrtEffl.Options-[goEditing];
      ShowMessage(CELLNOEDIT);
    end
  else
  begin
    sgCrtEffl.Options:=sgCrtEffl.Options+[goEditing];
  end;
end;

procedure TSWTs.cbxSelCrtNodeOnChange(Sender: TObject);
var
  //tempInt: Integer;
  swtNodesList : TStringList; outNodesList : TStringList;
begin
  PLRMObj.currentNode := GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode;
  outNodesList := getAllExceptCurrentNode();
  swtNodesList := getSWTTypeNodes(swtType);
  with PLRMObj.currentNode do
  begin
    tbxCrtName.Text := UserName;
    cbxSelCrtNode.Items := swtNodesList;
    cbxCrtOutlet.Items := outNodesList;
    if (assigned(outNode1) and (outNode1.userName <> '')) then cbxCrtOutlet.Text := outNode1.userName;
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

procedure TSWTs.sgHydDgnPropsKeyPress(Sender: TObject; var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TSWTs.sgHydDgnPropsSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
begin
  if (ACol<3) then
    begin
      sgHydDgnProps.Options:=sgHydDgnProps.Options-[goEditing];
      ShowMessage(CELLNOEDIT);
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

procedure TSWTs.sgHydEfflKeyPress(Sender: TObject; var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TSWTs.sgHydEfflSelectCell(Sender: TObject; ACol, ARow: Integer;var CanSelect: Boolean);
begin
  if (ACol<3) then
    begin
      sgHydEffl.Options:=sgHydEffl.Options-[goEditing];
      ShowMessage(CELLNOEDIT);
    end
  else
  begin
    sgHydEffl.Options:=sgHydEffl.Options+[goEditing];
  end;
end;
procedure TSWTs.lblHydSchmClick(Sender: TObject);
begin
   getSchmForm(PLRMObj.currentNode.SWTType);
end;

procedure TSWTs.cbxSelHydNodeOnChange(Sender: TObject);
var
  swtNodesList : TStringList; outNodesList : TStringList;
begin
  PLRMObj.currentNode := GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode;
  outNodesList := getAllExceptCurrentNode();
  swtNodesList := getSWTTypeNodes(swtType);
  with PLRMObj.currentNode do
  begin
    tbxHydName.Text := UserName;
    cbxSelHydNode.Items := swtNodesList;
    cbxHydOutlet.Items := outNodesList;
    if (assigned(outNode1) and (outNode1.userName <> '')) then cbxHydOutlet.Text := outNode1.userName;
  end;
end;


{$ENDREGION}

{$REGION 'Other Nodes Form Event Handlers'}
//-----------------------------------------------------------------------------
// Other Nodes Form Event Handlers
//-----------------------------------------------------------------------------

procedure TSWTs.cbxSelFldNodeOnChange(Sender: TObject);
var
diNodesList : TStringList;
//outNodesList : TStringList;
begin
  PLRMObj.currentNode := GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode;
  //outNodesList := getAllExceptCurrentNode();
  diNodesList := getNodeType(DIVIDER);
  with PLRMObj.currentNode do
  begin
    tbxFldName.Text := UserName;
    cbxSelFldNode.Items := diNodesList;
    if (assigned(outNode1) and (outNode1.userName <> '')) then cbxFldLowFlowNode.Text := outNode1.userName;
    if (assigned(outNode2) and (outNode2.userName <> '')) then cbxFldHighFlowNode.Text := outNode2.userName;
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
tempNode :TPLRMNode;
PointList: array[0..1] of TPoint;
mapObj : Umap.TMap;
mapForm : Fmap.TMapForm;
begin
  //save current node so that we can revert later
  tempNode := PLRMObj.currentNode;
   mapObj := FMap.MapForm.Map;
   mapForm := Fmap.MapForm;
   //Check to see if link exists, if so remove it
  //10/18 if (PLRMObj.currentNode.dwnLink is Uproject.TLink) then
  if assigned(PLRMObj.currentNode.outNode1) then
  
   begin
      if assigned(PLRMObj.currentNode.dwnLink.ID) then
      begin;
        swmmIndex := Project.Lists[CONDUIT].IndexOf(PLRMObj.currentNode.dwnLink.ID);
        if swmmIndex <> -1 then mapForm.EraseObject(CONDUIT,swmmIndex);
        PLRMObj.currentNode := tempNode; // needed after every swmm op that redraws
      end;
   end;
   upNode := PLRMObj.currentNode;
   dwnNode := (GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode);
   PointList[0] := Point(mapObj.GetXpix(upNode.swmmNode.X), mapObj.GetYpix(upNode.swmmNode.Y));
   PointList[1] := Point(mapObj.GetXpix(dwnNode.swmmNode.X), mapObj.GetYpix(dwnNode.swmmNode.Y));
   Uedit.AddLink(CONDUIT,upNode.swmmNode,dwnNode.swmmNode,PointList,0,tempID);
   swmmIndex := Project.Lists[CONDUIT].IndexOf(tempID);
   downLink := Project.GetLink(CONDUIT, swmmIndex);
   PLRMObj.currentNode := tempNode;
   PLRMObj.currentNode.dwnLink := downLink;
   PLRMObj.currentNode.dwnLinkID := PLRMObj.currentNode.dwnLink.ID;
   if not(assigned(PLRMObj.currentNode.divertLink)) then
    PLRMObj.currentNode.divertLinkID := '-1';
   PLRMObj.currentNode.outNode1 := dwnNode;
   btnApplyClick(Sender);
   PLRMObj.currentNode := tempNode;
   //downLink := nil;
   //upNode := nil;
   //dwnNode := nil;
   //tempNode := nil;
end;

procedure TSWTs.cbxFldHighFlowNodeOnChange(Sender: TObject);
var
swmmIndex : Integer;
tempID : String;
downLink : Uproject.TLink;
upNode : TPLRMNode;
dwnNode : TPLRMNode;
tempNode :TPLRMNode;
PointList: array[0..1] of TPoint;
mapObj : Umap.TMap;
mapForm : Fmap.TMapForm;
begin
  tempNode := PLRMObj.currentNode;
   mapObj := FMap.MapForm.Map;
   mapForm := Fmap.MapForm;
   //Check to see if link exists, if so remove it
   if (PLRMObj.currentNode.divertLink is Uproject.TLink and assigned(PLRMObj.currentNode.outNode2)) then
      begin;
      swmmIndex := Project.Lists[CONDUIT].IndexOf(PLRMObj.currentNode.divertLink.ID);
      if swmmIndex <> -1 then mapForm.EraseObject(CONDUIT,swmmIndex);
      PLRMObj.currentNode := tempNode; // needed after every swmm op that redraws
      end;
    upNode := PLRMObj.currentNode;
    dwnNode := (GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode);
    PointList[0] := Point(mapObj.GetXpix(upNode.swmmNode.X), mapObj.GetYpix(upNode.swmmNode.Y));
    PointList[1] := Point(mapObj.GetXpix(dwnNode.swmmNode.X), mapObj.GetYpix(dwnNode.swmmNode.Y));
    Uedit.AddLink(CONDUIT,upNode.swmmNode,dwnNode.swmmNode,PointList,0,tempID);
    swmmIndex := Project.Lists[CONDUIT].IndexOf(tempID);
    downLink := Project.GetLink(CONDUIT, swmmIndex);
    PLRMObj.currentNode := tempNode;
    PLRMObj.currentNode.divertLink := downLink;
    PLRMObj.currentNode.divertLinkID := PLRMObj.currentNode.divertLink.ID;
    //PLRMObj.currentNode := upNode;
    PLRMObj.currentNode.outNode2 := dwnNode;
    btnApplyClick(Sender);
    PLRMObj.currentNode := tempNode;
    //downLink := nil;
    //upNode := nil;
    //dwnNode := nil;
    //tempNode := nil;
end;


procedure TSWTs.cbxSelJunNodeOnChange(Sender: TObject);
var
  juNodesList : TStringList;
begin
  PLRMObj.currentNode := GSUtils.getComboBoxSelValue2(Sender) as TPLRMNode;
  juNodesList := getNodeType(JUNCTION);
  with PLRMObj.currentNode do
  begin
    tbxJunName.Text := UserName;
    cbxSelJunNode.Items := juNodesList;
    if (assigned(outNode1) and (outNode1.userName <> '')) then cbxJunOutNode.Text := outNode1.userName;
  end;
end;


procedure TSWTs.cbxSelOutNodeOnChange(Sender: TObject);
var
  ofNodesList : TStringList;
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
