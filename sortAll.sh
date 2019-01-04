#!/bin/sh
# Initialize variables to contain the directory of the .sam files and path to
# Bam directory for output of sorted .bam files
basePath="/home/blaney.p/binf6309-PatrickBlaney/RNA-Seq/"
samPath="Sam/"
bamOutPath="Bam/"
samSuffix=".sam"
# Loop through all .sam files, sort them, and output .bam files in the Bam
# directory
for samFile in $basePath$samPath*$samSuffix
do
	# Remove the base path and suffix from the .sam files
	pathRemoved="${samFile/$basePath$samPath/}"
	sampleName="${pathRemoved/$samSuffix/}"
	samtools sort \
	$basePath$samPath$sampleName$samSuffix \
	-o $basePath$bamOutPath$sampleName.sorted.bam \
	1>$bamOutPath$sampleName.sort.log 2>$bamOutPath$sampleName.sort.err 
done
