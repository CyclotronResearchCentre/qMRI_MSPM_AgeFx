function out = crc_qMRIage_02_zscoring
% Function z-scoring all the data, this performed
% - within voxel across subjects,
% - per tissue-weighted smoothed images (2) and maps (4),
%  i.e. one voxe from a single map smoothed for one tissue, across all the
%  subjects.
%
% The z-transformed maps are placed in a separate 'derivatives' sub-folder.
%_______________________________________________________________________
% Copyright (C) 2025 Cyclotron Research Centre

% Written by
% - C. Phillips, Cyclotron Research Centre, University of Liege, Belgium
% - S. Moallemian, Rutgers University, NJ, USA

%% Get defaults
pth = crc_qMRIage_defaults;

%% Deal with the data per tissue (2) and per  map (4)
% Define filters for TWsmooth and maps
filt_TWS = {'GM','WM'};
N_TWS  = numel(filt_TWS);
filt_maps = {'MTsat','PDmap','R1map','R2starmap'};
N_maps = numel(filt_maps);

% Loop of the TWS and maps
for i_TWS = 1:N_TWS
    % Pick tissue mask
    fn_mask_i = spm_select('FPListRec', pth.deriv, ...
        sprintf('^atlas-*%s.*_mask\\.nii(\\.gz)?$', filt_TWS{i_TWS}) );
    for j_maps = 1: N_maps
        % Pick list of maps from all subjects
        fn_img_ij = cellstr( spm_select('FPListRec', pth.TWsmo, ...
            sprintf('^sub.*%ssmo_%s\\.nii(\\.gz)?$', filt_TWS{i_TWS}, ...
            filt_maps{j_maps}) ));
        % Do the z-scoring
        within_voxel_z_scoring(fn_img_ij, fn_mask_i)
        
    end
end

%% Move all z-scored maps into other derivatives folder
if ~exist(pth.zscore,'dir'), mkdir(pth.zscore); end
% Collect all z-maps
fn_Zmaps = spm_select('FPListRec', pth.TWsmo, '^z_.*\.nii$');

% Specific derivtaives folders
dr_zscore = spm_file(pth.zscore,'basename');
dr_TWsmo  = spm_file(pth.TWsmo,'basename');

% moving them 1 by 1, placing them where they should
for ii = 1:size(fn_Zmaps,1)
    % Find target file and pth
    fn_tgt = strrep(fn_Zmaps(ii,:),dr_TWsmo,dr_zscore);
    pth_tgt = spm_file(fn_tgt,'fpath');
    if ~exist(pth_tgt,'dir'), mkdir(pth_tgt); end
    % Move file
    movefile(fn_Zmaps(ii,:),fn_tgt,'f')
end

%% Spit out results
fn_Zmaps = spm_select('FPListRec', pth.zscore, '^z_.*\.nii$');
out = fn_Zmaps;

end

%% SUBFUNCTION

% Code form SM original work
function within_voxel_z_scoring(fn_images, fn_mask)
% Perform within-voxel z-scoring throughout an entire list of images
% FORMAT within_voxel_z_scoring(fn_images, fn_mask)
% fn_images      - cells column, each cell contains the path of one image
% fn_mask        - path to a binary mask to constrain the area where
%                   z-scoring is performed. It should be the same mask used
%                   for the univariate model used as input to the
%                   multivariate analysis
%
%__________________________________________________________________________
%
% Soodeh Moallemian, PhD. 2025
% Rutgers University- Newark, NJ
% University of Liege, Liege, Belgium
% smoallemian@gmail.com
% s.moallemian@rutgers.edu
%__________________________________________________________________________
%
% The function does not return any output but each image that has been z-scored
% is saved in the exact same folder as the original with the exact same
% name but starting with the prefix 'z_'

% reading the binary mask image.
Vmask = spm_vol(fn_mask);
% getting the value of each voxel (mask) and location of each voxel
% (cmask =cordinate mask)
[mask, cmask] = spm_read_vols(Vmask);
% adding a 4th dimention to the location matrix (cmask)
cmask(4,:) = 1;
% X = A\B is the solution to the equation A*X = B.A. (index of all
% voxels)
voxmask = (Vmask.mat)\cmask;
% taking only the voxels in voxmask that have a value greater than zero in
% the binary mask (this matrix is smaller than the old one)
voxmask = voxmask(:,mask > .1);

im_mean = nan(size(mask));
im_std = nan(size(mask));
% taking the data from your files, from the locations that have non zero
% value the the mask, and stacking them on eachother.
mattmp = spm_get_data(fn_images,voxmask(1:3,:));
% taking the mean over each column
mattmp_mean = mean(mattmp,1);
%taking std over each column
mattmp_sd = std(mattmp,1);
% placing the mean and std value for each column in non-zero locations of the
% binary mask, in the NAN matrix
im_mean(mask > .1) = mattmp_mean;
im_std(mask > .1) = mattmp_sd;

for j = 1:size(fn_images,1)
    Vtmp = spm_vol(fn_images{j});
    voltmp = spm_read_vols(Vtmp, mask);
    voltmp = (voltmp - im_mean)./im_std;
    [htmppathstr, htmpname, htmpext] = fileparts(Vtmp.fname);
    Vtmp.fname = fullfile(htmppathstr, ['z_' htmpname htmpext]);
    Vtmp.dt = [64 0];
    spm_write_vol(Vtmp, voltmp);
    fprintf('saving %s \n', Vtmp.fname)
end

end