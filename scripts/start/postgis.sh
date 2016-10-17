#!/bin/bash

WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $WORKING_DIR/../utils/general.sh
source $WORKING_DIR/../utils/params.sh

container_name="postgis"
entry="$WORKING_DIR/../../postgis/run-container.sh"

sudo $entry -n $container_name \
            -v $postgres_storage \
            -u $postgres_user \
            -p $postgres_password \
            -d $postgres_database
