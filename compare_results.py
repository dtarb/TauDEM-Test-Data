#!/usr/bin/env python3

import sys
import os
import argparse
import numpy as np
from osgeo import gdal

# Configure GDAL to use exceptions
gdal.UseExceptions()

MAX_DIFF_THRESHOLD = 0  # DGT tightened this down. Was 1e-2

def compare_tif_files(file1_path, file2_path, max_diff_threshold=MAX_DIFF_THRESHOLD):
    """
    Compare two TIF files using maximum absolute difference threshold.
    Compares both pixel values and relevant raster properties.
    """
    # Open the files
    ds1 = gdal.Open(file1_path)
    ds2 = gdal.Open(file2_path)

    if ds1 is None or ds2 is None:
        print("Error: Could not open one or both files")
        return False

    # Compare basic properties
    if (ds1.RasterXSize != ds2.RasterXSize or
        ds1.RasterYSize != ds2.RasterYSize or
        ds1.RasterCount != ds2.RasterCount):
        print("Error: Files have different dimensions")
        print(f"File 1: {ds1.RasterXSize}x{ds1.RasterYSize}x{ds1.RasterCount}")
        print(f"File 2: {ds2.RasterXSize}x{ds2.RasterYSize}x{ds2.RasterCount}")
        return False

    # Print total pixel count
    total_pixels = ds1.RasterXSize * ds1.RasterYSize
    print(f"Total pixels found in input file: {total_pixels} ({ds1.RasterXSize}x{ds1.RasterYSize})")

    # Compare geotransform with reasonable tolerance
    if not np.allclose(ds1.GetGeoTransform(), ds2.GetGeoTransform(), rtol=1e-5):
        print("Error: Files have different geotransform")
        print(f"File 1 geotransform: {ds1.GetGeoTransform()}")
        print(f"File 2 geotransform: {ds2.GetGeoTransform()}")
        return False

    # Compare projection
    if ds1.GetProjection() != ds2.GetProjection():
        print("Warning: Projections do not match")
        print(ds1.GetProjection())
        print(ds2.GetProjection())
    #    return True   # DGT 10/27/25 rather than returning, continue to test for other differences

    # Compare pixel values for each band using max difference
    for band in range(1, ds1.RasterCount + 1):
        band1 = ds1.GetRasterBand(band)
        band2 = ds2.GetRasterBand(band)

        # Compare nodata values if they exist
        nodata1 = band1.GetNoDataValue()
        nodata2 = band2.GetNoDataValue()
        if nodata1 != nodata2:
            print(f"Error: Band {band} has different nodata values")
            print(f"File 1 nodata: {nodata1}, File 2 nodata: {nodata2}")
            return False

        # Read the actual data
        data1 = band1.ReadAsArray()
        data2 = band2.ReadAsArray()

        # Create masks for nodata values to exclude them from comparison
        if nodata1 is not None:
            mask1 = (data1 != nodata1)
            nodata_count1 = np.sum(~mask1)
            print(f"File 1 Band {band} - Nodata pixels: {nodata_count1} ({nodata_count1/total_pixels:.2%} of total)")
        else:
            mask1 = np.ones_like(data1, dtype=bool)
            print(f"File 1 Band {band} - No nodata value defined")

        if nodata2 is not None:
            mask2 = (data2 != nodata2)
            nodata_count2 = np.sum(~mask2)
            print(f"File 2 Band {band} - Nodata pixels: {nodata_count2} ({nodata_count2/total_pixels:.2%} of total)")
        else:
            mask2 = np.ones_like(data2, dtype=bool)
            print(f"File 2 Band {band} - No nodata value defined")

        # Combined mask for valid data in both arrays
        valid_mask = mask1 & mask2
        valid_pixel_count = np.sum(valid_mask)
        print(f"Band {band} - Valid pixels for comparison: {valid_pixel_count} ({valid_pixel_count/total_pixels:.2%} of total)")

        # Calculate max difference only for valid data
        if np.any(valid_mask):
            abs_diff = np.abs(data1[valid_mask] - data2[valid_mask])
            max_diff = np.max(abs_diff)
            mean_diff = np.mean(abs_diff)
            print(f"Band {band} - Max difference: {max_diff}, Mean difference: {mean_diff}")

            # Count pixels exceeding different thresholds
            diff_gt_0 = np.sum(abs_diff > 0)
            diff_gt_threshold = np.sum(abs_diff > max_diff_threshold)
            print(f"Band {band} - Pixels with any difference: {diff_gt_0} ({diff_gt_0/valid_pixel_count:.2%} of valid)")
            print(f"Band {band} - Pixels exceeding threshold: {diff_gt_threshold} ({diff_gt_threshold/valid_pixel_count:.2%} of valid)")

            # Check if max difference exceeds threshold
            if max_diff > max_diff_threshold:
                print(f"Error: Band {band} max difference ({max_diff}) exceeds threshold ({max_diff_threshold})")
                # Find location of max difference for debugging
                max_loc = np.unravel_index(np.argmax(np.abs(data1 - data2)), data1.shape)
                print(f"Max difference at {max_loc}: {data1[max_loc]} vs {data2[max_loc]}")
                return False
        else:
            print(f"Warning: Band {band} has no valid data for comparison")

    return True

