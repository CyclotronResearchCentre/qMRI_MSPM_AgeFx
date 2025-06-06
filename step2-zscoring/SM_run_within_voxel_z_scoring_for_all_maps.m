mask_path = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/data/derivatives/');

% z-score GM-MT data
   
 source = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/data/derivatives/VBQ_TWsmooth/');
 data_list = cellstr(spm_select('FPListRec',source,'^sub-.*GMsmo_MTsat.nii$'));
 mask = spm_select('FPListRec',mask_path,'atlas-GM_space-MNI_mask.nii$');
 within_voxel_z_scoring(data_list, mask)
   
 % z-score WM_MT data
   
 source = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/data/derivatives/VBQ_TWsmooth/');
 data_list = cellstr(spm_select('FPListRec',source,'^sub-.*WMsmo_MTsat.nii$'));
 mask = spm_select('FPListRec',mask_path,'atlas-WM_space-MNI_mask.nii$');
 within_voxel_z_scoring(data_list, mask)
 
 
 % z-score GM_R2s
 
 source = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/data/derivatives/VBQ_TWsmooth/');
 data_list = cellstr(spm_select('FPListRec',source,'^sub-.*GMsmo_R2starmap.nii$'));
 mask = spm_select('FPListRec',mask_path,'atlas-GM_space-MNI_mask.nii$');
 within_voxel_z_scoring(data_list, mask)
 
 
  % z-score WM_R2s
 
  source = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/data/derivatives/VBQ_TWsmooth/');
 data_list = cellstr(spm_select('FPListRec',source,'^sub-.*WMsmo_R2starmap.nii$'));
 mask = spm_select('FPListRec',mask_path,'atlas-WM_space-MNI_mask.nii$');
 within_voxel_z_scoring(data_list, mask)
 
 
  % z-score GM_R1
 
 source = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/data/derivatives/VBQ_TWsmooth/');
 data_list = cellstr(spm_select('FPListRec',source,'^sub-.*GMsmo_R1map.nii$'));
 mask = spm_select('FPListRec',mask_path,'atlas-GM_space-MNI_mask.nii$');
 within_voxel_z_scoring(data_list, mask)
 
 
   % z-score WM_R1
 
  source = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/data/derivatives/VBQ_TWsmooth/');
 data_list = cellstr(spm_select('FPListRec',source,'^sub-.*WMsmo_R1map.nii$'));
 mask = spm_select('FPListRec',mask_path,'atlas-WM_space-MNI_mask.nii$');
 within_voxel_z_scoring(data_list, mask)
 
 
 
   % z-score GM_A
 
 source = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/data/derivatives/VBQ_TWsmooth/');
 data_list = cellstr(spm_select('FPListRec',source,'^sub-.*GMsmo_PDmap.nii$'));
 mask = spm_select('FPListRec',mask_path,'atlas-GM_space-MNI_mask.nii$');
 within_voxel_z_scoring(data_list, mask)
 
 
   % z-score WM_A
 
 source = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/data/derivatives/VBQ_TWsmooth/');
 data_list = cellstr(spm_select('FPListRec',source,'^sub-.*WMsmo_PDmap.nii$'));
 mask = spm_select('FPListRec',mask_path,'atlas-WM_space-MNI_mask.nii$');
 within_voxel_z_scoring(data_list, mask)