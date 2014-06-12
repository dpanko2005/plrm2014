unit _PLRMD6About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TAbout = class(TForm)
    Image1: TImage;
    btnDismis: TButton;
    procedure btnDismisClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
 procedure getAbout();
var
  AboutForm: TAbout;

implementation

{$R *.dfm}

procedure getAbout();
//  var
//    tempInt : Integer;
  begin
    AboutForm := TAbout.Create(Application);
    try
      AboutForm.ShowModal;
    finally
      AboutForm.Free;
    end;
end;

procedure TAbout.btnDismisClick(Sender: TObject);
begin
   modalResult := mrOk;
end;

end.
