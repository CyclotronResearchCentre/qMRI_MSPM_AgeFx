%-----------------------------------------------------------------------
% Script to calculate number of clusters and voxels for multiple images
% using spm_bwlabel
%-----------------------------------------------------------------------

spm('Defaults','fMRI');
spm_jobman('initcfg');

% List of NIfTI files
nii_files = { ...
    'union_SPMs_05_GM.nii', ...
    'union_SPMs_125_GM.nii', ...
    'union_SPMs_05_WM.nii', ...
    'union_SPMs_125_WM.nii'};

results = struct();

for i = 1:numel(nii_files)
    nii_file = nii_files{i};
    fprintf('\nProcessing file: %s\n', nii_file);

    % Load image
    V = spm_vol(nii_file);
    Y = spm_read_vols(V);

    % Binarize 
    Ybin = double(Y > 0);

    [cluster_labels, num_clusters] = spm_bwlabel(Ybin, 26);

    % Calculate voxel counts
    total_voxels = sum(Ybin(:));
    voxels_per_cluster = zeros(num_clusters,1);
    for c = 1:num_clusters
        voxels_per_cluster(c) = sum(cluster_labels(:) == c);
    end

    % Store results in struct
    results(i).filename = nii_file;
    results(i).num_clusters = num_clusters;
    results(i).total_voxels = total_voxels;
    results(i).voxels_per_cluster = voxels_per_cluster;

    % Print summary
    fprintf('  Total clusters: %d\n', num_clusters);
    fprintf('  Total voxels: %d\n', total_voxels);
end

% Save results
save('cluster_voxel_counts_all.mat','results');
