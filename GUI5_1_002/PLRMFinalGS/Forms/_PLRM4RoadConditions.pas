unit _PLRM4RoadConditions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,xmldom, XMLIntf, msxmldom, XMLDoc,
  Dialogs, Grids, DBGrids, StdCtrls, ExtCtrls, jpeg, ComCtrls,StrUtils, _PLRM5RoadDrnXtcs, GSIO,
  GSUtils, GSTypes, GSPLRM, GSCatchments;

type
  TPLRMRoadConditions = class(TForm)
    statBar: TStatusBar;
    Image1: TImage;
    btnOk: TButton;
    btnCancel: TButton;
    GroupBox2: TGroupBox;
    Panel1: TPanel;
    Label3: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Panel3: TPanel;
    cboRdSwprTypMod: TComboBox;
    cboRdSwprTypLow: TComboBox;
    cboRdSwprTypHigh: TComboBox;
    Label2: TLabel;
    Panel4: TPanel;
    cboRdSwprFreqMod: TComboBox;
    cboRdSwprFreqLow: TComboBox;
    cboRdSwprFreqHigh: TComboBox;
    Label6: TLabel;
    GroupBox1: TGroupBox;
    Label9: TLabel;
    sgRdShouldr: TStringGrid;
    sgXtscsConcs: TStringGrid;
    GroupBox4: TGroupBox;
    Label28: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    sgPollDelFactors: TStringGrid;
    btnApply: TButton;
    dlgSaveScheme: TSaveDialog;
    sgRdReportCardSES: TStringGrid;
    Label10: TLabel;
    Label45: TLabel;
    Panel5: TPanel;
    cboRdAppStgyMod: TComboBox;
    cboRdAppStgyLow: TComboBox;
    cboRdAppStgyHigh: TComboBox;
    Label12: TLabel;
    Panel13: TPanel;
    Label14: TLabel;
    Label15: TLabel;
    Label46: TLabel;
    sgRdReportCardPPS: TStringGrid;
    Panel7: TPanel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label13: TLabel;
    Label47: TLabel;
    sgRamScore: TStringGrid;
    Label11: TLabel;
    Panel6: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Label17: TLabel;
    Panel10: TPanel;
    Label18: TLabel;
    Panel11: TPanel;
    Label19: TLabel;
    Panel12: TPanel;
    Label21: TLabel;
    Panel14: TPanel;
    Label16: TLabel;
    Panel15: TPanel;
    Label7: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure sgRdShouldrSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure sgRdReportCardSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure sgRdShouldrDrawCell(Sender: TObject; ACol,ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure sgXtscsConcsSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
    procedure sgXtscsConcsDrawCell(Sender: TObject; ACol,ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure storeFrmInput(var FrmScheme : TPLRMRdCondsScheme);
    procedure restoreFrmInput(FrmScheme : TPLRMRdCondsScheme);
    procedure partialRestoreFrmInput(FrmScheme : TPLRMRdCondsScheme);
    procedure cboRdSwprTypHighChange(Sender: TObject);

    procedure sgRdShouldrSetEditText(Sender: TObject; ACol, ARow: Integer;const Value: string);
    procedure cboRdAppStgyHighChange(Sender: TObject);
    procedure cboRdAppStgyModChange(Sender: TObject);
    procedure cboRdAppStgyLowChange(Sender: TObject);
    procedure sgRdShouldrKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);

    //Sweeper combo box events
    procedure cboRdSwprTypModChange(Sender: TObject);
    procedure cboRdSwprTypLowChange(Sender: TObject);
    procedure cboRdSwprFreqHighChange(Sender: TObject);
    procedure cboRdSwprFreqModChange(Sender: TObject);
    procedure cboRdSwprFreqLowChange(Sender: TObject);

    // Begin road methodology function descriptions
     function getRSScore(rowNum : Integer) : Double;    //Road shoulder stabilization score
     function lookUpRSValue(rdLuseCode :String; rsScore :Integer): Double;
     function lookUpAppScore(rdLuseCode :String; abrAppScore :Integer): Double; //Returns the appropriate Abrasive Application Score from table
     function calcPollPotScore(rdLuseCode :String; abrAppScore :Integer; rsScore :Integer): Double; //Returns the appropriate Abrasive Application Score from table
     procedure applyPollDelFactors();
     procedure updatePollPotScores();

    procedure updateCRCs();
    procedure sgPollDelFactorsKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sgRdReportCardDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnApplyClick(Sender: TObject);

    procedure sgRdShouldrKeyPress(Sender: TObject; var Key: Char);
    procedure sgXtscsConcsKeyPress(Sender: TObject; var Key: Char);
    procedure sgRdReportCardPPSKeyPress(Sender: TObject; var Key: Char);
    procedure sgRdReportCardSESKeyPress(Sender: TObject; var Key: Char);
    procedure sgPollDelFactorsKeyPress(Sender: TObject; var Key: Char);
    procedure sgPollDelFactorsSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);

 private
    { Private declarations }
  public
    { Public declarations }
  end;

  function getRoadCondition(createNewFlag:Boolean; var cbx:TComboBox; conditionName: String; curRdLuseInpt : String): TPLRMRdCondsScheme;overload;
  function getRoadCondition(Schm:TPLRMRdCondsScheme; curRdLuseInpt : String): TPLRMRdCondsScheme;overload;
  function getRoadConditionSilent(Schm:TPLRMRdCondsScheme; curRdLuseInpt : String): TPLRMRdCondsScheme;
