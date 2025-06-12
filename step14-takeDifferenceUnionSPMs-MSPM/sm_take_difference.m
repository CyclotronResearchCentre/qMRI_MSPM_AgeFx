function sm_take_difference(map1,map2,dest)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%this function takes the difference between two maps
% INPUTS:
%   map1: first map (use spm_select)
%   map2: second map 
%   dest: path to save the diff_map
%
%INPUT EXAMPLE:
% base_path = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/statistical analysis/DifferenceUnionofSPMs-MSPM');
% map1 = spm_select('FPList',base_path,'union_SPMs_125.nii');
% map2 = spm_select('FPList',base_path,'GM_MSPM_05.nii');
% dest = base_path;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

map1_struct = spm_vol(map1);
map1_vol = spm_read_vols(map1_struct);

map2_struct = spm_vol(map2);
map2_vol = spm_read_vols(map2_struct);


diff_map = map2_vol - map1_vol;

% Create a new image volume for the difference map
output_map = map2_struct;
output_map.fname = 'MSPM-SPMs_diff_map.nii';

cd(dest)
% save the difference map
spm_imcalc({map2_struct.fname, map1_struct.fname}, output_map.fname, 'i1 - i2');

end