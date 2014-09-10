unit Dcontrol;

{-------------------------------------------------------------------}
{                    Unit:    Dcontrol.pas                          }
{                    Project: EPA SWMM                              }
{                    Version: 5.1                                   }
{                    Date:    12/2/13      (5.1.000)                }
{                    Author:  L. Rossman                            }
{                                                                   }
{   Form unit with a memo control that edits Rule-Based Controls.   }
{-------------------------------------------------------------------}

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  System.UITypes,
  Uproject, Uglobals;

type
  TControlsForm = class(TForm)
    Memo1: TMemo;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    Panel2: TPanel;
    BtnOK: TButton;
    BtnCancel: TButton;
    BtnHelp: TButton;
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnHelpClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    StartLine: Integer;
  public
    { Public declarations }
    procedure FindRule(const RuleID: String);
  end;

//var
//  ControlsForm: TControlsForm;

implementation

{$R *.DFM}

procedure TControlsForm.FormCreate(Sender: TObject);
//-----------------------------------------------------------------------------
//  Form's OnCreate handler.
//-----------------------------------------------------------------------------
begin
  Uglobals.SetFont(self);
  Memo1.Font.Style := Font.Style;
  Memo1.Lines.Assign(Project.ControlRules);
  StartLine := -1;
end;

procedure TControlsForm.FormActivate(Sender: TObject);
//-----------------------------------------------------------------------------
//  Form's OnActivate handler. Scrolls Memo1 control down to where
//  user's selected rule begins (as determined by FindRule below).
//-----------------------------------------------------------------------------
var
  ScrollMessage: TWMVScroll;
  I: Integer;
begin
  if StartLine >= 0 then
  begin
    ScrollMessage.Msg := wm_VScroll;
    for I := 0 to StartLine-1 do
    begin
      ScrollMessage.ScrollCode := sb_LineDown;
      ScrollMessage.Pos := 0;
      Memo1.Dispatch(ScrollMessage);
    end;
  end;

end;

procedure TControlsForm.FindRule(const RuleID: String);
//-----------------------------------------------------------------------------
//  Finds line number in Memo1 where rule RuleID begins.
//-----------------------------------------------------------------------------
var
  I : Integer;
  Line: String;
begin
  StartLine := -1;
  if Length(RuleID) = 0 then Exit;
  for I := 0 to Memo1.Lines.Count-1 do
  begin
    Line := Trim(Memo1.Lines[I]);
    if Pos('RULE', UpperCase(Line)) = 0 then continue;
    if Pos(RuleID, Line) <> 0 then
    begin
      StartLine := I;
      Break;
    end;
  end;
end;

procedure TControlsForm.BtnOKClick(Sender: TObject);
//-----------------------------------------------------------------------------
//  OnClick handler for the OK button.
//-----------------------------------------------------------------------------
var
  I: Integer;
begin
  if Memo1.Modified then
  begin
    Uglobals.HasChanged := True;
    Project.ControlRules.Assign(Memo1.Lines);

    // Remove blank lines from end of control rules list
    with Project.ControlRules do
    begin
      for I := Count-1 downto 0 do
        if Length(Strings[I]) > 0 then break else Delete(I);
    end;

  end;
end;

procedure TControlsForm.BtnHelpClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT, 210740);
end;

procedure TControlsForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then BtnHelpClick(Sender);
end;

end.
