unit Dxsect;

{-------------------------------------------------------------------}
{                    Unit:    Dxsect.pas                            }
{                    Project: EPA SWMM                              }
{                    Version: 5.1                                   }
{                    Date:    12/2/13    (5.1.000)                  }
{                    Author:  L. Rossman                            }
{                                                                   }
{   Dialog form unit used to edit cross-sectional geometry for      }
{   a conduit.                                                      }
{-------------------------------------------------------------------}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, NumEdit, ImgList, Spin, Buttons, ComCtrls,
  Uproject, Uglobals;

type
  TXsectShape = record
    Text : array[1..4] of String;
  end;

const
  MAX_SHAPE_INDEX = 24;
  CUSTOM_SHAPE_INDEX = 23;
  IRREG_SHAPE_INDEX = 5;
  HORIZ_ELLIPSE_SHAPE_INDEX = 10;
  VERT_ELLIPSE_SHAPE_INDEX = 11;
  ARCH_SHAPE_INDEX = 12;
  TRAPEZOIDAL_SHAPE_INDEX = 1;
  CIRC_SHAPE_INDEX = 6;
  FORCE_MAIN_INDEX = 7;
  MODBASKET_SHAPE_INDEX = 15;
  RECTANGULAR_SHAPE_INDEX = 0;

  // This is the list of cross-sectional shapes that are available
  ShapeNames: array[0..MAX_SHAPE_INDEX] of String =
  ('Rectangular', 'Trapezoidal', 'Triangular', 'Parabolic', 'Power',
   'Irregular', 'Circular', 'Force Main', 'Filled Circular',
   'Closed Rectangular', 'Horizontal Elliptical', 'Vertical Elliptical',
   'Arch', 'Rectangular Triangular', 'Rectangular Round', 'Modified Baskethandle',
   'Egg', 'Horseshoe', 'Gothic', 'Catenary', 'Semi-Elliptical', 'Baskethandle',
   'Semi-Circular', 'Custom', 'Dummy');

  XsectShapes: array[0..MAX_SHAPE_INDEX] of TXsectShape =
    (
     (Text: ('RECT_OPEN', 'Bottom Width', '', '')),
     (Text: ('TRAPEZOIDAL', 'Bottom Width', 'Left Slope', 'Right Slope')),
     (Text: ('TRIANGULAR', 'Top Width', '', '')),
     (Text: ('PARABOLIC', 'Top Width', '', '')),
     (Text: ('POWER', 'Top Width', 'Exponent', '')),
     (Text: ('IRREGULAR', '', '', '')),
     (Text: ('CIRCULAR', '', '', '')),
     (Text: ('FORCE_MAIN', 'Roughness*', '', '')),
     (Text: ('FILLED_CIRCULAR', 'Filled Depth', '', '')),
     (Text: ('RECT_CLOSED', 'Bottom Width', '', '')),
     (Text: ('HORIZ_ELLIPSE', 'Max. Width', '', '')),
     (Text: ('VERT_ELLIPSE', 'Max. Width', '', '')),
     (Text: ('ARCH', 'Max. Width', '', '')),
     (Text: ('RECT_TRIANGULAR', 'Top Width', 'Triangle Height', '')),
     (Text: ('RECT_ROUND', 'Top Width', 'Bottom Radius', '')),
     (Text: ('MODBASKETHANDLE', 'Bottom Width', 'Top Radius', '')),
     (Text: ('EGG', '', '', '')),
     (Text: ('HORSESHOE', '', '', '')),
     (Text: ('GOTHIC', '', '', '')),
     (Text: ('CATENARY', '', '', '')),
     (Text: ('SEMIELLIPTICAL', '', '', '')),
     (Text: ('BASKETHANDLE', '', '', '')),
     (Text: ('SEMICIRCULAR', '', '', '')),
     (Text: ('CUSTOM', '', '', '')),
     (Text: ('DUMMY', '', '', ''))
     );

  XsectNotes: array[0..MAX_SHAPE_INDEX] of String =
  (
   'Open rectangular channel. Sidewalls can be removed for 2-D modeling.',
   'Open trapezoidal channel. Slopes are horizontal / vertical.',
   'Open triangular channel.',
   'Open parabolic channel where depth varies with top width squared.',
   'Open channel where depth varies with top width to some power.',
   'Open irregular natural channel described by transect coordinates.',
   'Standard circular pipe.',
   'Circular pipe with a special friction loss equation for pressurized flow.',
   'Circular pipe partly filled with sediment.',
   'Closed rectangular box conduit.',
   'Closed horizontal elliptical pipe. For standard shapes, enter 0 for width.',
   'Closed vertical elliptical pipe. For standard shapes, enter 0 for width.',
   'Closed arch pipe. For standard shapes, enter code # for depth and 0 for width.',
   'Closed rectangular top with triangular bottom.',
   'Closed rectangular top with circular bottom.',
   'Rectangular bottom with closed circular top.',
   'Classic Phillips Standard Egg sewer shape.',
   'Classic Boston Horseshoe sewer shape.',
   'Classic Gothic sewer shape.',
   'Classic Catenary sewer shape (i.e., inverted egg).',
   'Classic Louisville Semi-Elliptical sewer shape.',
   'Classic Baskethandle sewer shape.',
   'Classic Semi-Circular sewer shape.',
   'Closed custom shape described by a user-supplied shape curve.',
   'There are no parameters associated with a dummy cross-section.');

