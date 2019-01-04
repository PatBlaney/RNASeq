#!/usr/bin/perl
use strict;
use warnings;

# Create a .pep file that contains a subset of the whole transcriptome assembly .pep file

use Bio::Seq;
use Bio::SeqIO;
use Getopt::Long;
use Pod::Usage;

# Initialize variables that hold the user-specifed options for the program
my $fastaIn    = 'Trinity-GG.fasta.transdecoder.pep';
my $fastaOut   = 'subset.pep';
my $sampleRate = 1000;
my $usage      = "\n$0 [options] \n
Options:
	-fastaIn	FASTA input file [$fastaIn]
	-fastaOut	FASTA output file [$fastaOut]
	-sampleRate Number of output files [$sampleRate]
	-help		Show this message
\n";

# Utilize the GetOptions subroutine from the Getopt::Long module to store the program
# options to accept
GetOptions(
	'fastaIn=s'    => \$fastaIn,
	'fastaOut=s'   => \$fastaOut,
	'sampleRate=i' => \$sampleRate,
	'help'         => sub { pod2usage($usage); },
) or pod2usage($usage);

# Check if the input file exists, output message to user if it does not exist
if ( not( -e $fastaIn ) ) {
	die "The input file $fastaIn specified by -fastaIn does not exist\n";
}

# Read in the input .pep file containing full dataset
my $input = Bio::SeqIO->new(
	-file   => $fastaIn,
	-format => 'fasta'
);

# Open output .pep file to write subset of data to
my $output = Bio::SeqIO->new(
	-file   => ">$fastaOut",
	-format => 'fasta'
);

# Loop throug all peptide sequences with in whole transcriptome dataset
# Utilize a count to track the sequence entry total
my $seqCount = 0;
while ( my $seq = $input->next_seq ) {
	$seqCount++;

	# Write every thousandth peptide sequence to the subset file
	if ( ( $seqCount % $sampleRate ) == 0 ) {
		$output->write_seq($seq);
	}
}
