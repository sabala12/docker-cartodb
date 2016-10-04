#!/bin/bash

if ! test -n "$CARTODB_BASE_PATH"; then
        echo "Base path is not set."
        echo "Add 'export CARTODB_BASE_PATH=...' to ~/.profile and run 'source ~/.profile'."
        exit 1;
fi

entry="$CARTODB_BASE_PATH/carto/run-container.sh"

if [[ ! -e $entry ]]; then
        echo "cannot find $entry."
        echo "check 'CARTODB_BASE_PATH' env value."
        exit 1
fi

container_name="carto"
persistent_storage="/data/cartodb"
user_name="development"
password="277336"
domain="development"
email="sabalah21@gmail.com"
organization="org"
postgis_ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' postgis)
postgis_password=475909

sudo $entry -n $container_name \
            -v $persistent_storage \
            -u $user_name \
            -p $password \
            -d $domain \
            -e $email \
            -a $postgis_ip \
            -b $postgis_password
