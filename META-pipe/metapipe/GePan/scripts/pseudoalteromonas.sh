#!/bin/sh
#Starts Gepan
/opt/local/perl5122/bin/perl startGePan.pl -w /home/emr023/5x5delivery -f /home/emr023/5x5delivery/All_Mapped_Bin_Pseudoalteromonas.fna -p "glimmer3;blastp;pfam;priam" -T nucleotide -S contig -q 10 -o 1b
