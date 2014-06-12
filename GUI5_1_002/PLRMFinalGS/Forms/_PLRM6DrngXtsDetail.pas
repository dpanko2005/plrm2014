unit _PLRM6DrngXtsDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,FileCtrl, xmldom, XMLIntf, msxmldom, XMLDoc,
  Dialogs, StdCtrls, ComCtrls, ExtCtrls, jpeg, Grids, GSTypes, GSUtils, GSIO, GSPLRM, GSCatchments, UProject;

type TPLRMDrngXtsDetail = class(TForm)
    Image1: TImage;
    GroupBox2: TGroupBox;
    btnOK: TButton;
    btnCancel: TButton;
    btnSaveScheme: TButton;
    statBar: TStatusBar;
    Panel2: TPanel;
    Label2: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    cbxSnowPacks: TComboBox;
    gbxBMPHydProps: TGroupBox;
    Panel6: TPanel;
    Label14: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    lblGAmptTitle: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label3: TLabel;
    Label9: TLabel;
    Label15: TLabel;
    Panel4: TPanel;
    Label17: TLabel;
    Label18: TLabel;
    TabSheet2: TTabSheet;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Panel5: TPanel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label4: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Panel3: TPanel;
    Panel7: TPanel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    sgHydPropsDrng: TStringGrid;
    sgGreenAmpt: TStringGrid;
    sgPervDisp: TStringGrid;
    sgInf: TStringGrid;
    lblCatchArea: TLabel;
    btnApply: TButton;
    dlgSaveScheme: TSaveDialog;
    Label1: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure initFormContents(catch: TPLRMCatch);
    procedure FormCreate(Sender: TObject);
    procedure sgGenDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgGenSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);
    procedure restoreFrmInput(FrmScheme : TPLRMHydPropsScheme);
    procedure Button1Click(Sender: TObject);
    procedure cbxSnowPacksChange(Sender: TObject);
    procedure sgHydPropsDrngKeyPress(Sender: TObject; var Key: Char);
    procedure sgPervDispKeyPress(Sender: TObject; var Key: Char);
    procedure sgGreenAmptKeyPress(Sender: TObject; var Key: Char);
    procedure sgInfKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function getSDrngXtsScheme(var Schm:TPLRMHydPropsScheme; isRoad:Boolean; sType:Integer): TPLRMHydPropsScheme;

  var
  FrmData : TPLRMHydPropsScheme; //global data structure used to store form input
  Frm: TPLRMDrngXtsDetail;
  initCatchID: String;
  isNewScheme:Boolean;
  initSnowPackIdx: Integer; //used to preselect appropriate snow pack from combo box
implementation

{$R *.dfm}

procedure TPLRMDrngXtsDetail.initFormContents(catch: TPLRMCatch);
  var
    I : Integer;
    hydProps :dbReturnFields;
    gaProps :dbReturnFields;
  begin
      hydProps := GSIO.getDefaults('"6%"');
      for I := 0 to sgHydPropsDrng.RowCount - 2 do
      begin
        sgHydPropsDrng.Cells[0,I] := hydProps[0][I];
        sgHydPropsDrng.Cells[1,I] := hydProps[1][I];
        sgHydPropsDrng.Cells[2,I] := hydProps[0][I];
      end;
