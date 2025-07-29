#!/usr/bin/env bats

source '/tmp/bats-support/load.bash'
source '/tmp/bats-assert/load.bash'
source '/tmp/bats-file/load.bash'

# Set TAUDEM_PATH from environment or default - this is the path where the TauDEM executables are located
TAUDEM_PATH="${TAUDEM_PATH:-/usr/local/bin}"

# Validate that TAUDEM_PATH exists
if [ ! -d "$TAUDEM_PATH" ]; then
    echo "Error: TAUDEM_PATH directory '$TAUDEM_PATH' does not exist" >&2
    exit 1
fi

# Basic grid analysis
@test "run mpiexec -np 3 $TAUDEM_PATH/pitremove logan.tif -fel loganfel.tif" {
cd Base
run mpiexec -np 3  $TAUDEM_PATH/pitremove logan.tif
assert_success
}
@test "run mpiexec -np 3 $TAUDEM_PATH/pitremove -z logan.tif -fel loganfel4.tiff -4way" {
cd Base
run mpiexec -np 3  $TAUDEM_PATH/pitremove -z logan.tif -fel loganfel4.tiff -4way
assert_success
}
@test "run mpiexec -np 3 $TAUDEM_PATH/pitremove -z logan.tif -fel loganfeldm.tif -depmask logpitmask.tif" {
cd Base
run mpiexec -np 3  $TAUDEM_PATH/pitremove -z logan.tif -fel loganfeldm.tif -depmask logpitmask.tif
assert_success
}
@test "run mpiexec -np 3 $TAUDEM_PATH/pitremove -z logan.tif -fel loganfeldm4.tif -depmask logpitmask.tif -4way" {
cd Base
run mpiexec -np 3  $TAUDEM_PATH/pitremove -z logan.tif -fel loganfeldm4.tif -depmask logpitmask.tif -4way
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/d8flowdir -p loganp.tif -sd8 logansd8.tif -fel loganfel.tif" {
cd Base
run mpiexec -n 5  $TAUDEM_PATH/d8flowdir -p loganp.tif -sd8 logansd8.tif -fel loganfel.tif
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dinfflowdir -ang loganang.tif -slp loganslp.tif -fel loganfel.tif" {
cd Base
run mpiexec -n 4  $TAUDEM_PATH/dinfflowdir -ang loganang.tif -slp loganslp.tif -fel loganfel.tif
assert_success
}
@test "run mpiexec -n 6  $TAUDEM_PATH/d8flowdir -p loganpnf.tif -sd8 logansd8nf.tif -fel logan.tif" {
cd Base
run mpiexec -n 6  $TAUDEM_PATH/d8flowdir -p loganpnf.tif -sd8 logansd8nf.tif -fel logan.tif
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/dinfflowdir -ang loganangnf.tif -slp loganslpnf.tif -fel logan.tif" {
cd Base
run mpiexec -n 3  $TAUDEM_PATH/dinfflowdir -ang loganangnf.tif -slp loganslpnf.tif -fel logan.tif
assert_success
}
@test "run mpiexec -np 4  $TAUDEM_PATH/aread8 logan.tif" {
cd Base
run mpiexec -np 4  $TAUDEM_PATH/aread8 logan.tif
assert_success
}
@test "run mpiexec -np 12  $TAUDEM_PATH/areadinf logan.tif" {
cd Base
run mpiexec -np 12  $TAUDEM_PATH/areadinf logan.tif
assert_success
}
@test "run mpiexec -np 4  $TAUDEM_PATH/aread8 -p loganpnf.tif -ad8 loganad8nf.tif" {
cd Base
run mpiexec -np 4  $TAUDEM_PATH/aread8 -p loganpnf.tif -ad8 loganad8nf.tif
assert_success
}
@test "run mpiexec -np 12  $TAUDEM_PATH/areadinf -ang loganangnf.tif -sca loganscanf.tif" {
cd Base
run mpiexec -np 12  $TAUDEM_PATH/areadinf -ang loganangnf.tif -sca loganscanf.tif
assert_success
}
@test "run mpiexec -n 7  $TAUDEM_PATH/aread8 -p loganp.tif -o Outlet.shp -ad8 loganad8o.tif" {
cd Base
run mpiexec -n 7  $TAUDEM_PATH/aread8 -p loganp.tif -o Outlet.shp -ad8 loganad8o.tif
assert_success
}
@test "run mpiexec -n 1  $TAUDEM_PATH/areadinf -ang loganang.tif -o Outlet.shp -sca loganscao.tif" {
cd Base
run mpiexec -n 1  $TAUDEM_PATH/areadinf -ang loganang.tif -o Outlet.shp -sca loganscao.tif
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen.tif -tlen logantlen.tif -gord logangord.tif" {
cd Base
run mpiexec -n 5  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen.tif -tlen logantlen.tif -gord logangord.tif 
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen1.tif -tlen logantlen1.tif -gord logangord1.tif -mask loganad8.tif -thresh 100" {
cd Base
run mpiexec -n 5  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen1.tif -tlen logantlen1.tif -gord logangord1.tif -mask loganad8.tif -thresh 100 
assert_success
}
@test "run mpiexec -n 7  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen2.tif -tlen logantlen2.tif -gord logangord2.tif -o Outlet.shp" {
cd Base
run mpiexec -n 7  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen2.tif -tlen logantlen2.tif -gord logangord2.tif -o Outlet.shp 
assert_success
}

#stream network peuker douglas
@test "run mpiexec -np 7  $TAUDEM_PATH/peukerdouglas -fel loganfel.tif -ss loganss.tif" {
cd Base
run mpiexec -np 7  $TAUDEM_PATH/peukerdouglas -fel loganfel.tif -ss loganss.tif
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/aread8 -p loganp.tif -o Outlet.shp -ad8 loganssa.tif -wg loganss.tif" {
cd Base
run mpiexec -n 4  $TAUDEM_PATH/aread8 -p loganp.tif -o Outlet.shp -ad8 loganssa.tif -wg loganss.tif
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp.txt -o Outlet.shp -par 5 500 10 0" {
cd Base
run mpiexec -n 4  $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp.txt -o Outlet.shp -par 5 500 10 0 
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/threshold -ssa loganssa.tif -src logansrc.tif -thresh 180" {
cd Base
run mpiexec -n 5  $TAUDEM_PATH/threshold -ssa loganssa.tif -src logansrc.tif -thresh 180
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/streamnet -fel loganfel.tif -p loganp.tif -ad8 loganad8.tif -src logansrc.tif -ord loganord3.tif -tree logantree.dat -coord logancoord.dat -net logannet.shp -w loganw.tif -o Outlet.shp" {
cd Base
run mpiexec -n 5  $TAUDEM_PATH/streamnet -fel loganfel.tif -p loganp.tif -ad8 loganad8.tif -src logansrc.tif -ord loganord3.tif -tree logantree.dat -coord logancoord.dat -net logannet.shp -w loganw.tif -o Outlet.shp
assert_success
}


#stream network slope area
@test "run mpiexec -n 3  $TAUDEM_PATH/slopearea -slp loganslp.tif -sca logansca.tif -sa logansa.tif -par 2 1" {
cd Base
run mpiexec -n 3  $TAUDEM_PATH/slopearea -slp loganslp.tif -sca logansca.tif -sa logansa.tif -par 2 1
assert_success
}
@test "run mpiexec -n 8  $TAUDEM_PATH/d8flowpathextremeup -p loganp.tif -sa logansa.tif -ssa loganssa1.tif -o Outlet.shp" {
cd Base
run mpiexec -n 8  $TAUDEM_PATH/d8flowpathextremeup -p loganp.tif -sa logansa.tif -ssa loganssa1.tif -o Outlet.shp
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa1.tif -drp logandrp1.txt -o Outlet.shp -par 5000 50000 10 1" {
cd Base
run mpiexec -n 4  $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa1.tif -drp logandrp1.txt -o Outlet.shp -par 5000 50000 10 1 
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/threshold -ssa loganssa1.tif -src logansrc1.tif -thresh 15000" {
cd Base
run mpiexec -n 5  $TAUDEM_PATH/threshold -ssa loganssa1.tif -src logansrc1.tif -thresh 15000
assert_success
}
@test "run mpiexec -n 8  $TAUDEM_PATH/streamnet -fel loganfel.tif -p loganp.tif -ad8 loganad8.tif -src logansrc1.tif -ord loganord5.tif -tree logantree1.dat -coord logancoord1.dat -net logannet1.shp -w loganw1.tif -o Outlet.shp -sw" {
cd Base
run mpiexec -n 8  $TAUDEM_PATH/streamnet -fel loganfel.tif -p loganp.tif -ad8 loganad8.tif -src logansrc1.tif -ord loganord5.tif -tree logantree1.dat -coord logancoord1.dat -net logannet1.shp -w loganw1.tif -o Outlet.shp -sw
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/lengtharea -plen loganplen.tif -ad8 loganad8.tif -ss loganlass.tif -par 0.03 1.3" {
cd Base
run mpiexec -n 3  $TAUDEM_PATH/lengtharea -plen loganplen.tif -ad8 loganad8.tif -ss loganlass.tif -par 0.03 1.3
assert_success
}

#Specialized grid analysis
@test "run mpiexec -n 3  $TAUDEM_PATH/slopearearatio -slp loganslp.tif -sca logansca.tif -sar logansar.tiff" {
cd Base
run mpiexec -n 3  $TAUDEM_PATH/slopearearatio -slp loganslp.tif -sca logansca.tif -sar logansar.tiff
assert_success
}
@test "run mpiexec -np 7  $TAUDEM_PATH/d8hdisttostrm -p loganp.tif -src loganad8.tif -dist logandist1.tif -thresh 200" {
cd Base
run mpiexec -np 7  $TAUDEM_PATH/d8hdisttostrm -p loganp.tif -src loganad8.tif -dist logandist1.tif -thresh 200 
assert_success
}
@test "run mpiexec -np 5  $TAUDEM_PATH/d8hdisttostrm -p loganp.tif -src logansrc.tif -dist logandist.tif" {
cd Base
run mpiexec -np 5  $TAUDEM_PATH/d8hdisttostrm -p loganp.tif -src logansrc.tif -dist logandist.tif 
assert_success
}

