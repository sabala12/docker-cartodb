#!/bin/bash

CONTAINERS=("postgis" "redis" "maps-api" "sql-api" "carto")
ACTIONS=("stop" "rm")

validContainer () {
    local e
    for e in ${CONTAINERS[@]}; do [[ "$e" == "$1" ]] && return 1; done
    echo "only '${CONTAINERS[@]}' containers names are allowed!"
    exit 0
}

validAction () {
    local e
    for e in ${ACTIONS[@]}; do [[ "$e" == "$1" ]] && return 1; done
    echo "only '${ACTIONS[@]}' actions are allowed!"
    exit 0
}

printHelp () {
    echo -e "argument              options\n"
    echo "action                ${ACTIONS[@]}"
    echo "container             ${CONTAINERS[@]}"
}

if [[ $1 == "--help" ]]; then
    printHelp
    exit 0
fi

if [[ $# -ne 2 ]]; then
    printHelp
    exit 0
fi

ACTION=$1
CONTAINER_NAME=$2
validContainer $CONTAINER_NAME
validAction $ACTION

echo "exec $ACTION on $CONTAINER_NAME"
sudo docker $ACTION $CONTAINER_NAME >& /dev/null
