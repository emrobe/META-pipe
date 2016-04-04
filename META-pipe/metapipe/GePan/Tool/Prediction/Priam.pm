package GePan::Tool::Prediction::Priam;
use base qw(GePan::Tool);

use strict;
use GePan::Config qw(DATABASE_PATH PRIAM_PATH PRIAM_BLAST_PATH PRIAM_RELEASE_PATH GESTORE_PATH GESTORE_CONFIG);
use GePan::Logger;

=head1 NAME

GePan::Tool::Annotation::Priam

=head1 DESCRIPTION

Class for running hmmscan with given database and input file

Sub-Class of GePan::Tool

hmmscan call

    hmmscan --domtblout OUTPUTFILE DATABASE INPUTFILE

=head1 METHODS

=head2 B<execute()>

Starts a hmmscan with given multiple fasta and database

=cut

sub execute{
    my $self = shift;

    $self->{'logger'}->LogError("No output directory for priam run given.") unless ($self->{'output_dir'});
    $self->{'logger'}->LogError("No input file for priam run given.") unless ($self->{'input_file'});

    my $statement = $self->_getExecuteStatement();
    $self->{'logger'}->LogStatus("Priam call: $statement\n");
    my $exit = system($statement);
    if($exit){
	$self->{'logger'}->LogError("\n[ERROR] priam exit(".($exit/256).")\n");
    }
}

=head2 B<getToolName()>

Returns 'pfam'.

=cut

sub getToolName{
    return 'priam';
}


=head1 INTERNAL METHODS


=head2 B<_getExecuteStatement()>

Creates and returns the execute statement for Priam. Parameters used are recommended for independant protein sequences by priam (-pt 0.5 -mo 20 -mp 70 -cc T -cg F).

=cut

sub _getExecuteStatement{
    my $self = shift;

    my $outputdir = $self->{'output_dir'};
    my $outputFile = $self->{'output_file'};
    my $outputComplete = $outputdir."/".$outputFile;
    $outputComplete=~s/\/\//\//g;

    my $params = $self->{'parameter'};

    my $statement;

    #if($self->{'gestore'}) {
      #$statement = 'hadoop jar '.GESTORE_PATH.' org.diffdb.move -D file=priam -D run='.$self->{'run'}.' -D type=r2l -D regex='.$self->{'regex'}.' -conf='.GESTORE_CONFIG."\n";
      #$statement .= PRIAM_PATH." -bd ".PRIAM_BLAST_PATH." -p priam -od $outputdir"." -i ".$self->{'input_file'}." -n $outputFile"." -pt 0.5 -mo 20 -mp 70 -cc T -cg F";
    #} else {
      #$statement = PRIAM_PATH." -bd ".PRIAM_BLAST_PATH." -p ".PRIAM_RELEASE_PATH." -od $outputdir"." -i ".$self->{'input_file'}." -n priamout"." -pt 0.5 -mo 20 -mp 70 -cc T -cg F";
      #$statement = PRIAM_PATH." -bd ".PRIAM_BLAST_PATH." -p ".PRIAM_RELEASE_PATH." -od $outputdir"." -i ".$self->{'input_file'}." -n $outputFile"." -pt 0.5 -mo 20 -mp 70 -cc T -cg F";
      $statement = PRIAM_PATH." --blast_path ".PRIAM_BLAST_PATH." --priam ".PRIAM_RELEASE_PATH." --out $outputdir"." --in ".$self->{'input_file'}." --job_name $outputFile"." --min_proba 0.5 --min_proportion 70 --check_catalytic T --complete_genome F";
    #}
    return $statement;
}


1;
