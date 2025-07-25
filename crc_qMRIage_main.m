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
% adding SPM path, if not found
if isempty(which('spm')), addpath(pth.spm); end
% and initiliazing SPM
spm('defaults','fmri'),
spm_jobman('initcfg')

%% 01. Prepare and clean up the original data
% if that's not already done.
s01_out = crc_qMRIage_01_prepdata;

%% 02. Deal with z-scoring of the data
s02_out = crc_qMRIage_02_zscoring;

%% 03. Perform univariate SPM analysis
s03_out = crc_qMRIage_03_uSPM;



% % Get list of subjects
% [subj_dirs] = spm_select('FPList',pth.data,'dir','^sub-.*$');
% Nsubs = size(subj_dirs,1);

end
