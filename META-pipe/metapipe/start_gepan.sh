#!/bin/sh
if [ "$GEPAN_HOME" = "" ]; then
    echo "Error: Environment variable GEPAN_HOME is missing." >&2
    exit 1
fi

#source /opt/gridengine/default/common/settings.sh

/usr/bin/perl -I $GEPAN_HOME $GEPAN_HOME/GePan/scripts/startGePan.pl $@
