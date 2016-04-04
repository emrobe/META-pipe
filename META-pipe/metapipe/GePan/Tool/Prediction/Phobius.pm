package GePan::Tool::Prediction::Phobius;
use base qw(GePan::Tool);

use Data::Dumper;
use GePan::Config qw(PHOBIUS_PATH);
use GePan::Logger;


=head1 NAME

GePan::Tool::Prediction::Phobius

=head1 DESCRIPTION

Class for executing the Phobius prediction tool.

Sub-class of GePan::Tool

=head1 METHODS

=head2 B<execute()>

Executes Phobius. Output is written to given output directory.

Output is written to given output dir.

=cut

sub execute{
    my $self = shift;

    my $statement = $self->_getExecuteStatement(); 
    $self->{'logger'}->LogStatus("Phobius execute statement: $statement");
    my $exit = system($statement);
    $self->{'logger'}->LogError("GePan::Tool::Prediction::Phobius::execute - executing Phobius failed") if ($exit);
}

=head2 B<getToolName()>

Returns short name of tool (\'glimmer\')

=cut

sub getToolName{
    my $self = shift;
    return "phobius";
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


    my $statement = PHOBIUS_PATH." -short ".$self->{'input_file'}." > $outputPath";
    return $statement;
}




1;
