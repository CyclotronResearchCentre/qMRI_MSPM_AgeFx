function SM_MedianCalc_For_an_ROI(ROI_mask_path,Image_path,Out_path,map_name,ROI_name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function first, masked the images based on the ROI that it is given, 
% Then, it calculates the median value for the whole ROI and saves it with 
% the subject_id in a .csv file
% it also saves the masked images in the image directory
%
%
%
% EXAMPLE INPUTS:
% ROI_mask_path = fullfile(['/Users/smoallemian/Desktop/Manuscripts/' ...
%     'Moallemian_et_al_Aging_2025/statistical analysis/ROIs']);
% Image_path = fullfile(['/Users/smoallemian/Desktop/Manuscripts/' ...
%     'Moallemian_et_al_Aging_2025/data/derivatives/VBQ_TWsmooth/']);
% Out_path = fullfile(['/Users/smoallemian/Desktop/Manuscripts/' ...
%     'Moallemian_et_al_Aging_2025/statistical analysis/MedianScatterPlots']);
% map_name = 'GMsmo_MTsat';
% ROI_name = 'ROI_Pallidum';
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Soodeh Moallemian, PhD., Rutgers University, 2025
% s.moallemian@rutgers.edu
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Load ROI mask
ROI_mask_file = spm_select('FPListRec', ROI_mask_path, ['^' ROI_name '.nii$']);
ROI_mask_vol = spm_vol(ROI_mask_file);
ROI_mask_data = spm_read_vols(ROI_mask_vol);

% Get list of images
Images = spm_select('FPListRec', Image_path, ['^z_sub.*' map_name '.nii$']);

% create output cell array for subject IDs and medians
Median_Results = cell(size(Images, 1), 2);

for ii = 1 : size(Images, 1)
    % Load image
    img_file = strtrim(Images(ii,:));  % remove trailing spaces
    img_vol = spm_vol(img_file);
    img_data = spm_read_vols(img_vol);

    % Apply ROI mask and extract masked data
    masked_data = img_data .* (ROI_mask_data > 0);

    % Save the masked image
    [img_dir, img_name, ~] = fileparts(img_file);
    out_vol = img_vol;
    out_vol.fname = fullfile(img_dir, ['Masked_' ROI_name '_' img_name '.nii']);
    spm_write_vol(out_vol, masked_data);

    % Calculate median of non-zero masked voxels
    ROI_voxels = masked_data(ROI_mask_data > 0);
    median_val = median(ROI_voxels(:), 'omitnan');

    % Extract subject ID (e.g., from filename: z_sub-01_GMsmo_MTsat.nii)
    [~, fname, ~] = fileparts(img_file);
    subj_id = regexp(fname, 'sub-[^_]+', 'match', 'once');

    % Store results
    Median_Results{ii, 1} = subj_id;
    Median_Results{ii, 2} = median_val;

    fprintf('Processed %s, median = %.4f\n', subj_id, median_val);
end

% Convert to table and save as CSV
T = cell2table(Median_Results, 'VariableNames', {'SubjectID', [ROI_name '_MedianMaskedValue']});
if ~exist(fullfile(Out_path,map_name)), mkdir(Out_path,map_name), end

writetable(T, fullfile(Out_path, map_name, [ROI_name '_MedianValues.csv']));

fprintf('Saved median values to: %s\n', fullfile(Out_path, [ROI_name '_MedianValues.csv']));

end
