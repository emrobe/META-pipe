#!/bin/bash
source env/bin/activate
source /home/ira005/gepan/source_me.sh

export GEPAN_RUNNER_CMD=/home/ira005/gepan/integration/gepan
export GEPAN_GALAXY_LOG_DIR=/home/ira005/lwr/log/gepan

cd lwr
sh run.sh
