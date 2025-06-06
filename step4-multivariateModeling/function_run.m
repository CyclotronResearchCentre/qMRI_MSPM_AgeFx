%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
source_path =  fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/data/derivatives');
data_path = fullfile(source_path,'VBQ_TWsmooth');
covariate_path = source_path;
dest = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/statistical analysis/UnivariateSPM');
modality = 'GMsmo_MTsat';


zscored_files = cellstr(spm_select('FPListRec',data_path, '^z_.*GMsmo_MTsat.nii'));
exp_mask = cellstr(spm_select('FPListRec',source_path,'^atlas-GM.*MNI_mask.nii'));
age_cov = cellstr(spm_select('FPList',cov_path,'age.txt'));
sex_cov = cellstr(spm_select('FPList',cov_path,'sex.txt'));
TIV_cov = cellstr(spm_select('FPList',cov_path,'TIV.txt'));
scanner_cov = cellstr(spm_select('FPList',cov_path,'scanenr.txt'));
%dest_modality = fullfile(dest,modality)



function run_t_test(source,dest,mask,modality,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function is made to run a one sample t-test 
% inputs: 
% source = list to the files (use spm_select)
% dest = path to the destination, where you want to save the SPMs
% mask = the mask for GM or WM (use spm_select)
% modality = name of the modality you want to use (use  "_GM" or "_WM" to specify the tissue)
% example:
% modality = 'GM_MT';
%%taking all the GM_ MT files from the source path:
% source_file = spm_select('FPListRec',fullfile(source,modality), '^z_.*.nii');
%%defining the destination:
% dest = 'D:\statistical analysis\';
%%giving the mask:
% mask = spm_select('FPListRec',source,'^mask.*GM.nii');
%% giving the covariates (optional: add a txt file for )
% cov = spm_select('FPList',cov_path,'cov.txt');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Optional parameters definition
args = inputParser();
args.addParameter('covariate', fullfile(dest, 'covariate', 'cov.txt'));
args.parse(varargin{:})

files = cellstr(source);
exp_mask = cellstr(mask);

if ~isempty(args.Results.covariate)
    cov = cellstr(args.Results.covariate);
end

dest_modality = fullfile(dest,modality);

clear matlabbatch
matlabbatch{1}.spm.stats.factorial_design.dir = {dest};
matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = files;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
if 
matlabbatch{1}.spm.stats.factorial_design.multi_cov.files = {''};
matlabbatch{1}.spm.stats.factorial_design.multi_cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.multi_cov.iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = exp_mask;
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{2}.spm.stats.review.spmmat = '<UNDEFINED>';
matlabbatch{2}.spm.stats.review.display.matrix = 1;
matlabbatch{2}.spm.stats.review.print = 'ps';
matlabbatch{3}.spm.stats.fmri_est.spmmat = '<UNDEFINED>';
matlabbatch{3}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{3}.spm.stats.fmri_est.method.Classical = 1;

clear matlabbatch

spm_jobman('run',matlabbatch)
% 
end
