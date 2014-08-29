unit _PLRMD7bGISProgrs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, GSTypes, GSPLRM, GSUtils, GSCatchments;

type
  TPLRMGISProgrsDlg = class(TForm)
    statBar: TStatusBar;
    Image1: TImage;
    lblProgress: TLabel;
    ProgressBar1: TProgressBar;
    lblCurrentItem: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PLRMGISProgrsDlg: TPLRMGISProgrsDlg;

implementation

{$R *.dfm}

procedure TPLRMGISProgrsDlg.FormCreate(Sender: TObject);
begin
  statBar.SimpleText := PLRMVERSION;
end;

end.
