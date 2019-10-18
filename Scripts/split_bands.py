#!/usr/env/bin/env python
# Split raster bands into separate .tif files

from osgeo import gdal
import numpy as np

import sys
from os.path import join, basename, dirname

assert len(sys.argv) == 2

dataset_in = gdal.Open(sys.argv[1])
im = dataset_in.ReadAsArray()   # Read as array

# Image size
X, Y = dataset_in.RasterXSize, dataset_in.RasterYSize
B = dataset_in.RasterCount

# Data type
dtype = dataset_in.GetRasterBand(1).DataType    # Subject to the first band

# Geo info
proj = dataset_in.GetProjection()
gtf = dataset_in.GetGeoTransform()

driver = gdal.GetDriverByName('GTiff')  # Save as tiff file

tag = basename(sys.argv[1]).split('.')[0]

for i in range(B):
    dataset_out = driver.Create(
        join(dirname(sys.argv[1]), tag+'_Band'+str(i+1)+'.tif'), 
        X, Y, 1, # Single band image 
        
        )
    # Write header
    dataset_out.SetProjection(proj)
    dataset_out.SetGeoTransform(gtf)
    dataset_out.GetRasterBand(1).WriteArray(im[i])

# GC
dataset_in = None
dataset_out = None
