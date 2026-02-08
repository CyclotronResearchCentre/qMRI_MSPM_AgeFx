%% Handful scripts to manage the data and run the code.

% Get defaults
[pth,fn] = crc_qMRIage_defaults

%  Gzipping all files in a folder
% Defaults & input
flag_gzip = struct(...
    'filt','^.*\.nii$',... % all .nii files
    'rec', true, ... % act recursively
    'delOrig', true);      % delete original file after gzipping 

% Gzip the z-scored maps
fn_out = crc_gzip(pth.zscore, flag_gzip)


