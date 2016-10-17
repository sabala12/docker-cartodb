#!/bin/bash

WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $WORKING_DIR/../utils/general.sh
source $WORKING_DIR/../utils/params.sh

container_name="setup"
entry="$WORKING_DIR/../../setup/run-container.sh"

sudo $entry -n $container_name \
            -d $carto_domain \
            -u $carto_user \
            -p $carto_password \
            -e $carto_email \
            -a $postgres_address \
            -b $postgres_password
