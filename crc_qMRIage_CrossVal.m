function aa = crc_qMRIage_CrossVal
% Function for "cross-validation" of the processing &analsyis of the MPM 
% qMRI aging data set.
% This will work like the original "main" function BUT will start by
% randomly splitting the data into 2 subsets, which will be processed
% independently as the "full dataset".
% 
% Main steps
% ----------
% 1/ Create a split copy of the orginal data into CV1_/CV2_ derivatives
% folder
% 2/ Proceed as "main" function for each CV1_/CV2_ subset of data
% 
% NOTE
% 1/ Splitting is done randomly by considering the even/odd indexes, as the
% order of the subjects was randomized when anonymizing the data for public
% release.
% 2/ To facilitate the whole process, a flag is used to indicate which
% (sub)set of data should be used/ This implies tweaking the defaults and
% every call to the defaults to return the key folders prepended with
% 'CV1_', 'CV2_' or nothing (for the full dataset.
%_______________________________________________________________________
% Copyright (C) 2025 Cyclotron Research Centre

% Written by 
% - C. Phillips, Cyclotron Research Centre, University of Liege, Belgium
% - S. Moallemian, Rutgers University, NJ, USA

% Initiliazing SPM
spm('defaults','fmri'),
spm_jobman('initcfg')

%% 00. Setup original pathes, to full data set
% Some checks & path handling
[pth_o,~] = crc_qMRIage_defaults;
[pth_1,~] = crc_qMRIage_defaults(1);
[pth_2,~] = crc_qMRIage_defaults(2);

%% 01. Splitting into the 2 CV-folds
% The data are assumed to have been dzipped and prepared
dr_allSubj = spm_select('FPList',pth_o.TWsmo,'dir','^sub-S\d{3,3}$');
Nsubj = size(dr_allSubj,1); 
% Should be 138 !
if Nsubj~=138, error('Wrong number of subjects in dataset!'); end

% Prepare CV1_/C2_ subfolders
if ~exist(pth_1.TWsmo,'dir'), mkdir(pth_1.TWsmo); end
if ~exist(pth_2.TWsmo,'dir'), mkdir(pth_2.TWsmo); end

% Copy the data into CV1_/C2_
for ii=1:Nsubj/2
    i1 = 2*ii-1; i2 = 2*ii;
    copyfile(dr_allSubj(i1,:), ...
        fullfile(pth_1.TWsmo,spm_file(dr_allSubj(i1,:),'filename')));
    copyfile(dr_allSubj(i2,:), ...
        fullfile(pth_2.TWsmo,spm_file(dr_allSubj(i2,:),'filename')));
end

%% 02. Z-scoring
fn_Zmaps_CV1 = crc_qMRIage_02_zscoring(1);
fn_Zmaps_CV2 = crc_qMRIage_02_zscoring(2);

%% 03. Perform univariate SPM analysis
s03_out_CV1 = crc_qMRIage_03_uSPM(1);
s03_out_CV2 = crc_qMRIage_03_uSPM(2);

%% 04. Perform multivarite SPM analysis
s04_out_CV1 = crc_qMRIage_04_mSPM(1);
s04_out_CV2 = crc_qMRIage_04_mSPM(2);


end
