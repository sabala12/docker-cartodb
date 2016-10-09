#!/bin/bash

WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $WORKING_DIR/../scripts/utils/general.sh
source $WORKING_DIR/../scripts/utils/docker.sh

usage()
{
cat << EOF
usage: $0 options

This script runs a new docker cartodb instance for you.

OPTIONS:
   -h      show this message
   -n      container name
   -d      carto domain
   -a      postgres address
   -b      postgres password
EOF
}

while getopts ":h:n:d:a:b:" OPTION
do
     case $OPTION in
         n)
             CONTAINER_NAME=${OPTARG}
             ;;
         d)
             DOMAIN=${OPTARG}
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

checkOption CONTAINER_NAME
checkOption DOMAIN

killContainer $CONTAINER_NAME true

CMD="sudo docker run --name="${CONTAINER_NAME}" \
                     --network=host \
                     --restart=always \
                     -e CARTO_DOMAIN=${DOMAIN} \
                     -e POSTGRES_ADDRESS=${POSTGRES_ADDRESS} \
                     -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
	             -it \
	             carto:carto"

echo "********************"
echo "       carto        "
echo "********************"

eval $CMD
