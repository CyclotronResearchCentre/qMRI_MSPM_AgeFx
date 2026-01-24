# qMRI MSPM Age Fx
Overall the code in this repo was developed by Soodeh Moallemian and Christophe Phillips, to re-analyze "quantitative MRI" data from Martina F. Callaghan.

The code contains a series of scripts to generate the main results (not yet the figures though), described in our pre-print paper ([S. Moallemian et al., medRxiv, 2023](https://doi.org/10.1101/2023.10.19.23297253) and updated in 2025) from the now open dataset of preprocessed quantitative MRI data ([M. F. Callaghan & C. Phillips, OpenNEURO, 2025](https://openneuro.org/datasets/ds005851)).

---

## Data description

The preprocessed data are available on [OpenNEURO](https://openneuro.org/datasets/ds005851). The part we are interested in here are available in the

- `VBQ_TWsmooth` derivatives folder as it includes 8 image per participants, i.e. the 4 quantitative maps after tissue-weighted smoothing for the GM and WM separately;
-  the main `derivatives` folder as it contains group level images, i.e. the GM and WM masks, to be used for tissue specific statistical analysis, and mean `MTsat` maps, to be used for results display for example.

Overall the dataset includes spatially preprocessed quantitative MRIs from 138 healthy subjects:

- age range 19-75 years (mean 46.6, s.d. 21)
- data acquired on 2 different 3T whole body MR systems (69 participants per scanner)

The age, sex, total intra-cranial volume, and scanner used, for each participants, were collected in a table to be used for the statistical modelling.

---

## Code description

 A few tools are required to process the data mainly [SPM](https://github.com/spm) and [MSPM](https://github.com/LREN-CHUV/MSPM), both available from GitHub. For SPM, one can simply use the latest release, i.e. SPM25. Note though, that as much as SPM is well supported, MSPM is not (so far/yet). Thus everything MSPM related cannot be scripted... 

The description of the code is available in this [HowTo.md](HowTo.md) file. 

---

## References

- S. Moallemian, C. Bastin, M. F. Callaghan, C. Phillips, *Multivariate Age-related Analysis of Variance in quantitative MRI maps: Widespread age-related differences revisited*, medRxiv, 2023. 
  Available on [ULiège ORBI](https://hdl.handle.net/2268/311792) and [medRxiv](https://doi.org/10.1101/2023.10.19.23297253).

- S. Moallemian, C. Bastin, M. F. Callaghan, C. Phillips, *Multivariate SPM analysis of quantitative MRIs, widespread age-related differences revisited*. OHBM abstract and poster, 2023.
  Available on [ULiège ORBI](https://hdl.handle.net/2268/303401).
- M. F. Callaghan & C. Phillips, *Processed MPM qMRI aging data*, OpenNEURO, 2025.
  Available on [OpenNEURO](https://openneuro.org/datasets/ds005851).
- M. F. Callaghan, S. Moallemian & C. Phillips, *Lifespan quantitative MR images from 138 subjects, an open and spatially preprocessed dataset*. OHBM abstract and poster, 2025.
  Available on [ULiège ORBI](https://hdl.handle.net/2268/325811).

---

## Authors 

- [Soodeh Moallemian](https://www.linkedin.com/in/soodeh-moallemian/)
  - GIGA CRC Human Imaging, University of Liège, Belgium;
  - Center for Molecular and Behavioral Neuroscience, Rutgers University, NJ, USA.

- [Christophe Phillips](https://www.uliege.be/cms/c_9054334/fr/repertoire?uid=u016440), GIGA CRC Human Imaging, University of Liège, Belgium.

- [Martina F. Callaghan](https://sites.google.com/view/fil-physics/home), Wellcome Centre for Human Neuroimaging, Institute of Neurology, University College London, UK.

---

## Acknowledgments and Funding

The authors would like to thank E. Anderson, M. Cappelletti, R. Chowdhury, J. Diedirchsen, T.H.B. Fitzgerald, and P. Smittenaar, who took part in data acquisition as part of multiple cognitive neuroimaging studies performed at the WCHN. 

This work was supported by the Walloon Region in the framework of the PIT program PROTHER-WAL under grant agreement No. 7289 and ULiege Research Concerted Action (SLEEPDEM, grant 17/2109). Christophe Phillips are Research Directors at the [F.R.S.-FNRS](https://www.frs-fnrs.be/en/). This research was also funded in part by the Wellcome Trust [203147/Z/16/Z]. For the purpose of Open Access, the author has applied a CC BY public copyright licence to any Author Accepted Manuscript version arising from this submission.