var
  isNewScheme:Boolean;
  curRdLuseCodes: TStringList; //either primary or secondary with risk category
  curGridContents : String;
  curGridRowNum : Integer;
  FrmScheme : TPLRMRdCondsScheme; // Road conditions scheme
  rsCodes : TStringList;    // road shoulder codes from DB
  rsValues : TStringList;  // road shoulder codes values from DB
  raCodes : TStringList;    // road abrasive application codes from DB
  raValues : TStringList;  // road abrasive application codes values from DB
  swprTypCodes : TStringList; //sweeper type codes
  swprTypValues : TStringList; //sweeper type values
  swprFreqCodes : TStringList; //sweeper freq codes
  swprFreqValues : TStringList; //sweeper freq values
  prevGridVal : String;
  // Current selection of rd abravise app strategy combo boxes selections
  appValues : array[0..2] of String;  // For high - 0, mod - 1 and low - 0 road risk category road abrasive application strategy selection
  //Current selection of sweeper type scores combo boxes stored here
  rdSwprTypScores : array[0..2] of string;
  //Current selection of sweeper type scores combo boxes stored here
  rdSwprFreqScores : array[0..2] of string;
implementation

{$R *.dfm}
{$REGION 'GUI view procs'}
//Check if condition already exists, if so load it to be edited, else load form
// for it to be created.
function getRoadCondition(createNewFlag:Boolean; var cbx:TComboBox; conditionName: String; curRdLuseInpt : String): TPLRMRdCondsScheme;
  var
    PLRMRoadConds: TPLRMRoadConditions;
    tempInt : Integer;
  begin
    curRdLuseCodes := TStringList.Create;
    //Set global land use codes
    if curRdLuseInpt = '100' then
        curRdLuseCodes := GSIO.getCodes('62%',0)
     else
       curRdLuseCodes := GSIO.getCodes('63%',0);

    isNewScheme := createNewFlag;
    PLRMRoadConds := TPLRMRoadConditions.Create(Application);
    try
      tempInt := PLRMRoadConds.ShowModal;
      if tempInt = mrOK then
      begin
        FrmScheme.id := intToStr(cbx.items.Count);
        tempInt := cbx.Items.IndexOf(FrmScheme.name);
        if tempInt = -1 then
        begin
           tempInt := cbx.Items.AddObject(FrmScheme.name, FrmScheme);
        end;
        cbx.ItemIndex := tempInt;
        Result := FrmScheme;
      end
      else
        Result := nil;
    finally
      curRdLuseCodes.Free;
    end;
  end;

  //Check if condition already exists, if so load it to be edited, else load form
// for it to be created.
function getRoadCondition(Schm:TPLRMRdCondsScheme; curRdLuseInpt : String): TPLRMRdCondsScheme;overload;
  var
    PLRMRoadConds: TPLRMRoadConditions;
