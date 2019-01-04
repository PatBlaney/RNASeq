#!/bin/perl

# Parse the XML output file of a blastp run of reference-guided transcriptome
# assembly and write SwissProt annotations to one tab delimited file

use Bio::SearchIO;
use Bio::SeqIO;

# Read the XML file and create Bio::SearchIO objects
my $blastXml = Bio::SearchIO->new(
	-file   => 'Trinity-GG.blastp.xml',
	-format => 'blastxml'
);

# Open a tab-separated file to write SwissProt annotations to
open( ANNOTFILE, ">", 'aipSwissProt.tsv' ) or die;

# Add the header to .tsv file
print ANNOTFILE "Trinity\tSwissProt\tSwissProtDesc\teValue\n";

# Loop through each complete result of the blastp XML file
while ( my $result = $blastXml->next_result() ) {

	# Pull the entire query description from each result
	my $queryDesc = $result->query_description;

	# Isolate the concise query description
	if ( $queryDesc =~ /::(.*?)::/ ) {
		my $queryDescShort = $1;

		# Reassign the hit from the result to pull accession number,
		# subject description, and significance
		my $hit = $result->next_hit;
		if ($hit) {
			my $accessionNum    = $hit->accession;
			my $significanceVal = $hit->significance;

			# Isolate the concise subject description, accounting for either a
			# semi-colon or open bracket as the cutoff
			my $subjectDescription = $hit->description;
			if ( $subjectDescription =~ /Full=(.*?);/ ) {
				$subjectDescription = $1;
			}
			if ( $subjectDescription =~ /Full=(.*?)\[/ ) {
				$subjectDescription = $1;
			}

			# Add each variable to the annotation file before starting
			# moving to next result
			print ANNOTFILE "$queryDescShort\t",
			  				"$accessionNum\t",
			  				"$subjectDescription\t",
			  				"$significanceVal\n";
		}
	}
}

# Close the annotation file after writing all annotations
close ANNOTFILE;
