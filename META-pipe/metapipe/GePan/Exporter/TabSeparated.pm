package GePan::Exporter::TabSeparated;
use base qw(GePan::Exporter);
use GePan::Collection::Sequence;
use GePan::Mapping::Mapping;
use strict;
use Data::Dumper;
use GePan::Hit::Pfam;
use GePan::Hit::Priam;

=head1 NAME

GePan::Exporter::Metarep

=head1 DESCRIPTION

Exporter for Metarep visual representation. 

=head1 ATTRIBUTES

collection: GePan::Collection::Sequence of annotated sequences

=head1 METHODS

=head2 B<export()>

Exports given sequence(s) to tab-separated file of given name to given directory.

Results are ordered by confidence level.

Additionally sets attribute 'tmp_file' to all sequence objects.

=cut

sub export{
    my $self = shift;

    die "No output directory set." unless $self->{'output_directory'};
    die "No output file name given." unless $self->{'file'};
    die "No sequence(s) given to export." unless $self->{'collection'};
  
    $self -> _load();

    my $path = $self->{'output_directory'}."/".$self->{'file'};
    $path=~s/\/\//\//g;

    open(FILE,">$path") or die "Failed to open output file $path for writing.";

    my $levelSwitch = 0;

    my $seqCount = 1;

    #Create lookuptables for mapping
    my $Pfam2GO = GePan::Mapping::Mapping -> new();
    my $GO2EC = GePan::Mapping::Mapping -> new();
    $Pfam2GO -> {'logger'} = $self ->{'logger'};
    $GO2EC -> {'logger'} = $self->{'logger'};
    $Pfam2GO -> indexPfam2GO();
    $GO2EC -> indexGO2EC();

    #Writes header
    my @columnlist = ('#Query ID','Blast ID', 'Blast Description', 'Blast Taxon ID', 'Blast Identity', 'Blast Evalue','Gene3D Accession', 'Hamap Accession', 'Pfam Accession', 'Phobius Accession', 'Prints Accession','Prodom Accession', 'Prositepatterns Accession', 'Prositeprofiles Accesion', 'Smart Accession', 'Superfamily Accession', 'Tigrfam Accession', 'Coils', 'Panther', 'Pirsf','Priam EC');
    #Print Header from array above
    foreach my $column (@columnlist){
	if ($column eq $columnlist[-1]){
		print FILE $column;
		last;
	}
        print FILE $column."\t";
    }
    print FILE "\n";


    foreach my $seq (sort{$a->getAnnotation()->getConfidenceLevel cmp $b->getAnnotation()->getConfidenceLevel()}@{$self->{'collection'}->getList()}){
	my $annotation = $seq->getAnnotation();	
	my $attributes = $annotation->getAttributeCollection();
	my $trans = $annotation->getTransferredAnnotation();
	my $func = $annotation->getFunctionalAnnotation();
	my $description = $trans->getAnnotation()->getDescription();
	$description =~ s/\t/\|\|/g;

	######## Scalars to print ########
	my $CommonNameSource = $trans?$trans->getAnnotation()->getRefSeq()."\t":"\t";
	my $GeneOntology = $func?$Pfam2GO->getPfam2GO($func->getAccessionNumber()):["\t"];
        my $BlastDescription = $trans?$description."\t":"\t";
	my $BlastTaxonID = $trans?$trans->getAnnotation()->getTaxonomyID()."\t":"\t";
	my $BlastEvalue = $trans?$trans->getEValue()."\t":"\t";
	my $BlastIdentity = $trans?$trans->getPercentIdentity()."\t":"\t";
	my $BlastID = $trans?$trans->getCompleteName()."\t":"\t";
	my %attributehash;
	#Get lists of annotations from every tool in current query
	foreach my $attribute(@{$attributes->getList()}){
		$attributehash{$attribute->getToolName()} = $attribute;
        }

	my $Gene3dAccession = $attributehash{'Gene3D'}?$attributehash{'Gene3D'}->getAccession()."\t":"\t";
	my $Gene3dDescription = $attributehash{'Gene3D'}?$attributehash{'Gene3D'}->getDescription()."\t":"\t";
	my $Gene3dEvalue = $attributehash{'Gene3D'}?$attributehash{'Gene3D'}->getEvalue()."\t":"\t";
        my $HamapAccession = $attributehash{'Hamap'}?$attributehash{'Hamap'}->getAccession()."\t":"\t";
        my $HamapDescription = $attributehash{'Hamap'}?$attributehash{'Hamap'}->getDescription()."\t":"\t";
        my $HamapEvalue = $attributehash{'Hamap'}?$attributehash{'Hamap'}->getEvalue()."\t":"\t";
        my $IpfamAccession = $attributehash{'Ipfam'}?$attributehash{'Ipfam'}->getAccession()."\t":"\t";
        my $IpfamDescription = $attributehash{'Ipfam'}?$attributehash{'Ipfam'}->getDescription()."\t":"\t";
        my $IpfamEvalue = $attributehash{'Ipfam'}?$attributehash{'Ipfam'}->getEvalue()."\t":"\t";
        my $PhobiusAccession = $attributehash{'Phobius'}?$attributehash{'Phobius'}->getAccession()."\t":"\t";
        my $PhobiusDescription = $attributehash{'Phobius'}?$attributehash{'Phobius'}->getDescription()."\t":"\t";
        my $PhobiusEvalue = $attributehash{'Phobius'}?$attributehash{'Phobius'}->getEvalue()."\t":"\t";
        my $PrintsAccession = $attributehash{'Prints'}?$attributehash{'Prints'}->getAccession()."\t":"\t";
        my $PrintsDescription = $attributehash{'Prints'}?$attributehash{'Prints'}->getDescription()."\t":"\t";
        my $PrintsEvalue = $attributehash{'Prints'}?$attributehash{'Prints'}->getEvalue()."\t":"\t";
        my $ProdomAccession = $attributehash{'Prodom'}?$attributehash{'Prodom'}->getAccession()."\t":"\t";
        my $ProdomDescription = $attributehash{'Prodom'}?$attributehash{'Prodom'}->getDescription()."\t":"\t";
        my $ProdomEvalue = $attributehash{'Prodom'}?$attributehash{'Prodom'}->getEvalue()."\t":"\t";
        my $PrositepatternsAccession = $attributehash{'Prositepatterns'}?$attributehash{'Prositepatterns'}->getAccession()."\t":"\t";
        my $PrositepatternsDescription = $attributehash{'Prositepatterns'}?$attributehash{'Prositepatterns'}->getDescription()."\t":"\t";
        my $PrositepatternsEvalue = $attributehash{'Prositepatterns'}?$attributehash{'Prositepatterns'}->getEvalue()."\t":"\t";
        my $PrositeprofilesAccession = $attributehash{'Prositeprofiles'}?$attributehash{'Prositeprofiles'}->getAccession()."\t":"\t";
        my $PrositeprofilesDescription = $attributehash{'Prositeprofiles'}?$attributehash{'Prositeprofiles'}->getDescription()."\t":"\t";
        my $PrositeprofilesEvalue = $attributehash{'Prositeprofiles'}?$attributehash{'Prositeprofiles'}->getEvalue()."\t":"\t";
        my $SmartAccession = $attributehash{'Smart'}?$attributehash{'Smart'}->getAccession()."\t":"\t";
        my $SmartDescription = $attributehash{'Smart'}?$attributehash{'Smart'}->getDescription()."\t":"\t";
        my $SmartEvalue = $attributehash{'Smart'}?$attributehash{'Smart'}->getEvalue()."\t":"\t";
        my $SuperfamilyAccession = $attributehash{'Superfamily'}?$attributehash{'Superfamily'}->getAccession()."\t":"\t";
        my $SuperfamilyDescription = $attributehash{'Superfamily'}?$attributehash{'Superfamily'}->getDescription()."\t":"\t";
        my $SuperfamilyEvalue = $attributehash{'Superfamliy'}?$attributehash{'Superfamily'}->getEvalue()."\t":"\t";
        my $TigrfamAccession = $attributehash{'Tigrfam'}?$attributehash{'Tigrfam'}->getAccession()."\t":"\t";
        my $TigrfamDescription = $attributehash{'Tigrfam'}?$attributehash{'Tigrfam'}->getDescription()."\t":"\t";
        my $TigrfamEvalue = $attributehash{'Tigrfam'}?$attributehash{'Tigrfam'}->getEvalue()."\t":"\t";
        my $PantherAccession = $attributehash{'Panther'}?$attributehash{'Panther'}->getAccession()."\t":"\t";
        my $PantherDescription = $attributehash{'Panther'}?$attributehash{'Panther'}->getDescription()."\t":"\t";
        my $PantherEvalue = $attributehash{'Panther'}?$attributehash{'Panther'}->getEvalue()."\t":"\t";
        my $CoilsAccession = $attributehash{'Coils'}?$attributehash{'Coils'}->getAccession()."\t":"\t";
        my $CoilsDescription = $attributehash{'Coils'}?$attributehash{'Coils'}->getDescription()."\t":"\t";
        my $CoilsEvalue = $attributehash{'Coils'}?$attributehash{'Coils'}->getEvalue()."\t":"\t";
        my $PirsfAccession = $attributehash{'Pirsf'}?$attributehash{'Pirsf'}->getAccession()."\t":"\t";
        my $PirsfDescription = $attributehash{'Pirsf'}?$attributehash{'Pirsf'}->getDescription()."\t":"\t";
        my $PirsfEvalue = $attributehash{'Pirsf'}?$attributehash{'Pirsf'}->getEvalue()."\t":"\t";
        my $PriamEC = $attributehash{'Priam'}?$attributehash{'Priam'}->getEC()."\t":"\t";
        my $PriamProbability = $attributehash{'Priam'}?$attributehash{'Priam'}->getProbability()."\t":"\t";
        my $PriamKept = $attributehash{'Priam'}?$attributehash{'Priam'}->getKept()."\t":"\t";
        my $PriamFragment = $attributehash{'Priam'}?$attributehash{'Priam'}->getFragment()."\t":"\t";

	######## Values to print in each column ########
	###Peptide ID (Sequence ID)
	print FILE $seq->{'id'}."\t";
	print FILE $BlastID, $BlastDescription, $BlastTaxonID, $BlastIdentity, $BlastEvalue; 
	print FILE $Gene3dAccession;
        print FILE $HamapAccession;
	print FILE $IpfamAccession;
	print FILE $PhobiusAccession;
	print FILE $PrintsAccession;
	print FILE $ProdomAccession;
	print FILE $PrositepatternsAccession;
	print FILE $PrositeprofilesAccession;
	print FILE $SmartAccession;
	print FILE $SuperfamilyAccession;
	print FILE $TigrfamAccession;
	print FILE $CoilsAccession;
	print FILE $PantherAccession;
	print FILE $PirsfAccession;
	print FILE $PriamEC;
	#Iterate through toollist and print accordingly

	###Gene start
#	print FILE $seq->{'start'}."\t";
	###Gene stop
#	print FILE $seq->{'stop'},"\t\n";
	print FILE "\n";

	$seqCount++;
    }
    close(FILE);
}


