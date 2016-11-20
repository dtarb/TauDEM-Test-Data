Set TDIR=D:\Dropbox\Projects\TauDEM\Taudemdev\Taudem5PCVS2015\x64\Release
set path=%TDIR%;%path%

mpiexec -n 4 gagewatershed -p fdr.tif -gw gw.tif -id id.txt -o CatchOutlets3.shp