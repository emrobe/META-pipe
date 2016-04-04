#!/bin/sh
#Starts Gepan
/opt/local/perl5122/bin/perl startGePan.pl -w /home/emr023/sekvensdata/ -f /home/emr023/sekvensdata/KMM429concat.fna -p "glimmer3;blastp;pfam;priam" -T nucleotide -S contig -q 20 -o 1b
