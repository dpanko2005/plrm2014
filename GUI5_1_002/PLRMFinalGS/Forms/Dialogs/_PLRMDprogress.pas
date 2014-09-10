unit _PLRMDprogress;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls;

type
  TplrmProgress = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    lblProgress: TLabel;
    Label2: TLabel;
    progBar: TProgressBar;
    procedure CancelBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  plrmProgress: TplrmProgress;
  S:TStringList;
implementation
uses
  GSIO, GSPLRM;
{$R *.dfm}

procedure TplrmProgress.CancelBtnClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TplrmProgress.FormCreate(Sender: TObject);
begin
  lblProgress.Caption := StringReplace(lblProgress.Caption,'<P1>', intToStr(PLRMObj.metGridNum),[rfReplaceAll]);
end;

procedure TplrmProgress.OKBtnClick(Sender: TObject);
begin
    S := getAndSaveTSeries(PLRMObj.metGridNum,progBar);
end;

end.
