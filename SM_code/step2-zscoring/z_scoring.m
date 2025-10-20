% z-score GM-MT data
   
 source = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/data/derivatives/');
 data_list = cellstr(spm_select('FPListRec',source,'.*MTsat.*GM_probseg.nii$'));
 mask_path = spm_select('FPListRec',source,'atlas-GM_space-MNI_mask.nii$');
 within_voxel_z_scoring(data_list, mask_path)
   
 % z-score WM_MT data
   
 source = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/data/derivatives/');
 data_list = cellstr(spm_select('FPListRec',source,'.*MTsat.*WM_probseg.nii$'));
 mask_path = spm_select('FPListRec',source,'atlas-WM_space-MNI_mask.nii$');
 within_voxel_z_scoring(data_list, mask_path)
 
 
 % z-score GM_R2s
 
 source = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/data/derivatives/');
 data_list = cellstr(spm_select('FPListRec',source,'.*R2starmap.*GM_probseg.nii$'));
 mask_path = spm_select('FPListRec',source,'atlas-GM_space-MNI_mask.nii$');
 within_voxel_z_scoring(data_list, mask_path)
 
 
  % z-score WM_R2s
 
  source = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/data/derivatives/');
 data_list = cellstr(spm_select('FPListRec',source,'.*R2starmap.*WM_probseg.nii$'));
 mask_path = spm_select('FPListRec',source,'atlas-WM_space-MNI_mask.nii$');
 within_voxel_z_scoring(data_list, mask_path)
 
 
  % z-score GM_R1
 
 source = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/data/derivatives/');
 data_list = cellstr(spm_select('FPListRec',source,'.*R1map.*GM_probseg.nii$'));
 mask_path = spm_select('FPListRec',source,'atlas-GM_space-MNI_mask.nii$');
 within_voxel_z_scoring(data_list, mask_path)
 
 
   % z-score WM_R1
 
  source = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/data/derivatives/');
 data_list = cellstr(spm_select('FPListRec',source,'.*R1map.*WM_probseg.nii$'));
 mask_path = spm_select('FPListRec',source,'atlas-WM_space-MNI_mask.nii$');
 within_voxel_z_scoring(data_list, mask_path)
 
 
 
   % z-score GM_A
 
 source = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/data/derivatives/');
 data_list = cellstr(spm_select('FPListRec',source,'.*PDmap.*GM_probseg.nii$'));
 mask_path = spm_select('FPListRec',source,'atlas-GM_space-MNI_mask.nii$');
 within_voxel_z_scoring(data_list, mask_path)
 
 
   % z-score WM_A
 
 source = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/data/derivatives/');
 data_list = cellstr(spm_select('FPListRec',source,'.*PDmap.*GM_probseg.nii$'));
 mask_path = spm_select('FPListRec',source,'atlas-WM_space-MNI_mask.nii$');
 within_voxel_z_scoring(data_list, mask_path)