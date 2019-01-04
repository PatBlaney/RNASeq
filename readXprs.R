# Set a variable with the path containing the eXpress files
xprsPath <- "xprs_gg"

# Set a variable with eXpress results filename
xprsFile <- "results.xprs"

# Create a vector of eXpress results files
files <- list.files(path = xprsPath, pattern = xprsFile, full.names = T, recursive = TRUE)

# Check the vector contents
files

# Read the first file
firstFile <- read.delim(files[1], sep = "\t")

# Display the top of the first table
head(firstFile)

# Initialize a variable with null to store the merged table
merged <- NULL

# Iterate over the vector of eXpress results files
for (file in files) {
  
  # Read the eXpress results file as tab-delimited
  nextSample <- read.delim(file, sep = "\t")
  
  # Isolate the two columns of interest and reassing the variable to just these values
  nextSample <- nextSample[,c("target_id", "uniq_counts")]
  
  # Rename the target ID and unique count column so it identifies the sample easier
  colnames(nextSample) <- c("transcript", file)
  
  # If this is the first file, copy it to merged to start the merged table
  if(is.null(merged)) {
    merged <- nextSample
  
  # Else, merge the next sample with the main merged table
  }else{
    merged <- merge(merged, nextSample)
  }
}

# View the complete merged table
head(merged)

# Get the column names of the merged table
uglyColumns <- colnames(merged)

# Replace the path in the name of the files with an empty string
lessUglyColumns <- gsub(paste0(xprsPath, '/'), "", uglyColumns)
lessUglyColumns

# Replace the /results.xprs suffix with an empty string
prettyColumns <- gsub(paste0('/', xprsFile), "", lessUglyColumns)
prettyColumns

# Rename the columns in the merged table with the new clean names
colnames(merged) <- prettyColumns

# Write the merged table to a .csv file 
write.csv(merged, file = "mergedCountTable.csv", row.names = FALSE)