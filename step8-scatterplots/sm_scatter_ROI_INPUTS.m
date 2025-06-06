
% TO PLOT THE MEADIAN OF RAW MT MAPS
cd ('D:\Martina\Data4ChrisPhilips\statistical analysis\scatter_plots\')
ROI_list = readtable('ROIs.txt');
ROI_index = table2array(ROI_list(:,3));
ROI_names = table2array(ROI_list(:,2));
SPM_path = 'D:\Martina\Data4ChrisPhilips\data';
atlas_path = SPM_path;
data_path = 'D:\Martina\Data4ChrisPhilips\data\GM_MT';
dest = 'D:\Martina\Data4ChrisPhilips\statistical analysis\scatter_plots\MT';
% sm_scatter_ROI(ROI_index,SPM_path,atlas_path,data_path,dest)
sm_scatter_ROI_left_right(ROI_index,ROI_names,SPM_path,atlas_path,data_path,dest)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TO PLOT THE MEADIAN OF RAW R2* MAPS

cd ('D:\Martina\Data4ChrisPhilips\statistical analysis\scatter_plots\')
ROI_list = readtable('ROIs.txt');
ROI_index = table2array(ROI_list(:,3));
ROI_names = table2array(ROI_list(:,2));
SPM_path = 'D:\Martina\Data4ChrisPhilips\data';
atlas_path = SPM_path;
data_path = 'D:\Martina\Data4ChrisPhilips\data\GM_R2s';
dest = 'D:\Martina\Data4ChrisPhilips\statistical analysis\scatter_plots\R2s';
% sm_scatter_ROI(ROI_index,SPM_path,atlas_path,data_path,dest)
sm_scatter_ROI_left_right(ROI_index,ROI_names,SPM_path,atlas_path,data_path,dest)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TO PLOT THE MEADIAN OF RAW PD MAPS

cd ('D:\Martina\Data4ChrisPhilips\statistical analysis\scatter_plots\')
ROI_list = readtable('ROIs.txt');
ROI_index = table2array(ROI_list(:,3));
ROI_names = table2array(ROI_list(:,2));
SPM_path = 'D:\Martina\Data4ChrisPhilips\data';
atlas_path = SPM_path;
data_path = 'D:\Martina\Data4ChrisPhilips\data\GM_A';
dest = 'D:\Martina\Data4ChrisPhilips\statistical analysis\scatter_plots\A';
% sm_scatter_ROI(ROI_index,SPM_path,atlas_path,data_path,dest)
sm_scatter_ROI_left_right(ROI_index,ROI_names,SPM_path,atlas_path,data_path,dest)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TO PLOT THE MEADIAN OF RAW R1 MAPS

cd ('D:\Martina\Data4ChrisPhilips\statistical analysis\scatter_plots\')
ROI_list = readtable('ROIs.txt');
ROI_index = table2array(ROI_list(:,3));
ROI_names = table2array(ROI_list(:,2));
SPM_path = 'D:\Martina\Data4ChrisPhilips\data';
atlas_path = SPM_path;
data_path = 'D:\Martina\Data4ChrisPhilips\data\GM_R1';
dest = 'D:\Martina\Data4ChrisPhilips\statistical analysis\scatter_plots\R1';
% sm_scatter_ROI(ROI_index,SPM_path,atlas_path,data_path,dest)
sm_scatter_ROI_left_right(ROI_index,ROI_names,SPM_path,atlas_path,data_path,dest)




