function out = crc_qMRIage_03_uSPM
% Function to perform the univariate tests on the z-scored maps.
% This is performed per tissue-weighted smoothed images (2) and maps (4),
%
% The SPM analysis are placed in 8 (2x4) different derivatives folders.
%_______________________________________________________________________
% Copyright (C) 2025 Cyclotron Research Centre

% Written by
% - C. Phillips, Cyclotron Research Centre, University of Liege, Belgium
% - S. Moallemian, Rutgers University, NJ, USA

%% Get defaults
[pth,fn] = crc_qMRIage_defaults;

%% Prepare the basics for the SPM's
if ~exist(pth.code,'dir'), mkdir(pth.code); end;
% Get the empty matlabbatch
fn_MBatch_blank = fullfile(spm_file(mfilename('fullpath'),'fpath'), ...
    fn.MBuSPM);
run(fn_MBatch_blank); MBatch_orig = matlabbatch; %#ok<*NODEF>

% Get the covariates from the participants.tsv file
% and turn the sex and scanner one into binary value (1 for 'F' or 'trio')
participants_tsv = spm_load(fullfile(pth.data,'participants.tsv'));
fieldn = fieldnames(participants_tsv); Nfieldn = numel(fieldn);
SPM_cov = cell(2,Nfieldn-1);
for ii=1:Nfieldn-1
    SPM_cov{1,ii} = fieldn{ii+1};
    if strcmp(SPM_cov{1,ii},'sex')
        Csex = participants_tsv.(fieldn{ii+1});
        tmp = zeros(size(Csex));
        for jj = 1:numel(Csex)
            if strcmp(Csex{jj},'F')
                tmp(jj) = 1;
            end
        end
        SPM_cov{2,ii} = tmp;
    elseif strcmp(SPM_cov{1,ii},'scanner')
        Csca = participants_tsv.(fieldn{ii+1});
        tmp = zeros(size(Csca));
        for jj = 1:numel(Csca)
            if strcmp(Csca{jj},'trio')
                tmp(jj) = 1;
            end
        end
        SPM_cov{2,ii} = tmp;    
    else
        SPM_cov{2,ii} = participants_tsv.(fieldn{ii+1});
    end
end

%% Deal with the 2x4 SPM's, one by one
% Check filters for TC-weighted smoothing and maps
N_TC  = numel(fn.filt_TC);
N_maps = numel(fn.filt_maps);
pth_uSPM = cell(N_TC,N_maps);

for i_TWS = 1:N_TC
    % Pick tissue mask
    fn_mask_i = spm_select('FPListRec', pth.deriv, ...
        sprintf('^atlas-*%s.*_mask\\.nii(\\.gz)?$', fn.filt_TC{i_TWS}) );
    for j_maps = 1: N_maps
        % Pick list of maps from all subjects
        fn_img_ij = cellstr( spm_select('FPListRec', pth.TWsmo, ...
            sprintf('^sub.*%ssmo_%s\\.nii(\\.gz)?$', fn.filt_TC{i_TWS}, ...
            fn.filt_maps{j_maps}) ));
        N_img_j = size(fn_img_ij,1);
        % Define the SPM folder & create it
        fn_uSPM_ij = sprintf('uSPM_%s_%s', ...
            fn.filt_TC{i_TWS}, fn.filt_maps{j_maps});
        pth_uSPM_ij = fullfile(pth.deriv, fn_uSPM_ij);
        if ~exist(pth_uSPM_ij,'dir'), mkdir(pth_uSPM_ij); end;
        pth_uSPM{i_TWS,j_maps} = pth_uSPM_ij;
        
        % Fill up the matlabbatch
        matlabbatch = MBatch_orig;
        % - SPM directory
        matlabbatch{1}.spm.stats.factorial_design.dir = {pth_uSPM_ij};
        % - the data
        matlabbatch{1}.spm.stats.factorial_design.des.t1.scans = ...
            fn_img_ij;
        % - the covariates (this could be done outside the loops)
        for i_c = 1:size(SPM_cov,2)
            matlabbatch{1}.spm.stats.factorial_design.cov(i_c).c = ...
                SPM_cov{2,i_c}(1:N_img_j);
            matlabbatch{1}.spm.stats.factorial_design.cov(i_c).cname = ...
                SPM_cov{1,i_c};
        end
        % - the explicit mask
        matlabbatch{1}.spm.stats.factorial_design.masking.em = ...
            {fn_mask_i};
        
        % Saving it, in code folder, just in case
        save(fullfile(pth.code,['MBatch_',fn_uSPM_ij]),'matlabbatch');
        
        % Executing the matlabbatch
        spm_jobman('run', matlabbatch);

    end
end

%% Spit out list of uSPM folders
out = pth_uSPM;
end
