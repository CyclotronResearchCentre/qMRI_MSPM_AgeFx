function CKall = crc_check_allCK
% Function to to claculate a list of relevant Cohen's Kappa (CK) values.
%  These consits in the following comparisons
%   - UuSPM vs mSPM for (-> row 1)
%       * all data
%       * within CV1 and CV2
%   - within UuSPM for (-> row 2)
%       * all data vs CV1/2
%       * CV1/CV2
%   - within mSPM for (-> row 3)
%       * all data vs CV1/2
%       * CV1/CV2
% i.e. 9 tests placed in 3 rows 
% Then this is repeated for
%   - the tissue classed (GM & WM) -> row of cell array
%   - the thresholds used (.05 & .0125) -> columns of cell array
% 
% FORMAT
%   CKall = crc_check_allCK
%
% OUTPUT
%   CKall : [2x2] cell array of [3X3] scalar arrays
%
%_______________________________________________________________________
% Copyright (C) 2026 Cyclotron Research Centre

% Written by
% - C. Phillips, Cyclotron Research Centre, University of Liege, Belgium
% - S. Moallemian, Rutgers University, NJ, USA

% Get defaults
[pth,fn] = crc_qMRIage_defaults; %#ok<*ASGLU>

% Deal with useful comparisons
%------------------
l_thr = {'p-0500','p-0125'};
CKall = cell(numel(fn.filt_TC),numel(l_thr));

% Loop over tissues, then threshold
% then do the 3+2*3 comparisons
for i_TC = 1:numel(fn.filt_TC)
    % Define pathes
    pth_all = fullfile(pth.deriv, ...
        sprintf('binarized_SPM_%s',fn.filt_TC{i_TC}));
    pth_CV1 = fullfile(pth.deriv, ...
        sprintf('binarized_CV1_SPM_%s',fn.filt_TC{i_TC}));
    pth_CV2 = fullfile(pth.deriv, ...
        sprintf('binarized_CV2_SPM_%s',fn.filt_TC{i_TC}));
    pth_mSPM = fullfile(pth.deriv,sprintf('mSPM_%s',fn.filt_TC{i_TC}));
    % Find mask
    fn_mask = spm_select('FPList',pth_mSPM,'mask.nii');
    for i_thr = 1:numel(l_thr)
        % compare UuSPM vs mSPM, for all
        filt_um = sprintf('^[Um].*%s\\.nii',l_thr{i_thr});
        fn_All_um = spm_select('FPList',pth_all,filt_um);
        CK_All_um = crc_CohenKappaImg(fn_All_um,fn_mask);
        % compare UuSPM vs mSPM, for CV1/2
        filt_um = sprintf('^CV1_[Um].*%s\\.nii',l_thr{i_thr});
        fn_CV1_um = spm_select('FPList',pth_CV1,filt_um);
        CK_CV1_um = crc_CohenKappaImg(fn_CV1_um,fn_mask);
        filt_um = sprintf('^CV2_[Um].*%s\\.nii',l_thr{i_thr});
        fn_CV2_um = spm_select('FPList',pth_CV2,filt_um);
        CK_CV2_um = crc_CohenKappaImg(fn_CV2_um,fn_mask);
        % compare, within UuSPM, all vs CV1/2 & CV1 vs CV2
        fn_u_AllCV1 = char(...
            spm_select('FPList',pth_all,sprintf('^Uu.*%s\\.nii',l_thr{i_thr})), ...
            spm_select('FPList',pth_CV1,sprintf('^CV1_Uu.*%s\\.nii',l_thr{i_thr})) );
        CK_u_AllCV1 = crc_CohenKappaImg(fn_u_AllCV1,fn_mask);
        fn_u_AllCV2 = char(...
            spm_select('FPList',pth_all,sprintf('^Uu.*%s\\.nii',l_thr{i_thr})), ...
            spm_select('FPList',pth_CV2,sprintf('^CV2_Uu.*%s\\.nii',l_thr{i_thr})) );
        CK_u_AllCV2 = crc_CohenKappaImg(fn_u_AllCV2,fn_mask);
        fn_u_CV1CV2 = char(...
            spm_select('FPList',pth_CV1,sprintf('^CV1_Uu.*%s\\.nii',l_thr{i_thr})), ...
            spm_select('FPList',pth_CV2,sprintf('^CV2_Uu.*%s\\.nii',l_thr{i_thr})) );
        CK_u_CV1CV2 = crc_CohenKappaImg(fn_u_CV1CV2,fn_mask);
        % compare, within mSPM, all vs CV1/2 & CV1 vs CV2
        fn_m_AllCV1 = char(...
            spm_select('FPList',pth_all,sprintf('^m.*%s\\.nii',l_thr{i_thr})), ...
            spm_select('FPList',pth_CV1,sprintf('^CV1_m.*%s\\.nii',l_thr{i_thr})) );
        CK_m_AllCV1 = crc_CohenKappaImg(fn_m_AllCV1,fn_mask);
        fn_m_AllCV2 = char(...
            spm_select('FPList',pth_all,sprintf('^m.*%s\\.nii',l_thr{i_thr})), ...
            spm_select('FPList',pth_CV2,sprintf('^CV2_m.*%s\\.nii',l_thr{i_thr})) );
        CK_m_AllCV2 = crc_CohenKappaImg(fn_m_AllCV2,fn_mask);
        fn_m_CV1CV2 = char(...
            spm_select('FPList',pth_CV1,sprintf('^CV1_m.*%s\\.nii',l_thr{i_thr})), ...
            spm_select('FPList',pth_CV2,sprintf('^CV2_m.*%s\\.nii',l_thr{i_thr})) );
        CK_m_CV1CV2 = crc_CohenKappaImg(fn_m_CV1CV2,fn_mask);
        % Collect all CK values 3 + 2*3 in one array
        CK_TC_thr = [ ...
            CK_All_um CK_CV1_um CK_CV2_um ; ...
            CK_u_AllCV1 CK_u_AllCV2 CK_u_CV1CV2 ; ...
            CK_m_AllCV1 CK_m_AllCV2 CK_m_CV1CV2] ;
        % Save it in cell array
        CKall{i_TC,i_thr} = CK_TC_thr;
    end
end

%% Display results
% First TC, hen thresholds
for i_TC = 1:numel(fn.filt_TC)
    fprintf('\n')
    fprintf('Cohen''s Kappa values for %s tissue\n',fn.filt_TC{i_TC});
    for i_thr = 1:numel(l_thr)
        fprintf('\tCare for threshold at %s\n',l_thr{i_thr});
        CK_TC_thr = CKall{i_TC,i_thr};
        fprintf('\t\t- compare UuSPM vs mSPM, with all, CV1, and CV2 data:\n');
        fprintf('\t\t\t %1.4f\t %1.4f\t %1.4f\n',CK_TC_thr(1,:))
        fprintf('\t\t- compare data set for UuSPM with all-vs-CV1, all-vs-CV2, and CV1-vs-CV2:\n');
        fprintf('\t\t\t %1.4f\t %1.4f\t %1.4f\n',CK_TC_thr(2,:))
        fprintf('\t\t- compare data set for mSPM with all-vs-CV1, all-vs-CV2, and CV1-vs-CV2:\n');
        fprintf('\t\t\t %1.4f\t %1.4f\t %1.4f\n',CK_TC_thr(3,:))
    end
end
end

