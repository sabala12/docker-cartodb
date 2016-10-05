#!/bin/bash

if ! test -n "$CARTODB_BASE_PATH"; then
        echo "Base path is not set."
        echo "Add 'export CARTODB_BASE_PATH=...' to ~/.profile and run 'source ~/.profile'."
        exit 1;
fi

entry="$CARTODB_BASE_PATH/postgis/run-container.sh"

if [[ ! -e $entry ]]; then
        echo "cannot find $entry."
        echo "check 'CARTODB_BASE_PATH' env value."
        exit 1
fi

container_name="postgis"
persistent_storage="/data/postgis"
user_name="postgres"
pass="475909"
database="carto_db_development"

sudo $entry -n $container_name \
            -v $persistent_storage \
            -u $user_name \
            -p $pass \
            -d $database