//    tempInt : Integer;
  begin
    curRdLuseCodes := TStringList.Create;
    //Set global land use codes
    if curRdLuseInpt = '100' then
        curRdLuseCodes := GSIO.getCodes('62%',0)
     else
       curRdLuseCodes := GSIO.getCodes('63%',0);

    FrmScheme := Schm;
    PLRMRoadConds := TPLRMRoadConditions.Create(Application);

    try
      PLRMRoadConds.ShowModal;
      Result := FrmScheme;
    finally
      curRdLuseCodes.Free;
    end;
  end;

  function getRoadConditionSilent(Schm:TPLRMRdCondsScheme; curRdLuseInpt : String): TPLRMRdCondsScheme;
  var
    PLRMRoadConds: TPLRMRoadConditions;
    //tempInt : Integer;
    //Sender:TObject;
  begin
    curRdLuseCodes := TStringList.Create;
    //Set global land use codes
    if curRdLuseInpt = '100' then
        curRdLuseCodes := GSIO.getCodes('62%',0)
     else
       curRdLuseCodes := GSIO.getCodes('63%',0);

    FrmScheme := Schm;
    PLRMRoadConds := TPLRMRoadConditions.Create(Application);

    //try

      PLRMRoadConds.Show;
      PLRMRoadConds.Close;
        Result := FrmScheme;
      curRdLuseCodes.Free;
  end;

procedure TPLRMRoadConditions.storeFrmInput(var FrmScheme : TPLRMRdCondsScheme);
  begin
    FrmScheme.pollPotential[0][0] := cboRdAppStgyHigh.Text;
    FrmScheme.pollPotential[1][0] := cboRdAppStgyMod.Text;
    FrmScheme.pollPotential[2][0] := cboRdAppStgyLow.Text;

    FrmScheme.pollPotentialIDs[0][0] := String(appValues[0]);
    FrmScheme.pollPotentialIDs[1][0] :=  String(appValues[1]);
    FrmScheme.pollPotentialIDs[2][0] :=  String(appValues[2]);

    FrmScheme.pollPotential[0][1] := cboRdSwprTypHigh.Text;
    FrmScheme.pollPotential[1][1] := cboRdSwprTypMod.Text;
    FrmScheme.pollPotential[2][1] := cboRdSwprTypLow.Text;

    FrmScheme.pollPotentialIDs[0][1] := String(rdSwprTypScores[0]);
    FrmScheme.pollPotentialIDs[1][1] := String(rdSwprTypScores[1]);
    FrmScheme.pollPotentialIDs[2][1] := String(rdSwprTypScores[2]);

    FrmScheme.pollPotential[0][2] := cboRdSwprFreqHigh.Text;
    FrmScheme.pollPotential[1][2] := cboRdSwprFreqMod.Text;
    FrmScheme.pollPotential[2][2] := cboRdSwprFreqLow.Text;

    FrmScheme.pollPotentialIDs[0][2] := String(rdSwprFreqScores[0]);
    FrmScheme.pollPotentialIDs[1][2] := String(rdSwprFreqScores[1]);
    FrmScheme.pollPotentialIDs[2][2] := String(rdSwprFreqScores[2]);

    FrmScheme.shoulderConds  := GSUtils.copyGridContents(sgRdShouldr);
    FrmScheme.rdReportCardPPS  := GSUtils.copyGridContents(sgRdReportCardPPS);
    FrmScheme.rdReportCardSES  := GSUtils.copyGridContents(sgRdReportCardSES);
    FrmScheme.runoffConcs := GSUtils.copyGridContents(sgXtscsConcs);
    FrmScheme.pollDelFactors  := GSUtils.copyGridContents(sgPollDelFactors);

    FrmScheme.isSet := true;
    FrmScheme.description := 'This is the road conditions scheme';

          btnOk.Enabled := true;
end;

procedure TPLRMRoadConditions.restoreFrmInput(FrmScheme : TPLRMRdCondsScheme);
  begin
    if FrmScheme <> nil then
    partialRestoreFrmInput(FrmScheme);
    GSUtils.copyContentsToGrid(FrmScheme.rdReportCardPPS,0,0,sgRdReportCardPPS);
    GSUtils.copyContentsToGrid(FrmScheme.rdReportCardSES,0,0,sgRdReportCardSES);
    GSUtils.copyContentsToGrid(FrmScheme.runoffConcs,0,0,sgXtscsConcs);
    GSUtils.copyContentsToGrid(FrmScheme.pollDelFactors,0,0,sgPollDelFactors);
end;

