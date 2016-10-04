#!/bin/bash

usage()
{
cat << EOF
usage: $0 options

This script runs a new docker cartodb instance for you.

OPTIONS:
   -h      show this message
   -n      container name
   -v      carto data volume
   -u      carto user name
   -p      carto password
   -d      carto domain
   -e      mail address
   -a      postgres address
   -b      postgres password
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

while getopts ":h:n:v:u:p:d:e:a:b:" OPTION
do
     case $OPTION in
         n)
             CONTAINER_NAME=${OPTARG}
             ;;
         v)
             VOLUME=${OPTARG}
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

check_option "container_name" $CONTAINER_NAME
check_option "volume" $VOLUME
check_option "user" $USER
check_option "password" $PASSWORD
check_option "domain" $DOMAIN
check_option "email" $EMAIL

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

if [ ! -d $VOLUME ]; then
    mkdir $VOLUME
fi
chmod a+w $VOLUME

#docker_host=$(hostname -I | cut -f1 -d' ')
#--hostname="${CONTAINER_NAME}" \
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
	             carto:latest"

eval $CMD
