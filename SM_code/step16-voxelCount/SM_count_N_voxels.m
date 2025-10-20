function voxel_count = SM_count_N_voxels(source_path,mask_name)
%count the number of voxels in the union of SPMs
%
%
%
%
% EXAMPLE INPUT: 
% source_path = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/statistical analysis/UnionSPMs/SPMs_05/WM');
% mask_name = 'UnionSPMs.nii'
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Path to the binary mask (0 and 1)
mask_path = fullfile(source_path, mask_name); 

% Load the image
V = spm_vol(mask_path);
mask_data = spm_read_vols(V);

% Count the number of non-zero voxels 
voxel_count = sum(mask_data(:) > 0);

% Display the result
fprintf('Number of voxels in the mask: %d\n', voxel_count);

end