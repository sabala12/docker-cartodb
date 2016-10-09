#!/bin/bash

WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $WORKING_DIR/../scripts/utils/general.sh
source $WORKING_DIR/../scripts/utils/docker.sh

usage()
{
cat << EOF
usage: $0 options

This script runs a new docker cartodb setup instance for you.

OPTIONS:
-h      show this message
-n      container name
-u      carto user name
-p      carto password
-d      carto domain
-e      mail address
-a      postgres address
-b      postgres password
EOF
}

while getopts ":h:n:u:p:d:e:a:b:" OPTION
do
     case $OPTION in
         n)
             CONTAINER_NAME=${OPTARG}
             ;;
         u)
             USER=${OPTARG}
             ;;
         p)
             PASSWORD=${OPTARG}
             ;;
         d)
             DOMAIN=${OPTARG}
             ;;
         e)
             EMAIL=${OPTARG}
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
checkOption USER
checkOption PASSWORD
checkOption DOMAIN
checkOption EMAIL

killContainer $CONTAINER_NAME true

CMD="sudo docker run --name="${CONTAINER_NAME}" \
                     --network=host \
                     --restart=always \
                     -e CARTO_USER=${USER} \
                     -e CARTO_PASSWORD=${PASSWORD} \
                     -e CARTO_DOMAIN=${DOMAIN} \
                     -e CARTO_EMAIL=${EMAIL} \
                     -e POSTGRES_ADDRESS=${POSTGRES_ADDRESS} \
                     -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} \
                     -it \
                     carto:setup"

echo "********************"
echo "       setup        "
echo "********************"

eval $CMD
