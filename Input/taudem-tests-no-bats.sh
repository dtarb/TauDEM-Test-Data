#!/usr/bin/env bash

set -e  # Exit on error, stop tests on first failure

# Set TAUDEM_PATH from environment or default
TAUDEM_PATH="${TAUDEM_PATH:-/usr/local/bin}"

# Validate that TAUDEM_PATH exists
if [ ! -d "$TAUDEM_PATH" ]; then
    echo "Error: TAUDEM_PATH directory '$TAUDEM_PATH' does not exist" >&2
    exit 1
fi

# Test counter variables
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Store the original directory
ORIGINAL_DIR=$(pwd)

# Function to run a test
run_test() {
    local test_name="$1"
    local test_dir="$2"
    local test_command="$3"
    
    TOTAL_TESTS=$((TOTAL_TESTS + 1))
    
    echo ""
    echo "----------------------------------------"
    echo "Test $TOTAL_TESTS: $test_name"
    echo "----------------------------------------"
    
    # Change to test directory if specified
    if [ -n "$test_dir" ]; then
        cd "$ORIGINAL_DIR/$test_dir" || { echo "✗ FAILED - Could not change to directory $test_dir"; exit 1; }
    fi
    
    # Run the command and show output
    echo "Running: $test_command"
    if eval "$test_command"; then
        echo "✓ PASSED"
        PASSED_TESTS=$((PASSED_TESTS + 1))
        cd "$ORIGINAL_DIR"
        return 0
    else
        echo "✗ FAILED (exit code: $?)"
        FAILED_TESTS=$((FAILED_TESTS + 1))
        cd "$ORIGINAL_DIR"
        exit 1
    fi
}

# Print header
echo "========================================"
echo "TauDEM Tests (No BATS Framework)"
echo "========================================"
echo "TAUDEM_PATH: $TAUDEM_PATH"
echo "Start time: $(date)"
echo ""

# ========================================
# Basic Grid Analysis
# ========================================
echo ""
echo "========================================"
echo "BASIC GRID ANALYSIS"
echo "========================================"

run_test "pitremove logan.tif" "Base" "mpiexec -np 3 $TAUDEM_PATH/pitremove logan.tif"
run_test "pitremove logan.tif -z" "Base" "mpiexec -np 3 $TAUDEM_PATH/pitremove -z logan.tif -fel loganfel.bil"
run_test "pitremove with -4way" "Base" "mpiexec -np 3 $TAUDEM_PATH/pitremove -z logan.tif -fel loganfel4.tiff -4way"
run_test "pitremove with depmask" "Base" "mpiexec -np 3 $TAUDEM_PATH/pitremove -z logan.tif -fel loganfeldm.tif -depmask logpitmask.tif"
run_test "pitremove with depmask and -4way" "Base" "mpiexec -np 3 $TAUDEM_PATH/pitremove -z logan.tif -fel loganfeldm4.tif -depmask logpitmask.tif -4way"
run_test "d8flowdir" "Base" "mpiexec -n 5 $TAUDEM_PATH/d8flowdir -p loganp.tif -sd8 logansd8.tif -fel loganfel.tif"
run_test "dinfflowdir" "Base" "mpiexec -n 4 $TAUDEM_PATH/dinfflowdir -ang loganang.tif -slp loganslp.tif -fel loganfel.tif"
run_test "d8flowdir on unfilled DEM" "Base" "mpiexec -n 6 $TAUDEM_PATH/d8flowdir -p loganpnf.tif -sd8 logansd8nf.tif -fel logan.tif"
run_test "dinfflowdir on unfilled DEM" "Base" "mpiexec -n 3 $TAUDEM_PATH/dinfflowdir -ang loganangnf.tif -slp loganslpnf.tif -fel logan.tif"
run_test "aread8 logan.tif" "Base" "mpiexec -np 4 $TAUDEM_PATH/aread8 logan.tif"
run_test "areadinf logan.tif" "Base" "mpiexec -np 12 $TAUDEM_PATH/areadinf logan.tif"
run_test "aread8 on unfilled DEM" "Base" "mpiexec -np 4 $TAUDEM_PATH/aread8 -p loganpnf.tif -ad8 loganad8nf.tif"
run_test "areadinf on unfilled DEM" "Base" "mpiexec -np 12 $TAUDEM_PATH/areadinf -ang loganangnf.tif -sca loganscanf.tif"
run_test "aread8 with outlet" "Base" "mpiexec -n 7 $TAUDEM_PATH/aread8 -p loganp.tif -o Outlet.shp -ad8 loganad8o.tif"
run_test "areadinf with outlet" "Base" "mpiexec -n 1 $TAUDEM_PATH/areadinf -ang loganang.tif -o Outlet.shp -sca loganscao.tif"
run_test "gridnet" "Base" "mpiexec -n 5 $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen.tif -tlen logantlen.tif -gord logangord.tif"
run_test "gridnet with mask and thresh" "Base" "mpiexec -n 5 $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen1.tif -tlen logantlen1.tif -gord logangord1.tif -mask loganad8.tif -thresh 100"
run_test "gridnet with outlet" "Base" "mpiexec -n 7 $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen2.tif -tlen logantlen2.tif -gord logangord2.tif -o Outlet.shp"

# ========================================
# Stream Network - Peuker Douglas
# ========================================
echo ""
echo "========================================"
echo "STREAM NETWORK - PEUKER DOUGLAS"
echo "========================================"

run_test "peukerdouglas" "Base" "mpiexec -np 7 $TAUDEM_PATH/peukerdouglas -fel loganfel.tif -ss loganss.tif"
run_test "aread8 with weight grid" "Base" "mpiexec -n 4 $TAUDEM_PATH/aread8 -p loganp.tif -o Outlet.shp -ad8 loganssa.tif -wg loganss.tif"
run_test "dropanalysis" "Base" "mpiexec -n 4 $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp.txt -o Outlet.shp -par 5 500 10 0"
run_test "threshold" "Base" "mpiexec -n 5 $TAUDEM_PATH/threshold -ssa loganssa.tif -src logansrc.tif -thresh 180"
run_test "streamnet" "Base" "mpiexec -n 5 $TAUDEM_PATH/streamnet -fel loganfel.tif -p loganp.tif -ad8 loganad8.tif -src logansrc.tif -ord loganord3.tif -tree logantree.dat -coord logancoord.dat -net logannet.shp -w loganw.tif -o Outlet.shp"

# ========================================
# Stream Network - Slope Area
# ========================================
echo ""
echo "========================================"
echo "STREAM NETWORK - SLOPE AREA"
echo "========================================"

