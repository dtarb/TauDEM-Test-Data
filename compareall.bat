Rem Script to compare results for all folders for a specific test run
Rem Usage: compareall.bat <test_run_folder>

:: Define the list
set items=Base fts Geographic gridtypes sinmapsi AreaD8_data AreaDinf Gridnet peukerDouglas streamnet_data D8flowextreme DinfConcLimAccum DinfTransLimAcc MovedOutletstoStream_data GageWatershed ConnectDown NoEPSG MoveOutlets2 MoveOutlets3 gwunittest editraster catchoutlets FlowdirCond RetLimFlow CatchHydroGeo Inundepth GDAL_unset_nodata

:: Loop over the list
for %%i in (%items%) do (
    python compare_results.py ReferenceResult\%%i TestRunResult\%~1\%%i
)
