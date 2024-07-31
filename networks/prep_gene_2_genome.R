# Rename all genes as PHAGE_ID_GENENOM
setwd("/Users/dinosbardellati/Desktop/PhD_stuff/projects/Bee_phage/5kb/reviewer_comments/annotations/faa_files")
filelist=list.files()
for(i in 1:length(filelist))
{
  faaseq=readLines(filelist[i])				#reads in file i    
  genacc=strsplit(filelist[i],'.faa')[[1]]		#extracts the genome accession from the filename
  genepos=grep(">",faaseq)					#finds the start position of each gene in the FAA file
  faaseq[genepos]=paste(">",genacc,'_',c(1:length(genepos)),sep='')	#relabels each gene identifier in the format ">accession_n" where n stands in for the order of the genes.
  write.table(faaseq,paste("../faa_relab/",filelist[i],sep=''),row.names=F,col.names=F,quote=F)	#writes file using original name to FAArelab directory
} 

# Concatonate all phage seqs into one file
setwd("/Users/dinosbardellati/Desktop/PhD_stuff/projects/Bee_phage/5kb/reviewer_comments/annotations/faa_relab")
filelist=list.files()
allseq=character()
for(i in 1:length(filelist))
{
  allseq=c(allseq,readLines(filelist[i]))
}
write.table(allseq,'../allseqs.faa',row.names=F,col.names=F,quote=F)	

# Build gene2genome file
setwd("/Users/dinosbardellati/Desktop/PhD_stuff/projects/Bee_phage/5kb/reviewer_comments/annotations/faa_files")
library(dplyr)
filelist=list.files()
x = c()
y = c()
for(i in 1:length(filelist))
{
  faaseq=readLines(filelist[i])				#reads in file i    
  genacc=strsplit(filelist[i],'.faa')[[1]]		#extracts the genome accession from the filename
  genepos=grep(">",faaseq)					#finds the start position of each gene in the FAA file
  annot = str_split_fixed(faaseq[genepos], ' ', 2)[,2]
  faaseq[genepos]=paste(">",genacc,'_',c(1:length(genepos)),sep='')	#relabels each gene identifier in the format ">accession_n" where n stands in for the order of the genes.
  x = data.frame("protein_id" = gsub(">", "", faaseq[genepos]), 
                 "contig_id" = genacc, 
                 "keywords" = gsub(" ", "_", annot))
  y = rbind(y,x)
} 

write.table(x = y, file = "../gene2genome.tsv", 
            quote = F, row.names = F, sep = "\t")
