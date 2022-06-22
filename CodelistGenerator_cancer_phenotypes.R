############################################################################
#"Creating Codelists for wp2 EHDEN cancers using CodelistGenerator"
############################################################################

# install codelist generator from darwin (only once) --------------------------
# install.packages("remotes")
# remotes::install_github("darwin-eu/CodelistGenerator")

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

liver_codes1<-get_candidate_codes(keywords=c("liver cancer", 
                                              "liver neoplasm",
                                             "hepatic cancer",
                                             "hepatic neoplasm") ,
                                   domains="Condition",
                                   search_synonyms = TRUE,
                                   fuzzy_match = FALSE,
                                   exclude = c("risk",
                                               "fear",
                                               "benign", 
                                               "screening",
                                               "suspected"),
                                   include_descendants = TRUE,
                                   include_ancestor = FALSE,
                                   db=db,
                                   vocabulary_database_schema =  vocabulary_database_schema)





















