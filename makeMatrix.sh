#!/bin/bash
# Save the first argument as the xprsDir. xprs_gg for the genome-guided
# and xprs_dn for de-novo
xprsDir=$1
# Get a list of all results.xprs files using find
results="$(find $xprsDir -iname results.xprs)"
# Clean up the lie breaks in the fine output by echoing the results
results="$(echo $results)"
# Run the Trinity abundance_estimates_to_matrix.pl utility using eXpress
# as the estimation method
nice -n19 /usr/local/programs/trinityrnaseq-2.2.0/\
util/abundance_estimates_to_matrix.pl --est_method eXpress \
--cross_sample_norm TMM \
--out_prefix $xprsDir \
--name_sample_by_basedir $results \
1>$xprs.log 2>$xprs.err &
