#!/bin/bash

name="postgis"
persistent_storage="/data/postgis"
user_name="postgres"
pass="no_more"
database="carto_db_development"

sudo ~/Projects/carto-db/postgis/run-postgis-docker.sh -n $name -v $persistent_storage -u $user_name -p $pass -d $database
