program PLRM2014;

uses
  Windows,
  Forms,
  Dialogs,
  SysUtils,
  Dabout in 'Dabout.pas' {AboutBoxForm},
  Fmap in 'Fmap.pas' {MapForm},
  Uglobals in 'Uglobals.pas',
  Uutils in 'Uutils.pas',
  Fproped in 'Fproped.pas' {PropEditForm},
  PropEdit in 'PropEdit.pas',
  Dprefers in 'Dprefers.pas' {PreferencesForm},
  Umap in 'Umap.pas',
  Dmapdim in 'Dmapdim.pas' {MapDimensionsForm},
  Dlabel in 'Dlabel.pas' {LabelForm},
  Uinifile in 'Uinifile.pas',
  Dlegend in 'Dlegend.pas' {LegendForm},
  Dcolramp in 'Dcolramp.pas' {ColorRampForm},
  Uproject in 'Uproject.pas',
  Uedit in 'Uedit.pas',
  Dlanduse in 'Dlanduse.pas' {LanduseForm},
  Dinfil in 'Dinfil.pas' {InfilForm},
  Dcurve in 'Dcurve.pas' {CurveDataForm},
  Uexport in 'Uexport.pas',
  Dmap in 'Dmap.pas' {MapOptionsForm},
  Dtseries in 'Dtseries.pas' {TimeseriesForm},
  Uvertex in 'Uvertex.pas',
  Uoutput in 'Uoutput.pas',
  Ulegend in 'Ulegend.pas',
  Fstatus in 'Fstatus.pas' {StatusForm},
  Dreport in 'Dreport.pas' {ReportSelectForm},
  Fgraph in 'Fgraph.pas' {GraphForm},
  Dcopy in 'Dcopy.pas' {CopyToForm},
  Ubrowser in 'Ubrowser.pas',
  Fovmap in 'Fovmap.pas' {OVMapForm},
  Ddefault in 'Ddefault.pas' {DefaultsForm},
  Fmain in 'Fmain.pas' {MainForm},
  Dxsect in 'Dxsect.pas' {XsectionForm},
  Uimport in 'Uimport.pas',
  Dfind in 'Dfind.pas' {FindForm},
  Dmapexp in 'Dmapexp.pas' {MapExportForm},
  Udxf in 'Udxf.pas',
  Dsubland in 'Dsubland.pas' {SubLandUsesForm},
  Dgrouped in 'Dgrouped.pas' {GroupEditForm},
  Dquery in 'Dquery.pas' {QueryForm},
  Doptions in 'Doptions.pas' {AnalysisOptionsForm},
  Ftable in 'Ftable.pas' {TableForm},
  Dpattern in 'Dpattern.pas' {PatternForm},
  Fproplot in 'Fproplot.pas' {ProfilePlotForm},
  Dproplot in 'Dproplot.pas' {ProfilePlotOptionsForm},
  Dprofile in 'Dprofile.pas' {ProfileSelectionForm},
  Dcontrol in 'Dcontrol.pas' {ControlsForm},
  Dgrpdel in 'Dgrpdel.pas' {GroupDeleteForm},
  Dcalib1 in 'Dcalib1.pas' {CalibDataForm},
  Fsimul in 'Fsimul.pas' {SimulationForm},
  Fstats in 'Fstats.pas' {StatsReportForm},
  Ugraph in 'Ugraph.pas',
  Dtsect in 'Dtsect.pas' {TransectForm},
  Dprevplot in 'Dprevplot.pas' {PreviewPlotForm},
  Dstats in 'Dstats.pas' {StatsSelectForm},
  Dpollut in 'Dpollut.pas' {PollutantForm},
  Daquifer in 'Daquifer.pas' {AquiferForm},
  Dgwater in 'Dgwater.pas' {GroundWaterForm},
  Dinflows in 'Dinflows.pas' {InflowsForm},
  Dunithyd in 'Dunithyd.pas' {UnitHydForm},
  GridEdit in 'GridEdit.pas' {GridEditFrame: TFrame},
  Dcombine in 'Dcombine.pas' {FileCombineForm},
  Ucombine in 'Ucombine.pas',
  Dclimate in 'Dclimate.pas' {ClimatologyForm},
  Dsnow in 'Dsnow.pas' {SnowpackForm},
  Dtreat in 'Dtreat.pas' {TreatmentForm},
  Dsummary in 'Dsummary.pas' {ProjectSummaryForm},
  Dloads in 'Dloads.pas' {InitLoadingsForm},
  Uupdate in 'Uupdate.pas',
  Uvalidate in 'Uvalidate.pas',
  Uclipbrd in 'Uclipbrd.pas',
  Diface in 'Diface.pas' {IfaceFileForm},
  Dnotes in 'Dnotes.pas' {NotesEditorForm},
  Dbackdrp in 'Dbackdrp.pas' {BackdropFileForm},
  Dbackdim in 'Dbackdim.pas' {BackdropDimensionsForm},
  Ucoords in 'Ucoords.pas',
  Ucalib in 'Ucalib.pas',
  Ustats in 'Ustats.pas',
  Animator in 'Animator.pas' {AnimatorFrame: TFrame},
  Dtools1 in 'Dtools1.pas' {ToolOptionsForm},
  Dtools2 in 'Dtools2.pas' {ToolPropertiesForm},
  Utools in 'Utools.pas',
  Dreporting in 'Dreporting.pas' {ReportingForm},
  Ulid in 'Ulid.pas',
  Dlid in 'Dlid.pas' {LidControlDlg},
  Dlidgroup in 'Dlidgroup.pas' {LidGroupDlg},
  Dlidusage in 'Dlidusage.pas' {LidUsageDlg},
  UpDnEdit in 'UpDnEdit.pas' {UpDnEditBox: TFrame},
  swmm5 in 'swmm5.pas',
  Dchart in 'Dchart.pas' {ChartOptionsDlg},
  Fresults in 'Fresults.pas' {ResultsForm},
  Dproject in 'Dproject.pas' {ProjectForm},
  Dgweqn in 'Dgweqn.pas' {GWEqnForm},
  Dtimeplot in 'Dtimeplot.pas' {TimePlotForm},
  Dproselect in 'Dproselect.pas' {ProfileSelectForm},
  _PLRMD1LandUseAssignmnt2 in 'PLRMFinalGS\Forms\Dialogs\_PLRMD1LandUseAssignmnt2.pas' {PLRMLandUse},
  _PLRMD2SoilsAssignmnt in 'PLRMFinalGS\Forms\Dialogs\_PLRMD2SoilsAssignmnt.pas' {PLRMD2SoilsAssignmnt},
  _PLRMD3CatchProps in 'PLRMFinalGS\Forms\Dialogs\_PLRMD3CatchProps.pas' {CatchProps},
  _PLRMD4Schematics in 'PLRMFinalGS\Forms\Dialogs\_PLRMD4Schematics.pas' {DetSchm},
  _PLRMD5VolumeDischarge in 'PLRMFinalGS\Forms\Dialogs\_PLRMD5VolumeDischarge.pas' {VolumeDischargeForm},
  _PLRMD6About in 'PLRMFinalGS\Forms\Dialogs\_PLRMD6About.pas' {About},
  _PLRMDprogress in 'PLRMFinalGS\Forms\Dialogs\_PLRMDprogress.pas' {plrmProgress},
  _PLRMstats in 'PLRMFinalGS\Forms\Dialogs\_PLRMstats.pas' {frmPLRMStats},
  _PLRM1ProjNscenManger in 'PLRMFinalGS\Forms\_PLRM1ProjNscenManger.pas' {ProjNscenManager},
  _PLRM2ProjNscenEditor in 'PLRMFinalGS\Forms\_PLRM2ProjNscenEditor.pas' {ProjNscenEditor},
  _PLRM3PSCDef in 'PLRMFinalGS\Forms\_PLRM3PSCDef.pas' {PLRMPCSDef},
  _PLRM4RoadConditions in 'PLRMFinalGS\Forms\_PLRM4RoadConditions.pas' {PLRMRoadConditions},
  _PLRM5RoadDrnXtcs in 'PLRMFinalGS\Forms\_PLRM5RoadDrnXtcs.pas' {PLRMDrainageConditions},
  GSCatchments in 'PLRMFinalGS\Units\GSCatchments.pas',
  GSDataAccess in 'PLRMFinalGS\Units\GSDataAccess.pas',
  GSFileManage in 'PLRMFinalGS\Units\GSFileManage.pas',
  GSIO in 'PLRMFinalGS\Units\GSIO.pas',
  GSNodes in 'PLRMFinalGS\Units\GSNodes.pas',
  GSPLRM in 'PLRMFinalGS\Units\GSPLRM.pas',
  GSResults in 'PLRMFinalGS\Units\GSResults.pas',
  GSTypes in 'PLRMFinalGS\Units\GSTypes.pas',
  GSUtils in 'PLRMFinalGS\Units\GSUtils.pas',
  PLRMStats in 'PLRMFinalGS\Units\PLRMStats.pas',
  _PLRM6DrngXtsDetail in 'PLRMFinalGS\Forms\_PLRM6DrngXtsDetail.pas' {PLRMDrngXtsDetail},
  _PLRM7SWTs in 'PLRMFinalGS\Forms\_PLRM7SWTs.pas' {SWTs},
  _PLRM9ScenCompsMulti in 'PLRMFinalGS\Forms\_PLRM9ScenCompsMulti.pas' {PLRMScenComps},
  _PLRMDAbout in 'PLRMFinalGS\Forms\Dialogs\_PLRMDAbout.pas' {AboutPLRMBoxForm},
  _PLRMD4RoadPollutants in 'PLRMFinalGS\Forms\Dialogs\_PLRMD4RoadPollutants.pas' {PLRMRoadPollutants},
  _PLRMD5RoadDrainageEditor in 'PLRMFinalGS\Forms\Dialogs\_PLRMD5RoadDrainageEditor.pas' {PLRMRoadDrainageEditor},
  _PLRMD6ParcelDrainageAndBMPs in 'PLRMFinalGS\Forms\Dialogs\_PLRMD6ParcelDrainageAndBMPs.pas' {PLRMParcelDrngAndBMPs};

{$R *.RES}

begin
  Application.Initialize;
  Application.MainFormOnTaskBar := True; // added for MDI app
  Application.Title := 'SWMM 5';
  Application.HelpFile := '';
  Application.CreateForm(TMainForm, MainForm);
  //Application.CreateForm(TPLRMRoadPollutants, PLRMRoadPollutants);
  //Application.CreateForm(TPLRMRoadDrainageEditor, PLRMRoadDrainageEditor);
  //Application.CreateForm(TPLRMParcelDrngAndBMPs, PLRMParcelDrngAndBMPs);
  //Application.CreateForm(TplrmProgress, plrmProgress);
  //Application.CreateForm(TfrmPLRMStats, frmPLRMStats);
  {Application.CreateForm(TForm1, Form1);
  /Application.CreateForm(TDetSchm, DetSchm);
  Application.CreateForm(TFCatchParam, FCatchParam);
  Application.CreateForm(TFcatchProp, FcatchProp);
  Application.CreateForm(TFGlobalCatch, FGlobalCatch);
  Application.CreateForm(TForm7, Form7);
  Application.CreateForm(TForm2, Form2);}
  Application.Run;
end.
