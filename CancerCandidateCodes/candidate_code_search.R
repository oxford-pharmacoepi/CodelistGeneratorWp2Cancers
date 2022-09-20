# set up renv
renv::activate()
renv::restore()

# packages
library(DBI)
library(arrow)
library(dbplyr)
library(dplyr)
library(openxlsx)
library(here)
library(CodelistGenerator)
library(readr)
library(tictoc)
library(stringr)
library(CohortGenerator)
library(CirceR)
library(tidyverse)
library(readr)


# get the vocabs -----------------------------
# from database using or from athena directly
# this code loads of the CDM vocabularies that will we need from athena (https://athena.ohdsi.org)

vocab.folder<-c("C:/Users/dnewby/OneDrive - Nexus365/Desktop/Athena Vocabs/") # path to directory of unzipped files

concept<-read_delim(paste0(vocab.folder,"/CONCEPT.csv"),
                    "\t", escape_double = FALSE, trim_ws = TRUE)
concept_relationship<-read_delim(paste0(vocab.folder,"/CONCEPT_RELATIONSHIP.csv"),
                                 "\t", escape_double = FALSE, trim_ws = TRUE) 
concept_ancestor<-read_delim(paste0(vocab.folder,"/CONCEPT_ANCESTOR.csv"),
                             "\t", escape_double = FALSE, trim_ws = TRUE)
concept_synonym<-read_delim(paste0(vocab.folder,"/CONCEPT_SYNONYM.csv"),
                            "\t", escape_double = FALSE, trim_ws = TRUE)

db <- dbConnect(RSQLite::SQLite(), ":memory:")
dbWriteTable(db, "concept", concept, overwrite=TRUE)
dbWriteTable(db, "concept_relationship", concept_relationship, overwrite=TRUE)
dbWriteTable(db, "concept_ancestor", concept_ancestor, overwrite=TRUE)
dbWriteTable(db, "concept_synonym", concept_synonym, overwrite=TRUE)
rm(concept,concept_relationship, concept_ancestor, concept_synonym)
vocabulary_database_schema<-"main"

# if you have access to a database for 

# example with postgres database connection details
# server_dbi<-Sys.getenv("server")
# user<-Sys.getenv("user")
# password<- Sys.getenv("password")
# port<-Sys.getenv("port")
# host<-Sys.getenv("host")
# 
# db <- DBI::dbConnect(RPostgres::Postgres(),
#                      dbname = server_dbi,
#                      port = port,
#                      host = host,
#                      user = user,
#                      password = password)

# The structure of each of these tables is described in detail at: https://ohdsi.github.io/CommonDataModel/cdm53.html#Vocabulary_Tables 
#NOTE we are only looking for codes in the condition domain

# local vocab cdm
# (having previously run downloadVocab )
# arrowDirectory <- Sys.getenv("VocabArrowPath")
# 
# # check version
# # "v5.0 22-JUN-22"
# arrow::read_parquet(paste0(arrowDirectory,
#                        "/vocabulary.parquet"),
#                                    as_data_frame = FALSE) %>%
#     dplyr::rename_with(tolower) %>%
#     dplyr::filter(.data$vocabulary_id == "None") %>%
#     dplyr::select("vocabulary_version") %>%
#     dplyr::collect() %>%
#     dplyr::pull()
# 
# # check what vocabs we have
# arrow::read_parquet(paste0(arrowDirectory,
#                        "/vocabulary.parquet"),
#                                    as_data_frame = FALSE)  %>%
#     dplyr::rename_with(tolower) %>%
#     dplyr::select("vocabulary_id") %>%
#     dplyr::collect() %>%
#     dplyr::distinct() %>% 
#     dplyr::pull()


# search strategy for conditions
standardConceptConditions <-c("Standard", "Classification")
searchViaSynonymsConditions <- TRUE
searchInSynonymsConditions <- FALSE
searchNonStandardConditions <- TRUE
includeDescendantsConditions <- TRUE
includeAncestorConditions <- FALSE


# create codelist for LIVER CANCER ---------------------------------------
# criteria:
# Malignant cancer only
# No codes for benign/ in situ, lymphoma, melanoma, carcnoids (neuroendocrine)
# No codes for secondary cancer

Sys.time()

tic()
liver_codes1<-getCandidateCodes(keywords=c( "malignant neoplasm of liver") ,
                                domains="Condition",
                                exclude = c("risk",
                                            "fear",
                                            "benign", 
                                            "screening",
                                            "suspected",
                                            "secondary",
                                            "in situ",
                                            "uterine body",
                                            "neuroendocrine",
                                            "melanoma",
                                            "lymphoma",
                                            "carcinoid" ),
                                standardConcept = standardConceptConditions,
                                searchInSynonyms = searchInSynonymsConditions,
                                searchViaSynonyms = searchViaSynonymsConditions,
                                searchNonStandard = searchNonStandardConditions,
                                includeDescendants = includeDescendantsConditions,
                                includeAncestor = includeAncestorConditions,
                                db=db,
                                vocabularyDatabaseSchema =  vocabulary_database_schema)

toc()



# create codelist for STOMACH CANCER ---------------------------------------
# criteria:
# Malignant cancer only
# No codes for benign/ in situ, lymphoma, melanoma, carcnoids (neuroendocrine)
# No codes for secondary cancer

