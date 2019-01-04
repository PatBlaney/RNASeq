# Extract all the immune related genes that were found to be differentially expressed
# First, clear workspace
rm(list = ls())

# Load in the summarized differential expression analysis data
load("summarizedDeResults.RData")

# Read in the file containing all the annotations
spAnnot <- read.delim("proteinGeneGo.txt", sep = "\t", header = FALSE)

# Set the column names to easy identifiers
colnames(spAnnot) <- c("Gene", "Protein", "GeneDesc", "GO")

# Extract just the gene and associated GO terms
goDesc <- subset(spAnnot, select = c(GO, Gene))

# Isolate all the immune related genes and write their annotations to a .csv file
immune <- goDesc[grep("immune", goDesc$GO), ]
immuneGenes <- unique(immune$Gene)
immuneDE <- dfBothAnnot[row.names(dfBothAnnot) %in% immuneGenes, ]
colnames(immuneDE) <- c("lfcM", "pM", "lfcV", "pV", "Desc")
rownames(immuneDE) <- paste(rownames(immuneDE), immuneDE$Desc, sep='-')
immuneDE <- subset(immuneDE, select = c(lfcM, pM, lfcV, pV) )
write.csv(immuneDE, file="ImmuneRelated.csv")