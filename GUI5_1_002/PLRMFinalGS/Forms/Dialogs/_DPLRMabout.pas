unit _DPLRMabout;

{-------------------------------------------------------------------}
{                    Unit:    Dabout.pas                            }
{                    Project: EPA SWMM                              }
{                    Version: 5.0                                   }
{                    Date:    3/29/05       (5.0.005)               }
{                             5/25/05       (5.0.005a)              }
{                             6/15/05       (5.0.005b)              }
{                             9/5/05        (5.0.006)               }
{                             10/19/05      (5.0.006a)              }
{                             3/10/06       (5.0.007)               }
{                             7/5/06        (5.0.008)               }
{                             9/19/06       (5.0.009)               }
{                             6/19/07       (5.0.010)               }
{                             7/16/07       (5.0.011)               }
{                             2/4/08        (5.0.012)               }
{                             3/3/08        (5.0.013)               }
{                             1/21/09       (5.0.014)               }
{                    Author:  L. Rossman                            }
{                                                                   }
{   Form unit containing the "About" dialog box for EPA SWMM.       }
{-------------------------------------------------------------------}

interface

uses WinTypes, WinProcs, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls;

type
  VERTEX = packed record
    X, Y : DWORD;
    Red, Green, Blue, Alpha : Word;
  end;

type
  TPLRMAboutBoxForm = class(TForm)
    Label3: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Button1: TButton;
    BackTitle: TLabel;
    ForeTitle: TLabel;
    Version: TLabel;
    Label4: TLabel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
   vertices: array [0..1] of VERTEX;
   Rectangle: GRADIENT_RECT;
   Color1: TColor;
   Color2: TColor;
  public
    { Public declarations }
  end;

//var
//  AboutBoxForm: TAboutBoxForm;

implementation

{$R *.DFM}

procedure TPLRMAboutBoxForm.FormCreate(Sender: TObject);
begin
  // Set parameters used to draw gradient fill background
  vertices[0].x := 0;
  vertices[0].y := 0;
  vertices[0].Alpha  := $ff00;
  vertices[1].x := ClientWidth;
  vertices[1].y := ClientHeight;
  vertices[1].Alpha := $ff00;
  Rectangle.UpperLeft := 0;
  Rectangle.LowerRight := 1;
  Color1 := clBackground;
  Color2 := clSkyBlue;
end;

procedure TPLRMAboutBoxForm.FormPaint(Sender: TObject);
var
  // Declare the gradient fill function contained in msimg32.dll
  gradFill: function(DC : hDC; pVertex : Pointer; dwNumVertex : DWORD;
                     pMesh : Pointer; dwNumMesh, dwMode: DWORD): DWord; stdcall;
  hMod: THandle;
begin
  // Load the msimg32.dll library (included with Windows versions > 98)
  // so that the gradFill function can be used to draw a gradient fill.
  // If the library is not present, the form's background color will
  // default to be a solid fill using the clBackground color.
  hMod := LoadLibrary('msimg32.dll');
  if (hMod <> 0) then
  begin
    @gradFill := GetProcAddress(hMod, 'GradientFill');
    if (@gradFill <> nil) then
    begin
      vertices[0].Red    := GetRValue(Color1) SHL 8;
      vertices[0].Green  := GetGValue(Color1) SHL 8;
      vertices[0].Blue   := GetBValue(Color1) SHL 8;
      vertices[1].Red    := GetRValue(Color2) SHL 8;
      vertices[1].Green  := GetGValue(Color2) SHL 8;
      vertices[1].Blue   := GetBValue(Color2) SHL 8;
      gradFill(Canvas.Handle,@vertices[0],2,@Rectangle,1,GRADIENT_FILL_RECT_V);
    end;
    FreeLibrary(hMod);
  end;
end;

end.
