#!/usr/env/bin/env python
# A script to convert various types of raster images into .tiff format
# that can be easier for MATLAB to read

# Refer to this question:
# https://gis.stackexchange.com/questions/42584/how-to-call-gdal-translate-from-python-code
# and this one: https://gdal.org/tutorials/raster_api_tut.html#using-createcopy

from osgeo import gdal

import sys

assert len(sys.argv) == 3

dataset_in = gdal.Open(sys.argv[1])

driver = gdal.GetDriverByName('GTiff')
dataset_out = driver.CreateCopy(sys.argv[2], dataset_in, 0)

dataset_in = None
dataset_out = None