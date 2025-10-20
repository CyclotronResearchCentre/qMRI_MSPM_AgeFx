%-----------------------------------------------------------------------
% Job saved on 03-Jun-2025 15:31:58 by cfg_util (rev $Rev: 8183 $)
% spm SPM - SPM (dev)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
matlabbatch{1}.spm.util.imcalc.input = {
                                        '/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/statistical analysis/UnivariateSPM/GM_MTsat/spm_tresh_05.nii,1'
                                        '/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/statistical analysis/UnivariateSPM/GM_PDmap/spm_tresh_05.nii,1'
                                        '/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/statistical analysis/UnivariateSPM/GM_R1map/spm_tresh_05.nii,1'
                                        '/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/statistical analysis/UnivariateSPM/GM_R2starmap/spm_tresh_05.nii,1'
                                        };
matlabbatch{1}.spm.util.imcalc.output = 'union_SPMs';
matlabbatch{1}.spm.util.imcalc.outdir = {'/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/statistical analysis'};
matlabbatch{1}.spm.util.imcalc.expression = 'any(X)';
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 1;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

spm_jobman('run', matlabbatch);