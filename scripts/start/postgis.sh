#!/bin/bash

container_name="postgis"
persistent_storage="/data/postgis"
user_name="postgres"
pass="475909"
database="carto_db_development"

sudo ~/Projects/carto-db/postgis/run-postgis-docker.sh -n $container_name -v $persistent_storage -u $user_name -p $pass -d $database
