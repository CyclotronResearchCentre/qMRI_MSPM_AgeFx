function [fn_out, Nvx_per_clust] = crc_qMRIage_05_signifClusVxl(fl_split)
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
%   Nvx_per_clust : number of voxels per cluster
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
p_thresh = [.05 .0125]; % regular FWER plus the one divided by 4
% p_thresh = .05 ;

%% Deal with the 2x4 uSPM's, one by one, then mSPM
% Check filters for TC-weighted smoothing and maps
N_TC  = numel(fn.filt_TC);
N_maps = numel(fn.filt_maps);
pth_SPM_bin = cell(N_TC,1);
Nvx_per_clust = cell(N_TC,N_maps);
fn_bin = cell(N_TC,N_maps);

for i_zTWS = 1:N_TC
    % Loop over tissue, i.e. GM-WM, and
    % first create folder for binarized maps
    pth_SPM_bin{i_zTWS} = fullfile(pth.deriv, ...
        sprintf('binarized_%sSPM_%s', fn.pCV,fn.filt_TC{i_zTWS}));
    if ~exist(pth_SPM_bin{i_zTWS},'dir'), mkdir(pth_SPM_bin{i_zTWS}); end
    for j_maps = 1: N_maps
        % Loop over maps and find the uSPM folders
        pth_uSPM_ij = fullfile(pth.deriv, ...
            sprintf('%suSPM_%s_%s', ...
            fn.pCV,fn.filt_TC{i_zTWS},fn.filt_maps{j_maps}));
        [Nvx_per_clust{i_zTWS,j_maps},fn_bin{i_zTWS,j_maps}] = ...
            sm_cluster_masks(pth_uSPM_ij, p_thresh, pth_SPM_bin{i_zTWS});
    end
end

% Collect output
fn_out = fn_bin;


end

%% SUBFUNCTIONS

% Create binarized SPM's
function [Nvx_per_cluster,fn_binarized] = sm_cluster_masks(SPM_path, p_thresh, pth_dest)

% Sub-function to create a binary map with all the cluster, as well as
% estimate the cluster sizes.
%
% FORMAT [Nvx_per_cluster,fn_binarized] = sm_cluster_masks(SPM_path, p_thresh, pth_dest)
%
% INPUT
%   SPM_path : path of folder with SPM.mat
%   p_thresh : FWER threshold to use (can be a vector)
%   pth_dest : path of folder where to write binarized image(s)
%
% OUTPUT
%   Nvx_per_cluster : (cell array of) #voxels/clusters at fixed thresholds
%   fn_binarized    : filenames of binarized maps
%
%
% Derived from SM's "sm_cluster_masks.m" function

% Model name from the folder name
fn_model = spm_file(SPM_path,'basename');

% Load SPM.mat file
load(fullfile(SPM_path,'SPM.mat'))

% Find index of F-test contrast in SPM.xCon
con_idx = find(strcmp({SPM.xCon.STAT},'F'));

% Load F-map
V = spm_vol(fullfile(SPM_path,SPM.xCon(con_idx).Vspm.fname));
Forig = spm_read_vols(V);

Nvx_per_cluster = cell(numel(p_thresh),1);
fn_binarized = cell(numel(p_thresh),1);

for i_thresh = 1:numel(p_thresh)
    % Threshold F-map at p-value threshold
    F_thr = spm_uc( p_thresh(i_thresh), [SPM.xCon(con_idx).eidf , SPM.xX.erdf], ...
        'F', SPM.xVol.R, 1, SPM.xVol.S );
    F = Forig;
    F(F < F_thr) = 0;
    F(isnan(F))=0;
    F = double(F>0);
    % Find significant clusters
    Nvx_per_cluster{i_thresh} = count_voxels_per_clusters(F);
    
    fn_binarized{i_thresh} = fullfile(pth_dest, ...
        sprintf('%s_p-%04d.nii',fn_model,p_thresh(i_thresh)*10000));
    % Save all clusters as binary NIfTI files
    Vbin = V;
    Vbin.fname = fn_binarized{i_thresh}; Vbin.dt(1) = 2;
    spm_write_vol(Vbin,F);
end

end

function Nvx_per_cluster = count_voxels_per_clusters(F)

% Sub-function to count the number of voxels per cluster in thresholded
% statistical map
%
% FORMAT Nvx_per_cluster = count_voxels_per_clusters(F)
%
% INPUT
%   F : trhesholded map
%
% OUTPUT
%   Nvx_per_cluster : number of voxels per cluster
%

[clusters,n_clusters] = spm_bwlabel(F,18);
% check the number of voxels within each cluster
Nvx_per_cluster = zeros(n_clusters,1);
for ic = 1:n_clusters
    Nvx_per_cluster(ic) = sum(clusters(:)==ic);
end

end



