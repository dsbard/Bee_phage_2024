# Select bacterial genomes for crispr spacer analysis
bacto_meta = read.csv("/Users/dinosbardellati/Desktop/PhD_stuff/projects/Bee_phage/Bee_bacto_genomes/taxa_meta_table.csv", 
         header = F, col.names = c("accession", "species", "host", "completeness", "contamination", "N50", "Cover"))
# How many obs?
dim(bacto_meta)
# 131044 different accessions

# Clean species name a bit
spec = bacto_meta$species
bacto_meta$species = spec %>% 
  str_remove(pattern = "['']") %>%
  str_remove(pattern = "\\[|\\]" ) %>%
  str_remove(pattern = "uncultured" ) %>%
  trimws() 
# clean cover
bacto_meta$Cover = str_remove(bacto_meta$Cover , pattern = "x")

# add spec name as new col
genus = str_split_fixed(string = bacto_meta$species, pattern = " ", n = 2)[,1]
plyr::count(genus)
bacto_meta$Genus = genus

# We downloaded meta data for both GCA (GenBank) and GCF (RefSeq) accessions for each assembly
# Some accessions are in one and not the other
# Before moving forward, lets remove the redundant ones
bacto_meta$accession_unique = str_split(bacto_meta$accession, 
                                        pattern = "_", 
                                        n = 2, 
                                        simplify = T)[,2]
plyr::count(bacto_meta$accession_unique)
bacto_meta = bacto_meta %>% 
  distinct(accession_unique, .keep_all = T)
bacto_meta = bacto_meta[1:8]
# Filters we will impose:
  # If species is listed as mixed (wtf?)
  # >= 90% completeness -- change to 95%?
  # <= 2% contamination
  # Coverage >= 15x
  # n50 >= 20kb

# If any of Coverage, completeness, or contamination are null, get rid of them
bacto_meta = bacto_meta[!bacto_meta$Cover == "null",]
bacto_meta$Cover = as.numeric(bacto_meta$Cover)
bacto_meta = bacto_meta[!is.na(bacto_meta$Cover),]

bacto_meta = bacto_meta[!bacto_meta$completeness == "null",]
bacto_meta$completeness = as.numeric(bacto_meta$completeness)
bacto_meta = bacto_meta[!is.na(bacto_meta$completeness),]

bacto_meta = bacto_meta[!bacto_meta$contamination == "null",]
bacto_meta$contamination = as.numeric(bacto_meta$contamination)
bacto_meta = bacto_meta[!is.na(bacto_meta$contamination),]

bacto_meta = bacto_meta[!bacto_meta$N50 == "null",]
bacto_meta$N50 = as.numeric(bacto_meta$N50)
bacto_meta = bacto_meta[!is.na(bacto_meta$N50),]

# Unfortunately, being this strict removes a lot of bacteria that could otherwise be included
# For example, these filters remove any Bombella from the analysis
  # Several Bombella assemblies actually meet the criteria, their info is just recorded erronously in NCBI
    # i.e. instead of "completeness" it is entered as "completeness score"
  # Unfortunately, I do not have the time (or willpower) to sift through each and every instance of "null" in this df
# Instead, after applying our filters here, I will hand pick some high quality genomes from each of the groups
# Hopefully this resolces some of the over strictness

bacto_meta_filt = bacto_meta %>%
  filter(!grepl('mixed', species)) %>%
  filter(!grepl("Legionella", species)) %>%
  filter(completeness >= 90) %>%
  filter(contamination <= 2) %>%
  filter(N50 >= 25000) %>%
  filter(Cover >= 30)


dim(bacto_meta_filt)
# Left with 28172 
range(bacto_meta_filt$completeness)
range(bacto_meta_filt$contamination)
range(bacto_meta_filt$N50)
range(bacto_meta_filt$Cover)

# WHats left?
plyr::count(bacto_meta_filt$Genus)
genus_clean = str_split_fixed(string = bacto_meta_filt$species, pattern = " ", n = 2)[,1]
plyr::count(genus_clean)

# Print a list of accessions
# These are the ones we will use moving forward
write.csv(data.frame(bacto_meta_filt$accession, bacto_meta_filt$Genus), 
          "~/Desktop/PhD_stuff/projects/Bee_phage/Bee_bacto_genomes/good_accessions.csv",
          row.names = F, col.names = F, quote = F)


