source_path = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/');
atlas_path = fullfile(source_path,'NewScripts','step7-extractROIsBasedOnAAL3Atlas','AAL3_atlas');
canonical_path = fullfile(source_path,'statistical analysis','MultivariateSPM','GM');
atlas = spm_select ('FPList', atlas_path, 'AAL3v1_1mm.nii$');
canonicals = spm_select('FPListRec',canonical_path,'^spm_CVL_depVar.*.nii');
dest = fullfile(source_path,'statistical analysis','ROIs');
ROI_index = [77,78,81,82,41,42,1,2,83,84,15,16,75,76,79,80,165,166];
ROI_name = {'Putamen', 'Thalamus', 'Hippocampus', 'Precentral',...
    'Heschl', 'Supp_motor', 'Caudate', 'Pallidum', 'Red_nucleus'};
atlas_struct = spm_vol(atlas);
atlas_vols = spm_read_vols(atlas_struct);
ii=1;
for ROI_j = 1:2:length(ROI_index)
    %read the left and right ROI from the atlas
    ROI_L = atlas_vols==ROI_index(ROI_j);
    ROI_R = atlas_vols==ROI_index(ROI_j+1);
    
    %take the left and right as one
    ROI = ROI_L+ROI_R;
    
    filename = sprintf('ROI_%s.nii', char(ROI_name(ii)));
    
    % create a new SPM volume structure for the ROI mask
    ROI_struct = atlas_struct;
    ROI_struct.fname = filename;
    
    cd(dest)
    % write the ROI mask to a NIfTI file
    spm_write_vol(ROI_struct, ROI);
    ii=ii+1;
end