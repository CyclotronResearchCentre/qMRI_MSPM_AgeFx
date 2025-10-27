function fname = crc_save_matlabbatch(matlabbatch,fname)
% Function to save a manually built matlabbatch structure into an .m file
% with the code to generate the matlabbatch.
% This allows easy humen reviewing of the batch created, and potentially
% manual tweaking of these.
% 
% FORMAT
%   fname = crc_save_matlabbatch(matlabbatch, fname)
% 
% INPUT
%   matlabbatch : matlabbatch structure as created in script/function
%   fname       : filename, including path if a specific folder is needed
%                 if left empty, then 'matlabbatch.m' is used
% 
% NOTE:
% This code is largely inspired from the 'cfg_util' function, around lines
% 996 to 1011, which is part of the Matlabbatch package, by V. Glauche
% See https://github.com/spm/spm/blob/main/matlabbatch/cfg_util.m#L995
%_______________________________________________________________________
% Copyright (C) 2025 Cyclotron Research Centre

% Written by 
% - C. Phillips, Cyclotron Research Centre, University of Liege, Belgium
% - S. Moallemian, Rutgers University, NJ, USA

% Check filename is provide, or use default
if nargin<2 || isempty(fname)
    fname = 'matlabbatch.m';
end

% Revision version, as copied from cfg_util.m
rev = '$Rev: 8183 $';

% Turn the matlabbatch structure into cell array of string, with code lines
jobstr = gencode(matlabbatch); 

% Make sure the extension is '.m' and open file
fname = spm_file(fname,'ext','m');
fid = fopen(fname, 'wt');

% Save header stuff
fprintf(fid, '%%-----------------------------------------------------------------------\n');
fprintf(fid, '%% Job saved on %s by %s (rev %s)\n', datestr(now), ...
    mfilename, rev);
versions = cfg_get_defaults('versions');
vtags    = fieldnames(versions);
for k = 1:numel(vtags)
    fprintf(fid, '%% %s %s - %s\n', vtags{k}, versions.(vtags{k}).name, ...
        versions.(vtags{k}).ver);
end
fprintf(fid, '%%-----------------------------------------------------------------------\n');

% Save the matlabbatch stuff
fprintf(fid, '%s\n', jobstr{:});
% and close file
fclose(fid);                    
                                        
end