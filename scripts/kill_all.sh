#!/bin/bash

root=$(dirname $0)
CONTAINERS=("redis" "sql-api" "maps-api" "carto")

for container in ${CONTAINERS[@]}; do
    
    RUNNING=$(sudo docker inspect --format="{{ .State.Running }}" $container >& /dev/null)

    if [[ $RUNNING == "true" ]]; then
        echo "stoping $container"
        sudo docker stop -f $container >& /dev/null
        sudo docker rm -f $container >& /dev/null
    else
        sudo docker rm -f $container >& /dev/null
    fi

    echo "$container was removed"

done
