#To install/Configure GePan:
#1. Set GEPAN_PATH in Config.pm to your local GePan directory
#2. Set use lib='PATH'; in scripts/startGePan.pl to your local perl library
#
#Create a file called '.gitignore' and add these lines (if it is not already
#present):
Config.pm

#Execute:
git rm --cached Config.pm
#to untrack the current Config.pm file

#This tells git to skip syncing/commiting of Config.pm, so your configurations wont be
#messing up the repository Config.pm, and subsequently other users Config.pm.
#Config.pm is accessable through the virgin-branch in the local repository.

#------------------------------------------------------------------------------

#If any new paths are created, f.ex by adding a new tool, add them to this list
#so users easily can add them to their untracked Config.pm
#Paths as of Oct 22 2012 (-EmR):
use constant BLAST_PATH=>'/share/apps/gepan/share/blast/blastall';
use constant PFAM_PATH=>'/opt/local/hmmer30rc2/binaries/hmmscan';
use constant FASTA_PATH=>'/opt/bio/fasta/fasta36';
use constant MGA_PATH=>'/share/apps/gepan/share/mga/mga_linux_ia64';
use constant GLIMMER3_PATH=>'/opt/bio/glimmer/scripts';
use constant SIGNALP_PATH=>'/share/apps/gepan/share/signalp/signalp-3.0/signalp';
use constant DATABASE_PATH=>'/share/apps/gepan/bio_databases';
use constant PERL_PATH=>'/opt/local/perl5122/bin/perl';
use constant GEPAN_PATH=>'';
use constant NODE_LOCAL_PATH=>'/state/partition1';
use constant PRIAM_PATH=>'/opt/local/PRIAM_search.jar';
use constant PRIAM_RELEASE_PATH=>'/share/apps/gepan/bio_databases/priam/PRIAM_OCT11';
use constant PRIAM_BLAST_PATH=>'/opt/bio/ncbi/bin';
use constant MEGAN_PATH=>'NOT INSTALLED LOCALLY YET';
use constant KRONA_PATH=>'/opt/local/kronatools20/bin';
use constant GESTORE_PATH=>'/share/apps/gestore/diffdb.jar';
use constant GESTORE_CONFIG=>'/share/apps/gestore/gestore-conf.xml';
use constant BLAST2XML_PATH=>'/opt/local/python27/bin/python /share/apps/gestore/flatfileToXml.py';

#Remember to include the new path in our @EXPORT_OK.
