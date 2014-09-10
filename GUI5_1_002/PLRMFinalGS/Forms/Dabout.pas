unit Dabout;

{-------------------------------------------------------------------}
{                    Unit:    Dabout.pas                            }
{                    Project: EPA SWMM                              }
{                    Version: 5.1                                   }
{                    Date:    3/13/14       (5.1.001)               }
{                    Author:  L. Rossman                            }
{                                                                   }
{   Form unit containing the "About" dialog box for EPA SWMM.       }
{-------------------------------------------------------------------}

interface

uses Windows, Types, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, Vcl.Imaging.GIFImg, ShellAPI;

type
  TAboutBoxForm = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    Label5: TLabel;
    Panel1: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo1: TMemo;
    Memo2: TMemo;
    Label3: TLabel;
    Image1: TImage;
    Panel2: TPanel;
    Label4: TLabel;
    LinkLabel1: TLinkLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure LinkLabel1LinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

//var
//  AboutBoxForm: TAboutBoxForm;

implementation

{$R *.DFM}

const

Description1 =
'The EPA Storm Water Management Model (SWMM) is a dynamic '+
'rainfall-runoff-routing simulation model used for single ' +
'event or long-term (continuous) simulation of runoff quantity '+
'and quality from primarily urban areas. The runoff component of '+
'SWMM operates on a collection of subcatchment areas that receive '+
'precipitation and generate runoff and pollutant loads. The routing '+
'portion of SWMM transports this runoff through a system of pipes, '+
'channels, storage/treatment devices, pumps, and regulators. SWMM '+
'tracks the quantity and quality of runoff generated within each '+
'subcatchment, and the flow rate, flow depth, and quality of water '+
'in each pipe and channel during a simulation period comprised of '+
'multiple time steps.';

Description2 =
'EPA SWMM is public domain software that may be freely copied and distributed.';

Disclaimer =
'This software is provided on an "as-is" basis. US EPA makes no '+
'representations or warranties of any kind and expressly disclaim '+
'all other warranties express or implied, including, without '+
'limitation, warranties of merchantability or fitness for a particular '+
'purpose. Although care has been used in preparing the software product, '+
'US EPA disclaims all liability for its accuracy or completeness, and the '+
'user shall be solely responsible for the selection, use, efficiency and '+
'suitability of the software product. Any person who uses this product '+
'does so at their sole risk and without liability to US EPA. US EPA shall '+
'have no liability to users for the infringement of proprietary rights by '+
'the software product or any portion thereof.';

procedure TAboutBoxForm.FormCreate(Sender: TObject);
begin
  Label4.Caption := 'Storm Water Management Model'#10'Version 5.1';
  LinkLabel1.Caption := '<a href="http://www.epa.gov/swmm">www.epa.gov/swmm</a>';
  LinkLabel1.Hint := 'http://www.epa.gov/nrmrl/wswrd/wq/models/swmm';
  Memo1.Lines.Add(Disclaimer);
  Memo2.Lines.Add(Description1);
  Memo2.Lines.Add('');
  Memo2.Lines.Add(Description2);
  ActiveControl := Button1;
end;

procedure TAboutBoxForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then Close;
end;

procedure TAboutBoxForm.LinkLabel1LinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
var
  Url: String;
begin
  Url := LinkLabel1.Hint;
  ShellAPI.ShellExecute(0, 'Open', PChar(Url), PChar(''), nil, SW_SHOWNORMAL);
end;

end.