run_test "slopearea" "Base" "mpiexec -n 3 $TAUDEM_PATH/slopearea -slp loganslp.tif -sca logansca.tif -sa logansa.tif -par 2 1"
run_test "d8flowpathextremeup" "Base" "mpiexec -n 8 $TAUDEM_PATH/d8flowpathextremeup -p loganp.tif -sa logansa.tif -ssa loganssa1.tif -o Outlet.shp"
run_test "dropanalysis slope area" "Base" "mpiexec -n 4 $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa1.tif -drp logandrp1.txt -o Outlet.shp -par 5000 50000 10 1"
run_test "threshold slope area" "Base" "mpiexec -n 5 $TAUDEM_PATH/threshold -ssa loganssa1.tif -src logansrc1.tif -thresh 15000"
run_test "streamnet with -sw" "Base" "mpiexec -n 8 $TAUDEM_PATH/streamnet -fel loganfel.tif -p loganp.tif -ad8 loganad8.tif -src logansrc1.tif -ord loganord5.tif -tree logantree1.dat -coord logancoord1.dat -net logannet1.shp -w loganw1.tif -o Outlet.shp -sw"
run_test "connectdown simple shp" "Base" "mpiexec -n 8 $TAUDEM_PATH/ConnectDown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganOutlets.shp -od loganOutlets_Moved.shp -d 1"
run_test "lengtharea" "Base" "mpiexec -n 3 $TAUDEM_PATH/lengtharea -plen loganplen.tif -ad8 loganad8.tif -ss loganlass.tif -par 0.03 1.3"

# ========================================
# Specialized Grid Analysis
# ========================================
echo ""
echo "========================================"
echo "SPECIALIZED GRID ANALYSIS"
echo "========================================"

run_test "slopearearatio" "Base" "mpiexec -n 3 $TAUDEM_PATH/slopearearatio -slp loganslp.tif -sca logansca.tif -sar logansar.tiff"
run_test "d8hdisttostrm with threshold" "Base" "mpiexec -np 7 $TAUDEM_PATH/d8hdisttostrm -p loganp.tif -src loganad8.tif -dist logandist1.tif -thresh 200"
run_test "d8hdisttostrm" "Base" "mpiexec -np 5 $TAUDEM_PATH/d8hdisttostrm -p loganp.tif -src logansrc.tif -dist logandist.tif"

# ========================================
# Downslope Influence
# ========================================
echo ""
echo "========================================"
echo "DOWNSLOPE INFLUENCE"
echo "========================================"

run_test "areadinf with weight grid" "Base" "mpiexec -np 1 $TAUDEM_PATH/areadinf -ang loganang.tif -wg logandg.tif -sca logandi.tif"
run_test "dinfupdependence" "Base" "mpiexec -n 2 $TAUDEM_PATH/dinfupdependence -ang loganang.tif -dg logandg.tif -dep logandep.tif"
run_test "dinfdecayaccum" "Base" "mpiexec -n 7 $TAUDEM_PATH/dinfdecayaccum -ang loganang.tif -dm logandm08.tif -dsca logandsca.tif"
run_test "dinfconclimaccum" "Base" "mpiexec -n 3 $TAUDEM_PATH/dinfconclimaccum -ang loganang.tif -dm logandm08.tif -dg logandg.tif -ctpt loganctpt.tif -q logansca.tif"
run_test "dinfconclimaccum with outlet" "Base" "mpiexec -n 5 $TAUDEM_PATH/dinfconclimaccum -ang loganang.tif -dm logandm08.tif -dg logandg.tif -ctpt loganctpto.tif -q logansca.tif -o Outlet.shp -csol 2.4"

# ========================================
# Transport Limited Accumulation
# ========================================
echo ""
echo "========================================"
echo "TRANSPORT LIMITED ACCUMULATION"
echo "========================================"

run_test "dinftranslimaccum" "Base" "mpiexec -n 7 $TAUDEM_PATH/dinftranslimaccum -ang loganang.tif -tsup logantsup.tif -tc logantc.tif -tla logantla.tif -tdep logantdep.tif"
run_test "dinftranslimaccum with outlet" "Base" "mpiexec -n 6 $TAUDEM_PATH/dinftranslimaccum -ang loganang.tif -tsup logantsup.tif -tc logantc.tif -tla logantla1.tif -tdep logantdep1.tif -o Outlet.shp -cs logandg.tif -ctpt loganctpt1.tif"

# ========================================
# Reverse Accumulation
# ========================================
echo ""
echo "========================================"
echo "REVERSE ACCUMULATION"
echo "========================================"

run_test "dinfrevaccum" "Base" "mpiexec -n 4 $TAUDEM_PATH/dinfrevaccum -ang loganang.tif -wg logandg.tif -racc loganracc.tif -dmax loganrdmax.tif"

# ========================================
# Move Outlets
# ========================================
echo ""
echo "========================================"
echo "MOVE OUTLETS"
echo "========================================"

run_test "threshold for move outlets" "Base" "mpiexec -n 5 $TAUDEM_PATH/threshold -ssa loganad8.tif -src logansrc2.tif -thresh 200"
run_test "moveoutletstostreams" "Base" "mpiexec -np 3 $TAUDEM_PATH/moveoutletstostreams -p loganp.tif -src logansrc.tif -o OutletstoMove.shp -om Outletsmoved.shp -md 20"

# ========================================
# Distance Down
# ========================================
echo ""
echo "========================================"
echo "DISTANCE DOWN"
echo "========================================"

run_test "dinfdistdown ave h" "Base" "mpiexec -n 1 $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddhave.tif"
run_test "dinfdistdown min h" "Base" "mpiexec -n 2 $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddhmin.tif -m min h"
run_test "dinfdistdown max h" "Base" "mpiexec -n 3 $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddhmax.tif -m max h"
run_test "dinfdistdown ave v" "Base" "mpiexec -n 4 $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddvave.tif -m ave v"
run_test "dinfdistdown min v" "Base" "mpiexec -n 5 $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddvmin.tif -m min v"
run_test "dinfdistdown max v" "Base" "mpiexec -n 6 $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddvmax.tif -m max v"
run_test "dinfdistdown ave s" "Base" "mpiexec -n 7 $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddsave.tif -m ave s"
run_test "dinfdistdown min s" "Base" "mpiexec -n 8 $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddsmin.tif -m min s"
run_test "dinfdistdown max s" "Base" "mpiexec -n 1 $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddsmax.tif -m max s"
run_test "dinfdistdown ave p" "Base" "mpiexec -n 2 $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddpave.tif -m ave p"
run_test "dinfdistdown min p" "Base" "mpiexec -n 3 $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddpmin.tif -m min p"
run_test "dinfdistdown max p" "Base" "mpiexec -n 4 $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddpmax.tif -m max p"
run_test "dinfdistdown ave v -nc" "Base" "mpiexec -n 2 $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddvavenc.tif -m ave v -nc"
run_test "dinfdistdown min h -nc" "Base" "mpiexec -n 3 $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddhminnc.tif -m min h -nc"
run_test "dinfdistdown max p -nc" "Base" "mpiexec -n 4 $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddpmaxnc.tif -m max p -nc"
run_test "dinfdistdown max s -nc" "Base" "mpiexec -n 4 $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddsmaxnc.tif -m max s -nc"
run_test "dinfdistdown max s with wg" "Base" "mpiexec -n 4 $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddsmaxwg.tif -m max s -wg logandwg.tif"
run_test "dinfdistdown ave h with wg" "Base" "mpiexec -n 4 $TAUDEM_PATH/dinfdistdown -ang loganang.tif -fel loganfel.tif -src logansrc.tif -dd loganddhavewg.tif -m ave h -wg logandwg.tif"

# ========================================
# Distance Up
# ========================================
echo ""
echo "========================================"
echo "DISTANCE UP"
echo "========================================"