def compare_directories(dir1_path, dir2_path, max_diff_threshold=MAX_DIFF_THRESHOLD):
    """
    Compare all matching TIF files between two directories.
    Returns True only if all matching files are identical.
    """
    # Check if directories exist
    if not os.path.isdir(dir1_path) or not os.path.isdir(dir2_path):
        print("Error: One or both directory paths are invalid")
        return False

    # Get list of TIF files in first directory
    tif_files = [f for f in os.listdir(dir1_path) if f.lower().endswith('.tif') or f.lower().endswith('.tiff')]

    if not tif_files:
        print(f"No TIF files found in {dir1_path}")
        return False

    all_identical = True
    files_compared = 0
    mismatched_files = 0
    missing_files = 0

    for tif_file in tif_files:
        file1_path = os.path.join(dir1_path, tif_file)
        file2_path = os.path.join(dir2_path, tif_file)

        if not os.path.exists(file2_path):
            print(f"Warning: {tif_file} not found in second directory")
            missing_files += 1
            all_identical = False
            continue

        print(f"\nComparing {tif_file}...")
        result = compare_tif_files(file1_path, file2_path, max_diff_threshold)
        print(f"{tif_file}: {'Identical' if result else 'Different'}")

        files_compared += 1
        if not result:
            mismatched_files += 1
            all_identical = False

    print("\nSummary:")
    print(f"Total TIF files found in first directory: {len(tif_files)}")
    print(f"Files compared: {files_compared}")
    if mismatched_files > 0:
        print(f"Files with differences: {mismatched_files}")
    if missing_files > 0:
        print(f"Files missing from second directory: {missing_files}")
    print(f"Result: {'All files are identical' if all_identical else f'{mismatched_files + missing_files} file(s) did not match'}")

    return all_identical

def main():
    """
    Main function to handle command line arguments and initiate comparisons.
    """
    test_run_folders = [
        'Base', 'fts', 'Geographic', 'gridtypes', 'sinmapsi', 'AreaD8_data', 'AreaDinf',
        'Gridnet', 'peukerDouglas', 'streamnet_data', 'D8flowextreme', 'DinfConcLimAccum',
        'DinfTransLimAcc', 'MovedOutletstoStream_data', 'GageWatershed', 'ConnectDown',
        'NoEPSG', 'MoveOutlets2', 'MoveOutlets3', 'gwunittest', 'editraster', 'catchoutlets',
        'FlowdirCond', 'RetLimFlow', 'CatchHydroGeo', 'Inundepth', 'GDAL_unset_nodata'
    ]
    test_run_base_folder = 'TestRunResult'
    reference_result_base_folder = 'ReferenceResult'
    parser = argparse.ArgumentParser(description='Compare TIF files between two directories or for a test run.')
    parser.add_argument('--dir1', help='Path to first directory (for single directory comparison).')
    parser.add_argument('--dir2', help='Path to second directory (for single directory comparison).')
    parser.add_argument('--test_run_folder', help='Path to the folder relative to TestRunResult of a test run. This will trigger comparison for a predefined set of subfolders against the reference results.')
    parser.add_argument('--max_diff_threshold', type=float, default=MAX_DIFF_THRESHOLD,
                      help=f'Maximum absolute difference threshold for pixel values (default: {MAX_DIFF_THRESHOLD})')

    args = parser.parse_args()

    print(f"Using maximum pixel difference threshold: {args.max_diff_threshold}")

    if args.test_run_folder:
        base_result_folder = os.path.join(test_run_base_folder, args.test_run_folder)
        # check if base_result_folder exists
        if not os.path.isdir(base_result_folder):
            print(f"Error: Test run folder not found: {base_result_folder}")
            sys.exit(1)
        print(f"Performing test run comparison for base folder: {base_result_folder}")
        print(f"Reference result base folder: {reference_result_base_folder}")
        overall_success = True
        for folder in test_run_folders:
            dir1 = os.path.join(base_result_folder, folder)
            dir2 = os.path.join(reference_result_base_folder, folder)
            print(f"\n----- Comparing sub-directory: {folder} -----")
            if not os.path.isdir(dir1):
                print(f"Warning: Test directory not found, skipping: {dir1}")
                overall_success = False
                continue
            if not os.path.isdir(dir2):
                print(f"Warning: Reference directory not found, skipping: {dir2}")
                overall_success = False
                continue

            result = compare_directories(dir1, dir2, args.max_diff_threshold)
            if not result:
                overall_success = False

        print("\n----- Test Run Summary -----")
        if overall_success:
            print("All compared test run directories are identical.")
            sys.exit(0)
        else:
            print("Some differences were found in the test run comparison.")
            sys.exit(1)
    elif args.dir1 and args.dir2:
        result = compare_directories(args.dir1, args.dir2, args.max_diff_threshold)
        sys.exit(0 if result else 1)
    else:
        parser.error('Either --test_run_folder or both --dir1 and --dir2 must be specified.')

if __name__ == '__main__':
    main()
