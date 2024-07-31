# Basic code for running bacphlip
## We run this on a multifasta file (all phage genomes concatenated into a single file)
bacphlip -i path/to/phage_multi_fasta.fa --multi_fasta
# read in the output
bacphlip_out = read.csv("~/Desktop/PhD_stuff/projects/Bee_phage/5kb/reviewer_comments/Bee_phage_2024/temperate_prediction/phage_multi_fasta.txt", header = T, sep = "\t")
# Filter to those with a phage score >= 0.95
temp_phage = bacphlip_out %>%
  filter(Temperate >= .80)
temp_phage_names = temp_phage$X
write.table(temp_phage_names, "~/Desktop/PhD_stuff/projects/Bee_phage/5kb/reviewer_comments/life_style_pred/temperate_phage_names.csv",
            sep = ",", quote = F, col.names = F, row.names = F)
