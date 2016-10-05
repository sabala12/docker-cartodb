#!/bin/bash

if ! test -n "$CARTODB_BASE_PATH"; then
        echo "Base path is not set."
        echo "Add 'export CARTODB_BASE_PATH=...' to ~/.profile and run 'source ~/.profile'."
        exit 1;
fi

entry="$CARTODB_BASE_PATH/redis/run-container.sh"

if [[ ! -e $entry ]]; then
        echo "cannot find $entry."
        echo "check 'CARTODB_BASE_PATH' env value."
        exit 1
fi

container_name="redis"

sudo $entry -n $container_name
