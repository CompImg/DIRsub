% % Subtraction of two MRI images (originally used for 3D FLAIR images) with additional postprocessing (bias field correction, brain extraction, histogram matching). 
% % These images have to be in nifti-format 
% % and be named 'post.nii' (follow-up image) and 'pre.nii' (baseline image)
% % These have to be in the same directory as the script. 
% % Also the file 'batch_reg_job_processed.m' (which comes with this script file) has to be in the same directory
% % 
% % 
% % This script uses the following additional packages and algorithms: 
% % 
% % Statistical Parametric Mapping package for MATLAB (SPM 12, Wellcome Trust Center for Neuroimaging)
% % 
% % N4 biasfield correction algorithm as described in
% % Tustison et al. N4ITK: Improved N3 bias correction. IEEE Trans Med Imaging. 2010;29(6):1310-1320
% % 
% % ROBEX algorithm for brain extraction as described in
% % Iglesias et al. Robust brain extraction across datasets and comparison with publicly available methods. IEEE Trans Med Imaging. 2011;30(9):1617-1634


%SPM-generated code: (used to reslice and coregister)
nrun = 1; % enter the number of runs here
jobfile = {'batch_reg_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);

spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
%SPM-generated code ends here,  generates 'rpre.nii' which is 'pre.nii' registered on 'post.nii'   

% Import post.nii and rpre.nii
rprevol = spm_vol('rpre.nii');
rpostvol = spm_vol('post.nii');
pre=spm_read_vols(rprevol);
post=spm_read_vols(rpostvol);

%Bias-Field Correction

!N4BiasFieldCorrection -d 3 -i post.nii -o post.nii
!N4BiasFieldCorrection -d 3 -i rpre.nii -o rpre.nii

%Skullstripping
        
!Robex post.nii spost.nii mask.nii
maskvol = spm_vol('mask.nii');
mask = spm_read_vols(maskvol);
spostvol = spm_vol('spost.nii');
spost = post.*mask; %spm_read_vols(spostvol);
spre = pre.*mask;
        
%Histogram matching

spost1 = spost./max(spost(:)); % transform histograms to [0,1]
spre1 = spre./max(spre(:));
% convert to vectors because imhistmatch only works properly in 2D:
mspre1_r = imhistmatch(spre1(:),spost1(:));
mspre1 = reshape(mspre1_r,size(spost)); %return to 3D matrices
mspre = mspre1.*max(spost(:)); %stretch histogram to match hist(post)
        
% Calculate and store FLAIR subtraction
processed_sub = spost - mspre;
proc_subvol = rpostvol;
proc_subvol.fname = 'sub_processed.nii';
spm_write_vol(proc_subvol,processed_sub);