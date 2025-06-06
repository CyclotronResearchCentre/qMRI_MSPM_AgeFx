%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TO PLOT THE MEADIAN/MEAN OF z-scored R1 MAPS

cd ('D:\Martina\Data4ChrisPhilips\statistical analysis\scatter_plots\')
ROI_list = readtable('ROIs.txt');
ROI_index = table2array(ROI_list(:,3));
ROI_names = table2array(ROI_list(:,2));
SPM_path = 'D:\Martina\Data4ChrisPhilips\data';
atlas_path = SPM_path;
data_path = 'D:\Martina\Data4ChrisPhilips\data\GM_R1';
dest = 'D:\Martina\Data4ChrisPhilips\statistical analysis\scatter_plots\median_z-scored_corrected\z_R1';
%sm_scatter_ROI_z_scored_left_right_mean(ROI_index,ROI_names,SPM_path,atlas_path,data_path,dest)
sm_scatter_ROI_z_scored_left_right(ROI_index,ROI_names,SPM_path,atlas_path,data_path,dest)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TO PLOT THE MEADIAN/MEAN OF z-scored R2* MAPS

cd ('D:\Martina\Data4ChrisPhilips\statistical analysis\scatter_plots\')
ROI_list = readtable('ROIs.txt');
ROI_index = table2array(ROI_list(:,3));
ROI_names = table2array(ROI_list(:,2));
SPM_path = 'D:\Martina\Data4ChrisPhilips\data';
atlas_path = SPM_path;
data_path = 'D:\Martina\Data4ChrisPhilips\data\GM_R2s';
dest = 'D:\Martina\Data4ChrisPhilips\statistical analysis\scatter_plots\median_z-scored_corrected\z_R2s';
% sm_scatter_ROI_z_scored_left_right_mean(ROI_index,ROI_names,SPM_path,atlas_path,data_path,dest)
sm_scatter_ROI_z_scored_left_right(ROI_index,ROI_names,SPM_path,atlas_path,data_path,dest)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TO PLOT THE MEADIAN/MEAN OF z-scored PD MAPS

cd ('D:\Martina\Data4ChrisPhilips\statistical analysis\scatter_plots\')
ROI_list = readtable('ROIs.txt');
ROI_index = table2array(ROI_list(:,3));
ROI_names = table2array(ROI_list(:,2));
SPM_path = 'D:\Martina\Data4ChrisPhilips\data';
atlas_path = SPM_path;
data_path = 'D:\Martina\Data4ChrisPhilips\data\GM_A';
dest = 'D:\Martina\Data4ChrisPhilips\statistical analysis\scatter_plots\median_z-scored_corrected\z_A';
sm_scatter_ROI_z_scored_left_right_mean(ROI_index,ROI_names,SPM_path,atlas_path,data_path,dest)
sm_scatter_ROI_z_scored_left_right(ROI_index,ROI_names,SPM_path,atlas_path,data_path,dest)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TO PLOT THE MEADIAN/MEAN OF z-scored MT MAPS

cd ('D:\Martina\Data4ChrisPhilips\statistical analysis\scatter_plots\')
ROI_list = readtable('ROIs.txt');
ROI_index = table2array(ROI_list(:,3));
ROI_names = table2array(ROI_list(:,2));
SPM_path = 'D:\Martina\Data4ChrisPhilips\data';
atlas_path = SPM_path;
data_path = 'D:\Martina\Data4ChrisPhilips\data\GM_MT';
dest = 'D:\Martina\Data4ChrisPhilips\statistical analysis\scatter_plots\median_z-scored_corrected\z_MT';
%sm_scatter_ROI_z_scored_left_right_mean(ROI_index,ROI_names,SPM_path,atlas_path,data_path,dest)
sm_scatter_ROI_z_scored_left_right(ROI_index,ROI_names,SPM_path,atlas_path,data_path,dest)
