#!/bin/perl
use warnings;
use strict;

# Combine annotations from various databases and GO Terminology into one tab
# delimited file for each transcritp matched by the Blast

# Open the complete GO Terms annotation file
open( SP_TO_GO, "<", "/scratch/go/spToGo.tsv" ) or die $!;

# Initialize a hash to store the SwissProt IDs and associated GO Terms
my %spToGo;

# Loop through all lines in the annotation file to isolate the GO Terms for
# each associated SwissProt ID
while (<SP_TO_GO>) {
	chomp;

	# Split the line by column and initialize variables for the SwissProt ID
	# and GO Terms
	my ( $swissProt, $go ) = split( "\t", $_ );

	# Add both variables to the hash and increment a counter to force the
	# hash to be two dimensional
	$spToGo{$swissProt}{$go}++;
}

# Open the .tsv file containing all biological process GO Terms names and associated IDs
open( BIOPROGO, "<", "bioProcess.tsv" ) or die $!;

# Initialize a hash to store the biological process GO Term IDs and names
my %bioProcessGo;

# Read the BioPro GO Terms .tsv file to store each ID as key and name as value
while (<BIOPROGO>) {
	chomp;

	# Separate the GO ID from the term
	my ( $goId, $goName ) = split( "\t", $_ );

	# Add name and ID to the hash
	$bioProcessGo{$goId} = $goName;
}

# Open the merged annotation file containing query description, SwissProt
# accession IDs, subject description, and e-value
open( SP, "<", "aipSwissProt.tsv" ) or die $!;

# Open a tab delimited file to write the full results of the merged annotation files
open(TRINITYGO, ">", "trinitySpGo.tsv");

# Loop through each line to isolate each column
while (<SP>) {
	chomp;
	my ( $trinity, $swissProt, $description, $eValue ) = split( "\t", $_ );

	# Find any SwissProt accession ID matches between the merged annotation file
	# and the hash of associated GO Terms
	if ( defined $spToGo{$swissProt} ) {
		foreach my $go ( sort keys %{ $spToGo{$swissProt} } ) {
			
			# Match the GO ID from the merged annotation file to the BioPro GO Terms
			# then write this to the tab delimited .tsv file.
			if (defined $bioProcessGo{$go}) {
				print TRINITYGO join( "\t", $trinity, $description, $swissProt, $go, $bioProcessGo{$go} ), "\n";
			}
		}
	}
}
