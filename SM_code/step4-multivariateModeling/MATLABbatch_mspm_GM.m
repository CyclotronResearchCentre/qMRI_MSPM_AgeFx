% List of open inputs
nrun = X; % enter the number of runs here
jobfile = {'/Users/smoallemian/Desktop/Manuscripts/Moallemian et al_Aging_2025/NewScripts/step-5/MATLABbatch_mspm_GM_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(0, nrun);
for crun = 1:nrun
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