run_test "dinfdistup ave h" "Base" "mpiexec -n 1 $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduhave.tif"
run_test "dinfdistup min h with thresh" "Base" "mpiexec -n 2 $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduhmin.tif -m min h -thresh 0.5"
run_test "dinfdistup max h with thresh" "Base" "mpiexec -n 3 $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduhmax.tif -m max h -thresh 0.8"
run_test "dinfdistup ave v" "Base" "mpiexec -n 4 $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduvave.tif -m ave v"
run_test "dinfdistup min v" "Base" "mpiexec -n 5 $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduvmin.tif -m min v"
run_test "dinfdistup max v" "Base" "mpiexec -n 6 $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduvmax.tif -m max v"
run_test "dinfdistup ave s with thresh" "Base" "mpiexec -n 7 $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandusave.tif -m ave s -thresh 0.9"
run_test "dinfdistup min s" "Base" "mpiexec -n 8 $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandusmin.tif -m min s"
run_test "dinfdistup max s" "Base" "mpiexec -n 1 $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandusmax.tif -m max s"
run_test "dinfdistup ave p" "Base" "mpiexec -n 2 $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandupave.tif -m ave p"
run_test "dinfdistup min p" "Base" "mpiexec -n 3 $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandupmin.tif -m min p"
run_test "dinfdistup max p" "Base" "mpiexec -n 4 $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandupmax.tif -m max p"
run_test "dinfdistup ave v -nc" "Base" "mpiexec -n 2 $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduvavenc.tif -m ave v -nc"
run_test "dinfdistup min h -nc" "Base" "mpiexec -n 3 $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du loganduhminnc.tif -m min h -nc"
run_test "dinfdistup max p -nc" "Base" "mpiexec -n 4 $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandupmaxnc.tif -m max p -nc"
run_test "dinfdistup max s -nc" "Base" "mpiexec -n 4 $TAUDEM_PATH/dinfdistup -ang loganang.tif -fel loganfel.tif -du logandusmaxnc.tif -m max s -nc"

# ========================================
# Avalanche
# ========================================
echo ""
echo "========================================"
echo "AVALANCHE"
echo "========================================"

run_test "dinfavalanche" "Base" "mpiexec -n 2 $TAUDEM_PATH/dinfavalanche -ang loganang.tif -fel loganfel.tif -ass loganass.tif -rz loganrz.tif -dfs logandfs.tif"
run_test "dinfavalanche with thresh and alpha" "Base" "mpiexec -n 3 $TAUDEM_PATH/dinfavalanche -ang loganang.tif -fel loganfel.tif -ass loganass.tif -rz loganrz1.tif -dfs logandfs1.tif -thresh 0.1 -alpha 10"
run_test "dinfavalanche with direct" "Base" "mpiexec -n 4 $TAUDEM_PATH/dinfavalanche -ang loganang.tif -fel loganfel.tif -ass loganass.tif -rz loganrz2.tif -dfs logandfs2.tif -direct -thresh 0.01 -alpha 5"

# ========================================
# Slope Average Down
# ========================================
echo ""
echo "========================================"
echo "SLOPE AVERAGE DOWN"
echo "========================================"

run_test "slopeavedown" "Base" "mpiexec -n 3 $TAUDEM_PATH/slopeavedown -p loganp.tif -fel loganfel.tif -slpd loganslpd.tif"
run_test "slopeavedown with dn" "Base" "mpiexec -n 3 $TAUDEM_PATH/slopeavedown -p loganp.tif -fel loganfel.tif -slpd loganslpd1.tif -dn 1000"

# ========================================
# Special Cases
# ========================================
echo ""
echo "========================================"
echo "SPECIAL CASES"
echo "========================================"

run_test "tiffio partitions test" "Base" "mpiexec -n 6 $TAUDEM_PATH/areadinf -ang topo3fel1ang.tif -sca topo3fel1sca.tif"
run_test "double precision test" "Base" "mpiexec -n 4 $TAUDEM_PATH/areadinf -ang demDoubleang.tif -sca demDoublesca.tif -wg demDoublewgt.tif"

# ========================================
# Gage Watershed
# ========================================
echo ""
echo "========================================"
echo "GAGE WATERSHED"
echo "========================================"

run_test "gagewatershed with id" "Base" "mpiexec -n 7 $TAUDEM_PATH/gagewatershed -p loganp.tif -o Outletsmoved.shp -gw logangw.tif -id gwid.txt"
run_test "gagewatershed no id" "Base" "mpiexec -n 4 $TAUDEM_PATH/gagewatershed -p loganp.tif -o Outletsmoved.shp -gw logangw1.tif"
run_test "gagewatershed img with upid" "Base" "mpiexec -n 5 $TAUDEM_PATH/gagewatershed -p logantp.img -o Outletsmoved2.shp -gw logangw2.tif -id gwid2.txt -upid gwup2.txt"

# ========================================
# Fort Stewart Data Tests
# ========================================
echo ""
echo "========================================"
echo "FORT STEWART DATA - STREAM BUFFER"
echo "========================================"

run_test "fts pitremove" "fts" "mpiexec -n 3 $TAUDEM_PATH/pitremove fs_small.tif"
run_test "fts dinfflowdir" "fts" "mpiexec -n 4 $TAUDEM_PATH/dinfflowdir fs_small.tif"
run_test "fts d8flowdir" "fts" "mpiexec -n 4 $TAUDEM_PATH/d8flowdir fs_small.tif"
run_test "fts aread8" "fts" "mpiexec -n 1 $TAUDEM_PATH/aread8 fs_small.tif"
run_test "fts threshold" "fts" "mpiexec -n 2 $TAUDEM_PATH/threshold -ssa fs_smallad8.tif -src fs_smallsrc.tif -thresh 500"
run_test "fts dinfdistdown with buffer" "fts" "mpiexec -n 5 $TAUDEM_PATH/dinfdistdown -ang fs_smallang.tif -fel fs_smallfel.tif -src fs_smallsrc.tif -dd fs_smallddhavewg.tif -m ave h -wg streambuffreclass2.tif"

# ========================================
# File Format Tests
# ========================================
echo ""
echo "========================================"
echo "FILE FORMAT TESTS"
echo "========================================"

run_test "compressed 16-bit unsigned" "Base" "mpiexec -n 8 $TAUDEM_PATH/pitremove MED_01_01.tif"
run_test "VRT format" "Base" "mpiexec -n 8 $TAUDEM_PATH/pitremove -z LoganVRT/output.vrt -fel loganvrtfel.tif"
run_test "IMG format" "Base" "mpiexec -n 8 $TAUDEM_PATH/pitremove -z loganIMG/logan.img -fel loganimgfel.tif"
run_test "ESRIGRID format" "Base" "mpiexec -n 8 $TAUDEM_PATH/pitremove -z loganESRIGRID/logan -fel loganesrigridfel.tif"

# ========================================
# Geographic Coordinate Tests
# ========================================
echo ""
echo "========================================"
echo "GEOGRAPHIC COORDINATE SYSTEM TESTS"
echo "========================================"

