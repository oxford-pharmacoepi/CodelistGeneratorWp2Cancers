# CancersPhenotyping

## Generation of candidate codes: instructions to run
The relevant code is inside the folder CancerCandidateCodes. First open the RProject called CancerCandidateCodes.Rproj in RStudio You then need to open the code in candidate_code_search.R file, with the output of this being an excel file with the potential codes of interest for review. The first lines will use renv to install the required packages. After this you will need to specify the location of arrow files with the vocabulary tables [here](https://github.com/oxford-pharmacoepi/RareBloodCancersPhenotyping/blob/66e0e6a21d77d43e4cb1b7479256c18e7a037acd/BloodCancerCandidateCodes/candidate_code_search.R#L12) - you can build this by running  [this function from CodelistGenerator](https://darwin-eu.github.io/CodelistGenerator/reference/importVocab.html).

For this project you can either set up the arrow or you can donwload athena vocabs locally and read these in

This project contains phenotyping for the following incident primary maligicant cancers:

- Breast
- Colorectal
- Lung
- Liver
- Stomach
- Head/neck
- Prostate