Sys.time()

tic()
stomach_codes1<-getCandidateCodes(keywords=c( "malignant tumor of stomach") ,
                                domains="Condition",
                                exclude = c("risk",
                                            "fear",
                                            "benign", 
                                            "screening",
                                            "suspected",
                                            "secondary",
                                            "in situ",
                                            "neuroendocrine",
                                            "melanoma",
                                            "lymphoma",
                                            "carcinoid"
                                            ),
                                standardConcept = standardConceptConditions,
                                searchInSynonyms = searchInSynonymsConditions,
                                searchViaSynonyms = searchViaSynonymsConditions,
                                searchNonStandard = searchNonStandardConditions,
                                includeDescendants = includeDescendantsConditions,
                                includeAncestor = includeAncestorConditions,
                                db=db,
                                vocabularyDatabaseSchema =  vocabulary_database_schema)

toc()



# create codelist for HEAD/NECK CANCER ---------------------------------------
# criteria:
# Malignant cancer only
# No codes for benign/ in situ, lymphoma, melanoma, carcnoids (neuroendocrine)
# No codes for secondary cancer
# No codes for cancer in brain or eye as not considered head/neck cancer
# No codes related to thyroid cancer as not considered head/neck cancer
# No codes related to skin of head/scalp/neck and neck as this is skin cancer

Sys.time()

tic()
headneck_codes1<-getCandidateCodes(keywords=c(   "malignant tumor of lip" ,
                                                "malignant tumor of base of tongue" ,
                                                "malignant tumor of tongue" ,
                                                "malignant tumor of gum" ,
                                                "malignant tumor of floor of mouth" ,
                                                "malignant tumor of palate" ,
                                                "malignant tumor of buccal mucosa" ,
                                                "malignant tumor of oral cavity" ,
                                                "malignant tumor of parotid gland" ,
                                                "malignant tumor of major salivary gland" ,
                                                "malignant tumor of tonsil" ,
                                                "malignant tumor of oropharynx" ,
                                                "malignant tumor of nasopharynx" ,
                                                "malignant tumor of pyriform fossa" ,  
                                                "malignant tumor of hypopharynx" ,
                                                "malignant tumor of postcricoid region" ,
                                                "malignant tumor of pharynx" ,
                                                "malignant tumor of Waldeyer's ring" ,
                                                "malignant neoplasm of lip, oral cavity and pharynx" ,
                                                "malignant tumor of middle ear" ,
                                                "malignant tumor of nasal cavity" ,
                                                "malignant tumor of nasal sinuses" ,
                                                "malignant tumor of larynx" ) ,
                                  domains="Condition",
                                  exclude = c("risk",
                                              "fear",
                                              "benign", 
                                              "screening",
                                              "suspected",
                                              "secondary",
                                              "in situ",
                                              "neuroendocrine",
                                              "melanoma",
                                              "lymphoma",
                                              "carcinoid"
                                  ),
                                  standardConcept = standardConceptConditions,
                                  searchInSynonyms = searchInSynonymsConditions,
                                  searchViaSynonyms = searchViaSynonymsConditions,
                                  searchNonStandard = searchNonStandardConditions,
                                  includeDescendants = includeDescendantsConditions,
                                  includeAncestor = includeAncestorConditions,
                                  db=db,
                                  vocabularyDatabaseSchema =  vocabulary_database_schema)

toc()


# create codelist for BREAST/COLORECTAL/LUNG/PROSTATE CANCER ---------------------------------------

# for other cancers we have json files sent from collaborators. 
# The concept sets were exported to ATLAS and converted to csv files

# breast
# colorectal cancer (specific and broad)
# lung
# prostate

# read in csvs for remaining cancers candidate codes
df <- list.files(path = here("candidate_codes_from_collabs"), pattern = "*.csv", full.names=TRUE) %>% 
  map(read_csv)


# df <- list.files(path = here("Github",
#                              "CodelistGeneratorWp2Cancers",
#                              "CancerCandidateCodes",
#                              "candidate_codes_from_collabs"), pattern = "*.csv", full.names=TRUE) %>% 
#   map(read_csv)


#only include snomed codes for review
df[[1]] <- df[[1]] %>%
  filter(Vocabulary == "SNOMED")
df[[2]] <- df[[2]] %>%
  filter(Vocabulary == "SNOMED")
df[[3]] <- df[[3]] %>%
  filter(Vocabulary == "SNOMED")
df[[4]] <- df[[4]] %>%
  filter(Vocabulary == "SNOMED")
df[[5]] <- df[[5]] %>%
  filter(Vocabulary == "SNOMED")


# save to excel
candidateCodelists <- list("liver_cancer_codes" = liver_codes1, 
                           "stomach_cancer_codes" = stomach_codes1,
                           "headneck_cancer_codes" = headneck_codes1, 
                           "breast_cancer_codes" =  df[[1]],
                           "colorectal_cancer_codes" = df[[2]], 
                           "colorectal_cancer_codes_BROAD" = df[[3]], 
                           "lung_cancer_codes" =  df[[4]],
                           "prostate_cancer_codes" = df[[5]])
write.xlsx(candidateCodelists, file = "cancer_candidate_codes.xlsx")
