function sm_scatter_ROI(ROI_index,SPM_path,atlas_path,data_path,dest)
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is a function to plot medians of masked values of raw maps
% vs their age of the subjects. it will also fit a linear regression model
% to the medians and age.
%INPUTS:
%   ROI_idx: a matrix of indices of ROIs based on AAL3v1-1mm atlas
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
for jj = 1 : length(ROI_index)
    %define an empty matrix to be filled with median values
    medians = [];
    ROI = ROI_index(jj);
    %take the array in the atlas that has the value of ROI
    ROI_masks = atlas_vols==ROI;
    
    %loop over subjects and take the maps
    for ii = 1:length(Subjects4Chris.ID)
        
        %read the ID from SPM.mat
        sub_id = char(Subjects4Chris.ID(ii));
        file_regexp = sprintf('^fin_dart.*%s.*.nii', sub_id);
        
        %select and read the corresponding map
        map = spm_select('FPList',data_path,file_regexp);
        map_struct = spm_vol(char(map));
        map_vols = spm_read_vols(map_struct);
        
        %mask the map based on the ROI jj in atlas
        masked_map = map_vols.*ROI_masks;
        
        %get the values of masked maps
        vals_ii = masked_map(masked_map(:)>0);
        
        
        %calculate the median and mean value
        median_ii = median(vals_ii);
        medians = [medians,median_ii]; %#ok<AGROW>
        
        %printing the values
        %         fprintf('the mean value at region %d in subject %s is %d \n',ROI,sub_id,mean(vals_ii))
        %         fprintf('the median value at region %d in subject %s is %d \n',ROI,sub_id,median(vals_ii))
        
        %get the age of the subjects
        age = Subjects4Chris.Age;
    end
    % Plot the scatter plot
    figure;
    scatter(age, medians,"diamond");
    xlim([min(Subjects4Chris.Age),max(Subjects4Chris.Age)+5]);
    % ylim([0,1.5]);
    title(['ROI scatter plot for ROI ',num2str(ROI)]);
    xlabel('Age');
    ylabel('Median value');
    
    % fit linear regression
    Lreg = fitlm(age, medians);
    
    % regression coefficients and R-squared value
    coeffs = Lreg.Coefficients;
    R2 = Lreg.Rsquared.Ordinary;
    
    % Add regression line to scatter plot
    hold on;
    plot(age, coeffs.Estimate(1) + coeffs.Estimate(2)*age, 'r');
    legend('median value', 'Linear Regression');
    text(mean(age), max(medians), ['R^2 = ', num2str(R2)], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
    hold off;
    
    % Display coefficients and R-squared value
    disp('Regression coefficients:');
    disp(coeffs);
    disp(['R-squared value: ' num2str(R2)]);
    
    % Save the scatter plot
    cd(dest)
    saveas(gcf, fullfile(dest, ['ROI_',num2str(ROI),'_scatter_plot.png']));
    close(gcf)
end
diary off
end