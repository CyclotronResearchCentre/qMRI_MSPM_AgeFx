function median_matrix = sm_scatter_ROI_z_scored_left_right(ROI_index,ROI_names,SPM_path,atlas_path,data_path,dest)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a function to plot medians of masked values of z-scored maps
% vs their age of the subjects. it will also fit a linear regression model
% to the medians and age.
%INPUTS:
%   ROI_idx: a matrix of indices of ROIs based on AAL3v1-1mm atlas
%   ROI_names: a cell array of ROI names, corresponding to the ROI indeces
%   SPM_path: path to the SPM.mat file, where you have stored the subjects'
%   ID and Age
%   atlas_path: path to AAL atlas image
%   data_path: path to your data
%   dest: path to store the scatter plots
%EXAMPLE INPUTS:
%   ROI_index = [77,88];
%   SPM_path = 'D:\Martina\Data4ChrisPhilips\data';
%   atlas_path = SPM_path;
%   data_path = 'D:\Martina\Data4ChrisPhilips\data\GM_A';
%   dest = 'D:\Martina\Data4ChrisPhilips\statistical analysis\scatter_plots'
%
%
% Written by Soodeh Moallemian University of Liege 2023
% smoallemian@uliege.be /smoallemian@gmail.com
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(dest)
diary('logfile.txt')
SPM_path = fullfile(SPM_path);
atlas = spm_select('FPList',atlas_path,'rAAL3v1_1mm.nii$');
cd(SPM_path)
load('Subjects4Chris.mat')
data_path = fullfile(data_path);
dest = fullfile(dest);
%load the atlas file and take the ROIS
atlas_struct = spm_vol(atlas);
atlas_vols = spm_read_vols(atlas_struct);


% loop over ROI indeces and take the maps for each subject
for jj = 1 : 2 : length(ROI_index)
    %define empty matrices to be filled with median values
    medians_L = []; medians_R = []; str =[];
    %take the array in the atlas that has the value of ROI
    % for the left and right index
% % % %     if isnan(ROI_index(jj))
% % % %         warning(['region ', num2str(jj), ' has NAN values.']);
% % % %         jj= jj+1; %#ok<FXSET>
% % % %     end
    ROI_L = atlas_vols==ROI_index(jj);
    ROI_R = atlas_vols==ROI_index(jj+1);
    
    %loop over subjects and take the maps
    for ii = 1:length(Subjects4Chris.ID)
        
        %read the ID from SPM.mat
        sub_id = char(Subjects4Chris.ID(ii));
        file_regexp = sprintf('^z_fin_dart.*%s.*.nii', sub_id);
        
        %select and read the corresponding map
        map = spm_select('FPList',data_path,file_regexp);
        map_struct = spm_vol(char(map));
        map_vols = spm_read_vols(map_struct);
        
        %mask the map based on the ROI jj (LEFT) in atlas
        masked_map_L = map_vols.*ROI_L;
        
        %get the values of masked maps
        vals_L = masked_map_L(masked_map_L(:)~=0);
        
        
        %calculate the median and mean value
        median_L = median(vals_L(~isnan(vals_L)));
        medians_L = [medians_L,median_L]; %#ok<AGROW>
        
        
        %mask the map based on the ROI jj in atlas
        masked_map_R = map_vols.*ROI_R;
        
        %get the values of masked maps
        vals_R = masked_map_R(masked_map_R(:)~=0);
        
        
        %calculate the median and mean value
        median_R = median(vals_R(~isnan(vals_R)));
        medians_R = [medians_R,median_R]; %#ok<AGROW>
        
        %printing the values
        %         fprintf('the mean value at region %d in subject %s is %d \n',ROI,sub_id,mean(vals_ii))
        %         fprintf('the median value at region %d in subject %s is %d \n',ROI,sub_id,median(vals_ii))
        
    end
    median_matrix.left = medians_L;
    median_matrix.right = medians_R;
    median_matrix.subname = Subjects4Chris.ID
    %get the age of the subjects
    age = Subjects4Chris.Age;
    ROI_name_L =  ROI_names(ROI_index(jj));
    ROI_name_R =  ROI_names(ROI_index(jj+1)) ;
    
    plot_title = strsplit(char(ROI_name_L),'_L');
    plot_title = plot_title{1};
    % Plot the scatter plot
    figure;
    xlim([min(Subjects4Chris.Age),max(Subjects4Chris.Age)+5]);
    % ylim([0,1.5]);

    
    
    % fit linear regression
    Lreg_L = fitlm(age, medians_L);
    Lreg_R = fitlm(age, medians_R);
    % regression coefficients and R-squared value
    coeffs_L = Lreg_L.Coefficients;
    R2_L = Lreg_L.Rsquared.Ordinary;
%     pvalue_L = Lreg_L.
    
    
    coeffs_R = Lreg_R.Coefficients;
    R2_R = Lreg_R.Rsquared.Ordinary;
    
    %plot scatter for the left ROI
    scatter(age, medians_L,"diamond",'r');
    hold on;
      % Add regression line to scatter plot
    plot(age, coeffs_L.Estimate(1) + coeffs_L.Estimate(2)*age, 'r');
    
    
    
    %plot scatter for the right ROI
    scatter(age, medians_R,"o",'b');
      % Add regression line to scatter plot
    plot(age, coeffs_R.Estimate(1) + coeffs_R.Estimate(2)*age, "--b");
    
    title(['median voxle values in ',char(plot_title), ' ROI']);
    xlabel('Age');
    ylabel('Median');
    dim = [.2 .03 .3 .3];
    str_Left = ['R_{L}^2 = ', num2str(R2_L)];
    str_Right = ['R_{R}^2 = ', num2str(R2_R)];
    str = sprintf('%s\n%s', str_Left, str_Right);
    annotation('textbox',dim,'String',str,'FitBoxToText','on','BackgroundColor', 'white','EdgeColor', 'black');
%     title(['ROI scatter plot for ROI ',char(plot_title)]);
%     xlabel('Age');
%     ylabel('Median');
%     legend('median left', 'LR left','median right', 'LR right');
    % text(mean(age), max(medians_L), ['R_{L}^2 = ', num2str(R2_L)], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
    % text(mean(age), max(medians_R), ['R_{R}^2 = ', num2str(R2_R)], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
    
    % Display coefficients and R-squared value

% % %     fprintf('Regression coefficients for %s: \n',ROI_name_L);
% % %     disp(coeffs_L);
% % %     disp(['R-squared value: ' num2str(R2_L)]);
% % %     disp(['p value: ' num2str(R2_R)]);
% % %     
% % %     
% % %     fprintf('Regression coefficients for %s: \n',ROI_name_R);
% % %     disp(coeffs_L);
% % %     disp(['R-squared value: ' num2str(R2_R)]);
    
    % Save the scatter plot
    cd(dest)
    saveas(gcf, fullfile(dest, ['ROI_',char(plot_title),'_scatter_plot.png']));
    close(gcf)
end
if jj+1 == 168
    return
end
diary off
end