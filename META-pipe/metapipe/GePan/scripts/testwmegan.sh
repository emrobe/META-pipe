#!/bin/sh
#Starts Gepan
/opt/local/perl5122/bin/perl startGePan.pl -w /home/emr023/sekvensdata/muddyDNA/ -f /home/emr023/sekvensdata/muddyDNA/subset100k.fas -p "null;blastn;megan" -T nucleotide -S read -q 32 -o 3