=head1 GETTER & SETTER METHODS

=head2 B<setCollection(GePan::Collection::Sequence)>

Sets the sequence-object(s) of the exporter.

=cut

sub setCollection{
    my ($self,$seqs) = @_;
    $self->{'collection'} = $seqs;
}

=head2 B<getCollection()>

Returns the GePan::Collection::Sequence object.

=cut

sub getCollection{
    my $self = shift;
    return $self->{'collection'};
}

sub cureDescription{
    my $string = $_;
    my $string =~ s/\t/, /g;
    return $string;

}

#Rewrite this. It's horrible.
sub getBestEC{
    my $attributes = $_[0];
    my $EnzymeCommission = $_[1];

    ###Prepare Priam results, if any.
    my $EC;
    my $sourceEC;
    #Get the first element, which is the lowest Evalue. Set to valid EC if >= E-10
    foreach my $priam(@{$attributes->getList()}){
	my $pec = $priam->getEC();
	my $pevalue = $priam->getEValue();
	if ($pevalue =~ /-\d{2}$/){
		$EC = $pec."\t";
		$sourceEC = "Priam; Evalue: ".$pevalue."\t";
	}
	last;
    }
    ###Prepare Pfam2GO2EC results, if any.
    sort(@$EnzymeCommission);
    #If no tab, insert tab at the end
    if ($EnzymeCommission->[0] !~ m/^\t/){push (@{$EnzymeCommission}, "\t");}
    #Extract defined values
    my @temp = grep {defined($_)} @$EnzymeCommission;
    my @resultEC;
    foreach (@temp){
	
    	push (@resultEC, $_);
    	if (($_ eq $temp[-2])||($_ eq $temp[-1])){next;}
    	push (@resultEC, '||');
    }
    ###Prioritize Priam
    if (defined($sourceEC)){
	my $return = $EC.$sourceEC;
	return $return;
    }
    ###No Priam, then Pfam2GO2EC
    elsif(defined($resultEC[1])){
	my $return = join ('',@resultEC)."Pfam2GO2EC\t";
	return $return;
    }
    ###No hits, return blank (\t\t)
    else{return "\t\t";}

}

1;
