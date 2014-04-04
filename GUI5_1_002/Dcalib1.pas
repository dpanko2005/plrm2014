unit Dcalib1;

{-------------------------------------------------------------------}
{                    Unit:    Dcalib1.pas                           }
{                    Project: EPA SWMM                              }
{                    Version: 5.1                                   }
{                    Date:    1/2/14        (5.1.000)               }
{                    Author:  L. Rossman                            }
{                                                                   }
{   Dialog form unit that obtains names of calibration data files   }
{   for different measurement variables.                            }
{-------------------------------------------------------------------}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Grids, ExtCtrls, StdCtrls, Buttons, Uglobals, OpenDlg;

type
  TCalibDataForm = class(TForm)
    StringGrid1: TStringGrid;
    BtnOK: TButton;
    BtnCancel: TButton;
    BtnHelp: TButton;
    BtnBrowse: TSpeedButton;
    BtnEdit: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnBrowseClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnHelpClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    FileDir: String;
  public
    { Public declarations }
  end;

//var
//  CalibDataForm: TCalibDataForm;

implementation

{$R *.DFM}

uses Fmain;

const
  TXT_PARAMETER = 'Calibration Variable';
  TXT_NAME_OF_FILE = 'Name of Calibration File';
  TXT_SELECT_FILE = 'Select a Calibration File';
  TXT_FILE_FILTER = 'Data files (*.DAT)|*.DAT|All files|*.*';


procedure TCalibDataForm.FormCreate(Sender: TObject);
//-----------------------------------------------------------------------------
// OnCreate handler. Loads current calibration file names into the
// form's grid control.
//-----------------------------------------------------------------------------
var
  I: Integer;

begin
// Set font size and default file directory
  Uglobals.SetFont(self);
  FileDir := ProjectDir;

// Initialize the grid control
  with StringGrid1 do
  begin
    RowCount := High(CalibData) + 1;
    ColWidths[1] := ClientWidth - ColWidths[0];
    ClientHeight := (DefaultRowHeight+1)*(RowCount);

    Cells[0,0] := TXT_PARAMETER;
    for I := 1 to RowCount-1 do
    begin
      Cells[0,I] := Uglobals.CalibVariables[I];
    end;

    Cells[1,0] := TXT_NAME_OF_FILE;
    for I := 1 to RowCount-1 do
    begin
      Cells[1,I] := CalibData[I].FileName;
    end;
  end;
end;

procedure TCalibDataForm.BtnBrowseClick(Sender: TObject);
//-----------------------------------------------------------------------------
// OnClick handler for "Browse" button. Uses the MainForm's
// OpenTextFileDialog control to obtain the name of a calibration file.
//-----------------------------------------------------------------------------
var
  InitDir: String;
begin
  with StringGrid1 do InitDir := ExtractFileDir(Cells[Col,Row]);
  if Length(InitDir) = 0 then InitDir := ProjectDir;
  with MainForm.OpenTextFileDialog do
  begin
    Title := TXT_SELECT_FILE;
    Filter := TXT_FILE_FILTER;
    InitialDir := InitDir;
    Filename := '*.dat';
    if Execute then
    begin
      with StringGrid1 do Cells[Col,Row] := Filename;
      FileDir := ExtractFileDir(Filename);
    end;
  end;
end;

procedure TCalibDataForm.BtnEditClick(Sender: TObject);
//-----------------------------------------------------------------------------
// OnClick handler for "Edit" button. Launches Windows NotePad editor for
// the file in current cell of grid control.
//-----------------------------------------------------------------------------
var
  fname: String;
  CmdLine: AnsiString;

begin
  with StringGrid1 do fname := Cells[1,Row];
  if Length(fname) > 0 then
  begin
    CmdLine := AnsiString('Notepad ' + fname);
    WinExec(PAnsiChar(CmdLine),SW_SHOWNORMAL);
  end;
end;

procedure TCalibDataForm.BtnOKClick(Sender: TObject);
//-----------------------------------------------------------------------------
// OnClick handler for "OK" button. Updates names of project's calibration
// files with the entries in the grid control.
//-----------------------------------------------------------------------------
var
  I  : Integer;
  S  : String;
begin
  for I := 1 to StringGrid1.RowCount-1 do
  begin
    S := Trim(StringGrid1.Cells[1,I]);
    if (CalibData[I].FileName <> S) then
    begin
      CalibData[I].FileName := S;
      HasChanged := True;
    end;
  end;
end;

procedure TCalibDataForm.BtnHelpClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT, 209960);
end;

procedure TCalibDataForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_F1 then BtnHelpClick(Sender);
end;

end.
