function [pth,fn] = crc_qMRIage_defaults(fl_split)
% Simple function to define some default values for the processing of the
% "MPM qMRI aging" dataset. One should at least update the basic pathes for
% his own system and installation.
% 
% FORMAT [pth,fn] = crc_qMRIage_defaults(fl_split)
% 
% INPUT
%   fl_split: flag indicating which split to use: 
%               - 0, full dataset [def. if nothing indicated]
%               - 1, first fold 'CV1_' prefix
%               - 2, second fold 'CV2_' prefix
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
%   .code   : folder with some codes/matlabbatch created during the
%             processing
%   fn      : structure with a list of filenames
%   .pCV    : prfix for th cross-validation fold (empty or 'CV1/2_')
%   .MBuSPM : matlabbatch with the empty 1S-ttest GLM definition
%   .filt_TC   : tissue classes considered, {'GM','WM'}
%   .filt_maps : maps considered , {'MTsat','PDmap','R1map','R2starmap'}
%_______________________________________________________________________
% Copyright (C) 2025 Cyclotron Research Centre

% Written by 
% - C. Phillips, Cyclotron Research Centre, University of Liege, Belgium
% - S. Moallemian, Rutgers University, NJ, USA

%% Check input
% Assuming that the user passes a legitimate value (0, 1 or 2) or nothing
if nargin==0
    fl_split = 0;
end
switch fl_split
    case 0, pCV = '';
    case 1, pCV = 'CV1_';
    case 2, pCV = 'CV2_';
    otherwise
        error('Wrong crossvalidation flag')
end

%% Pathes
% Basic pathes
pth = struct( ...
    'spm', 'D:\6a_GitHub_SPM\spm25', ...
    'mspm', 'D:\6a_GitHub_SPM\MSPM', ...
    'aal3', 'D:\6a_GitHub_SPM\AAL3', ...
    'data', 'D:\ccc_DATA\ds005851');

% Secondary pathes
pth.deriv  = fullfile(pth.data,'derivatives');
pth.dartel = fullfile(pth.deriv,'SPM8_dartel');
pth.TWsmo  = fullfile(pth.deriv,[pCV,'VBQ_TWsmooth']);
pth.zscore = fullfile(pth.deriv,[pCV,'Zsc_maps']);
pth.code   = fullfile(pth.data,'code');

%% Filenames
fn = struct( ...
    'pCV', pCV, ...
    'MBuSPM', 'MBatch_1Sttest_empty.m', ...
    'filt_TC', {{'GM','WM'}}, ...
    'filt_maps', {{'MTsat','PDmap','R1map','R2starmap'}});

end