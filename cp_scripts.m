%% Handful scripts to manage the data and run the code.
% ====================================================
cd D:\6_GitHubCRC_Git\qMRI_MSPM_AgeFx
% Get defaults
[pth,fn] = crc_qMRIage_defaults %#ok<*ASGLU>

%%  Gzipping all files in a folder
% Defaults & input
flag_gzip = struct(...
    'filt','^.*\.nii$',... % all .nii files
    'rec', true, ... % act recursively
    'delOrig', true);      % delete original file after gzipping 

% Gzip the z-scored maps
fn_out = crc_gzip(pth.zscore, flag_gzip) %#ok<*NASGU>

% Gzip the results, just the .nii files, from CV
pth_res = 'C:\Users\christophe\OneDrive - Universite de Liege\2_Data\ds005851\derivatives'
pth_res = 'D:\ccc_DATA\ds005851\derivatives'
fn_out = crc_gzip(pth_res, flag_gzip);

%% Unzipping data to relaucnh processing
flag_gunzip = struct(...
      'filt','^.*\.gz$',... % all .gz files
      'rec', true, ...      % act recursively
      'delOrig', true);  
% Original data
[pth,fn] = crc_qMRIage_defaults(0)
fn_out = crc_gunzip(pth.zscore, flag_gunzip);

% CV1 data
[pth_CV1,~] = crc_qMRIage_defaults(1)
fn_out = crc_gunzip(pth_CV1.zscore, flag_gunzip);
% CV2 data
[pth_CV2,~] = crc_qMRIage_defaults(2)
fn_out = crc_gunzip(pth_CV2.zscore, flag_gunzip);

% Top masks
flag_gunzip = struct(...
      'filt','^.*\.gz$',... % all .gz files
      'rec', false, ...      % act recursively
      'delOrig', true);  
fn_out = crc_gunzip(pth.deriv, flag_gunzip);

%% Checking CV1_GM_MTsat

NVx = Nvx_per_clust_CV1{1,1}
sum(NVx{1,1}==1)

%% Looking at Cohen's Kappa
% Test
fn_bin_test = char( fn_out{1,1}{1}, fn_out{1,5}{1})
CK = crc_CohenKappaImg(fn_bin_test)
% CK = crc_CohenKappaImg(fn_bin_test,fn_msk)

% USeful tests
CKall = crc_check_allCK

%% Zipping of .nii files from some specific set of folder

% Defaults & input
[pth,fn] = crc_qMRIage_defaults;
% filt_dir = '.*binarized.*';
filt_dir = '.*SPM.*';
l_dirs = spm_select('FPList',pth.deriv,'dir',filt_dir)

% Zipping
flag_gzip = struct(...
    'filt','^.*\.nii$',... % all .nii files
    'rec', true, ... % act recursively
    'delOrig', true);      % delete original file after gzipping 
for i_dir = 1:size(l_dirs,1)
    fn_out = crc_gzip(deblank(l_dirs(i_dir,:)), flag_gzip);
end



