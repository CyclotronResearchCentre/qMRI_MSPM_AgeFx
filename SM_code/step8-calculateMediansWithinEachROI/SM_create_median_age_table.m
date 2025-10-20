
function SM_create_median_age_table(map_list, ROI_list, source_path, demographic_tab_path,dest_path)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function creates a table with subject_id, age, and median values 
% from each ROI for each quantitative map.
%
% INPUTS:
% map_list:       Cell array of strings specifying map names
% ROI_list:       Cell array of strings specifying ROI names
% source_path:    Path where median images are
% demographic_tab_path: Path to the participants' demographic data (.xlsx)
% dest_path: Path where median value CSVs are stored
%
% EXAMPLE INPUT:
% map_list = {'GMsmo_MTsat', 'GMsmo_PDmap', 'GMsmo_R1map', 'GMsmo_R2starmap'};
% ROI_list = {'ROI_Caudate', 'ROI_Heschl', 'ROI_Hippocampus', 'ROI_Pallidum', ...
%             'ROI_Precentral', 'ROI_Putamen', 'ROI_Supp_motor', 'ROI_Thalamus'};
% source_path = '/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/statistical analysis/MedianValuesWithinEachROI/';
% demographic_tab_path = '/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/data/participants.xlsx';
% dest_path = '/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/statistical analysis/ScatterPlotsForEachROI';

% SM_create_median_age_table(map_list, ROI_list, source_path, demographic_tab_path);

%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Written by Soodeh Moallemian, PhD. 2025
% Rutgers, The State University of New Jersey
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Read demographic table
demographic_tab = readtable(demographic_tab_path);

% Initialize structure to store results
MedianTab = table;
MedianTab.subID = demographic_tab.participant_id;
MedianTab.age = demographic_tab.age;
MedianTab.sex = demographic_tab.sex;
MedianTab.TIV = demographic_tab.TIV;
MedianTab.scanner =demographic_tab.scanner;

% Loop over ROIs and maps
for ii = 1:length(ROI_list)
    ROI_name = ROI_list{ii};
    for jj = 1:length(map_list)
        map_name = map_list{jj};

        % Construct file name and read median values
        file_name = fullfile(source_path, map_name, [ROI_name '_MedianValues.csv']);
        if exist(file_name, 'file')
            medianTab = readtable(file_name);

            % Expected column name: 'ROI_<Region>_MedianMaskedValue'
            % Find the column name programmatically:
            median_col_idx = contains(medianTab.Properties.VariableNames, 'MedianMaskedValue');
            median_values = medianTab{:, median_col_idx};

            % Sanitize variable name
            col_name = matlab.lang.makeValidName(['MedianValues_' ROI_name '_' map_name]);

            % Add to output table
            MedianTab.(col_name) = median_values;
        else
            warning('File not found: %s', file_name);
        end
    end
    if ~exist(fullfile(dest_path, ROI_name),"dir")
        mkdir (dest_path, ROI_name)
    end
    % Save output table
    writetable(MedianTab, fullfile(dest_path, ROI_name, [ROI_name '_Median_Age_Table.csv']));
end



end
