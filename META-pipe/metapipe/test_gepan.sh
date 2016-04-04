#!/bin/sh
if [ "$GEPAN_HOME" = "" ]; then
    echo "Error: Environment variable GEPAN_HOME is missing." >&2
    exit 1
fi

sh $GEPAN_HOME/start_metapipe.sh -w $GEPAN_WORK_DIR -f $PWD/test_input/small.fas -p "mga;blastp;pfam" -T nucleotide -S contig -t "bacteria,all" -q 2 -o 3  -P -R "$@"
