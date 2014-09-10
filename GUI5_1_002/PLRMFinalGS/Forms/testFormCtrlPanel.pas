unit testFormCtrlPanel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, _PLRM6DrngXtsDetail, _PLRM7SWTs, _PLRM9ScenComps, StdCtrls, _PLRM0Wizard;

type
  TtestFormCtrlP = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  testFormCtrlP: TtestFormCtrlP;

implementation

{$R *.dfm}

procedure TtestFormCtrlP.Button1Click(Sender: TObject);
begin
      //PLRMRoadConditions.Close;
      //PLRMDrngXtsDetail := TPLRMDrngXtsDetail.create(self);

//    with PLRMDrngXtsDetail do
//      try
//        ShowModal;
//    finally
//      Free;
//    end;
//    ModalResult := mrOK;
 end;

procedure TtestFormCtrlP.Button2Click(Sender: TObject);
begin
  PLRMSWTs := TPLRMSWTs.create(self);

    with PLRMSWTs do
      try
        ShowModal;
    finally
      Free;
    end;
    ModalResult := mrOK;
end;

procedure TtestFormCtrlP.Button3Click(Sender: TObject);
begin
  PLRMScenComps := TPLRMScenComps.create(self);

    with PLRMScenComps do
      try
        ShowModal;
    finally
      Free;
    end;
    ModalResult := mrOK;
end;

procedure TtestFormCtrlP.Button4Click(Sender: TObject);
begin
  PLRMWiz := TPLRMWiz.create(self);

    with PLRMWiz do
      try
        ShowModal;
    finally
      Free;
    end;
    ModalResult := mrOK;
end;

end.
