This directory contains sources for compiling GDAL / OGR with GEOS support
GEOS support needed for intersections to work
Useful links:
http://lists.osgeo.org/pipermail/gdal-dev/2013-May/036159.html
	- download 3.3.8 from http://trac.osgeo.org/geos/
	- in MSVC command window:
	  - cd to geos-3.3.8
	  - autogen.bat
	  - nmake /f makefile.vc MSVC_VER=1500
	- output is in /src/
	- cd into gdal
	- edit nmake.opt
	  - change GEOS_DIR, GEOS_CFLAGS, GEOS_LIB variables for your local paths
	- nmake /f makefile.vc clean
	- nmake /f makefile.vc
	
http://trac.osgeo.org/geos/wiki/BuildingOnWindowsWithNMake

To compile geos had to copy 
C:\Users\dpankani\Downloads\geos-3.4.2\include\geos - the geos folder into
C:\Users\dpankani\Downloads\geos-3.4.2\capi - the capi folder

Output dll defaults to C:\warmerda\bld\bin gdal111.dll if install option added to compilation

Above not working so started over with newly downloaded source files to:
C:\dev\plrm2014\GUI5_1_002\OpenGIS
Had issue compiling gdal where gdal was linking geos_c.dll in c:\program files which is 64-bit and not 32-bit like rest of compiled source
so renamed geos_c.dll in c:\program files to xgeos_c.dll and copied over newly compiled geos_c.dll from C:\dev\plrm2014\GUI5_1_002\OpenGIS\geos-3.4.2