# Run DESeq2 using the merged table of counts and associated annotations
# First, load the DESeq2 library
library("DESeq2")

# Load in the necessary data objects containing counts and annotations
load("clcCountsBlast2GoAnnotations.RData")

# Create a DESeq data set from the raw gene expression counts and the associated
# metadata about the design groups and conditions
ddsAll <- DESeqDataSetFromMatrix(countData = rawCounts,
                                  colData = colData,
                                  design = ~ Menthol + Vibrio)

# Set the control treatment of the design
ddsAll$Menthol <- relevel(ddsAll$Menthol, ref = "NoMenthol")
ddsAll$Vibrio <- relevel(ddsAll$Vibrio, ref = "NoVibrio")

# Prefilter out low counts from the DESeq dataset to reduce memory and boost speed
# Only keep read counts that are >10
nrow(counts(ddsAll))
ddsAll <- ddsAll[rowSums(counts(ddsAll)) > 10, ]
nrow(counts(ddsAll))

# Run DESeq differential expresion analysis using the prefiltered read count dataset
ddsAll <- DESeq(ddsAll)

# Preview the result names from the new dataset
resultsNames(ddsAll)

# Simplify downstream analysis by only extracting results with a p-value <0.05 then 
# save these results as data frames
resVibrio <- results(ddsAll, alpha = 0.05, name = "Vibrio_Vibrio_vs_NoVibrio")
resMenthol <- results(ddsAll, alpha = 0.05, name = "Menthol_Menthol_vs_NoMenthol")
dfVibrio <- as.data.frame(resVibrio)
dfMenthol <- as.data.frame(resMenthol)

# Sanity check of the contents in the new data frames
head(dfVibrio)
head(dfMenthol)

# Isolate the log2 fold change and adjusted p-value columns from results data frames
dfVibrio <- subset(subset(dfVibrio, select = c(log2FoldChange, padj)))
head(dfVibrio)
dfMenthol <- subset(subset(dfMenthol, select = c(log2FoldChange, padj)))
head(dfMenthol)

# Combine the two data frames by merging on the row names
dfBoth <- merge(dfMenthol, dfVibrio, by = 0, suffixes = c(".Menthol", ".Vibrio"))
rownames(dfBoth) <- dfBoth$Row.names
head(dfBoth)

# Remove unnecessary Row.names column
dfBoth <- subset(dfBoth, select = -c(Row.names))
head(dfBoth)

# Merge the gene annotations with the updated results data frame
dfBothAnnot <- merge(dfBoth, geneDesc, by = 0, all.x = TRUE)
rownames(dfBothAnnot) <- dfBothAnnot$Row.names
dfBothAnnot <- subset(dfBothAnnot, select = -c(Row.names))
head(dfBothAnnot, n = 10)

# Save data objects containing results
save(ddsAll, dfBothAnnot, resVibrio, resMenthol, file = "summarizedDeResults.RData")

# Clear workspace
rm(list = ls())