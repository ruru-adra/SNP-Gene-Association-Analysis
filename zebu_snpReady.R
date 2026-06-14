options(rgl.useNULL=TRUE)
library(rgl)
library(Matrix)
library(matrixcalc)
library(stringr)
library(impute)
library(snpReady)

#read table empty as "NA"
t_geno<- read.table("../cattle_fluidigm/rslt_july/t_geno.txt", header=T, sep="\t", na.strings = c("", "NA", "--", "NN"))


# Assign the first row as column names #this is wide format
colnames(t_geno) <- as.character(unlist(t_geno[1, ]))  
t_geno <- t_geno[-1, ]  # Remove the first row

# Reset row numbers
rownames(t_geno) <- NULL


l_geno<- geno %>% #this is long format
  pivot_longer(cols = S01:S95,
               names_to = "sID", 
               values_to = "allele")

l_geno<- select(l_geno, sID, snpID, allele)



geno <- l_geno %>%
  separate(allele, into = c("a1", "a2"), sep = 1)


## input in long format
zebu <- raw.data(data = as.matrix(geno), frame = "long", 
                         base = TRUE, 
                         sweep.sample = 0.5, call.rate = 0, maf = 0.01, 
                         imput = TRUE, imput.type = "wright", outfile = "012")

clean_zebu<- zebu$M.clean

#get a report
zebu$report

#extract snp
snp_maf001<- as.data.frame(colnames(clean_zebu))
colnames(snp_maf001)[1]="snpID"


pop.gen.zebu<- popgen(M=clean_zebu)
head(pop.gen.zebu$whole$Markers)
head(pop.gen.zebu$whole$Population)
head(pop.gen.zebu$whole$Variability)
head(pop.gen.zebu$whole$Genotypes)

markers<- as.data.frame(pop.gen.zebu$whole$Markers)
pop<- as.data.frame(pop.gen.zebu$whole$Population)
var<- as.data.frame(pop.gen.zebu$whole$Variability)
genotype<- as.data.frame(pop.gen.zebu$whole$Genotypes)

#calculate data by sub group
sinfo<- read.table("sinfo_amylose.txt", header=T, sep="\t")
sinfo<- as.matrix(sinfo)
popgen_sbg_zebu <- popgen(M = clean_zebu, subgroups = sinfo)
head(popgen_sbg_zebu$bygroup$Nellore$Population)
head(popgen_sbg_zebu$bygroup$KK$Population)
head(popgen_sbg_zebu$bygroup$KKE$Population)


nellore<- as.data.frame(popgen_sbg_zebu$bygroup$Nellore$Population)
kk<- as.data.frame(popgen_sbg_zebu$bygroup$KK$Population)
kke<- as.data.frame(popgen_sbg_zebu$bygroup$KKE$Population)





