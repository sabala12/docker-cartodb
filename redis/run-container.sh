#!/bin/bash

WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $WORKING_DIR/../scripts/utils/general.sh
source $WORKING_DIR/../scripts/utils/docker.sh

usage()
{
cat << EOF
usage: $0 options

This script runs a new redis instance for you.

OPTIONS:
   -h      show this message
   -n      container name
EOF
}

while getopts ":h:n:" OPTION
do
     case $OPTION in
         n)
             CONTAINER_NAME=${OPTARG}
             ;;
         *)
             usage
             exit 1
             ;;
     esac
done

checkOption CONTAINER_NAME

killContainer $CONTAINER_NAME false

CMD="sudo docker run --name="${CONTAINER_NAME}" \
                     --net=host
                     -itd \
                     redis:latest"
eval $CMD
