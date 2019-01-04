#!/bin/sh
# Initiate variables to contain the directory of .bam files to be indexed, the .bam
# suffix  
bamPath="/home/blaney.p/binf6309-PatrickBlaney/RNA-Seq/Bam/"
bamSuffix=".sorted.bam"
# Loop through all .bam files, index them, and output .bai files in the Bam directory
for bamFile in $bamPath*$bamSuffix
do
	# Remove the path and the suffix from the .sorted.bam suffix
	pathRemoved="${bamFile/$bamPath/}"
	sampleName="${pathRemoved/$bamSuffix/}"
	samtools index $bamFile
	1>$bamPath$sampleName.index.log and 2>$bamPath$sampleName.index.err
done
