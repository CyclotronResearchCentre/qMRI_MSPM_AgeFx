function fn_out = crc_qMRIage_05_signifClusVxl(fl_split)
% Function to analyze SPMs results, coming form the F-contrast on the age 
% regressor after thresholding.
% The aim is to extract quantitative values for number of significant 
% voxels, and clusters in the threhsolded maps.
% FORMAT
%   fn_out = crc_qMRIage_05_signifClusVxl(fl_split)
% 
% INPUT
%   fl_split : flag indicating which split to use: 
%               - 0, full dataset [def. if nothing indicated]
%               - 1, first fold 'CV1_' prefix
%               - 2, second fold 'CV2_' prefix
% 
% OUTPUT
%   fn_out : cell array (6x2) of filenames of thresholded maps generated
% 
% This is performed for
% - the univariate SPM's (uSPM)
% - the union of thresholded univariate SPM's (UuSPM)
% - the multivariate SPM (mSPM)
% and this is performed for both GM and WM
%
% All the binary maps are placed in 2 different derivatives folders, one
% for GM and the other for WM.
% 
% The function can accommodate the 'split data' according to the input
% flag.
%_______________________________________________________________________
% Copyright (C) 2026 Cyclotron Research Centre

% Written by
% - C. Phillips, Cyclotron Research Centre, University of Liege, Belgium
% - S. Moallemian, Rutgers University, NJ, USA

%% Get defaults
if nargin==0, fl_split = 0; end
[pth,fn] = crc_qMRIage_defaults(fl_split);

% Define thresholds for SPM's
% p_thresh = [.05 .0125]; % regular FWER plus the one divided by 4
p_thresh = .05 ;
k_thresh = 0; % No spatial extent threshold

%% Deal with the 2x4 uSPM's, one by one, then mSPM
% Check filters for TC-weighted smoothing and maps
N_TC  = numel(fn.filt_TC);
N_maps = numel(fn.filt_maps);
pth_SPM_bin = cell(N_TC,1);
% fn_MBuSPM = cell(N_TC,N_maps);

for i_zTWS = 1:N_TC
    % Loop over tissue, i.e. GM-WM, and
    % first create folder for binarized maps
    pth_SPM_bin{i_zTWS} = fullfile(pth.deriv, ...
            sprintf('%sSPM_%s_binarize', fn.pCV,fn.filt_TC{i_zTWS}));
    if ~exist(pth_SPM_bin{i_zTWS},'dir'), mkdir(pth_SPM_bin{i_zTWS}); end
    for j_maps = 1: N_maps
        % Loop over maps and find the uSPM folders
        pth_uSPM{i_zTWS,j_maps} = fullfile(pth.deriv, ...
            sprintf('%suSPM_%s_%s', ...
                fn.pCV,fn.filt_TC{i_zTWS},fn.filt_maps{j_maps}));
        sm_cluster_masks(pth_uSPM{i_zTWS,j_maps}, p_thresh, k_thresh, ...
            pth_SPM_bin{i_zTWS})
    end
end

end

%% SUBFUNCTIONS

% Create binarized SPM's
function Nvx_per_cluster = sm_cluster_masks(SPM_path,p_thresh,k_thresh,pth_dest)

% Sub-function to create a binary map with all the cluster, as well as
% estimate the cluster sizes.
% 
% Derived from SM's "sm_cluster_masks.m" function

% Model name from the folder
fn_model = spm_file(SPM_path,'basename');

% Load SPM.mat file
load(fullfile(SPM_path,'SPM.mat'))

% Find index of F-test contrast in SPM.xCon
con_idx = find(strcmp({SPM.xCon.STAT},'F'));

% Load F-map
V = spm_vol(SPM.xCon(con_idx).Vspm.fname);
F = spm_read_vols(V);

% Threshold F-map at p-value threshold
F(F < spm_invFcdf(1 - p_thresh, SPM.xCon(con_idx).eidf , SPM.xX.erdf)) = 0;
F(isnan(F))=0;
F = double(F>0);
% Find significant clusters
[clusters,n_clusters] = spm_bwlabel(F,18);
%check the number of voxels within each cluster
for ic = 1:n_clusters
    Nvx_per_cluster(ic) = sum(clusters(:)==ic); 
end
% cd(dest)
% mkdir(sprintf('cluster_masks_FWER%d',p_thresh)) 
% cd cluster_masks


fn_binarized = fullfile(pth_dest, ...
    sprintf('%s_p-%04d\.nii',fn_model,p_thresh*1000));
% Save all clusters as binary NIfTI files
Vbin = V;
Vbin.fname = fn_binarized;
spm_write_vol(V,F);
% for ii = 1:n_clusters
%     voxels = find(clusters == ii);
%     if length(voxels) >= k_thresh
%         mask = zeros(size(F));
%         mask(voxels) = 1;
%         V.fname = sprintf('cluster_%03d.nii',ii);
%         spm_write_vol(V,mask);
%     end
% end
end




