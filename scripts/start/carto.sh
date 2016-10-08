#!/bin/bash

WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $WORKING_DIR/../utils/general.sh

dir_name="carto"
container_name="carto"
domain="development"
postgis_ip=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' postgis)
postgis_password=475909

setEntry $dir_name entry

sudo $entry -n $container_name \
            -d $domain \
            -a $postgis_ip \
            -b $postgis_password
