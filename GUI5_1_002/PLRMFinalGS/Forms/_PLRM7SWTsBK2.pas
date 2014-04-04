unit _PLRM7SWTsBK2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, Grids, ComCtrls;

type
  TSWTs3 = class(TForm)
    pgCtrl: TPageControl;
    TabSheet3: TTabSheet;
    GroupBox5: TGroupBox;
    sgDetEffl: TStringGrid;
    GroupBox6: TGroupBox;
    Button1: TButton;
    sgDetDgnProps: TStringGrid;
    TabSheet4: TTabSheet;
    TabSheet1: TTabSheet;
    Image1: TImage;
    btnOk: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    Label8: TLabel;
    cbxDetSelNode: TComboBox;
    lblDetSchm: TLabel;
    StatusBar1: TStatusBar;
    Edit1: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    ComboBox1: TComboBox;
    GroupBox3: TGroupBox;
    Image2: TImage;
    Image4: TImage;
    cbxSelInfNode: TComboBox;
    Label2: TLabel;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    Edit2: TEdit;
    ComboBox3: TComboBox;
    GroupBox2: TGroupBox;
    lblInfSchm: TLabel;
    Button2: TButton;
    sgInfiltDgnProps: TStringGrid;
    GroupBox4: TGroupBox;
    StringGrid2: TStringGrid;
    Image3: TImage;
    cbxSelHydNode: TComboBox;
    Label9: TLabel;
    GroupBox7: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Edit3: TEdit;
    ComboBox5: TComboBox;
    GroupBox8: TGroupBox;
    lblHydSchm: TLabel;
    Button3: TButton;
    sgHydDgnProps: TStringGrid;
    GroupBox9: TGroupBox;
    StringGrid4: TStringGrid;
    TabSheet2: TTabSheet;
    TabSheet5: TTabSheet;
    Label13: TLabel;
    cbxSelFiltNode: TComboBox;
    Image5: TImage;
    GroupBox10: TGroupBox;
    Label14: TLabel;
    Label15: TLabel;
    Edit4: TEdit;
    ComboBox7: TComboBox;
    GroupBox11: TGroupBox;
    lblFiltSchm: TLabel;
    Button4: TButton;
    sgCFiltrDgnProps: TStringGrid;
    Label17: TLabel;
    cbxSelWetlNode: TComboBox;
    Image6: TImage;
    GroupBox13: TGroupBox;
    Label18: TLabel;
    Label19: TLabel;
    Edit5: TEdit;
    ComboBox9: TComboBox;
    GroupBox14: TGroupBox;
    lblWetlSchm: TLabel;
    Button5: TButton;
    sgWetlDgnProps: TStringGrid;
    GroupBox15: TGroupBox;
    sgWetlEffl: TStringGrid;
    ComboBox10: TComboBox;
    Label21: TLabel;
    GroupBox12: TGroupBox;
    Label22: TLabel;
    StringGrid6: TStringGrid;
    ComboBox11: TComboBox;
    TabSheet6: TTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure initGrids(sgDgnProps:TStringGrid; sgEffl:TStringGrid; qryStrCode:String);
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
  private
    { Private declarations }
  public
    { Public declarations }
  end;
procedure getSWTProps(nodeID:String; swtTypeNum:Integer);

var
  SWTs3: TSWTs3;
  swtType:Integer;

implementation

{$R *.dfm}
uses
GSIO, GSUtils, GSTypes, GSPLRM, UProject,UGlobals, _PLRMD4Schematics;

procedure getSWTProps(nodeID:String; swtTypeNum:Integer);
  var
    tempInt : Integer;
    I: Integer;
  begin
    swtType := swtTypeNum ;
    SWTs3 := TSWTs3.Create(Application);
    //swtType := swtTypeNum ;

    for I := 0 to SWTs3.pgCtrl.PageCount - 1 do
      SWTs3.pgCtrl.Pages[I].TabVisible := false;

    case swtType of
       1:
        begin
          SWTs3.cbxDetSelNode.Items := PLRMObj.nodesTypeLists[swtType];
          SWTs3.cbxDetSelNode.ItemIndex := PLRMObj.getNodeIndex(nodeID,PLRMObj.nodesTypeLists[swtType]);
          SWTs3.pgCtrl.Pages[0].TabVisible := true;  //Detention
        end;
       2:
       begin
          SWTs3.cbxSelInfNode.Items := PLRMObj.nodesTypeLists[swtType];
          SWTs3.cbxSelInfNode.ItemIndex := PLRMObj.getNodeIndex(nodeID,PLRMObj.nodesTypeLists[swtType]);
          SWTs3.pgCtrl.Pages[1].TabVisible := true; //Infiltration
       end;
       3:
       begin
          SWTs3.cbxSelWetlNode.Items := PLRMObj.nodesTypeLists[swtType];
          SWTs3.cbxSelWetlNode.ItemIndex := PLRMObj.getNodeIndex(nodeID,PLRMObj.nodesTypeLists[swtType]);
          SWTs3.pgCtrl.Pages[4].TabVisible := true; //Wetland
       end;
       4:
       begin
          SWTs3.cbxSelFiltNode.Items := PLRMObj.nodesTypeLists[swtType];
          SWTs3.cbxSelFiltNode.ItemIndex := PLRMObj.getNodeIndex(nodeID,PLRMObj.nodesTypeLists[swtType]);
          SWTs3.pgCtrl.Pages[3].TabVisible := true; //'Filter'
       end;
       5:
       begin
          SWTs3.cbxSelHydNode.Items := PLRMObj.nodesTypeLists[swtType];
          SWTs3.cbxSelHydNode.ItemIndex := PLRMObj.getNodeIndex(nodeID,PLRMObj.nodesTypeLists[swtType]);
          SWTs3.pgCtrl.Pages[2].TabVisible := true; //'Hydrodynamic Device'
       end;
    end;
    try
      tempInt := SWTs3.ShowModal;
    finally
      SWTs3.Free;
    end;
