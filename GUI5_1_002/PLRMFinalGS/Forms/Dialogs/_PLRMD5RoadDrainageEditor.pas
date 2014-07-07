unit _PLRMD5RoadDrainageEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.jpeg,
  Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TPLRMRoadDrainageEditor = class(TForm)
    Image1: TImage;
    lblCatchArea: TLabel;
    lblCatchImprv: TLabel;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Edit3: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Edit4: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Edit8: TEdit;
    Edit9: TEdit;
    Edit10: TEdit;
    Label15: TLabel;
    Edit11: TEdit;
    Label16: TLabel;
    Edit12: TEdit;
    Label17: TLabel;
    Edit13: TEdit;
    statBar: TStatusBar;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function showRoadRoadDrainageEditorDialog(CatchID: String): Integer;

var
  PLRMRoadDrainageEditor: TPLRMRoadDrainageEditor;
  catchArea: Double;
  initCatchID: String;

implementation

{$R *.dfm}

function showRoadRoadDrainageEditorDialog(CatchID: String): Integer;
var
  Frm: TPLRMRoadDrainageEditor;
  tempInt: Integer;
begin
  initCatchID := CatchID;
  Frm := TPLRMRoadDrainageEditor.Create(Application);
  try
    tempInt := Frm.ShowModal;
  finally
    Frm.Free;
  end;
end;

end.
