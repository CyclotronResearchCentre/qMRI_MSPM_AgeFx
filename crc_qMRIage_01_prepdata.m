function out = crc_qMRIage_01_prepdata
% Function dealing with data preparation and cleaning up.
%_______________________________________________________________________
% Copyright (C) 2025 Cyclotron Research Centre

% Written by 
% - C. Phillips, Cyclotron Research Centre, University of Liege, Belgium
% - S. Moallemian, Rutgers University, NJ, USA

%% Get defaults
pth = crc_qMRIage_defaults;

%% Deleting unnecessary folder with non-smoothed data
if exist(pth.dartel,'dir'), delete(pth.dartel); end

%% Unzip all images in the TW-smoothed derivatives folder 
% + 'derivatives' top folder with atlases.
fn_out = crc_gunzip(pth.deriv, flag);

%% Spit out list of files
out = fn_out;

end
