#!/bin/bash

WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $WORKING_DIR/../utils/general.sh

dir_name="postgis"
container_name="postgis"
persistent_storage="/data/postgis"
user_name="postgres"
pass="475909"
database="carto_db_development"

setEntry $dir_name entry

sudo $entry -n $container_name \
            -v $persistent_storage \
            -u $user_name \
            -p $pass \
            -d $database
