# Ovarian Cancer Diagnostics using Wavelet Packet Scaling Descriptors
## Overview
Detecting early-stage ovarian cancer accurately and efficiently is crucial for timely treatment. Various methods for early diagnosis have been explored, including a focus on features derived from protein mass spectra, but these tend to overlook the complex interplay across protein expression levels. We propose an innovative method to automate the search for diagnostic features in these spectra by analyzing their inherent scaling characteristics. We compare two techniques for estimating the self-similarity in a signal using its wavelet packet decomposition. The methods are applied to the mass spectra using a rolling window approach, yielding a collection of self-similarity indexes that capture protein interactions, potentially indicative of ovarian cancer. Then, the most discriminatory scaling descriptors from this collection are selected for use in classification algorithms. To assess their effectiveness for early diagnosis of ovarian cancer, the techniques are applied to two datasets from the American National Cancer Institute. Comparative evaluation against an existing wavelet-based method shows that one wavelet packet-based technique led to improved diagnostic performance for one of the analyzed datasets. This highlights the potential of wavelet packet-based methods to capture novel diagnostic information related to ovarian cancer. This innovative approach offers promise for better early detection and improved patient outcomes in ovarian cancer.

## Dataset
Project data is available at the [American National Cancer Institute Internet Repository](https://home.ccr.cancer.gov/ncifdaproteomics/ppatterns.asp). 
Two datasets namely `Ovarian 4-3-02` (_100 cases and 100 controls_) and `Ovarian 8-7-02` (_162 cases and 91 controls_) were used to validate the proposed modality. Each protein mass spectra consists of the intensities of 15,153 peptides defined by their mass-to-charge ratio (i.e. the ratio of molecular weight to electrical charge) (m/z).



## Matlab code instructions

### Load data
- Download the datasets from the "Ovarian Cancer Studies" section on this page: https://home.ccr.cancer.gov/ncifdaproteomics/ppatterns.asp
- Create a directory called `DATA` in the `MATLAB` directory of this repository
- Extract the ZIP files into folders in the `DATA` directory, e.g. `MATLAB/DATA/OvarianDataset4-3-02`
- Create the MATLAB versions of the datasets by opening and running the `import_data.m` script through at least the `Save data` section

### Examine wavelet spectra for DWT and Wang et al. methods
- Open the script `spectral_slopes_Wang/confirm_slopes_by_regions.m`.
- In the Options block, select the method (DWT or Wang et al.).
- Run the script, which will save one `.png` with all observations per region
- To use your own chosen levels: update the vectors in the first code block of `spectral_slopes_Wang/ovarian_slopes_chosen_levels.m`

### Generate features with DWT or Wang et al. methods
- Open the script `spectral_slopes_Wang/ovarian_slopes_chosen_levels.m`
- Choose the dataset and the method in the Options code block (
`raw_data`, `dataname`, `wav_method`)
- Run the "Generate features" code block
- Save the results with the "save slope_cands" block
- To save as CSV files, use the `spectral_slopes_Wang/chosenlevels_loadandsave.m` script

### Generate features with Jones et al. method
- Open the script `best_basis_Jones\Jones_data_processing.m`
- Select the dataset using `dataname` in the Options code block
- Run through the Generate features block to calculate features for the dataset
- Run the subsequent two code blocks to save the features as a CSV file
- the remaining blocks in the script are optional


**Note:** The original manuscript is available [here](https://).
