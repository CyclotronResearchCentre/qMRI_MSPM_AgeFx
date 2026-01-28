# qMRI aging data processing

Some practical information about the processing of the "MPM qMRI aging" dataset.

#### NOTE: 

The whole code derives from code originally written by S. Moallemian, then updated by C. Phillips. Only steps 1 to 5 have been updated in the code here under, the rest is on my "to do" list...

---

## Prerequisites

We need to have 

- "clean" versions of [SPM](https://github.com/spm/spm) (use the latest release, i.e. SPM25) and [MSPM](https://github.com/LREN-CHUV/MSPM) (both available from GitHub);

- a [copy of the data](https://openneuro.org/datasets/ds005851/versions/1.0.0/download#) directly from OpenNeuro;

- for results extraction, a copy of the [`AAL3v1_1mm` atlas](https://www.oxcns.org/aal3.html), installed in the SPM folder as described in the instructions.

The path to these 3-4 folders will be defined in the `crc_qMRIage_defaults` function.

---

## Main processing steps

The whole data processing is run from the main function `crc_qMRIage_main.m`, which itself calls a series of other function. Here is a brief description of these:

- general purpose functions

  - `crc_qMRIage_defaults`,  simple function to define some default values for the processing of the dataset. One should at least update the basic paths for his own system and installation, i.e. the fields in the `pth` structure
  - `pth.spm` :arrow_forward: folder with SPM's distribution, e.g. `D:\6a_GitHub_SPM\spm25` on my computer
    
  - `pth.mspm` :arrow_forward: folder with MSPM's distribution, e.g. `D:\6a_GitHub_SPM\MSPM` on my computer
    
  - `pth.data` :arrow_forward: main folder with the data, e.g. `D:\ccc_DATA\ds005851` on my computer
  - `crc_gzip` & `crc_gunzip`, home made functions to zip & unzip a bunch of files, based on some filters (using `spm_select` "regular expression") and potentially recursively in a folder.
  
- specific processing step function
  - to create the univariate/multivariate SPM's
    - `crc_qMRIage_01_prepdata`, cleans up the data (removing the non-smoothed data folder) and unzipping the rest
    - `crc_qMRIage_02_zscoring`, z-scoring all the data, this is performed within voxel across subjects, per tissue-weighted smoothed images (GM & WM tissue classes) and maps (4 for `MTsat`, `PD`, `R1`, `R2star`), i.e. one voxel from a single map smoothed for one tissue, across all the subjects.
    - `crc_qMRIage_03_uSPM`, creating the univariate GLMs on the z-scored maps. This is performed per tissue-weighted smoothed images (2 tissue classes) and (4) maps. The SPM analysis are placed in 8 (2x4) different derivatives folders.
    - `crc_qMRIage_04_mSPM`, performing the multivariate SPM, per tissue-weighted smoothed images (2 tissue classes), relying on the previously built univariate 4 SPMs. The 2 MSPM analysis are placed in different derivatives folders.
  
  - to extract some relevant information from the statistical maps
    - `crc_qMRIage_05_signifClusVxl`, counting the number of of significant clusters and voxels
    - `crc_qMRIage_06_extractROIs`, extracting and plotting the values in some ROIs
  



### Limitations 

There remain a few [open issues](https://github.com/LREN-CHUV/MSPM/issues) with MSPM code. Most of these should not be too difficult to fix... except for [issue nr 4](https://github.com/LREN-CHUV/MSPM/issues/4) about the definition of the contrasts (which **must** be entered manually through a pop-up GUI :astonished:).

Efectively the main problem with MSPM code, as it stands now, is that **one cannot fully automatize the MSPM analysis**! Indeed, when trying to run the `Analysis` module, only the `MSPM.mat` file is selected and an external GUI window opens to defined the contrasts of interests: one for the experimental design (e.g. group comparison or regression) and one for the modalities (e.g. effect across all modalities). This poorly fitted GUI, then opens SPM's standard contrast definition GUI window.

The 2 constrasts :

- `c` for the experimental desing should be set to `[0 1 0 0 0]`, to test for the age regressor;
- `L` for the modalities should be set to `eye(4)`, to test for all modalities considered together.

We will try to solve that but it is not straightforward and will take time, which we do not have...

---

## Future

With the code here above, the univariate and multivariate SPMs are all calculated. It would convenient to upgrade the codes from steps 6 till 16 in order to generate all the maps, figures and tables used in the paper and its appendix.
