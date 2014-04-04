unit Dgweqn;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TGWEqnForm = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Memo1: TMemo;
    OkBtn: TButton;
    CancelBtn: TButton;
    Label3: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetEqn(Eqn: String);
    function  GetEqn: String;
  end;

var
  GWEqnForm: TGWEqnForm;

implementation

{$R *.dfm}

procedure TGWEqnForm.SetEqn(Eqn: String);
begin
  Edit1.Text := Eqn;
end;

procedure TGWEqnForm.Button1Click(Sender: TObject);
begin
  Memo1.Visible := True;
end;

function TGWEqnForm.GetEqn: String;
begin
  Result := Trim(Edit1.Text);
end;

end.
