unit _FGlobalCatchments;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, StdCtrls, Grids, DBGrids;

type
  TFGlobalCatch = class(TForm)
    GroupBox3: TGroupBox;
    DBGrid1: TDBGrid;
    Button2: TButton;
    btnCloseFrm: TButton;
    btnHelp: TButton;
    ADOTable1: TADOTable;
    DataSource1: TDataSource;
    Button1: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FGlobalCatch: TFGlobalCatch;

implementation

{$R *.dfm}

end.
