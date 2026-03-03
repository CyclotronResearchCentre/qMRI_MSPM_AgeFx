function CK = crc_CohenKappaImg(fn_bin,fn_msk)
% Function to calculate Cohen's Kappa between 2 binarized maps. A mask can
% be passed along to limite the space to the voxels in the mask.
% 
% Interpretation of Cohen's Kappa value, by Landis & Koch
%   Range       Meaning
%   0.00-0.20   Poor 
%   0.21-0.40   Fair 
%   0.41-0.60   Moderate 
%   0.61-0.80   Good 
%   0.81-1.00   Very good
% 
% Ref: 
% - https://en.wikipedia.org/wiki/Cohen%27s_kappa
% - Cohen J. A coefficient of agreement for nominal scales. Educ Psychol 
%   Measur 1960];20:37–46.
%   https://doi.org/10.1177/001316446002000104
% - Landis JR, Koch GG. The measurement of observer agreement for 
%   categorical data. Biometrics 1977];33:159–74. 
%   https://doi.org/10.2307/2529310 & https://www.jstor.org/stable/2529310
%_______________________________________________________________________
% Copyright (C) 2025 Cyclotron Research Centre

% Written by
% - C. Phillips, Cyclotron Research Centre, University of Liege, Belgium
% - S. Moallemian, Rutgers University, NJ, USA

Val_bin = spm_read_vols(spm_vol(fn_bin));

if nargin==2
    Val_msk = spm_read_vols(spm_vol(fn_msk));
    use_msk = true;
else
    use_msk = false;
end

sz_bins = size(Val_bin);
vVal_bin = reshape(Val_bin,[prod(sz_bins(1:3)),sz_bins(4)]);

% if a mask is provided, throw out voxels outside the maak
if use_msk
    % Remove things outside mask
    vVal_bin(Val_msk(:)==0,:) = [];
end

% Count TP/FP/TN/FN
TP = sum(and(vVal_bin(:,1),vVal_bin(:,2)));
TN = sum(and(~vVal_bin(:,1),~vVal_bin(:,2)));

FP = sum(and(vVal_bin(:,1),~vVal_bin(:,2)));
FN = sum(and(~vVal_bin(:,1),vVal_bin(:,2)));

% Calculate Cohen's Kappa

CK = 2 * ( TP*TN - FP*FN) / ( (TP+FP)*(FP+TN) + (TP+FN)*(FN+TN) );

end