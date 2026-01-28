function out = crc_qMRIage_04_mSPM(fl_split)
% Function to perform the multivariate SPM.
% This is performed per tissue-weighted smoothed images (2), relying on the
% previously built univariate SPMs (4).
%
% The 2 MSPM analysis are placed in different derivatives folders.
% 
% WARNING
%  It is quite insane that the analysis module does launch a GUI window
%  where the user must define the necessary contrast vectors!
%  This should definitely be integrated in the matlabbatch system, even if
%  just very roughly as a matrix input, without any check.
% 
% The 2 constrasts :
% - 'c' for the experimental desing should be set to [0 1 0 0 0], to test
%   for the age regressor
% - 'L' for the modalities should be set to eye(4), to test for all
%   modalities considered together
%_______________________________________________________________________
% Copyright (C) 2025 Cyclotron Research Centre

% Written by
% - C. Phillips, Cyclotron Research Centre, University of Liege, Belgium
% - S. Moallemian, Rutgers University, NJ, USA

%% Get defaults
if nargin==0, fl_split = 0; end
[pth,fn] = crc_qMRIage_defaults(fl_split);

%% Pick up the uSPM's, and combine them into a MSPM
% Check filters for TC-weighted smoothing and maps
N_TC  = numel(fn.filt_TC);
N_maps = numel(fn.filt_maps);
pth_mSPM = cell(N_TC,1);
fn_MBmSPM = cell(N_TC,1);

pth_wd = pwd; % neede to return after running MSPM
for i_TC = 1:N_TC
    % Find the uSPM folders nad corresponding SPM.mat files
    filt_TC_i = sprintf('^%suSPM_%s_.*',fn.pCV,fn.filt_TC{i_TC});
    dirs_i = spm_select('FPList',pth.deriv,'dir',filt_TC_i);
    fn_uSPM = cell(N_maps,1);
    for j_maps = 1:N_maps
        fn_uSPM{j_maps} = fullfile(deblank(dirs_i(j_maps,:)),'SPM.mat');
    end
    % Prepare the MSPM folder
    pth_mSPM{i_TC} = fullfile(pth.deriv, ...
        sprintf('%smSPM_%s',fn.pCV,fn.filt_TC{i_TC}) );
    if ~exist(pth_mSPM{i_TC},'dir'), mkdir(pth_mSPM{i_TC}); end
    % MSPM mode estimation:
    % - define fresh matlabbatch
    clear matlabbatch
    matlabbatch{1}.spm.tools.results.model_estimation.spmmat = ...
        fn_uSPM;
    matlabbatch{1}.spm.tools.results.model_estimation.swd = ...
        {pth_mSPM{i_TC}};
    matlabbatch{2}.spm.tools.results.analyse.spmmat = ...
        {fullfile(pth_mSPM{i_TC},'MSPM.mat')};
    % - save matlabbatch
    fn_mSPM = fullfile(pth.code, ...
        sprintf('MBatch_%smSPM_ModelEstimAnalysis_%s', ...
                fn.pCV, fn.filt_TC{i_TC}) );
    fn_MBmSPM{i_TC} = crc_save_matlabbatch(matlabbatch,fn_mSPM);
    % - run matlabbatch
    spm_jobman('run', matlabbatch);
    % - return back to original folder
    cd(pth_wd)
end


%% Spit out list of mSPM folders
out = pth_mSPM;

end