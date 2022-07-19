############################################################################
#"Creating Codelists for wp2 EHDEN cancers using CodelistGenerator"
############################################################################

# install codelist generator from darwin (only once) --------------------------
# install.packages("remotes")
#remotes::install_github("darwin-eu/CodelistGenerator")


#install packages -----------------------------------
library(here)
library(readr)
library(DBI)
library(RSQLite)
library(here)
library(dplyr)
library(stringr)
library(DT)
library(kableExtra)
library(CodelistGenerator)
library(Eunomia)
library(tictoc)

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
#NOTE we are only looking for codes in the condition domain initially

# create codelist for LIVER CANCER ---------------------------------------
# criteria:
# Malignant cancer only
# No codes for benign/ in situ 
# No codes for secondary cancer
Sys.time()

tic()
liver_codes1<-getCandidateCodes(keywords=c( "malignant neoplasm of liver") ,
                                  domains="Condition",
                                searchSynonyms = TRUE,
                                  fuzzyMatch = FALSE,
                                  exclude = c("risk",
                                              "fear",
                                              "benign", 
                                              "screening",
                                              "suspected",
                                              "secondary",
                                              "in situ",
                                              "uterine body"),
                                  includeDescendants = TRUE,
                                  includeAncestor = FALSE,
                                  db=db,
                                vocabularyDatabaseSchema =  vocabulary_database_schema)

toc()

write.csv(liver_codes1, "C:/Users/dnewby/OneDrive - Nexus365/Documents/GitHub/CodelistGenerator_cancers/Codelists/liver_cancer_110722.csv")

#check candidate codes
readMappings<-showMappings(candidateCodelist=liver_codes1,
                          sourceVocabularies="Read",
                          db=db,
                          vocabularyDatabaseSchema =  vocabulary_database_schema)





# create codelist for STOMACH CANCER ---------------------------------------
#https://training.seer.cancer.gov/ugi/abstract-code-stage/codes.html
# criteria:
# Malignant cancer only
# No codes for benign/ in situ 
# No codes for secondary cancer
Sys.time()
tic()
stomach_codes2<-getCandidateCodes(keywords=c("malignant tumor of stomach") ,
                                    domains="Condition",
                                    searchSynonyms = TRUE,
                                    fuzzyMatch = FALSE,
                                    exclude = c("risk",
                                                "fear",
                                                "benign", 
                                                "screening",
                                                "suspected",
                                                "secondary",
                                                "in situ"),
                                    includeDescendants = TRUE,
                                    includeAncestor = FALSE,
                                    db=db,
                                    vocabularyDatabaseSchema =  vocabulary_database_schema)
toc()




write.csv(stomach_codes2, "C:/Users/dnewby/OneDrive - Nexus365/Documents/GitHub/CodelistGenerator_cancers/Codelists/stomach_cancer_110722.csv")


# create codelist for HEAD/NECK CANCER ---------------------------------------
#https://training.seer.cancer.gov/head-neck/abstract-code-stage/codes.html
# criteria:
# Malignant cancer only
# No codes for benign/ in situ 
# No codes for secondary cancer
# No codes for cancer in brain or eye as not considered head/neck cancer
# No codes related to thyroid cancer as not considered head/neck cancer
# No codes related to skin of head/scalp/neck and neck as this is skin cancer

Sys.time()
tic()
headneck_codes1<-getCandidateCodes(keywords=c(
  "malignant tumor of lip" ,
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
   "malignant tumor of larynx" 
  #"malignant tumor of neck" ,
  #"malignant tumor of head and neck" ,
  #"malignant tumor of thyroid gland" 
                            ) ,
  domains="Condition",
  searchSynonyms = TRUE,
  fuzzyMatch = FALSE,
  exclude = c("risk",
              "fear",
              "benign", 
              "screening",
              "suspected",
              "secondary",
              "in situ" ,
              "brain",
              "eye" ,
              "pregnancy" ,
              "childbirth",
              "baby" ,
              "hypothyroidism",
              "hypoparathyroidism",
              "hyperparathyroidism" ,
              "skin"
              ),
  includeDescendants = TRUE,
  includeAncestor = FALSE,
  db=db,
  vocabularyDatabaseSchema =  vocabulary_database_schema)

toc()

#927 before now 512 remove thyroid now 454

write.csv(headneck_codes1, "C:/Users/dnewby/OneDrive - Nexus365/Documents/GitHub/CodelistGenerator_cancers/Codelists/headneck_cancer_110722.csv")

## testing something out

# two concepts
# 1 primary malignant neoplasm of lip
# 2 malignant neoplasm of lip


Sys.time()
tic()
headneck_codes3<-getCandidateCodes(keywords=c(
  "malignant tumor of lip" 
) ,
domains="Condition",
searchSynonyms = TRUE,
fuzzyMatch = FALSE,
exclude = c("risk",
            "fear",
            "benign", 
            "screening",
            "suspected",
            "secondary",
            "in situ" ,
            "brain",
            "eye" ,
            "pregnancy" ,
            "childbirth",
            "baby" ,
            "hypothyroidism",
            "hypoparathyroidism",
            "hyperparathyroidism" ,
            "skin"
),
includeDescendants = TRUE,
includeAncestor = FALSE,
db=db,
vocabularyDatabaseSchema =  vocabulary_database_schema)

toc()


Sys.time()
tic()
headneck_codes3<-getCandidateCodes(keywords=c(
  "malignant tumor of lip" 
) ,
domains="Condition",
searchSynonyms = TRUE,
fuzzyMatch = FALSE,
exclude = c("risk",
            "fear",
            "benign", 
            "screening",
            "suspected",
            "secondary",
            "in situ" ,
            "brain",
            "eye" ,
            "pregnancy" ,
            "childbirth",
            "baby" ,
            "hypothyroidism",
            "hypoparathyroidism",
            "hyperparathyroidism" ,
            "skin"
),
includeDescendants = TRUE,
includeAncestor = FALSE,
db=db,
vocabularyDatabaseSchema =  vocabulary_database_schema)

toc()





Sys.time()
tic()
headneck_codes4<-getCandidateCodes(keywords=c(
  "Primary malignant neoplasm of lip" 
) ,
domains="Condition",
searchSynonyms = TRUE,
fuzzyMatch = FALSE,
exclude = c("risk",
            "fear",
            "benign", 
            "screening",
            "suspected",
            "secondary",
            "in situ" ,
            "brain",
            "eye" ,
            "pregnancy" ,
            "childbirth",
            "baby" ,
            "hypothyroidism",
            "hypoparathyroidism",
            "hyperparathyroidism" ,
            "skin"
),
includeDescendants = TRUE,
includeAncestor = FALSE,
db=db,
vocabularyDatabaseSchema =  vocabulary_database_schema)

toc()

