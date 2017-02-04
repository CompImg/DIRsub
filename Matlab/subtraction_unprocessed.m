% % Subtraction of two MRI-images (in our case applied to DIR images). 
% % These images have to be in nifti-format 
% % and be named 'post.nii' (follow-up image) and 'pre.nii' (baseline image)
% % These have to be in the same directory as the script. 
% % Also the file 'batch_reg_job_dir.m' (which comes with this script file) has to be in the same directory
% %
% % This script uses the following additional package: 
% % 
% % Statistical Parametric Mapping package for MATLAB (SPM 12, Wellcome Trust Center for Neuroimaging)


%SPM-generated code: (used to reslice and coregister)

nrun = 1; % enter the number of runs here
jobfile = {'batch_reg_job.m'}; %working directory must be inserted manually
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);

spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
%SPM-generated code ends here, generates 'rpre.nii' which is 'pre.nii' registered on 'post.nii'   

% Import post.nii and rpre.nii

rprevol = spm_vol('rpre.nii');
rpostvol = spm_vol('post.nii');
pre=spm_read_vols(rprevol);
post=spm_read_vols(rpostvol);

%calculate subtraction
sub  =  post-pre;

%write subtraction into file
subvol  = rpostvol;
subvol.fname = 'sub.nii';
spm_write_vol(subvol,sub);