#!/bin/bash

usage()
{
cat << EOF
usage: $0 options

This script runs a new docker cartodb instance for you.

OPTIONS:
   -h      show this message
   -n      container name
   -v      volume to mount the cartodb into
   -u      carto user name
   -p      carto password
   -a      redis address
   -b      postgres address
   -c      postgres password
EOF
}

check_option()
{
    if [[ -z $1 ]]; then
        echo "option $0 no set"
        usage
        exit 1
    fi
}

while getopts ":h:n:v:u:p:a:b:c:" OPTION
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
         a)  
             REDIS_ADDRESS=${OPTARG}
             ;;
         b)  
             POSTGRES_ADDRESS=${OPTARG}
             ;;
         c)
             POSTGRES_PASS=${OPTARG}
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
check_option "redis address" $REDIS_ADDRESS
check_option "postgres address" $POSTGRES_ADDRESS
check_option "postgres password" $POSTGRES_PASS

RUNNING=$(docker inspect --format="{{ .State.Running }}" $CONTAINER_NAME 2> /dev/null)
if [[ "$RUNNING" == "true" ]]; then
    echo "Container $CONTAINER_NAME already running!"
    echo -n -e "Enter 'y' to kill old container, or something else to exit.\n"; read kill_container
    if [[ "$kill_container" == "y" ]]; then
        echo -n "killing $CONTAINER_NAME"
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

docker_host=$(hostname -I | cut -f1 -d' ')
CMD="sudo docker run --name="${CONTAINER_NAME}" \
        --hostname="${CONTAINER_NAME}" \
        --add-host dockerhost:"$docker_host" \
        --restart=always \
	-e CARTO_USER=${USER} \
	-e CARTO_PASS=${PASSWORD} \
	-e REDIS_ADDRESS=${REDIS_ADDRESS} \
	-e POSTGRES_ADDRESS=${POSTGRES_ADDRESS} \
	-e POSTGRES_PASS=${POSTGRES_PASS} \
        --link redis:redis \
        --link postgis:postgis \
        -p 3000:3000 \
        -p 8080:8080 \
        -p 8181:8181 \
	-it \
	cartodb/cartodb:latest"

echo 'Running cartodb'
eval $CMD
