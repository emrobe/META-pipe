package GePan::Parser::Prediction::Interpro;
use base qw(GePan::Parser::Prediction);
use strict;
use Data::Dumper;
use GePan::Hit::Gene3d;
use GePan::Hit::Superfamily;
use GePan::Hit::Smart;
use GePan::Hit::Prositepatterns;
use GePan::Hit::Prints;
use GePan::Hit::Tigrfam;
use GePan::Hit::Prodom;
use GePan::Hit::Prositeprofiles;
use GePan::Hit::Hamap;
use GePan::Hit::IPfam;
use GePan::Hit::Panther;
use GePan::Hit::Coils;
use GePan::Hit::Pirsf;

#use GePan::Hit::Pfam;

=head1 NAME

GePan::Parser::Prediction::Interpro

=head1 DESCRIPTION

Parser for tool Interpro

=head1 ATTRIBUTE

=head1 METHODS 

=head2 B<parseFile()>

Parses the result file of an Interpro run.

=cut

sub parseFile{
    my $self = shift;

    $self->{'logger'}->LogError("No interpro output file specified for parsing.") unless $self->{'file'};

    my $collection = GePan::Collection::Hit->new();
    $collection->setLogger($self->{'logger'});

    my $file = $self->{'file'};
    open(FILE,"<$file") or $self->{'logger'}->LogError("Failed to open file $file for reading.");
    while(my $line = <FILE>){
	my @split = grep{$_ ne ""}split(/\t/,$line);

        #Run subroutine matching string in column 4. 
        &{\&{$split[3]}}($self,$collection,\@split);
    }
    close(FILE);
    $self->{'collection'} = $collection;
}

