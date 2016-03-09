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
    echo "trying to estabish connection..."
    echo "ip=$IPADDRESS"
    echo "user=$PGUSER"
    echo "database=$DATABASE"
    echo "password=$PGPASSWORD"
    sql_test="select case when true then 'true' end;"
    sql_result=$(psql -h $IPADDRESS -U $PGUSER -d $DATABASE -c "$sql_test")
    
    if [[ "$sql_result" =~ .*true.* ]]; then
        return 1
    else
        echo "second shoot"
        sleep 10
        sudo docker exec ${CONTAINER_NAME} service postgresql restart
        sql_result=$(psql -h $IPADDRESS -U $PGUSER -d $DATABASE -c "$sql_test")
        if [[ "$sql_result" =~ .*false.* ]]; then
            return 0
        else
            return 1
        fi
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
#echo "Connect using:"
#echo "psql -l -p 5432 -h $IPADDRESS -U $PGUSER"
#echo "and password $PGPASSWORD"
    fi
    exit 0
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
IPADDRESS=`docker inspect $CONTAINER_NAME | grep IPAddress | grep -o '[0-9\.]*'`
RUNNING=$(docker inspect --format="{{ .State.Running }}" $CONTAINER_NAME 2> /dev/null)
echo $RUNNING
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
    VOLUME_OPTION=""
fi

if [ ! -d $VOLUME ]
then
    mkdir $VOLUME
fi
chmod a+w $VOLUME

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

IPADDRESS=`docker inspect $CONTAINER_NAME | grep IPAddress | grep -o '[0-9\.]*'`
validate_and_exit