//
      for I := 0 to sgGreenAmpt.RowCount - 1 do
      begin
        sgGreenAmpt.Cells[0,I] := FormatFloat('#0.00',StrToFloat(PLRMObj.currentCatchment.soilsInfData[0,I+1]));
        sgGreenAmpt.Cells[2,I] := FormatFloat('#0.00',StrToFloat(PLRMObj.currentCatchment.soilsInfData[0,I+1]));
      end;
      sgGreenAmpt.Cells[1,0] := 'in/hr';
      sgGreenAmpt.Cells[1,1] := 'in';
      sgGreenAmpt.Cells[1,2] := 'in';

      case FrmData.stype of
        0:
        begin
          lblGAmptTitle.Caption := 'Green Ampt Parameters for Areas draining directly to the outlet';
          gbxBMPHydProps.visible := false;
        end;
        1:
        begin
          gaProps := GSIO.getDefaults('"8%"');
          lblGAmptTitle.Caption := 'Green Ampt Parameters for Infiltration Facilities ';
          PageControl1.Pages[0].TabVisible := true;
          PageControl1.Pages[1].TabVisible := false;

          //Unit storage area
          sgInf.Cells[0,0] := FormatFloat('#0',StrToFloat(gaProps[0][0]));
          sgInf.Cells[1,0] := gaProps[1][0];
          sgInf.Cells[2,0] := FormatFloat('#0',StrToFloat(gaProps[0][0]));

         //added 7/21/09 change to only expose ksat
          sgInf.Cells[0,1] := FormatFloat('#0.00',StrToFloat(gaProps[0][1]));
          sgInf.Cells[1,1] := gaProps[1][1];
          sgInf.Cells[2,1] := FormatFloat('#0.00',StrToFloat(gaProps[0][1]));
        end;
        2:
        begin
          gaProps := GSIO.getDefaults('"9%"');
          lblGAmptTitle.Caption := 'Green Ampt Parameters for Pervious Dispersion Areas';
          PageControl1.Pages[0].TabVisible := false;
          PageControl1.Pages[1].TabVisible := true;

          //Pervious dispersion footprint
          sgPervDisp.Cells[0,0] := FormatFloat('#0',StrToFloat(gaProps[0][0]));
          sgPervDisp.Cells[1,0] := gaProps[1][0];
          sgPervDisp.Cells[2,0] := FormatFloat('#0',StrToFloat(gaProps[0][0]));

          //Pervious dispersion slope
          sgPervDisp.Cells[0,1] := FormatFloat('#0.0',StrToFloat(gaProps[0][1]));
          sgPervDisp.Cells[1,1] := gaProps[1][1];
          sgPervDisp.Cells[2,1] := FormatFloat('#0.0',StrToFloat(gaProps[0][1]));

          //added 7/21/09 change to expose ksat
          sgPervDisp.Cells[0,2] := FormatFloat('#0.00',StrToFloat(PLRMObj.currentCatchment.soilsInfData[0,1]));
          sgPervDisp.Cells[1,2] := 'in/hr';
          sgPervDisp.Cells[2,2] := FormatFloat('#0.00',StrToFloat(PLRMObj.currentCatchment.soilsInfData[0,1]));

          //added 8/04/09 change to allow custom depression storage
          sgPervDisp.Cells[0,3] := FormatFloat('#0.0',StrToFloat(gaProps[0][2]));
          sgPervDisp.Cells[1,3] :=  gaProps[1][2];
          sgPervDisp.Cells[2,3] := FormatFloat('#0.0',StrToFloat(gaProps[0][2]));
        end;
      end;
end;

procedure TPLRMDrngXtsDetail.restoreFrmInput(FrmScheme : TPLRMHydPropsScheme);
var
  tempInt:Integer;
  begin
    tempInt :=snowPackNames.IndexOf(FrmScheme.snowPackID);
    if (tempInt <> -1) then  cbxSnowPacks.ItemIndex := tempInt;

    if FrmScheme <> nil then
    begin
      GSUtils.copyContentsToGrid(FrmScheme.drngHydProps,0,0,sgHydPropsDrng);
      if ((sgGreenAmpt.Cells[0,0]= FrmScheme.hydPropsGA[0,0]) and (sgGreenAmpt.Cells[0,1]= FrmScheme.hydPropsGA[1,0])) then  //this condition not true first time scheme is loaded from file. true after scheme is saved
      begin
        sgGreenAmpt.Cells[2,0] := FrmScheme.hydPropsGA[0,2];
        sgGreenAmpt.Cells[2,1] := FrmScheme.hydPropsGA[1,2];
        sgGreenAmpt.Cells[2,2] := FrmScheme.hydPropsGA[2,2];
      end;
    end;

    case FrmData.stype of
      1:
      begin
        GSUtils.copyContentsToGridNChk(FrmScheme.hydPropsHSC,0,0,sgInf);
        if(sgInf.RowCount > 2)then sgInf.RowCount := sgInf.RowCount - 2;
      end;
      2:
        GSUtils.copyContentsToGridNChk(FrmScheme.hydPropsHSC,0,0,sgPervDisp);
    end;
end;

procedure TPLRMDrngXtsDetail.sgGenDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  GSUtils.sgGrayOnDrawCell3ColsOnly(Sender,ACol,ARow,Rect,State,0,1,1);
end;

procedure TPLRMDrngXtsDetail.sgGenSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  GSUtils.sgSelectCellWthNonEditCol(Sender,ACol, ARow,CanSelect,0,1,1);
end;

