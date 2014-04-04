unit Dtemp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GridEdit, StdCtrls, ComCtrls, NumEdit, Buttons, Uproject, Uglobals;

const
  MonthLabels1: PChar = 'Jan'#13'Feb'#13'Mar'#13'Apr'#13'May'#13'Jun';
  MonthLabels2: PChar = 'Jul'#13'Aug'#13'Sep'#13'Oct'#13'Nov'#13'Dec';
  ADCColLabels: PChar = 'Depth Ratio'#13'Impervious'#13'Pervious';
  ADCRowLabels: PChar = ''#13'0.0'#13'0.1'#13'0.2'#13'0.3'#13'0.4'#13'0.5'#13+
                        '0.6'#13'0.7'#13'0.8'#13'0.9';
type
  TTemperatureForm = class(TForm)
    PageControl1: TPageControl;
    OKBtn: TButton;
    CancelBtn: TButton;
    HelpBtn: TButton;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    RadioButton1: TRadioButton;
    ComboBox1: TComboBox;
    RadioButton2: TRadioButton;
    Edit1: TEdit;
    WindGrid1: TGridEditFrame;
    Label1: TLabel;
    WindGrid2: TGridEditFrame;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    Label3: TLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    NumEdit1: TNumEdit;
    NumEdit2: TNumEdit;
    NumEdit3: TNumEdit;
    Label4: TLabel;
    NumEdit4: TNumEdit;
    NumEdit5: TNumEdit;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    NumEdit6: TNumEdit;
    ADCGrid: TGridEditFrame;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure OKBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetData(T: TTemperature);
    procedure GetData(T: TTemperature);
  end;

//var
//  TemperatureForm: TTemperatureForm;

implementation

{$R *.dfm}

procedure TTemperatureForm.FormCreate(Sender: TObject);
begin
  Uglobals.SetFont(self);
  with WindGrid1.Grid do
  begin
    Rows[0].SetText(MonthLabels1);
  end;
  with WindGrid2.Grid do
  begin
    Rows[0].SetText(MonthLabels2);
  end;
  with ADCGrid.Grid do
  begin
    Cols[0].SetText(ADCRowLabels);
    Rows[0].SetText(ADCColLabels);
  end;
end;

procedure TTemperatureForm.OKBtnClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TTemperatureForm.SetData(T: TTemperature);
var
  I: Integer;
  J: Integer;
begin
  with T do
  begin
    if DataSource = 1 then
    begin
      RadioButton1.Checked := True;
      ComboBox1.Text := Tseries;
    end
    else
    begin
      RadioButton2.Checked := True;
      Edit1.Text     := TempFile;
      Edit2.Text     := StartDate;
      Edit3.Text     := EndDate;
    end;
    with WindGrid1.Grid do
    begin
      for I := 0 to 5 do Cells[I,1] := WindSpeed[I+1];
    end;
    with WindGrid2.Grid do
    begin
      for I := 0 to 5 do Cells[I,1] := WindSpeed[I+7];
    end;
    for I := 1 to 6 do
    begin
      with FindComponent('NumEdit'+IntToStr(I)) as TNumEdit do
        Text := SnowMelt[I];
    end;
    with ADCGrid.Grid do
    begin
      for I := 1 to 2 do
      begin
        for J := 1 to 10 do
          Cells[I,J] := ADCurve[I][J];
      end;
    end;
  end;
  PageControl1.ActivePageIndex := 0;
end;

procedure TTemperatureForm.GetData(T: TTemperature);
var
  I: Integer;
  J: Integer;
begin
  with T do
  begin
    if RadioButton1.Checked then
    begin
      DataSource := 1;
      Tseries := ComboBox1.Text;
    end
    else
    begin
      DataSource := 2;
      TempFile := Edit1.Text;
      StartDate := Edit2.Text;
      EndDate := Edit3.Text;
    end;
    with WindGrid1.Grid do
    begin
      for I := 0 to 5 do WindSpeed[I+1] := Cells[I,1];
    end;
    with WindGrid2.Grid do
    begin
      for I := 0 to 5 do  WindSpeed[I+7] := Cells[I,1];
    end;
    for I := 1 to 6 do
    begin
      with FindComponent('NumEdit'+IntToStr(I)) as TNumEdit do
        SnowMelt[I] := Text;
    end;
    with ADCGrid.Grid do
    begin
      for I := 1 to 2 do
      begin
        for J := 1 to 10 do
           ADCurve[I][J] := Cells[I,J];
      end;
    end;
  end;
end;

end.
