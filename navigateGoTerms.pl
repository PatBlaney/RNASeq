#!/bin/perl
use warnings;
use strict;

# Subset a complete ontology heirarchy to just those relevent to the experimental
# organism

use Bio::OntologyIO;

# Initiate a variable to hold the parser of all GO Terms within the .obo file
my $parser = Bio::OntologyIO->new(
	-file   => "/scratch/go-basic.obo",
	-format => "obo"
);

# Open a tab delimitied file to write GO Term ID and name to
open(GOTERMS, ">","bioProcess.tsv") or die $!;

# Loop through all the terms ascending to top level
while (my $ont = $parser->next_ontology() ) {
	
	# Restrict GO Terms to just those for biolocial process as they are the most
	# applicable to Aiptasia experiment
	if ($ont->name() eq "biological_process") {
		
		# Cycle through all leaves to write their name and GO Term ID to the output file
		foreach my $leaf ( $ont->get_leaf_terms ) {
			my $go_name = $leaf->name();
			my $go_id = $leaf->identifier();
			print GOTERMS join( "\t", $go_id, $go_name), "\n";
		}
	}
}
