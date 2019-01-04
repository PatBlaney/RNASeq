# Output visualizations of the differential expression analysis data
# that was produced by DESeq2
# Load the libraries necessary
library("DESeq2")
library("RColorBrewer")
library("pheatmap")
library("limma")

# Load in the summerized differential expression analysis data
load("summarizedDeResults.RData")

# Plot the dispersion estimates of the data
plotDispEsts(ddsAll)

# Extract subsets of genes that are up- and down-regulated using a 
# p-value cutoff of 0.05
logThreshold <- 0
alpha <- 0.05
upVibrio <- subset(dfBothAnnot, (padj.Vibrio < alpha) & (log2FoldChange.Vibrio > logThreshold))
downVibrio <- subset(dfBothAnnot, (padj.Vibrio < alpha) & (log2FoldChange.Vibrio < logThreshold))
upMenthol <- subset(dfBothAnnot, (padj.Menthol < alpha) & (log2FoldChange.Menthol > logThreshold))
downMenthol <- subset(dfBothAnnot, (padj.Menthol < alpha) & (log2FoldChange.Menthol < logThreshold))
listAll <- list(UpVibrio = row.names(upVibrio), DownVibrio = row.names(downVibrio),
                UpMenthol = row.names(upMenthol), DownMenthol = row.names(downMenthol))

# Create a volcano plot of the Vibrio and Menthol log2 fold change as a function
# of mean normalized counts
plotMA(resVibrio, ylim = c(-4,4), alpha = 0.05)
plotMA(resMenthol, ylim = c(-4,4), alpha = 0.05)

# Execute rlog transformation on counts to construct sample distance matrix
rldAll <- rlog(ddsAll, blind = FALSE)
sampleDists <- dist(t(assay(rldAll)))
sampleDistMatrix <- as.matrix(sampleDists)
rownames(sampleDistMatrix) <- paste(rldAll$Vibrio, rldAll$Menthol, sep = "-")
colnames(sampleDistMatrix) <- NULL

# Cluster samples based on overall gene expression patterns using a heat map
colors <- colorRampPalette(rev(brewer.pal(9, "Blues")))(255)
pheatmap(sampleDistMatrix,
         clustering_distance_rows = sampleDists,
         clustering_distance_cols = sampleDists,
         col = colors)

# Execute principal component analysis to determine percentage of variation between
# design groups
plotPCA(rldAll, intgroup = c("Vibrio", "Menthol"))

# Create a venn diagram that has an overlap between Vibrio Up, Vibrio Down, Menthol Up,
# and Menthol Down
upVibrio$count <- rep(1, nrow(upVibrio))
downVibrio$count <- rep(1, nrow(downVibrio))
upMenthol$count <- rep(1, nrow(upMenthol))
downMenthol$count <- rep(1, nrow(downMenthol))
vibrioCount <- merge(upVibrio, downVibrio, by = 0, all = TRUE, suffixes = c("Up", "Down"))
mentholCount <- merge(upMenthol, downMenthol, by = 0, all = TRUE, suffixes = c("Up", "Down"))
rownames(vibrioCount) <- vibrioCount$Row.names
rownames(mentholCount) <- mentholCount$Row.names
vibrioCount <- subset(vibrioCount, select = -c(Row.names))
mentholCount <- subset(mentholCount, select = -c(Row.names))
bothCount <- merge(vibrioCount, mentholCount, by = 0, all = TRUE, suffixes = c("Vibrio", "Menthol"))
rownames(bothCount) <- bothCount$Row.names
bothCount <- subset(bothCount, select = -c(Row.names))
bothCount <- subset(bothCount, select = c(countUpVibrio, countDownVibrio, countUpMenthol, countDownMenthol))

# Convert all NAs in the bothCount subset to zeros 
bothCount$countUpVibrio[is.na(bothCount$countUpVibrio)] <- 0
bothCount$countDownVibrio[is.na(bothCount$countDownVibrio)] <- 0
bothCount$countUpMenthol[is.na(bothCount$countUpMenthol)] <- 0
bothCount$countDownMenthol[is.na(bothCount$countDownMenthol)] <- 0

# Produce the venn diagram
vennDiagram(vennCounts(bothCount),
            names = c("UpVibrio", "DownVibrio", "UpMenthol", "DownMenthol"),
            circle.col = c("red", "green", "blue", "yellow"))