unit _PLRMD7GISTool;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.jpeg, Vcl.ExtCtrls,
  Vcl.ComCtrls, GSIO, GSUtils,GSTypes, GSPLRM, GSCatchments,UProject,
  Vcl.StdCtrls, Vcl.Grids;

type
  TPLRMGISTool = class(TForm)
    Image1: TImage;
    statBar: TStatusBar;
    edtCatchName: TEdit;
    Label2: TLabel;
    btnApply: TButton;
    GroupBox1: TGroupBox;
    Edit1: TEdit;
    Button1: TButton;
    Label1: TLabel;
    Edit2: TEdit;
    Button2: TButton;
    Label3: TLabel;
    Edit3: TEdit;
    Button3: TButton;
    Label4: TLabel;
    Edit4: TEdit;
    Button4: TButton;
    Label5: TLabel;
    Edit5: TEdit;
    Button5: TButton;
    Label6: TLabel;
    Edit6: TEdit;
    Button6: TButton;
    Label7: TLabel;
    GroupBox2: TGroupBox;
    Panel12: TPanel;
    Label21: TLabel;
    Panel1: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    sgNoBMPs: TStringGrid;
    Panel4: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Button7: TButton;
    Edit7: TEdit;
    Label15: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Button8: TButton;
    Button9: TButton;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PLRMGISTool: TPLRMGISTool;

implementation

{$R *.dfm}

procedure TPLRMGISTool.FormCreate(Sender: TObject);
begin
  statBar.SimpleText := PLRMVERSION;
  Self.Caption := PLRMD1_TITLE;
end;

end.
