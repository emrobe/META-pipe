package GePan::Tool::Prediction::Interpro;
use base qw(GePan::Tool);

use Data::Dumper;
use GePan::Config qw(INTERPRO_PATH);
use GePan::Logger;


=head1 NAME

GePan::Tool::Prediction::Interpro

=head1 DESCRIPTION

Class for executing the Interpro package.

Sub-class of GePan::Tool

=head1 METHODS

=head2 B<execute()>

Executes Interpro. Output is written to given output directory.

Output is written to given output dir.

=cut

sub execute{
    my $self = shift;

    my $statement = $self->_getExecuteStatement();
    $self->{'logger'}->LogStatus("Interpro execute statement: $statement");
    my $exit = system($statement);
    $self->{'logger'}->LogError("GePan::Tool::Prediction::Interpro::execute - executing Interpro failed") if ($exit);
}

=head2 B<getToolName()>

Returns short name of tool (\'glimmer\')

=cut

sub getToolName{
    my $self = shift;
    return "interpro";
}

=head1 INTERNAL METHODS

=cut

=head2 B<_getExecuteStatement()>

Creates and returns the execute statement for glimmer.

=cut

sub _getExecuteStatement{
    my $self = shift;

my $outputPath = $self->{'output_dir'}.'/'.$self->{'output_file'};

    my @split = split(/\./,($self->{'output_file'}));
    my $last = pop(@split);
    my $tag = join(".",@split);
    if($last ne 'predict'){
        $tag .= $last;
    }


    my $statement = "bash ".INTERPRO_PATH." -goterms -iprlookup -f tsv --applications TIGRFAM,PRODOM,SMART,PROSITE,HAMAP,SUPERFAMILY,PRINTS,PANTHER,GENE3D,PIRSF,PHOBIUS,COILS -t p -i ".$self->{'input_file'}." -o $outputPath";
    return $statement;
}




1;
