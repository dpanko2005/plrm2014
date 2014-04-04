unit Dinfil;

{-------------------------------------------------------------------}
{                    Unit:    Dinfil.pas                            }
{                    Project: EPA SWMM                              }
{                    Version: 5.1                                   }
{                    Date:    12/2/13     (5.1.000)                 }
{                    Author:  L. Rossman                            }
{                                                                   }
{   Dialog form unit for editing subcatchment infiltration          }
{   parameters.                                                     }
{-------------------------------------------------------------------}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Uglobals, Uproject, PropEdit;

type
  TInfilForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ComboBox1: TComboBox;
    Panel3: TPanel;
    OKBtn: TButton;
    CancleBtn: TButton;
    HelpBtn: TButton;
    Panel4: TPanel;
    HintLabel: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
  private
    { Private declarations }
    InfilModel: Integer;
    PropEdit1: TPropEdit;
    PropList: TStringlist;
    procedure ShowPropertyHint(Sender: TObject; aRow: LongInt);
  public
    { Public declarations }
    HasChanged: Boolean;
    procedure SetData(InfilData: array of String; const SetInfilModel: Boolean);
    procedure GetData(var InfilData: array of String);
    procedure SetInfilModel(const S: String);
    procedure GetInfilModelName(var S: String);
  end;

//var
//  InfilForm: TInfilForm;

implementation

{$R *.DFM}

const
  TXT_PROPERTY = 'Property';
  TXT_VALUE = 'Value';

  HortonProps: array[0..4] of TPropRecord =
  (
   (Name:'Max. Infil. Rate';  Style: esEdit;  Mask: emPosNumber;  Length: 0),
   (Name:'Min. Infil. Rate';  Style: esEdit;  Mask: emPosNumber;  Length: 0),
   (Name:'Decay Constant';    Style: esEdit;  Mask: emPosNumber;  Length: 0),
   (Name:'Drying Time';       Style: esEdit;  Mask: emPosNumber;  Length: 0),
   (Name:'Max. Volume';       Style: esEdit;  Mask: emPosNumber;  Length: 0)
  );

  GreenAmptProps: array[0..2] of TPropRecord =
  (
    (Name:'Suction Head';    Style: esEdit;  Mask: emPosNumber;  Length: 0),
    (Name:'Conductivity';    Style: esEdit;  Mask: emPosNumber;  Length: 0),
    (Name:'Initial Deficit'; Style: esEdit;  Mask: emPosNumber;  Length: 0)
  );

  CurveNumProps: array[0..2] of TPropRecord =
  (
    (Name:'Curve Number';        Style: esEdit;  Mask: emPosNumber;  Length: 0),
    (Name:'Conductivity';        Style: esHeading; Mask: emNone;     Length: 0),
    (Name:'Drying Time';         Style: esEdit;  Mask: emPosNumber;  Length: 0)
  );

  HortonHint: array[0..4] of String =
  ('Maximum rate on the Horton infiltration curve (in/hr or mm/hr)',
   'Minimum rate on the Horton infiltration curve (in/hr or mm/hr)',
   'Decay constant for the Horton infiltration curve (1/hr)',
   'Time for a fully saturated soil to completely dry (days)',
   'Maximum infiltration volume possible (inches or mm, 0 if not applicable)');

  GreenAmptHint: array[0..2] of String =
  ('Soil capillary suction head (inches or mm)',
   'Soil saturated hydraulic conductivity (in/hr or mm/hr)',
   'Initial soil moisture deficit (a fraction)');

  CurveNumHint: array[0..2] of String =
  ('SCS runoff curve number',
   'This property has been deprecated and its value is ignored.',
   'Time for a fully saturated soil to completely dry (days)');

procedure TInfilForm.FormCreate(Sender: TObject);
//-----------------------------------------------------------------------------
//  Form's OnCreate handler.
//-----------------------------------------------------------------------------
var
  I: Integer;
begin
  // Set font and caption
  Uglobals.SetFont(self);

  // Load infiltration options into Combo Box
  for I := 0 to High(InfilOptions) do
    ComboBox1.Items.Add(InfilOptions[I]);

  // Create Property Editor
  PropEdit1 := TPropEdit.Create(self);
  with PropEdit1 do
  begin
    Parent := Panel1;
    Align := alClient;
    BorderStyle := bsNone;
    Left := 1;
    Top := 1;
    ColHeading1 := TXT_PROPERTY;
    ColHeading2 := TXT_VALUE;
    ValueColor := clNavy;
    OnRowSelect := ShowPropertyHint;
  end;

  // Create Property stringlist
  PropList := TStringlist.Create;
  HasChanged := False;