procedure TPLRMRoadConditions.partialRestoreFrmInput(FrmScheme : TPLRMRdCondsScheme);
  begin
    if FrmScheme <> nil then
    begin
      cboRdAppStgyHigh.ItemIndex := cboRdAppStgyHigh.Items.IndexOf(FrmScheme.pollPotential[0][0]);
      cboRdAppStgyMod.ItemIndex := cboRdAppStgyMod.Items.IndexOf(FrmScheme.pollPotential[1][0]);
      cboRdAppStgyLow.ItemIndex := cboRdAppStgyLow.Items.IndexOf(FrmScheme.pollPotential[2][0]);

      cboRdSwprTypHigh.ItemIndex := cboRdSwprTypHigh.Items.IndexOf(FrmScheme.pollPotential[0][1]);
      cboRdSwprTypMod.ItemIndex := cboRdSwprTypMod.Items.IndexOf(FrmScheme.pollPotential[1][1]);
      cboRdSwprTypLow.ItemIndex := cboRdSwprTypLow.Items.IndexOf(FrmScheme.pollPotential[2][1]);

      cboRdSwprFreqHigh.ItemIndex := cboRdSwprFreqHigh.Items.IndexOf(FrmScheme.pollPotential[0][2]);
      cboRdSwprFreqMod.ItemIndex := cboRdSwprFreqMod.Items.IndexOf(FrmScheme.pollPotential[1][2]);
      cboRdSwprFreqLow.ItemIndex := cboRdSwprFreqLow.Items.IndexOf(FrmScheme.pollPotential[2][2]);
      GSUtils.copyContentsToGrid(FrmScheme.shoulderConds,0,0,sgRdShouldr);
      GSUtils.copyContentsToGrid(FrmScheme.pollDelFactors,0,0,sgPollDelFactors);

      rdSwprTypScores[0]:=FrmScheme.pollPotentialIDs[0][1];
      rdSwprTypScores[1]:=FrmScheme.pollPotentialIDs[1][1];
      rdSwprTypScores[2]:=FrmScheme.pollPotentialIDs[2][1];

      rdSwprFreqScores[0]:= FrmScheme.pollPotentialIDs[0][2];
      rdSwprFreqScores[1]:= FrmScheme.pollPotentialIDs[1][2];
      rdSwprFreqScores[2]:= FrmScheme.pollPotentialIDs[2][2];

          //Globally store initial selected values not selected text
      appValues[0] := getComboBoxSelValue(cboRdAppStgyHigh);
      appValues[1] := getComboBoxSelValue(cboRdAppStgyMod);
      appValues[2] := getComboBoxSelValue(cboRdAppStgyLow);
    end;
end;

//Begin Road abrasives application combobox change handlers for high. mod, low
procedure TPLRMRoadConditions.cboRdAppStgyHighChange(Sender: TObject);
begin
  appValues[0] := getComboBoxSelValue(sender);
  updateCRCs();
end;

procedure TPLRMRoadConditions.cboRdAppStgyModChange(Sender: TObject);
begin
  appValues[1] := getComboBoxSelValue(sender);
  updateCRCs();
end;

procedure TPLRMRoadConditions.cboRdAppStgyLowChange(Sender: TObject);
begin
  appValues[2] := getComboBoxSelValue(sender);
  updateCRCs();
end;

procedure TPLRMRoadConditions.cboRdSwprFreqHighChange(Sender: TObject);
begin
  rdSwprFreqScores[0] := getComboBoxSelValue(sender);
  updateCRCs();
end;

procedure TPLRMRoadConditions.cboRdSwprFreqLowChange(Sender: TObject);
begin
  rdSwprFreqScores[2] := getComboBoxSelValue(sender);
  updateCRCs();
end;

procedure TPLRMRoadConditions.cboRdSwprFreqModChange(Sender: TObject);
begin
  rdSwprFreqScores[1] := getComboBoxSelValue(sender);
  updateCRCs();
end;

procedure TPLRMRoadConditions.cboRdSwprTypHighChange(Sender: TObject);
begin
  rdSwprTypScores[0] := getComboBoxSelValue(sender);
  updateCRCs();
end;

procedure TPLRMRoadConditions.cboRdSwprTypLowChange(Sender: TObject);
begin
  rdSwprTypScores[2] := getComboBoxSelValue(sender);
  updateCRCs();
end;

procedure TPLRMRoadConditions.cboRdSwprTypModChange(Sender: TObject);
begin
  rdSwprTypScores[1] := getComboBoxSelValue(sender);
  updateCRCs();
end;

procedure TPLRMRoadConditions.FormCreate(Sender: TObject);
var
  idx : integer;
