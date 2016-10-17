#!/bin/bash

WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $WORKING_DIR/../scripts/utils/general.sh
source $WORKING_DIR/../scripts/utils/docker.sh

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

validateAndExit()
{
    sql_test="select case when true then 'true' end;"
    sql_result=$(psql -U $PGUSER -h "localhost" -c "$sql_test" 2> /dev/null)
    
    if [[ "$sql_result" =~ .*true.* ]]; then
        exit 0
    else
        echo "failed to establish database connection!"
        echo "user=$PGUSER"
        echo "database=$DATABASE"
        exit 3
    fi
}

setVolume()
{
    local __argc=2
    checkArgs $FUNCNAME $__argc $#

    local __path=$1
    local __result=$2

    if [[ -f $__path ]]; then
        echo "$__path is a file!"
        exit 1
    fi
    
    if [[ ! -d $__path ]]; then
        mkdir $__path
    fi
    chmod a+w $__path

    __volume_opt="-v ${VOLUME}:/var/lib/postgresql"
    set $__result $__volume_opt
}

waitForContainer()
{
    read line <$container_pipe

    sleep 2
    sudo docker exec ${CONTAINER_NAME} service postgresql restart
    echo "1" >$script_pipe
}

createPipe()
{
    local __argc=1
    checkArgs $FUNCNAME $__argc $#

    local __pipe=$1

    if [[ -e $__pipe ]]; then
        rm $__pipe
    fi

    trap "rm -f $__pipe" EXIT

    if [[ ! -p $__pipe ]]; then
        mkfifo $__pipe
    else
        echo "failed to create pipe at $__pipe"
        exit 2
    fi
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

checkOption CONTAINER_NAME
checkOption VOLUME
checkOption PGUSER
checkOption PGPASSWORD
checkOption DATABASE

export PGPASSWORD=$PGPASSWORD

containerStatus $CONTAINER_NAME container_status &> /dev/null

if [[ "$container_status" == "running" ]]; then
    validateAndExit
fi

killContainer $CONTAINER_NAME false

setVal VOLUME_OPTION "-v $VOLUME:/var/lib/postgresql"

mkdir -p $VOLUME

script_pipe=${VOLUME}/script_sock
container_pipe=${VOLUME}/container_sock
createPipe $script_pipe
createPipe $container_pipe

waitForContainer &
sleep 1

CMD="sudo docker run --name="${CONTAINER_NAME}" \
                     ${VOLUME_OPTION} \
                     --restart=always \
                     --net=host \
                     -e POSTGRES_USER=${PGUSER} \
                     -e POSTGRES_PASS=${PGPASSWORD} \
                     -e POSTGRES_DATABASE=${DATABASE} \
                     -it \
                     carto:postgis"

echo "********************"
echo "      postgis       "
echo "********************"

eval $CMD
read line<$script_pipe
