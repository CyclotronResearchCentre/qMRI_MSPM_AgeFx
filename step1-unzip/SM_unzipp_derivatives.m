% 1. Unzipp all derivatives/ SPM8
source = '/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/data/derivatives/SPM8_dartel';
sub_list = dir(source);
sub_list = sub_list([sub_list.isdir] & ~ismember({sub_list.name}, {'.', '..'}));  % Only folders, no . or ..

data_list = cellstr(spm_select('FPListRec', source, '.*.nii.gz'));

for ii = 1:length(sub_list)
    sub_id = sub_list(ii).name;
    sub_folder = fullfile(source, sub_id);

    for jj = 1:length(data_list)
        this_file = data_list{jj};

        if contains(this_file, sub_id)
            gunzip(this_file, fullfile(sub_folder, 'anat'));
        end
    end
end

% 2. Unzipp all derivatives/VBQ_TWSmooth
source = '/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/data/derivatives/VBQ_TWsmooth';
sub_list = dir(source);
sub_list = sub_list([sub_list.isdir] & ~ismember({sub_list.name}, {'.', '..'}));  % Only folders, no . or ..

data_list = cellstr(spm_select('FPListRec', source, '.*.nii.gz'));

for ii = 1:length(sub_list)
    sub_id = sub_list(ii).name;
    sub_folder = fullfile(source, sub_id);

    for jj = 1:length(data_list)
        this_file = data_list{jj};

        if contains(this_file, sub_id)
            gunzip(this_file, fullfile(sub_folder, 'anat'));
        end
    end
end

% 2. Unzipp masks and templates

source = '/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/data/derivatives/';
mask_list = cellstr(spm_select('FPList', source, '.*\.nii\.gz'));

for ii = 1:length(mask_list)
    gunzip(mask_list{ii}, source);
end

template = cellstr(spm_select('FPList', fullfile(source,'SPM8_dartel'), '.*\.nii\.gz'));
gunzip(template, fullfile(source,'SPM8_dartel'));