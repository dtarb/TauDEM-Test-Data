Rem command to run
mpiexec -n 4 D:\Dropbox\Projects\TauDEM\TauDEMDev\Taudem5PCVS2015\x64\Release\CatchHydroGeo -hand onion3dd.tif -catch onion3w.tif -catchlist catchlist.txt -slp onion3slp.tif -h stage.txt -table hydropropotable.txt

Rem catchlist.txt exported from *net.shp with columns
Rem -  LINKNO	
Rem - Slope	
Rem - Length	
Rem - Areakm2

Rem Note that linkno depends on the number of processes

