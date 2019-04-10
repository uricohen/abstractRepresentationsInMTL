This repository contains code and data accompanying the following paper: 

### Representation of Abstract Semantic Knowledge in Populations of Human Single Neurons in the Medial Temporal Lobe

Thomas P. Reber<sup>1,2*</sup>, Marcel Bausch<sup>1</sup>, Sina Mackay<sup>1</sup>, Jan Boström<sup>3</sup>, Christian E. Elger<sup>1</sup>, Florian Mormann<sup>1</sup>

<sup>1</sup> Department of Epileptology, University of Bonn Medical Centre, Bonn, Germany

<sup>2</sup> Faculty of Psychology, Swiss Distance Learning University, Brig, Switzerland

<sup>3</sup> Department of Neurosurgery, University of Bonn Medical Centre, Bonn, Germany


If you have any questions, please contact <treber@uni-bonn.de>. All data files and code are in Matlab format.

### Code
We used Matlab R2017 with the statistics and machine learning toolbox, the signal processing toolbox, and the image processing toolbox. To reproduce the figures in the manuscript, start matlab, navigate to the repository-folder and add it to the matlabpath:

```
cd('/Path/to/this/repo');
addpath(pwd);
```

Then call one of these functions: 

- `figure1.m`: single unit examples
- `figure2.m`: Unit descriptives, Selecitivity and Response-Probabilities
- `figure3orS2.m`: RSAs. To produce Figure S2, set the variable `whichUnits` on line 63 to `'firstSessionPerPatient'`.
- `figure4.m`: Decoding results. reads output from `ospr_classify.m` (see below).
- `figureS1.m`: Stimuli Overview
- `figureS3.m`: RSA on image similarities. Uses data generated by `calcualte_image_similarities.m`. 
- `figureS4.m`: Just plot the dendrograms of figure3, but larger
- `figureS5orS6.m`: classification analyses, separate for subjects - plots results generated by `ospr_classify_per_subject.m`

Further .m files in this repository are included because they are called by the above scripts at some point or another.

### Data
#### `zvals.mat`
Containes z-scored firing rates for each stimulus-unit combination, and some lookup variables. Please refer to the paper for the methods used to obtain these z-scores. 

- `zvals`: a nunits X nstimuli matrix of zscores
- `cluster_lookup`: a table with nunits rows and 8 columns with infos on the units (such as anatomical location, SU vs. MU, etc) rows in this table correspond to rows in zvals variable above
- `stim_lookup`: a cell of size nstimuli, i.e., 100 of names of the presented images (e.g., wild\_animals\_6). Entries correspond to the columns in zvals variable above.
- `cat_lookup`: a cell of size nstimuli = 100 of names of the category the images belong to. Entries correspond to the columns in zvals variable above.

#### `zvals_trial.mat`
Containes z-scored firing rates for each trial-unit combination, and some lookup variables. Please refer to the paper for the methods used to obtain these z-scores. 

- `zvals`: a nunits X nstrials matrix of zscores
- `cluster_lookup`: a table with nunits rows and 8 columns with infos on the units (such as anatomical location, SU vs. MU, etc) rows in this table correspond to rows in zvals variable above
- `stim_lookup`: a cell of size ntrials, i.e., 1000 of names of the presented images (e.g., wild\_animals\_6) entries correspond to the columns in zvals variable above
- `cat_lookup`: a cell of size ntrials, i.e., 1000 of names of the category the images belong to entries correspond to the columns in zvals variable above

#### `category_responses.mat`
Containes whether a stimulus elicited a neuronal response for each unit-stimulus combination. 

- `consider_rs`: a nunits X nstimuli matrix of booleans that have the value 'true' if a stimulus elicits a response according to the criterion mentionen in the paper
- `pvals_rs`: a nunits X nstimuli matrix of p-values resulting from the binwise signed rank test mention in the paper
- `pcrit_rs`: the alpha-level at which the binwise ranksum test is considered 'significant'
- `cluster_lookup`: a table with nunits rows and 8 columns with infos on the units (such as anatomical location, SU vs. MU, etc) rows in this table correspond to rows in zvals variable above
- `stim_lookup`: a cell of size nstimuli, i.e., 100 of names of the presented images (e.g., wild\_animals\_6) entries correspond to the columns in the `consider_rs` and `pvals_rs` variables above
- `cat_lookup`: a cell of size nstimuli, i.el, 100 of names of the category the images belong to entries correspond to the columns in `consider_rs` and `pvals_rs` variables above

#### `classification_results_*.mat`
.mat files starting `classification_results` are output produced by the script `ospr_classify.m` mentioned above. For details on the coding anlyses, please refer to the method section of the paper or inspect `ospr_classify.m` and `ospr_doclassperm.m`.


#### `regions.mat`
Contains a struct with names of anatomical Regions, i.e., AM, HC, EC, PHC, and the names of electrode localizations (sites) assign to anatomical regions e.g. 

```
regions(1).name = 'AM' % Amygdala
regions(1).sites = {'RA', 'LA'}; % for wires in left and right amygdala
```

Note that data in the .mat files also includes units that are not reported int the paper as the units were recorded in anatomical regions outside the MTL. Such units are identified by:

```
idx = strcmp(cluster_lookup.regionname == 'other');
```
#### `&ast;segmentedSpikes.mat`
Contains structs `cherries` with the field `cherries.trial`. Ich entry there, contains spike times relative to stimulus onset. The strcut `conditions` contains lookup variables to identify trials of interest. Please refer to `figure1.m` for examples of how these data can be analyzed.

#### `&ast;timesCSC&ast;.mat`
Contains non-segmented data on sorted spikes in the format of [https://github.com/csn-le/wave_clus](wave_clus).
