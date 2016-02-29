#!/bin/bash

name="postgis"
persistent_storage="/data/postgis"
user_name="panda"
pass="I_HATE_THIS_PLACE"

sudo ~/Projects/carto-db/postgis/run-postgis-docker.sh -n $name -v $persistent_storage -u $user_name -p $pass