type
  TXsectionForm = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    Label1: TLabel;
    NumEdit1: TNumEdit;
    Label2: TLabel;
    NumEdit2: TNumEdit;
    Label3: TLabel;
    NumEdit3: TNumEdit;
    Label4: TLabel;
    NumEdit4: TNumEdit;
    TsectCombo: TComboBox;
    BarrelsLabel: TLabel;
    TsectBtn: TBitBtn;
    BarrelsEdit: TEdit;
    BarrelsUpDown: TUpDown;
    TsectLabel: TLabel;
    DimenLabel: TLabel;
    UnitsLabel: TEdit;
    ForceMainNote: TLabel;
    ShapeListView: TListView;
    ImageList1: TImageList;
    SidewallsLabel: TLabel;
    SidewallsCombo: TComboBox;
    SpecialNote: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure NumEdit1Change(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure TsectBtnClick(Sender: TObject);
    procedure ShapeListViewChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    OldShapeIndex: Integer;
    function  ValidateData: Boolean;
    function  ValidateTextEntry(NumEdit: TNumEdit; const N: Integer;
              const I: Integer): Boolean;
  public
    { Public declarations }
    HasChanged: Boolean;
    procedure SetData(const Shape: String; const Geom1: String;
              const Geom2: String; const Geom3: String; const Geom4: String;
              const Barrels: String; const Tsect: String);
    procedure GetData(var Shape: String; var Geom1: String;
              var Geom2: String; var Geom3: String; var Geom4: String;
              var Barrels: String; var Tsect: String);
  end;

//var
//  XsectionForm: TXsectionForm;

implementation

{$R *.DFM}
{$R Xsects.res}

uses
  Uedit;

const
  MSG_BAD_DATA = 'Invalid data. Please re-enter a value.';
  TXT_TRANSECT_NOTE = 'Transect Name';
  TXT_CUSTOM_NOTE = 'Shape Curve Name';
  TXT_FEET = 'Feet';
  TXT_METERS = 'Meters';
  TXT_MAX_DEPTH = 'Max. Depth';
  TXT_INCHES = ' (in)';
  TXT_MMETERS = ' (mm)';
  TXT_C_FACTOR = '*Hazen-Williams C-factor';
  TXT_ROUGHNESS = '*Darcy-Weisbach roughness height';

var
  Created: Boolean;

procedure TXsectionForm.FormCreate(Sender: TObject);
//-----------------------------------------------------------------------------
// OnCreate handler for form.
//-----------------------------------------------------------------------------
var
  I: Integer;
  ListItem: TListItem;

begin
  // Load contents of ShapeListView
  Created := False;
  with ShapeListView do
  begin
    SmallImages := ImageList1;
    LargeImages := ImageList1;
    for I := 0 to ImageList1.Count - 1 do
    begin
      ListItem := Items.Add;
      Listitem.Caption := ShapeNames[I];
      ListItem.ImageIndex := I;
    end;
  end;
  Created := True;

  // Add transect names to TsectCombo box
  TsectCombo.Items := Project.Lists[TRANSECT];
  SpecialNote.Caption := '';

  // Position controls on the form
  TsectLabel.Left := NumEdit1.Left;
  TsectLabel.Top := Label1.Top;
  TsectLabel.Visible := False;

  TsectCombo.Left := TsectLabel.Left;
  TsectCombo.Top := NumEdit1.Top;
  TsectCombo.Visible := False;

  TsectBtn.Top := TsectCombo.Top;
  TsectBtn.Left := TsectCombo.Left + TsectCombo.Width;
  TsectBtn.Visible := False;

  ForceMainNote.Left := Label3.Left;
  ForceMainNote.Top := Label3.Top;
  //ForceMainNote.Width := SpecialNote.Width;
  ForceMainNote.Visible := False;

  SidewallsLabel.Left := Label3.Left;
  SidewallsLabel.Top := Label3.Top;
  SidewallsLabel.Visible := False;
  SidewallsCombo.Left := NumEdit3.Left;
  SidewallsCombo.Top := NumEdit3.Top;
  SidewallsCombo.Visible := False;

  // Assign text to units label
  with UnitsLabel do
  begin
    if Uglobals.UnitSystem = usUS
    then Text := TXT_FEET
    else Text := TXT_METERS;
  end;

  if SameText(Project.Options.Data[FORCE_MAIN_EQN_INDEX], 'H-W') then
    ForceMainNote.Caption := TXT_C_FACTOR
  else if Uglobals.UnitSystem = usUS
  then ForceMainNote.Caption := TXT_ROUGHNESS + TXT_INCHES
  else ForceMainNote.Caption := TXT_ROUGHNESS + TXT_MMETERS;
end;

procedure TXsectionForm.FormShow(Sender: TObject);
begin
    ShapeListView.Items[OldShapeIndex].MakeVisible(False);
    ShapeListView.SetFocus;
end;

procedure TXsectionForm.ShapeListViewChange(Sender: TObject;
  Item: TListItem; Change: TItemChange);
var
  I: Integer;
begin
    if not Created then Exit;
    I := ShapeListView.ItemIndex;
    SpecialNote.Caption := XsectNotes[I];

    // Asssign visibility & labels to the dimension edit controls
    TsectLabel.Visible := False;
    TsectCombo.Visible := False;
    TsectBtn.Visible := False;

    Label1.Caption := TXT_MAX_DEPTH;
    Label2.Caption := XsectShapes[I].Text[2];
    Label3.Caption := XsectShapes[I].Text[3];
    Label4.Caption := XsectShapes[I].Text[4];
    NumEdit1.Visible := True;
    NumEdit2.Visible := (Length(XsectShapes[I].Text[2]) > 0);
    NumEdit3.Visible := (Length(XsectShapes[I].Text[3]) > 0);
    NumEdit4.Visible := (Length(XsectShapes[I].Text[4]) > 0);
    ForceMainNote.Visible := False;
    SidewallsLabel.Visible := False;
    SidewallsCombo.Visible := False;

    // Special case for Irregular cross sections
    if I = IRREG_SHAPE_INDEX then
    begin
      NumEdit1.Visible := False;
      TsectCombo.Items := Project.Lists[TRANSECT];
      TsectLabel.Top := BarrelsLabel.Top;
      TsectCombo.Top := BarrelsEdit.Top;
      TsectBtn.Top := TsectCombo.Top;
      TsectLabel.Caption := TXT_TRANSECT_NOTE;
      TsectLabel.Visible := True;
      TsectCombo.Visible := True;
      TsectBtn.Visible := True;
    end;

    // Special case for Custom shape
    if I = CUSTOM_SHAPE_INDEX then
    begin
      TsectCombo.Items := Project.Lists[SHAPECURVE];
      TsectLabel.Top := Label3.Top;
      TsectCombo.Top := NumEdit3.Top;
      TsectBtn.Top := TsectCombo.Top;
      TsectLabel.Caption := TXT_CUSTOM_NOTE;
      TsectLabel.Visible := True;
      TsectCombo.Visible := True;
      TsectBtn.Visible := True;
    end;

    // Special case for Force Main shape
    if I = FORCE_MAIN_INDEX then
    begin
      ForceMainNote.Visible := True;
    end;

    // Special case for Open Rectangular shape
    if I = RECTANGULAR_SHAPE_INDEX then
    begin
      NumEdit3.Visible := False;
      SidewallsLabel.Visible := True;
      SidewallsCombo.Visible := True;
    end;

    if I = MAX_SHAPE_INDEX then
    begin
      Label1.Caption := '';
      NumEdit1.Visible := False;
    end;

    Label1.Visible := NumEdit1.Visible;
    Label3.Visible := NumEdit3.Visible;
    UnitsLabel.Visible := NumEdit1.Visible and BarrelsEdit.Enabled;
    DimenLabel.Visible := UnitsLabel.Visible;
    BarrelsLabel.Visible := NumEdit1.Visible;
    BarrelsEdit.Visible := NumEdit1.Visible;
    BarrelsUpDown.Visible := NumEdit1.Visible;
end;

procedure TXsectionForm.SetData(const Shape: String; const Geom1: String;
  const Geom2: String; const Geom3: String; const Geom4: String;
  const Barrels: String; const Tsect: String);
//-----------------------------------------------------------------------------
//  Loads a given set of cross-section parameters into the form.
//  Shape = name of cross section shape,
//  Geom1 .. Geom4 = shape's dimensional parameters
//  Barrels = number of barrels
//  Tsect = name of transect object for irregular shapes
//-----------------------------------------------------------------------------
var
  I         : Integer;
  K         : Integer;
  MaxShapes : Integer;
  S         : String;
begin
  // If Barrels string empty, then form is being used to set defaults
  if Length(Barrels) = 0 then
  begin
    BarrelsEdit.Enabled := False;
    BarrelsUpDown.Enabled := False;
    MaxShapes := CUSTOM_SHAPE_INDEX - 1;
  end
  else
  begin
    MaxShapes := MAX_SHAPE_INDEX;
    try
      I := StrToInt(Barrels);
    except
      On EConvertError do I := 1;
    end;
    if I >= 1 then BarrelsUpDown.Position := I;
  end;

  // Add remaining parameters to form
  S := Shape;
  TsectCombo.Text := Tsect;
  NumEdit1.Text := Geom1;
  NumEdit2.Text := Geom2;
  NumEdit3.Text := Geom3;
  NumEdit4.Text := Geom4;

  // Find index of current shape in shape list view
  I := -1;
  for K := 0 to MaxShapes do
  begin
    if SameText(S, XsectShapes[K].Text[1]) then
    begin
      I := K;
      break;
    end;
  end;
  if I = RECTANGULAR_SHAPE_INDEX then
  begin
    SidewallsCombo.ItemIndex := StrToIntDef(Geom3, 0);
  end;
  if I >= 0 then
  begin
    ShapeListView.Selected := ShapeListView.Items[I];
  end;
  HasChanged := False;
  OldShapeIndex := I;
end;

procedure TXsectionForm.GetData(var Shape: String; var Geom1: String;
  var Geom2: String; var Geom3: String; var Geom4: String;
  var Barrels: String; var Tsect: String);
//-----------------------------------------------------------------------------
//  Retrieves cross-section parameters from the form.
//-----------------------------------------------------------------------------
var
  I: Integer;
  K: Integer;
begin
  K := ShapeListView.ItemIndex;
  Shape := XsectShapes[K].Text[1];
  if NumEdit2.Visible then Geom2 := NumEdit2.Text else Geom2 := '0';
  if NumEdit3.Visible then Geom3 := NumEdit3.Text else Geom3 := '0';
  if NumEdit4.Visible then Geom4 := NumEdit4.Text else Geom4 := '0';

  if K = IRREG_SHAPE_INDEX then
  begin
    Geom1 := 'N/A';
    Barrels := '1';
    Tsect := TsectCombo.Text;
    I := Project.Lists[TRANSECT].IndexOf(Tsect);
    if I >= 0
    then Geom1 := TTransect(Project.Lists[TRANSECT].Objects[I]).Data[TRANSECT_MAX_DEPTH];
  end

  else if K = CUSTOM_SHAPE_INDEX then
  begin
    Geom1 := NumEdit1.Text;
    Geom2 := TsectCombo.Text;
    Barrels := IntToStr(BarrelsUpDown.Position);
    Tsect := TsectCombo.Text;
  end

  else if K = RECTANGULAR_SHAPE_INDEX then
  begin
    Geom3 := IntToStr(SidewallsCombo.ItemIndex);
  end

  else if K = MAX_SHAPE_INDEX then
  begin
    Geom1 := '0';
    Barrels := '1';
    Tsect := '';
  end

  else
  begin
    Geom1 := NumEdit1.Text;
    Barrels := IntToStr(BarrelsUpDown.Position);
    Tsect := '';
  end;
  if K <> OldShapeIndex then HasChanged := True;
end;

procedure TXsectionForm.NumEdit1Change(Sender: TObject);
//-----------------------------------------------------------------------------
// OnChange handler for all 4 NumEdit controls as well as the TsectCombo
// control.
//-----------------------------------------------------------------------------
begin
  HasChanged := True;
end;

procedure TXsectionForm.OKBtnClick(Sender: TObject);
//-----------------------------------------------------------------------------
// OnClick handler for the OK button.
//-----------------------------------------------------------------------------
begin
  if ValidateData then ModalResult := mrOK;
end;

function  TXsectionForm.ValidateData: Boolean;
//-----------------------------------------------------------------------------
// Validates data entries on the form.
//-----------------------------------------------------------------------------
var
  I: Integer;
begin
  Result := True;
  I := ShapeListView.ItemIndex;
  if NumEdit1.Visible then Result := Result and ValidateTextEntry(NumEdit1, 1, I);
  if NumEdit2.Visible then Result := Result and ValidateTextEntry(NumEdit2, 2, I);
  if NumEdit3.Visible then Result := Result and ValidateTextEntry(NumEdit3, 3, I);
  if NumEdit4.Visible then Result := Result and ValidateTextEntry(NumEdit4, 4, I);
end;

function  TXsectionForm.ValidateTextEntry(NumEdit: TNumEdit; const N: Integer;
  const I: Integer): Boolean;
//-----------------------------------------------------------------------------
// Validates the entry made in a NumEdit control for a given shape.
//-----------------------------------------------------------------------------
var
  X: Single;
begin
  // Assume entry is 0 if edit control is blank
  Result := True;
  if Length(NumEdit.Text) = 0 then NumEdit.Text := '0';

  // Convert the string to a number
  X := StrToFloat(Trim(NumEdit.Text));

  // If the number is 0, then check if the type of shape permits it
  if (X = 0) then
  begin
    if (N = 2)
    and (I in [CIRC_SHAPE_INDEX, TRAPEZOIDAL_SHAPE_INDEX,
               HORIZ_ELLIPSE_SHAPE_INDEX, VERT_ELLIPSE_SHAPE_INDEX,
               ARCH_SHAPE_INDEX])
    then Exit;

    if (N = 3) and (I = MODBASKET_SHAPE_INDEX) then Exit;

    // Otherwise issue an error message
    MessageDlg(MSG_BAD_DATA, mtError, [mbOK], 0);
    if NumEdit.Visible then NumEdit.SetFocus;
    Result := False;
  end;
end;

procedure TXsectionForm.TsectBtnClick(Sender: TObject);
//-----------------------------------------------------------------------------
// OnClick handler for the TSectBtn control. Launches the Transect Editor
// dialog for the transect named in the TsectCombo box.
//-----------------------------------------------------------------------------
var
  I: Integer;
  S: String;
begin
  S := Trim(TsectCombo.Text);

  if ShapeListView.ItemIndex = CUSTOM_SHAPE_INDEX then
  begin
    I := Project.Lists[SHAPECURVE].IndexOf(S);
    S := Uedit.EditCurve(SHAPECURVE, I);
    if Length(S) > 0 then
    begin
      TsectCombo.Text := S;
      TsectCombo.Items := Project.Lists[SHAPECURVE];
    end;
    Exit;
  end;

  I := Project.Lists[TRANSECT].IndexOf(S);
  S := Uedit.EditTransect(I);
  if Length(S) > 0 then
  begin
      TsectCombo.Text := S;
      TsectCombo.Items := Project.Lists[TRANSECT];
  end;
end;

procedure TXsectionForm.HelpBtnClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT, 211450);
end;

end.
