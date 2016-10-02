#!/bin/bash

usage()
{
cat << EOF
usage: $0 options

This script runs a new postgis container.

OPTIONS:
   -h      Show this message
   -n      Container name
   -v      Volume to mount the Postgres cluster into
   -u      Postgres user name
   -p      Postgres password
   -d      Postgres defaults database (defaults to 'postgres')
EOF
}

test_connection()
{
    echo "user=$PGUSER"
    echo "database=$DATABASE"
    echo "password=$PGPASSWORD"
    sql_test="select case when true then 'true' end;"
    sql_result=$(psql -U $PGUSER -d $DATABASE -h 127.0.0.1 -c "$sql_test" 2> /dev/null)
    
    if [[ "$sql_result" =~ .*true.* ]]; then
        return 1
    else
        echo "enable to establish connection."
        return 0
    fi
}

validate_and_exit()
{
    test_connection
    local connection_status=$?
    if [[ connection_status -ne 1 ]]; then
        echo "failed to established database connection"
    fi
    exit 0
}

make_pipe()
{
    trap "rm -f $1" EXIT

    if [[ ! -p $1 ]]; then
            mkfifo $1
    fi
}

wait_for_container()
{
    read line <$container_pipe

    sleep 2
    sudo docker exec ${CONTAINER_NAME} service postgresql restart
    echo "1" >$pipe
}

while getopts ":h:n:v:u:p:d:" OPTION
do
     case $OPTION in
         n)
             CONTAINER_NAME=${OPTARG}
             ;;
         v)
             VOLUME=${OPTARG}
             ;;
         u)
             PGUSER=${OPTARG}
             ;;
         p)
             PGPASSWORD=${OPTARG}
             ;;
         d)
             DATABASE=${OPTARG}
             ;;
         *)
             usage
             exit 1
             ;;
     esac
done

export PGPASSWORD=$PGPASSWORD
RUNNING=$(sudo docker inspect --format="{{ .State.Running }}" $CONTAINER_NAME 2> /dev/null)
if [[ "$RUNNING" == "true" ]]; then
    echo "container $CONTAINER_NAME already running!"
    validate_and_exit
fi

# make sure container does not exist
sudo docker rm -f $CONTAINER_NAME &> /dev/null

echo "configuring parameters..."
if [[ -z $VOLUME ]] || [[ -z $CONTAINER_NAME ]] || [[ -z $PGUSER ]] || [[ -z $PGPASSWORD ]]; then
     usage
     exit 1
fi

if [[ ! -z $VOLUME ]]; then
    VOLUME_OPTION="-v ${VOLUME}:/var/lib/postgresql"
else
    echo "missing VOLUME option!"
    exit 1
fi

if [[ -f $VOLUME ]]; then
    echo "$VOLUME cannot be a file!"
    exit 1
fi

if [[ ! -d $VOLUME ]]; then
    mkdir $VOLUME
fi
chmod a+w $VOLUME

pipe=/tmp/script_sock
container_pipe=${VOLUME}/container_sock

if [[ -e $pipe ]]; then
    rm $pipe
fi

if [[ -e $container_pipe ]]; then
    rm $container_pipe
fi

make_pipe $pipe
make_pipe $container_pipe

wait_for_container &
sleep 1

#--hostname="${CONTAINER_NAME}" \
CMD="sudo docker run --name="${CONTAINER_NAME}" \
        ${VOLUME_OPTION} \
        --restart=always \
        --net=host \
        -e POSTGRES_USER=${PGUSER} \
        -e POSTGRES_PASS=${PGPASSWORD} \
        -e POSTGRES_DATABASE=${DATABASE} \
        -it \
        postgis:latest"

eval $CMD
read line <$pipe
