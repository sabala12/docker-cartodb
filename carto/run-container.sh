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
   -e      host machine name
   -o      run off the internet
   -a      postgres address
   -b      postgres password
EOF
}

while getopts ":h:n:d:e:o:a:b:" OPTION
do
     case $OPTION in
         n)
             CONTAINER_NAME=${OPTARG}
             ;;
         d)
             DOMAIN=${OPTARG}
             ;;
         e)
             HOST=${OPTARG}
             ;;
         o)
             OFFLINE=${OPTARG}
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
checkOption HOST
checkOption OFFLINE
checkOption POSTGRES_ADDRESS
checkOption POSTGRES_PASSWORD

killContainer $CONTAINER_NAME true

CMD="sudo docker run --name="${CONTAINER_NAME}" \
                     --net=host \
                     --restart=always \
                     -e CARTO_DOMAIN=${DOMAIN} \
                     -e CARTO_HOST=${HOST} \
                     -e CARTO_OFFLINE=${OFFLINE} \
                     -e POSTGRES_ADDRESS=${POSTGRES_ADDRESS} \
                     -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
	             -it \
	             carto:carto"

echo "********************"
echo "       carto        "
echo "********************"

eval $CMD
