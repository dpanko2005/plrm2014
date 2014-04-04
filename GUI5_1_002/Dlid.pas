unit Dlid;

{-------------------------------------------------------------------}
{                    Unit:    Dlid.pas                              }
{                    Project: EPA SWMM                              }
{                    Version: 5.1                                   }
{                    Date:    12/2/13        (5.1.000)              }
{                    Author:  L. Rossman                            }
{                                                                   }
{   Dialog form unit that describes the design of a generic LID     }
{   control that can be re-used throughout the study area.          }
{                                                                   }
{   This form was re-designed for release 5.0.023.                  }
{-------------------------------------------------------------------}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, NumEdit, ComCtrls, Uproject, Uglobals, Ulid, ExtCtrls;

type
  TLidControlDlg = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    NameEdit: TNumEdit;
    TypeCombo: TComboBox;
    OkBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    ImageBook: TNotebook;
    BioCellImage: TImage;
    RainGardenImage: TImage;
    GreenRoofImage: TImage;
    InfilTrenchImage: TImage;
    PermPaveImage: TImage;
    RainBarrelImage: TImage;
    VegSwaleImage: TImage;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    SlopeLabel1: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    SlopeLabel2: TLabel;
    Label34: TLabel;
    SurfaceEdit1: TNumEdit;
    SurfaceEdit2: TNumEdit;
    SurfaceEdit3: TNumEdit;
    SurfaceEdit4: TNumEdit;
    SurfaceEdit5: TNumEdit;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label12: TLabel;
    Label40: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    PavementEdit1: TNumEdit;
    PavementEdit2: TNumEdit;
    PavementEdit3: TNumEdit;
    PavementEdit4: TNumEdit;
    PavementEdit5: TNumEdit;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label6: TLabel;
    Label11: TLabel;
    SoilEdit1: TNumEdit;
    SoilEdit2: TNumEdit;
    SoilEdit3: TNumEdit;
    SoilEdit4: TNumEdit;
    SoilEdit5: TNumEdit;
    SoilEdit6: TNumEdit;
    SoilEdit7: TNumEdit;
    StorageHeightLabel: TLabel;
    Label9: TLabel;
    StorageEdit1: TNumEdit;
    StoragePanel: TPanel;
    StorageVoidLabel: TLabel;
    Label15: TLabel;
    Label33: TLabel;
    Label41: TLabel;
    Label45: TLabel;
    StorageEdit2: TNumEdit;
    StorageEdit3: TNumEdit;
    StorageEdit4: TNumEdit;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label39: TLabel;
    DrainDelayLabel: TLabel;
    HoursLabel: TLabel;
    Label47: TLabel;
    DrainEdit1: TNumEdit;
    DrainEdit2: TNumEdit;
    DrainEdit3: TNumEdit;
    DrainDelayEdit: TNumEdit;
    Label3: TLabel;
    Label46: TLabel;
    Label48: TLabel;
    Label49: TLabel;
    Label50: TLabel;
    DrainMatEdit1: TNumEdit;
    DrainMatEdit2: TNumEdit;
    DrainMatEdit3: TNumEdit;
    procedure FormCreate(Sender: TObject);
    procedure NameEditChange(Sender: TObject);
    procedure NumEditExit(Sender: TObject);
    procedure TypeComboClick(Sender: TObject);
    procedure OkBtnClick(Sender: TObject);
    procedure HelpBtnClick(Sender: TObject);
  private
    { Private declarations }
    LidIndex: Integer;
  public
    { Public declarations }
    Modified: Boolean;
    procedure SetData(const Index: Integer; aLID: TLid);
    procedure GetData(var S: String; aLID: TLid);
  end;

//var
//  LidControlDlg: TLidControlDlg;

implementation

{$R *.dfm}

procedure TLidControlDlg.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  // Set font size
  Uglobals.SetFont(self);

  // Add process types to ProcessCombo
  for I := 0 to High(Ulid.ProcessTypesLong) do
    TypeCombo.Items.Add(Ulid.ProcessTypesLong[I]);
  TypeCombo.ItemIndex := 0;
  Modified := False;
end;

procedure TLidControlDlg.SetData(const Index: Integer; aLID: TLid);
var
  I: Integer;
