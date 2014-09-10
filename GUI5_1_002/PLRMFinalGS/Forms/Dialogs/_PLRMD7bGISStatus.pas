unit _PLRMD7bGISStatus;

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
    lblErrors: TLabel;
    btnOk: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnOkClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

function showGISProgressDialog(msgsList: TStringList): Integer;

var
  PLRMGISProgrsDlg: TPLRMGISProgrsDlg;

implementation

{$R *.dfm}

function showGISProgressDialog(msgsList: TStringList): Integer;
var
  Frm: TPLRMGISProgrsDlg;
  tempInt: Integer;
  I: Integer;
begin

  Frm := TPLRMGISProgrsDlg.Create(Application);
  try
    if (assigned(msgsList)) then
      for I := 0 to msgsList.Count - 1 do
      begin
        Frm.lblErrors.Caption := Frm.lblErrors.Caption + #13#10 + msgsList[I];
      end;
    tempInt := Frm.ShowModal;
  finally
    Frm.Free;
  end;
  Result := tempInt;
end;

procedure TPLRMGISProgrsDlg.btnOkClick(Sender: TObject);
begin
  self.Close;
end;

procedure TPLRMGISProgrsDlg.FormCreate(Sender: TObject);
begin
  statBar.SimpleText := PLRMVERSION;
  lblErrors.Caption := '';
end;

end.
