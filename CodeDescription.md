# MSPM qMRI analysis

Some explanation about the (origina) code by @SoodehMoallemian to process the (derivative) data, which are to be downloaded from https://openneuro.org/datasets/ds005851/versions/1.0.0.

Code is organized in a series of folders `step1_***` to `step18_***`, containing some specific code for that step of the processing. 

## Processing steps

### Step 1 

contains a function to unzip the derivative data: 

1. Unzip all derivatives/SPM8

2. Unzip all derivatives/VBQ_TWSmooth

3. Unzip masks and templates

###  Step 2 

z-scores the data and brings the maps into the normal ()$\mu=0$, $\sigma = 1$) distribution. It contains two files, the main function is `SM_within_voxel_z_scoring.m` and `SM_run_within_voxel_z_scoring_for_all_maps.m` asks to run the main function on different maps.

### Step 3 

univariate SPM creation for different maps:

### Steps 4 and 5 

multivariate SPM modeling and analysis


### Step 6 
create the clusters that survived the FWER corrected p-value (and specific least number of voxels per cluster=k) from the MSPM

### Step 7 

a.  `sm_extract_ROIs .m` reads the AAL3 atlas, and extracts each ROI. 

b.  `Combine_left_right_ROIs.m` combines ROIs from both hemispheres

c.  `MATLABBATCH_combine_Cerebellum_job.m` takes all the voxels belonging to any subregion of Cerebellum

d.  `MATLABBATCH_combine_Thalamus_job.m` takes all the voxels belonging to any subregion of Thalamus

### Step 8

a.   `SM_MedianCalc_For_ROIs.m` masked the images for each ROI, calculates the median values within that ROI, and saves the median values in a csv file. (also saves the masked ROI)

b.  `SM_create_median_age_table` creates a table with demographic data and median values for each ROI. The table contains covariates (age, sex, scanner, TIV) and median values for all ROIs for all subjects à to be used for median scatter plots and regression.

### Step 9

plot the scatter plots with regression fit

### Step 10

take the union of SPMs (for each tissue WM and GM f-test results). [both the function and the matlab batch do the same thing] the function is useful if there are NANs :arrow_forward: to be used when comparing the findings from MSPM and all SPMs together

### Step 11

`SM_calc_canonical_val_mean.m` function generates and saves canonical variate images based on the z-scored quantitative maps. It uses the canonical vector image, derived from the multivariateSPM in MSPM, and multiply it by the quantitative map values. Then, it takes the mean out of all canonical variates. The output image is the mean canonical vector length (canonical variate) for each voxel, that represents the contribution of the quantitative map in the MultivariateSPM model :arrow_forward: to be used in the canonical analysis results

### Step 12

`SM_extract_peak_from_MSPM.m`  finds the peak value for each ROI for the MSPM (or any other map) saves the coordinates and the value of the peak voxel

### Step 13

`SM_extract_peak_from_MSPM.m` same as step 12, but this time extracting the peak from canonical vectors

### Step 14

`sm_take_difference.m` takes the difference between MPSM and the union of all SPMs.

### Step15

a.  `SM_AllROIsMedianVals.m` stacks all ROI median values for each map in one csv file

b.  `SM_extractROIMedianAcrossMaps.m` reads the tables created in part (a) and extracts median values for each ROI is a separate file

### Step 16

voxel count from union of SPMs and MSPM

### Step 17

This script with take two images and only return the voxles that belong to the first image, (voxels that have values other than zero and NAN)

### Step 18

Script to calculate number of clusters and voxels for multiple images using `spm_bwlabel`





---

## Notes

Steps 1 to 4 have already been refactored in a more flexible code by @ChristophePhillips. Moreover a [master function `crc_qMRIage_main`](https://github.com/CyclotronResearchCentre/qMRI_MSPM_AgeFx/blob/main/crc_qMRIage_main.m), then calls the individual steps, in order to fully (as much as possible with MSPM) the whole data process, which is much more convenient  
