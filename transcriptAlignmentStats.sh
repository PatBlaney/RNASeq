#!/bin/bash
# Get the xprs path as the first argument
xprsPath=$1
# Set a variable with the xprs output file extension
xprsExt='.err'
# Set a variable with the output filename
outFile='tranAlignStats.csv'
# Set a variable with the search text of the desired data
searchText='overall alignment rate'
# Write a header line in the csv file
echo 'Sample,TranAligPct' > $xprsPath$outFile
# Grep the search text and pipe into a loop to process each line
grep "$searchText" $xprsPath*$xprsExt | while read -r line ;
do
	# Remove search text from the output
	line="${line/$searchText/}"
	# Remove file path from the output
	line="${line/$xprsPath/}"
	# Remove file extension from the output
	line="${line/$xprsExt/}"
	# Replace colon separator with comma
	line="${line/:/,}"
	# Remove the % sign
	line="${line/\%/}"
	# Appened line output in csv file
	echo $line >> $xprsPath$outFile
done
