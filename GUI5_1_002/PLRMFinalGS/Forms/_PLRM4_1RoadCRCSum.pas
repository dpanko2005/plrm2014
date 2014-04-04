unit _PLRM4_1RoadCRCSum;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, GSUtils, GSTypes, jpeg;

type
  TRoadCRCs = class(TForm)
    sgRdCRCAdj: TStringGrid;
    Panel6: TPanel;
    Label5: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label4: TLabel;
    Label12: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    sgRdCRCWtd: TStringGrid;
    Panel2: TPanel;
    Label3: TLabel;
    Label19: TLabel;
    Panel3: TPanel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label28: TLabel;
    Image1: TImage;
    //procedure FormCreate(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure showRdCRCsSumryForm(primRdCRCs : TPLRMRdCondsData; secRdCRCs :TPLRMRdCondsData);
var
  FrmRoadCRCs: TRoadCRCs;

implementation

{$R *.dfm}

procedure showRdCRCsSumryForm(primRdCRCs : TPLRMRdCondsData; secRdCRCs :TPLRMRdCondsData);
var
  idx :Integer;
  jdx :Integer;
  secStrtRowNum :Integer;
  FrmRoadCRCs: TRoadCRCs;
  Rslts : TPLRMRdCondsData;
  tempInt : Integer;
  crcSums : array[0..1, 0..5] of Double;
begin
    FrmRoadCRCs := TRoadCRCs.Create(Application);
    secStrtRowNum := 3;
  for idx := 0 to 2 do//High(primRdCRCs.xtscsConcs) do
    for jdx := 0 to 5 do//High(primRdCRCs.xtscsConcs) do
      begin
         FrmRoadCRCs.sgRdCRCAdj.Cells[jdx,idx] := primRdCRCs.xtscsConcs[idx,jdx];
         FrmRoadCRCs.sgRdCRCAdj.Cells[jdx, idx + secStrtRowNum] := secRdCRCs.xtscsConcs[idx,jdx];
      //keep track of sums
//      crcSums[0,jdx] := crcSums[0,jdx] +  (StrToFloat(primRdCRCs.xtscsConcs[idx,jdx])*primRdCRCs.assigndWts[idx]);
//      crcSums[1,jdx] := crcSums[1,jdx] +  (StrToFloat(secRdCRCs.xtscsConcs[idx,jdx])*secRdCRCs.assigndWts[idx]);
      end;
  //populated weighted crc grid
//  for idx := 0 to 1 do
//    for jdx := 0 to 5 do
//      begin
//         FrmRoadCRCs.sgRdCRCWtd.Cells[jdx,0] := FormatFloat('0', crcSums[0,jdx]);
//         FrmRoadCRCs.sgRdCRCWtd.Cells[jdx,1] := FormatFloat('0', crcSums[1,jdx]);
//      end;
  try
      tempInt := FrmRoadCRCs.ShowModal;
      if tempInt = mrOK then
      begin
      end;
    finally
      FrmRoadCRCs.Free;
    end;
end;



procedure getAdjRoadCRCs(RdCRCs : array of String; RdType : Integer);
var
    RoadCRCs : TRoadCRCs;
    iLoop :Integer; //row counter: high, moderate, low
    jLoop :Integer; // column counter: TSS, FineSed, TP, DP, TN, DN
    strtRow : Integer;
    //RdCRC is array[1..3, 1..6] of String;
begin
   // Cycle through rows (iLoop) and colums (jLoop)
    if RdType = 1 then; //Road type is Primary
      strtRow := 1;
    if RdType = 2 then; //Road type is Secondary
      strtRow := 3;

    for iLoop := 1 to 3 do
       begin
         for jLoop := 1 to 6 do
         begin
            RoadCRCs.sgRdCRCAdj.Cells[iLoop + strtRow,jLoop] := RdCRCs[iLoop,jLoop];
         end;
       end;
end;

procedure getWtdRoadCRCs(RdCRCs : array of String; RdType : Integer; Wts : TStringList);
var
    RoadCRCs : TRoadCRCs;
    WtdCRCs : TStringList;
    iLoop :Integer; //row counter: high, moderate, low
    jLoop : Integer; // column counter: TSS, FineSed, TP, DP, TN, DN
    strtRow : Integer;
    sCRCs : TStringList;
begin
    if RdType = 1 then; //Road type is Primary
      strtRow := 1;
    if RdType = 2 then; //Road type is Secondary
      strtRow := 2;

    sCRCs := TStringList.Create;
    WtdCRCs := TStringList.Create;

    //calculate weighted values one column at a time
    for jLoop := 1 to 6 do
      begin
        for iLoop := 1 to 3 do
          begin
            //populate sCRCs for current pollutant (jLoop)
            sCRCs[iLoop] := RdCRCs[iLoop,jLoop];
          end;
          //calculate weighted values
          WtdCRCs[jLoop] := FloatToStr(GSUtils.gsVectorMultiply(sCRCs,Wts));
      end;

    //Populate grid
    for jLoop := 1 to 6 do
      begin
        RoadCRCs.sgRdCRCWtd.Cells[strtRow,jLoop] := WtdCRCs[jLoop];
      end;

end;

end.
