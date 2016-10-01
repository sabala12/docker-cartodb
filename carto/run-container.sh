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
   -o      organization
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

while getopts ":h:n:v:u:p:d:e:o:" OPTION
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
         o)
             ORGANIZATION=${OPTARG}
             ;;
         *)
             usage
             exit 1
             ;;
     esac
done

check_option "volume" $VOLUME
check_option "container_name" $CONTAINER_NAME
check_option "user" $USER
check_option "password" $PASSWORD
check_option "domain" $DOMAIN
check_option "email" $EMAIL
check_option "organiztion" $ORGANIZATION
#check_option "redis address" $REDIS_ADDRESS
#check_option "postgres address" $POSTGRES_ADDRESS
#check_option "postgres password" $POSTGRES_PASS

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
#--add-host dockerhost:"$docker_host" \
        #--link redis:redis \
        #--link postgis:postgis \
#--hostname="${CONTAINER_NAME}" \

#	             -e REDIS_ADDRESS=${REDIS_ADDRESS} \
#	             -e POSTGRES_ADDRESS=${POSTGRES_ADDRESS} \
#	             -e POSTGRES_PASS=${POSTGRES_PASS} \
#docker_host_address=$(hostname)
#-e DOCKER_HOST_ADDRESS=${docker_host_address} \
CMD="sudo docker run --name="${CONTAINER_NAME}" \
                     --network=host \
                     --restart=always \
	             -e CARTO_USER=${USER} \
	             -e CARTO_PASSWORD=${PASSWORD} \
                     -e CARTO_DOMAIN=${DOMAIN} \
                     -e CARTO_EMAIL=${EMAIL} \
                     -e CARTO_ORGANIZATION=${ORGANIZATION} \
	             -it \
	             carto:latest"

eval $CMD
