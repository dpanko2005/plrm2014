unit _PLRM4_2ParcelCRCSumary;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, GSUtils, GSTypes, GSIO, jpeg;

type
  TParcelCRCs = class(TForm)
    Panel6: TPanel;
    Label5: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label4: TLabel;
    Label12: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label3: TLabel;
    Label19: TLabel;
    Image1: TImage;
    sgParcelCRCAdj: TStringGrid;
    //procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure showParcelCRCsSumryForm();
var
  FrmParcelsCRCs: TParcelCRCs;

implementation

{$R *.dfm}

procedure showParcelCRCsSumryForm();
var
  idx :Integer;
  jdx :Integer;
  kdx :Integer;
  nextSetRowInc :Integer;
  FrmParcelsCRCs: TParcelCRCs;
  Rslts : TPLRMRdCondsData;
  tempInt : Integer;
  crcSums : array[0..1, 0..4] of Double;
  crcs : dbReturnFields; //array[0..1] of TStringList;
begin
  FrmParcelsCRCs := TParcelCRCs.Create(Application);
  nextSetRowInc := 3;

  crcs := GSIO.lookUpParcelCRCs();
  kdx := 0;
  for idx := 0 to 11 do//High(primRdCRCs.xtscsConcs) do
    for jdx := 0 to 5 do//High(primRdCRCs.xtscsConcs) do
      begin
         FrmParcelsCRCs.sgParcelCRCAdj.Cells[jdx,idx] := crcs[1][kdx];
         kdx := kdx + 1;
     end;
  try
      tempInt := FrmParcelsCRCs.ShowModal;
      if tempInt = mrOK then
      begin
      end;
    finally
      FrmParcelsCRCs.Free;
    end;
end;

end.
