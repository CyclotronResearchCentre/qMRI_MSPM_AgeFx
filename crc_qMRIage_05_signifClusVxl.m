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
n_thresh = numel(p_thresh);
N_TC  = numel(fn.filt_TC);
N_maps = numel(fn.filt_maps);

% Prepare output cell arrays
pth_SPM_bin = cell(N_TC,1);
Nvx_per_clust = cell(N_TC,N_maps);
fn_bin = cell(N_TC,N_maps);

%% Deal with the 2x4 uSPM's, one by one,

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

%% Deal with the union of the binarized SPM's
% Collect all the files across maps, then sum them up

for i_zTWS = 1:N_TC % Check GM and WM
    fn_bin_Uu = cell(2,1);
    Nvx_p_cl_Uu = cell(2,1);
    for i_thr = 1:n_thresh
        % Collect the various binarized maps
        fn_tmp = '';
        for j_maps = 1: N_maps
            fn_tmp = char(fn_tmp,fn_bin{i_zTWS,j_maps}{i_thr});
        end
        fn_tmp(1,:) = []; % remove 1st empty line
        % Generate Union-of-bin-uSPM filename
        fn_bin_Uu{i_thr} = spm_file(fn_tmp(1,:), 'filename', ...
            sprintf('%sUuSPM_%s_p-%04d.nii', ...
                fn.pCV,fn.filt_TC{i_zTWS},p_thresh(i_thr)*10000));
        
        % Unite the collected binary maps
        fl_imcalc = struct( ...
            'dmtx', 1, ...
            'mask', 0, ...
            'interp', 0, ...
            'dtype', 2, ...
            'descrip', 'Union of binarized uSPM''s');
        spm_imcalc(fn_tmp, fn_bin_Uu{i_thr}, 'any(X)', fl_imcalc);
        
        % Count clusters and voxel
        Nvx_p_cl_Uu{i_thr} = count_voxels_per_clusters(fn_bin_Uu{i_thr});
    end
    % append these to the cell array of results
    fn_bin{i_zTWS, N_maps+1}        = fn_bin_Uu;
    Nvx_per_clust{i_zTWS, N_maps+1} = Nvx_p_cl_Uu;
end

%% Deal with the 2 mSPM's, one by one,
for i_zTWS = 1:N_TC
    % Loop over tissue, i.e. GM-WM, and find the mSPM folders
    pth_mSPM_i = fullfile(pth.deriv, ...
        sprintf('%smSPM_%s', fn.pCV,fn.filt_TC{i_zTWS}), ...
        'L_01_c01');
    [Nvx_per_clust{i_zTWS,N_maps+2},fn_bin{i_zTWS,N_maps+2}] = ...
        sm_cluster_masks(pth_mSPM_i, p_thresh, pth_SPM_bin{i_zTWS}, 1);
end


%% Collect output
fn_out = fn_bin;


end

%% SUBFUNCTIONS

% Create binarized SPM's
function [Nvx_per_cluster,fn_binarized] = sm_cluster_masks(SPM_path, p_thresh, pth_dest, fl_mspm)

% Sub-function to create a binary map with all the cluster, as well as
% estimate the cluster sizes.
%
% FORMAT [Nvx_per_cluster,fn_binarized] = sm_cluster_masks(SPM_path, p_thresh, pth_dest)
%
% INPUT
%   SPM_path : path of folder with SPM.mat
%   p_thresh : FWER threshold to use (can be a vector)
%   pth_dest : path of folder where to write binarized image(s)
%   fl_mspm  : flag indicating the use of mSPM results, instead of uSPM [def]
%
% OUTPUT
%   Nvx_per_cluster : (cell array of) #voxels/clusters at fixed thresholds
%   fn_binarized    : filenames of binarized maps
%
%
% Derived from SM's "sm_cluster_masks.m" function

if nargin<4, fl_mspm = false; end

% Model name from the folder name
if ~fl_mspm % uSPM
    fn_model = spm_file(SPM_path,'basename');
else % mSPM
    fn_model = spm_file(spm_file(SPM_path,'path'),'basename');
end

% Load SPM.mat file
load(fullfile(SPM_path,'SPM.mat'))

% Find index of F-test contrast in SPM.xCon
con_idx = find(strcmp({SPM.xCon.STAT},'F'));

% Load F-map
if ~fl_mspm % uSPM
    fn_Fmap = fullfile(SPM_path,SPM.xCon(con_idx).Vspm.fname);
else %mSPM
    fn_Fmap = SPM.xCon(con_idx).Vspm.fname;
end

V = spm_vol(fn_Fmap);
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
    Vbin.fname = fn_binarized{i_thresh}; 
    Vbin.dt(1) = 2; % save as uint8
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
%   F : thresholded map, or filename to binarized map
%
% OUTPUT
%   Nvx_per_cluster : number of voxels per cluster
%

% IF filename is passed, check the file exist, then load it into memory
if ischar(F)
    fn = F;
    if exist(fn,'file')
        F = spm_read_vols(spm_vol(fn));
    else
        error('File does not seem to exist: %s\n', fn);
    end
end

% Find clusters
[clusters,n_clusters] = spm_bwlabel(F,18);
% check the number of voxels within each cluster
Nvx_per_cluster = zeros(n_clusters,1);
for ic = 1:n_clusters
    Nvx_per_cluster(ic) = sum(clusters(:)==ic);
end

end