#downslope influence
@test "run mpiexec -np 1  $TAUDEM_PATH/areadinf -ang loganang.tif -wg logandg.tif -sca logandi.tif" {
cd Base
run mpiexec -np 1  $TAUDEM_PATH/areadinf -ang loganang.tif -wg logandg.tif -sca logandi.tif
assert_success
}
@test "run mpiexec -n 2  $TAUDEM_PATH/dinfupdependence -ang loganang.tif -dg logandg.tif -dep logandep.tif" {
cd Base
run mpiexec -n 2  $TAUDEM_PATH/dinfupdependence -ang loganang.tif -dg logandg.tif -dep logandep.tif
assert_success
}
@test "run mpiexec -n 7  $TAUDEM_PATH/dinfdecayaccum -ang loganang.tif -dm logandm08.tif -dsca logandsca.tif" {
cd Base
run mpiexec -n 7  $TAUDEM_PATH/dinfdecayaccum -ang loganang.tif -dm logandm08.tif -dsca logandsca.tif 
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/dinfconclimaccum -ang loganang.tif -dm logandm08.tif -dg logandg.tif -ctpt loganctpt.tif -q logansca.tif" {
cd Base
run mpiexec -n 3  $TAUDEM_PATH/dinfconclimaccum -ang loganang.tif -dm logandm08.tif -dg logandg.tif -ctpt loganctpt.tif -q logansca.tif 
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/dinfconclimaccum -ang loganang.tif -dm logandm08.tif -dg logandg.tif -ctpt loganctpto.tif -q logansca.tif  -o Outlet.shp -csol 2.4" {
cd Base
run mpiexec -n 5  $TAUDEM_PATH/dinfconclimaccum -ang loganang.tif -dm logandm08.tif -dg logandg.tif -ctpt loganctpto.tif -q logansca.tif  -o Outlet.shp -csol 2.4
assert_success
}

#Trans lim accum
@test "run mpiexec -n 7  $TAUDEM_PATH/dinftranslimaccum -ang loganang.tif -tsup logantsup.tif -tc logantc.tif -tla logantla.tif -tdep logantdep.tif" {
cd Base
run mpiexec -n 7  $TAUDEM_PATH/dinftranslimaccum -ang loganang.tif -tsup logantsup.tif -tc logantc.tif -tla logantla.tif -tdep logantdep.tif
assert_success
}
@test "run mpiexec -n 6  $TAUDEM_PATH/dinftranslimaccum -ang loganang.tif -tsup logantsup.tif -tc logantc.tif -tla logantla1.tif -tdep logantdep1.tif -o Outlet.shp -cs logandg.tif -ctpt loganctpt1.tif" {
cd Base
run mpiexec -n 6  $TAUDEM_PATH/dinftranslimaccum -ang loganang.tif -tsup logantsup.tif -tc logantc.tif -tla logantla1.tif -tdep logantdep1.tif -o Outlet.shp -cs logandg.tif -ctpt loganctpt1.tif 
assert_success
}

#REVERSE ACCUMULATION
@test "run mpiexec -n 4  $TAUDEM_PATH/dinfrevaccum -ang loganang.tif -wg logandg.tif -racc loganracc.tif -dmax loganrdmax.tif" {
cd Base
run mpiexec -n 4  $TAUDEM_PATH/dinfrevaccum -ang loganang.tif -wg logandg.tif -racc loganracc.tif -dmax loganrdmax.tif
assert_success
}

#MOVEOUTLETS
@test "run mpiexec -n 5  $TAUDEM_PATH/threshold -ssa loganad8.tif -src logansrc2.tif -thresh 200" {
cd Base
run mpiexec -n 5  $TAUDEM_PATH/threshold -ssa loganad8.tif -src logansrc2.tif -thresh 200
assert_success
}
@test "run mpiexec -np 3  $TAUDEM_PATH/moveoutletstostreams -p loganp.tif -src logansrc.tif -o OutletstoMove.shp -om Outletsmoved.shp -md 20" {
cd Base
run mpiexec -np 3  $TAUDEM_PATH/moveoutletstostreams -p loganp.tif -src logansrc.tif -o OutletstoMove.shp -om Outletsmoved.shp -md 20 
assert_success
}

#DISTDOWN
@test "run mpiexec -n 1  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddhave.tif" {
cd Base
run mpiexec -n 1  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddhave.tif
assert_success
}
@test "run mpiexec -n 2  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddhmin.tif -m min h" {
cd Base
run mpiexec -n 2  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddhmin.tif -m min h
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddhmax.tif -m max h" {
cd Base
run mpiexec -n 3  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddhmax.tif -m max h
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddvave.tif -m ave v" {
cd Base
run mpiexec -n 4  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddvave.tif -m ave v
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddvmin.tif -m min v" {
cd Base
run mpiexec -n 5  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddvmin.tif -m min v
assert_success
}
@test "run mpiexec -n 6  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddvmax.tif -m max v" {
cd Base
run mpiexec -n 6  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddvmax.tif -m max v
assert_success
}
@test "run mpiexec -n 7  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddsave.tif -m ave s" {
cd Base
run mpiexec -n 7  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddsave.tif -m ave s
assert_success
}
@test "run mpiexec -n 8  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddsmin.tif -m min s" {
cd Base
run mpiexec -n 8  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddsmin.tif -m min s
assert_success
}
@test "run mpiexec -n 1  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddsmax.tif -m max s" {
cd Base
run mpiexec -n 1  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddsmax.tif -m max s
assert_success
}
@test "run mpiexec -n 2  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddpave.tif -m ave p" {
cd Base
run mpiexec -n 2  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddpave.tif -m ave p
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddpmin.tif -m min p" {
cd Base
run mpiexec -n 3  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddpmin.tif -m min p
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddpmax.tif -m max p" {
cd Base
run mpiexec -n 4  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddpmax.tif -m max p
assert_success
}
@test "run mpiexec -n 2  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddvavenc.tif -m ave v -nc" {
cd Base
run mpiexec -n 2  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddvavenc.tif -m ave v -nc
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddhminnc.tif -m min h -nc" {
cd Base
run mpiexec -n 3  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddhminnc.tif -m min h -nc
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddpmaxnc.tif -m max p -nc" {
cd Base
run mpiexec -n 4  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddpmaxnc.tif -m max p -nc
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddsmaxnc.tif -m max s -nc" {
cd Base
run mpiexec -n 4  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddsmaxnc.tif -m max s -nc
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddsmaxwg.tif -m max s -wg logandwg.tif" {
cd Base
run mpiexec -n 4  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddsmaxwg.tif -m max s -wg logandwg.tif
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddhavewg.tif -m ave h -wg logandwg.tif" {
cd Base
run mpiexec -n 4  $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddhavewg.tif -m ave h -wg logandwg.tif
assert_success
}

#DISTANCE UP
@test "run mpiexec -n 1  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduhave.tif" {
cd Base
run mpiexec -n 1  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduhave.tif
assert_success
}
@test "run mpiexec -n 2  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduhmin.tif -m min h -thresh 0.5" {
cd Base
run mpiexec -n 2  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduhmin.tif -m min h -thresh 0.5
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduhmax.tif -m max h -thresh 0.8" {
cd Base
run mpiexec -n 3  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduhmax.tif -m max h -thresh 0.8
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduvave.tif -m ave v" {
cd Base
run mpiexec -n 4  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduvave.tif -m ave v
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduvmin.tif -m min v" {
cd Base
run mpiexec -n 5  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduvmin.tif -m min v
assert_success
}
@test "run mpiexec -n 6  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduvmax.tif -m max v" {
cd Base
run mpiexec -n 6  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduvmax.tif -m max v
assert_success
}
@test "run mpiexec -n 7  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandusave.tif -m ave s -thresh 0.9" {
cd Base
run mpiexec -n 7  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandusave.tif -m ave s -thresh 0.9
assert_success
}
@test "run mpiexec -n 8  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandusmin.tif -m min s" {
cd Base
run mpiexec -n 8  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandusmin.tif -m min s
assert_success
}
@test "run mpiexec -n 1  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandusmax.tif -m max s" {
cd Base
run mpiexec -n 1  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandusmax.tif -m max s
assert_success
}
@test "run mpiexec -n 2  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandupave.tif -m ave p" {
cd Base
run mpiexec -n 2  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandupave.tif -m ave p
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandupmin.tif -m min p" {
cd Base
run mpiexec -n 3  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandupmin.tif -m min p
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandupmax.tif -m max p" {
cd Base
run mpiexec -n 4  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandupmax.tif -m max p
assert_success
}
@test "run mpiexec -n 2  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduvavenc.tif -m ave v -nc" {
cd Base
run mpiexec -n 2  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduvavenc.tif -m ave v -nc
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduhminnc.tif -m min h -nc" {
cd Base
run mpiexec -n 3  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduhminnc.tif -m min h -nc
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandupmaxnc.tif -m max p -nc" {
cd Base
run mpiexec -n 4  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandupmaxnc.tif -m max p -nc
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandusmaxnc.tif -m max s -nc" {
cd Base
run mpiexec -n 4  $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandusmaxnc.tif -m max s -nc
assert_success
}

