package GePan::Config;

=head1 NAME

GePan::Common

=head1 DESCRIPTION

Package for storing needed paths, e.g. path to blast, fasta etc

=head1 EXPORTED CONSTANTS

BLAST_PATH : path to blastall

FASTA_PATH : path to executables of the fasta package, e.g. fasta35,fastx ...

PFAM_PATH : path to hmmsearch

MGA_PATh : path to MetaGeneAnnotator

GLIMMER3_PATH : path to glimmer3

DATABASE_PATH : path to database directory (with sub-directories pfam and uniprot)

=cut
use strict;
use base qw(Exporter);

use constant GEPAN_PATH=>'/home/uitgalaxy/local/lib/metapipe';
use constant BLAST_PATH=>'/global/apps/blast/2.2.29/bin/blastp';
use constant PFAM_PATH=>'/global/apps/hmmer/3.0/bin/hmmscan';
use constant FASTA_PATH=>'/global/apps/fasta/36.3.4/bin/fasta36';
use constant MGA_PATH=>'/home/uitgalaxy/local/lib/metapipe/deps/mga/mga_linux_ia64';
use constant GLIMMER3_PATH=>'/home/uitgalaxy/local/lib/metapipe/deps/glimmer-scripts';
use constant SIGNALP_PATH=>'/home/uitgalaxy/local/lib/metapipe/deps/signalp/signalp-3.0/signalp';
#use constant DATABASE_PATH=>'/home/uitgalaxy/local/lib/metapipe/bio_databases';
use constant DATABASE_PATH=>'/global/work/uitgalaxy/share/bio_databases';
use constant PERL_PATH=>'/usr/bin/perl';
use constant NODE_LOCAL_PATH=>'/global/work/uitgalaxy/tmp/metapipe';
use constant PYTHON_PATH=>'/global/apps/python/2.7.3/bin/python2.7';
use constant GESTORE_PATH=>'';
use constant GESTORE_CONFIG=>'';
use constant BLAST2XML_PATH=>'';


use constant PRIAM_BLAST_PATH=>'/global/apps/blast/2.2.19/bin';
use constant PHOBIUS_PATH=>'/home/uitgalaxy/local/lib/phobius/phobius.pl';
use constant PRIAM_PATH=>'/home/uitgalaxy/local/bin/priam';
use constant PRIAM_RELEASE_PATH=>'/home/uitgalaxy/local/share/priam/PRIAM_OCT14';
use constant INTERPRO_PATH=>'/home/uitgalaxy/local/lib/interproscan/interproscan.sh';

our @EXPORT_OK=qw(INTERPRO_PATH BLAST_PATH FASTA_PATH PFAM_PATH MGA_PATH GLIMMER3_PATH DATABASE_PATH SIGNALP_PATH PERL_PATH GEPAN_PATH NODE_LOCAL_PATH PYTHON_PATH GESTORE_CONFIG GESTORE_PATH BLAST2XML_PATH PRIAM_PATH PRIAM_RELEASE_PATH PRIAM_BLAST_PATH PHOBIUS_PATH);

1;
