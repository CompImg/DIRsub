# This script takes as input two images (DICOM or NIfTI), performs a rigid co-registraction and image subtraction
# As is, this script assumes that elastix files (and optionally N4BiasFieldCorrection and SmoothImage) are in the same folder
# as this script (i.e. WD). Further, image files should be in the sub-folder "Images" in the same directory
library(oro.nifti); library(oro.dicom)

#Set some paths
wd <- getwd()
elastix <- paste(wd,"\\elastix",sep="")
paramFile <- elastix <- paste(wd,"\\elastixParam.txt",sep="")
n4bfc <- paste(wd,"\\N4BiasFieldCorrection",sep="")
smoothimage <- paste(wd,"\\SmoothImage",sep="")


