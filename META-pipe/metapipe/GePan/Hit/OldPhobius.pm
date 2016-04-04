package GePan::Hit::OldPhobius;
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

sub setSignalpept{
    my ($self,$v);
    $self->{'signalpept'} = $v;
}

=head2 B<getSignal>

Returns 1 if hit is signal peptide, 0 otherwise.

=cut

sub getSignalpept{
    my $self = shift;
    return $self->{'Signal'};
}

=head2 B<setCleavage(int)>

Sets the number of transmembrane regions predicted.

=cut

sub setTransmemb{
    my ($self,$v);
    $self->{'transmemb'} = $v;
}

=head2 B<getCleavage>

Returns the number of transmembrane regions predicted.

=cut

sub getTransmemb{
    my $self = shift;
    return $self->{'transmemb'};
}

=head2 B<setSignalProbability(int)>

Sets a string of prediction information.

=cut

sub setPrediction{
    my ($self,$v);
    $self->{'predction'} = $v;
}

=head2 B<getPrediction()>

Returns a string of prediction information.

=cut

sub getPrediction{
    my $self = shift;
    return $self->{'prediction'};
}

=head2 B<_getAttributes()>

Returns a list of all attribute fields of object.

=cut

sub _getAttributes{
    my $self = shift;
    return ['prediction','signalpept','transmemb'];
}


=head2 B<getName()>

Returns 'Phobius';

=cut

sub getToolName{
    return 'Phobius';
}

1;
