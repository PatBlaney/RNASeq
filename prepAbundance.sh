#!/bin/bash
# Get the transcriptome argument from the command line
transcriptome=$1
# Store the Trinity path as a variable
trinityPath='/usr/local/programs/trinityrnaseq-2.2.0'
# Run align and estimate abundance with the --prep_reference option
# to build the bowtie2 index
nice -n19 $trinityPath/util/align_and_estimate_abundance.pl \
--transcripts $transcriptome --prep_reference \
--aln_method bowtie2 --est_method eXpress \
--trinity_mode --output_dir Aip --seqType fq \
1>$transcriptome.prep.log 2>$transcriptome.prep.err &
