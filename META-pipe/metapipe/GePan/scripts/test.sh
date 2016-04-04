#!/bin/sh
#Starts Gepan
/opt/local/perl5122/bin/perl startGePan.pl -w /home/emr023/sekvensdata/Inhouse/ -f /home/emr023/sekvensdata/Inhouse/all_contigs_MabCent_linux_corrected.fas -p "mga;blastp;pfam;priam" -T nucleotide -S contig -q 20 -o 3
