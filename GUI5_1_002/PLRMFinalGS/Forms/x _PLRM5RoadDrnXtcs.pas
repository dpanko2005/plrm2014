unit x_PLRM5RoadDrnXtcs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, xmldom, XMLIntf, msxmldom, XMLDoc,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, jpeg, Grids, GSUtils, GSTypes, GSPLRM, GSCatchments, UProject,
  _PLRM6DrngXtsDetail, Buttons;

type
  TPLRMDrainageConditions = class(TForm)
    Image1: TImage;
    btnCancel: TButton;
    btnOK: TButton;
    statBar: TStatusBar;
    btnApply: TButton;
    pgCtrlParcelRds: TPageControl;
    TabSheet4: TTabSheet;
    GroupBox2: TGroupBox;
    Panel8: TPanel;
    sgSFR: TStringGrid;
    Label3: TLabel;
    Label6: TLabel;
    Label19: TLabel;
    Panel7: TPanel;
    Panel9: TPanel;
    btnEditSFROut: TButton;
    btnEditSFRInf: TButton;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    lblSfrHdr: TLabel;
    Panel2: TPanel;
    Label1: TLabel;
    Label4: TLabel;
    lblMfrHdr: TLabel;
    Panel5: TPanel;
    Label17: TLabel;
    Label18: TLabel;
    lblCicHdr: TLabel;
    Panel6: TPanel;
    Label16: TLabel;
    lblVegHdr: TLabel;
    Panel10: TPanel;
    sgMFR: TStringGrid;
    Panel11: TPanel;
    sgCICU: TStringGrid;
    Panel12: TPanel;
    sgVeg: TStringGrid;
    Panel13: TPanel;
    btnEditMFROut: TButton;
    btnEditMFRInf: TButton;
    cbxMFRInf: TComboBox;
    cbxMFROut: TComboBox;
    Panel14: TPanel;
    btnEdtCICUOut: TButton;
    btnEditCICUInf: TButton;
    Panel15: TPanel;
    btnEditVegTurfOut: TButton;
    Label30: TLabel;
    Label9: TLabel;
    Label25: TLabel;
    Label31: TLabel;
    TabSheet3: TTabSheet;
    GroupBox1: TGroupBox;
    Label11: TLabel;
    Panel1: TPanel;
    sgPrimRds: TStringGrid;
    Panel3: TPanel;
    Label12: TLabel;
    Label13: TLabel;
    lblPrrHdr: TLabel;
    Label28: TLabel;
    Panel4: TPanel;
    btnRdPrimDspEdit: TButton;
    btnRdPrimInfEdit: TButton;
    cbxGlobalSpecfc: TComboBox;
    cbxRdSecInf: TComboBox;
    cbxRdSecDsp: TComboBox;
    cbxRdSecOut: TComboBox;
    cbxRdPrimInf: TComboBox;
    cbxRdPrimDsp: TComboBox;
    cbxRdPrimOut: TComboBox;
    cbxCICUInf: TComboBox;
    cbxCICUOut: TComboBox;
    cbxSFRInf: TComboBox;
    cbxSFROut: TComboBox;
    cbxVegOut: TComboBox;
    btnRdPrimOutEdit: TButton;
    Panel16: TPanel;
    lblSerHdr: TLabel;
    Label15: TLabel;
    Label26: TLabel;
    Label29: TLabel;
    Panel19: TPanel;
    sgSecRds: TStringGrid;
    Panel22: TPanel;
    btnRdSecDspEdit: TButton;
    btnRdSecInfEdit: TButton;
    btnRdSecOutEdit: TButton;
    Label7: TLabel;
    Label8: TLabel;
    Label10: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    lblCatchArea: TLabel;
    //xmlDoc: TXMLDocument;
    btnRdPrimInfNew: TButton;
    btnRdPrimDspNew: TButton;
    btnRdPrimOutNew: TButton;
    btnRdSecInfNew: TButton;
    btnRdSecDspNew: TButton;
    btnRdSecOutNew: TButton;
    btnNewSFRInf: TButton;
    btnNewSFROut: TButton;
    btnNewMFRInf: TButton;
    btnNewMFROut: TButton;
    btnNewCICUInf: TButton;
    btnNewCICUOut: TButton;
    btnNewVegTurfOut: TButton;
    btnRdPrimInfLoad: TButton;
    btnRdPrimDspLoad: TButton;
    btnRdPrimOutLoad: TButton;
    btnRdSecOutLoad: TButton;
    btnRdSecDspLoad: TButton;
    btnRdSecInfLoad: TButton;
    btnLDSFRInf: TButton;
    btnLDSFROut: TButton;
    btnLDMFROut: TButton;
    btnLDMFRInf: TButton;
    btnLDCICUOut: TButton;
    btnLDCICUInf: TButton;
    btnLDVegTOut: TButton;
    lblCatchImprv: TLabel;
    Label37: TLabel;
    lblOthHdr: TLabel;
    sgOthr: TStringGrid;
    cbxOthrOut: TComboBox;
    btnNewOthrOut: TButton;
    btnEditOthrOut: TButton;
    btnLDOthrOut: TButton;
    Panel17: TPanel;
    Panel18: TPanel;
    Button1: TButton;
    Button2: TButton;
    Panel20: TPanel;
    Button3: TButton;
    Button4: TButton;
    Panel21: TPanel;
    Button5: TButton;
    Button6: TButton;
    Panel23: TPanel;
    Button7: TButton;
    Button11: TButton;
    Panel24: TPanel;
    Panel25: TPanel;
    Button8: TButton;
    Button12: TButton;
    Button15: TButton;
    Panel26: TPanel;
    Button18: TButton;
    Button21: TButton;
    Button24: TButton;

    procedure initFormContents(catch: TPLRMCatch);
    procedure restoreFormContents(catch: TPLRMCatch);
    //procedure rePopulateForm(catch: TPLRMCatch);
    procedure sgGenDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgGenParcelDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgGenRdDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgRoadGenSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure sgParcelGenSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure sgGenRdSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure cbxGlobalSpecfcChange(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure btnRdSecInfEditClick(Sender: TObject);
    procedure btnRdSecDspEditClick(Sender: TObject);
    procedure btnRdSecOutEditClick(Sender: TObject);
    procedure btnEditSFRInfClick(Sender: TObject);
    procedure btnEditSFROutClick(Sender: TObject);
    procedure btnEditMFRInfClick(Sender: TObject);
    procedure btnEditMFROutClick(Sender: TObject);
    procedure btnEditCICUInfClick(Sender: TObject);
    procedure btnEditCICUOutClick(Sender: TObject);
    procedure btnEditVegTurfOutClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnRdPrimInfNewClick(Sender: TObject);
    procedure btnRdPrimInfLoadClick(Sender: TObject);
    procedure btnRdPrimDspLoadClick(Sender: TObject);
    procedure btnRdSecInfNewClick(Sender: TObject);
    procedure btnRdSecInfLoadClick(Sender: TObject);
    procedure btnRdSecDspNewClick(Sender: TObject);
    procedure btnRdSecDspLoadClick(Sender: TObject);
    procedure btnRdSecOutNewClick(Sender: TObject);
    procedure btnRdPrimDspNewClick(Sender: TObject);
    procedure btnRdPrimOutNewClick(Sender: TObject);
    procedure btnNewSFRInfClick(Sender: TObject);
    procedure btnNewSFROutClick(Sender: TObject);
    procedure btnNewMFRInfClick(Sender: TObject);
    procedure btnNewMFROutClick(Sender: TObject);
    procedure btnNewCICUInfClick(Sender: TObject);
    procedure btnNewCICUOutClick(Sender: TObject);
    procedure btnNewVegTurfOutClick(Sender: TObject);
    procedure btnLDSFRInfClick(Sender: TObject);
    procedure btnLDSFROutClick(Sender: TObject);
    procedure btnLDMFRInfClick(Sender: TObject);
    procedure btnLDMFROutClick(Sender: TObject);
    procedure btnLDCICUInfClick(Sender: TObject);
    procedure btnLDCICUOutClick(Sender: TObject);
    procedure btnLDVegTOutClick(Sender: TObject);
    procedure btnRdSecOutLoadClick(Sender: TObject);
    procedure sgGenSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
    procedure sgVegDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
   procedure checkAndSelectCbxItm(var cbx:TCombobox; scheme:TPLRMHydPropsScheme; schms:TStringList);
    procedure updateCalcs(sg:TStringGrid);
    procedure roadLoadScheme(var cbx:TCombobox; var schm:TPLRMHydPropsScheme;hydCategory:Integer);
    procedure roadNewScheme(var cbx:TCombobox; var schm:TPLRMHydPropsScheme; hydCategory:Integer);
    procedure parcelNewScheme(var cbx:TCombobox; var schm:TPLRMHydPropsScheme;hydCategory:Integer);
    procedure parcelLoadScheme(var cbx:TCombobox; var schm:TPLRMHydPropsScheme; hydCategory:Integer);
    procedure btnRdPrimOutLoadClick(Sender: TObject);
    procedure btnRdPrimInfEditClick(Sender: TObject);
    procedure btnRdPrimDspEditClick(Sender: TObject);
    procedure btnRdPrimOutEditClick(Sender: TObject);
    procedure cbxRdSecInfChange(Sender: TObject);
    procedure cbxRdSecDspChange(Sender: TObject);
    procedure cbxRdSecOutChange(Sender: TObject);
    procedure cbxRdPrimInfChange(Sender: TObject);
    procedure cbxRdPrimDspChange(Sender: TObject);
    procedure cbxRdPrimOutChange(Sender: TObject);
    procedure cbxSFRInfChange(Sender: TObject);
    procedure cbxSFROutChange(Sender: TObject);
    procedure cbxMFRInfChange(Sender: TObject);
    procedure cbxMFROutChange(Sender: TObject);
    procedure cbxCICUInfChange(Sender: TObject);
    procedure cbxCICUOutChange(Sender: TObject);
    procedure cbxVegOutChange(Sender: TObject);
    procedure cbxOthrOutChange(Sender: TObject);
    procedure btnNewOthrOutClick(Sender: TObject);
    procedure btnEditOthrOutClick(Sender: TObject);
    procedure btnLDOthrOutClick(Sender: TObject);
//    procedure pgCtrlParcelRdsChange(Sender: TObject);
 //procedure loadHydCondsScheme(var cbx:TCombobox; filePath:String = '');

    procedure loadHydPropsScheme(var cbx:TCombobox;sType:Integer;hydCategory:Integer); overload;
    procedure updateCbxItems();
    procedure sgPrimRdsKeyPress(Sender: TObject; var Key: Char);
    procedure sgSFRKeyPress(Sender: TObject; var Key: Char);
    procedure sgMFRKeyPress(Sender: TObject; var Key: Char);
    procedure sgCICUKeyPress(Sender: TObject; var Key: Char);
    procedure sgVegKeyPress(Sender: TObject; var Key: Char);
    procedure sgOthrKeyPress(Sender: TObject; var Key: Char);
    procedure sgSecRdsKeyPress(Sender: TObject; var Key: Char);

    procedure getHydSchemes(var Schm:TPLRMHydPropsScheme; sType:Integer; ext:String; parcelOrRoad:String; luse:String);

  private
    { Private declarations }
  public
    { Public declarations }
    procedure loadHydPropsScheme2(var cbx:TCombobox; dir:String; ext:String; filePath:String = '');overload;
    procedure loadHydPropsScheme2(var Schm:TPLRMHydPropsScheme; dir:String; ext:String; filePath:String);overload;
end;
function getDrngCondsInput(catchID: String): TPLRMDrngXtcsData;

var
  Frm: TPLRMDrainageConditions;
  initCatchID: String;
  curCatchArea:Double;
  curAcVals :array[0..6] of Double;
  curImpPrctVals :array[0..6] of Double;
  sgs: array[0..6] of TStringGrid;
  prevGridValue : String;
implementation

uses GSIO;

{$R *.dfm}

  procedure TPLRMDrainageConditions.btnOKClick(Sender: TObject);
  begin
    btnApplyClick(Sender);
    if not(assigned(PLRMObj.currentCatchment.catchHydPropSchemes)) then
       PLRMObj.currentCatchment.copyHydSchemesToArray;
    ModalResult := mrOk;
  end;

  procedure TPLRMDrainageConditions.btnApplyClick(Sender: TObject);
//  var
//    I :Integer;
//    cbxArr : array[0..4] of TCombobox;
  begin
  GSPLRM.PLRMObj.currentCatchment.secRdDrng := GSUtils.copyGridContents(0,0, sgSecRds);
  GSPLRM.PLRMObj.currentCatchment.primRdDrng := GSUtils.copyGridContents(0,0, sgPrimRds);
  GSPLRM.PLRMObj.currentCatchment.sfrDrng := GSUtils.copyGridContents(0,0, sgSFR);
  GSPLRM.PLRMObj.currentCatchment.mfrDrng := GSUtils.copyGridContents(0,0, sgMFR);
  GSPLRM.PLRMObj.currentCatchment.cicuDrng := GSUtils.copyGridContents(0,0, sgCICU);
  GSPLRM.PLRMObj.currentCatchment.vegTDrng := GSUtils.copyGridContents(0,0, sgVeg);
  GSPLRM.PLRMObj.currentCatchment.othrDrng := GSUtils.copyGridContents(0,0, sgOthr);
  GSPLRM.PLRMObj.currentCatchment.hasDefDrnXtcs :=true
  end;

  procedure TPLRMDrainageConditions.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

{$REGION 'Parcels' }
  procedure TPLRMDrainageConditions.parcelNewScheme(var cbx:TCombobox; var schm:TPLRMHydPropsScheme; hydCategory:Integer);
  var
    tempInt:Integer;
  begin
    schm := getSDrngXtsScheme(true,cbx,PLRMObj.hydPropsSchemes,1,PLRMObj.currentCatchment.swmmCatch.ID,hydCategory,false);
    PLRMObj.curHydPropsScheme := schm;
    tempInt := PLRMObj.hydPropsSchemes.IndexOf(schm.id);
    if tempInt = -1 then
    begin
      PLRMObj.hydPropsSchemes.AddObject(schm.id,schm);
      case hydCategory of
        0:
        begin
          PLRMObj.hydPropsPcOutSchemes.AddObject(schm.name,schm);
            updateGeneralCbxItems(cbxSFROut,cbx);
            updateGeneralCbxItems(cbxMFROut,cbx);
            updateGeneralCbxItems(cbxCicuOut,cbx);
            updateGeneralCbxItems(cbxVegOut,cbx);
            updateGeneralCbxItems(cbxOthrOut,cbx);
        end;
        1:
        begin
          PLRMObj.hydPropsPcInfSchemes.AddObject(schm.name,schm);
            updateGeneralCbxItems(cbxSFRInf,cbx);
            updateGeneralCbxItems(cbxMFRInf,cbx);
            updateGeneralCbxItems(cbxCicuInf,cbx);
        end
        else ShowMessage('An error was encountered with the Parcel Schemes!');
      end;

    end;
  end;
  procedure TPLRMDrainageConditions.parcelLoadScheme(var cbx:TCombobox; var schm:TPLRMHydPropsScheme; hydCategory:Integer);
  begin
    loadHydPropsScheme(cbx,1,hydCategory);
    schm := PLRMObj.curHydPropsScheme;
    //updateParcelCbxItems(cbx);
    case hydCategory of
        0:
        begin
          PLRMObj.hydPropsPcOutSchemes.AddObject(schm.name,schm);
            updateGeneralCbxItems(cbxSFROut,cbx);
            updateGeneralCbxItems(cbxMFROut,cbx);
            updateGeneralCbxItems(cbxCicuOut,cbx);
            updateGeneralCbxItems(cbxVegOut,cbx);
            updateGeneralCbxItems(cbxOthrOut,cbx);
        end;
        1:
        begin
          PLRMObj.hydPropsPcInfSchemes.AddObject(schm.name,schm);
            updateGeneralCbxItems(cbxSFRInf,cbx);
            updateGeneralCbxItems(cbxMFRInf,cbx);
            updateGeneralCbxItems(cbxCicuInf,cbx);
        end
        else ShowMessage('An error was encountered with the Parcel Schemes!');
      end;
  end;

{$REGION 'MFR' }
//MFR Schemes New
  procedure TPLRMDrainageConditions.btnNewMFRInfClick(Sender: TObject);
begin
  parcelNewScheme(cbxMFRInf,PLRMObj.currentCatchment.mfrSchms[1],1);
end;

  procedure TPLRMDrainageConditions.btnNewMFROutClick(Sender: TObject);
begin
  parcelNewScheme(cbxMFROut,PLRMObj.currentCatchment.mfrSchms[0],0);
end;

//MFR Schemes Edit
  procedure TPLRMDrainageConditions.btnEditMFRInfClick(Sender: TObject);
  begin
    PLRMObj.currentCatchment.mfrSchms[1]:= getSDrngXtsScheme(PLRMObj.currentCatchment.mfrSchms[1],false,1);
  end;

  procedure TPLRMDrainageConditions.btnEditMFROutClick(Sender: TObject);
  begin
    PLRMObj.currentCatchment.mfrSchms[0]:= getSDrngXtsScheme(PLRMObj.currentCatchment.mfrSchms[0],false,0);
  end;

//MFR Schemes Load
  procedure TPLRMDrainageConditions.btnLDMFRInfClick(Sender: TObject);
begin
  parcelLoadScheme(cbxMFRInf,PLRMObj.currentCatchment.mfrSchms[1],1);
end;
  procedure TPLRMDrainageConditions.btnLDMFROutClick(Sender: TObject);
  begin
  parcelLoadScheme(cbxMFROut,PLRMObj.currentCatchment.mfrSchms[0],0);
  end;
procedure TPLRMDrainageConditions.btnLDOthrOutClick(Sender: TObject);
begin
parcelLoadScheme(cbxVegOut,PLRMObj.currentCatchment.othrSchms[0],0);
end;
{$ENDREGION}

{$REGION 'SFR' }
//SFR schemes New
  procedure TPLRMDrainageConditions.btnNewSFRInfClick(Sender: TObject);
begin
  parcelNewScheme(cbxSFRInf,PLRMObj.currentCatchment.sfrSchms[1],1);
end;
procedure TPLRMDrainageConditions.btnNewSFROutClick(Sender: TObject);
begin
    parcelNewScheme(cbxSFROut,PLRMObj.currentCatchment.sfrSchms[0],0);
end;

//SFR schemes Edit
procedure TPLRMDrainageConditions.btnEditSFRInfClick(Sender: TObject);
begin
  PLRMObj.currentCatchment.sfrSchms[1]:= getSDrngXtsScheme(PLRMObj.currentCatchment.sfrSchms[1],false,1);
end;

procedure TPLRMDrainageConditions.btnEditSFROutClick(Sender: TObject);
begin
  PLRMObj.currentCatchment.sfrSchms[0]:= getSDrngXtsScheme(PLRMObj.currentCatchment.sfrSchms[0],false,0);
end;
//SFR Load scheme
  procedure TPLRMDrainageConditions.btnLDSFRInfClick(Sender: TObject);
begin
  parcelLoadScheme(cbxSFRInf,PLRMObj.currentCatchment.sfrSchms[1],1);
end;
  procedure TPLRMDrainageConditions.btnLDSFROutClick(Sender: TObject);
begin
  parcelLoadScheme(cbxSFROut,PLRMObj.currentCatchment.sfrSchms[0],0);
end;

{$ENDREGION}

{$REGION 'CICU' }
 //CICU Schemes New
  procedure TPLRMDrainageConditions.btnNewCICUInfClick(Sender: TObject);
begin
    parcelNewScheme(cbxCICUInf,PLRMObj.currentCatchment.cicuSchms[1],1);
end;
  procedure TPLRMDrainageConditions.btnNewCICUOutClick(Sender: TObject);
begin
  parcelNewScheme(cbxCICUOut,PLRMObj.currentCatchment.cicuSchms[0],0);
end;

//CICU Schemes Edit
  procedure TPLRMDrainageConditions.btnEditCICUInfClick(Sender: TObject);
  begin
    PLRMObj.currentCatchment.cicuSchms[1]:= getSDrngXtsScheme(PLRMObj.currentCatchment.cicuSchms[1],false,1);
  end;
  procedure TPLRMDrainageConditions.btnEditCICUOutClick(Sender: TObject);
  begin
    PLRMObj.currentCatchment.cicuSchms[0]:= getSDrngXtsScheme(PLRMObj.currentCatchment.cicuSchms[0],false,0);
  end;
  //CICU Load
  procedure TPLRMDrainageConditions.btnLDCICUInfClick(Sender: TObject);
  begin
    parcelLoadScheme(cbxCICUInf,PLRMObj.currentCatchment.cicuSchms[1],1);
  end;
  procedure TPLRMDrainageConditions.btnLDCICUOutClick(Sender: TObject);
  begin
  parcelLoadScheme(cbxCICUOut,PLRMObj.currentCatchment.cicuSchms[0],1);
  end;

{$ENDREGION}

 {$REGION 'Veg T' }
//Veg T Scheme New
  procedure TPLRMDrainageConditions.btnNewVegTurfOutClick(Sender: TObject);
begin
  parcelNewScheme(cbxVegOut,PLRMObj.currentCatchment.vegTSchms[0],0);
end;
//Veg Turf Edit
procedure TPLRMDrainageConditions.btnEditVegTurfOutClick(Sender: TObject);
begin
  PLRMObj.currentCatchment.vegTSchms[0]:= getSDrngXtsScheme(PLRMObj.currentCatchment.vegTSchms[0],false,0);
end;
  //Veg Turf Load
  procedure TPLRMDrainageConditions.btnLDVegTOutClick(Sender: TObject);
  begin
    parcelLoadScheme(cbxVegOut,PLRMObj.currentCatchment.vegTSchms[0],0);
  end;
{$ENDREGION}

{$REGION 'Othr' }
  //Othr scheme edit
procedure TPLRMDrainageConditions.btnEditOthrOutClick(Sender: TObject);
  begin
    PLRMObj.currentCatchment.othrSchms[0]:= getSDrngXtsScheme(PLRMObj.currentCatchment.othrSchms[0],false,0);
  end;
{$ENDREGION}
{$ENDREGION}

{$REGION 'Roads' }

{$REGION 'Secondary Roads' }
//Secondary roads New
  procedure TPLRMDrainageConditions.btnRdSecInfNewClick(Sender: TObject);
  begin
    roadNewScheme(cbxRdSecInf,PLRMObj.currentCatchment.secRdSchms[1],1);
  end;
  procedure TPLRMDrainageConditions.btnRdSecDspNewClick(Sender: TObject);
  begin
    roadNewScheme(cbxRdSecDsp,PLRMObj.currentCatchment.secRdSchms[2],2);
  end;
  procedure TPLRMDrainageConditions.btnRdSecOutNewClick(Sender: TObject);
  begin
    roadNewScheme(cbxRdSecOut,PLRMObj.currentCatchment.secRdSchms[0],0 );
  end;

procedure TPLRMDrainageConditions.btnNewOthrOutClick(Sender: TObject);
begin
 parcelNewScheme(cbxOthrOut,PLRMObj.currentCatchment.othrSchms[0],0);
end;

//Secondary roads Edit
  procedure TPLRMDrainageConditions.btnRdSecInfEditClick(Sender: TObject);
  begin
    PLRMObj.currentCatchment.secRdSchms[1]:= getSDrngXtsScheme(PLRMObj.currentCatchment.secRdSchms[1],true,1);
  end;

  procedure TPLRMDrainageConditions.btnRdSecDspEditClick(Sender: TObject);
  begin
    PLRMObj.currentCatchment.secRdSchms[2]:= getSDrngXtsScheme(PLRMObj.currentCatchment.secRdSchms[2],true,2);
  end;

  procedure TPLRMDrainageConditions.btnRdSecOutEditClick(Sender: TObject);
  begin
    PLRMObj.currentCatchment.secRdSchms[0]:= getSDrngXtsScheme(PLRMObj.currentCatchment.secRdSchms[0],true,0);
  end;

//Sec Roads Load
  procedure TPLRMDrainageConditions.btnRdSecInfLoadClick(Sender: TObject);
  begin
    roadLoadScheme(cbxRdSecInf,PLRMObj.currentCatchment.secRdSchms[1],1);
  end;
  procedure TPLRMDrainageConditions.btnRdSecDspLoadClick(Sender: TObject);
  begin
    roadLoadScheme(cbxRdSecDsp,PLRMObj.currentCatchment.secRdSchms[2],2);
  end;
  procedure TPLRMDrainageConditions.btnRdSecOutLoadClick(Sender: TObject);
  begin
    roadLoadScheme(cbxRdSecOut,PLRMObj.currentCatchment.secRdSchms[0],0);
  end;
{$ENDREGION}

{$REGION 'Primary Roads' }
//Primary roads New
  procedure TPLRMDrainageConditions.btnRdPrimInfNewClick(Sender: TObject);
  begin
    roadNewScheme(cbxRdPrimInf,PLRMObj.currentCatchment.primRdSchms[1],1);
  end;
  procedure TPLRMDrainageConditions.btnRdPrimDspNewClick(Sender: TObject);
  begin
    roadNewScheme(cbxRdPrimDsp,PLRMObj.currentCatchment.primRdSchms[2],2);
  end;
  procedure TPLRMDrainageConditions.btnRdPrimOutNewClick(Sender: TObject);
  begin
    roadNewScheme(cbxRdPrimOut,PLRMObj.currentCatchment.primRdSchms[0],0);
  end;

// Primary roads edit
  procedure TPLRMDrainageConditions.btnRdPrimInfEditClick(Sender: TObject);
  begin
    PLRMObj.currentCatchment.primRdSchms[1]:= getSDrngXtsScheme(PLRMObj.currentCatchment.primRdSchms[1],true,1);
  end;

  procedure TPLRMDrainageConditions.btnRdPrimDspEditClick(Sender: TObject);
  begin
    PLRMObj.currentCatchment.primRdSchms[2]:= getSDrngXtsScheme(PLRMObj.currentCatchment.primRdSchms[2],true,2);
  end;
  procedure TPLRMDrainageConditions.btnRdPrimOutEditClick(Sender: TObject);
  begin
    PLRMObj.currentCatchment.primRdSchms[0]:= getSDrngXtsScheme(PLRMObj.currentCatchment.primRdSchms[0],true,0);
  end;

// Primary roads Load
  procedure TPLRMDrainageConditions.btnRdPrimInfLoadClick(Sender: TObject);
  begin
    roadLoadScheme(cbxRdPrimInf,PLRMObj.currentCatchment.primRdSchms[1],1);
  end;
  procedure TPLRMDrainageConditions.btnRdPrimDspLoadClick(Sender: TObject);
  begin
    roadLoadScheme(cbxRdPrimDsp,PLRMObj.currentCatchment.primRdSchms[2],2);
  end;
  procedure TPLRMDrainageConditions.btnRdPrimOutLoadClick(Sender: TObject);
  begin
      roadLoadScheme(cbxRdPrimOut,PLRMObj.currentCatchment.primRdSchms[0],0);
  end;
{$ENDREGION}

  procedure TPLRMDrainageConditions.roadNewScheme(var cbx:TCombobox; var schm:TPLRMHydPropsScheme; hydCategory:Integer);
  var
    tempInt:Integer;
  begin
    schm := getSDrngXtsScheme(true,cbx,PLRMObj.hydPropsSchemes,1,PLRMObj.currentCatchment.swmmCatch.ID,hydCategory,true);
    PLRMObj.curHydPropsScheme := schm;
    tempInt := PLRMObj.hydPropsSchemes.IndexOf(schm.id);
//    if tempInt = -1 then PLRMObj.hydPropsSchemes.AddObject(schm.id,schm);
    if tempInt = -1 then
    begin
      PLRMObj.hydPropsSchemes.AddObject(schm.id,schm);
      case hydCategory of
        0:
        begin
          PLRMObj.hydPropsRdOutSchemes.AddObject(schm.id,schm);
          updateGeneralCbxItems(cbxRdPrimOut,cbx);
          updateGeneralCbxItems(cbxRdSecOut,cbx);
        end;
        1:
        begin
          PLRMObj.hydPropsRdInfSchemes.AddObject(schm.id,schm);
          updateGeneralCbxItems(cbxRdPrimInf,cbx);
          updateGeneralCbxItems(cbxRdSecInf,cbx);
        end;
        2:
        begin
          PLRMObj.hydPropsRdDspSchemes.AddObject(schm.id,schm);
          updateGeneralCbxItems(cbxRdPrimDsp,cbx);
          updateGeneralCbxItems(cbxRdSecDsp,cbx);
        end
        else ShowMessage('An error was encountered with the Road Schemes!');
      end;
    end;
  end;

  procedure TPLRMDrainageConditions.roadLoadScheme(var cbx:TCombobox; var schm:TPLRMHydPropsScheme;hydCategory:Integer);
  begin
    loadHydPropsScheme(cbx,0,hydCategory);
    schm := PLRMObj.curHydPropsScheme;
    case hydCategory of
        0:
        begin
          PLRMObj.hydPropsRdOutSchemes.AddObject(schm.name,schm);
            updateGeneralCbxItems(cbxRdPrimOut,cbx);
            updateGeneralCbxItems(cbxRdSecOut,cbx);
        end;
        1:
        begin
          PLRMObj.hydPropsRdInfSchemes.AddObject(schm.name,schm);
            updateGeneralCbxItems(cbxRdPrimInf,cbx);
            updateGeneralCbxItems(cbxRdSecInf,cbx);
        end;
        2:
        begin
          PLRMObj.hydPropsRdDspSchemes.AddObject(schm.name,schm);
            updateGeneralCbxItems(cbxRdPrimDsp,cbx);
            updateGeneralCbxItems(cbxRdSecDsp,cbx);
        end
        else ShowMessage('An error was encountered with the Parcel Schemes!');
      end;
  end;


{$ENDREGION}


procedure TPLRMDrainageConditions.updateCbxItems();
//var
//  I:Integer;
begin
    copyHydSchmToCbx(cbxRdPrimInf,PLRMObj.hydPropsRdInfSchemes);
    copyHydSchmToCbx(cbxRdPrimDsp,PLRMObj.hydPropsRdDspSchemes);
    copyHydSchmToCbx(cbxRdPrimOut,PLRMObj.hydPropsRdOutSchemes);

    cbxRdSecInf.Items := cbxRdPrimInf.Items;
    cbxRdSecDsp.Items := cbxRdPrimDsp.Items;
    cbxRdSecOut.Items := cbxRdPrimOut.Items;

    copyHydSchmToCbx(cbxSfrInf,PLRMObj.hydPropsPcInfSchemes);
    copyHydSchmToCbx(cbxSfrOut,PLRMObj.hydPropsPcOutSchemes);

    cbxMfrInf.Items := cbxSfrInf.items;
    cbxMfrOut.Items := cbxSfrOut.items;
    cbxCicuInf.Items := cbxSfrInf.items;
    cbxCicuOut.Items := cbxSfrOut.items;
    cbxvegOut.Items := cbxSfrOut.items;
    cbxOthrOut.Items := cbxSfrOut.items;
end;

procedure TPLRMDrainageConditions.cbxCICUInfChange(Sender: TObject);
begin
    PLRMObj.curHydPropsScheme := GSUtils.getComboBoxSelValue2(Sender) as TPLRMHydPropsScheme;
    PLRMObj.currentCatchment.cicuSchms[1]:= PLRMObj.curHydPropsScheme;
end;

procedure TPLRMDrainageConditions.cbxCICUOutChange(Sender: TObject);
begin
    PLRMObj.curHydPropsScheme := GSUtils.getComboBoxSelValue2(Sender) as TPLRMHydPropsScheme;
    PLRMObj.currentCatchment.cicuSchms[0]:= PLRMObj.curHydPropsScheme;
end;

procedure TPLRMDrainageConditions.cbxGlobalSpecfcChange(Sender: TObject);
begin
   //set current catchment to the obj coresponding to selected value
    PLRMObj.currentCatchment := GSUtils.getComboBoxSelValue2(Sender) as TPLRMCatch;
    lblCatchArea.Caption := 'Selected Catchment Area is: ' + PLRMobj.currentCatchment.swmmCatch.Data[UProject.SUBCATCH_AREA_INDEX] + 'ac';

    if PLRMObj.currentCatchment.hasDefSoils = false then
    begin
      ShowMessage('Please select another catchment or go back and provide soils data for current catchment');
      Exit;
    end;
//    if PLRMObj.currentCatchment.hasDefDrnXtcs = true then
//      rePopulateForm(PLRMobj.currentCatchment)
    //else
      initFormContents(PLRMobj.currentCatchment);
end;

procedure TPLRMDrainageConditions.cbxMFRInfChange(Sender: TObject);
begin
    PLRMObj.curHydPropsScheme := GSUtils.getComboBoxSelValue2(Sender) as TPLRMHydPropsScheme;
    PLRMObj.currentCatchment.mfrSchms[1]:= PLRMObj.curHydPropsScheme;
end;

procedure TPLRMDrainageConditions.cbxMFROutChange(Sender: TObject);
begin
    PLRMObj.curHydPropsScheme := GSUtils.getComboBoxSelValue2(Sender) as TPLRMHydPropsScheme;
    PLRMObj.currentCatchment.mfrSchms[0]:= PLRMObj.curHydPropsScheme;
end;

procedure TPLRMDrainageConditions.cbxRdPrimDspChange(Sender: TObject);
begin
    PLRMObj.curHydPropsScheme := GSUtils.getComboBoxSelValue2(Sender) as TPLRMHydPropsScheme;
    PLRMObj.currentCatchment.primRdSchms[2]:= PLRMObj.curHydPropsScheme;
end;

procedure TPLRMDrainageConditions.cbxRdPrimInfChange(Sender: TObject);
begin
    PLRMObj.curHydPropsScheme := GSUtils.getComboBoxSelValue2(Sender) as TPLRMHydPropsScheme;
    PLRMObj.currentCatchment.primRdSchms[1]:= PLRMObj.curHydPropsScheme;
end;

procedure TPLRMDrainageConditions.cbxRdPrimOutChange(Sender: TObject);
begin
    PLRMObj.curHydPropsScheme := GSUtils.getComboBoxSelValue2(Sender) as TPLRMHydPropsScheme;
    PLRMObj.currentCatchment.primRdSchms[0]:= PLRMObj.curHydPropsScheme;
end;

procedure TPLRMDrainageConditions.cbxRdSecDspChange(Sender: TObject);
begin
    PLRMObj.curHydPropsScheme := GSUtils.getComboBoxSelValue2(Sender) as TPLRMHydPropsScheme;
    PLRMObj.currentCatchment.secRdSchms[2]:= PLRMObj.curHydPropsScheme;
end;

procedure TPLRMDrainageConditions.cbxRdSecInfChange(Sender: TObject);
  begin
    PLRMObj.curHydPropsScheme := GSUtils.getComboBoxSelValue2(Sender) as TPLRMHydPropsScheme;
    PLRMObj.currentCatchment.secRdSchms[1]:= PLRMObj.curHydPropsScheme;
  end;

procedure TPLRMDrainageConditions.cbxRdSecOutChange(Sender: TObject);
begin
PLRMObj.curHydPropsScheme := GSUtils.getComboBoxSelValue2(Sender) as TPLRMHydPropsScheme;
    PLRMObj.currentCatchment.secRdSchms[0]:= PLRMObj.curHydPropsScheme;
end;

procedure TPLRMDrainageConditions.cbxSFRInfChange(Sender: TObject);
begin
    PLRMObj.curHydPropsScheme := GSUtils.getComboBoxSelValue2(Sender) as TPLRMHydPropsScheme;
    PLRMObj.currentCatchment.sfrSchms[1]:= PLRMObj.curHydPropsScheme;
end;

procedure TPLRMDrainageConditions.cbxSFROutChange(Sender: TObject);
begin
    PLRMObj.curHydPropsScheme := GSUtils.getComboBoxSelValue2(Sender) as TPLRMHydPropsScheme;
    PLRMObj.currentCatchment.sfrSchms[0]:= PLRMObj.curHydPropsScheme;
end;

procedure TPLRMDrainageConditions.cbxVegOutChange(Sender: TObject);
begin
    PLRMObj.curHydPropsScheme := GSUtils.getComboBoxSelValue2(Sender) as TPLRMHydPropsScheme;
    PLRMObj.currentCatchment.vegtSchms[0]:= PLRMObj.curHydPropsScheme;
end;

procedure TPLRMDrainageConditions.cbxOthrOutChange(Sender: TObject);
begin
    PLRMObj.curHydPropsScheme := GSUtils.getComboBoxSelValue2(Sender) as TPLRMHydPropsScheme;
    PLRMObj.currentCatchment.othrSchms[0]:= PLRMObj.curHydPropsScheme;
end;

procedure TPLRMDrainageConditions.initFormContents(catch: TPLRMCatch);
  var
    hasLuse :array[0..6] of Boolean;
    I,J : Integer;
    prcnt : Double;
  begin
  with PLRMObj.currentCatchment do
  begin
    for I := 0 to High(sgs) do
    begin
      //maybe overwritten below in if statement by design
      //included for the sake of readability and to avoid else statement:
      for J := 0 to 1 do
      begin
        //% of area column row 0
        sgs[I].Cells[0,J] := '0';
        //initial values of area(ac) column row 0
        sgs[I].Cells[1,J] := '0';
        //imperv imperv area(ac) column row 0
        sgs[I].Cells[2,J] := '0';
        //default dcia
        sgs[I].Cells[3,J] := '100';
        //default ksat vals
        sgs[I].Cells[4,J] := soilsInfData[0,1];
        //default slopes
        sgs[I].Cells[5,J] := FloatToStr(PLRMObj.currentCatchment.slope); //swmmCatch.Data[UProject.SUBCATCH_SLOPE_INDEX];
      end;
    end;

//Road areas drain to pervious dispersion defaults
  sgSecRds.Cells[0,2] := '100';
  sgSecRds.Cells[1,2] := '0';
  sgSecRds.Cells[2,2] := '0';
  sgSecRds.Cells[3,2] := '100';
  sgSecRds.Cells[4,2] := soilsInfData[0,1];
  sgSecRds.Cells[5,2] := FloatToStr(PLRMObj.currentCatchment.slope); //swmmCatch.Data[UProject.SUBCATCH_SLOPE_INDEX];

  sgPrimRds.Cells[0,2] := '100';
  sgPrimRds.Cells[1,2] := '0';
  sgPrimRds.Cells[2,2] := '0';
  sgPrimRds.Cells[3,2] := '100';
  sgPrimRds.Cells[4,2] := soilsInfData[0,1];
  sgPrimRds.Cells[5,2] := FloatToStr(PLRMObj.currentCatchment.slope); // swmmCatch.Data[UProject.SUBCATCH_SLOPE_INDEX];

  //area(ac) column
  for I := 0 to High(curAcVals) do
  begin
     curAcVals[I] := PLRMobj.getCurCatchLuseProp(GSUtils.frmsLuses[I],3,hasLuse[I]);
     curImpPrctVals[I] := PLRMobj.getCurCatchLuseProp(GSUtils.frmsLuses[I],2,hasLuse[I]);
  end;

  //primary road areas
  if hasLuse[0] = true then
  begin
    sgPrimRds.Cells[1,2] := FloatToStr(curAcVals[0]);
    sgPrimRds.Cells[2,2] := FloatToStr(curImpPrctVals[0]*curAcVals[0]/100);
  end;
  //secondary road areas
  if hasLuse[1] = true then
  begin
    sgSecRds.Cells[1,2] := FloatToStr(curAcVals[1]);
    sgSecRds.Cells[2,2] := FloatToStr(curImpPrctVals[1]*curAcVals[1]/100);
  end;


  for J := 2 to High(sgs)-1 do
  begin
    if hasLuse[J] = true then
    begin
        prcnt :=  StrToFloat(bmpImpl[J-2,2]);
        sgs[J].Cells[0,0] := bmpImpl[J-2,2];
        sgs[J].Cells[0,1] := FloatToStr(100 - prcnt);
        sgs[J].Cells[1,0] := FloatToStr(prcnt*curAcVals[J]/100);
        sgs[J].Cells[1,1] := FloatToStr((100 - prcnt)*curAcVals[J]/100);
        sgs[J].Cells[2,0] := FloatToStr(prcnt*curImpPrctVals[J]*curAcVals[J]/100/100);
        sgs[J].Cells[2,1] := FloatToStr((100-prcnt)*curImpPrctVals[J]*curAcVals[J]/100/100);
    end;
  end;
    //VgT grid has only one row so different
    J := High(sgs) -1;
    prcnt :=  StrToFloat(bmpImpl[J-2,2]);
    sgVeg.Cells[0,0] := '100';
    sgVeg.Cells[1,0] := FloatToStr((100 - prcnt)*curAcVals[J]/100);
    sgVeg.Cells[2,0] := FloatToStr((100-prcnt)*curImpPrctVals[J]*curAcVals[J]/100/100);

    //Othr grid also has only one row so different
    J := High(sgs);
    prcnt :=  100;
    sgOthr.Cells[0,0] := '100';
    sgOthr.Cells[1,0] := FloatToStr(PLRMObj.currentCatchment.othrArea);
    sgOthr.Cells[2,0] := FloatToStr(PLRMObj.currentCatchment.othrPrcntImpv);
   // lblCatchArea.Caption := 'Selected Catchment Area is: ' + FloatToStr(area) + 'ac';

   lblPrrHdr.Caption := 'Primary Roads ( ' + FormatFloat('0.##',strToFloat(sgPrimRds.Cells[1,2])) + ' acres)';
   lblSerHdr.Caption := 'Secondary Roads ( ' + FormatFloat('0.##',strToFloat( sgSecRds.Cells[1,2])) + ' acres)';
   lblSfrHdr.Caption := 'Single Family Residential ( ' + FormatFloat('0.##',strToFloat( sgSFR.Cells[1,1])) + ' acres)';
   lblMfrHdr.Caption := 'Multi-Family Residential ( ' + FormatFloat('0.##',strToFloat( sgMFR.Cells[1,1])) + ' acres)';
   lblCicHdr.Caption := 'CICU ( ' + FormatFloat('0.##',strToFloat(sgCICU.Cells[1,1])) + ' acres)';
   lblVegHdr.Caption := 'Vegetated Turf ( ' + FormatFloat('0.##',strToFloat(sgVeg.Cells[1,0])) + ' acres)';
   lblOthHdr.Caption := 'All Others ( ' + FormatFloat('0.##',strToFloat(sgOthr.Cells[1,0])) + ' acres)';
  end;
end;

procedure TPLRMDrainageConditions.restoreFormContents(catch: TPLRMCatch);
  var
    hasLuse :array[0..6] of Boolean;
    I,J : Integer;
    prcnt : Double;
  begin
  with PLRMObj.currentCatchment do
  begin

  //area(ac) column
  for I := 0 to High(curAcVals) do
  begin
     curAcVals[I] := PLRMobj.getCurCatchLuseProp(GSUtils.frmsLuses[I],3,hasLuse[I]);
     curImpPrctVals[I] := PLRMobj.getCurCatchLuseProp(GSUtils.frmsLuses[I],2,hasLuse[I]);
  end;

  //primary road areas
  if hasLuse[0] = true then
  begin
    sgPrimRds.Cells[1,2] := FloatToStr(curAcVals[0]);
    sgPrimRds.Cells[2,2] := FloatToStr(curImpPrctVals[0]*curAcVals[0]/100);
  end;
  //secondary road areas
  if hasLuse[1] = true then
  begin
    sgSecRds.Cells[1,2] := FloatToStr(curAcVals[1]);
    sgSecRds.Cells[2,2] := FloatToStr(curImpPrctVals[1]*curAcVals[1]/100);
  end;

  //Write back dcia, ksat and aveslope if previously assigned
  if assigned(PLRMObj.currentCatchment.primRdDrng) then
       copyContentsToGridNChk(PLRMObj.currentCatchment.primRdDrng,0,0,sgPrimRds);
  if assigned(PLRMObj.currentCatchment.secRdDrng) then
       copyContentsToGridNChk(PLRMObj.currentCatchment.secRdDrng,0,0,sgSecRds);
  if assigned(PLRMObj.currentCatchment.sfrDrng) then
       copyContentsToGridNChk(PLRMObj.currentCatchment.sfrDrng,0,0,sgSFR);
   if assigned(PLRMObj.currentCatchment.mfrDrng) then
       copyContentsToGridNChk(PLRMObj.currentCatchment.mfrDrng,0,0,sgMFR);
   if assigned(PLRMObj.currentCatchment.mfrDrng) then
       copyContentsToGridNChk(PLRMObj.currentCatchment.cicuDrng,0,0,sgCICU);
   if assigned(PLRMObj.currentCatchment.mfrDrng) then
       copyContentsToGridNChk(PLRMObj.currentCatchment.vegTDrng,0,0,sgVeg);
   if assigned(PLRMObj.currentCatchment.mfrDrng) then
       copyContentsToGridNChk(PLRMObj.currentCatchment.othrDrng,0,0,sgOthr);

  for J := 2 to High(sgs)-1 do
  begin
    if hasLuse[J] = true then
    begin
        prcnt :=  StrToFloat(bmpImpl[J-2,2]);
        sgs[J].Cells[0,0] := bmpImpl[J-2,2];
        sgs[J].Cells[0,1] := FloatToStr(100 - prcnt);
        sgs[J].Cells[1,0] := FloatToStr(prcnt*curAcVals[J]/100);
        sgs[J].Cells[1,1] := FloatToStr((100 - prcnt)*curAcVals[J]/100);
        sgs[J].Cells[2,0] := FloatToStr(prcnt*curImpPrctVals[J]*curAcVals[J]/100/100);
        sgs[J].Cells[2,1] := FloatToStr((100-prcnt)*curImpPrctVals[J]*curAcVals[J]/100/100);
    end;
  end;
    //VgT grid has only one row so different
    J := High(sgs) -1;
    prcnt :=  StrToFloat(bmpImpl[J-2,2]);
    sgVeg.Cells[0,0] := '100';
    sgVeg.Cells[1,0] := FloatToStr((100 - prcnt)*curAcVals[J]/100);
    sgVeg.Cells[2,0] := FloatToStr((100-prcnt)*curImpPrctVals[J]*curAcVals[J]/100/100);

    //Othr grid also has only one row so different
    J := High(sgs);
    prcnt :=  100;
    sgOthr.Cells[0,0] := '100';
    sgOthr.Cells[1,0] := FloatToStr(PLRMObj.currentCatchment.othrArea);
    sgOthr.Cells[2,0] := FloatToStr(PLRMObj.currentCatchment.othrPrcntImpv);


   lblPrrHdr.Caption := 'Primary Roads ( ' + FormatFloat('0.##',curAcVals[0]) + ' acres)';
   lblSerHdr.Caption := 'Secondary Roads ( ' + FormatFloat('0.##',curAcVals[1]) + ' acres)';
   lblSfrHdr.Caption := 'Single Family Residential ( ' + FormatFloat('0.##',curAcVals[2]) + ' acres)';
   lblMfrHdr.Caption := 'Multi-Family Residential ( ' + FormatFloat('0.##',curAcVals[3]) + ' acres)';
   lblCicHdr.Caption := 'CICU ( ' + FormatFloat('0.##',curAcVals[4]) + ' acres)';
   lblVegHdr.Caption := 'Vegetated Turf ( ' + FormatFloat('0.##',curAcVals[5]) + ' acres)';
   lblOthHdr.Caption := 'All Others ( ' + FormatFloat('0.##',strToFloat(sgOthr.Cells[1,0])) + ' acres)';
  end;
end;

procedure TPLRMDrainageConditions.FormCreate(Sender: TObject);
var
  tempInt,I : Integer;
//  tempLst :TStringList;
//  cbxArr : array[0..4] of TCombobox;
//  Schm :TPLRMHydPropsScheme;
begin
    statBar.SimpleText := PLRMVERSION;
    Self.Caption := PLRM5_TITLE;
    lblCatchArea.Caption := 'Catchment ID: ' + PLRMObj.currentCatchment.swmmCatch.ID + '   [ Area: ' + PLRMobj.currentCatchment.swmmCatch.Data[UProject.SUBCATCH_AREA_INDEX] + 'ac ]';

    //use arrays for less verbose code
    sgs[0] := sgPrimRds;
    sgs[1] := sgSecRds;
    sgs[2] := sgSFR;
    sgs[3] := sgMFR;
    sgs[4] := sgCICU;
    sgs[5] := sgVeg;
    sgs[6] := sgOthr;

    tempInt := PLRMObj.getCatchIndex(initCatchID);
    cbxGlobalSpecfc.items := PLRMObj.catchments; // loads catchments into combo box
    cbxGlobalSpecfc.ItemIndex := tempInt;
    PLRMObj.currentCatchment := PLRMObj.catchments.Objects[tempInt] as TPLRMCatch;
    curCatchArea := StrToFloat(PLRMobj.currentCatchment.swmmCatch.Data[UProject.SUBCATCH_AREA_INDEX]);


  for I := 0 to High(PLRMObj.currentCatchment.primRdSchms)do
  begin
    getHydSchemes(PLRMObj.currentCatchment.primRdSchms[I], I,HYDSCHMEXTS[I], 'Roads', 'Prr');
  end;

  for I := 0 to High(PLRMObj.currentCatchment.secRdSchms)do
  begin
    getHydSchemes(PLRMObj.currentCatchment.secRdSchms[I], I,HYDSCHMEXTS[I], 'Roads', 'Ser');
  end;

   for I := 0 to High(PLRMObj.currentCatchment.sfrSchms)-1 do
  begin
    getHydSchemes(PLRMObj.currentCatchment.sfrSchms[I], I,HYDSCHMEXTS[I+3], 'Parcels', 'Sfr');
  end;

  for I := 0 to High(PLRMObj.currentCatchment.mfrSchms)-1 do
  begin
    getHydSchemes(PLRMObj.currentCatchment.mfrSchms[I], I,HYDSCHMEXTS[I+3], 'Parcels', 'Mfr');
  end;

  for I := 0 to High(PLRMObj.currentCatchment.cicuSchms)-1 do
  begin
    getHydSchemes(PLRMObj.currentCatchment.cicuSchms[I], I,HYDSCHMEXTS[I+3], 'Parcels', 'Cic');
  end;
//  getHydSchemes(PLRMObj.currentCatchment.vegTSchms[0], I,HYDSCHMEXTS[3], 'Parcels', 'VgT');
//  getHydSchemes(PLRMObj.currentCatchment.othrSchms[0], I,HYDSCHMEXTS[3], 'Parcels', 'Othr');
  getHydSchemes(PLRMObj.currentCatchment.vegTSchms[0], 0,HYDSCHMEXTS[3], 'Parcels', 'VgT');
  getHydSchemes(PLRMObj.currentCatchment.othrSchms[0], 0,HYDSCHMEXTS[3], 'Parcels', 'Othr');

  if PLRMObj.currentCatchment.hasDefDrnXtcs = true then
    restoreFormContents(PLRMobj.currentCatchment)
  else
    initFormContents(PLRMobj.currentCatchment);
end;

procedure TPLRMDrainageConditions.getHydSchemes(var Schm:TPLRMHydPropsScheme; sType:Integer; ext:String; parcelOrRoad:String; luse:String);
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
      tempLst := getFilesInFolder(HYDSCHMSDIR, '*.' + ext);
      if (assigned(tempLst) and (tempLst <> nil)) then
      loadHydPropsScheme2(Schm, HYDSCHMSDIR,ext,HYDSCHMSDIR + '\' + tempLst[0]);
      Schm.luse := luse;
    end;
end;

procedure TPLRMDrainageConditions.checkAndSelectCbxItm(var cbx:TCombobox; scheme:TPLRMHydPropsScheme; schms:TStringList);
var
  tempInt :Integer;
begin
  if (scheme <> nil) then
  begin
    tempInt := schms.indexOf(scheme.name);
    if (tempInt <> -1) then
      cbx.ItemIndex := tempInt
    else
      cbx.ItemIndex := 0;
  end
  else
      cbx.ItemIndex := 0;
end;

  procedure TPLRMDrainageConditions.sgCICUKeyPress(Sender: TObject;
  var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMDrainageConditions.sgGenDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
  begin
  GSUtils.sgGrayOnDrawCell3ColsOnly(Sender,ACol,ARow,Rect,State,1,1,2);
  GSUtils.sgGrayOnDrawCellColAndRow(Sender,ACol, ARow,Rect,State,0,1);
  end;

  procedure TPLRMDrainageConditions.sgGenParcelDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
  begin
  GSUtils.sgGrayOnDrawCell3ColsOnly(Sender,ACol,ARow,Rect,State,0,1,2);
 // GSUtils.sgGrayOnDrawCellColAndRow(Sender,ACol, ARow,Rect,State,0,1);
  end;

  procedure TPLRMDrainageConditions.sgRoadGenSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  GSUtils.sgSelectCellWthNonEditCol(Sender,ACol, ARow,CanSelect,1,1,2);
  GSUtils.sgSelectCellWthNonEditColNRow(Sender,ACol, ARow,CanSelect,0,2);
end;

procedure TPLRMDrainageConditions.sgSecRdsKeyPress(Sender: TObject;
  var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMDrainageConditions.sgSFRKeyPress(Sender: TObject; var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMDrainageConditions.sgParcelGenSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  GSUtils.sgSelectCellWthNonEditCol(Sender,ACol, ARow,CanSelect,0,1,2);
end;

  procedure TPLRMDrainageConditions.sgPrimRdsKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMDrainageConditions.sgGenSetEditText(Sender: TObject; ACol,  ARow: Integer; const Value: string);
var
    tempSum : double;
    irow: Integer;
    sg:TStringGrid;
begin
    sg := Sender as TStringGrid;
    tempSum := 0;
    if sg.Cells[ACol, ARow] <> '' then
    begin
      if ACol = 0  then
      begin
        for irow := 0 to sg.RowCount-2 do
        begin
          if ARow <> irow  then
            tempSum := tempSum + StrToFloat(sg.Cells[ACol, irow])
          else
            tempSum := tempSum + StrToFloat(Value);
          if ((100 - tempSum) > 100) or ((100 - tempSum) < 0) then
          begin
            //ShowMessage('This row must add up to 100. Please enter a different number!');
            ShowMessage('Cell values must not exceed 100% and the sum of all the values in this column must add up to 100%!');
            sg.Cells[ACol,ARow] := prevGridValue;
            Exit;
          end
          else
        end;
        sg.Cells[0, sg.RowCount-1] := FloatToStr(100 - tempSum); //update last row of first column
        updateCalcs(sg);
      end;

      if ACol = 3 then
      begin
        if (StrToFloat(sg.Cells[ACol,ARow]) > 100) then
        begin
          ShowMessage('Cell values in this column must not exceed 100% !');
          sg.Cells[ACol,ARow] := prevGridValue;
          Exit;
        end;
      end;
    end;
end;

  procedure TPLRMDrainageConditions.sgMFRKeyPress(Sender: TObject; var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMDrainageConditions.sgOthrKeyPress(Sender: TObject;
  var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMDrainageConditions.sgVegDrawCell(Sender: TObject; ACol,  ARow: Integer; Rect: TRect; State: TGridDrawState);
  begin
   GSUtils.sgGrayOnDrawCell3ColsOnly(Sender,ACol,ARow,Rect,State,0,1,2);
  end;

  procedure TPLRMDrainageConditions.sgVegKeyPress(Sender: TObject; var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMDrainageConditions.updateCalcs(sg:TStringGrid);
var
    irow,I: Integer;
    prcntImpv:Double;
    area:Double;
begin
  area := 0;
  prcntImpv := 0;
  for I := 0 to High(sgs) do
    if (sgs[I] = sg) then
    begin
        prcntImpv := curImpPrctVals[I];
        area := curAcVals[I];
    end;

  //only acreage and imperv acreage columns calculated
  for irow := 0 to sg.RowCount-1 do
  begin
    sg.Cells[1, irow] := FloatToStr(StrToFloat(sg.Cells[0, irow]) * area/100);
    sg.Cells[2, irow] := FloatToStr(StrToFloat(sg.Cells[1, irow]) * prcntImpv/100);
    end;
end;

//used for road grids that need the first column to be editable but not the last cell in the first column
  procedure TPLRMDrainageConditions.sgGenRdSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
  var
    sg:TStringGrid;
begin
  sg := Sender as TStringGrid;
  prevGridValue := sg.Cells[ACol,ARow];
  GSUtils.sgSelectCellWthNonEditCol(Sender,ACol, ARow,CanSelect,1,1,2);
  GSUtils.sgSelectCellWthNonEditColNRow(Sender,ACol, ARow,CanSelect,0,2);
end;
 //used for road grids that need the first column to be editable but not the last cell in the first column

  procedure TPLRMDrainageConditions.sgGenRdDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  GSUtils.sgGrayOnDrawCell3ColsOnly(Sender,ACol,ARow,Rect,State,1,1,2);
  GSUtils.sgGrayOnDrawCellColAndRow(Sender,ACol, ARow,Rect,State,0,2);
end;

  function getDrngCondsInput(catchID: String): TPLRMDrngXtcsData;
  var
    PLRMDrngXts: TPLRMDrainageConditions;
    data : TPLRMDrngXtcsData;
    tempInt : Integer;
  begin
    initCatchID := catchID;
    PLRMDrngXts := TPLRMDrainageConditions.Create(Application);

    try
      tempInt := PLRMDrngXts.ShowModal;
      if tempInt = mrOK then
      begin
        Result := data
      end;
    finally
      PLRMDrngXts.Free;
    end;
    Result := data;
  end;

  procedure TPLRMDrainageConditions.loadHydPropsScheme(var cbx:TCombobox;sType:Integer;hydCategory:Integer);
  begin
    if stype = 1 then //dealing with parcels
    begin
      case hydCategory of
        0:  loadHydPropsScheme2(cbx,HYDSCHMSDIR,HYDSCHMEXTS[3]);
        1:  loadHydPropsScheme2(cbx,HYDSCHMSDIR,HYDSCHMEXTS[4]);
      end;
    end
    else
    begin
      case  hydCategory of
        0:  loadHydPropsScheme2(cbx,HYDSCHMSDIR,HYDSCHMEXTS[0]);
        1:  loadHydPropsScheme2(cbx,HYDSCHMSDIR,HYDSCHMEXTS[1]);
        2:  loadHydPropsScheme2(cbx,HYDSCHMSDIR,HYDSCHMEXTS[2]);
      end;
    end;
  end;

 procedure TPLRMDrainageConditions.loadHydPropsScheme2(var cbx:TCombobox; dir:String; ext:String; filePath:String = '');
var
   tempInt: Integer;
   opnFileDlg: TOpenDialog;
   Scheme: TPLRMHydPropsScheme;
   tempStr:String;
  begin

  if filePath = '' then
  begin
    opnFileDlg := TOpenDialog.Create(Self);
    opnFileDlg.InitialDir := dir; //GetCurrentDir;
    opnFileDlg.Options := [ofFileMustExist];
    opnFileDlg.Filter := 'Hydrologic Properties Scheme Files(*.' + ext + ')|*.' + ext;
    opnFileDlg.FilterIndex := 1;
    if opnFileDlg.Execute then
      filePath := opnfiledlg.FileName
    else
      exit;
   end;

    PLRMObj.loadHydPropsSchemeFromXML(filePath);
    Scheme := PLRMObj.hydPropsSchemes.Objects[PLRMObj.curhydPropsSchmID] as TPLRMHydPropsScheme;
    if ((cbx.Items = nil) or (cbx.Items.count = 0) or (cbx.Items.IndexOf(Scheme.name) = -1)) then
    begin
      ;
    end
    else
    begin
      tempStr := ExtractFileName(filePath);
      tempStr := StringReplace(tempStr, '.' + ext, '', [rfReplaceAll, rfIgnoreCase]);
      if (cbx.Items.IndexOf(tempStr) <> -1) then
      begin
        ShowMessage('A Scheme with the same name was encountered. Please rename the following scheme and try again: ' + filePath);
        exit;
      end
      else
      begin
        Scheme.name := tempStr;
      end;
    end;
    tempInt := cbx.Items.AddObject(Scheme.name, Scheme);
    cbx.ItemIndex  := tempInt
end;
procedure TPLRMDrainageConditions.loadHydPropsScheme2(var Schm:TPLRMHydPropsScheme; dir:String; ext:String; filePath:String);
var
//   tempInt: Integer;
//   opnFileDlg: TOpenDialog;
   tempStr:String;
  begin
    PLRMObj.loadHydPropsSchemeFromXML(filePath);
    Schm := PLRMObj.hydPropsSchemes.Objects[PLRMObj.curhydPropsSchmID] as TPLRMHydPropsScheme;
    tempStr := ExtractFileName(filePath);
    tempStr := StringReplace(tempStr, '.' + ext, '', [rfReplaceAll, rfIgnoreCase]);
    Schm.name := tempStr;
    Schm.catchName := PLRMObj.currentCatchment.name ;
    end;
end.
