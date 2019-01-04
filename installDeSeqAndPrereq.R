# Install the prerequisite packages needed to run DESeq and to output
# visualizations of the results.

# Set the timezone that will be used when running DESeq
Sys.setenv(TZ = "US/Eastern")

# Install knitr package to support R Markdown
install.packages("knitr")

# Install RColorBrewer for palette plot colors
install.packages("RColorBrewer", quiet = TRUE)

# Install devtools to support package instalation from GitHub repository
install.packages("devtools")

# Install pheatmap to produce heatmaps
install.packages("pheatmap", quiet = TRUE)

# Set source to BioConductor where DESeq2 is accesible
source("http://bioconductor.org/biocLite.R")
# Update all Bioconductor packages
biocLite(ask = FALSE)

# Install DESeq2 for differential expression analysis
biocLite("DESeq2", quiet = TRUE, ask = FALSE, suppressUpdates = TRUE)

# Install limma for Ven Diagrams
biocLite("limma", ask = FALSE, suppressUpdates = TRUE)
