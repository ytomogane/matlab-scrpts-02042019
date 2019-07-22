%-----------------------------------------------------------------------
% Job saved on 08-Nov-2016 11:55:11 by cfg_util (rev $Rev: 6460 $)
% spm SPM - SPM12 (6685)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------

% spm_get_defaults;
% global defaults
% spm_jobman('initcfg');
%jobs{1}.spm.spatial.preproc.channel.vols = {'C:\Users\susumulab\Desktop\SPMtest\b0.img,1'};
function inhomo_cor(filename)
spmpath=which('spm');
spmpath(end-5:end)=[];
jobs{1}.spm.spatial.preproc.channel.vols ={[filename,',1']};
jobs{1}.spm.spatial.preproc.channel.biasreg = 0.001;
jobs{1}.spm.spatial.preproc.channel.biasfwhm = 60;
jobs{1}.spm.spatial.preproc.channel.write = [1 1];
jobs{1}.spm.spatial.preproc.tissue(1).tpm = {[spmpath,'\tpm\TPM.nii,1']};
jobs{1}.spm.spatial.preproc.tissue(1).ngaus = 3;
jobs{1}.spm.spatial.preproc.tissue(1).native = [1 0];
jobs{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
jobs{1}.spm.spatial.preproc.tissue(2).tpm = {[spmpath,'\tpm\TPM.nii,2']};
jobs{1}.spm.spatial.preproc.tissue(2).ngaus = 3;
jobs{1}.spm.spatial.preproc.tissue(2).native = [1 0];
jobs{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
jobs{1}.spm.spatial.preproc.tissue(3).tpm = {[spmpath,'\tpm\TPM.nii,3']};
jobs{1}.spm.spatial.preproc.tissue(3).ngaus = 3;
jobs{1}.spm.spatial.preproc.tissue(3).native = [1 0];
jobs{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
jobs{1}.spm.spatial.preproc.warp.mrf = 1;
jobs{1}.spm.spatial.preproc.warp.cleanup = 1;
jobs{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
jobs{1}.spm.spatial.preproc.warp.affreg = 'mni';
jobs{1}.spm.spatial.preproc.warp.fwhm = 0;
jobs{1}.spm.spatial.preproc.warp.samp = 3;
jobs{1}.spm.spatial.preproc.warp.write = [0 0];
spm_jobman('run',jobs);
disp('inhomogeneity correction completed')
clear jobs