end;

procedure TInfilForm.FormDestroy(Sender: TObject);
//-----------------------------------------------------------------------------
//  Form's OnDestroy handler.
//-----------------------------------------------------------------------------
begin
  PropList.Free;
  PropEdit1.Free;
end;

procedure TInfilForm.FormShow(Sender: TObject);
//-----------------------------------------------------------------------------
//  Form's OnShow handler.
//-----------------------------------------------------------------------------
begin
  case InfilModel of
  0: PropEdit1.SetProps(HortonProps, PropList);
  1: PropEdit1.SetProps(HortonProps, PropList);
  2: PropEdit1.SetProps(GreenAmptProps, PropList);
  3: PropEdit1.SetProps(CurveNumProps, PropList);
  end;
  PropEdit1.Edit;
end;

procedure TInfilForm.ComboBox1Change(Sender: TObject);
//-----------------------------------------------------------------------------
//  OnChange handler for ComboBox1.
//-----------------------------------------------------------------------------
begin
  InfilModel := ComboBox1.ItemIndex;
  PropList.Clear;
  case InfilModel of
  0: SetData(Uproject.DefHortonInfil, True);
  1: SetData(Uproject.DefHortonInfil, True);
  2: SetData(Uproject.DefGreenAmptInfil, True);
  3: SetData(Uproject.DefCurveNumInfil, True);
  end;
  FormShow(Sender);
end;

procedure TInfilForm.SetInfilModel(const S: String);
//-----------------------------------------------------------------------------
//  Determines which Infiltration model is represented by string S.
//-----------------------------------------------------------------------------
var
  I: Integer;
begin
  InfilModel := -1;
  for I := 0 to High(InfilOptions) do
  begin
    if SameText(S, InfilOptions[I]) then InfilModel := I;
  end;
  ComboBox1.ItemIndex := InfilModel;
end;

procedure TInfilForm.SetData(InfilData: array of String;
  const SetInfilModel: Boolean);
//-----------------------------------------------------------------------------
//  Loads a set of infiltration parameters into the form.
//-----------------------------------------------------------------------------
var
  N: Integer;
  J: Integer;
begin
  ComboBox1.Enabled := SetInfilModel;
  N := -1;
  case InfilModel of
  0: N := High(HortonProps);
  1: N := High(HortonProps);
  2: N := High(GreenAmptProps);
  3: N := High(CurveNumProps);
  end;
  for J := 0 to N do PropList.Add(InfilData[J]);
end;

procedure TInfilForm.GetData(var InfilData: array of String);
//-----------------------------------------------------------------------------
//  Retrieves a set of infiltration parameters from the form.
//-----------------------------------------------------------------------------
var
  J: Integer;
begin
  for J := 0 to PropList.Count-1 do
  begin
   if Length(Trim(PropList[J])) > 0 then InfilData[J] := PropList[J];
  end;
  if not HasChanged then HasChanged := PropEdit1.Modified;
end;

procedure TInfilForm.GetInfilModelName(var S: String);
//-----------------------------------------------------------------------------
//  Retrieves the type of infiltration model selected from the form.
//-----------------------------------------------------------------------------
begin
  S := ComboBox1.Text;
end;

procedure TInfilForm.ShowPropertyHint(Sender: TObject; aRow: LongInt);
//-----------------------------------------------------------------------------
//  OnRowSelect handler assigned to the PropEdit control. Selects the
//  appropriate hint text to display when a new infiltration property
//  is selected.
//-----------------------------------------------------------------------------
var
  S: String;
begin
  case InfilModel of
  0: S := HortonHint[aRow];
  1: S := HortonHint[aRow];
  2: S := GreenAmptHint[aRow];
  3: S := CurveNumHint[aRow];
  end;
  HintLabel.Caption := S;
end;

procedure TInfilForm.OKBtnClick(Sender: TObject);
//-----------------------------------------------------------------------------
//  OnClick handler for the OK button.
//-----------------------------------------------------------------------------
begin
  PropEdit1.IsValid;
end;

procedure TInfilForm.HelpBtnClick(Sender: TObject);
begin
  case InfilModel of
  0: Application.HelpCommand(HELP_CONTEXT, 212690);
  1: Application.HelpCommand(HELP_CONTEXT, 212690);
  2: Application.HelpCommand(HELP_CONTEXT, 212700);
  3: Application.HelpCommand(HELP_CONTEXT, 212710);
  end;
end;

end.
