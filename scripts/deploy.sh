#!/bin/bash

root=$(dirname $0)
CONTAINERS=("redis" "postgis" "sql-api" "maps-api" "carto")

$root"/kill_all.sh"

echo -e "\nfinish removing old containers"

for container in ${CONTAINERS[@]}; do
    echo -e "\ndeploing $container"
    sudo $root"/start/"$container".sh"
done
