unit _PLRMD5VolumeDischarge;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, ComCtrls, GSPLRM,GSNodes, Grids, GridEdit,GSTypes, Math;

type
  TVolumeDischargeForm = class(TForm)
    BtnSave: TButton;
    BtnCancel: TButton;
    sgVolDischarge: TStringGrid;
    Label1: TLabel;
    btnAutoCalc: TButton;
    statBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnCancelClick(Sender: TObject);
    procedure btnAutoCalcClick(Sender: TObject);
    procedure sgVolDischargeKeyPress(Sender: TObject; var Key: Char);
  private

  public
    { Public declarations }
  end;

var
  VolumeDischargeForm: TVolumeDischargeForm;

implementation

{$R *.DFM}

uses
  Dtblplot, Fmain, Uedit, GSIO, GSUtils, UProject, _PLRM7SWTs;

procedure TVolumeDischargeForm.FormCreate(Sender: TObject);
//-----------------------------------------------------------------------------
// Form's OnCreate handler.
//-----------------------------------------------------------------------------
var
//  I : Integer;
  data :PLRMGridData;
//  sg : TStringGrid;

begin
    statBar.SimpleText := PLRMVERSION;
    Self.Caption := PLRMD5_TITLE;
    //Read in curve from current node
    if (PLRMObj.currentNode.swtType = 4) then  PLRMObj.currentNode.volumeDischarge[2,0] := 'Filtration. Rate (in/hr)';
   data := PLRMObj.currentNode.volumeDischarge;
   copyInvertedPLRMGridToStrGrid(data,0,0,sgVolDischarge);
end;


procedure TVolumeDischargeForm.sgVolDischargeKeyPress(Sender: TObject;
  var Key: Char);
begin
  gsEditKeyPress(Sender,Key,gemPosNumber) ;
end;

procedure TVolumeDischargeForm.BtnCancelClick(Sender: TObject);
begin
  //PLRMObj.currentNode.userCustomizedCurveFlag := False;
  VolumeDischargeForm.Close;
  //modalResult := mrCancel;
end;

procedure TVolumeDischargeForm.BtnSaveClick(Sender: TObject);
//-----------------------------------------------------------------------------
// OnClick handler for Save button.
//-----------------------------------------------------------------------------
var
I : integer;
DDTInc : Double;
InfInc : Array of Double;
InfSum : Double;
curNode : TPLRMNode;
begin
  curNode := PLRMObj.currentNode;
  //Update volume discharge grid
  curNode.volumeDischarge := copyStringGridToInvertedPLRMGrid(sgVolDischarge);

  //Update stage discharge grids; since volume increment cannot be changed, only discharge
  //rate needs to be updated
  for I := 1 to sgVolDischarge.RowCount-1 do//skipping header row
  begin
     curNode.stageTmtDischarge[1,I] := curNode.volumeDischarge[1,I];
     curNode.stageInfDischarge[1,I] := curNode.volumeDischarge[2,I];
 end;
 //calculate new drawdown time and average infiltration rate
  DDTInc := 0;
 //InfInc := 0;
  InfSum := 0;
 SetLength(InfInc,sgVolDischarge.RowCount-2);
 for I := 1 to sgVolDischarge.RowCount-2 do
   begin
     DDTInc := DDTInc + (StrToFloat(curNode.volumeDischarge[0,I+1])-
        StrToFloat(curNode.volumeDischarge[0,I]))/(0.5*(StrToFloat(curNode.volumeDischarge[1,I+1])+
          StrToFloat(curNode.volumeDischarge[1,I])));
     InfInc[I-1] := ((StrToFloat(curNode.stageInfDischarge[0,I+1])-
        StrToFloat(curNode.stageInfDischarge[0,I]))/StrToFloat(curNode.stageInfDischarge[0,sgVolDischarge.RowCount-1]))*
          0.5*(StrToFloat(curNode.stageInfDischarge[1,I+1])+StrToFloat(curNode.stageInfDischarge[1,I]));
     //InfSum := InfInc[I-1] + InfSum;
   end;

DDTInc := DDTInc/3600;
InfSum := Sum(InfInc);

case curNode.SWTType of
  1: ShowMessage('Calculated brimful drawdown time is: ' + FormatFloat('0.####',DDTInc)+
    ' hrs' + #13#10+ 'Calculated volume-weighted average infiltration rate: ' +
    FormatFloat('0.####',InfSum)+ ' in/hr');
  2: ShowMessage('Calculated volume-weighted average infiltration rate: ' + FormatFloat('0.####',InfSum)+ ' in/hr');
  3: ShowMessage('Calculated brimful drawdown time for surcharge volume is: ' + FormatFloat('0.####',DDTInc)+
    ' hrs');
  4: ShowMessage('Calculated volume-weighted average infiltration rate: ' + FormatFloat('0.####',InfSum)+ ' in/hr');

end;

 curNode.userCustomizedCurveFlag := True;
 VolumeDischargeForm.Free;
 VolumeDischargeForm.Close;
end;


procedure TVolumeDischargeForm.btnAutoCalcClick(Sender: TObject);
var
  buttonSelected:Integer;
begin

  buttonSelected := MessageDlg('The current volume discharge curve may be overwritten if you proceed. Do you want to continue?',mtCustom,[mbYes,mbNo], 0);
  if (buttonSelected = mrNo) then Exit;
  
  PLRMObj.currentNode.userCustomizedCurveFlag := False;
  SWTs.btnApplyClick(Sender);
  //Refresh grid
 copyInvertedPLRMGridToStrGrid(PLRMObj.currentNode.volumeDischarge,0,0,sgVolDischarge);
end;

end.