run_test "geo pitremove" "Geographic" "mpiexec -np 3 $TAUDEM_PATH/pitremove enogeo.tif"
run_test "geo d8flowdir" "Geographic" "mpiexec -n 5 $TAUDEM_PATH/d8flowdir -p enogeop.tif -sd8 enogeosd8.tif -fel enogeofel.tif"
run_test "geo dinfflowdir" "Geographic" "mpiexec -n 4 $TAUDEM_PATH/dinfflowdir -ang enogeoang.tif -slp enogeoslp.tif -fel enogeofel.tif"
run_test "geo aread8" "Geographic" "mpiexec -np 4 $TAUDEM_PATH/aread8 enogeo.tif"
run_test "geo areadinf" "Geographic" "mpiexec -np 12 $TAUDEM_PATH/areadinf enogeo.tif"
run_test "geo aread8 with outlet" "Geographic" "mpiexec -n 7 $TAUDEM_PATH/aread8 -p enogeop.tif -o Outlets.shp -ad8 enogeoad8o.tif"
run_test "geo areadinf with outlet" "Geographic" "mpiexec -n 1 $TAUDEM_PATH/areadinf -ang enogeoang.tif -o Outlets.shp -sca enogeoscao.tif"
run_test "geo gridnet" "Geographic" "mpiexec -n 5 $TAUDEM_PATH/gridnet -p enogeop.tif -plen enogeoplen.tif -tlen enogeotlen.tif -gord enogeogord.tif"
run_test "geo gridnet with mask" "Geographic" "mpiexec -n 5 $TAUDEM_PATH/gridnet -p enogeop.tif -plen enogeoplen1.tif -tlen enogeotlen1.tif -gord enogeogord1.tif -mask enogeoad8.tif -thresh 100"
run_test "geo gridnet with outlet" "Geographic" "mpiexec -n 7 $TAUDEM_PATH/gridnet -p enogeop.tif -plen enogeoplen2.tif -tlen enogeotlen2.tif -gord enogeogord2.tif -o Outlets.shp"
run_test "geo peukerdouglas" "Geographic" "mpiexec -np 7 $TAUDEM_PATH/peukerdouglas -fel enogeofel.tif -ss enogeoss.tiff"
run_test "geo aread8 with wg" "Geographic" "mpiexec -n 4 $TAUDEM_PATH/aread8 -p enogeop.tif -o Outlets.shp -ad8 enogeossa.tif -wg enogeoss.tiff"
run_test "geo dropanalysis" "Geographic" "mpiexec -n 4 $TAUDEM_PATH/dropanalysis -p enogeop.tif -fel enogeofel.tif -ad8 enogeoad8.tif -ssa enogeossa.tif -drp enogeodrp.txt -o Outlets.shp -par 5 500 10 0"
run_test "geo threshold" "Geographic" "mpiexec -n 5 $TAUDEM_PATH/threshold -ssa enogeossa.tif -src enogeosrc.tif -thresh 180"
run_test "geo streamnet" "Geographic" "mpiexec -n 5 $TAUDEM_PATH/streamnet -fel enogeofel.tif -p enogeop.tif -ad8 enogeoad8.tif -src enogeosrc.tif -ord enogeoord3.tif -tree enogeotree.dat -coord enogeocoord.dat -net enogeonet.shp -w enogeow.tif -o Outlets.shp"
run_test "geo slopearea" "Geographic" "mpiexec -n 3 $TAUDEM_PATH/slopearea -slp enogeoslp.tif -sca enogeosca.tif -sa enogeosa.tif -par 2 1"
run_test "geo d8flowpathextremeup" "Geographic" "mpiexec -n 8 $TAUDEM_PATH/d8flowpathextremeup -p enogeop.tif -sa enogeosa.tif -ssa enogeossa1.tif -o Outlets.shp"
run_test "geo dropanalysis slope area" "Geographic" "mpiexec -n 4 $TAUDEM_PATH/dropanalysis -p enogeop.tif -fel enogeofel.tif -ad8 enogeoad8.tif -ssa enogeossa1.tif -drp enogeodrp1.txt -o Outlets.shp -par 10 2000 10 1"
run_test "geo threshold slope area" "Geographic" "mpiexec -n 5 $TAUDEM_PATH/threshold -ssa enogeossa1.tif -src enogeosrc1.tif -thresh 32"
run_test "geo streamnet slope area" "Geographic" "mpiexec -n 8 $TAUDEM_PATH/streamnet -fel enogeofel.tif -p enogeop.tif -ad8 enogeoad8.tif -src enogeosrc1.tif -ord enogeoord5.tif -tree enogeotree1.dat -coord enogeocoord1.dat -net enogeonet1.shp -w enogeow1.tif -o Outlets.shp -sw"
run_test "geo lengtharea" "Geographic" "mpiexec -n 3 $TAUDEM_PATH/lengtharea -plen enogeoplen.tif -ad8 enogeoad8.tif -ss enogeolass.tif -par 0.03 1.3"
run_test "geo slopearearatio" "Geographic" "mpiexec -n 3 $TAUDEM_PATH/slopearearatio -slp enogeoslp.tif -sca enogeosca.tif -sar enogeosar.tif"
run_test "geo d8hdisttostrm thresh" "Geographic" "mpiexec -np 7 $TAUDEM_PATH/d8hdisttostrm -p enogeop.tif -src enogeoad8.tif -dist enogeodist1.tif -thresh 200"
run_test "geo d8hdisttostrm" "Geographic" "mpiexec -np 5 $TAUDEM_PATH/d8hdisttostrm -p enogeop.tif -src enogeosrc.tif -dist enogeodist.tif"
run_test "geo threshold for move" "Geographic" "mpiexec -n 5 $TAUDEM_PATH/threshold -ssa enogeoad8.tif -src enogeosrc2.tif -thresh 200"
run_test "geo moveoutletstostreams" "Geographic" "mpiexec -np 3 $TAUDEM_PATH/moveoutletstostreams -p enogeop.tif -src enogeosrc.tif -o Outlets.shp -om Outletsmoved.shp -md 20"
run_test "geo dinfdistdown ave h" "Geographic" "mpiexec -n 1 $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddhave.tif"
run_test "geo dinfdistdown min h" "Geographic" "mpiexec -n 2 $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddhmin.tif -m min h"
run_test "geo dinfdistdown max h" "Geographic" "mpiexec -n 3 $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddhmax.tif -m max h"
run_test "geo dinfdistdown ave v" "Geographic" "mpiexec -n 4 $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddvave.tif -m ave v"
run_test "geo dinfdistdown min v" "Geographic" "mpiexec -n 5 $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddvmin.tif -m min v"
run_test "geo dinfdistdown max v" "Geographic" "mpiexec -n 6 $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddvmax.tif -m max v"
run_test "geo dinfdistdown ave s" "Geographic" "mpiexec -n 7 $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddsave.tif -m ave s"
run_test "geo dinfdistdown min s" "Geographic" "mpiexec -n 8 $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddsmin.tif -m min s"
run_test "geo dinfdistdown max s" "Geographic" "mpiexec -n 1 $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddsmax.tif -m max s"
run_test "geo dinfdistdown ave p" "Geographic" "mpiexec -n 2 $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddpave.tif -m ave p"
run_test "geo dinfdistdown min p" "Geographic" "mpiexec -n 3 $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddpmin.tif -m min p"
run_test "geo dinfdistdown max p" "Geographic" "mpiexec -n 4 $TAUDEM_PATH/dinfdistdown -ang enogeoang.tif -fel enogeofel.tif -src enogeosrc.tif -dd enogeoddpmax.tif -m max p"
run_test "geo dinfdistup ave h" "Geographic" "mpiexec -n 1 $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeoduhave.tif"
run_test "geo dinfdistup min h thresh" "Geographic" "mpiexec -n 2 $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeoduhmin.tif -m min h -thresh 0.5"
run_test "geo dinfdistup max v" "Geographic" "mpiexec -n 6 $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeoduvmax.tif -m max v"
run_test "geo dinfdistup ave s thresh" "Geographic" "mpiexec -n 7 $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeodusave.tif -m ave s -thresh 0.9"
run_test "geo dinfdistup min s" "Geographic" "mpiexec -n 8 $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeodusmin.tif -m min s"
run_test "geo dinfdistup max s" "Geographic" "mpiexec -n 1 $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeodusmax.tif -m max s"
run_test "geo dinfdistup ave p" "Geographic" "mpiexec -n 2 $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeodupave.tif -m ave p"
run_test "geo dinfdistup min p" "Geographic" "mpiexec -n 3 $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeodupmin.tif -m min p"
run_test "geo dinfdistup max p" "Geographic" "mpiexec -n 4 $TAUDEM_PATH/dinfdistup -ang enogeoang.tif -fel enogeofel.tif -du enogeodupmax.tif -m max p"
run_test "geo slopeavedown" "Geographic" "mpiexec -n 3 $TAUDEM_PATH/slopeavedown -p enogeop.tif -fel enogeofel.tif -slpd enogeoslpd.tif"
run_test "geo gagewatershed" "Geographic" "mpiexec -n 7 $TAUDEM_PATH/gagewatershed -p enogeop.tif -o Outletsmoved.shp -gw enogeogw.tif -id gwid.txt"

