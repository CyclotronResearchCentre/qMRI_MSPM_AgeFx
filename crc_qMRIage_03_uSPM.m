function pth_out = crc_qMRIage_03_uSPM(fl_split)
% Function to create the univariate GLMs on the z-scored maps.
% This is performed per tissue-weighted smoothed images (2) and maps (4),
%
% The SPM analysis are placed in 8 (2x4) different derivatives folders.
% 
% FORMAT
%   pth_out = crc_qMRIage_03_uSPM(fl_split)
% 
% INPUT
%   fl_split : flag indicating which split to use: 
%               - 0, full dataset [def. if nothing indicated]
%               - 1, first fold 'CV1_' prefix
%               - 2, second fold 'CV2_' prefix
% 
% OUTPUT
%   pth_out : cell array (2x4) of pathes to the uSPM generated
%_______________________________________________________________________
% Copyright (C) 2025 Cyclotron Research Centre

% Written by
% - C. Phillips, Cyclotron Research Centre, University of Liege, Belgium
% - S. Moallemian, Rutgers University, NJ, USA

%% Get defaults
if nargin==0, fl_split = 0; end
[pth,fn] = crc_qMRIage_defaults(fl_split);
fl_printPDF = false; % do not print the design matrix
% set to 'true' to write out a PDF file of the design matrix 

% define sublist of subjects for covariates, if CV-split
switch fl_split
    case 1, ll_sub = 1:2:138; % CV1
    case 2, ll_sub = 2:2:138; % CV2
    otherwise, ll_sub = 1:138; % whole dataset
end

%% Prepare the basics for the SPM's
if ~exist(pth.code,'dir'), mkdir(pth.code); end;
% Get the empty matlabbatch
fn_MBatch_blank = fullfile(spm_file(mfilename('fullpath'),'fpath'), ...
    fn.MBuSPM);
run(fn_MBatch_blank); MBatch_orig = matlabbatch; %#ok<*NODEF>

% remove the review module, if not required
if ~fl_printPDF, MBatch_orig(3) = []; end

% Get the covariates from the participants.tsv file, for the list of
% subjecets (full of split CV1/2) 
% and turn the sex and scanner one into binary value (1 for 'F'/'trio' and 
% 0 for 'M'/'quatro')
participants_tsv = spm_load(fullfile(pth.data,'participants.tsv'));
fieldn = fieldnames(participants_tsv); Nfieldn = numel(fieldn);
SPM_cov = cell(2,Nfieldn-1);
for ii=1:Nfieldn-1
    SPM_cov{1,ii} = fieldn{ii+1};
    if strcmp(SPM_cov{1,ii},'sex')
        Csex = participants_tsv.(fieldn{ii+1})(ll_sub);
        tmp = zeros(size(Csex));
        for jj = 1:numel(Csex)
            if strcmp(Csex{jj},'F')
                tmp(jj) = 1; % 'F' set as 1, thus 'M' as 0
            end
        end
        SPM_cov{2,ii} = tmp;
    elseif strcmp(SPM_cov{1,ii},'scanner')
        Csca = participants_tsv.(fieldn{ii+1})(ll_sub);
        tmp = zeros(size(Csca));
        for jj = 1:numel(Csca)
            if strcmp(Csca{jj},'trio')
                tmp(jj) = 1; % 'trio' set as 1, thus 'quatro' as 0
            end
        end
        SPM_cov{2,ii} = tmp;    
    else
        SPM_cov{2,ii} = participants_tsv.(fieldn{ii+1})(ll_sub);
    end
end

%% Deal with the 2x4 SPM's, one by one
% Check filters for TC-weighted smoothing and maps
N_TC  = numel(fn.filt_TC);
N_maps = numel(fn.filt_maps);
pth_uSPM = cell(N_TC,N_maps);
fn_MBuSPM = cell(N_TC,N_maps);

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
        fn_uSPM_ij = sprintf('%suSPM_%s_%s', ...
            fn.pCV, fn.filt_TC{i_TWS}, fn.filt_maps{j_maps});
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
        fn_uSPM = fullfile(pth.code,['MBatch_',fn_uSPM_ij]);
        fn_MBuSPM{i_TWS,j_maps} = crc_save_matlabbatch(matlabbatch,fn_uSPM);
        
        % Executing the matlabbatch
        spm_jobman('run', matlabbatch);

    end
end

%% Spit out list of uSPM folders
pth_out = {pth_uSPM, fn_MBuSPM};
end
