package GePan::Tool::Annotation::Pfam;
use base qw(GePan::Tool::Annotation);

use strict;
use GePan::Config qw(DATABASE_PATH PFAM_PATH GESTORE_PATH GESTORE_CONFIG);
use GePan::Logger;

=head1 NAME

GePan::Tool::Annotation::Pfam

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

    $self->{'logger'}->LogError("No output directory for hmmsearch run given.") unless ($self->{'output_dir'});
    $self->{'logger'}->LogError("No input file for hmmsearch run given.") unless ($self->{'input_file'});
    $self->{'logger'}->LogError("No database for hmmsearch run given.") unless ($self->{'database'});

    my $statement = $self->_getExecuteStatement();
    $self->{'logger'}->LogStatus("Pfam call: $statement\n");
    my $exit = system($statement);
    if($exit){
	$self->{'logger'}->LogError("\n[ERROR] hmmsearch exit(".($exit/256).")\n");
    }
}

=head2 B<getToolName()>

Returns 'pfam'.

=cut

sub getToolName{
    return 'pfam';
}


=head1 INTERNAL METHODS


=head2 B<_getExecuteStatement()>

Creates and returns the execute statement for glimmer.

=cut

sub _getExecuteStatement{
    my $self = shift;

    my $outputdir = $self->{'output_dir'};
    my $outputFile = $self->{'output_file'};
    my $outputComplete = $outputdir."/".$outputFile;
    $outputComplete=~s/\/\//\//g;

    my $db_path = $self->{'database'}->getPath();

    my $statement;
    
    if($self->{'database'}->getDatabaseTaxon() eq 'gestore') {
      my @paths = split('/', $db_path);
      my $db_name = $paths[-1];
      $statement = 'hadoop jar '.GESTORE_PATH.' org.diffdb.move -D file='.$db_name.' -D run='.$self->{'run'}.' -D type=r2l -D regex='.$self->{'regex'}.' -conf='.GESTORE_CONFIG."\n";
      $statement .= 'touch pfam_result_'.$db_name."\n";
      $statement .= 'touch '.$db_name.".deleted\n";
      $statement .= 'hadoop jar '.GESTORE_PATH.' org.diffdb.move -D file=pfam_result_'.$db_name.' -D task=${SGE_TASK_ID} -D run='.$self->{'run'}.' -D type=r2l -conf='.GESTORE_CONFIG."\n";
      $statement .= PFAM_PATH." --domtblout pfamOutput $db_name ".$self->{'input_file'}."\n";
      $statement .= "cat pfamOutput pfam_result_$db_name | grep -f $db_name.deleted -v | grep -v '#' > pfamProperOut\n";
      $statement .= 'hadoop jar '.GESTORE_PATH.' org.diffdb.move -D file=pfam_result_'.$db_name.' -D path=pfamProperOut -D task=${SGE_TASK_ID} -D run='.$self->{'run'}.' -D type=l2r -D format=hmmeroutput -conf='.GESTORE_CONFIG."\n";
      $statement .= "mv pfamProperOut $outputComplete\n";
    } else {
      $db_path=~s/\/\//\//g;
      $statement = PFAM_PATH." --domtblout $outputComplete $db_path ".$self->{'input_file'};
    }
    return $statement;
}


1;
