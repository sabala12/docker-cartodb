#!/bin/bash

WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $WORKING_DIR/../utils/general.sh

dir_name="carto"
container_name="carto"
user_name="development"
password="277336"
domain="development"
email="sabalah21@gmail.com"
organization="org"
postgis_ip=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' postgis)
postgis_password=475909

setEntry $dir_name entry

sudo $entry -n $container_name \
            -u $user_name \
            -p $password \
            -d $domain \
            -e $email \
            -a $postgis_ip \
            -b $postgis_password
