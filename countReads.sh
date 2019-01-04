#!/bin/bash
# Write header lines for the csv files
echo "PairsOut,Sample" > pairsOut.csv
echo "PairsIn,Sample" > pairsIn.csv
# Set variables for the inPath, outPath, and left read suffix
outPath="Paired/"
inPath="/scratch/AiptasiaMiSeq/fastq/"
leftSuffix=".R1.fastq"
# 1. Use grep to find all lines starting with @M0 in all R1.fastq files
# 2. Pipe output to cut, and separate columns by ':', get first column
# 3. Pipe output to sort
# 4. Pipe output to uniq to collapse repeating sample names
# 5. Use -c option to provide count of lines collapsed
# 6. Use sed to replace spaces with commas and remove path and suffix from filename
grep "\@M0" $outPath*$leftSuffix|\
cut -d':' -f1|\
sort|\
uniq -c|\
sed -e "s|^ *||;s| |,|;s|$outPath||;s|$leftSuffix||" >> pairsOut.csv
grep "\@M0" $inPath*$leftSuffix|\
cut -d':' -f1|\
sort|\
uniq -c|\
sed -e "s|^ *||;s| |,|;s|$inPath||;s|$leftSuffix||" >> pairsIn.csv
