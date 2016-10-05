#!/bin/bash

source ./utils.sh

container_status()
{
        local argc=2
        check_args $FUNCNAME $argc $#
                
        local CONTAINER_NAME=$1
        local __RESULT_VAR=$2

        RUNNING=$(docker inspect --format="{{ .State.Running }}" $CONTAINER_NAME 2> /dev/null)

        if [ $? -eq 1 ]; then
                set_val "$__RESULT_VAR" "unknown"
                return
        fi

        if [[ "$RUNNING" == "true" ]]; then
                set_val "$__RESULT_VAR" "running"
                return
        else
                set_val "$__RESULT_VAR" "stopped"
                return
        fi
}

kill_container()
{
        local argc=1
        check_args $FUNCNAME $argc $#

        local CONTAINER_NAME=$1
        local CONTAINER_STATUS=$2
        container_status $CONTAINER_NAME

        if [[ "$CONTAINER_STATUS" == "unknown" ]]; then
                return
        fi

        echo "$CONTAINER_NAME is $CONTAINER_STATUS."
        echo -n -e "Enter y to kill the container, or else to continue.\n"; read KILL_CONTAINER

        if [[ "$KILL_CONTAINER" == "y" ]]; then
                if [[ "$KILL_CONTAINER" == "y" ]]; then
                        sudo docker stop $CONTAINER_NAME
                fi 

                sudo docker rm $CONTAINER_NAME
        fi
}
