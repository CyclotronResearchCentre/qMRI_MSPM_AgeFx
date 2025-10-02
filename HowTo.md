# qMRI aging data processing

Some practical information about the processing of the "MPM qMRI aging" dataset.

NOTE: The whole code derives from code 1st written by S. Moallemian, then updated by C. Phillips

## Prerequisites

We need to have 

- "clean" versions of [SPM](https://github.com/spm/spm) and [MSPM](https://github.com/LREN-CHUV/MSPM), available from GitHub.

- a [copy of the data](https://openneuro.org/datasets/ds005851/versions/1.0.0/download#) directly from OpenNeuro

The path to these 3 folders will be defined in the `crc_qMRIage_defaults` function.



## Main processing steps

The whole data processing is run from the main function `crc_qMRIage_main.m`, which itself calls a series of other function. Here is a brief description of these:

- general purpose functions

  - `crc_qMRIage_defaults`,  simple function to define some default values for the processing of the dataset. One should at least update the basic paths for his own system and installation, i.e. 

    - `spm` :arrow_forward: folder with SPM's distribution, e.g. `D:\6a_GitHub_SPM\spm25`

    - `mspm` :arrow_forward: folder with MSPM's distribution, e.g. `D:\6a_GitHub_SPM\MSPM`

    - `data` :arrow_forward: main folder with the data, e.g. `D:\ccc_DATA\ds005851`
  - `crc_gzip` & `crc_gunzip`, home made functions to zip & unzip a bunch of files, based on some filters (using `spm_select` "regular expression") and potentially recursively in a folder.

- specific processing step function
  - `crc_qMRIage_01_prepdata`, cleans up the data (removing the non-smoothed data folder) and unzipping the rest
  - `crc_qMRIage_02_zscoring`, z-scoring all the data, this performed within voxel across subjects, per tissue-weighted smoothed images (2) and maps (4), i.e. one voxel from a single map smoothed for one tissue, across all the subjects.
  - `crc_qMRIage_03_uSPM`, creating the univariate GLMs on the z-scored maps. This is performed per tissue-weighted smoothed images (2) and maps (4). The SPM analysis are placed in 8 (2x4) different derivatives folders.
  - `crc_qMRIage_04_mSPM`, performing the multivariate SPM, per tissue-weighted smoothed images (2), relying on the previously built univariate SPMs (4). The 2 MSPM analysis are placed in different derivatives folders.

### Limitations 

There remain a few [open issues](https://github.com/LREN-CHUV/MSPM/issues) with MSPM code. Most of these should not be too difficult to fix... except for [issue nr 4](https://github.com/LREN-CHUV/MSPM/issues/4) about the definition of the contrasts (which **must** be entered manually through a pop-up GUI :astonished:).

The main problem with MSPM code, as it stands now, is that **one cannot fully automatize the MSPM analysis**! Indeed, when trying to run the `Analysis` module, only the `MSPM.mat` file is selected and an external GUI window opens to defined the contrasts of interests: one for the experimental design (e.g. group comparison or regression) and one for the modalities (e.g. effect across all modalities). This poorly fitted GUI, then opens SPM's standard contrast definition GUI window.

The 2 constrasts :

- `c` for the experimental desing should be set to `[0 1 0 0 0]`, to test for the age regressor;
- `L` for the modalities should be set to `eye(4)`, to test for all modalities considered together.

We will try to solve that but it is not straightforward and will take time, which we do not have...