sub Gene3D{
        my $self = shift;
        my $collection = shift;
        my @split = @{$_[0]};
        my $hit = GePan::Hit::Gene3d->new();
        $hit->setParams({tool=>$split[3],
                         accession=>$split[4],
                         description=>$split[5],
                         start=>$split[6],
                         stop=>$split[7],
                         evalue=>$split[8],
                         id=>$split[0],
                         logger=>$self->{'logger'}});
	if ((scalar @split)>11){$hit->setParams({ipraccession=>$split[11], iprdescription=>$split[12]});}
	if ((scalar @split)>13){$hit->setParams({go=>$split[13]});}
        $collection->addElement($hit);
}
sub SUPERFAMILY{
        my $self = shift;
        my $collection = shift;
        my @split = @{$_[0]};
        my $hit = GePan::Hit::Superfamily->new();
        $hit->setParams({tool=>$split[3],
                         accession=>$split[4],
                         description=>$split[5],
                         start=>$split[6],
                         stop=>$split[7],
                         evalue=>$split[8],
                         id=>$split[0],
                         logger=>$self->{'logger'}});
        if ((scalar @split)>11){$hit->setParams({ipraccession=>$split[11], iprdescription=>$split[12]});}
        if ((scalar @split)>13){$hit->setParams({go=>$split[13]});}
        $collection->addElement($hit);
}
sub Pfam{
        my $self = shift;
        my $collection = shift;
        my @split = @{$_[0]};
        my $hit = GePan::Hit::Ipfam->new();
        $hit->setParams({tool=>$split[3],
                         accession=>$split[4],
                         description=>$split[5],
                         start=>$split[6],
                         stop=>$split[7],
                         evalue=>$split[8],
                         id=>$split[0],
                         logger=>$self->{'logger'}});
        if ((scalar @split)>11){$hit->setParams({ipraccession=>$split[11], iprdescription=>$split[12]});}
        if ((scalar @split)>13){$hit->setParams({go=>$split[13]});}
        $collection->addElement($hit);
}
sub SMART{
        my $self = shift;
        my $collection = shift;
        my @split = @{$_[0]};
        my $hit = GePan::Hit::Smart->new();
        $hit->setParams({tool=>$split[3],
                         accession=>$split[4],
                         description=>$split[5],
                         start=>$split[6],
                         stop=>$split[7],
                         evalue=>$split[8],
                         id=>$split[0],
                         logger=>$self->{'logger'}});
        if ((scalar @split)>11){$hit->setParams({ipraccession=>$split[11], iprdescription=>$split[12]});}
        if ((scalar @split)>13){$hit->setParams({go=>$split[13]});}
        $collection->addElement($hit);
}
sub ProSitePatterns{
        my $self = shift;
        my $collection = shift;
        my @split = @{$_[0]};
        my $hit = GePan::Hit::Prositepatterns->new();
        $hit->setParams({tool=>$split[3],
                         accession=>$split[4],
                         description=>$split[5],
                         start=>$split[6],
                         stop=>$split[7],
                         evalue=>$split[8],
                         id=>$split[0],
                         logger=>$self->{'logger'}});
        if ((scalar @split)>11){$hit->setParams({ipraccession=>$split[11], iprdescription=>$split[12]});}
        if ((scalar @split)>13){$hit->setParams({go=>$split[13]});}
        $collection->addElement($hit);
}
sub ProSiteProfiles{
        my $self = shift;
        my $collection = shift;
        my @split = @{$_[0]};
        my $hit = GePan::Hit::Prositeprofiles->new();
        $hit->setParams({tool=>$split[3],
                         accession=>$split[4],
                         description=>$split[5],
                         start=>$split[6],
                         stop=>$split[7],
                         evalue=>$split[8],
                         id=>$split[0],
                         logger=>$self->{'logger'}});
        if ((scalar @split)>11){$hit->setParams({ipraccession=>$split[11], iprdescription=>$split[12]});}
        if ((scalar @split)>13){$hit->setParams({go=>$split[13]});}
        $collection->addElement($hit);
}
sub Hamap{
        my $self = shift;
        my $collection = shift;
        my @split = @{$_[0]};
        my $hit = GePan::Hit::Hamap->new();
        $hit->setParams({tool=>$split[3],
                         accession=>$split[4],
                         description=>$split[5],
                         start=>$split[6],
                         stop=>$split[7],
                         evalue=>$split[8],
                         id=>$split[0],
                         logger=>$self->{'logger'}});
        if ((scalar @split)>11){$hit->setParams({ipraccession=>$split[11], iprdescription=>$split[12]});}
        if ((scalar @split)>13){$hit->setParams({go=>$split[13]});}
        $collection->addElement($hit);
}
sub TIGRFAM{
        my $self = shift;
        my $collection = shift;
        my @split = @{$_[0]};
        my $hit = GePan::Hit::Tigrfam->new();
        $hit->setParams({tool=>$split[3],
                         accession=>$split[4],
                         description=>$split[5],
                         start=>$split[6],
                         stop=>$split[7],
                         evalue=>$split[8],
                         id=>$split[0],
                         logger=>$self->{'logger'}});
        if ((scalar @split)>11){$hit->setParams({ipraccession=>$split[11], iprdescription=>$split[12]});}
        if ((scalar @split)>13){$hit->setParams({go=>$split[13]});}
        $collection->addElement($hit);
}
sub PRINTS{
        my $self = shift;
        my $collection = shift;
        my @split = @{$_[0]};
        my $hit = GePan::Hit::Prints->new();
        $hit->setParams({tool=>$split[3],
                         accession=>$split[4],
                         description=>$split[5],
                         start=>$split[6],
                         stop=>$split[7],
                         evalue=>$split[8],
                         id=>$split[0],
                         logger=>$self->{'logger'}});
        if ((scalar @split)>11){$hit->setParams({ipraccession=>$split[11], iprdescription=>$split[12]});}
        if ((scalar @split)>13){$hit->setParams({go=>$split[13]});}
        $collection->addElement($hit);
}
sub ProDom{
        my $self = shift;
        my $collection = shift;
        my @split = @{$_[0]};
        my $hit = GePan::Hit::Prodom->new();
        $hit->setParams({tool=>$split[3],
                         accession=>$split[4],
                         description=>$split[5],
                         start=>$split[6],
                         stop=>$split[7],
                         evalue=>$split[8],
                         id=>$split[0],
                         logger=>$self->{'logger'}});
        if ((scalar @split)>11){$hit->setParams({ipraccession=>$split[11], iprdescription=>$split[12]});}
        if ((scalar @split)>13){$hit->setParams({go=>$split[13]});}
        $collection->addElement($hit);
}
sub Phobius{
        my $self = shift;
        my $collection = shift;
        my @split = @{$_[0]};
        my $hit = GePan::Hit::Phobius->new();
        $hit->setParams({tool=>$split[3],
                         accession=>$split[4],
                         description=>$split[5],
                         start=>$split[6],
                         stop=>$split[7],
                         evalue=>$split[8],
                         id=>$split[0],
                         logger=>$self->{'logger'}});
        if ((scalar @split)>11){$hit->setParams({ipraccession=>$split[11], iprdescription=>$split[12]});}
        if ((scalar @split)>13){$hit->setParams({go=>$split[13]});}
        $collection->addElement($hit);
}
sub PANTHER{
        my $self = shift;
        my $collection = shift;
        my @split = @{$_[0]};
        my $hit = GePan::Hit::Panther->new();
        $hit->setParams({tool=>$split[3],
                         accession=>$split[4],
                         description=>$split[5],
                         start=>$split[6],
                         stop=>$split[7],
                         evalue=>$split[8],
                         id=>$split[0],
                         logger=>$self->{'logger'}});
        if ((scalar @split)>11){$hit->setParams({ipraccession=>$split[11], iprdescription=>$split[12]});}
        if ((scalar @split)>13){$hit->setParams({go=>$split[13]});}
        $collection->addElement($hit);
}
sub Coils{
        my $self = shift;
        my $collection = shift;
        my @split = @{$_[0]};
        my $hit = GePan::Hit::Coils->new();
        $hit->setParams({tool=>$split[3],
                         accession=>$split[4],
                         description=>$split[5],
                         start=>$split[6],
                         stop=>$split[7],
                         evalue=>$split[8],
                         id=>$split[0],
                         logger=>$self->{'logger'}});
        if ((scalar @split)>11){$hit->setParams({ipraccession=>$split[11], iprdescription=>$split[12]});}
        if ((scalar @split)>13){$hit->setParams({go=>$split[13]});}
        $collection->addElement($hit);
}
sub PIRSF{
        my $self = shift;
        my $collection = shift;
        my @split = @{$_[0]};
        my $hit = GePan::Hit::Pirsf->new();
        $hit->setParams({tool=>$split[3],
                         accession=>$split[4],
                         description=>$split[5],
                         start=>$split[6],
                         stop=>$split[7],
                         evalue=>$split[8],
                         id=>$split[0],
                         logger=>$self->{'logger'}});
        if ((scalar @split)>11){$hit->setParams({ipraccession=>$split[11], iprdescription=>$split[12]});}
        if ((scalar @split)>13){$hit->setParams({go=>$split[13]});}
        $collection->addElement($hit);
}
1;
