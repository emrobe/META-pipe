#!/bin/sh
#Starts Gepan

/opt/local/perl5122/bin/perl startGePan.pl -w /home/emr023/sekvensdata/Marzymes/MiSeq_Tromsoe -f /home/emr023/sekvensdata/Marzymes/MiSeq_Tromsoe/$1 -p "glimmer3;blastp;pfam;priam" -T nucleotide -t "bacteria,all" -S contig -q 32 -o 3
