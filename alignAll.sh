#!/bin/sh
# Initialize variables to contain the splice site file, GMAP database, the
# directory of the trimmed paired end FASTQ files, the left/right suffix, and
# the output directory
basePath="/home/blaney.p/binf6309-PatrickBlaney/RNA-Seq/"
spliceSites="AiptasiaGmapIIT.iit"
GMAPdb="AiptasiaGmapDb"
trimmedPairedReadPath="Paired/"
leftSuffix=".R1.fastq"
rightSuffix=".R2.fastq"
samOutPath="Sam/"
# Loop through all trimmed paired end reads in the directory and output the
# .sam file into the designated Sam folder
for leftInFile in $basePath$trimmedPairedReadPath*$leftSuffix
do
	# Remove the base path and suffix from the sample filename
	pathRemoved="${leftInFile/$basePath$trimmedPairedReadPath/}"
	sampleName="${pathRemoved/$leftSuffix/}"
        nice -n 19 gsnap \
        -A sam \
        -s $basePath$spliceSites \
        -D $basePath \
        -d $GMAPdb \
        $basePath$trimmedPairedReadPath$sampleName$leftSuffix \
        $basePath$trimmedPairedReadPath$sampleName$rightSuffix \
        1>$samOutPath$sampleName.sam 2>$samOutPath$sampleName.err
done
