#!/bin/bash

root=$(dirname $0)
CONTAINERS=("postgis" "redis" "maps-api" "sql-api" "carto")

for container in ${CONTAINERS[@]}; do
    sudo $root"/start/"$container".sh"
done