#AVALANCHE
@test "run mpiexec -n 2  $TAUDEM_PATH/dinfavalanche -ang loganang.tif -fel loganfel.tif -ass loganass.tif -rz loganrz.tif -dfs logandfs.tif" {
cd Base
run mpiexec -n 2  $TAUDEM_PATH/dinfavalanche -ang loganang.tif -fel loganfel.tif -ass loganass.tif -rz loganrz.tif -dfs logandfs.tif
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/dinfavalanche -ang loganang.tif -fel loganfel.tif -ass loganass.tif -rz loganrz1.tif -dfs logandfs1.tif -thresh 0.1 -alpha 10" {
cd Base
run mpiexec -n 3  $TAUDEM_PATH/dinfavalanche -ang loganang.tif -fel loganfel.tif -ass loganass.tif -rz loganrz1.tif -dfs logandfs1.tif -thresh 0.1 -alpha 10
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dinfavalanche -ang loganang.tif -fel loganfel.tif -ass loganass.tif -rz loganrz2.tif -dfs logandfs2.tif -direct -thresh 0.01 -alpha 5" {
cd Base
run mpiexec -n 4  $TAUDEM_PATH/dinfavalanche -ang loganang.tif -fel loganfel.tif -ass loganass.tif -rz loganrz2.tif -dfs logandfs2.tif -direct -thresh 0.01 -alpha 5
assert_success
}

#SLOPEAVEDOWN
@test "run mpiexec -n 3  $TAUDEM_PATH/slopeavedown -p loganp.tif -fel loganfel.tif -slpd loganslpd.tif" {
cd Base
run mpiexec -n 3  $TAUDEM_PATH/slopeavedown -p loganp.tif -fel loganfel.tif -slpd loganslpd.tif
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/slopeavedown -p loganp.tif -fel loganfel.tif -slpd loganslpd1.tif -dn 1000" {
cd Base
run mpiexec -n 3  $TAUDEM_PATH/slopeavedown -p loganp.tif -fel loganfel.tif -slpd loganslpd1.tif -dn 1000
assert_success
}

#test case for tiffio partitions within a stripe
@test "run mpiexec -n 6  $TAUDEM_PATH/areadinf -ang topo3fel1ang.tif -sca topo3fel1sca.tif" {
cd Base
run mpiexec -n 6  $TAUDEM_PATH/areadinf -ang topo3fel1ang.tif -sca topo3fel1sca.tif 
assert_success
}

#test case for double precision file
@test "run mpiexec -n 4  $TAUDEM_PATH/areadinf -ang demDoubleang.tif -sca demDoublesca.tif -wg demDoublewgt.tif" {
cd Base
run mpiexec -n 4  $TAUDEM_PATH/areadinf -ang demDoubleang.tif -sca demDoublesca.tif -wg demDoublewgt.tif
assert_success
}

#gagewatershed test
@test "run mpiexec -n 7  $TAUDEM_PATH/gagewatershed -p loganp.tif -o Outletsmoved.shp -gw logangw.tif -id gwid.txt" {
cd Base
run mpiexec -n 7  $TAUDEM_PATH/gagewatershed -p loganp.tif -o Outletsmoved.shp -gw logangw.tif -id gwid.txt
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/gagewatershed -p loganp.tif -o Outletsmoved.shp -gw logangw1.tif" {
cd Base
run mpiexec -n 4  $TAUDEM_PATH/gagewatershed -p loganp.tif -o Outletsmoved.shp -gw logangw1.tif 
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/gagewatershed -p logantp.img -o Outletsmoved2.shp -gw logangw1.tif -id gwid1.txt -upid gwup.txt" {
cd Base
run mpiexec -n 5  $TAUDEM_PATH/gagewatershed -p logantp.img -o Outletsmoved2.shp -gw logangw1.tif -id gwid1.txt -upid gwup.txt
assert_success
}

#Connect down
#@test "run mpiexec -n 8  $TAUDEM_PATH/connectdown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganOutlets.shp -od loganOutlets_Moved.shp -d 1" {
#cd Base
#run mpiexec -n 8  $TAUDEM_PATH/connectdown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganOutlets.shp -od loganOutlets_Moved.shp -d 1
#assert_success
#}

####################################################################
####################################################################

#tests on ft steward data with stream buffer
@test "run mpiexec -n 3  $TAUDEM_PATH/pitremove fs_small.tif" {
cd fts
run mpiexec -n 3  $TAUDEM_PATH/pitremove fs_small.tif
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dinfflowdir fs_small.tif" {
cd fts
run mpiexec -n 4  $TAUDEM_PATH/dinfflowdir fs_small.tif
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/d8flowdir fs_small.tif" {
cd fts
run mpiexec -n 4  $TAUDEM_PATH/d8flowdir fs_small.tif
assert_success
}
@test "run mpiexec -n 1  $TAUDEM_PATH/aread8 fs_small.tif" {
cd fts
run mpiexec -n 1  $TAUDEM_PATH/aread8 fs_small.tif
assert_success
}
@test "run mpiexec -n 2  $TAUDEM_PATH/threshold -ssa fs_smallad8.tif -src fs_smallsrc.tif -thresh 500" {
cd fts
run mpiexec -n 2  $TAUDEM_PATH/threshold -ssa fs_smallad8.tif -src fs_smallsrc.tif -thresh 500
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/dinfdistdown -ang fs_smallang.tif -fel fs_smallfel.tif -src fs_smallsrc.tif -dd fs_smallddhavewg.tif -m ave h -wg streambuffreclass2.tif" {
cd fts
run mpiexec -n 5  $TAUDEM_PATH/dinfdistdown -ang fs_smallang.tif -fel fs_smallfel.tif -src fs_smallsrc.tif -dd fs_smallddhavewg.tif -m ave h -wg streambuffreclass2.tif
assert_success
}

####################################################################
####################################################################

#test with compressed 16 bit unsigned integer that a user had trouble with
@test "run mpiexec -n 8  $TAUDEM_PATH/pitremove MED_01_01.tif" {
cd Base
run mpiexec -n 8  $TAUDEM_PATH/pitremove MED_01_01.tif
assert_success
}

#test with VRT format
@test "run mpiexec -n 8  $TAUDEM_PATH/pitremove -z LoganVRT/output.vrt -fel loganvrtfel.tif" {
cd Base
run mpiexec -n 8  $TAUDEM_PATH/pitremove -z LoganVRT/output.vrt -fel loganvrtfel.tif
assert_success
}

#test with img file format
@test "run mpiexec -n 8  $TAUDEM_PATH/pitremove -z loganIMG/logan.img -fel loganimgfel.tif" {
cd Base
run mpiexec -n 8  $TAUDEM_PATH/pitremove -z loganIMG/logan.img -fel loganimgfel.tif
assert_success
}

#test with ESRIGRID file format
@test "run mpiexec -n 8  $TAUDEM_PATH/pitremove -z loganESRIGRID/logan -fel loganesrigridfel.tif" {
cd Base
run mpiexec -n 8  $TAUDEM_PATH/pitremove -z loganESRIGRID/logan -fel loganesrigridfel.tif
assert_success
}

####################################################################
####################################################################


# Basic grid analysis
@test "run mpiexec -np 3  $TAUDEM_PATH/pitremove enogeo.tif" {
cd Geographic
run mpiexec -np 3  $TAUDEM_PATH/pitremove enogeo.tif  
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/d8flowdir -p enogeop.tif -sd8 enogeosd8.tif -fel enogeofel.tif" {
cd Geographic
run mpiexec -n 5  $TAUDEM_PATH/d8flowdir -p enogeop.tif -sd8 enogeosd8.tif -fel enogeofel.tif 
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dinfflowdir -ang enogeoang.tif -slp enogeoslp.tif -fel enogeofel.tif" {
cd Geographic
run mpiexec -n 4  $TAUDEM_PATH/dinfflowdir -ang enogeoang.tif -slp enogeoslp.tif -fel enogeofel.tif
assert_success
}
@test "run mpiexec -np 4  $TAUDEM_PATH/aread8 enogeo.tif" {
cd Geographic
run mpiexec -np 4  $TAUDEM_PATH/aread8 enogeo.tif
assert_success
}
@test "run mpiexec -np 12  $TAUDEM_PATH/areadinf enogeo.tif" {
cd Geographic
run mpiexec -np 12  $TAUDEM_PATH/areadinf enogeo.tif
assert_success
}
@test "run mpiexec -n 7  $TAUDEM_PATH/aread8 -p enogeop.tif -o Outlets.shp -ad8 enogeoad8o.tif" {
cd Geographic
run mpiexec -n 7  $TAUDEM_PATH/aread8 -p enogeop.tif -o Outlets.shp -ad8 enogeoad8o.tif
assert_success
}
@test "run mpiexec -n 1  $TAUDEM_PATH/areadinf -ang enogeoang.tif -o Outlets.shp -sca enogeoscao.tif" {
cd Geographic
run mpiexec -n 1  $TAUDEM_PATH/areadinf -ang enogeoang.tif -o Outlets.shp -sca enogeoscao.tif
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/gridnet -p enogeop.tif -plen enogeoplen.tif -tlen enogeotlen.tif -gord enogeogord.tif" {
cd Geographic
run mpiexec -n 5  $TAUDEM_PATH/gridnet -p enogeop.tif -plen enogeoplen.tif -tlen enogeotlen.tif -gord enogeogord.tif 
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/gridnet -p enogeop.tif -plen enogeoplen1.tif -tlen enogeotlen1.tif -gord enogeogord1.tif -mask enogeoad8.tif -thresh 100" {
cd Geographic
run mpiexec -n 5  $TAUDEM_PATH/gridnet -p enogeop.tif -plen enogeoplen1.tif -tlen enogeotlen1.tif -gord enogeogord1.tif -mask enogeoad8.tif -thresh 100 
assert_success
}
@test "run mpiexec -n 7  $TAUDEM_PATH/gridnet -p enogeop.tif -plen enogeoplen2.tif -tlen enogeotlen2.tif -gord enogeogord2.tif -o Outlets.shp" {
cd Geographic
run mpiexec -n 7  $TAUDEM_PATH/gridnet -p enogeop.tif -plen enogeoplen2.tif -tlen enogeotlen2.tif -gord enogeogord2.tif -o Outlets.shp 
assert_success
}

