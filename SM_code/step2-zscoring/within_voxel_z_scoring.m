function within_voxel_z_scoring(list_images, mask_path)
% Perform within-voxel z-scoring throughout an entire list of images
% FORMAT within_voxel_z_scoring(list_images, mask)
% list_images      - cells column, each cell contains the path of one image
% mask_path        - path to a binary mask to constrain the area where 
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
hmask = spm_vol(mask_path); 
% getting the value of each voxel (mask) and location of each voxel 
% (cmask =cordinate mask)
[mask, cmask] = spm_read_vols(hmask);
% adding a 4th dimention to the location matrix (cmask)
cmask(4,:) = 1;
% X = A\B is the solution to the equation A*X = B.A. (index of all
% voxels)
voxmask = (hmask.mat)\cmask;
% taking only the voxels in voxmask that have a value greater than zero in
% the binary mask (this matrix is smaller than the old one)
voxmask = voxmask(:,mask > .1);

im_mean = nan(size(mask));
im_std = nan(size(mask));
% taking the data from your files, from the locations that have non zero
% value the the mask, and stacking them on eachother.
mattmp = spm_get_data(list_images,voxmask(1:3,:));
% taking the mean over each column
mattmp_mean = mean(mattmp,1);
%taking std over each column
mattmp_sd = std(mattmp,1);
% placing the mean and std value for each column in non-zero locations of the 
% binary mask, in the NAN matrix 
im_mean(mask > .1) = mattmp_mean;
im_std(mask > .1) = mattmp_sd;

    for j = 1:size(list_images,1)
        htmp = spm_vol(list_images{j});
        voltmp = spm_read_vols(htmp, mask);
        voltmp = (voltmp - im_mean)./im_std;
        [htmppathstr, htmpname, htmpext] = fileparts(htmp.fname);
        htmp.fname = fullfile(htmppathstr, ['z_' htmpname htmpext]);
        htmp.dt = [64 0];
        spm_write_vol(htmp, voltmp);
        fprintf('saving %s \n', htmp.fname)
    end
end
