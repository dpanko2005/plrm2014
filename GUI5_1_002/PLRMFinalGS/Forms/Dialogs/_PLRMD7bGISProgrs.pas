unit _PLRMD7bGISProgrs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, GSTypes, GSPLRM, GSUtils, GSCatchments,
  GSGdal;

type
  TPLRMGISProgrsDlg = class(TForm)
    statBar: TStatusBar;
    Image1: TImage;
    lblPercentComplete: TLabel;
    progrBar: TProgressBar;
    lblCurrentItem: TLabel;
    procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

function showGISProgressDialog(): Integer;

var
  PLRMGISProgrsDlg: TPLRMGISProgrsDlg;

implementation

{$R *.dfm}

function showGISProgressDialog(): Integer;
var
  Frm: TPLRMGISProgrsDlg;
  tempInt: Integer;
begin

  Frm := TPLRMGISProgrsDlg.Create(Application);
  try
    runGISOps(shpFilesDict, Frm.progrBar, Frm.lblPercentComplete,
      Frm.lblCurrentItem);
    tempInt := Frm.ShowModal;
  finally
    Frm.Free;
  end;
  Result := tempInt;
end;

procedure TPLRMGISProgrsDlg.FormCreate(Sender: TObject);
begin
  statBar.SimpleText := PLRMVERSION;
  lblCurrentItem.Visible := True;
  lblCurrentItem.Caption := 'Checking catchments GIS file';

  lblPercentComplete.Visible := True;
  lblPercentComplete.Caption := '0%';

  self.CloseModal;
end;

end.
