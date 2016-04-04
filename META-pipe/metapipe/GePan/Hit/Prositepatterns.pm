package GePan::Hit::Prositepatterns;
use base qw(GePan::Hit);
use strict;
use GePan::Logger;

=head1 NAME

GePan::Hit::Phobius

=head1 DESCRIPTION

Class for a single Phobius-hit

=head1 ATTRIBUTES

prediction: probability of beeing a signal peptide

signalpept: Y if signal peptide

transmemb: probability of having a cleavage site

=head1 METHODS

=head1 GETTER & SETTER METHODS

=head2 B<setSignal(int)>

Sets 1 if peptide is signal peptide, 0 otherwise

=cut

sub setTool{
    my ($self,$v);
    $self->{'tool'} = $v;
}

=head2 B<getSignal>

Returns 1 if hit is signal peptide, 0 otherwise.

=cut

sub getTool{
    my $self = shift;
    return $self->{'tool'};
}

=head2 B<setCleavage(int)>

Sets the number of transmembrane regions predicted.

=cut

sub setAccession{
    my ($self,$v);
    $self->{'accession'} = $v;
}

=head2 B<getCleavage>

Returns the number of transmembrane regions predicted.

=cut

sub getAccession{
    my $self = shift;
    return $self->{'accession'};
}

=head2 B<setSignalProbability(int)>

Sets a string of prediction information.

=cut

sub setDescription{
    my ($self,$v);
    $self->{'description'} = $v;
}

=head2 B<getPrediction()>

Returns a string of prediction information.

=cut

sub getDescription{
    my $self = shift;
    return $self->{'description'};
}

sub setStart{
    my ($self,$v);
    $self->{'start'} = $v;
}

=head2 B<getPrediction()>

Returns a string of prediction information.

=cut

sub getStart{
    my $self = shift;
    return $self->{'start'};
}

sub setStop{
    my ($self,$v);
    $self->{'stop'} = $v;
}

=head2 B<getPrediction()>

Returns a string of prediction information.

=cut

sub getStop{
    my $self = shift;
    return $self->{'stop'};
}
=head2 B<_getAttributes()>

Returns a list of all attribute fields of object.

=cut

sub setEvalue{
    my ($self,$v);
    $self->{'evalue'} = $v;
}

=head2 B<getPrediction()>

Returns a string of prediction information.

=cut

sub getEvalue{
    my $self = shift;
    return $self->{'evalue'};
}

sub _getAttributes{
    my $self = shift;
    return ['tool','accession','description', 'start', 'stop', 'evalue', 'go', 'ipraccession', 'iprdescription'];
}


=head2 B<getName()>

Returns 'Phobius';

=cut

sub getToolName{
    return 'Prositepatterns';
}

1;
