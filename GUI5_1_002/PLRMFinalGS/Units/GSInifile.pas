unit GSInifile;

{ ------------------------------------------------------------------- }
{ Unit:    Uinifile.pas }
{ Project: EPA SWMM }
{ Version: 5.1 }
{ Date:    03/24/14     (5.1.001) }
{ 03/31/14     (5.1.002) }
{ Author:  L. Rossman }
{ }
{ Delphi Pascal unit that reads and writes initialization data }
{ to the SWMM INI file (epaswmm5.ini) as well as for the current }
{ project's INI file. }
{ ------------------------------------------------------------------- }

interface

uses
  Classes, SysUtils, Forms,  IniFiles;


procedure ReadIniFile;
procedure SaveIniFile;

implementation

uses
  Fmain, Fmap, Fproped, Uupdate, GSUtils;

var
  PLRMINIFilePath: String;

procedure ReadIniFile;
// -----------------------------------------------------------------------------
// Reads custom PLRM settings
// from the plrm ini file. The name of the ini file is the same as the name
// of the plrm executable with a .ini file extension
// -----------------------------------------------------------------------------
var
  INIFILE: TIniFile;
begin

  INIFILE := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));

  try
    // read and update file paths
    defaultPrjDir := INIFILE.ReadString('FilePaths', 'workspace',
      defaultPrjDir);
    // Free the .INI file object
  finally
    INIFILE.Free;
  end;
end;

procedure SaveIniFile;
// -----------------------------------------------------------------------------
// Saves custom PLRM settings
// to the plrm ini file. The name of the ini file is the same as the name
// of the plrm executable with a .ini file extension
// -----------------------------------------------------------------------------
var
  INIFILE: TIniFile;
begin
  INIFILE := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));

  try
    // write file paths
    INIFILE.WriteString('FilePaths', 'workspace', defaultPrjDir);
    // Free the .INI file object
  finally
    INIFILE.Free;
  end;
end;

end.
