# TauDEM Test Data

This repository contains input data for testing TauDEM.

The suggested testing pattern is to copy the `Input` directory into `TestRunResult`, naming it for the test being done. Then cd into the new folder. If the `TestRunResult` directory doesn't exist in the root of the repository, create it first and then copy the `Input` directory into it.

## Running Tests on Windows

In the testing folder, edit the `testall.bat` file to set the `TDIR` variable to the directory where the TauDEM executables exist on your machine. You need to edit the `TDIR` variable in the `testall.bat` file only if you have built TauDEM from source and have not installed it. If you have installed TauDEM, the `TDIR` variable should already point to the `bin` directory of the TauDEM installation. If you have built TauDEM executables in debug mode, the `TDIR` variable should point to the full path of TauDEM local branched version of the `build/debug/src/Debug` directory. The `Debug` directory that holds debug executables. However, if you have built TauDEM in release mode, the `TDIR` variable should point to the full path of local TauDEM branched version of the `build/release/src/Release` directory.

Run the script `testall.bat` and compare the answers to results in the `ReferenceResult` folder.

To redirect all output to a single file, use:

```sh
testall > testall.out 2>&1
```

## Running Tests on MacOS and Linux

**Note:** The `taudem-tests.sh` script requires [BATS](https://bats-core.readthedocs.io/en/stable/index.html) to be installed.

Set the `TAUDEM_PATH` environment variable to the directory where the TauDEM executables exist on your machine. You need to set the `TAUDEM_PATH` environment variable only if you have built TauDEM from source and have not installed it. If you have built TauDEM executables in debug mode, the `TAUDEM_PATH` environment variable should point to the TuaDEM local branched version of the `build/debug/src` directory - need to use the full path to the this directory. However, if you have built TauDEM in release mode, the `TAUDEM_PATH` environment variable should point to the local TauDEM branched version of the `build/release/src` directory - need to use the full path to this directory.

Run the script `taudem-tests.sh` and compare the answers to results in the `ReferenceResult` folder.

NOTE: If the output of the above test run script shows '0 tests 0 failure', then the bats test framework helper files are probably missing in the '/tmp' directory. In that case, you need to run the following commands:

```sh
git clone https://github.com/ztombol/bats-support /tmp/bats-support
git clone https://github.com/ztombol/bats-assert /tmp/bats-assert
git clone https://github.com/ztombol/bats-file /tmp/bats-file
```

To redirect all output to a single file, use:

```sh
./taudem-tests.sh > testall.out 2>&1
```

**Note:** Test run output files will also be written to the `TestRunResult/Input` folder. **Do not commit any of the test run output files.**

## Comparing Results

You can use the `compare_results.py` script to compare test results. This script requires Python, GDAL, and NumPy to be installed. It can operate in two modes: comparing two specific directories or comparing an entire test run against the reference results. This script needs to be run from the root of the repository.

### Usage

The script supports the following arguments:

- `--dir1`: Path to the first directory.
- `--dir2`: Path to the second directory.
- `--test_run_folder`: Path to a test run folder inside `TestRunResult`. Using this automates comparison against `ReferenceResult`.
- `--max_diff_threshold`: Optional. Maximum absolute difference allowed for pixel values (default is 0).

#### Mode 1: Comparing Two Directories

To compare the contents of two specific directories, use the `--dir1` and `--dir2` arguments.

```sh
python compare_results.py --dir1 [path/to/dir1] --dir2 [path/to/dir2]
```

For example, to compare a specific test output against the reference:

```sh
python compare_results.py --dir1 TestRunResult/my_test/Base --dir2 ReferenceResult/Base
```

#### Mode 2: Comparing a Full Test Run

To automatically compare all output folders from a test run against the corresponding folders in `ReferenceResult`, use the `--test_run_folder` argument. The value should be the name of the folder you created inside `TestRunResult` for your test run.

```sh
python compare_results.py --test_run_folder [test_run_name]
```

For example, if your test results are in `TestRunResult/my_test`, you would run:

```sh
python compare_results.py --test_run_folder my_test
```

This will iterate through all standard test subdirectories (e.g., `Base`, `fts`, `Geographic`, etc.), comparing `TestRunResult/my_test/<subdir>` with `ReferenceResult/<subdir>`.

NOTE: The use of `my_test` directory in the above examples is based on the assumption that you have reanmed the `Input` directory to `my_test` inside the `TestRunResult` directory before running the tests.
