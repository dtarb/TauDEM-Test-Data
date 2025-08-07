#!/usr/bin/env python3

import sys
import os
import argparse
import numpy as np
from osgeo import gdal

# Configure GDAL to use exceptions
gdal.UseExceptions()

MAX_DIFF_THRESHOLD = 1e-2

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
        print("Error: Files have different projections")
        return False

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
    parser = argparse.ArgumentParser(description='Compare TIF files between two directories')
    parser.add_argument('dir1', help='Path to first directory')
    parser.add_argument('dir2', help='Path to second directory')
    parser.add_argument('--max_diff_threshold', type=float, default=MAX_DIFF_THRESHOLD,
                      help=f'Maximum absolute difference threshold for pixel values (default: {MAX_DIFF_THRESHOLD})')

    args = parser.parse_args()

    print(f"Using maximum pixel difference threshold: {args.max_diff_threshold}")
    result = compare_directories(args.dir1, args.dir2, args.max_diff_threshold)
    sys.exit(0 if result else 1)

if __name__ == '__main__':
    main()
