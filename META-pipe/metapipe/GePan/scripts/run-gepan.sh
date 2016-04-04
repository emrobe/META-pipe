#!/bin/sh
#Starts Gepan
/opt/local/perl5122/bin/perl startGePan.pl -w /home/emr023/sekvensdata/Inhouse/ -f /home/emr023/sekvensdata/Inhouse/ut.fas -p "mga;blastp;pfam;priam" -T nucleotide -S contig -q 8 -o 3
