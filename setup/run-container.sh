#!/bin/bash

source ./../scripts/utils/general.sh
source ./../scripts/utils/docker.sh

usage()
{
cat << EOF
usage: $0 options

This script runs a new docker cartodb setup instance for you.

OPTIONS:
   -h      show this message
   -n      container name
   -a      postgres address
   -b      postgres password
EOF
}

while getopts ":h:n:a:b:" OPTION
do
     case $OPTION in
         n)
             CONTAINER_NAME=${OPTARG}
             ;;
         a)
             POSTGRES_ADDRESS=${OPTARG}
             ;;
         b)
             POSTGRES_PASSWORD=${OPTARG}
             ;;
         *)
             usage
             exit 1
             ;;
     esac
done

check_option "container_name" $CONTAINER_NAME

kill_container $CONTAINER_NAME

sudo docker start $
