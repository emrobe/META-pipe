package GePan::FileScheduler;

use strict;
use Data::Dumper;
use GePan::Exporter::Fasta;
use GePan::Collection::Sequence;
use GePan::Logger;

=head1 NAME

GePan::FileScheduler

=head1 DESCRIPTION

Package for creating multiple fasta files with at most 
given number of sequences per file. 

=cut

=head1 ATTRIBUTES

max = maximum number of fasta files to create (number of CPUs used)

collection = GePan::Collection::Sequence object containing sequences.

output_directory = directory the fasta files are written too

file_names = array-ref of outomatically generated fasta file names (created by FileScheduler).

logger: GePan::Logger object

=head1 CONSTRUCTOR

=head2 B<new()>

Creates an empty FileScheduler object.

=cut

sub new{
    my ($class) = @_;
    my $self = {max=>'',
		collection=>'',
		output_directory=>'',
		file_names=>''};
    return (bless($self,$class));
}

=head1 METHODS

=head2 B<createFiles()>

Creates max number of sequence files from sequences in given sequence_object.

=cut

sub createFiles{
    my $self = shift;
    
    $self->{'logger'}->LogError("FileScheduler::createFiles() - No maximum number of sequence-file(s) given.") unless $self->{'max'};
    $self->{'logger'}->LogError("FileScheduler::createFiles() - No GePan::Collection::Sequence object given.") unless $self->{'collection'};
    $self->{'logger'}->LogError("FileScheduler::createFiles() - No output-directory given.") unless $self->{'output_directory'};

    my $collection = $self->{'collection'};
    my $files = [];

    my $seqs = _split($collection,$self); 

    my $path = $self->{'output_directory'}."/";
    $path=~s/\/\//\//g;
   
    for(my $i = 0;$i<scalar(@$seqs);$i++){
        my $tmp = {};
        my $type;
        my $splitCollection = GePan::Collection::Sequence->new();
        while(my $seq = $seqs->[$i]->getNextElement()){
            $self->{'logger'}->LogError("FileScheduler::createFiles() - Unknown sequence of name ".$seq->getID()) unless ($collection->getElementByID($seq->getID));
            if($type && ($seq->getType() ne $type)){
                $self->{'logger'}->LogWarning("Sequences of different types are included in file.");
            }
            if(!$type){
                $type = $seq->getType();
            }
            $splitCollection->addElement($seq);
        }

        my $name = _getFileName($self->{'file'},$path);
        my $fasta = GePan::Exporter::Fasta->new();
        my $input_type = $self->{'collection'}->getList()->[0]->getSequenceType();
        $fasta->setParams({output_directory=>$path,
                           file=>$name,
                           output_types=>$input_type,
                           collection=>$splitCollection});
        $fasta->export();
        push @$files,$name;
    }
    $self->{'file_names'} = $files;
 
}


=head1 GETTER & SETTER METHODS

=head2 B<setParams(hash-ref)>

Sets all parameter by hash of form
{ parameter_name => parameter_value }

=cut

sub setParams{
    my ($self,$params) = @_;
    foreach(keys(%$params)){
        $self->{$_} = $params->{$_};
    }
}


=head2 B<getNextSequenceFile()>

Returns the path/name of the next sequence file in list of 
all files created by createFile().
Returns 0 if all files have been returned.
Starts at the beginning of the list if called again.

=cut

sub getNextSequenceFile{
    my $self = shift;
    if($self->{'fileCount'}){
	if(($self->{'fileCount'}+1)<scalar(@{$self->{'splitFiles'}})){
	    $self->{'fileCount'} = $self->{'fileCount'}+1;
	    return @{$self->{'splitFiles'}}[$self->{'fileCount'}];
	}
	else{
	    $self->{'fileCount'} = undef;
	    return 0;
	}
    }
    else{
	$self->{'fileCount'} = 0;	
	return @{$self->{'splitFiles'}}[$self->{'fileCount'}];
    }
}
    

=head2 returnFileNames

Returns the names of all created fasta files

=cut

sub returnFileNames{
    my $self = shift;
    $self->{'logger'}->LogError("FileScheduler::returnFileNames() - No known result files.") unless $self->{'file_names'};
    return $self->{'file_names'};
}


=head1 INTERNAL METHODS

=head2 B<_split(hash-ref,int)>
Splits collection into sub collections based on number of cpu's utilized
=cut


sub _split{
    my ($collection,$self) = @_;
    my $number = $self->{'max'};
    # initialize the resulting array of collection objects
    my @result = ();
    my $counter = 0;
    #Splits $collection into X number of subcollections stored in an array.
    while(my $seq = $collection->getNextElement()){
        if ($counter == $number){$counter=0;}
        
        if (ref $result[$counter]){
            my $element = $result[$counter];
	    $element->addElement($collection->getElementByID($seq->{'id'}));    
        }
        else{
	    my $element = GePan::Collection::Sequence->new();
	    $element->addElement($collection->getElementByID($seq->{'id'}));
	    $result[$counter] = $element;
	}
	#$self->{'logger'}->LogWarning(Dumper($result[$counter]));
        $counter++;
    }
    return \@result;
    
}

=head2 B<_getFileName()>

Returns unique file-name for fasta file dependend on sequence type

File names are: filename.XXX where XXX = count 

=cut

sub _getFileName{
    my ($input,$path) = @_;

    my $counter = 1;

    # get name of input file
    my @split = split("/",$input);
    my $file = $split[-1];

    while(-f ($path."/".$file.".".$counter)){
	$counter++;
    } 
    return ($file.".".$counter);
}

=head2 B<setLogger(GePan::Logger)>

Sets GePan::Logger object.

=cut

sub setLogger{
    my ($self,$l) = @_;
    $self->{'logger'} = $l;
}

### No sort function skips sorting. Not done yet
#sub _nosort{
#    my $collection = shift;
#    my @result = ();
#    foreach (@{$collection->getList()}){push @results, $_;}
#    return \@result; 

#}

1;
