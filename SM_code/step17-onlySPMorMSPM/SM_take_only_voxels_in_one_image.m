%-----------------------------------------------------------------------
% This script with take two images and only return the voxles that belong
% to the first image, (voxels that have values other than zero and NAN)

% Christophe Phillips, PhD, Universite de Liege, 
% Soodeh Moallemian, PhD, Rutgers University, 2025

%-----------------------------------------------------------------------


spm('defaults', 'FMRI');
spm_jobman('initcfg');

% Define input images
img1 = '/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/statistical analysis/Calc_MSPMvsUnionSPM/union_SPMs_125.nii,1';
img2 = '/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/statistical analysis/Calc_MSPMvsUnionSPM/MSPM_masked.nii,1';

% Setup batch
matlabbatch{1}.spm.util.imcalc.input = {img1; img2};
matlabbatch{1}.spm.util.imcalc.output = 'UnionSPMs_only';
matlabbatch{1}.spm.util.imcalc.outdir = {''};
matlabbatch{1}.spm.util.imcalc.expression = '(i1 .* (i2==0)) .* ~isnan(i1) .* ~isnan(i2)';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

spm_jobman('run', matlabbatch);
