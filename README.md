# qMRI MSPM Age Fx
Overall the code in this repo was developed by Soodeh Moallemian and Christophe Phillips, to re-analyze "quantitative MRI" data from Martina F. Callaghan.

## Code description

The code contains a series of scripts to generate the results, including figures, described in our pre-print paper (S. Moallemian et al., medRxiv, 2023) from the (now) open dataset of preprocessed quantitative MRI data (M. F. Callaghan & C. Phillips, OpenNEURO, 2025).

A few tools are required to process the data mainly [SPM](https://github.com/spm) and [MSPM](https://github.com/LREN-CHUV/MSPM).

## Data description

The preprocessed data are available on [OpenNEURO](https://openneuro.org/datasets/ds005851). The part we are interested in here are available in the

- `VBQ_TWsmooth` derivatives folder as it includes 8 image per participants, i.e. the 4 quantitative maps after tissue-weighted smoothing for the GM and WM separately;
-  the main `derivatives` folder as it contains group level images, i.e. the GM and WM masks, to be used for tissue specific statistical analysis, and mean MTsat maps, to be used for results display for example.

Overall the dataset includes spatially preprocessed quantitative MRIs from 138 healthy subjects:

- age range 19-75 years (mean 46.6, s.d. 21)
- data acquired on 2 different 3T whole body MR systems (69 participants per scanner)

The age, sex, total intra-cranial volume, and scanner used, for each participants, were collected in a table to be used for the statistical modelling.

## References

- S. Moallemian, C. Bastin, M. F. Callaghan, C. Phillips, *Multivariate Age-related Analysis of Variance in quantitative MRI maps: Widespread age-related differences revisited*, medRxiv, 2023. 
  Available on [ULiège ORBI](https://hdl.handle.net/2268/311792) and [medRxiv](https://doi.org/10.1101/2023.10.19.23297253).

- S. Moallemian, C. Bastin, M. F. Callaghan, C. Phillips, *Multivariate SPM analysis of quantitative MRIs, widespread age-related differences revisited*. OHBM abstract and poster, 2023.
  Available on [ULiège ORBI](https://hdl.handle.net/2268/303401).
- M. F. Callaghan & C. Phillips, *Processed MPM qMRI aging data*, OpenNEURO, 2025.
  Available on [OpenNEURO](https://openneuro.org/datasets/ds005851).
- M. F. Callaghan, S. Moallemian & C. Phillips, *Lifespan quantitative MR images from 138 subjects, an open and spatially preprocessed dataset*. OHBM abstract and poster, 2025.
  Available on [ULiège ORBI](https://hdl.handle.net/2268/325811).

## Authors

- [Soodeh Moallemian](https://www.linkedin.com/in/soodeh-moallemian/)
  - GIGA CRC Human Imaging, University of Liège, Belgium;
  - Center for Molecular and Behavioral Neuroscience, Rutgers University, NJ, USA.

- [Christophe Phillips](https://www.uliege.be/cms/c_9054334/fr/repertoire?uid=u016440), GIGA CRC Human Imaging, University of Liège, Belgium.

- [Martina F. Callaghan](https://sites.google.com/view/fil-physics/home), Wellcome Centre for Human Neuroimaging, Institute of Neurology, University College London, UK.

