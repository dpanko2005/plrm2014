unit _FCatchProp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, ADODB, StdCtrls;

type
  TFcatchProp = class(TForm)
    ADOTable2: TADOTable;
    DataSource2: TDataSource;
    DBGrid1: TDBGrid;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FcatchProp: TFcatchProp;

implementation

{$R *.dfm}

end.
