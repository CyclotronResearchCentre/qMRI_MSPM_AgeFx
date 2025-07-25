function pth = crc_qMRIage_defaults
% Simple function to define some default values for the processing of the
% "MPM qMRI aging" dataset. One should at least update the basic pathes for
% his own system and installation.
% 
% FORMAT pth = crc_qMRIage_defaults
% 
% OUTPUT
%   pth     : structure with a list of basic and secondary pathes
%   .spm    : root folder with SPM25
%   .mspm   : root folder with MSPM
%   .data   : root folder with the BIDS data
%   .deriv  : folder with the derivatives
%   .dartel : folder with the SPM8-Dartel processed data (not smoothed)
%   .TWsmo  : folder with the tissue-weighted smoothed data (to be used!)
%   .zscore : folder with the z-scored maps
%_______________________________________________________________________
% Copyright (C) 2025 Cyclotron Research Centre

% Written by 
% - C. Phillips, Cyclotron Research Centre, University of Liege, Belgium
% - S. Moallemian, Rutgers University, NJ, USA

%% Pathes
% Basic pathes
pth = struct( ...
    'spm', 'D:\6a_GitHub_SPM\spm25', ...
    'mspm', 'D:\6a_GitHub_SPM\MSPM', ...
    'data', 'D:\ccc_DATA\ds005851');

% Secondary pathes
pth.deriv  = fullfile(pth.data,'derivatives');
pth.dartel = fullfile(pth.deriv,'SPM8_dartel');
pth.TWsmo  = fullfile(pth.deriv,'VBQ_TWsmooth');
pth.zscore = fullfile(pth.deriv,'Zsc_maps');


end