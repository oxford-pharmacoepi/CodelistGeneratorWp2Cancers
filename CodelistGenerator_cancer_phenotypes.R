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
Sys.time()

tic()
liver_codes1<-get_candidate_codes(keywords=c( "neoplasm of liver",
                                              "malignant neoplasm of liver") ,
                                  domains="Condition",
                                  search_synonyms = TRUE,
                                  fuzzy_match = FALSE,
                                  exclude = c("risk",
                                              "fear",
                                              "benign", 
                                              "screening",
                                              "suspected",
                                              "secondary",
                                              "in situ"),
                                  include_descendants = TRUE,
                                  include_ancestor = FALSE,
                                  db=db,
                                  vocabulary_database_schema =  vocabulary_database_schema)

toc()

write.csv(liver_codes1, "C:/Users/dnewby/OneDrive - Nexus365/Documents/GitHub/CodelistGenerator_cancers/Codelists/liver_cancer_110722.csv")


# create codelist for STOMACH CANCER ---------------------------------------
#https://training.seer.cancer.gov/ugi/abstract-code-stage/codes.html
Sys.time()
tic()
stomach_codes2<-get_candidate_codes(keywords=c("malignant tumor of stomach",
                                               "neoplasm of stomach") ,
                                    domains="Condition",
                                    search_synonyms = TRUE,
                                    fuzzy_match = FALSE,
                                    exclude = c("risk",
                                                "fear",
                                                "benign", 
                                                "screening",
                                                "suspected",
                                                "secondary",
                                                "in situ"),
                                    include_descendants = TRUE,
                                    include_ancestor = FALSE,
                                    db=db,
                                    vocabulary_database_schema =  vocabulary_database_schema)


toc()




write.csv(stomach_codes2, "C:/Users/dnewby/OneDrive - Nexus365/Documents/GitHub/CodelistGenerator_cancers/Codelists/stomach_cancer_110722.csv")


# create codelist for HEAD/NECK CANCER ---------------------------------------
#https://training.seer.cancer.gov/head-neck/abstract-code-stage/codes.html
Sys.time()
tic()
headneck_codes1<-get_candidate_codes(keywords=c(
  
  "malignant neoplasm of lip, oral cavity and pharynx" ,
  "malignant tumor of lip" ,
  "neoplasm of lip" ,
  "malignant tumor of base of tongue" ,
  "neoplasm of base of tongue" ,
  "malignant tumor of tongue" ,
  "neoplasm of tongue" ,
  "malignant tumor of gum" ,
  "neoplasm of gum" ,
  "malignant tumor of floor of mouth" ,
  "neoplasm of floor of mouth" ,
  "malignant tumor of palate" ,
  "neoplasm of palate" ,
  "nalignant tumor of buccal mucosa" ,
  "malignant tumor of oral cavity" ,
  "tumor of oral cavity",
  "malignant tumor of parotid gland" ,
  "neoplasm of parotid gland" ,
  "malignant tumor of major salivary gland" ,
  "neoplasm of major salivary gland" ,
  "malignant tumor of tonsil" ,
  "neoplasm of tonsil" ,
  "malignant tumor of oropharynx" ,
  "neoplasm of oropharynx" ,
  "malignant tumor of nasopharynx" ,
  "neoplasm of nasopharynx" ,
  "malignant tumor of pyriform fossa" ,
  "neoplasm of pyriform sinus" ,
  "malignant tumor of postcricoid region" ,
  "neoplasm of postcricoid region" ,
  "malignant tumor of pharynx" ,
  "malignant tumor of head and neck" ,
  "malignant tumor of nasal cavity" ,
  "neoplasm of nasal cavity" ,
  "malignant tumor of maxillary sinus" ,
  "malignant tumor of nasal sinuses" ,
  "neoplasm of accessory sinus" ,
  "malignant tumor of larynx" ,
  "malignant tumor of neck" ,
  "malignant tumor of head and neck" ,
  "neoplasm of head and neck" ,
  "malignant tumor of thyroid gland" ,
 "neoplasm of thyroid gland"
  

                            ) ,
domains="Condition",
search_synonyms = TRUE,
fuzzy_match = FALSE,
exclude = c("risk",
            "fear",
            "benign", 
            "screening",
            "suspected",
            "secondary",
            "in situ"),
include_descendants = TRUE,
include_ancestor = FALSE,
db=db,
vocabulary_database_schema =  vocabulary_database_schema)

toc()

write.csv(headneck_codes1, "C:/Users/dnewby/OneDrive - Nexus365/Documents/GitHub/CodelistGenerator_cancers/Codelists/headneck_cancer_110722.csv")