# ========================================
# Grid Types Tests
# ========================================
echo ""
echo "========================================"
echo "GRID TYPES TESTS"
echo "========================================"

run_test "gridtypes pitremove tif" "gridtypes" "mpiexec -np 3 $TAUDEM_PATH/pitremove logan.tif"
run_test "gridtypes img output" "gridtypes" "mpiexec -np 3 $TAUDEM_PATH/pitremove -z logan.tif -fel loganfelim.img"
run_test "gridtypes sdat output" "gridtypes" "mpiexec -np 3 $TAUDEM_PATH/pitremove -z logan.tif -fel loganfelsd.sdat"
run_test "gridtypes bil output" "gridtypes" "mpiexec -np 3 $TAUDEM_PATH/pitremove -z logan.tif -fel loganfel.bil"
run_test "gridtypes bin output" "gridtypes" "mpiexec -np 3 $TAUDEM_PATH/pitremove -z logan.tif -fel loganfel1.bin"
run_test "gridtypes d8flowdir mixed" "gridtypes" "mpiexec -np 3 $TAUDEM_PATH/d8flowdir -fel loganfel1.bin -p bilp.bil -sd8 binsd8.bin"
run_test "gridtypes aread8 mixed" "gridtypes" "mpiexec -n 5 $TAUDEM_PATH/aread8 -p bilp.bil -ad8 loganad8.img"
run_test "gridtypes dinfflowdir mixed" "gridtypes" "mpiexec -n 2 $TAUDEM_PATH/dinfflowdir -fel loganfel.bil -ang ang.ang -slp slp.slp"
run_test "gridtypes lg extension" "gridtypes" "mpiexec -np 3 $TAUDEM_PATH/pitremove -z logan.tif -fel loganfel2.lg"
run_test "gridtypes no extension" "gridtypes" "mpiexec -np 3 $TAUDEM_PATH/pitremove -z logan.tif -fel loganfel3"

# =======================================
# Sinmap Parameter Region Tests
# ========================================
echo ""
echo "========================================"
echo "SINMAP PARAMETER REGION TESTS"
echo "========================================"
run_test "siregion based on feature Id" "sinmapsi" "mpiexec -n 3 $TAUDEM_PATH/siregion -dem dem -parreg demregsh.tif -att demparsh.csv -shp regions.shp -shp-att-name Id"
run_test "siregion based on feature FID" "sinmapsi" "mpiexec -n 3 $TAUDEM_PATH/siregion -dem dem -parreg demregsh-fid.tif -att demparsh-fid.csv -shp regions.shp -shp-att-name FID"
run_test "siregion based on raster" "sinmapsi" "mpiexec -n 3 $TAUDEM_PATH/siregion -dem dem -parreg demregkilp.tif -att demparkilp.csv -parreg-in kilpreg3.tif"
run_test "siregion based on uniform" "sinmapsi" "mpiexec -n 3 $TAUDEM_PATH/siregion -dem dem -parreg demreg12.tif -att dempar12.csv"

# ========================================
# SinmapSI Tests
# ========================================
echo ""
echo "========================================"
echo "SINMAPSI TESTS"
echo "========================================"

run_test "sinmapsi dm" "sinmapsi" "mpiexec -n 1 $TAUDEM_PATH/sinmapsi -slp dmslp.tif -sca dmsca.tif -calpar dmcalp.txt -cal dmcal.tif -si dmsi.tif -sat dmsat.tif -par 0.0009 0.00135 9.81 1000"
run_test "sinmapsi pitremove dem" "sinmapsi" "mpiexec -n 4 $TAUDEM_PATH/pitremove dem"
run_test "sinmapsi dinfflowdir" "sinmapsi" "mpiexec -n 4 $TAUDEM_PATH/dinfflowdir -fel demfel.tif -slp demslp.tif -ang demang.tif"
run_test "sinmapsi areadinf" "sinmapsi" "mpiexec -n 2 $TAUDEM_PATH/areadinf -ang demang.tif -sca demsca.tif"
run_test "sinmapsi reg12" "sinmapsi" "mpiexec -n 3 $TAUDEM_PATH/sinmapsi -slp demslp.tif -sca demsca.tif -cal demreg12.tif -calpar dempar12.csv -si demsi1.tif -sat demsat1.tif -par 0.0009 0.00135 9.81 1000"
run_test "sinmapsi regsh" "sinmapsi" "mpiexec -n 3 $TAUDEM_PATH/sinmapsi -slp demslp.tif -sca demsca.tif -cal demregsh.tif -calpar demparsh.dat -si demsi2.tif -sat demsat2.tif -par 0.0009 0.00135 9.81 1000"

# ========================================
# SetRegion Tests
# ========================================
echo ""
echo "========================================"
echo "SETREGION TESTS"
echo "========================================"

run_test "setregion" "SetRegion" "mpiexec -n 3 $TAUDEM_PATH/setregion -p fdrsubset.tif -gw gwsubset.tif -out region3.tif -id 3"

# ========================================
# OGR Format Tests
# ========================================
echo ""
echo "========================================"
echo "OGR FORMAT TESTS - AREAD8"
echo "========================================"

