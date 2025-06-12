function SM_extract_peak_from_MSPM(source_path, mask_path,dest_path)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get the MSPM at p<0.05 map
% mask it for specific ROI
% find the voxel with the maximum value(peak) within each ROI mask from the
% MSPM map
% save the coordinate of that voxel
% save the value of that voxel
%EXAMPLE INPUTS:
source_path = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/');
mask_path = fullfile(source_path, 'statistical analysis','AllROIs');
dest_path = fullfile(source_path, 'statistical analysis','Masked_MSPM_ROIs');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %init files
    mask_list = spm_select('FPList', mask_path, '.*.nii');
    MSPM_map = spm_select('FPList',fullfile(source_path,'statistical analysis','MultivariateSPM', 'GM', 'L_01_C01'), 'GM_MSPM_05.nii');

    % Load MSPM volume
    V_mspm = spm_vol(MSPM_map);
    Y_mspm = spm_read_vols(V_mspm);

    results = {};
    
    for i = 1:size(mask_list, 1)
        mask_file = strtrim(mask_list(i, :));
        [~, roi_name, ~] = fileparts(mask_file);

        % Load mask volume
        V_mask = spm_vol(mask_file);
        Y_mask = spm_read_vols(V_mask);

        % Mask the MSPM map
        masked_vals = Y_mspm .* (Y_mask > 0);

        % Get the index of the maximum value within the mask
        [max_val, linear_idx] = max(masked_vals(:));

        if max_val > 0
            % Convert linear index to x, y, z
            [x, y, z] = ind2sub(size(masked_vals), linear_idx);
            xyz = V_mspm.mat * [x; y; z; 1]; % Convert to mm space

            % Store results
            results(end+1, :) = {roi_name, max_val, xyz(1), xyz(2), xyz(3)};
        else
            % Store empty if no voxel found
            results(end+1, :) = {roi_name, NaN, NaN, NaN, NaN};
        end
    end

    % Convert to table and save
    results_table = cell2table(results, 'VariableNames', {'ROI', 'MaxValue', 'X_mm', 'Y_mm', 'Z_mm'});
    output_file = fullfile(dest_path, 'MSPM_peak_results.csv');
    writetable(results_table, output_file);

    fprintf('Results saved to: %s\n', output_file);
end


