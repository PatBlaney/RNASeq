#!/bin/bash
# Initiate variables to hold command line arguments for the 
# transcriptome file and output path directory
transcriptome=$1
outPath=$2
# Initiate variables to hold the path to the Trinity software,
# the trimmed paired reads path, both fastq read suffixes, and
# suffix of log and error files
trinityPath='/usr/local/programs/trinityrnaseq-2.2.0'
pairedPath='Paired/'
leftSuffix='.R1.fastq'
rightSuffix='.R2.fastq'
logSuffix='.log'
errSuffix='.err'
# Check to make sure the output path directory exists, if not
# create the directory
mkdir -p $outPath
# Loop through all left reads of the pairs in the Paired directory
for leftReads in $pairedPath*$leftSuffix
do
	# Use base path of left reads to get corresponding right read
	rightReads="${leftReads/$leftSuffix/$rightSuffix}"
	# Isolate the sample name from the file path
	sample="${leftReads/$pairedPath/}"
	sample="${sample/$leftSuffix/}"
	# Run align and estimate abundance utility tool within Trinity
	# using the user input transcriptome and corresponding left and
	# right reads
	nice -n19 $trinityPath/util/align_and_estimate_abundance.pl \
	--transcripts $transcriptome --aln_method bowtie2 --est_method eXpress \
	--trinity_mode --output_dir $outPath$sample --seqType fq --SS_lib_type FR \
	--left $leftReads --right $rightReads --thread_count 1\
	1>$outPath$sample$logSuffix 2>$outPath$sample$errSuffix &
done
