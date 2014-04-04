unit Fstatus;

{-------------------------------------------------------------------}
{                    Unit:    Fstatus.pas                           }
{                    Project: EPA SWMM                              }
{                    Version: 5.1                                   }
{                    Date:    11/12/13    (5.1.001)                 }
{                             03/28/14    (5.1.002)                 }
{                    Author:  L. Rossman                            }
{                                                                   }
{   MDI child form that displays the status report generated        }
{   from a run of SWMM.                                             }
{                                                                   }
{-------------------------------------------------------------------}

interface

uses
  SysUtils, Types, Messages, Classes, Graphics, Controls, Windows,
  Forms, Dialogs, StdCtrls, ComCtrls, Clipbrd, Menus, StrUtils, ExtCtrls,
  Xprinter, Uglobals, Uutils;

type
  TStatusForm = class(TForm)
    Memo1: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    //plrm edit procedure RefreshStatusReport;
    procedure RefreshStatusReport;overload;
    procedure RefreshStatusReport(prlmRptFilePath:String);overload;

    procedure ClearReport;
    procedure CopyTo;
    procedure Print(Destination: TDestination);
  end;

var
  StatusForm: TStatusForm;        // Do not comment out this line.
   PLRMTopicPos: array[0..19] of LongInt;                 //PLRM Addition

implementation

{$R *.DFM}

uses
  Dcopy, Fmain, GSUtils; //PLRM edit

const
  MSG_NO_FILE = 'There is no Report File to view.';
  MSG_REPORT_TOO_BIG = 'Status Report too big to fit in window.';

    PLRMTopics: array[0..3] of String =                           //PLRM addition
    ('Global Information',
     'Catchments',
     'Storm Water Treatment',
     'Scenario Summary');


procedure TStatusForm.FormClose(Sender: TObject; var Action: TCloseAction);
//-----------------------------------------------------------------------------
// OnClose handler for form.
//-----------------------------------------------------------------------------
begin
  Action := caFree;
  isPLRMStatusReportActive := false; //PLRM edit
end;

procedure TStatusForm.RefreshStatusReport;
//-----------------------------------------------------------------------------
// Reloads the form with the contents
// of the Status Report File generated from an analysis.
//-----------------------------------------------------------------------------
var
  Line : String;
  F : TextFile;
  Skip: Boolean;
begin
  // Clear report's contents
  Memo1.Clear;

  // Make sure that the report file exists
  if not FileExists(TempReportFile)
  then Memo1.Lines.Add(MSG_NO_FILE)
  else
  begin
    AssignFile(F, TempReportFile);
    Skip := False;
    try
      {$I-}
      Reset(F);
      {$I+}
      Memo1.Lines.BeginUpdate;
      while not Eof(F) do
      begin
        Readln(F, Line);
        if Skip = False then
        begin
          if  (ContainsText(Line, 'Subcatchment Runoff'))
          or (ContainsText(Line, 'Node Depth'))
          then Skip := True;
        end
        else if ContainsText(Line, 'Analysis begun')
        then Skip := False;
        if not Skip then   Memo1.Lines.Add(Line);
      end;
    finally
      Memo1.Lines.EndUpdate;
      CloseFile(F);
    end;
    Memo1.SelStart := 0;
  end;
end;

//plrm 2014 update of previous plrm procedure
procedure TStatusForm.RefreshStatusReport(prlmRptFilePath:String);
//-----------------------------------------------------------------------------
// Reloads the form with the contents
// of the Status Report File generated from an analysis.
//-----------------------------------------------------------------------------
var
  Line : String;
  F : TextFile;
  Skip: Boolean;
begin
  // Clear report's contents
  Memo1.Clear;

  // Make sure that the report file exists
  if not FileExists(prlmRptFilePath)
  then Memo1.Lines.Add(MSG_NO_FILE)
  else
  begin
    AssignFile(F, prlmRptFilePath);
    Skip := False;
    try
      {$I-}
      Reset(F);
      {$I+}
      Memo1.Lines.BeginUpdate;
      while not Eof(F) do
      begin
        Readln(F, Line);
        if Skip = False then
        begin
          if  (ContainsText(Line, 'Subcatchment Runoff'))
          or (ContainsText(Line, 'Node Depth'))
          then Skip := True;
        end
        else if ContainsText(Line, 'Analysis begun')
        then Skip := False;
        if not Skip then   Memo1.Lines.Add(Line);
      end;
    finally
      Memo1.Lines.EndUpdate;
      CloseFile(F);
    end;
    Memo1.SelStart := 0;
  end;
end;

procedure TStatusForm.ClearReport;
begin
  Memo1.Clear;
end;

procedure TStatusForm.CopyTo;
//-----------------------------------------------------------------------------
// Copies contents of the FileViewer to either a file or to the Clipboard.
//-----------------------------------------------------------------------------
var
  copyToForm : TCopyToForm;
begin
  // Create the CopyTo dialog form
  copyToForm := TCopyToForm.Create(self);
  with copyToForm do
  try

    // Disable format selection (since it has to be Text)
    FormatGroup.ItemIndex := 2;
    FormatGroup.Enabled := False;

    // Show the form modally
    if ShowModal = mrOK then
    begin

      // If user supplies a file name then copy report to it
      if Length(DestFileName) > 0
      then Memo1.Lines.SaveToFile(DestFileName)

      // Otherwise copy the contents into the Clipboard
      else Memo1.CopyToClipboard;
    end;

  // Free the CopyTo dialog form
  finally
    copyToForm.Free;
  end;
end;

procedure TStatusForm.Print(Destination: TDestination);
//-----------------------------------------------------------------------------
// Prints Status Report to Destination (printer or preview form).
//-----------------------------------------------------------------------------
var
//  I    : Integer;
//  S    : array[0..1024] of WideChar;
  Line : String;
  F : TextFile;
begin
  with MainForm.thePrinter do
  begin
    BeginJob;
    try
      SetDestination(Destination);
      AssignFile(F, TempReportFile);
      try
        {$I-}
        Reset(F);
        {$I+}
        while not Eof(F) do
        begin
          Readln(F, Line);
          PrintLine(Line);
        end;
      finally
        CloseFile(F);
      end;
    finally
      EndJob;
    end;
  end;
end;

end.