begin
  LidIndex := Index;

  // Place the name of existing LID object in the NameEdit control
  if Index >= 0
  then NameEdit.Text := Project.Lists[LID].Strings[Index];

  // Place LID Process Type in the ProcessCombo control
  TypeCombo.ItemIndex := aLID.ProcessType;
  ImageBook.PageIndex := TypeCombo.ItemIndex;

  // Fill the layer tab sheets with data
  for I := 1 to 5 do
    with FindComponent('SurfaceEdit' + IntToStr(I)) as TNumEdit do
      Text := aLID.SurfaceLayer[I-1];

  for I := 1 to 5 do
    with FindComponent('PavementEdit' + IntToStr(I)) as TNumEdit do
      Text := aLID.PavementLayer[I-1];

  for I := 1 to 7 do
    with FindComponent('SoilEdit' + IntToStr(I)) as TNumEdit do
      Text := aLID.SoilLayer[I-1];

  for I := 1 to 4 do
    with FindComponent('StorageEdit' + IntToStr(I)) as TNumEdit do
      Text := aLID.StorageLayer[I-1];

  for I := 1 to 3 do
    with FindComponent('DrainEdit' + IntToStr(I)) as TNumEdit do
      Text := aLID.DrainLayer[I-1];
  DrainDelayEdit.Text := aLid.DrainLayer[3];

  for I := 1 to 3 do
    with FindComponent('DrainMatEdit' + IntToStr(I)) as TNumEdit do
      Text := aLID.DrainMatLayer[I-1];

  // Display the correct tab sheets for the current process type
  TypeComboClick(self);
end;

procedure TLidControlDlg.GetData(var S: String; aLID: TLid);
var
  I: Integer;
begin
  // Retrieve the name of the LID from the Name edit control
  S := Trim(NameEdit.Text);

  // Retrieve the process type
  aLID.ProcessType := TypeCombo.ItemIndex;

  // Retrieve data for each layer
  if TabSheet1.TabVisible then
    for I := 1 to 5 do
      with FindComponent('SurfaceEdit' + IntToStr(I)) as TNumEdit do
        aLID.SurfaceLayer[I-1] := Text;

  if TabSheet2.TabVisible then
    for I := 1 to 5 do
      with FindComponent('PavementEdit' + IntToStr(I)) as TNumEdit do
        aLID.PavementLayer[I-1] := Text;

  if TabSheet3.TabVisible then
    for I := 1 to 7 do
      with FindComponent('SoilEdit' + IntToStr(I)) as TNumEdit do
        aLID.SoilLayer[I-1] := Text;

  if TabSheet4.TabVisible then
  begin
    for I := 1 to 4 do
      with FindComponent('StorageEdit' + IntToStr(I)) as TNumEdit do
        aLID.StorageLayer[I-1] := Text;
  end;

  if TabSheet5.Visible then
  begin
    for I := 1 to 3 do
      with FindComponent('DrainEdit' + IntToStr(I)) as TNumEdit do
        aLID.DrainLayer[I-1] := Text;
    aLID.DrainLayer[3] := DrainDelayEdit.Text;
  end;

  if TabSheet6.Visible then
  begin
    for I := 1 to 3 do
      with FindComponent('DrainMatEdit' + IntToStr(I)) as TNumEdit do
        aLID.DrainMatLayer[I-1] := Text;
  end;

end;

procedure TLidControlDlg.NameEditChange(Sender: TObject);
//-----------------------------------------------------------------------------
//  OnChange handler for the various fields on the form.
//-----------------------------------------------------------------------------
begin
  Modified := True;
end;

//-----------------------------------------------------------------------------
//  OnExit handler for Numerical fields that edit fractions.
//-----------------------------------------------------------------------------
procedure TLidControlDlg.NumEditExit(Sender: TObject);
var
  Pscreen: TPoint;
  Pclient: TPoint;
begin
  with Sender as TNumEdit do
  begin
    if (Length(Text) = 0) or (StrToFloat(Text) >= 1.0) then
    begin
      Pclient.X := 0;
      Pclient.Y := Height;
      Pscreen := ClientToScreen(Pclient);
      MessageDlgPos('This value must be less than 1.0', mtError, [mbOK],
        0, Pscreen.X, Pscreen.Y);
      SetFocus;
      Exit;
    end;
  end;
end;