run_test "ogr aread8 shp" "AreaD8_data" "mpiexec -n 7 $TAUDEM_PATH/aread8 -p loganp.tif -o LoganOutlet.shp -ad8 loganad8_1.tif"
run_test "ogr aread8 sqlite" "AreaD8_data" "mpiexec -n 3 $TAUDEM_PATH/aread8 -p loganp.tif -o LoganSample.sqlite -lyrname LoganOutlet -ad8 loganad8_3.tif"
run_test "ogr aread8 json" "AreaD8_data" "mpiexec -n 4 $TAUDEM_PATH/aread8 -p loganp.tif -o LoganOutlet.json -ad8 loganad8_4.tif"
run_test "ogr aread8 json lyrname" "AreaD8_data" "mpiexec -n 6 $TAUDEM_PATH/aread8 -p loganp.tif -o LoganOutlet.json -lyrname LoganOutlet -ad8 loganad8_5.tif"
run_test "ogr aread8 gdb" "AreaD8_data" "mpiexec -n 7 $TAUDEM_PATH/aread8 -p loganp.tif -o Logan.gdb -ad8 loganad8_6.tif"
run_test "ogr aread8 gdb lyrname" "AreaD8_data" "mpiexec -n 5 $TAUDEM_PATH/aread8 -p loganp.tif -o Logan.gdb -lyrname Outlet -ad8 loganad8_7.tif"
run_test "ogr aread8 gdb lyrno" "AreaD8_data" "mpiexec -n 2 $TAUDEM_PATH/aread8 -p loganp.tif -o Logan.gdb -lyrno 0 -ad8 loganad8_8.tif"

echo ""
echo "========================================"
echo "OGR FORMAT TESTS - AREADINF"
echo "========================================"

run_test "ogr areadinf shp" "AreaDinf" "mpiexec -n 7 $TAUDEM_PATH/areadinf -ang loganang.tif -o LoganOutlet.shp -sca logansca_1.tif"
run_test "ogr areadinf sqlite lyrno" "AreaDinf" "mpiexec -n 1 $TAUDEM_PATH/areadinf -ang loganang.tif -o LoganSample.sqlite -lyrno 1 -sca logansca_2.tif"
run_test "ogr areadinf sqlite lyrname" "AreaDinf" "mpiexec -n 3 $TAUDEM_PATH/areadinf -ang loganang.tif -o LoganSample.sqlite -lyrname LoganOutlet -sca logansca_3.tif"
run_test "ogr areadinf sqlite lyrno 2" "AreaDinf" "mpiexec -n 5 $TAUDEM_PATH/areadinf -ang loganang.tif -o LoganSample.sqlite -lyrno 1 -sca logansca_4.tif"
run_test "ogr areadinf json" "AreaDinf" "mpiexec -n 3 $TAUDEM_PATH/areadinf -ang loganang.tif -o LoganOutlet.json -sca logansca_5.tif"
run_test "ogr areadinf json lyrname" "AreaDinf" "mpiexec -n 5 $TAUDEM_PATH/areadinf -ang loganang.tif -o LoganOutlet.json -lyrname LoganOutlet -sca logansca_6.tif"
run_test "ogr areadinf gdb" "AreaDinf" "mpiexec -n 5 $TAUDEM_PATH/areadinf -ang loganang.tif -o Logan.gdb -sca logansca_7.tif"
run_test "ogr areadinf gdb lyrname" "AreaDinf" "mpiexec -n 3 $TAUDEM_PATH/areadinf -ang loganang.tif -o Logan.gdb -lyrname Outlet -sca logansca_8.tif"
run_test "ogr areadinf gdb lyrno" "AreaDinf" "mpiexec -n 6 $TAUDEM_PATH/areadinf -ang loganang.tif -o Logan.gdb -lyrno 0 -sca logansca_9.tif"

echo ""
echo "========================================"
echo "OGR FORMAT TESTS - GRIDNET"
echo "========================================"

run_test "ogr gridnet shp" "Gridnet" "mpiexec -n 7 $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen1.tif -tlen logantlen1.tif -gord logangord1.tif -o LoganOutlet.shp"
run_test "ogr gridnet sqlite" "Gridnet" "mpiexec -n 6 $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen3.tif -tlen logantlen3.tif -gord logangord3.tif -o LoganSample.sqlite -lyrname LoganOutlet"
run_test "ogr gridnet sqlite lyrno" "Gridnet" "mpiexec -n 3 $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen4.tif -tlen logantlen4.tif -gord logangord4.tif -o LoganSample.sqlite -lyrno 1"
run_test "ogr gridnet json" "Gridnet" "mpiexec -n 3 $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen5.tif -tlen logantlen5.tif -gord logangord5.tif -o LoganOutlet.json"
run_test "ogr gridnet json lyrname" "Gridnet" "mpiexec -n 7 $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen6.tif -tlen logantlen6.tif -gord logangord6.tif -o LoganOutlet.json -lyrname LoganOutlet"
run_test "ogr gridnet gdb" "Gridnet" "mpiexec -n 1 $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen7.tif -tlen logantlen7.tif -gord logangord7.tif -o Logan.gdb"
run_test "ogr gridnet gdb lyrname" "Gridnet" "mpiexec -n 3 $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen8.tif -tlen logantlen8.tif -gord logangord8.tif -o Logan.gdb -lyrname Outlet"
run_test "ogr gridnet gdb lyrno" "Gridnet" "mpiexec -n 2 $TAUDEM_PATH/gridnet -p loganp.tif -plen loganplen9.tif -tlen logantlen9.tif -gord logangord9.tif -o Logan.gdb -lyrno 0"

echo ""
echo "========================================"
echo "OGR FORMAT TESTS - DROPANALYSIS"
echo "========================================"

run_test "ogr dropanalysis shp" "peukerDouglas" "mpiexec -n 1 $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp1.txt -o LoganOutlet.shp -par 5 500 10 0"
run_test "ogr dropanalysis sqlite" "peukerDouglas" "mpiexec -n 5 $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp3.txt -o LoganSample.sqlite -lyrname LoganOutlet -par 5 500 10 0"
run_test "ogr dropanalysis sqlite lyrno" "peukerDouglas" "mpiexec -n 2 $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp4.txt -o LoganSample.sqlite -lyrno 1 -par 5 500 10 0"
run_test "ogr dropanalysis json" "peukerDouglas" "mpiexec -n 5 $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp5.txt -o LoganOutlet.json -par 5 500 10 0"
run_test "ogr dropanalysis json lyrname" "peukerDouglas" "mpiexec -n 4 $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp6.txt -o LoganOutlet.json -lyrname LoganOutlet -par 5 500 10 0"
run_test "ogr dropanalysis gdb" "peukerDouglas" "mpiexec -n 3 $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp7.txt -o Logan.gdb -par 5 500 10 0"
run_test "ogr dropanalysis gdb lyrname" "peukerDouglas" "mpiexec -n 5 $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp8.txt -o Logan.gdb -lyrname Outlet -par 5 500 10 0"
run_test "ogr dropanalysis gdb lyrno" "peukerDouglas" "mpiexec -n 6 $TAUDEM_PATH/dropanalysis -p loganp.tif -fel loganfel.tif -ad8 loganad8.tif -ssa loganssa.tif -drp logandrp9.txt -o Logan.gdb -lyrno 0 -par 5 500 10 0"

echo ""
echo "========================================"
echo "OGR FORMAT TESTS - STREAMNET"
echo "========================================"

