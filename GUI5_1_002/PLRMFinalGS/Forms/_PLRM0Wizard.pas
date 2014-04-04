unit _PLRM0Wizard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,xmldom, XMLIntf, msxmldom, XMLDoc,
  Dialogs, ExtCtrls, StdCtrls, jpeg, _PLRM1ProjNscenManger, GSIO, GSUtils, GSTypes, _PLRMD1LandUseAssignmnt2, _PLRM3PSCDef,_PLRM5RoadDrnXtcs,
  _PLRMD2SoilsAssignmnt, _PLRM7SWTs, _PLRMD3CatchProps, _PLRMD4Schematics, ExtDlgs,
  ComCtrls;

type
  TPLRMWiz = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Shape1: TShape;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Image3: TImage;
    Image8: TImage;
    Image11: TImage;
    Label15: TLabel;
    Label16: TLabel;
    Image12: TImage;
    Label14: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    imgCompScns: TImage;
    Shape4: TShape;
    Shape5: TShape;
    Shape6: TShape;
    Button1: TButton;
    Shape7: TShape;
    Label5: TLabel;
    Label2: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    Shape2: TShape;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Label10: TLabel;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    btnOpnPLRM: TButton;
    dlgOpnInptFile: TOpenTextFileDialog;
    btnCatchProps: TButton;
    btTestSchmatics: TButton;
    Button10: TButton;
    statBar: TStatusBar;
    procedure Image8Click(Sender: TObject);
    procedure generalImgMouseEnter(Sender: TObject);
    procedure generalImgMouseLeave(Sender: TObject);
    procedure Label10Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure btnCatchPropsClick(Sender: TObject);
    procedure imgCompScnsClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PLRMWiz: TPLRMWiz;

implementation
uses   GSPLRM, _PLRM9ScenCompsMulti;

{$R *.dfm}

procedure TPLRMWiz.btnCatchPropsClick(Sender: TObject);
begin
  getCatchProps('0');
end;

procedure TPLRMWiz.Button1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TPLRMWiz.Button9Click(Sender: TObject);
begin
getSWTProps('1',1)
end;

procedure TPLRMWiz.FormCreate(Sender: TObject);
begin
  statBar.SimpleText := PLRMVERSION;
  PLRMObj := TPLRM.Create;
  Self.Caption := PLRM0_WIZTITLE;
end;

procedure TPLRMWiz.Image8Click(Sender: TObject);
var
  tempInt:Integer;
begin
 ProjScenMangerFrm :=  TProjNscenManager.Create(self) ;
 with ProjScenMangerFrm do
      try
      begin
        tempInt := ShowModal;
        if tempInt = mrCancel then
          exit;
      end;
    finally
      Free;
    end;
    ModalResult := mrOK;
end;

procedure TPLRMWiz.imgCompScnsClick(Sender: TObject);
var tempInt:Integer;
begin
 PLRMScenComps :=  TPLRMScenComps.Create(self) ;
 with PLRMScenComps do
      try
      begin
        tempInt := ShowModal;
        if tempInt = mrCancel then
          exit;
      end;
    finally
      Free;
    end;
    ModalResult := mrOK;
end;

procedure TPLRMWiz.generalImgMouseEnter(Sender: TObject);
begin
 (Sender as TImage).Top := (Sender as TImage).top + 5;
end;

procedure TPLRMWiz.generalImgMouseLeave(Sender: TObject);
begin
(Sender as TImage).Top := (Sender as TImage).top - 5;
end;

procedure TPLRMWiz.Label10Click(Sender: TObject);
begin
  GSUtils.BrowseURL('http://maps.google.com/maps?q=http://code.google.com/apis/kml/documentation/KML_Samples.kml') ;
end;

end.
