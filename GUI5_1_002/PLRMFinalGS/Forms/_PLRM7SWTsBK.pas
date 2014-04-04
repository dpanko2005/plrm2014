unit _PLRM7SWTsBK;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Grids, DBGrids, StdCtrls, jpeg, ExtCtrls,
  GSTypes, GSUtils, GSIO;

type
  TPLRMSWTs = class(TForm)
    Image1: TImage;
    pgCtrl: TPageControl;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet1: TTabSheet;
    btnOk: TButton;
    btnCancel: TButton;
    btnApply: TButton;
    StatusBar1: TStatusBar;
    GroupBox4: TGroupBox;
    Image2: TImage;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    Button1: TButton;
    Button4: TButton;
    Button7: TButton;
    GroupBox7: TGroupBox;
    Image4: TImage;
    GroupBox8: TGroupBox;
    Button8: TButton;
    GroupBox9: TGroupBox;
    Button9: TButton;
    Button10: TButton;
    sgHyd: TStringGrid;
    sgHydEffl: TStringGrid;
    GroupBox1: TGroupBox;
    Button5: TButton;
    Button6: TButton;
    sgInf: TStringGrid;
    GroupBox2: TGroupBox;
    Button11: TButton;
    StringGrid2: TStringGrid;
    GroupBox3: TGroupBox;
    Image3: TImage;
    sgDet: TStringGrid;
    StringGrid5: TStringGrid;
    procedure InitFrmContents(swtType:Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
 function getSWTInput(swtType: Integer): Boolean;
var
  Frm: TPLRMSWTs;

implementation

{$R *.dfm}
 

procedure TPLRMSWTs.InitFrmContents(swtType:Integer);
var
  I : Integer;
  defProps :dbReturnFields2;
  sgParams:TStringGrid;
begin
  case swtType of
    0:
    begin
      pgCtrl.Pages[0].TabVisible := true;
      pgCtrl.Pages[1].TabVisible := false;
      pgCtrl.Pages[2].TabVisible := false;
      sgParams := sgDet;
      defProps := GSIO.getDefaults('"7%"',1,2,3);
    end;
    1:
    begin
      pgCtrl.Pages[0].TabVisible := false;
      pgCtrl.Pages[1].TabVisible := true;
      pgCtrl.Pages[2].TabVisible := false;
      sgParams := sgInf;
      defProps := GSIO.getDefaults('"8%"',1,2,3);
    end;
    2:
    begin
      pgCtrl.Pages[0].TabVisible := false;
      pgCtrl.Pages[1].TabVisible := true;
      pgCtrl.Pages[2].TabVisible := false;
      sgParams := sgHyd;
      defProps := GSIO.getDefaults('"9%"',1,2,3);
    end;
  end;

  //Headers
  sgParams.Cells[0,0] := 'Parameter';
  sgParams.Cells[1,0] := 'Default Value';
  sgParams.Cells[2,0] := 'Unit';

  I := 0;
  sgParams.Cells[0,I+1] := defProps[0][I];
  sgParams.Cells[1,I+1] := defProps[1][I];
  sgParams.Cells[2,I+1] := defProps[2][I];
  for I := 1 to defProps[0].Count - 1 do
    begin
      GSUtils.AddGridRow(defProps[0][I], sgParams,1);
      sgParams.Cells[0,I+1] := defProps[0][I];
      sgParams.Cells[1,I+1] := defProps[1][I];
      sgParams.Cells[2,I+1] := defProps[2][I];
    end;
end;

function getSWTInput(swtType: Integer): Boolean;
  var
    tempInt : Integer;
  begin
    Frm := TPLRMSWTs.Create(Application);
    Frm.InitFrmContents(swtType);
    try
      tempInt := Frm.ShowModal;
      if tempInt = mrOK then
      begin
        Result := true
      end;
    finally
      Frm.Free;
    end;
    Result := false;
  end;
end.
