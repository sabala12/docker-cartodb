#!/bin/bash

root=$(dirname $0)
CONTAINERS=("postgis" "redis" "maps-api" "sql-api" "carto")

for container in ${CONTAINERS[@]}; do
    sudo $root/exec.sh stop $container
    sudo $root/exec.sh rm $container
done

