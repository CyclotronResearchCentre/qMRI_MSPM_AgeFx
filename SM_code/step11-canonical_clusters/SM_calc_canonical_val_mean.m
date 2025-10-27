function SM_calc_canonical_val_mean(quant_map_pattern, base_path, canonical_path, out_path)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function generates and saves canonical variate images based on the 
% z-scored quantitative maps. It uses the canonical vector image, derived from 
% the multivariateSPM in MSPM, and multiply it by the quantitative map values,
% Then, it takes the mean out of all cacnonical variates. The output image
% is the mean canonical vector lenght (canonical variate) for each voxel,
% that represents the contribution of the quantitative map in the
% MultivariateSPM model
%
% Parameters:
%   quant_map_pattern - regex pattern to select quantitative maps (e.g., '^z_sub.*GMsmo_PDmap.nii')
%   base_path         - base directory of the project
%   canonical_path    - full path to the canonical vectors (SPM .nii images)
%   out_path          - output directory to save canonical variate images
%
% Example usage:
%
% quant_map_pattern = '^z_sub.*GMsmo_MTsat.nii';
% base_path = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025');
% canonical_path = fullfile(base_path,'statistical analysis','MultivariateSPM', 'GM', 'L_01_c01');
% out_path = fullfile(base_path, 'statistical analysis','CanonicalVariates', 'MTsat');
%%%%%%%%%%%%%%%%%%%%%%%


    % Select quantitative maps
    quant_maps = spm_select('FPListRec', fullfile(base_path, 'data', 'derivatives', 'VBQ_TWsmooth'), ...
        quant_map_pattern);
    
    % Select canonical variate images
    canonical_vecs = spm_select('FPListRec', canonical_path, '^spm_CVL.*.nii');
    
    % Create output directory if it doesn't exist
    if ~exist(out_path, 'dir')
        mkdir(out_path);
    end

    % Process each canonical vector
    for can_jj = 1:size(canonical_vecs, 1)
        can_vol = spm_vol(canonical_vecs(can_jj, :));
        can_mat = spm_read_vols(can_vol);
        can_variate_sum = zeros(size(can_mat));  % Initialize volume
        
        % Multiply each quant map with the canonical vector
        for map_ii = 1:size(quant_maps, 1)
            map_vol = spm_vol(quant_maps(map_ii, :));
            map_mat = spm_read_vols(map_vol);
            can_variate_sum = can_variate_sum + (map_mat .* can_mat);
        end
        
        % Average across maps
        can_variate_mean = can_variate_sum / size(quant_maps, 1);
        
        % Prepare output file
        out_vol = can_vol;
        [~, can_vec_name, ~] = fileparts(canonical_vecs(can_jj, :));
        out_vol.fname = fullfile(out_path, ['CanonicalVariate_' can_vec_name '.nii']);
        
        % Save the NIfTI file
        spm_write_vol(out_vol, can_variate_mean);
    end

    fprintf('Canonical variate images saved to: %s\n', out_path);
end
