function fn_out = crc_gunzip(fn_in, flag)
% Function to gunzip a list of files, either explicitly listed or picked up
% with a "regular expression" filter, potentially recursively.
% 
% FORMAT
% 
%   fn_out = crc_gunzip(fn_in, flag)
% 
% INPUT
% 
% fn_in     : single file, list of files, or path to a folder where files
%             will be selected to be gunzipped
% flag      : structure with some options
%   .filt       : file filtering regular expression (see spm_select)
%                 Def. '^.*\.gz$', i.e. all .gz files
%   .rec        : act recursively or not on folder
%                 Def. 'true', i.e. act recursively
%   .delOrig    : delete the original file(s) or not 
%                 Def. 'false', i.e. do NOT delete original zipped file(s)
% 
% OUPTUT
% 
% fn_out    : file(s) that were gunzipped
% 
% 
% EXAMPLE
% 
% flag = struct(...
%     'filt','^.*\.gz$',... % all .gz files
%     'rec', true, ...      % act recursively
%     'delOrig', false);    % do not delete original zipped file(s
% pth_in = 'D:\myDATA\';
% fn_out = crc_gunzip(fn_in, flag)
% 
% NOTE:
% When multiple files are passed, gunzip will put all the uncompressed 
% files into the folder of the *1st* filer. Therefore, it is safer to loop 
% over the files and ensure their % uncompressed version is created next to
% the original one!
% This is what this function is doing. :-)
%_______________________________________________________________________
% Copyright (C) 2025 Cyclotron Research Centre

% Written by C. Phillips.
% Cyclotron Research Centre, University of Liege, Belgium

% Defaults & input
flag_ref = struct(...
    'filt','^.*\.gz$',... % all .gz files
    'rec', true, ...      % act recursively
    'delOrig', false);    % do not delete original file after gunzipping 
pth_ref = '.'; % use local location by default

if nargin<2, flag = flag_ref; end
if nargin<1, fn_in = pth_ref; end

% Find out if dealing with (list of) file(s) or a single path, from which
% to pick some files
if size(fn_in,1)>1 || exist(fn_in,'file')==2
    % assume it's single/list of file/s
    search_dir = false;
    fn_2gunz = fn_in;
elseif size(fn_in,1)==1 && exist(fn_in,'dir')==7
    % assume single path to deal with
    search_dir = true;
    pth_seach = fn_in;
else
    % Unknown case
    beep
    fprintf('\nUnknow input format\n\t%s',fn_in')
end

% If searching a directory, then pick up all the target files
if search_dir
    % Do we go recursive or not ?
    if flag.rec
        listSelect = 'FPListRec';
    else
        listSelect = 'FPList';
    end
    fn_2gunz = spm_select(listSelect,pth_seach,flag.filt);
end

% gunzipping things, one by one to keep thigns clean
for ii=1:size(fn_2gunz,1)
    gunzip(deblank(fn_2gunz(ii,:)));
    % if requested delete original file
    if flag.delOrig
        delete(deblank(fn_2gunz(ii,:)));
    end
end

% return list of gunzipped files
fn_out = spm_file(fn_2gunz, 'ext','');

end