begin
    statBar.SimpleText := PLRMVERSION;
    Self.Caption := PLRM4_TITLE;
    //road shoulder codes
    rsCodes := TStringList.Create;
    rsValues := TStringList.Create;
    GSIO.getCodesAndValues('rs%',rsCodes,rsValues);

    //road abrasives app strategy codes
    raCodes := TStringList.Create;
    raValues := TStringList.Create;
    GSIO.getCodesAndValues('9%',raCodes,raValues);

    for idx := 0 to raCodes.Count - 1 do
    begin
        cboRdAppStgyLow.AddItem(raCodes[idx],  TObject(raValues[idx]));
        cboRdAppStgyMod.AddItem(raCodes[idx],  TObject(raValues[idx]));
        cboRdAppStgyHigh.AddItem(raCodes[idx],  TObject(raValues[idx]));
    end;

    // set defaults
    cboRdAppStgyLow.ItemIndex := 0;
    cboRdAppStgyMod.ItemIndex := 0;
    cboRdAppStgyHigh.ItemIndex := 0;
    //Globally store initial selected values not selected text
    appValues[2] := getComboBoxSelValue(cboRdAppStgyLow);
    appValues[1] := getComboBoxSelValue(cboRdAppStgyMod);
    appValues[0] := getComboBoxSelValue(cboRdAppStgyHigh);

    //road sweeper type codes and values
    swprTypCodes := TStringList.Create;
    swprTypValues := TStringList.Create;
    GSIO.getCodesAndValues('7%',swprTypCodes,swprTypValues);

    for idx := 0 to swprTypCodes.Count - 1 do
    begin
        cboRdSwprTypLow.AddItem(swprTypCodes[idx],  TObject(swprTypValues[idx]));
        cboRdSwprTypMod.AddItem(swprTypCodes[idx],  TObject(swprTypValues[idx]));
        cboRdSwprTypHigh.AddItem(swprTypCodes[idx],  TObject(swprTypValues[idx]));
    end;
    // set defaults
    cboRdSwprTypLow.ItemIndex := 0;
    cboRdSwprTypMod.ItemIndex := 0;
    cboRdSwprTypHigh.ItemIndex := 0;
    //Globally store initial selected values not selected text
    rdSwprTypScores[0] := getComboBoxSelValue(cboRdSwprTypLow);
    rdSwprTypScores[1] := getComboBoxSelValue(cboRdSwprTypMod);
    rdSwprTypScores[2] := getComboBoxSelValue(cboRdSwprTypHigh);

    //road sweeper freq codes and values
    swprFreqCodes := TStringList.Create;
    swprFreqValues := TStringList.Create;
    GSIO.getCodesAndValues('8%',swprFreqCodes,swprFreqValues);

    for idx := 0 to swprFreqCodes.Count - 1 do
    begin
        cboRdSwprFreqLow.AddItem(swprFreqCodes[idx],  TObject(swprFreqValues[idx]));
        cboRdSwprFreqMod.AddItem(swprFreqCodes[idx],  TObject(swprFreqValues[idx]));
        cboRdSwprFreqHigh.AddItem(swprFreqCodes[idx],  TObject(swprFreqValues[idx]));
    end;

  // set defaults
    cboRdSwprFreqLow.ItemIndex := 0;
    cboRdSwprFreqMod.ItemIndex := 0;
    cboRdSwprFreqHigh.ItemIndex := 0;
    //Globally store initial selected values not selected text
    rdSwprFreqScores[0] := getComboBoxSelValue(cboRdSwprFreqLow);
    rdSwprFreqScores[1] := getComboBoxSelValue(cboRdSwprFreqMod);
    rdSwprFreqScores[2] := getComboBoxSelValue(cboRdSwprFreqHigh);

    sgRdShouldr.EditorMode := True;
    //Grid column headers or titles
    sgRdShouldr.Cells[0,0] := '100'; //'Percent Uninprovded';
    sgRdShouldr.Cells[1,0] := '0'; //'Percent Protected Only';
    sgRdShouldr.Cells[2,0] := '0'; //'Percent Stabilized Only';
    sgRdShouldr.Cells[3,0] := '0'; //'Percent Stabilized and Protected';
    sgRdShouldr.Cells[4,0] := '0'; //'Road Shoulder Score';

    //Row 1 initial content
    sgRdShouldr.Cells[0,1] := '100'; //'Percent Uninprovded';
    sgRdShouldr.Cells[1,1] := '0'; //'Percent Protected Only';
    sgRdShouldr.Cells[2,1] := '0'; //'Percent Stabilized Only';
    sgRdShouldr.Cells[3,1] := '0'; //'Percent Stabilized and Protected';
    sgRdShouldr.Cells[4,1] := '0'; //'Road Shoulder Score';

    //Row 2 initial content
    sgRdShouldr.Cells[0,2] := '100'; //'Percent Uninprovded';
    sgRdShouldr.Cells[1,2] := '0'; //'Percent Protected Only';
    sgRdShouldr.Cells[2,2] := '0'; //'Percent Stabilized Only';
    sgRdShouldr.Cells[3,2] := '0'; //'Percent Stabilized and Protected';
    sgRdShouldr.Cells[4,2] := '0'; //'Road Shoulder Score';

    //'Pollutant delivery factors';
    sgPolldelFactors.Cells[0,0] := '1.0';
    sgPolldelFactors.Cells[1,0] := '1.0';
    sgPolldelFactors.Cells[0,1] := '1.0';
    sgPolldelFactors.Cells[1,1] := '1.0';
    sgPolldelFactors.Cells[0,2] := '1.0';
    sgPolldelFactors.Cells[1,2] := '1.0';
    sgPolldelFactors.Cells[2,2] := '1.0';

    partialRestoreFrmInput(FrmScheme);
    //restoreFrmInput(FrmScheme);
    sgXtscsConcs.EditorMode := false;
    sgPolldelFactors.Options:=sgRdShouldr.Options+[goEditing];
    updateCRCs(); //not needed after full restore
