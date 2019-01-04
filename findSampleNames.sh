#!/bin/bash
# Initialize a variable to contain the directory of the un-trimmed FASTQ files
fastqPath="/scratch/AiptasiaMiSeq/fastq/"
# Initialize a variable to contain the suffix for the left reads
leftSuffix=".R1.fastq"
# Loop through all the left-read FASTQ files in the $fastqPath
for leftInFile in $fastqPath*$leftSuffix
do
	# Print $leftInFile to see what it contains
	echo $leftInFile
	# Remove the path from the filename and assign the new name to pathRemoved
	pathRemoved="${leftInFile/$fastqPath/}"
	# Print $pathRemoved to see what it contains after removing the path
	echo $pathRemoved
	# Remove the left-read suffix from $pathRemoved and assign new name to suffixRemoved
	suffixRemoved="${pathRemoved/$leftSuffix/}"
	# Print $suffixRemoved to see what it contains after removing the path
	echo $suffixRemoved
done
