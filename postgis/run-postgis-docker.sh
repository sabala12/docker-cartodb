#!/bin/bash
# Commit and redeploy the user map container

usage()
{
cat << EOF
usage: $0 options

This script runs a new docker postgis instance for you.
To get the image run:
docker pull kartoza/postgis


OPTIONS:
   -h      Show this message
   -n      Container name
   -v      Volume to mount the Postgres cluster into
   -u      Postgres user name (defaults to 'docker')
   -p      Postgres password  (defaults to 'docker')
   -d      Postgres defaults database (defaults to 'postgres')
EOF
}

test_connection()
{
    IPADDRESS=`docker inspect $CONTAINER_NAME | grep IPAddress | grep -o '[0-9\.]*'`
    echo "ip=$IPADDRESS"
    echo "user=$PGUSER"
    echo "database=$DATABASE"
    echo "password=$PGPASSWORD"
    sql_test="select case when true then 'true' end;"
    echo "trying to estabish connection..."
    sql_result=$(psql -U $PGUSER -d $DATABASE -h $IPADDRESS -c "$sql_test")
    
    if [[ "$sql_result" =~ .*true.* ]]; then
        return 1
    else
        return 0
    fi
}

validate_and_exit()
{
    test_connection
    local connection_status=$?
    if [[ connection_status -ne 1 ]]; then
        echo "failed to established connection to database ):"
    else
        echo "good to go (:"
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
    echo "listen to pipe=$container_pipe"
    while read line <$container_pipe
    do
        if [[ "$line" == 'postgres_up' ]]; then
                break
        else
                echo "unknown message $line"
        fi
    done

    sleep 1
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
RUNNING=$(docker inspect --format="{{ .State.Running }}" $CONTAINER_NAME 2> /dev/null)
if [[ "$RUNNING" == "true" ]]; then
    echo "container $CONTAINER_NAME already running!"
    validate_and_exit
fi

# make sure container does not exist
sudo docker rm $CONTAINER_NAME >& /dev/null

echo "configuring parameters..."
if [[ -z $VOLUME ]] || [[ -z $CONTAINER_NAME ]] || [[ -z $PGUSER ]] || [[ -z $PGPASSWORD ]] 
then
     usage
     exit 1
fi

if [[ ! -z $VOLUME ]]
then
    VOLUME_OPTION="-v ${VOLUME}:/var/lib/postgresql"
else
    echo "missing VOLUME option!"
    exit 1
fi

if [ ! -d $VOLUME ]
then
    mkdir $VOLUME
fi
chmod a+w $VOLUME

pipe=/tmp/script_sock
container_pipe=${VOLUME}/container_sock
make_pipe $pipe
make_pipe $container_pipe

wait_for_container &
sleep 1

CMD="sudo docker run --name="${CONTAINER_NAME}" \
        --hostname="${CONTAINER_NAME}" \
        --restart=always \
	-e POSTGRES_USER=${PGUSER} \
	-e POSTGRES_PASS=${PGPASSWORD} \
        -e POSTGRES_DATABASE=${DATABASE} \
        -p 5432:5432 \
	-it \
        ${VOLUME_OPTION} \
	cartodb/postgis:latest /start-postgis.sh"

echo $CMD
eval $CMD

echo "listen to pipe=$pipe"
while read line <$pipe
do
    sleep 1
    if [[ "$line" == '1' ]]; then
        echo "good to go (:"
        break
    fi
    echo "unknown replay $line"
done
