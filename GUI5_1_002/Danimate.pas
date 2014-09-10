unit Danimate;
{-------------------------------------------------------------------}
{                    Unit:    Fmain.pas                             }
{                    Project: EPA SWMM                              }
{                    Version: 5.0                                   }
{                    Date:    3/29/05                               }
{                             9/5/05                                }
{                    Author:  L. Rossman                            }
{                                                                   }
{   Stay-on-top form that controls animation of the Map and         }
{   Profile plots.                                                  }
{-------------------------------------------------------------------}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ComCtrls, ExtCtrls, Uglobals, Uproject;

type
  TAnimatorForm = class(TForm)
    SpeedBar: TTrackBar;
    RewindBtn: TSpeedButton;
    BackBtn: TSpeedButton;
    PauseBtn: TSpeedButton;
    FwdBtn: TSpeedButton;
    Timer: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PauseBtnClick(Sender: TObject);
    procedure SpeedBarChange(Sender: TObject);
    procedure BackBtnClick(Sender: TObject);
    procedure FwdBtnClick(Sender: TObject);
    procedure RewindBtnClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateStatus;
  end;

var
  AnimatorForm: TAnimatorForm;

implementation

{$R *.dfm}

uses Fmain, Ubrowser;

procedure TAnimatorForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
//-----------------------------------------------------------------------------
//  OnClose handler. Hides the form.
//-----------------------------------------------------------------------------
begin

////  Stop any animation in progress. (LR - 9/5/05) ////
  PauseBtnClick(self);
  
  MainForm.MnuAnimatorToolbar.Checked := False;
  Hide;
end;

procedure TAnimatorForm.UpdateStatus;
//-----------------------------------------------------------------------------
// Updates status of the animation controls after a new analysis has been
// made or a new variable was chosen for viewing on the map.
//-----------------------------------------------------------------------------
var
  IsEnabled: Boolean;
begin
  // Controls enabled only if output results exist
  // and there is more than 1 time period.
  IsEnabled := True;
  if not RunFlag then IsEnabled := False
  else if Nperiods = 1 then IsEnabled := False;
  if not IsEnabled then PauseBtnClick(Self);
  RewindBtn.Enabled := IsEnabled;
  BackBtn.Enabled := IsEnabled;
  PauseBtn.Enabled := IsEnabled;
  FwdBtn.Enabled := IsEnabled;
  SpeedBar.Enabled := IsEnabled;
end;

procedure TAnimatorForm.PauseBtnClick(Sender: TObject);
//-----------------------------------------------------------------------------
//  OnClick handler for the PauseBtn. Pauses the animation.
//-----------------------------------------------------------------------------
begin
  Timer.Enabled := False;
  BackBtn.Down := False;
  FwdBtn.Down := False;
end;

procedure TAnimatorForm.SpeedBarChange(Sender: TObject);
//-----------------------------------------------------------------------------
//  OnChange handler for the SpeedBar trackbar. Changes the speed of the
//  animation.
//-----------------------------------------------------------------------------
begin
  with SpeedBar do
    Timer.Interval := 100*(Max+1-Position);
end;

procedure TAnimatorForm.BackBtnClick(Sender: TObject);
//-----------------------------------------------------------------------------
//  OnClick handler for the BackBtn. Restarts the animation.
//-----------------------------------------------------------------------------
begin
  Timer.Enabled := True;
end;

procedure TAnimatorForm.FwdBtnClick(Sender: TObject);
//-----------------------------------------------------------------------------
//  OnClick handler for the FwdBtn. Restarts the animation.
//-----------------------------------------------------------------------------
begin
  Timer.Enabled := True;
end;

procedure TAnimatorForm.RewindBtnClick(Sender: TObject);
//-----------------------------------------------------------------------------
//  OnClick handler for the RewindBtn. Pauses the animation and resets
//  the current display date to the start of the simulation.
//-----------------------------------------------------------------------------
begin
  PauseBtnClick(Sender);
  Ubrowser.CurrentDateIndex := 0;
  MainForm.DateScrollBar.Position := 0;
  Ubrowser.RefreshTimeListBox(False);
end;

procedure TAnimatorForm.TimerTimer(Sender: TObject);
//-----------------------------------------------------------------------------
//  OnTimer handler for the Timer control. Moves to the next (or previous)
//  simulation time period if the FwdBtn (or BackBtn) is depressed.
//-----------------------------------------------------------------------------
begin
  if FwdBtn.Down then
  begin
    if CurrentPeriod = Nperiods-1 then PauseBtnClick(Sender)
    else Ubrowser.IncreaseElapsedTime;
  end
  else if BackBtn.Down then
  begin
    if CurrentPeriod <= 0 then PauseBtnClick(Sender)
    else Ubrowser.DecreaseElapsedTime;
  end
  else Exit;
end;

procedure TAnimatorForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
//-----------------------------------------------------------------------------
//  Form's OnKeyDown handler. Displays a Help topic when F1 is pressed.
//-----------------------------------------------------------------------------
begin
  if Key = vk_F1 then Application.HelpCommand(HELP_CONTEXT, 211840);
end;

end.
