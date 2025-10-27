 function MedianVals_tab = SM_AllROIsMedianVals(Source_path, map_name)

% This function reads all *MedianValues.csv files from the specified map directory,
% extracts subject IDs and median values, creates a combined table, and saves it.
%
% INPUTS:
%   - Source_path: full path to the folder containing map subfolders
%   - map_name: name of the specific map subfolder (e.g., 'GMsmo_MTsat')
%
% OUTPUT:
%   - MedianVals_tab: table containing SubjectID and median values for each ROI
%
%
%
%
% Example INPUT: 
% Source_path = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/statistical analysis/MedianScatterPlots/');
% map_name = 'GMsmo_MTsat';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Construct the full path to the map folder
    map_path = fullfile(Source_path, map_name);

    % Get all matching CSV files
    ROIs = dir(fullfile(map_path, '*MedianValues.csv'));  

    % Initialize an empty table
    MedianVals_tab = table();

    % Loop through each file
    for ii = 1:length(ROIs)
        % Full path to current CSV
        file_path = fullfile(map_path, ROIs(ii).name);

        % Read the table
        temp_tab = readtable(file_path);

        % Extract subject IDs and median values
        subjectIDs = temp_tab{:,1};
        medianVals = temp_tab{:,2};

        % Create valid variable name from ROI file name
        [~, roi_name, ~] = fileparts(ROIs(ii).name);
        roi_var_name = matlab.lang.makeValidName(roi_name);

        % On first iteration, add SubjectID column
        if ii == 1
            MedianVals_tab.SubjectID = subjectIDs;
        end

        % Add ROI median values
        MedianVals_tab.(roi_var_name) = medianVals;
    end

    % Save the final table
    output_filename = sprintf('AllROIs_%s_MedianVals.csv', map_name);
    output_file = fullfile(map_path, output_filename);
    writetable(MedianVals_tab, output_file);

    fprintf('Saved median values table to:\n%s\n', output_file);
end
