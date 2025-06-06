% map_list = {'GMsmo_MTsat', 'GMsmo_PDmap', 'GMsmo_R1map', 'GMsmo_R2starmap'};
% ROI_list = {'ROI_Caudate', 'ROI_Heschl', 'ROI_Hippocampus', 'ROI_Pallidum',
%     'ROI_Precentral', 'ROI_Putamen', 'ROI_Supp_motor', 'ROI_Thalamus'};
% source_path = '/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/statistical analysis/MedianValuesWithinEachROI/';
% for ii = 1: length(ROI_list)
%     ROI_name = ROI_list{ii};
%     map_name = map_list{ii};
%     MedianTab = readtable(fullfile(source_path, [ROI_name '_Median_Age_Table.csv']));
%     col_name = matlab.lang.makeValidName(['MedianValues_' ROI_name '_' map_name])
%     scatter(MedianTab.age, MedianTab.(col_name))
% 
% end



map_list = {'GMsmo_MTsat', 'GMsmo_PDmap', 'GMsmo_R1map', 'GMsmo_R2starmap'};
ROI_list = {'ROI_Caudate', 'ROI_Heschl', 'ROI_Hippocampus', 'ROI_Pallidum', ...
    'ROI_Precentral', 'ROI_Putamen', 'ROI_Supp_motor', 'ROI_Thalamus'};

source_path = '/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/statistical analysis/MedianValuesWithinEachROI/';

for ii = 1:length(ROI_list)
    ROI_name = ROI_list{ii};

    % Read the CSV file for the current ROI
    MedianTab = readtable(fullfile(source_path, [ROI_name '_Median_Age_Table.csv']));
    
    % Create a new figure for the current ROI
    figure('Name', ROI_name, 'NumberTitle', 'off');
    
    for jj = 1:length(map_list)
        map_name = map_list{jj};
        
        % Generate column name
        col_name = matlab.lang.makeValidName(['MedianValues_' ROI_name '_' map_name]);
        
        % Prepare data
        x = MedianTab.age;
        y = MedianTab.(col_name);
        
        % Subplot for current map
        subplot(2, 2, jj); % 2x2 grid
        scatter(x, y, 'b', 'filled'); hold on;
        
        % Fit and plot linear regression line
        coeffs = polyfit(x, y, 1);
        y_fit = polyval(coeffs, x);
        plot(x, y_fit, 'r--', 'LineWidth', 1.5);
        
        % Axis labels and title
        xlabel('Age (yrs)');
        ylabel([extractAfter(map_name, 'GMsmo_') 'Median Values']);
        title([map_name strrep(ROI_name, '_', '\_')]);
        
        grid on;
    end

    % save each figure as PNG
    saveas(gcf, fullfile(source_path, [ROI_name '_' map_name '_scatter_plots.png']));
end
        