# Wavelet packet analysis of blood protein spectra for diagnosing ovarian cancer

## Load data

- Download the datasets from the "Ovarian Cancer Studies" section on this page: https://home.ccr.cancer.gov/ncifdaproteomics/ppatterns.asp
- Create a directory called `DATA` in the `MATLAB` directory of this repository
- Extract the ZIP files into folders in the `DATA` directory, e.g. `MATLAB/DATA/OvarianDataset4-3-02`
- Create the MATLAB versions of the datasets by opening and running the `import_data.m` script through at least the `Save data` section

## Examine wavelet spectra for DWT and Wang et al. methods

- Open the script `spectral_slopes_Wang/confirm_slopes_by_regions.m`.
- In the Options block, select the method (DWT or Wang et al.).
- Run the script, which will save one `.png` with all observations per region
- To use your own chosen levels: update the vectors in the first code block of `spectral_slopes_Wang/ovarian_slopes_chosen_levels.m`

## Generate features with DWT or Wang et al. methods

- Open the script `spectral_slopes_Wang/ovarian_slopes_chosen_levels.m`
- Choose the dataset and the method in the Options code block (
`raw_data`, `dataname`, `wav_method`)
- Run the "Generate features" code block
- Save the results with the "save slope_cands" block
- To save as CSV files, use the `spectral_slopes_Wang/chosenlevels_loadandsave.m` script

## Generate features with Jones et al. method

- Open the script `best_basis_Jones\Jones_data_processing.m`
- Select the dataset using `dataname` in the Options code block
- Run through the Generate features block to calculate features for the dataset
- Run the subsequent two code blocks to save the features as a CSV file
- the remaining blocks in the script are optional
