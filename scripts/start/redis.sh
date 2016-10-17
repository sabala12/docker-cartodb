#!/bin/bash

WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $WORKING_DIR/../utils/general.sh
source $WORKING_DIR/../utils/params.sh

container_name="redis"
entry="$WORKING_DIR/../../redis/run-container.sh"

sudo $entry -n $container_name