procedure TLidControlDlg.TypeComboClick(Sender: TObject);
//-----------------------------------------------------------------------------
//  OnClick handler for the TypeCombo control.
//-----------------------------------------------------------------------------
var
  ShowTab1: Boolean;  //Surface layer tab
  ShowTab2: Boolean;  //Pavement layer tab
  ShowTab3: Boolean;  //Soil layer tab
  ShowTab4: Boolean;  //Storage layer tab
  ShowTab5: Boolean;  //Drain layer tab
  ShowTab6: Boolean;  //Drainmat layer tab
  RainBarrel: Boolean;
  VegSwale: Boolean;

begin
  ShowTab1 := True;
  ShowTab2 := False;
  ShowTab3 := False;
  ShowTab4 := True;
  ShowTab5 := True;
  ShowTab6 := False;

  ImageBook.PageIndex := TypeCombo.ItemIndex;
  case TypeCombo.ItemIndex of
  Ulid.BIO_CELL: ShowTab3 := True;
  Ulid.RAIN_GARDEN:
    begin
      ShowTab3 := True;
      ShowTab4 := False;
      ShowTab5 := False;
    end;
  Ulid.GREEN_ROOF:
    begin
      ShowTab3 := True;
      ShowTab4 := False;
      ShowTab5 := False;
      ShowTab6 := True;
    end;
  Ulid.PERM_PAVE: ShowTab2 := True;
  Ulid.RAIN_BARREL: ShowTab1 := False;
  Ulid.VEG_SWALE:
    begin
      ShowTab4 := False;
      ShowTab5 := False;
    end;
  end;

  TabSheet1.TabVisible := ShowTab1;
  TabSheet2.TabVisible := ShowTab2;
  TabSheet3.TabVisible := ShowTab3;
  TabSheet4.TabVisible := ShowTab4;
  TabSheet5.TabVisible := ShowTab5;
  TabSheet6.TabVisible := ShowTab6;

  RainBarrel := (TypeCombo.ItemIndex = Ulid.RAIN_BARREL);
  DrainDelayEdit.Visible := RainBarrel;
  DrainDelayLabel.Visible := RainBarrel;
  HoursLabel.Visible := RainBarrel;
  StoragePanel.Visible := not RainBarrel;
  if RainBarrel then StorageHeightLabel.Caption := 'Barrel Height'
  else StorageHeightLabel.Caption := 'Thickness';

  VegSwale := (TypeCombo.ItemIndex = Ulid.VEG_SWALE);
  SlopeLabel1.Visible := VegSwale;
  SlopeLabel2.Visible := VegSwale;
  SurfaceEdit5.Visible := VegSwale;
end;

procedure TLidControlDlg.OkBtnClick(Sender: TObject);
var
  S : String;
  ID: String;
  DupID: Integer;
  Pscreen: TPoint;
  Pclient: TPoint;
begin
  // Get coordinates of bottom left of edit control
  Pclient.X := NameEdit.Left;
  Pclient.Y := NameEdit.Top + NameEdit.Height + 2;

  // Check for blank name
  S := Trim(NameEdit.Text);
  if Length(S) = 0 then
  begin
    Pscreen := ClientToScreen(Pclient);
    MessageDlgPos('LID Name cannot be left blank.', mtError, [mbOK],
        0, Pscreen.X, Pscreen.Y);
    NameEdit.SetFocus;
    Exit;
  end;

  // Temporarily blank out existing LID name in data base
  if LidIndex >= 0 then
  begin
    ID := Project.Lists[LID].Strings[LidIndex];
    Project.Lists[LID].Strings[LidIndex] := '';
  end;

  // See if another LID with same name exists
  DupID := Project.Lists[LID].IndexOf(S);

  // Restore ID name and display error message if duplicate found
  if LidIndex >= 0 then Project.Lists[LID].Strings[LidIndex] := ID;
  if DupID >= 0 then
  begin
    Pscreen := ClientToScreen(Pclient);
    MessageDlgPos('LID Name already in use.', mtError, [mbOK],
        0, Pscreen.X, Pscreen.Y);
    NameEdit.SetFocus;
    Exit;
  end;

  // Signal that dialog's contents are OK
  ModalResult := mrOk;
end;

procedure TLidControlDlg.HelpBtnClick(Sender: TObject);
begin
  Application.HelpCommand(HELP_CONTEXT, 213280);
end;


end.
