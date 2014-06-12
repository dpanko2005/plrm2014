unit _PLRMstats;

{-------------------------------------------------------------------}
{                    Unit:    Dstats.pas                            }
{                    Project: EPA SWMM                              }
{                    Version: 5.0                                   }
{                    Date:    3/10/06     (5.0.007)                 }
{                             6/19/07     (5.0.010)                 }
{                    Author:  L. Rossman                            }
{                                                                   }
{   Stay-on-top dialog form used to specify statistical analysis    }
{   options for a variable at a given location. Works with the      }
{   TStatsSelection data structure defined in the Ustats unit       }
{   and launches the TStatsReportForm defined in the Fstats unit.   }
{                                                                   }
{   This unit has been completely rewritten (LR - 3/10/06).         }
{   Label next to MinEditDelta field replaced (5.0.010 - LR)        }
{-------------------------------------------------------------------}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, NumEdit, StdCtrls, Buttons, Uglobals, Uproject,
  Ustats, Math, GSTypes, PLRMStats;

type
  TfrmPLRMStats = class(TForm)

    BtnOK: TButton;
    dlgOpenOutputFile: TOpenDialog;
    tbxOutputFileName: TEdit;
    Label1: TLabel;
    Button1: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPLRMStats: TfrmPLRMStats;

implementation

{$R *.dfm}

uses
  Uoutput, GSPLRM, GSNodes;

procedure TfrmPLRMStats.FormShow(Sender: TObject);
//-----------------------------------------------------------------------------
//  OnShow handler.
//-----------------------------------------------------------------------------
begin
  // Set font size
  Uglobals.SetFont(self);
end;


procedure TfrmPLRMStats.FormClose(Sender: TObject; var Action: TCloseAction);
//-----------------------------------------------------------------------------
//  OnClose handler.
//-----------------------------------------------------------------------------
begin
  Action := caFree;
end;


procedure TfrmPLRMStats.BtnOKClick(Sender: TObject);
//-----------------------------------------------------------------------------
//  OnClick handler for the OK button.
//-----------------------------------------------------------------------------
//var
//  ObjName        : String;           // SWMM ID name of object being analyzed
//  tempSWTs : TStringList;
//  tempNode : TPLRMNode;
//  tempSWMMNode : TNode;
//  AnnualLoads : TStringList;
//  swtOut : TswtResults;
//  SWTData : PLRMGridDataDbl;
//  SWTNum : Integer;
//  SWTDataSL : TStringList; //  1-Detention, 2-Infiltration, 3-WetBasin, 4-Bed Filter, 5-Cartridge Filter, 6-Treatment Vault
//  I,J: Integer;
begin
// Place form's selections into a StatsSelection data structure
 Hide;
    PLRMStats.GetAllResults();
end;

procedure TfrmPLRMStats.Button1Click(Sender: TObject);
//var
//PLRMLink : TLink;

begin
  dlgOpenOutputFile.Filter := 'SWMM Output files (*.out)|*.out|All files (*.*)|*.*';

  if dlgOpenOutputFile.Execute then
    tbxOutputFileName.Text := dlgOpenOutputFile.FileName;
   Uglobals.RunStatus := Uoutput.CheckRunStatus(tbxOutputFileName.Text);  //checks to make sure run was successful
   Uoutput.GetBasicOutput; //loads output into memory
end;

end.
