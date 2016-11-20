Set TDIR=D:\Dropbox\Projects\TauDEM\Taudemdev\Taudem5PCVS2015\x64\Release
set path=%TDIR%;%path%

rem  This is a specific problem that caused an infinite loop in moveoutlets prior to 11/20/16 fixes 

mpiexec  -np  8  moveoutletstostreams  -p  subwatershed_74p.tif  -src  subwatershed_74src1.tif  -o  mypoint.shp  -om  New_Outlet.shp  -md  10000.0 

mpiexec -np 1 moveoutletstostreams  -p  subwatershed_74p.tif  -src  subwatershed_74src1.tif  -o  testpoints.shp  -om  New_Outlet1.shp  -md  10000 

mpiexec -np 8 moveoutletstostreams  -p  subwatershed_74p.tif  -src  subwatershed_74src1.tif  -o  testpoints.shp  -om  New_Outlet2.shp  -md  100 