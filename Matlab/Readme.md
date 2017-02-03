These scripts were used to generate longitudinal
subtraction images as described in:

Eichinger
et al. “Improved detection of MRI
activity in multiple sclerosis through longitudinal double inversion recovery subtraction
imaging”, submitted. 

They were developed and tested with MATLAB R2015b.

They subtract the image “pre.nii” from the image
“post.nii”. In our case they were applied to serial FLAIR and DIR images which
were from the same MR scanner, they might need to be changed if used in another
setting. The scripts, including ‘batch_reg_job.m’, have to be in the same
directory as the image files ‘pre.nii’ and ‘post.nii’.

‘subtraction_unprocessed.m’ generates a simple
subtraction image without further post processing and stores the resulting
subtraction map ‘sub.nii’ in the working directory.

‘subtraction_processed.m’ generates, analogously, a
subtraction image ‘sub_processed.nii’ with additional bias field correction,
brain extraction and histogram matching. 

These scripts make use of the following additional
packages and algorithms (the folder structures of N4 biasfield correction and
ROBEX might need to be adapted according to the user’s setup - we stored copies
of both in the working directory itself):

Statistical Parametric Mapping package for MATLAB (SPM 12, Wellcome Trust Center for Neuroimaging)

N4 biasfield correction algorithm as described in Tustison et al. N4ITK: Improved N3 bias correction. IEEE Trans Med Imaging. 2010;29(6):1310-1320

ROBEX algorithm for brain extraction as described in Iglesias et al. Robust brain extraction across datasets and comparison with publicly available methods. IEEE Trans Med Imaging. 2011;30(9):1617-1634