end;

//Displays message box saying cell is uneditable if in the 1st column
procedure TPLRMRoadConditions.sgRdShouldrSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  prevGridVal := sgRdShouldr.Cells[ACol,ARow];
  if (ACol=0) or (ACol=4) then
    begin
      sgRdShouldr.Options:=sgRdShouldr.Options-[goEditing];
      ShowMessage(CELLNOEDIT);
    end
  else
  begin
    sgRdShouldr.Options:=sgRdShouldr.Options+[goEditing];
  end;
end;

procedure TPLRMRoadConditions.sgRdShouldrSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: string);
  var
    tempSum : double;
    tempVal:String;
    //tempTxt:String;
  I: Integer;
  //strStart:AnsiString;
begin
    tempSum := 0;
    curGridContents := sgRdShouldr.Cells[ACol, ARow];
    curGridRowNum := ARow;
    tempVal := Value;

    if sgRdShouldr.Cells[ACol, ARow] <> '' then
    begin
      for I := 1 to 3 do
        if I = ACol then
          tempSum := tempSum + StrToFloat(tempVal)
        else
          tempSum := tempSum + StrToFloat(sgRdShouldr.Cells[I, ARow]);
      if ((100 - tempSum) > 100) or ((100 - tempSum) < 0) then
      begin
        ShowMessage('This row must add up to 100. Please enter a different number!');
        sgRdShouldr.Cells[ACol, ARow] := prevGridVal;
        Exit;
      end
      else
        sgRdShouldr.Cells[0, ARow] := FloatToStr(100 - tempSum);
    end;
end;

//Grays out 1st colum of the grid to signify that it is uneditable
procedure TPLRMRoadConditions.sgRdShouldrDrawCell(Sender: TObject; ACol,ARow: Integer; Rect: TRect; State: TGridDrawState);
var S : String;
begin
  if ((ACol=0) or (ACol=4)) then begin //or (ARow = 0 ))then begin
    sgRdShouldr.Canvas.Brush.Color := cl3DLight;
    sgRdShouldr.Canvas.FillRect(Rect);
    S := sgRdShouldr.Cells[ACol, ARow];
     sgRdShouldr.Canvas.Font.Color := clBlue;
    sgRdShouldr.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
  end;
end;

procedure TPLRMRoadConditions.sgRdShouldrKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMRoadConditions.sgRdShouldrKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    updateCRCs;
end;

procedure TPLRMRoadConditions.sgRdReportCardDrawCell(Sender: TObject; ACol,  ARow: Integer; Rect: TRect; State: TGridDrawState);
var S : String;
begin
    (Sender as TStringGrid).Canvas.Brush.Color := cl3DLight;
    (Sender as TStringGrid).Canvas.FillRect(Rect);
    S := (Sender as TStringGrid).Cells[ACol, ARow];
    (Sender as TStringGrid).Canvas.Font.Color := clBlue;
    (Sender as TStringGrid).Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
