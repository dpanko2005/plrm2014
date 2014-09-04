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
  Classes, SysUtils, Forms, IniFiles;

procedure ReadIniFile;
procedure SaveIniFile;

implementation

uses
  Fmain, Fmap, Fproped, Uupdate, Generics.Collections,GSUtils;

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
  tempStr: String;
  I: Integer;
begin

  INIFILE := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));

  try
    // read and update file paths
    defaultPrjDir := INIFILE.ReadString('FilePaths', 'workspace',
      defaultPrjDir);

    // read saved GIS shapefile
    if (not(assigned(shpFilesDict))) then
      shpFilesDict := TDictionary<String, String>.Create();

    for I := 0 to High(shpFileKeys) do
    begin
      tempStr := INIFILE.ReadString('FilePaths', shpFileKeys[I], tempStr);
      if (tempStr <> '') then
        if not(shpFilesDict.ContainsKey(shpFileKeys[I])) then
          shpFilesDict.Add(shpFileKeys[I], tempStr);
    end;
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
  I: Integer;
begin
  INIFILE := TIniFile.Create(ChangeFileExt(Application.ExeName, '.ini'));

  try
    // write file paths
    INIFILE.WriteString('FilePaths', 'workspace', defaultPrjDir);

    // Save GIS shapefile paths if exist
    if (assigned(shpFilesDict)) then
    begin
      for I := 0 to High(shpFileKeys) do
      begin
        if (shpFilesDict.ContainsKey(shpFileKeys[I])) then
          INIFILE.WriteString('FilePaths', shpFileKeys[I],
            shpFilesDict[shpFileKeys[I]]);
      end;
    end;

    // Free the .INI file object
  finally
    INIFILE.Free;
  end;
end;

end.