procedure TPLRMDrngXtsDetail.sgGreenAmptKeyPress(Sender: TObject;
  var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMDrngXtsDetail.sgHydPropsDrngKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMDrngXtsDetail.sgInfKeyPress(Sender: TObject; var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMDrngXtsDetail.sgPervDispKeyPress(Sender: TObject; var Key: Char);
begin
gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMDrngXtsDetail.btnApplyClick(Sender: TObject);
begin
  FrmData.drngHydProps := GSUtils.copyGridContents(0,0, sgHydPropsDrng);
  FrmData.hydPropsGA := GSUtils.copyGridContents(0,0, sgGreenAmpt);
  FrmData.snowPackID := cbxSnowPacks.Text;
  //case category of
  case  FrmData.stype of
    0:
    begin
      FrmData.stype := 0;
      Frmdata.category := 'ToOutlet';
    end;
    1:
    begin
      FrmData.stype := 1;
      Frmdata.category := 'ToInfiltration';
      Frmdata.description := 'Hydrologic Properties Scheme - To Infiltration HSC';
      FrmData.hydPropsHSC := GSUtils.copyGridContents(0,0, sgInf);
    end;
    2:
    begin
      FrmData.stype := 2;
      Frmdata.category := 'ToPerviousDispersion';
      Frmdata.description := 'Hydrologic Properties Scheme - To Pervious Dispersion Area ';
      FrmData.hydPropsHSC := GSUtils.copyGridContents(0,0, sgPervDisp);
    end;
  end;
  FrmData.isSet := true
end;

procedure TPLRMDrngXtsDetail.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TPLRMDrngXtsDetail.Button1Click(Sender: TObject);
begin
  PLRMObj.plrmToXML;
end;

procedure TPLRMDrngXtsDetail.cbxSnowPacksChange(Sender: TObject);
begin
  FrmData.snowPackID := cbxSnowPacks.Text;
end;

procedure TPLRMDrngXtsDetail.btnOKClick(Sender: TObject);
begin
  if (FrmData.snowPackID = '-1') then
  begin
    showMessage('Please select snow pack');
    exit;
  end;
  btnApplyClick(Sender);
  ModalResult := mrOk;
end;

procedure TPLRMDrngXtsDetail.FormCreate(Sender: TObject);
begin
  statBar.SimpleText := PLRMVERSION;

  if FrmData.stype = 0 then Self.Caption := PLRM6_TITLE;
  if FrmData.stype = 1 then Self.Caption := PLRM6inf_TITLE;
  if FrmData.stype = 2 then Self.Caption := PLRM6dsp_TITLE;


  if (Assigned(GSUtils.snowPackNames) = false) then getSwmmDefaultBlocks(5); //fills snowPackNames list
  begin
    cbxSnowPacks.Items := SnowPackNames;
    cbxSnowPacks.ItemIndex := initSnowPackIdx;
  end;
  initFormContents(PLRMobj.currentCatchment);
  //10/18  '-1' indicates catchment info was incompletely provided before saving
  //12/28/09 if ((FrmData.hydPropsGA[0,0] <> '-1') and (FrmData.hydPropsHSC[2,0] <> '-1')) then restoreFrmInput(FrmData);
  //12/28/09 Fixed error preventing _PLRM6 from being loaded the second time
  if ((FrmData.hydPropsGA[0,2] <> '-1') and (FrmData.hydPropsHSC[0,2] <> '-1')) then restoreFrmInput(FrmData);
end;

  //sType -0 - to outlet, 1 - to infiltration, 2 - to pervious dispersion
function getSDrngXtsScheme(var Schm:TPLRMHydPropsScheme; isRoad:Boolean; sType:Integer): TPLRMHydPropsScheme;
//  var
//    Sender:TObject;
  begin
    if isRoad = true then
      initSnowPackIdx := 0
    else
      initSnowPackIdx := 1;
    if Schm = nil then
    begin
       Schm := TPLRMHydPropsScheme.Create();
       Schm.stype := sType;
    end;

    FrmData := Schm;
    Frm := TPLRMDrngXtsDetail.Create(Application);
    Frm.Visible := false;
    FrmData.snowPackID := Frm.cbxSnowPacks.Text;
    Frm.ShowModal;
    Result := FrmData;
  end;

end.
