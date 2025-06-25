function ROItab = SM_extractROIMedianAcrossMaps(source_path, ROI)
% extractROIMedianAcrossMaps
% This function reads all AllROIs_*.csv files in the source_path,
% extracts the specified ROI's median values across maps,
% and saves the resulting table in the same directory.
%
% INPUTS:
%   - source_path: path to the directory containing AllROIs_*.csv files
%   - ROI: ROI name (e.g., 'ROI_Caudate_MedianValues') to extract from each map
%
% OUTPUT:
%   - ROItab: table with SubjectID and ROI values from each map
%
%EXAMPLE INPUT: 
% source_path = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/statistical analysis/MedianValuesPearsonCorrelations/MedianValues')
% ROI = 'ROI_Caudate_MedianValues';
%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Get list of all matching AllROIs csv files
    Median_dir = dir(fullfile(source_path, 'AllROIs_*.csv'));

    % Initialize empty table
    ROItab = table();

    % Loop through each map CSV
    for ii = 1:length(Median_dir)
        % Full path to file
        file_path = fullfile(source_path, Median_dir(ii).name);

        % Read the table
        T = readtable(file_path);

        % On first file, get SubjectID column
        if ii == 1
            ROItab.SubjectID = T.SubjectID;
        end

        % Extract the map name (e.g., GMsmo_MTsat)
        [~, name, ~] = fileparts(Median_dir(ii).name);
        tokens = regexp(name, 'AllROIs_(.*)_MedianVals', 'tokens');
        if ~isempty(tokens)
            map_name = tokens{1}{1};
        else
            warning('Skipping file %s: could not parse map name.', name);
            continue;
        end

        % Add ROI column from this file if it exists
        if ismember(ROI, T.Properties.VariableNames)
            ROItab.(map_name) = T.(ROI);
        else
            warning('ROI %s not found in %s. Filling with NaN.', ROI, Median_dir(ii).name);
            ROItab.(map_name) = NaN(height(T),1);
        end
    end

    % Save table
    output_filename = fullfile(source_path, [ROI '_AcrossMaps.csv']);
    writetable(ROItab, output_filename);
    fprintf('Saved ROI median values across maps to:\n%s\n', output_filename);
end