end;

procedure TPLRMRoadConditions.sgRdReportCardPPSKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMRoadConditions.sgRdReportCardSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  if ACol=1 then
    begin
      (Sender as TStringGrid).Options:=(Sender as TStringGrid).Options-[goEditing];
      ShowMessage(CELLNOEDIT);
    end
  else
  begin
    (Sender as TStringGrid).Options:=(Sender as TStringGrid).Options+[goEditing];
  end;
end;

procedure TPLRMRoadConditions.sgRdReportCardSESKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMRoadConditions.sgPollDelFactorsKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TPLRMRoadConditions.sgPollDelFactorsKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
      //updateCRCs();
end;

procedure TPLRMRoadConditions.sgPollDelFactorsSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: string);
begin
    if (Value = '') then exit;
    updateCRCs();
end;

//Begin Report Card gridcell events
procedure TPLRMRoadConditions.sgXtscsConcsSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin
  if ACol=1 then
    begin
      sgXtscsConcs.Options:=sgXtscsConcs.Options-[goEditing];
      ShowMessage('This Roads Report Card is not directly editable!');
    end
  else
  begin
    sgXtscsConcs.Options:=sgXtscsConcs.Options+[goEditing];
  end;
end;

procedure TPLRMRoadConditions.sgXtscsConcsDrawCell(Sender: TObject; ACol,ARow: Integer; Rect: TRect; State: TGridDrawState);
var s : String;
begin
     sgXtscsConcs.Canvas.Brush.Color := cl3DLight;
    sgXtscsConcs.Canvas.FillRect(Rect);
    S := sgXtscsConcs.Cells[ACol, ARow];
    sgXtscsConcs.Canvas.Font.Color := clBlue;
    sgXtscsConcs.Canvas.TextOut(Rect.Left + 2, Rect.Top + 2, S);
end;
procedure TPLRMRoadConditions.sgXtscsConcsKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

{$ENDREGION}

{$REGION 'Road Methodology Calcs'}
// Begin Road Methodology calculation
function TPLRMRoadConditions.getRSScore(rowNum : Integer) : Double;
var
  jdx : Integer;
  rsScore : Double;
  prcntRdStabValues : TStringList;
  assignedWeights : TStringList;
begin
  prcntRdStabValues := TStringList.Create;
  assignedWeights := TStringList.Create;
    for jdx := 0 to sgRdShouldr.ColCount - 2 do    //Subtract 2 cause last colmn is calculated
    begin
          if sgRdShouldr.Cells[jdx,rowNum] = '' then
          sgRdShouldr.Cells[jdx,rowNum] := '0';
         prcntRdStabValues.Add(sgRdShouldr.Cells[jdx,rowNum]);
         assignedWeights.Add(rsValues[jdx]);
    end;
  rsScore := gsVectorMultiply( prcntRdStabValues, assignedWeights);
  sgRdShouldr.Cells[4,rowNum] := FloatToStr(rsScore / 100); //enter computed value into road shoulder score column
  FreeAndNil(prcntRdStabValues);
  FreeAndNil(assignedWeights);
  Result := rsScore / 100;
end;

function TPLRMRoadConditions.lookUpRSValue(rdLuseCode :String; rsScore :Integer): Double; //Returns the appropriate RS Value from table
begin
   Result := GSIO.lookUpValueFrmPolPotTbl('RoadPollutantPotential','RdLandUseAndRisk',
   '"'+rdLuseCode+'"','RdStabScore',IntToStr(rsScore), 'RSValue');
end;

function TPLRMRoadConditions.lookUpAppScore(rdLuseCode :String; abrAppScore :Integer): Double; //Returns the appropriate Abrasive Application Score from table
begin
   Result := GSIO.lookUpValueFrmPolPotTbl('RoadPollutantPotential','RdLandUseAndRisk',
   '"'+rdLuseCode+'"','AbrAppScore',IntToStr(abrAppScore), 'AppValue');
end;

procedure TPLRMRoadConditions.btnApplyClick(Sender: TObject);
begin
  storeFrmInput(FrmScheme);
end;

procedure TPLRMRoadConditions.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TPLRMRoadConditions.btnOkClick(Sender: TObject);
begin
  btnApplyClick(Sender);
  ModalResult := mrOK;
end;

function TPLRMRoadConditions.calcPollPotScore(rdLuseCode :String; abrAppScore :Integer; rsScore :Integer): Double; //Returns the appropriate Abrasive Application Score from table
var
  rsValue : Double;
  appValue : Double;