#stream network peuker douglas
@test "run mpiexec -np 7  $TAUDEM_PATH/peukerdouglas -fel enogeofel.tif -ss enogeoss.tiff" {
cd Geographic
run mpiexec -np 7  $TAUDEM_PATH/peukerdouglas -fel enogeofel.tif -ss enogeoss.tiff
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/aread8 -p enogeop.tif -o Outlets.shp -ad8 enogeossa.tif -wg enogeoss.tiff" {
cd Geographic
run mpiexec -n 4  $TAUDEM_PATH/aread8 -p enogeop.tif -o Outlets.shp -ad8 enogeossa.tif -wg enogeoss.tiff
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dropanalysis -p enogeop.tif -fel enogeofel.tif -ad8 enogeoad8.tif -ssa enogeossa.tif -drp enogeodrp.txt -o Outlets.shp -par 5 500 10 0" {
cd Geographic
run mpiexec -n 4  $TAUDEM_PATH/dropanalysis -p enogeop.tif -fel enogeofel.tif -ad8 enogeoad8.tif -ssa enogeossa.tif -drp enogeodrp.txt -o Outlets.shp -par 5 500 10 0 
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/threshold -ssa enogeossa.tif -src enogeosrc.tif -thresh 180" {
cd Geographic
run mpiexec -n 5  $TAUDEM_PATH/threshold -ssa enogeossa.tif -src enogeosrc.tif -thresh 180
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/streamnet -fel enogeofel.tif -p enogeop.tif -ad8 enogeoad8.tif -src enogeosrc.tif -ord enogeoord3.tif -tree enogeotree.dat -coord enogeocoord.dat -net enogeonet.shp -w enogeow.tif -o Outlets.shp" {
cd Geographic
run mpiexec -n 5  $TAUDEM_PATH/streamnet -fel enogeofel.tif -p enogeop.tif -ad8 enogeoad8.tif -src enogeosrc.tif -ord enogeoord3.tif -tree enogeotree.dat -coord enogeocoord.dat -net enogeonet.shp -w enogeow.tif -o Outlets.shp
assert_success
}

#stream network slope area
@test "run mpiexec -n 3  $TAUDEM_PATH/slopearea -slp enogeoslp.tif -sca enogeosca.tif -sa enogeosa.tif -par 2 1" {
cd Geographic
run mpiexec -n 3  $TAUDEM_PATH/slopearea -slp enogeoslp.tif -sca enogeosca.tif -sa enogeosa.tif -par 2 1
assert_success
}
@test "run mpiexec -n 8  $TAUDEM_PATH/d8flowpathextremeup -p enogeop.tif -sa enogeosa.tif -ssa enogeossa1.tif -o Outlets.shp" {
cd Geographic
run mpiexec -n 8  $TAUDEM_PATH/d8flowpathextremeup -p enogeop.tif -sa enogeosa.tif -ssa enogeossa1.tif -o Outlets.shp
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dropanalysis -p enogeop.tif -fel enogeofel.tif -ad8 enogeoad8.tif -ssa enogeossa1.tif -drp enogeodrp1.txt -o Outlets.shp -par 10 2000 10 1" {
cd Geographic
run mpiexec -n 4  $TAUDEM_PATH/dropanalysis -p enogeop.tif -fel enogeofel.tif -ad8 enogeoad8.tif -ssa enogeossa1.tif -drp enogeodrp1.txt -o Outlets.shp -par 10 2000 10 1 
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/threshold -ssa enogeossa1.tif -src enogeosrc1.tif -thresh 32" {
cd Geographic
run mpiexec -n 5  $TAUDEM_PATH/threshold -ssa enogeossa1.tif -src enogeosrc1.tif -thresh 32
assert_success
}
@test "run mpiexec -n 8  $TAUDEM_PATH/streamnet -fel enogeofel.tif -p enogeop.tif -ad8 enogeoad8.tif -src enogeosrc1.tif -ord enogeoord5.tif -tree enogeotree1.dat -coord enogeocoord1.dat -net enogeonet1.shp -w enogeow1.tif -o Outlets.shp -sw" {
cd Geographic
run mpiexec -n 8  $TAUDEM_PATH/streamnet -fel enogeofel.tif -p enogeop.tif -ad8 enogeoad8.tif -src enogeosrc1.tif -ord enogeoord5.tif -tree enogeotree1.dat -coord enogeocoord1.dat -net enogeonet1.shp -w enogeow1.tif -o Outlets.shp -sw
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/lengtharea -plen enogeoplen.tif -ad8 enogeoad8.tif -ss enogeolass.tif -par 0.03 1.3" {
cd Geographic
run mpiexec -n 3  $TAUDEM_PATH/lengtharea -plen enogeoplen.tif -ad8 enogeoad8.tif -ss enogeolass.tif -par 0.03 1.3
assert_success
}

#Specialized grid analysis
@test "run mpiexec -n 3  $TAUDEM_PATH/slopearearatio -slp enogeoslp.tif -sca enogeosca.tif -sar enogeosar.tif" {
cd Geographic
run mpiexec -n 3  $TAUDEM_PATH/slopearearatio -slp enogeoslp.tif -sca enogeosca.tif -sar enogeosar.tif
assert_success
}
@test "run mpiexec -np 7  $TAUDEM_PATH/d8hdisttostrm -p enogeop.tif -src enogeoad8.tif -dist enogeodist1.tif -thresh 200" {
cd Geographic
run mpiexec -np 7  $TAUDEM_PATH/d8hdisttostrm -p enogeop.tif -src enogeoad8.tif -dist enogeodist1.tif -thresh 200 
assert_success
}
@test "run mpiexec -np 5  $TAUDEM_PATH/d8hdisttostrm -p enogeop.tif -src enogeosrc.tif -dist enogeodist.tif" {
cd Geographic
run mpiexec -np 5  $TAUDEM_PATH/d8hdisttostrm -p enogeop.tif -src enogeosrc.tif -dist enogeodist.tif 
assert_success
}

#MOVEOUTLETS
@test "run mpiexec -n 5  $TAUDEM_PATH/threshold -ssa enogeoad8.tif -src enogeosrc2.tif -thresh 200" {
cd Geographic
run mpiexec -n 5  $TAUDEM_PATH/threshold -ssa enogeoad8.tif -src enogeosrc2.tif -thresh 200
assert_success
}
@test "run mpiexec -np 3  $TAUDEM_PATH/moveoutletstostreams -p enogeop.tif -src enogeosrc.tif -o Outlets.shp -om Outletsmoved.shp -md 20" {
cd Geographic
run mpiexec -np 3  $TAUDEM_PATH/moveoutletstostreams -p enogeop.tif -src enogeosrc.tif -o Outlets.shp -om Outletsmoved.shp -md 20 
assert_success
}

#DISTDOWN
@test "run mpiexec -n 1  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddhave.tif" {
cd Geographic
run mpiexec -n 1  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddhave.tif
assert_success
}
@test "run mpiexec -n 2  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddhmin.tif -m min h" {
cd Geographic
run mpiexec -n 2  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddhmin.tif -m min h
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddhmax.tif -m max h" {
cd Geographic
run mpiexec -n 3  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddhmax.tif -m max h
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddvave.tif -m ave v" {
cd Geographic
run mpiexec -n 4  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddvave.tif -m ave v
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddvmin.tif -m min v" {
cd Geographic
run mpiexec -n 5  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddvmin.tif -m min v
assert_success
}
@test "run mpiexec -n 6  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddvmax.tif -m max v" {
cd Geographic
run mpiexec -n 6  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddvmax.tif -m max v
assert_success
}
@test "run mpiexec -n 7  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddsave.tif -m ave s" {
cd Geographic
run mpiexec -n 7  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddsave.tif -m ave s
assert_success
}
@test "run mpiexec -n 8  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddsmin.tif -m min s" {
cd Geographic
run mpiexec -n 8  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddsmin.tif -m min s
assert_success
}
@test "run mpiexec -n 1  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddsmax.tif -m max s" {
cd Geographic
run mpiexec -n 1  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddsmax.tif -m max s
assert_success
}
@test "run mpiexec -n 2  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddpave.tif -m ave p" {
cd Geographic
run mpiexec -n 2  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddpave.tif -m ave p
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddpmin.tif -m min p" {
cd Geographic
run mpiexec -n 3  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddpmin.tif -m min p
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddpmax.tif -m max p" {
cd Geographic
run mpiexec -n 4  $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddpmax.tif -m max p
assert_success
}

#DISTANCE UP
@test "run mpiexec -n 1  $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeoduhave.tif" {
cd Geographic
run mpiexec -n 1  $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeoduhave.tif
assert_success
}
@test "run mpiexec -n 2  $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeoduhmin.tif -m min h -thresh 0.5" {
cd Geographic
run mpiexec -n 2  $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeoduhmin.tif -m min h -thresh 0.5
assert_success
}
@test "run mpiexec -n 6  $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeoduvmax.tif -m max v" {
cd Geographic
run mpiexec -n 6  $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeoduvmax.tif -m max v
assert_success
}
@test "run mpiexec -n 7  $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeodusave.tif -m ave s -thresh 0.9" {
cd Geographic
run mpiexec -n 7  $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeodusave.tif -m ave s -thresh 0.9
assert_success
}
@test "run mpiexec -n 8  $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeodusmin.tif -m min s" {
cd Geographic
run mpiexec -n 8  $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeodusmin.tif -m min s
assert_success
}
@test "run mpiexec -n 1  $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeodusmax.tif -m max s" {
cd Geographic
run mpiexec -n 1  $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeodusmax.tif -m max s
assert_success
}
@test "run mpiexec -n 2  $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeodupave.tif -m ave p" {
cd Geographic
run mpiexec -n 2  $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeodupave.tif -m ave p
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeodupmin.tif -m min p" {
cd Geographic
run mpiexec -n 3  $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeodupmin.tif -m min p
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeodupmax.tif -m max p" {
cd Geographic
run mpiexec -n 4  $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeodupmax.tif -m max p
assert_success
}

