Rem Script to compare results for all folders for a specific test run
Rem Usage: compareall.bat <test_run_folder>
Rem E.g. compareall.bat Test > comparealltest.out  

:: Define the list
set items=Base fts Geographic gridtypes sinmapsi setregion AreaD8_data AreaDinf Gridnet peukerDouglas streamnet_data D8flowextreme DinfConcLimAccum DinfTransLimAcc MovedOutletstoStream_data GageWatershed ConnectDown NoEPSG MoveOutlets2 MoveOutlets3 gwunittest editraster catchoutlets FlowdirCond RetLimFlow CatchHydroGeo Inundepth GDAL_unset_nodata

:: Loop over the list
for %%i in (%items%) do (
    python compare_results.py --dir1 ReferenceResult\%%i --dir2 TestRunResult\%~1\%%i
)
