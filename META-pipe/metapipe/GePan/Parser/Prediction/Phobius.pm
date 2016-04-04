package GePan::Parser::Prediction::Phobius;
use base qw(GePan::Parser::Prediction);
use strict;
use Data::Dumper;
use GePan::Hit::Phobius;

=head1 NAME

GePan::Parser::Prediction::Phobius

=head1 DESCRIPTION

Parser for tool Phobius

=head1 ATTRIBUTE

=head1 METHODS 

=head2 B<parseFile()>

Parses the result file of a Phobius run.

=cut

sub parseFile{
    my $self = shift;

    $self->{'logger'}->LogError("No phobius output file specified for parsing.") unless $self->{'file'};

    my $collection = GePan::Collection::Hit->new();
    $collection->setLogger($self->{'logger'});

    my $file = $self->{'file'};
    open(FILE,"<$file") or $self->{'logger'}->LogError("Failed to open file $file for reading.");
    while(my $line = <FILE>){
	if($line=~/^SEQENCE ID/){
	    next;
	}   	
	my @split = grep{$_ ne ""}split(/[\t\s]/,$line);
	$self->{'logger'}->LogError("GePan::Parser::Prediction::Phobius::parseFile() - Odd number of elements in line split.") unless scalar(@split)==4;

	next unless (($split[1] !=0)||($split[2] eq 'Y'));

	my $hit = GePan::Hit::Phobius->new();
	$hit->setParams({prediction=>$split[3],
			 transmemb=>$split[1],
			 signalpept=>$split[2],
			 id=>$split[0],
			 logger=>$self->{'logger'}});
	$collection->addElement($hit);
    }
    close(FILE);
    $self->{'collection'} = $collection;
}

1;
