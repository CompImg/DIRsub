# This script takes as input two images (DICOM), performs a rigid co-registraction and image subtraction
# As is, this script assumes that elastix files (and optionally N4BiasFieldCorrection) are in the same folder
# as this script (i.e. WD). Further, image files should be in sub-folders "pre" and "post" in the same directory
library(oro.nifti)

#Set some paths
wd <- getwd()
elastix <- paste(wd,"\\elastix",sep="")
#The elastix parameter file for registration; simple rigid registration (MI) will suffice
paramFile <- paste(wd,"\\elastixParam.txt",sep="")
n4bfc <- paste(wd,"\\N4BiasFieldCorrection",sep="")
dcm2niix <- paste(wd,"\\dcm2niix",sep="")

#We assume that images are in two subfolders; perform dcm2niix conversion
dcm2niix.args <- paste("-o ",wd," -f pre ",wd,"\\pre",sep="")
system2(dcm2niix,dcm2niix.args)

dcm2niix.args <- paste("-o ",wd," -f post ",wd,"\\post",sep="")
system2(dcm2niix,dcm2niix.args)

#OPTIONAL: BiasField Correction
#n4.args <- "-d 3 -i pre.nii -o pre.nii"
#system2(n4bfc,n4.args)

#n4.args <- "-d 3 -i post.nii -o post.nii"
#system2(n4bfc,n4.args)

#Rigidly co-register
elastix.args <- paste("-f post.nii -m pre.nii -p ",paramFile," -out ",wd,sep="")
system2(elastix,elastix.args)

#Some housekeeping
file.remove(paste(wd,"\\IterationInfo.0.R0.txt",sep=""))
file.remove(paste(wd,"\\IterationInfo.0.R1.txt",sep=""))
file.remove(paste(wd,"\\IterationInfo.0.R2.txt",sep=""))
file.remove(paste(wd,"\\IterationInfo.0.R3.txt",sep=""))
file.remove(paste(wd,"\\elastix.log",sep=""))

#Keep transformation file
#Rename output
file.rename(paste(wd,"\\result.0.nii",sep=""),paste(wd,"\\pre.reg.nii",sep=""))

#Load and subtract
pre <- readNIfTI(paste(wd,"\\pre.reg.nii",sep=""),reorient = F)
post <- readNIfTI(paste(wd,"\\post.nii",sep=""),reorient = F)

sub <- post - pre
sub@dim_ <- pre@dim_

writeNIfTI(sub,"DIRsub")
