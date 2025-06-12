function SM_extract_peak_from_MSPM(source_path, canonical_path, mask_path, dest_path)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For each ROI:
% - Get peak voxel in MSPM map
% - Get canonical vector values at that voxel
% - Save ROI name, coordinates, MSPM peak value, and canonical values
%
%
% %EXAMPLE INPUTS:
% source_path = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/');
% mask_path = fullfile(source_path, 'statistical analysis','AllROIs');
% dest_path = fullfile(source_path, 'statistical analysis','MaskedMSPMandeCanonicalValuesWithinROIs');
% canonical_path = fullfile(source_path,'statistical analysis','MultivariateSPM','GM/L_01_c01/');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Load MSPM map
    MSPM_map = spm_select('FPList', ...
        fullfile(source_path, 'statistical analysis', 'MultivariateSPM', 'GM', 'L_01_C01'), ...
        'GM_MSPM_05.nii');
    V_mspm = spm_vol(MSPM_map);
    Y_mspm = spm_read_vols(V_mspm);

    % Load canonical vector maps
    Can_maps = spm_select('FPList', canonical_path,'^spm_CVL.*.nii');

    n_canonicals = size(Can_maps, 1);
    V_can = spm_vol(Can_maps);
    Y_can = cell(n_canonicals, 1);
    for j = 1:n_canonicals
        Y_can{j} = spm_read_vols(V_can(j));
    end

    % Load ROI masks
    mask_list = spm_select('FPList', mask_path, '.*.nii');

    % Initialize results
    results = {};
    
    for i = 1:size(mask_list, 1)
        mask_file = strtrim(mask_list(i, :));
        [~, roi_name, ~] = fileparts(mask_file);

        % Load mask
        V_mask = spm_vol(mask_file);
        Y_mask = spm_read_vols(V_mask);

        % Apply mask to MSPM map
        masked_vals = Y_mspm .* (Y_mask > 0);
        [max_val, linear_idx] = max(masked_vals(:));

        if max_val > 0
            % Convert to voxel and real-world coordinate
            [x, y, z] = ind2sub(size(masked_vals), linear_idx);
            xyz_mm = V_mspm.mat * [x; y; z; 1];

            % Get canonical values at this voxel
            can_vals = nan(1, n_canonicals);
            for j = 1:n_canonicals
                can_vals(j) = Y_can{j}(x, y, z);
            end

            % Store results
            results(end+1, :) = [{roi_name, max_val, xyz_mm(1), xyz_mm(2), xyz_mm(3)}, num2cell(can_vals)];
        else
            % If no voxel found, fill NaNs
            results(end+1, :) = [{roi_name, NaN, NaN, NaN, NaN}, num2cell(NaN(1, n_canonicals))];
        end
    end

    % Prepare column names
    col_names = [{'ROI', 'MSPM_PeakVal', 'X_mm', 'Y_mm', 'Z_mm'}];
    for j = 1:n_canonicals
        [~, cname, ~] = fileparts(Can_maps(j, :));
        col_names{end+1} = cname;
    end

    % Save results
    results_table = cell2table(results, 'VariableNames', col_names);
    if ~exist(dest_path, 'dir')
        mkdir(dest_path);
    end
    output_file = fullfile(dest_path, 'MSPM_Peak_and_CanonicalValues.csv');
    writetable(results_table, output_file);

    fprintf('Results saved to: %s\n', output_file);
end