#SLOPEAVEDOWN
@test "run mpiexec -n 3  $TAUDEM_PATH/slopeavedown -p enogeop.tif -fel enogeofel.tif -slpd enogeoslpd.tif" {
cd Geographic
run mpiexec -n 3  $TAUDEM_PATH/slopeavedown -p enogeop.tif -fel enogeofel.tif -slpd enogeoslpd.tif
assert_success
}

#gagewatershed test
@test "run mpiexec -n 7  $TAUDEM_PATH/gagewatershed -p enogeop.tif -o Outletsmoved.shp -gw enogeogw.tif -id gwid.txt" {
cd Geographic
run mpiexec -n 7  $TAUDEM_PATH/gagewatershed -p enogeop.tif -o Outletsmoved.shp -gw enogeogw.tif -id gwid.txt
assert_success
}


####################################################################
####################################################################

# Testing different file extensions
@test "run mpiexec -np 3  $TAUDEM_PATH/pitremove logan.tif" {
cd gridtypes
run mpiexec -np 3  $TAUDEM_PATH/pitremove logan.tif
assert_success
}
@test "run mpiexec -np 3  $TAUDEM_PATH/pitremove -z logan.tif -fel loganfelim.img" {
cd gridtypes
run mpiexec -np 3  $TAUDEM_PATH/pitremove -z logan.tif -fel loganfelim.img
assert_success
}
@test "run mpiexec -np 3  $TAUDEM_PATH/pitremove -z logan.tif -fel loganfelsd.sdat" {
cd gridtypes
run mpiexec -np 3  $TAUDEM_PATH/pitremove -z logan.tif -fel loganfelsd.sdat
assert_success
}
@test "run mpiexec -np 3  $TAUDEM_PATH/pitremove -z logan.tif -fel loganfel.bil" {
cd gridtypes
run mpiexec -np 3  $TAUDEM_PATH/pitremove -z logan.tif -fel loganfel.bil
assert_success
}
@test "run mpiexec -np 3  $TAUDEM_PATH/pitremove -z logan.tif -fel loganfel1.bin" {
cd gridtypes
run mpiexec -np 3  $TAUDEM_PATH/pitremove -z logan.tif -fel loganfel1.bin
assert_success
}
# THIS IS A DUPLICATE OF THE TEST ABOVE (line 824)
# @test "run mpiexec -np 3  $TAUDEM_PATH/pitremove -z logan.tif -fel loganfel.bil" {
# cd gridtypes
# run mpiexec -np 3  $TAUDEM_PATH/pitremove -z logan.tif -fel loganfel.bil
# assert_success
# }
@test "run mpiexec -np 3  $TAUDEM_PATH/d8flowdir -fel loganfel1.bin -p bilp.bil -sd8 binsd8.bin" {
cd gridtypes
run mpiexec -np 3  $TAUDEM_PATH/d8flowdir -fel loganfel1.bin -p bilp.bil -sd8 binsd8.bin
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/aread8 -p bilp.bil -ad8 loganad8.img" {
cd gridtypes
run mpiexec -n 5  $TAUDEM_PATH/aread8 -p bilp.bil -ad8 loganad8.img
assert_success
}
@test "run mpiexec -n 2  $TAUDEM_PATH/dinfflowdir -fel loganfel.bil -ang ang.ang -slp slp.slp" {
cd gridtypes
run mpiexec -n 2  $TAUDEM_PATH/dinfflowdir -fel loganfel.bil -ang ang.ang -slp slp.slp
assert_success
}
@test "run mpiexec -np 3  $TAUDEM_PATH/pitremove -z logan.tif -fel loganfel2.lg" {
cd gridtypes
run mpiexec -np 3  $TAUDEM_PATH/pitremove -z logan.tif -fel loganfel2.lg
assert_success
}
@test "run mpiexec -np 3  $TAUDEM_PATH/pitremove -z logan.tif -fel loganfel3" {
cd gridtypes
run mpiexec -np 3  $TAUDEM_PATH/pitremove -z logan.tif -fel loganfel3
assert_success
}

#Testing SinmapSI
@test "run mpiexec -n 1  $TAUDEM_PATH/sinmapsi -slp dmslp.tif -sca dmsca.tif -calpar dmcalp.txt -cal dmcal.tif -si dmsi.tif -sat dmsat.tif -par 0.0009 0.00135 9.81 1000" {
cd sinmapsi
run mpiexec -n 1  $TAUDEM_PATH/sinmapsi -slp dmslp.tif -sca dmsca.tif -calpar dmcalp.txt -cal dmcal.tif -si dmsi.tif -sat dmsat.tif -par 0.0009 0.00135 9.81 1000
assert_success
}

#Testing with Sinmap manual example
@test "run mpiexec -n 4  $TAUDEM_PATH/pitremove dem" {
cd sinmapsi
run mpiexec -n 4  $TAUDEM_PATH/pitremove dem
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/dinfflowdir -fel demfel.tif -slp demslp.tif -ang demang.tif" {
cd sinmapsi
run mpiexec -n 4  $TAUDEM_PATH/dinfflowdir -fel demfel.tif -slp demslp.tif -ang demang.tif
assert_success
}
@test "run mpiexec -n 2  $TAUDEM_PATH/areadinf -ang demang.tif -sca demsca.tif" {
cd sinmapsi
run mpiexec -n 2  $TAUDEM_PATH/areadinf -ang demang.tif -sca demsca.tif
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/sinmapsi -slp demslp.tif -sca demsca.tif -cal demreg12.tif -calpar dempar12.csv -si demsi1.tif -sat demsat1.tif -par 0.0009 0.00135 9.81 1000" {
cd sinmapsi
run mpiexec -n 3  $TAUDEM_PATH/sinmapsi -slp demslp.tif -sca demsca.tif -cal demreg12.tif -calpar dempar12.csv -si demsi1.tif -sat demsat1.tif -par 0.0009 0.00135 9.81 1000
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/sinmapsi -slp demslp.tif -sca demsca.tif -cal demregsh.tif -calpar demparsh.dat -si demsi2.tif -sat demsat2.tif -par 0.0009 0.00135 9.81 1000" {
cd sinmapsi
run mpiexec -n 3  $TAUDEM_PATH/sinmapsi -slp demslp.tif -sca demsca.tif -cal demregsh.tif -calpar demparsh.dat -si demsi2.tif -sat demsat2.tif -par 0.0009 0.00135 9.81 1000
assert_success
}

# Setregion function which defines a region with the indicated ID if either it is in the gw file or has flow going to it, even though its flow direction may be no data
@test "mpiexec -n 3 $TAUDEM_PATH/setregion -p fdrsubset.tif -gw gwsubset.tif -out region3.tif -id 3" {
cd SetRegion
run mpiexec -n 3  $TAUDEM_PATH/setregion -p fdrsubset.tif -gw gwsubset.tif -out region3.tif -id 3
assert_success
}