run_test "ogr streamnet shp" "streamnet_data" "mpiexec -n 5 $TAUDEM_PATH/streamnet -fel loganfel.tif -p loganp.tif -ad8 loganad8.tif -src logansrc.tif -ord loganord3.tif -tree logantree.dat -coord logancoord.dat -net logannet1.shp -w loganw.tif -o LoganOutlet.shp"
run_test "ogr streamnet sqlite" "streamnet_data" "mpiexec -n 3 $TAUDEM_PATH/streamnet -fel loganfel.tif -p loganp.tif -ad8 loganad8.tif -src logansrc.tif -ord loganord3.tif -tree logantree.dat -coord logancoord.dat -net LoganSample.sqlite -netlyr Mynetwork.shp -w loganw.tif -o LoganSample.sqlite -lyrname LoganOutlet"
run_test "ogr streamnet kml gdb" "streamnet_data" "mpiexec -n 7 $TAUDEM_PATH/streamnet -fel loganfel.tif -p loganp.tif -ad8 loganad8.tif -src logansrc.tif -ord loganord3.tif -tree logantree.dat -coord logancoord.dat -net logannet3.kml -netlyr logannet3 -w loganw.tif -o Logan.gdb -lyrname Outlet"
run_test "ogr streamnet json gdb" "streamnet_data" "mpiexec -n 7 $TAUDEM_PATH/streamnet -fel loganfel.tif -p loganp.tif -ad8 loganad8.tif -src logansrc.tif -ord loganord3.tif -tree logantree.dat -coord logancoord.dat -net logannet3.json -netlyr logannet3 -w loganw.tif -o Logan.gdb -lyrno 0"
run_test "ogr streamnet json json" "streamnet_data" "mpiexec -n 5 $TAUDEM_PATH/streamnet -fel loganfel.tif -p loganp.tif -ad8 loganad8.tif -src logansrc.tif -ord loganord3.tif -tree logantree.dat -coord logancoord.dat -net logannet4.json -netlyr logannet4 -w loganw.tif -o LoganOutlet.json -lyrno 0"

echo ""
echo "========================================"
echo "OGR FORMAT TESTS - D8FLOWPATHEXTREMEUP"
echo "========================================"

run_test "ogr d8flowpathextremeup shp" "D8flowextreme" "mpiexec -n 3 $TAUDEM_PATH/d8flowpathextremeup -p loganp.tif -sa logansa.tif -ssa loganssa1.tif -o LoganOutlet.shp"
run_test "ogr d8flowpathextremeup sqlite" "D8flowextreme" "mpiexec -n 5 $TAUDEM_PATH/d8flowpathextremeup -p loganp.tif -sa logansa.tif -ssa loganssa2.tif -o LoganSample.sqlite -lyrname LoganOutlet"
run_test "ogr d8flowpathextremeup sqlite lyrno" "D8flowextreme" "mpiexec -n 7 $TAUDEM_PATH/d8flowpathextremeup -p loganp.tif -sa logansa.tif -ssa loganssa3.tif -o LoganSample.sqlite -lyrno 1"
run_test "ogr d8flowpathextremeup gdb" "D8flowextreme" "mpiexec -n 1 $TAUDEM_PATH/d8flowpathextremeup -p loganp.tif -sa logansa.tif -ssa loganssa4.tif -o Logan.gdb"
run_test "ogr d8flowpathextremeup gdb lyrno" "D8flowextreme" "mpiexec -n 8 $TAUDEM_PATH/d8flowpathextremeup -p loganp.tif -sa logansa.tif -ssa loganssa5.tif -o Logan.gdb -lyrno 0"

echo ""
echo "========================================"
echo "OGR FORMAT TESTS - DINFCONCLIMACCUM"
echo "========================================"

run_test "ogr dinfconclimaccum shp" "DinfConcLimAccum" "mpiexec -n 1 $TAUDEM_PATH/dinfconclimaccum -ang loganang.tif -dm logandm08.tif -dg logandg.tif -ctpt loganctpto1.img -q logansca.tif -o LoganOutlet.shp -csol 2.4"
run_test "ogr dinfconclimaccum sqlite" "DinfConcLimAccum" "mpiexec -n 5 $TAUDEM_PATH/dinfconclimaccum -ang loganang.tif -dm logandm08.tif -dg logandg.tif -ctpt loganctpto2.tif -q logansca.tif -o LoganSample.sqlite -lyrname LoganOutlet -csol 2.4"
run_test "ogr dinfconclimaccum gdb" "DinfConcLimAccum" "mpiexec -n 7 $TAUDEM_PATH/dinfconclimaccum -ang loganang.tif -dm logandm08.tif -dg logandg.tif -ctpt loganctpto4.tif -q logansca.tif -o Logan.gdb -csol 2.4"
run_test "ogr dinfconclimaccum gdb lyrno" "DinfConcLimAccum" "mpiexec -n 8 $TAUDEM_PATH/dinfconclimaccum -ang loganang.tif -dm logandm08.tif -dg logandg.tif -ctpt loganctpto5.tif -q logansca.tif -o Logan.gdb -lyrno 0 -csol 2.4"

echo ""
echo "========================================"
echo "OGR FORMAT TESTS - DINFTRANSLIMACCUM"
echo "========================================"

run_test "ogr dinftranslimaccum shp" "DinfTransLimAcc" "mpiexec -n 2 $TAUDEM_PATH/dinftranslimaccum -ang loganang.tif -tsup logantsup.tif -tc logantc.tif -tla logantla1.img -tdep logantdep1.tif -o LoganOutlet.shp -cs logandg.tif -ctpt loganctpt1.tif"
run_test "ogr dinftranslimaccum sqlite" "DinfTransLimAcc" "mpiexec -n 6 $TAUDEM_PATH/dinftranslimaccum -ang loganang.tif -tsup logantsup.tif -tc logantc.tif -tla logantla2.tif -tdep logantdep2.tif -o LoganSample.sqlite -lyrname LoganOutlet -cs logandg.tif -ctpt loganctpt2.tif"
run_test "ogr dinftranslimaccum gdb" "DinfTransLimAcc" "mpiexec -n 5 $TAUDEM_PATH/dinftranslimaccum -ang loganang.tif -tsup logantsup.tif -tc logantc.tif -tla logantla4.tif -tdep logantdep4.tif -o Logan.gdb -cs logandg.tif -ctpt loganctpt4.tif"
run_test "ogr dinftranslimaccum json" "DinfTransLimAcc" "mpiexec -n 7 $TAUDEM_PATH/dinftranslimaccum -ang loganang.tif -tsup logantsup.tif -tc logantc.tif -tla logantla5.tif -tdep logantdep5.tif -o LoganOutlet.json -cs logandg.tif -ctpt loganctpt5.tif"

echo ""
echo "========================================"
echo "OGR FORMAT TESTS - MOVEOUTLETSTOSTREAMS"
echo "========================================"

