#!/bin/bash

WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $WORKING_DIR/../utils/general.sh
source $WORKING_DIR/../utils/params.sh

container_name="carto"
entry="$WORKING_DIR/../../carto/run-container.sh"

sudo $entry -n $container_name \
            -c $net_domain \
            -d $carto_domain \
            -e $carto_host \
            -a $postgres_address \
            -b $postgres_password