#Testing of OGR starts here 
@test "run mpiexec -n 7  $TAUDEM_PATH/aread8 -p loganp.tif -o LoganOutlet.shp -ad8 loganad8_1.tif" {
cd AreaD8_data
run mpiexec -n 7  $TAUDEM_PATH/aread8 -p loganp.tif -o LoganOutlet.shp -ad8 loganad8_1.tif
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/aread8 -p loganp.tif -o LoganSample.sqlite -lyrname LoganOutlet -ad8 loganad8_3.tif" {
cd AreaD8_data
run mpiexec -n 3  $TAUDEM_PATH/aread8 -p loganp.tif -o LoganSample.sqlite -lyrname LoganOutlet -ad8 loganad8_3.tif
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/aread8 -p loganp.tif -o LoganOutlet.json -ad8 loganad8_4.tif" {
cd AreaD8_data
run mpiexec -n 4  $TAUDEM_PATH/aread8 -p loganp.tif -o LoganOutlet.json -ad8 loganad8_4.tif
assert_success
}
# Note that the syntax below with -lyrname LoganOutlet differs from PC usage that has -lyrname OGRGeoJson. Have not determined why. (with the TauDEM 5.3.8 version, there is no need to use -lyrname OGRGeoJson)
@test "run mpiexec -n 6  $TAUDEM_PATH/aread8 -p loganp.tif -o LoganOutlet.json -lyrname LoganOutlet -ad8 loganad8_5.tif" {
cd AreaD8_data
run mpiexec -n 6  $TAUDEM_PATH/aread8 -p loganp.tif -o LoganOutlet.json -lyrname LoganOutlet -ad8 loganad8_5.tif
assert_success
}
@test "run mpiexec -n 7  $TAUDEM_PATH/aread8 -p loganp.tif -o Logan.gdb -ad8 loganad8_6.tif" {
cd AreaD8_data
run mpiexec -n 7  $TAUDEM_PATH/aread8 -p loganp.tif -o Logan.gdb -ad8 loganad8_6.tif
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/aread8 -p loganp.tif -o Logan.gdb -lyrname Outlet -ad8 loganad8_7.tif" {
cd AreaD8_data
run mpiexec -n 5  $TAUDEM_PATH/aread8 -p loganp.tif -o Logan.gdb -lyrname Outlet -ad8 loganad8_7.tif
assert_success
}
@test "run mpiexec -n 2  $TAUDEM_PATH/aread8 -p loganp.tif -o Logan.gdb -lyrno 0 -ad8 loganad8_8.tif" {
cd AreaD8_data
run mpiexec -n 2  $TAUDEM_PATH/aread8 -p loganp.tif -o Logan.gdb -lyrno 0 -ad8 loganad8_8.tif
assert_success
}

 
@test "run mpiexec -n 7  $TAUDEM_PATH/areadinf -ang loganang.tif -o LoganOutlet.shp -sca logansca_1.tif" {
cd AreaDinf
run mpiexec -n 7  $TAUDEM_PATH/areadinf -ang loganang.tif -o LoganOutlet.shp -sca logansca_1.tif
assert_success
}
@test "run mpiexec -n 1  $TAUDEM_PATH/areadinf -ang loganang.tif -o LoganSample.sqlite -lyrno 1 -sca logansca_2.tif" {
cd AreaDinf
run mpiexec -n 1  $TAUDEM_PATH/areadinf -ang loganang.tif -o LoganSample.sqlite -lyrno 1 -sca logansca_2.tif
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/areadinf -ang loganang.tif -o LoganSample.sqlite -lyrname LoganOutlet -sca logansca_3.tif" {
cd AreaDinf
run mpiexec -n 3  $TAUDEM_PATH/areadinf -ang loganang.tif -o LoganSample.sqlite -lyrname LoganOutlet -sca logansca_3.tif
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/areadinf -ang loganang.tif -o LoganSample.sqlite -lyrno 1 -sca logansca_4.tif" {
cd AreaDinf
run mpiexec -n 5  $TAUDEM_PATH/areadinf -ang loganang.tif -o LoganSample.sqlite -lyrno 1 -sca logansca_4.tif
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/areadinf -ang loganang.tif -o LoganOutlet.json -sca logansca_5.tif" {
cd AreaDinf
run mpiexec -n 3  $TAUDEM_PATH/areadinf -ang loganang.tif -o LoganOutlet.json -sca logansca_5.tif
assert_success
}
# Note that the syntax below with -lyrname LoganOutlet differs from PC usage that has -lyrname OGRGeoJson. Have not determined why. (with the TauDEM 5.3.8 version, there is no need to use -lyrname OGRGeoJson)
@test "run mpiexec -n 5  $TAUDEM_PATH/areadinf -ang loganang.tif -o LoganOutlet.json -lyrname LoganOutlet -sca logansca_6.tif" {
cd AreaDinf
run mpiexec -n 5  $TAUDEM_PATH/areadinf -ang loganang.tif -o LoganOutlet.json -lyrname LoganOutlet -sca logansca_6.tif
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/areadinf -ang loganang.tif -o Logan.gdb -sca logansca_7.tif" {
cd AreaDinf
run mpiexec -n 5  $TAUDEM_PATH/areadinf -ang loganang.tif -o Logan.gdb -sca logansca_7.tif
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/areadinf -ang loganang.tif -o Logan.gdb -lyrname Outlet -sca logansca_8.tif" {
cd AreaDinf
run mpiexec -n 3  $TAUDEM_PATH/areadinf -ang loganang.tif -o Logan.gdb -lyrname Outlet -sca logansca_8.tif
assert_success
}
@test "run mpiexec -n 6  $TAUDEM_PATH/areadinf -ang loganang.tif -o Logan.gdb -lyrno 0 -sca logansca_9.tif" {
cd AreaDinf
run mpiexec -n 6  $TAUDEM_PATH/areadinf -ang loganang.tif -o Logan.gdb -lyrno 0 -sca logansca_9.tif
assert_success
}
@test "run mpiexec -n 7  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen1.tif -tlen logantlen1.tif -gord logangord1.tif -o LoganOutlet.shp" {
cd Gridnet
run mpiexec -n 7  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen1.tif -tlen logantlen1.tif -gord logangord1.tif -o LoganOutlet.shp 
assert_success
}
@test "run mpiexec -n 6  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen3.tif -tlen logantlen3.tif -gord logangord3.tif -o LoganSample.sqlite -lyrname LoganOutlet" {
cd Gridnet
run mpiexec -n 6  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen3.tif -tlen logantlen3.tif -gord logangord3.tif -o LoganSample.sqlite -lyrname LoganOutlet
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen4.tif -tlen logantlen4.tif -gord logangord4.tif -o LoganSample.sqlite -lyrno 1" {
cd Gridnet
run mpiexec -n 3  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen4.tif -tlen logantlen4.tif -gord logangord4.tif -o LoganSample.sqlite -lyrno 1
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen5.tif -tlen logantlen5.tif -gord logangord5.tif -o LoganOutlet.json" {
cd Gridnet
run mpiexec -n 3  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen5.tif -tlen logantlen5.tif -gord logangord5.tif -o LoganOutlet.json
assert_success
}

# Note that the syntax below with -lyrname LoganOutlet differs from PC usage that has -lyrname OGRGeoJson. Have not determined why. (with the TauDEM 5.3.8 version, there is no need to use -lyrname OGRGeoJson)
@test "run mpiexec -n 7  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen6.tif -tlen logantlen6.tif -gord logangord6.tif -o LoganOutlet.json -lyrname LoganOutlet" {
cd Gridnet
run mpiexec -n 7  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen6.tif -tlen logantlen6.tif -gord logangord6.tif -o LoganOutlet.json -lyrname LoganOutlet 
assert_success
}
@test "run mpiexec -n 1  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen7.tif -tlen logantlen7.tif -gord logangord7.tif -o Logan.gdb" {
cd Gridnet
run mpiexec -n 1  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen7.tif -tlen logantlen7.tif -gord logangord7.tif -o Logan.gdb
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen8.tif -tlen logantlen8.tif -gord logangord8.tif -o Logan.gdb -lyrname Outlet" {
cd Gridnet
run mpiexec -n 3  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen8.tif -tlen logantlen8.tif -gord logangord8.tif -o Logan.gdb -lyrname Outlet
assert_success
}
@test "run mpiexec -n 2  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen9.tif -tlen logantlen9.tif -gord logangord9.tif -o Logan.gdb -lyrno 0" {
cd Gridnet
run mpiexec -n 2  $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen9.tif -tlen logantlen9.tif -gord logangord9.tif -o Logan.gdb -lyrno 0
assert_success
}

#stream network peuker douglas
@test "run mpiexec -n 1  $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp1.txt -o LoganOutlet.shp -par 5 500 10 0" {
cd peukerDouglas
run mpiexec -n 1  $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp1.txt -o LoganOutlet.shp -par 5 500 10 0 
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp3.txt -o LoganSample.sqlite -lyrname LoganOutlet -par 5 500 10 0" {
cd peukerDouglas
run mpiexec -n 5  $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp3.txt -o LoganSample.sqlite -lyrname LoganOutlet -par 5 500 10 0 
assert_success
}
@test "run mpiexec -n 2  $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp4.txt -o LoganSample.sqlite -lyrno 1 -par 5 500 10 0" {
cd peukerDouglas
run mpiexec -n 2  $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp4.txt -o LoganSample.sqlite -lyrno 1 -par 5 500 10 0 
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp5.txt -o LoganOutlet.json -par 5 500 10 0" {
cd peukerDouglas
run mpiexec -n 5  $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp5.txt -o LoganOutlet.json -par 5 500 10 0 
assert_success
}
# Note that the syntax below with -lyrname LoganOutlet differs from PC usage that has -lyrname OGRGeoJson. Have not determined why. (with the TauDEM 5.3.8 version, there is no need to use -lyrname OGRGeoJson)
@test "run mpiexec -n 4  $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp6.txt -o LoganOutlet.json -lyrname LoganOutlet -par 5 500 10 0" {
cd peukerDouglas
run mpiexec -n 4  $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp6.txt -o LoganOutlet.json -lyrname LoganOutlet -par 5 500 10 0 
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp7.txt -o Logan.gdb -par 5 500 10 0" {
cd peukerDouglas
run mpiexec -n 3  $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp7.txt -o Logan.gdb -par 5 500 10 0 
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp8.txt -o Logan.gdb -lyrname Outlet -par 5 500 10 0" {
cd peukerDouglas
run mpiexec -n 5  $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp8.txt -o Logan.gdb -lyrname Outlet -par 5 500 10 0 
assert_success
}
@test "run mpiexec -n 6  $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp9.txt -o Logan.gdb -lyrno 0 -par 5 500 10 0" {
cd peukerDouglas
run mpiexec -n 6  $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp9.txt -o Logan.gdb -lyrno 0 -par 5 500 10 0 
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/streamnet -fel loganfel.tif -p loganp.tif -ad8 loganad8.tif -src logansrc.tif -ord loganord3.tif -tree logantree.dat -coord logancoord.dat -net logannet1.shp -w loganw.tif -o LoganOutlet.shp" {
cd streamnet_data
run mpiexec -n 5  $TAUDEM_PATH/streamnet -fel loganfel.tif -p loganp.tif -ad8 loganad8.tif -src logansrc.tif -ord loganord3.tif -tree logantree.dat -coord logancoord.dat -net logannet1.shp -w loganw.tif -o LoganOutlet.shp
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/streamnet -fel loganfel.tif -p loganp.tif -ad8 loganad8.tif -src logansrc.tif -ord loganord3.tif -tree logantree.dat -coord logancoord.dat -net LoganSample.sqlite -netlyr Mynetwork.shp -w loganw.tif -o LoganSample.sqlite -lyrname LoganOutlet" {
cd streamnet_data
run mpiexec -n 3  $TAUDEM_PATH/streamnet -fel loganfel.tif -p loganp.tif -ad8 loganad8.tif -src logansrc.tif -ord loganord3.tif -tree logantree.dat -coord logancoord.dat -net LoganSample.sqlite -netlyr Mynetwork.shp -w loganw.tif -o LoganSample.sqlite -lyrname LoganOutlet
assert_success
}
@test "run mpiexec -n 7  $TAUDEM_PATH/streamnet -fel loganfel.tif -p loganp.tif -ad8 loganad8.tif -src logansrc.tif -ord loganord3.tif -tree logantree.dat -coord logancoord.dat -net logannet3.kml -netlyr logannet3 -w loganw.tif -o Logan.gdb -lyrname Outlet" {
cd streamnet_data
run mpiexec -n 7  $TAUDEM_PATH/streamnet -fel loganfel.tif -p loganp.tif -ad8 loganad8.tif -src logansrc.tif -ord loganord3.tif -tree logantree.dat -coord logancoord.dat -net logannet3.kml -netlyr logannet3 -w loganw.tif -o Logan.gdb -lyrname Outlet
assert_success
}
@test "run mpiexec -n 7  $TAUDEM_PATH/streamnet -fel loganfel.tif -p loganp.tif -ad8 loganad8.tif -src logansrc.tif -ord loganord3.tif -tree logantree.dat -coord logancoord.dat -net logannet3.json -netlyr logannet3 -w loganw.tif -o Logan.gdb -lyrno 0" {
cd streamnet_data
run mpiexec -n 7  $TAUDEM_PATH/streamnet -fel loganfel.tif -p loganp.tif -ad8 loganad8.tif -src logansrc.tif -ord loganord3.tif -tree logantree.dat -coord logancoord.dat -net logannet3.json -netlyr logannet3 -w loganw.tif -o Logan.gdb -lyrno 0
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/streamnet -fel loganfel.tif -p loganp.tif -ad8 loganad8.tif -src logansrc.tif -ord loganord3.tif -tree logantree.dat -coord logancoord.dat -net logannet4.json -netlyr logannet4 -w loganw.tif -o LoganOutlet.json -lyrno 0" {
cd streamnet_data
run mpiexec -n 5  $TAUDEM_PATH/streamnet -fel loganfel.tif -p loganp.tif -ad8 loganad8.tif -src logansrc.tif -ord loganord3.tif -tree logantree.dat -coord logancoord.dat -net logannet4.json -netlyr logannet4 -w loganw.tif -o LoganOutlet.json -lyrno 0
assert_success
}

