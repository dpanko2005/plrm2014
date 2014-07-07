unit _PLRMD6ParcelDrainageAndBMPs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Grids,
  Vcl.ExtCtrls, Vcl.Imaging.jpeg;

type
  TPLRMParcelDrngAndBMPs = class(TForm)
    Image1: TImage;
    lblCatchArea: TLabel;
    lblCatchImprv: TLabel;
    Panel12: TPanel;
    Label21: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    sgRoadShoulderPercents: TStringGrid;
    Panel2: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    StringGrid1: TStringGrid;
    Panel3: TPanel;
    Label7: TLabel;
    Panel4: TPanel;
    Label6: TLabel;
    Label8: TLabel;
    StringGrid2: TStringGrid;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Button1: TButton;
    Button2: TButton;
    statBar: TStatusBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function showPLRMParcelDrngAndBMPsDialog(CatchID: String): Integer;

var
  PLRMParcelDrngAndBMPs: TPLRMParcelDrngAndBMPs;
  catchArea: Double;
  initCatchID: String;

implementation

{$R *.dfm}

function showPLRMParcelDrngAndBMPsDialog(CatchID: String): Integer;
var
  Frm: TPLRMParcelDrngAndBMPs;
  tempInt: Integer;
begin
  initCatchID := CatchID;
  Frm := TPLRMParcelDrngAndBMPs.Create(Application);
  try
    tempInt := Frm.ShowModal;
  finally
    Frm.Free;
  end;
end;

end.
