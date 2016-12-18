rem  Run CatchOutlets single processor, no parallel version yet
mpiexec -n 1 CatchOutlets -net net1.shp -p fdr.tif -o CatchOutlets.shp -mindist 20000 -minarea 50000000 -gwstartno 5
