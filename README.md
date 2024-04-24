# MDA5_study
This repo contains all scripts used to generate the data found in the thesis called: Analysis of High Noise Time Series Data of Differential Chromatin Accessibility and Chromatin-Bound Proteins in MDA5-Induced Mouse Embryonic Stem Cells

The folder ATAC contains the scripts used for processing of ATAC-seq data. Inside this folder multiple files and folder can be found:
- Seq2Science: Contains the configuration files used for preprocessing the data.
- downsample.sh: This bash file was used to downsample all BAM files inside a folder.
- atac_seq_analysis.ipynb: This Jupyter notebook contains the R code used to analyze the ATAC-seq data.

The folder ChEP contains the script used to analyse the ChEP-MS data. The file in this folder is the following:
- chep_ms_analysis.Rmd: This R markdown notebook contains the R code used to analyze the ChEP-MS data.

To access the raw data generated in this study, contact L.F.H.Maas@student.vu.nl
