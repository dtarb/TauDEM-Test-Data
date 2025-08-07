# TauDEM Test Data

This repository contains input data for testing TauDEM.

## Running Tests on Windows

The suggested testing pattern is to copy the `Input` directory into `TestRunResults`, naming it for the test being done. Then cd into the new folder.

In the testing folder, ddit the `testall.bat` file to set the `TDIR` variable to the directory where the TauDEM executables exist on your machine. You need to edit the `TDIR` variable in the `testall.bat` file only if you have built TauDEM from source and have not installed it. If you have installed TauDEM, the `TDIR` variable should already point to the `bin` directory of the TauDEM installation. If you have built TauDEM executables in debug mode, the `TDIR` variable should point to the full path of TauDEM local branched version of the `build/debug/src/Debug` directory. The `Debug` directory that holds debug executables. However, if you have built TauDEM in release mode, the `TDIR` variable should point to the full path of local TauDEM branched version of the `build/release/src/Release` directory.

Run the script `testall.bat` and compare the answers to results in the `ReferenceResult` folder.

To redirect all output to a single file, use:

```sh
testall > testall.out 2>&1
```

## Running Tests on MacOS and Linux

**Note:** The `run-taudem-tests.sh` script requires [BATS](https://bats-core.readthedocs.io/en/stable/index.html) to be installed.

Set the `TAUDEM_PATH` environment variable to the directory where the TauDEM executables exist on your machine. You need to set the `TAUDEM_PATH` environment variable only if you have built TauDEM from source and have not installed it. If you have built TauDEM executables in debug mode, the `TAUDEM_PATH` environment variable should point to the TuaDEM local branched version of the `build/debug/src` directory - need to use the full path to the this directory. However, if you have built TauDEM in release mode, the `TAUDEM_PATH` environment variable should point to the local TauDEM branched version of the `build/release/src` directory - need to use the full path to this directory.

Run the script `run-taudem-tests.sh` and compare the answers to results in the `ReferenceResult` folder.

To redirect all output to a single file, use:

```sh
./run-taudem-tests.sh > testall.out 2>&1
```

**Note:** Test run output files will also be written to the `input` folder. **Do not commit any of the test run output files.**

## Comparing Results

You can use the `compare_results.py` script to compare the results. This script requires Python GDAL and numpy to be installed. It takes two directories as input and compares all matching TIF files in the two directories. It uses a maximum absolute difference threshold to compare pixel values.

Usage:

```sh
python compare_results.py [dir1] [dir2]
```

For example, to compare the results in the `input/Base` folder to the reference results in the `ReferenceResults/testfolder/Base` folder, run:

```sh
python compare_results.py input/Base ReferenceResult/Base
```
