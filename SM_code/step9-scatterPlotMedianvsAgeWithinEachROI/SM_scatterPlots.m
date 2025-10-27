function SM_scatterPlots(source_path,map_list, ROI_path)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This function, plots the median values within each quantitative map
% within different ROIs.
%
% INPUTS: 
% source_path: path to the source directory (qMRI maps)
% map_list: a cell array containing the name of the maps
% ROI_path: path to the ROI mask images.
% dest_path: path to the directory where you want to save the scatter plots
% EXAMPLE INPUTS:
% 
% source_path = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/statistical analysis/ScatterPlotsForEachROI');
% map_list = {'GMsmo_MTsat', 'GMsmo_PDmap', 'GMsmo_R1map', 'GMsmo_R2starmap'};
% ROI_path = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/statistical analysis/CombinedLeftRightROIs');
% dest_path = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/statistical analysis/MedianScatterPlots');
% 
%
%
%
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% scatter plot for each ROI and 4 maps. 
% map_list = {'GMsmo_MTsat', 'GMsmo_PDmap', 'GMsmo_R1map', 'GMsmo_R2starmap'};
% ROI_list = {'ROI_Caudate', 'ROI_Heschl', 'ROI_Hippocampus', 'ROI_Pallidum', ...
%     'ROI_Precentral', 'ROI_Putamen', 'ROI_Supp_motor', 'ROI_Thalamus'};

% source_path = '/Users/smoallemian/Desktop/Manuscripts/Moallemian_et_al_Aging_2025/statistical analysis/ScatterPlotsForEachROI';

%select ROIs

ROI_list = spm_select('FPListRec',ROI_path,'.nii$');

for ii = 1:size(ROI_list,1)
    [~,ROI_name,~] = fileparts(ROI_list(ii,:));
    % ROI_name = ROI_list{ii};

    MedianTab = readtable(fullfile(source_path, ROI_name, [ROI_name '_Median_Age_Table.csv']));
    
    % Create a new figure for the current ROI
    figure('Name', extractAfter(ROI_name, 'ROI_'), 'NumberTitle', 'off');
    
     for jj = 1:length(map_list)
        map_name = map_list{jj};
        
        % Generate column name
        col_name = matlab.lang.makeValidName(['MedianValues_' ROI_name '_' map_name]);
        
        % Prepare data
        x = MedianTab.age;
        y = MedianTab.(col_name);
        
        % Subplot for current map
        subplot(2, 2, jj); % 2x2 grid
        scatter(x, y, 'b', '*'); hold on;
        
        % Fit linear model
        lm = fitlm(x, y);
        coeffs = lm.Coefficients.Estimate; % [intercept; slope]
        R2 = lm.Rsquared.Ordinary;

        % Plot regression line
        y_fit = coeffs(1) + coeffs(2) * x;
        plot(x, y_fit, 'r--', 'LineWidth', 1.5);

        % Display model info on the plot
        eqn_str = sprintf('y = %.3f + %.3fx\nR^2 = %.3f', coeffs(1), coeffs(2), R2);
        x_margin = 0.05 * range(x);
        y_margin = 0.05 * range(y);

        x_pos = min(x) + x_margin;
        y_pos = min(y) + y_margin;
        text(x_pos, y_pos, eqn_str, ...
            'FontSize', 7, ...
            'Color', 'k', ...
            'BackgroundColor', 'none', ...
            'EdgeColor', 'none', ...
            'VerticalAlignment', 'bottom', ...
            'HorizontalAlignment', 'left');

        xlabel('Age (yrs)');
        short_map = extractAfter(map_name, 'GMsmo_');
        ylabel(' Median Values');
        title(short_map);

        grid off;
    end
    % save each figure
    saveas(gcf, fullfile(source_path, ROI_name, [ROI_name '_scatter_plots.png']));
    savefig(gcf, fullfile(source_path, ROI_name, [ROI_name '_scatter_plots.fig']));
    hold off
    close gcf
end
end



        