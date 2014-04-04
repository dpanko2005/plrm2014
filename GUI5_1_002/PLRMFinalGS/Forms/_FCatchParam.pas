unit _FCatchParam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, StdCtrls, ComCtrls, jpeg, ExtCtrls, Menus, DB, ADODB;

type
  TFCatchParam = class(TForm)
    GroupBox3: TGroupBox;
    Button2: TButton;
    btnCloseFrm: TButton;
    btnHelp: TButton;
    DBGrid1: TDBGrid;
    ADOTable1: TADOTable;
    DataSource1: TDataSource;
    PopupMenu1: TPopupMenu;
    re1: TMenuItem;
    LandUse21: TMenuItem;
    LandUse31: TMenuItem;
    Button1: TButton;
  private
    { Private declarations }
  public

    { Public declarations }
  end;

var
  FCatchParam: TFCatchParam;

implementation

{$R *.dfm}

end.
