unit _PLRMD4Schematics;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, ComCtrls, GSTypes;

type
  TDetSchm = class(TForm)
    Image1: TImage;
    Image2: TImage;
    pgCtrl: TPageControl;
    TabSheet0: TTabSheet;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    TabSheet5: TTabSheet;
    Image7: TImage;
    statBar: TStatusBar;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
procedure getSchmForm(SWTType:Integer);
var
  DetSchm: TDetSchm;

implementation

{$R *.dfm}
  procedure getSchmForm(SWTType:Integer);
  var
    I : Integer;
  begin
    DetSchm := TDetSchm.Create(Application);
    for I := 0 to DetSchm.pgCtrl.PageCount - 1 do
      DetSchm.pgCtrl.Pages[I].TabVisible := false;

    case SWTType of
       1:   //Detention
       begin
          DetSchm.Caption :=  PLRMD4Det_TITLE;
          DetSchm.pgCtrl.Pages[0].TabVisible := true;  //Detention
        end;
       2:   //Infiltration
       begin
        DetSchm.Caption :=  PLRMD4Inf_TITLE;
        DetSchm.pgCtrl.Pages[1].TabVisible := true; //Infiltration
       end;
       3:   //WetBasin
       begin
          DetSchm.Caption :=  PLRMD4Wet_TITLE;
          DetSchm.pgCtrl.Pages[4].TabVisible := true; //WetBasin
       end;
       4:      //Bed Filter
       begin
          DetSchm.Caption :=  PLRMD4Gfl_TITLE;
          DetSchm.pgCtrl.Pages[5].TabVisible := true; //'Filter'
       end;
       5:     //Cartridge filter
       begin
          DetSchm.Caption :=  PLRMD4Cfl_TITLE;
          DetSchm.pgCtrl.Pages[3].TabVisible := true; //'Hydrodynamic Device'
       end;
       6:     //Hydrodynamic
       begin
          DetSchm.Caption :=  PLRMD4GHyd_TITLE;
          DetSchm.pgCtrl.Pages[2].TabVisible := true; //'Hydrodynamic Device'
       end;
    end;
    try
      DetSchm.ShowModal;
    finally
      DetSchm.Free;
    end;
  end;
procedure TDetSchm.FormCreate(Sender: TObject);
begin
  statBar.SimpleText := PLRMVERSION;
  Self.Caption := PLRMD4_TITLE;
end;

end.
