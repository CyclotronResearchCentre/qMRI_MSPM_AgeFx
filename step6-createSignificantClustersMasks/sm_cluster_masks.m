function sm_cluster_masks(SPM_path,p_thresh,k_thresh,dest)
%%
% This function will take the SPM.mat of your model and 
% returns the masks from significant clusters surviving the P_value for
% family wise error rate correction. 
% Inputs:
%SPM_path : path to your spm.mat
%p_thresh: (0.05,0.001,0)
%k_thresh: thresholding the ,minumum number of voxels in each cluster
%dest: path to where you want to save the cluster images
% Example inputs:
% SPM_path = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/statistical analysis/MultivariateSPM/GM/L_01_c01/');
% p_thresh = 0.05;
% k_thresh = 20;
% dest = fullfile('/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/statistical analysis/ClustersMasks/GM_ClustersMasks_at_p_00125');
% sm_cluster_masks(SPM_path,p_thresh,k_thresh,dest)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(SPM_path)
% Load SPM.mat file
load('SPM.mat')

% Find index of F-test contrast in SPM.xCon
con_idx = find(strcmp({SPM.xCon.STAT},'F'));

% Load F-map
%%%%you should change the name of the folder at the moment
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
cd(dest)
% mkdir(sprintf('cluster_masks_FWER%d',p_thresh)) 
% cd cluster_masks
% Loop over clusters and save as NIfTI files
for ii = 1:n_clusters
    voxels = find(clusters == ii);
    if length(voxels) >= k_thresh
        mask = zeros(size(F));
        mask(voxels) = 1;
        V.fname = sprintf('cluster_%03d.nii',ii);
        spm_write_vol(V,mask);
    end
end
end