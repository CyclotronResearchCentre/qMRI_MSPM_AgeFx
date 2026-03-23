function aa = crc_qMRIage_main
% Main function for thre processing of the MPM qMRI aging data set.
% This calls a series of functions to deal with the successive processing
% steps, from data cleaning to figure production.
% 
% Main steps
% 
% NOTE
% The whole code derives from code 1st written by S. Moallemian, then
% updated by C. Phillips
%_______________________________________________________________________
% Copyright (C) 2025 Cyclotron Research Centre

% Written by 
% - C. Phillips, Cyclotron Research Centre, University of Liege, Belgium
% - S. Moallemian, Rutgers University, NJ, USA

%% 00. Setup pathes to the code
% Some checks & path handling
[pth,fn] = crc_qMRIage_defaults;

% adding SPM path, if not found
if isempty(which('spm')), addpath(pth.spm); end

% adding MSPM to SPM, as a separate tool, if not done yet
pth_SPMtool_MSPM = fullfile(spm('dir'),'toolbox','MSPM_toolbox');
if ~exist(pth_SPMtool_MSPM,'dir'),
    % copy MSPM into SPM's tools folder
    mkdir(pth_SPMtool_MSPM)
    copyfile(pth.mspm,pth_SPMtool_MSPM)
end

% adding the AAL3v1_1mm atlas to SPM as recomemnded in the instructions 
% (https://www.oxcns.org/aal3.html), if not done yet
pth_SPM_atlas = fullfile(spm('dir'),'atlas');
if ~exist(pth_SPM_atlas,'dir'),
    % copy necessary AAL files into SPM's (new) atlas folder
    mkdir(pth_SPM_atlas)
    fn_2copy = {'AAL3v1.nii', 'AAL3v1.xml', 'AAL3v1.nii.txt', ...
        'AAL3v1_1mm.nii', 'AAL3v1_1mm.xml', 'AAL3v1_1mm.nii.txt', ...
        'ROI_MNI_V7.nii', 'ROI_MNI_V7_vol.txt'};
    for ii=1:numel(fn_2copy)
        copyfile( fullfile(pth.aal3,fn_2copy{ii}), pth_SPM_atlas);
    end
end

% then initiliazing SPM
spm('defaults','fmri'),
spm_jobman('initcfg')

%% 01. Prepare and clean up the original data
% if that's not already done.
s01_out = crc_qMRIage_01_prepdata; %#ok<*NASGU>

%% 02. Deal with z-scoring of the data
s02_out = crc_qMRIage_02_zscoring;

%% 03. Perform univariate SPM analysis
s03_out = crc_qMRIage_03_uSPM;

%% 04. Perform multivarite SPM analysis
s04_out = crc_qMRIage_04_mSPM;

%% 05. Find significant clusters & count voxels/clusters, 
% for uSPM/UuSPM/MSPM/ (univariate, union of univariate,  multivariate SPM)
[fn_out, Nvx_per_clust] = crc_qMRIage_05_signifClusVxl;

% Check results
% sz_Nvx = size(Nvx_per_clust)
N_thr  = numel(Nvx_per_clust{1,1});
N_TC   = numel(fn.filt_TC);
N_maps = numel(fn.filt_maps);

% Per tissue class (cell) and map+union (1st dim), 
% extract #cluster, min-max #vx/cl, #voxels (2nd dim)
% for both thresholds (3rd dim)
VxCl_count = cell(N_TC,1);
for i_zTWS = 1:N_TC
    VxCl_count_TC = zeros(N_maps+1,4,N_thr);
    for j_maps = 1: N_maps+2 % to account for union of sPMs & mSPM
        for i_thr = 1:N_thr
            tmp_ct = Nvx_per_clust{i_zTWS,j_maps}{i_thr};
            VxCl_count_TC(j_maps, : , i_thr) = ...
                [numel(tmp_ct), min(tmp_ct), max(tmp_ct), sum(tmp_ct)];
        end
    end
    VxCl_count{i_zTWS} = VxCl_count_TC;
end

% Check Cohen's Kappa, for UuSPM and mSPM, for GM/WM and 2 thresholds
% using the tissue mask
CK = zeros(N_TC,N_thr);
for i_zTWS = 1:N_TC
    for i_thr = 1:N_thr
        fn_mask_i = spm_select('FPList', pth.deriv, ...
            sprintf('^atlas-*%s.*_mask\\.nii(\\.gz)?$', fn.filt_TC{i_zTWS}) );
        fn_cmp = char(fn_out{i_zTWS,6}{i_thr}, fn_out{i_zTWS,5}{i_thr});
        CK(i_zTWS,i_thr) = crc_CohenKappaImg(fn_cmp,fn_mask_i);
    end
end

%% 06.Extract ROI signals
% s06_out = crc_qMRIage_06_extractROIs;


% % Get list of subjects
% [subj_dirs] = spm_select('FPList',pth.data,'dir','^sub-.*$');
% Nsubs = size(subj_dirs,1);

end
