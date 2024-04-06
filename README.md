<!-- badges: start -->
[![R-CMD-check](https://github.com/gilesjohnr/es.dhaka/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/gilesjohnr/es.dhaka/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

# **es.dhaka**: an R package for processing environmental sampling data

This package provides data and methods for parsing and compiling data sets that measure infectious disease burden using Environmental Sampling (ES) methods. The tools here were developed specifically for ES studies in Dhaka, Bangladesh and are designed to provide data outputs that can be used with the open-source companion package `es` which can be found [HERE](https://gilesjohnr.github.io/es/). An overview of data and methods are outlined below, with more detailed vignettes available [HERE](https://gilesjohnr.github.io/es.dhaka/articles/processing_es_data.html).


## Data

The tools here are intended to do the heavy lifting when combining data from multiple sources such as:

  * Data in .eds and .xls format exported from [Applied Biosystems qPCR Systems](https://www.thermofisher.com/us/en/home/life-science/pcr/real-time-pcr/real-time-pcr-instruments.html?gclid=CjwKCAiAi6uvBhADEiwAWiyRdo3P55Qq1NO8sErSvCmVGT2Cs4-5NCzYcgqYhCC6KemKTn6sw7850BoCqbkQAvD_BwE&ef_id=CjwKCAiAi6uvBhADEiwAWiyRdo3P55Qq1NO8sErSvCmVGT2Cs4-5NCzYcgqYhCC6KemKTn6sw7850BoCqbkQAvD_BwE:G:s&s_kwcid=AL!3652!3!606132911219!p!!g!!taqman%20applied%20biosystems!17574808700!139287686778&cid=gsd_pcr_sbu_r02_co_cp1491_pjt9623_gsd00000_0se_gaw_rs_lgn_&gad_source=1) using [QuantStudio software](https://www.thermofisher.com/us/en/home/global/forms/life-science/quantstudio-6-7-flex-software.html).
  
  * Data in .xlsx format containing measurements from [Aquaread water monitoring instruments](https://www.aquaread.com/)
  
The package also contains several important accessory data sets that are required for building compiled the data or for downstream analyses:
  
  * Standard curve data for all Taqman card designs are stored in the `standard_curves` data object. Standard curves are necessary for estimating the number of gene copies for a target (e.g. viral load), the methods for which can be found in the companion R package `es`.
  
  * The package also contains several data dictionaries referred to as a `key` that cross reference important information about target names, location names, and standard curve data sets.
     - `key_location_names`: These data cross reference the unique (and sometimes duplicated) location names of sampling sites and a set of 'concise' names that clean up characters and allow combination of duplicated locations.
     - `key_target_names`: These data cross reference the unique (and sometimes duplicated) target names across all Taqman cards to concise target names, relevant control samples, and whether to include the target in the compiled data set.
     - `key_standard_curves`: These data cross reference each unique experiment name to the appropriate standard curve data source.
  
## Methods

There are four main reproducible functions that parse raw data and compile the results into a single clean format data set. The functions are `parse_tac_xls` and `compile_tac_data` for TAC data and `parse_aquaprobe_xlsx` and `compile_aquaprobe_data` for the Aquaprobe data. 

  1. Parse card-level TAC data output produced by QuantStudio software and extract its contents into individual .csv files containing raw data. 
  
  2. Compile card-level .csv files into a single data set. When compiling, several QC operations are performed:
  
     a. Excludes sensitive targets based on the `key` data dictionary included in this package.
     
     b. Parse sample IDs into collection dates and an `aquaprobe_id` used to merge with Aquaprobe data.
     
     c. Edit duplicated target names based on the `key` data dictionary. 
     
     d. Adjustments to the Ct values are made using blank samples to control for contamination. Specifically, if the corresponding blank is not "Undetermined" for a pathogen in a particular sample, then that pathogen's Ct value is set to NA for all samples on the same card as the blank and for the following two cards as well.
     
     e. Adjustment to Ct values based on amplification controls. Each pathogen is mapped to its corresponding control (MS2 for RNA targets and PhHV for DNA targets) as defined in the `key` data dictionary. When an amplification control in a sample is positive (Ct < threshold of 40), then all relevant targets in that sample that are "Undetermined" are set to the threshold value (40 in this example).
     
     f. Remaining 'Undetermined' observations are set to NA.
     
  3. Parse Aquaprobe excel files into .csv files with consistent format.
  
  4. Compile raw Aquaprobe .csv files into one data set. During compilation several QC and formatting tasks are performed:
  
     a. Duplicated measurements are consolidated by taking the mean of each variable.
     
     b. Dates are converted to a standard date object.
     
     c. Spatial coordinates in Degree Minute Second (DMS) format are converted to a standard DMS format and converted to Decimal Degrees (DD).
     
     d. Aquaprode coded variable names are translated into more readable variable names based on the variable descriptions at [www.aquaread.com/sensors](https://www.aquaread.com/sensors). 
     
     


## Installation

#### 1) Check dependencies
The data parsing functions in this package depend on Python 3 and Java. To check and install these you can try the following:

Download Python 3 [HERE](https://www.python.org/downloads/) or check current installation with:
```console
user@computer:~$ python3 --version
Python 3.11.5
```


Download Java [HERE](https://www.oracle.com/java/technologies/downloads/) or check current installation with:
```console
user@computer:~$ java --version
java 21.0.2 2024-01-16 LTS
Java(TM) SE Runtime Environment (build 21.0.2+13-LTS-58)
Java HotSpot(TM) 64-Bit Server VM (build 21.0.2+13-LTS-58, mixed mode, sharing)
```


#### 2) Install from Github
Use the `devtools` package to install the development version of `es.dhaka` from the GitHub repository. R version >= 3.5.0 recommended.
```r
install.packages('devtools')
devtools::install_github("gilesjohnr/es.dhaka", dependencies=TRUE)
```


## Troubleshooting
This package is currently in development and maintained by John Giles ([@gilesjohnr](https://github.com/gilesjohnr)). For general questions, contact John Giles (john.giles@gatesfoundation.org) and/or Jillian Gauld (jillian.gauld@gatesfoundation.org). Note that this software is constructed under Copyright 2024 Bill & Melinda Gates Foundation and was developed for specific environmental sampling applications and not intended to generalize perfectly to all settings.


## Funding
This work was developed at the [Institute for Disease Modeling](https://www.idmod.org/) in support of funded research grants made by the [Bill \& Melinda Gates Foundation](https://www.gatesfoundation.org/).