#stream network slope area
@test "run mpiexec -n 3  $TAUDEM_PATH/d8flowpathextremeup -p loganp.tif -sa logansa.tif -ssa loganssa1.tif -o LoganOutlet.shp" {
cd D8flowextreme
run mpiexec -n 3  $TAUDEM_PATH/d8flowpathextremeup -p loganp.tif -sa logansa.tif -ssa loganssa1.tif -o LoganOutlet.shp
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/d8flowpathextremeup -p loganp.tif -sa logansa.tif -ssa loganssa2.tif -o LoganSample.sqlite -lyrname LoganOutlet" {
cd D8flowextreme
run mpiexec -n 5  $TAUDEM_PATH/d8flowpathextremeup -p loganp.tif -sa logansa.tif -ssa loganssa2.tif -o LoganSample.sqlite -lyrname LoganOutlet
assert_success
}
@test "run mpiexec -n 7  $TAUDEM_PATH/d8flowpathextremeup -p loganp.tif -sa logansa.tif -ssa loganssa3.tif -o LoganSample.sqlite -lyrno 1" {
cd D8flowextreme
run mpiexec -n 7  $TAUDEM_PATH/d8flowpathextremeup -p loganp.tif -sa logansa.tif -ssa loganssa3.tif -o LoganSample.sqlite -lyrno 1
assert_success
}
@test "run mpiexec -n 1  $TAUDEM_PATH/d8flowpathextremeup -p loganp.tif -sa logansa.tif -ssa loganssa4.tif -o Logan.gdb" {
cd D8flowextreme
run mpiexec -n 1  $TAUDEM_PATH/d8flowpathextremeup -p loganp.tif -sa logansa.tif -ssa loganssa4.tif -o Logan.gdb 
assert_success
}
@test "run mpiexec -n 8  $TAUDEM_PATH/d8flowpathextremeup -p loganp.tif -sa logansa.tif -ssa loganssa5.tif -o Logan.gdb -lyrno 0" {
cd D8flowextreme
run mpiexec -n 8  $TAUDEM_PATH/d8flowpathextremeup -p loganp.tif -sa logansa.tif -ssa loganssa5.tif -o Logan.gdb -lyrno 0
assert_success
}

#downslope influence
@test "run mpiexec -n 1  $TAUDEM_PATH/dinfconclimaccum -ang loganang.tif -dm logandm08.tif -dg logandg.tif -ctpt loganctpto1.img -q logansca.tif -o LoganOutlet.shp -csol 2.4" {
cd DinfConcLimAccum
run mpiexec -n 1  $TAUDEM_PATH/dinfconclimaccum -ang loganang.tif -dm logandm08.tif -dg logandg.tif -ctpt loganctpto1.img -q logansca.tif -o LoganOutlet.shp -csol 2.4
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/dinfconclimaccum -ang loganang.tif -dm logandm08.tif -dg logandg.tif -ctpt loganctpto2.tif -q logansca.tif -o LoganSample.sqlite -lyrname LoganOutlet -csol 2.4" {
cd DinfConcLimAccum
run mpiexec -n 5  $TAUDEM_PATH/dinfconclimaccum -ang loganang.tif -dm logandm08.tif -dg logandg.tif -ctpt loganctpto2.tif -q logansca.tif -o LoganSample.sqlite -lyrname LoganOutlet -csol 2.4
assert_success
}
@test "run mpiexec -n 7  $TAUDEM_PATH/dinfconclimaccum -ang loganang.tif -dm logandm08.tif -dg logandg.tif -ctpt loganctpto4.tif -q logansca.tif -o Logan.gdb -csol 2.4" {
cd DinfConcLimAccum
run mpiexec -n 7  $TAUDEM_PATH/dinfconclimaccum -ang loganang.tif -dm logandm08.tif -dg logandg.tif -ctpt loganctpto4.tif -q logansca.tif -o Logan.gdb -csol 2.4
assert_success
}
@test "run mpiexec -n 8  $TAUDEM_PATH/dinfconclimaccum -ang loganang.tif -dm logandm08.tif -dg logandg.tif -ctpt loganctpto5.tif -q logansca.tif -o Logan.gdb -lyrno 0 -csol 2.4" {
cd DinfConcLimAccum
run mpiexec -n 8  $TAUDEM_PATH/dinfconclimaccum -ang loganang.tif -dm logandm08.tif -dg logandg.tif -ctpt loganctpto5.tif -q logansca.tif -o Logan.gdb -lyrno 0 -csol 2.4
assert_success
}
#Trans lim accum
@test "run mpiexec -n 2  $TAUDEM_PATH/dinftranslimaccum -ang loganang.tif -tsup logantsup.tif -tc logantc.tif -tla logantla1.img -tdep logantdep1.tif -o LoganOutlet.shp -cs logandg.tif -ctpt loganctpt1.tif" {
cd DinfTransLimAcc
run mpiexec -n 2  $TAUDEM_PATH/dinftranslimaccum -ang loganang.tif -tsup logantsup.tif -tc logantc.tif -tla logantla1.img -tdep logantdep1.tif -o LoganOutlet.shp -cs logandg.tif -ctpt loganctpt1.tif 
assert_success
}
@test "run mpiexec -n 6  $TAUDEM_PATH/dinftranslimaccum -ang loganang.tif -tsup logantsup.tif -tc logantc.tif -tla logantla2.tif -tdep logantdep2.tif -o LoganSample.sqlite -lyrname LoganOutlet  -cs logandg.tif -ctpt loganctpt2.tif" {
cd DinfTransLimAcc
run mpiexec -n 6  $TAUDEM_PATH/dinftranslimaccum -ang loganang.tif -tsup logantsup.tif -tc logantc.tif -tla logantla2.tif -tdep logantdep2.tif -o LoganSample.sqlite -lyrname LoganOutlet  -cs logandg.tif -ctpt loganctpt2.tif 
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/dinftranslimaccum -ang loganang.tif -tsup logantsup.tif -tc logantc.tif -tla logantla4.tif -tdep logantdep4.tif -o Logan.gdb  -cs logandg.tif -ctpt loganctpt4.tif" {
cd DinfTransLimAcc
run mpiexec -n 5  $TAUDEM_PATH/dinftranslimaccum -ang loganang.tif -tsup logantsup.tif -tc logantc.tif -tla logantla4.tif -tdep logantdep4.tif -o Logan.gdb  -cs logandg.tif -ctpt loganctpt4.tif 
assert_success
}
##@test "run mpiexec -n 7  $TAUDEM_PATH/dinftranslimaccum -ang loganang.tif -tsup logantsup.tif -tc logantc.tif -tla logantla5.tif -tdep logantdep5.tif -o LoganOutlet.json -cs logandg.tif -ctpt loganctpt5.tif" {
##cd DinfTransLimAcc
##run mpiexec -n 7  $TAUDEM_PATH/dinftranslimaccum -ang loganang.tif -tsup logantsup.tif -tc logantc.tif -tla logantla5.tif -tdep logantdep5.tif -o Loganoutlet.json -cs logandg.tif -ctpt loganctpt5.tif 
##assert_success
#}

#MOVEOUTLETS
@test "run mpiexec -np 1  $TAUDEM_PATH/moveoutletstostreams -p loganp.tif -src logansrc.tif -o OutletstoMove.shp -om Outletsmoved.shp -md 20" {
cd MovedOutletstoStream_data
run mpiexec -np 1  $TAUDEM_PATH/moveoutletstostreams -p loganp.tif -src logansrc.tif -o OutletstoMove.shp -om Outletsmoved.shp -md 20 
assert_success
}
@test "run mpiexec -np 3  $TAUDEM_PATH/moveoutletstostreams -p loganp.tif -src logansrc.tif -o OutletstoMove.json -om Outletsmoved.kml -md 20" {
cd MovedOutletstoStream_data
run mpiexec -np 3  $TAUDEM_PATH/moveoutletstostreams -p loganp.tif -src logansrc.tif -o OutletstoMove.json -om Outletsmoved.kml -md 20 
assert_success
}
@test "run mpiexec -np 4  $TAUDEM_PATH/moveoutletstostreams -p loganp.tif -src logansrc.tif -o LoganSample.sqlite -lyrno 2 -om Outletsmoved5.kml -md 20" {
cd MovedOutletstoStream_data
run mpiexec -np 4  $TAUDEM_PATH/moveoutletstostreams -p loganp.tif -src logansrc.tif -o LoganSample.sqlite -lyrno 2 -om Outletsmoved5.kml -md 20 
assert_success
}
@test "run mpiexec -np 7  $TAUDEM_PATH/moveoutletstostreams -p loganp.tif -src logansrc.tif -o Logan.gdb -lyrno 0 -om Outletsmove.json -md 20" {
cd MovedOutletstoStream_data
run mpiexec -np 7  $TAUDEM_PATH/moveoutletstostreams -p loganp.tif -src logansrc.tif -o Logan.gdb -lyrno 0 -om Outletsmove.json -md 20 
assert_success
}

