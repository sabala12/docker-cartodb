#!/bin/bash

WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
VOLUME_CONFS="-v $WORKING_DIR/opt:/home/opt"
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
   -v      Volume to mount the Postgres cluster into
EOF
}

while getopts ":h:n:v:" OPTION
do
     case $OPTION in
         n)
             CONTAINER_NAME=${OPTARG}
             ;;
         v)
             VOLUME=${OPTARG}
             ;;
         *)
             usage
             exit 1
             ;;
     esac
done

checkOption CONTAINER_NAME
checkOption VOLUME

containerStatus $CONTAINER_NAME container_status &> /dev/null
setVal VOLUME_OPTION "-v $VOLUME:/var/lib/redis"

mkdir -p $VOLUME

if [[ "$container_status" == "running" ]]; then
    exit 0
fi

killContainer $CONTAINER_NAME false

CMD="sudo docker run --name="${CONTAINER_NAME}" \
                     $VOLUME_OPTION \
                     $VOLUME_CONFS \
                     --restart=always \
                     --net=host
                     -itd \
                     carto:redis /home/opt/start.sh"

echo "********************"
echo "       redis        "
echo "********************"

eval $CMD