end;

procedure TSWTs3.btnApplyClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TSWTs3.btnCancelClick(Sender: TObject);
begin
ModalResult := mrCancel;
end;

procedure TSWTs3.btnOkClick(Sender: TObject);
begin
ModalResult := mrOK;
end;

procedure TSWTs3.FormCreate(Sender: TObject);
var
  tempInt,I : Integer;
  dbProps :dbReturnFields3;
  data :PLRMGridData;
begin
     case swtType of
       1:
          initGrids( sgDetDgnProps, sgDetEffl,'500'); //Detention
       2:
         initGrids( sgInfiltDgnProps, sgDetEffl,'505'); //Infiltration
       3:
         initGrids( sgWetlDgnProps, sgDetEffl,'501'); //Wetland
       4:
         initGrids( sgDetDgnProps, sgDetEffl,'502');  //Granular bed Filter
       5:
       initGrids( sgHydDgnProps, sgDetEffl,'504');  //Hydrodynamic device
       6:
       initGrids( sgCFiltrDgnProps, sgDetEffl,'503');  //Cartridge Filter bed
     end;
end;

procedure TSWTs3.initGrids(sgDgnProps:TStringGrid; sgEffl:TStringGrid; qryStrCode:String);
var
  tempInt,I : Integer;
  dbProps :dbReturnFields3;
  data :PLRMGridData;
begin
    sgDgnProps.Cells[0,0] := 'Parameters';
    sgDgnProps.Cells[1,0] := 'Default Value';
    sgDgnProps.Cells[2,0] := 'Units';
    sgDgnProps.Cells[3,0] := 'Value';

    sgEffl.Cells[0,0] := 'Pollutants of Concern';
    sgEffl.Cells[1,0] := 'Default Value';
    sgEffl.Cells[2,0] := 'Units';
    sgEffl.Cells[3,0] := 'Value';

    //Read defaults from database
    dbProps := GSIO.getDesignParams(qryStrCode,2,3,4,7);
    data := dbFields3ToPLRMGridData(dbProps,0);
    copyContentsToGridAddRows(data,0,1,sgDgnProps);

    //Read defaults from database
    dbProps := GSIO.getEfflQuals(qryStrCode,2,3,4,7);
    data := dbFields3ToPLRMGridData(dbProps,0);
    copyContentsToGridAddRows(data,0,1,sgEffl);

end;

procedure TSWTs3.lblDetSchmMouseEnter(Sender: TObject);
begin
   lblDetSchm.Font.Size := 10;
   lblDetSchm.Font.Color := clGreen;
end;

procedure TSWTs3.lblDetSchmMouseLeave(Sender: TObject);
begin
  lblDetSchm.Font.Size := 9;
  lblDetSchm.Font.Color := clBlue;
end;

procedure TSWTs3.lblDetSchmClick(Sender: TObject);
begin
    getSchmForm(1);
end;  

procedure TSWTs3.lblInfSchmClick(Sender: TObject);
begin
   getSchmForm(2);
end;

procedure TSWTs3.lblHydSchmClick(Sender: TObject);
begin
   getSchmForm(3);
end;

procedure TSWTs3.lblFiltSchmClick(Sender: TObject);
begin
    getSchmForm(4);
end;

procedure TSWTs3.lblWetlSchmClick(Sender: TObject);
begin
   getSchmForm(5);
end;

//generalized event handles
procedure TSWTs3.lblMouseEnter(Sender: TObject);
begin
   (Sender as TLabel).Font.Size := 10;
   (Sender as TLabel).Font.Color := clGreen;
end;

procedure TSWTs3.lblMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Size := 9;
  (Sender as TLabel).Font.Color := clBlue;
end;

end.