#gagewatershed test
@test "run mpiexec -n 1  $TAUDEM_PATH/gagewatershed -p loganp.tif -o LoganOutlet.shp -gw logangw1.tif -id gwid1.txt" {
cd GageWatershed
run mpiexec -n 1  $TAUDEM_PATH/gagewatershed -p loganp.tif -o LoganOutlet.shp -gw logangw1.tif -id gwid1.txt
assert_success
}
@test "run mpiexec -n 3  $TAUDEM_PATH/gagewatershed -p loganp.tif -o Logan.gdb -gw logangw3.tif -id gwid3.txt" {
cd GageWatershed
run mpiexec -n 3  $TAUDEM_PATH/gagewatershed -p loganp.tif -o Logan.gdb -gw logangw3.tif -id gwid3.txt
assert_success
}
@test "run mpiexec -n 5  $TAUDEM_PATH/gagewatershed -p loganp.tif -o Logan.gdb -lyrno 0 -gw logangw3.tif -id gwid3.txt" {
cd GageWatershed
run mpiexec -n 5  $TAUDEM_PATH/gagewatershed -p loganp.tif -o Logan.gdb -lyrno 0 -gw logangw3.tif -id gwid3.txt
assert_success
}
@test "run mpiexec -n 7  $TAUDEM_PATH/gagewatershed -p loganp.tif -o loganoutlet.json -gw logangw4.tif -id gwid4.txt" {
cd GageWatershed
run mpiexec -n 7  $TAUDEM_PATH/gagewatershed -p loganp.tif -o LoganOutlet.json -gw logangw4.tif -id gwid4.txt
assert_success
}

##Connect down
#@test "run mpiexec -n 1  $TAUDEM_PATH/connectdown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganOutlets1.shp -od loganOutlets_Moved1.shp -d 1" {
#cd ConnectDown
#run mpiexec -n 1  $TAUDEM_PATH/connectdown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganOutlets1.shp -od loganOutlets_Moved1.shp -d 1
#assert_success
#}
#@test "run mpiexec -n 3  $TAUDEM_PATH/connectdown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganOutlets2.shp -olyr loganOutlets2  -od loganOutlets_Moved2.shp -odlyr loganOutlets2 -d 1" {
#cd ConnectDown
#run mpiexec -n 3  $TAUDEM_PATH/connectdown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganOutlets2.shp -olyr loganOutlets2  -od loganOutlets_Moved2.shp -odlyr loganOutlets2 -d 1
#assert_success
#}
#@test "run mpiexec -n 5  $TAUDEM_PATH/connectdown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganSample.sqlite -olyr myoutlet1  -od loganSample.sqlite -odlyr myoutlet2 -d 1" {
#cd ConnectDown
#run mpiexec -n 5  $TAUDEM_PATH/connectdown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganSample.sqlite -olyr myoutlet1  -od loganSample.sqlite -odlyr myoutlet2 -d 1
#assert_success
#}
#@test "run mpiexec -n 7  $TAUDEM_PATH/connectdown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganOutlets2.kml -od loganOutlets_Moved2.kml -d 1" {
#cd ConnectDown
#run mpiexec -n 7  $TAUDEM_PATH/connectdown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganOutlets2.kml -od loganOutlets_Moved2.kml -d 1
#assert_success
#}
#@test "run mpiexec -n 1  $TAUDEM_PATH/connectdown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganOutlets3.kml -olyr loganOutlets3 -od loganOutlets_Moved3.kml -odlyr loganOutlets_Moved3 -d 1" {
#cd ConnectDown
#run mpiexec -n 1  $TAUDEM_PATH/connectdown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganOutlets3.kml -olyr loganOutlets3 -od loganOutlets_Moved3.kml -odlyr loganOutlets_Moved3 -d 1
#assert_success
#}
#@test "run mpiexec -n 3  $TAUDEM_PATH/connectdown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganOutlets4.json -od loganOutlets_Moved2.json -d 1" {
#cd ConnectDown
#run mpiexec -n 3  $TAUDEM_PATH/connectdown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganOutlets4.json -od loganOutlets_Moved2.json -d 1
#assert_success
#}
#@test "run mpiexec -n 8  $TAUDEM_PATH/connectdown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganOutlets3.kml -olyr loganOutlets3 -od loganOutlets_Moved3.kml -odlyr loganOutlets_Moved3 -d 1" {
#cd ConnectDown
#run mpiexec -n 8  $TAUDEM_PATH/connectdown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganOutlets3.kml -olyr loganOutlets3 -od loganOutlets_Moved3.kml -odlyr loganOutlets_Moved3 -d 1
#assert_success
#}

#Test EPSG functionality
@test "run mpiexec -n 2  $TAUDEM_PATH/aread8 -p ma2_ep.tif -ad8 ma2_ead8.tif -o outlet.shp -nc" {
cd NoEPSG
run mpiexec -n 2  $TAUDEM_PATH/aread8 -p ma2_ep.tif -ad8 ma2_ead8.tif -o outlet.shp -nc
assert_success
}
@test "run mpiexec  -np  8  moveoutletstostreams  -p  subwatershed_74p.tif  -src  subwatershed_74src1.tif  -o  mypoint.shp  -om  New_Outlet.shp  -md  10000.0" {
cd MoveOutlets2
run mpiexec  -np  8  $TAUDEM_PATH/moveoutletstostreams  -p  subwatershed_74p.tif  -src  subwatershed_74src1.tif  -o  mypoint.shp  -om  New_Outlet.shp  -md  10000.0 
assert_success
}
@test "run mpiexec -np 1  $TAUDEM_PATH/moveoutletstostreams  -p  subwatershed_74p.tif  -src  subwatershed_74src1.tif  -o  testpoints.shp  -om  New_Outlet1.shp  -md  10000" {
cd MoveOutlets2
run mpiexec -np 1  $TAUDEM_PATH/moveoutletstostreams  -p  subwatershed_74p.tif  -src  subwatershed_74src1.tif  -o  testpoints.shp  -om  New_Outlet1.shp  -md  10000 
assert_success
}

@test "run mpiexec -np 8  $TAUDEM_PATH/moveoutletstostreams  -p  subwatershed_74p.tif  -src  subwatershed_74src1.tif  -o  testpoints.shp  -om  New_Outlet2.shp  -md  100" {
cd MoveOutlets2
run mpiexec -np 8  $TAUDEM_PATH/moveoutletstostreams  -p  subwatershed_74p.tif  -src  subwatershed_74src1.tif  -o  testpoints.shp  -om  New_Outlet2.shp  -md  100 
assert_success
}
@test "run mpiexec -n 4  $TAUDEM_PATH/gagewatershed -p fdr.tif -gw gw.tif -id id.txt -o CatchOutlets3.shp" {
cd gwunittest
run mpiexec -n 4  $TAUDEM_PATH/gagewatershed -p fdr.tif -gw gw.tif -id id.txt -o CatchOutlets3.shp
assert_success
}

# editraster 
@test "run mpiexec -n 2  $TAUDEM_PATH/editraster -in fdro.tif -out fdrmod.tif -changes changes.txt" {
cd Editraster
run mpiexec -n 2  $TAUDEM_PATH/editraster -in fdro.tif -out fdrmod.tif -changes changes.txt
assert_success
}
# catchoutlets 
# Run catchoutlets single processor, no parallel version yet
@test "run mpiexec -n 1  $TAUDEM_PATH/catchoutlets -net net1.shp -p fdr.tif -o CatchOutlets.shp -mindist 20000 -minarea 50000000 -gwstartno 5" {
cd CatchOutlets
run mpiexec -n 1  $TAUDEM_PATH/catchoutlets -net net1.shp -p fdr.tif -o CatchOutlets.shp -mindist 20000 -minarea 50000000 -gwstartno 5
assert_success
}

#Run flow direction conditioning
@test "run mpiexec -n 4  $TAUDEM_PATH/flowdircond -z wcdem.tif -p pm.tif -zfdc wcdemzfdc.tif" {
cd FlowdirCond
run mpiexec -n 4  $TAUDEM_PATH/flowdircond -z wcdem.tif -p pm.tif -zfdc wcdemzfdc.tif
assert_success
}

#Run Retention Limited Flow Accumulation
@test "run mpiexec -n 6  $TAUDEM_PATH/retlimflow -ang spawnang.tif -wg spawnwg.tif -rc spawnrc.tif -qrl spawnqrl.tif" {
cd RetLimFlow
run mpiexec -n 6  $TAUDEM_PATH/retlimflow -ang spawnang.tif -wg spawnwg.tif -rc spawnrc.tif -qrl spawnqrl.tif
assert_success
}

#Run CatchHydroGeo
@test "run mpiexec -n 4  $TAUDEM_PATH/catchhydrogeo -hand onion3dd.tif -catch onion3w.tif -catchlist catchlist.txt -slp onion3slp.tif -h stage.txt -table hydropropotable.txt" {
cd CatchHydroGeoTest
run mpiexec -n 4  $TAUDEM_PATH/catchhydrogeo -hand Onion3dd.tif -catch Onion3w.tif -catchlist catchlist.txt -slp Onion3slp.tif -h stage.txt -table hydropropotable.txt
assert_success
}