run_test "ogr moveoutletstostreams shp" "MovedOutletstoStream_data" "mpiexec -np 1 $TAUDEM_PATH/moveoutletstostreams -p loganp.tif -src logansrc.tif -o OutletstoMove.shp -om Outletsmoved.shp -md 20"
run_test "ogr moveoutletstostreams json kml" "MovedOutletstoStream_data" "mpiexec -np 3 $TAUDEM_PATH/moveoutletstostreams -p loganp.tif -src logansrc.tif -o OutletstoMove.json -om Outletsmoved.kml -md 20"
run_test "ogr moveoutletstostreams sqlite kml" "MovedOutletstoStream_data" "mpiexec -np 4 $TAUDEM_PATH/moveoutletstostreams -p loganp.tif -src logansrc.tif -o LoganSample.sqlite -lyrno 2 -om Outletsmoved5.kml -md 20"
run_test "ogr moveoutletstostreams gdb json" "MovedOutletstoStream_data" "mpiexec -np 7 $TAUDEM_PATH/moveoutletstostreams -p loganp.tif -src logansrc.tif -o Logan.gdb -lyrno 0 -om Outletsmove.json -md 20"

echo ""
echo "========================================"
echo "OGR FORMAT TESTS - GAGEWATERSHED"
echo "========================================"

run_test "ogr gagewatershed shp" "GageWatershed" "mpiexec -n 1 $TAUDEM_PATH/gagewatershed -p loganp.tif -o LoganOutlet.shp -gw logangw1.tif -id gwid1.txt"
run_test "ogr gagewatershed gdb" "GageWatershed" "mpiexec -n 3 $TAUDEM_PATH/gagewatershed -p loganp.tif -o Logan.gdb -gw logangw3.tif -id gwid3.txt"
run_test "ogr gagewatershed gdb lyrno" "GageWatershed" "mpiexec -n 5 $TAUDEM_PATH/gagewatershed -p loganp.tif -o Logan.gdb -lyrno 0 -gw logangw3.tif -id gwid3.txt"
run_test "ogr gagewatershed json" "GageWatershed" "mpiexec -n 7 $TAUDEM_PATH/gagewatershed -p loganp.tif -o LoganOutlet.json -gw logangw4.tif -id gwid4.txt"

echo ""
echo "========================================"
echo "CONNECT DOWN"
echo "========================================"

run_test "connectdown simple" "ConnectDown" "mpiexec -n 1 $TAUDEM_PATH/ConnectDown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganOutlets1.shp -od loganOutlets_Moved1.shp -d 1"
run_test "connectdown shp with layer" "ConnectDown" "mpiexec -n 3 $TAUDEM_PATH/ConnectDown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganOutlets2.shp -olyr loganOutlets2 -od loganOutlets_Moved2.shp -odlyr loganOutlets2 -d 1"
run_test "connectdown sqlite two layers" "ConnectDown" "mpiexec -n 5 $TAUDEM_PATH/ConnectDown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganSample.sqlite -olyr myoutlet1 -od loganSample.sqlite -odlyr myoutlet2 -d 1"
run_test "connectdown kml simple" "ConnectDown" "mpiexec -n 7 $TAUDEM_PATH/ConnectDown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganOutlets2.kml -od loganOutlets_Moved2.kml -d 1"
run_test "connectdown kml with layer" "ConnectDown" "mpiexec -n 1 $TAUDEM_PATH/ConnectDown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganOutlets3.kml -olyr loganOutlets3 -od loganOutlets_Moved3.kml -odlyr loganOutlets_Moved3 -d 1"
run_test "connectdown json simple" "ConnectDown" "mpiexec -n 3 $TAUDEM_PATH/ConnectDown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganOutlets4.json -od loganOutlets_Moved2.json -d 1"
run_test "connectdown kml with layer (n=8)" "ConnectDown" "mpiexec -n 8 $TAUDEM_PATH/ConnectDown -p loganp.tif -ad8 loganad8.tif -w logangw.tif -o loganOutlets3.kml -olyr loganOutlets3 -od loganOutlets_Moved3.kml -odlyr loganOutlets_Moved3 -d 1"

echo ""
echo "========================================"
echo "SPECIALIZED UNIT TESTS"
echo "========================================"

run_test "aread8 no epsg" "NoEPSG" "mpiexec -n 2 $TAUDEM_PATH/aread8 -p ma2_ep.tif -ad8 ma2_ead8.tif -o outlet.shp -nc"

run_test "moveoutlets 1" "MoveOutlets2" "mpiexec -np 8 $TAUDEM_PATH/moveoutletstostreams -p subwatershed_74p.tif -src subwatershed_74src1.tif -o mypoint.shp -om New_Outlet.shp -md 10000.0"
run_test "moveoutlets 2" "MoveOutlets2" "mpiexec -np 1 $TAUDEM_PATH/moveoutletstostreams -p subwatershed_74p.tif -src subwatershed_74src1.tif -o testpoints.shp -om New_Outlet1.shp -md 10000"
run_test "moveoutlets 3" "MoveOutlets2" "mpiexec -np 8 $TAUDEM_PATH/moveoutletstostreams -p subwatershed_74p.tif -src subwatershed_74src1.tif -o testpoints.shp -om New_Outlet2.shp -md 100"

run_test "moveoutlets 4" "MoveOutlets3" "mpiexec -np 8 $TAUDEM_PATH/moveoutletstostreams -p p.tif -src src.tif -o outlets2_geo.shp -om outlets_align.shp -md 3000"

run_test "gagewatershed unit test" "gwunittest" "mpiexec -n 4 $TAUDEM_PATH/gagewatershed -p fdr.tif -gw gw.tif -id id.txt -o CatchOutlets3.shp"

run_test "editraster" "Editraster" "mpiexec -n 2 $TAUDEM_PATH/editraster -in fdro.tif -out fdrmod.tif -changes changes.txt"

run_test "catchoutlets" "CatchOutlets" "mpiexec -n 1 $TAUDEM_PATH/catchoutlets -net net1.shp -p fdr.tif -o CatchOutlets.shp -mindist 20000 -minarea 50000000 -gwstartno 5"

run_test "flowdircond" "FlowdirCond" "mpiexec -n 4 $TAUDEM_PATH/flowdircond -z wcdem.tif -p pm.tif -zfdc wcdemzfdc.tif"

run_test "retlimflow" "RetLimFlow" "mpiexec -n 6 $TAUDEM_PATH/retlimflow -ang spawnang.tif -wg spawnwg.tif -rc spawnrc.tif -qrl spawnqrl.tif"

run_test "catchhydrogeo" "CatchHydroGeo" "mpiexec -n 4 $TAUDEM_PATH/catchhydrogeo -hand hand.tif -catch w.tif -catchlist catchlist.csv -slp slp.tif -h stage.txt -table hydropropotable.txt"

run_test "inundepth" "Inundepth" "mpiexec -n 4 $TAUDEM_PATH/inundepth -hand hand.tif -catch w.tif -fc forecast.csv -hp hydropropotable.txt -inun inundepth.tif -depth depths.csv"

run_test "aread8 gdal unset nodata" "GDAL_unset_nodata" "mpiexec -n 4 $TAUDEM_PATH/aread8 -p p.tif -ad8 ssa.tif -wg weights.tif -nc"

# ========================================
# Final Summary
# ========================================
echo ""
echo "========================================"
echo "TEST SUMMARY"
echo "========================================"
echo "Total tests: $TOTAL_TESTS"
echo "Passed: $PASSED_TESTS"
echo "Failed: $FAILED_TESTS"
echo "End time: $(date)"
echo "========================================"

# Return to original directory
cd "$ORIGINAL_DIR"

# Exit with failure code if any tests failed
if [ "$FAILED_TESTS" -gt 0 ]; then
    exit 1
fi

exit 0
