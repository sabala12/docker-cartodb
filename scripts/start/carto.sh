#!/bin/bash

POSTGIS_RUNNING=$(sudo docker inspect --format="{{ .State.Running }}" postgis 2> /dev/null)

if [[ $POSTGIS_RUNNING == "true" ]]; then
    exit 0
fi

root="/path to postgis parent dir/"
name="postgis"
persistent_storage="/data/postgis"
user_name="panda"
pass="itry2"

sudo $root"/postgis/run-postgis-docker.sh" -n $name -v $persistent_storage -u $user_name -p $pass
