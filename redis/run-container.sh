#!/bin/bash

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

check_option()
{
    if [[ -z $2 ]]; then
        echo "option $1 no set"
        usage
        exit 1
    fi
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

check_option "container_name" $CONTAINER_NAME

RUNNING=$(docker inspect --format="{{ .State.Running }}" $CONTAINER_NAME 2> /dev/null)
if [[ "$RUNNING" == "true" ]]; then
    echo "Container $CONTAINER_NAME already running!"
    echo -n -e "Enter 'y' to kill old container, or something else to exit.\n"; read kill_container
    if [[ "$kill_container" == "y" ]]; then
        sudo docker rm -f $CONTAINER_NAME >& /dev/null
    else
        echo -n "goodbey (:"
        exit 0
    fi
fi

CMD="sudo docker run --name="${CONTAINER_NAME}" \
                     --net=host
                     -itd \
                     redis:latest"
eval $CMD
