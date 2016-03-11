#!/bin/bash

root=$(dirname $0)
CONTAINERS=("redis" "carto")
#CONTAINERS=("redis" "postgis" "carto")

$root"/kill_all.sh"

echo -e "\nfinish removing old containers"

for container in ${CONTAINERS[@]}; do
    sudo $root"/start/"$container".sh"
done