begin
  appValue := lookUpRSValue(rdLuseCode,rsScore);
   rsValue := lookUpAppScore(rdLuseCode,abrAppScore);
   Result := appValue + rsValue;
end;

procedure TPLRMRoadConditions.updatePollPotScores(); //Calculated pollutant potential score and updates report card grid
var
  rsScore :Integer;
  rslt : Double;
  idx: Integer;
begin
  for idx := Low(appValues) to High(appValues) do
  begin
    rsScore := Round(getRSScore(idx)); //StrToInt(sgRdShouldr.Cells[4,idx]);
    rslt := calcPollPotScore(curRdLuseCodes[idx],StrToInt(appValues[idx]),rsScore);
    sgRdreportCardPPS.Cells[0,idx] := FloatToStr(rslt);
  end;
end;

function getAdjustedCRC(crc: Double; prcntRed:Double):Double;
begin
  Result := crc * prcntRed;
end;

//Sweeper and adjusted CRC calcs
procedure TPLRMRoadConditions.updateCRCs();
var
  crcs : dbReturnFields; //array[0..1] of TStringList;
  prcntRed: dbReturnFields;
  idx : Integer;
  jdx : Integer;
  ppScore: String;
  adjCRC : Double;
begin
   updatePollPotScores;
   // for each land use + risk code's ppScore look up crcs for all pollutants, populate grid at appropriate locations. repeat for all 3 scores
   for idx := 0 to curRdLuseCodes.Count - 1 do
   begin
    ppScore := FormatFloat('#,##0.0',StrToFloat(sgRdreportCardPPS.Cells[0,idx]));
    crcs := GSIO.lookUpRdCRCs(ppScore);//GSIO.lookUpCRCs(FormatFloat('#,##0.00',ppScore));
    prcntRed := GSIO.lookUpSwprEffReds(StrToInt(rdSwprTypScores[idx]), StrToInt(rdSwprFreqScores[idx]));
    //write sweeper effectiveness score as average of sweepr type and sweepfreq scores to grid
    sgRdreportCardSES.Cells[0,idx] := FormatFloat('0.0',((StrToInt(rdSwprTypScores[idx]) + StrToInt(rdSwprFreqScores[idx]))/2));
    for jdx := 0 to crcs[0].Count - 1 do
    begin
      adjCRC := getAdjustedCRC(StrToFloat(crcs[1][jdx]), 1 - StrToFloat(prcntRed[1][jdx]));
      if jdx < 2 then
        sgXtscsConcs.Cells[jdx,idx] := FloatToStr(Int(adjCrc))
      else
        sgXtscsConcs.Cells[jdx,idx] := FormatFloat('0.00',(adjCrc));
    end;
   end;
   applyPollDelFactors();
end;

procedure TPLRMRoadConditions.applyPollDelFactors();
var
  idx :Integer;
begin
  for idx := 0 to sgPollDelFactors.RowCount - 1 do
  begin
        //apply fines factor
    sgXtscsConcs.Cells[1,idx] := FloatToStr(StrToFloat(sgXtscsConcs.Cells[1,idx]) * StrToFloat(sgPollDelFactors.Cells[0,idx]));
    sgXtscsConcs.Cells[3,idx] := FloatToStr(StrToFloat(sgXtscsConcs.Cells[3,idx]) * StrToFloat(sgPollDelFactors.Cells[0,idx]));
    sgXtscsConcs.Cells[5,idx] := FloatToStr(StrToFloat(sgXtscsConcs.Cells[5,idx]) * StrToFloat(sgPollDelFactors.Cells[0,idx]));
    //apply fines / dissolveds factor
    sgXtscsConcs.Cells[0,idx] := FloatToStr(StrToFloat(sgXtscsConcs.Cells[0,idx]) * StrToFloat(sgPollDelFactors.Cells[1,idx]));
    sgXtscsConcs.Cells[2,idx] := FloatToStr(StrToFloat(sgXtscsConcs.Cells[2,idx]) * StrToFloat(sgPollDelFactors.Cells[1,idx]));
    sgXtscsConcs.Cells[4,idx] := FloatToStr(StrToFloat(sgXtscsConcs.Cells[4,idx]) * StrToFloat(sgPollDelFactors.Cells[1,idx]));
   end;
end;
{$ENDREGION}
end.
