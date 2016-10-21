#!/bin/bash

WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $WORKING_DIR/general.sh

stopContainer()
{
        local __argc=1
        checkArgs $FUNCNAME $__argc $#

        local __container_name=$1
        sudo docker stop $__container_name &> /dev/null
}

rmContainer()
{
        local __argc=1
        checkArgs $FUNCNAME $__argc $#

        local __container_name=$1
        sudo docker rm -f $__container_name &> /dev/null
}

containerStatus()
{
        local __argc=2
        checkArgs $FUNCNAME $__argc $#
                
        local __container_name=$1
        local __result=$2

        local __running=$(sudo docker inspect --format="{{ .State.Running }}" $__container_name 2> /dev/null)
        if [[ "$__running" == "true" ]]; then
                setVal $__result "running"

        elif [[ "$__running" == "stopped" ]]; then
                setVal $__result "stopped"

        else
                setVal $__result "unknown"

        fi
}

killContainer()
{
        local __argc=2
        checkArgs $FUNCNAME $__argc $#

        local __container_name=$1
        local __always=$2

        containerStatus $__container_name __container_status

        if [[ "$__container_status" == "unknown" ]]; then
                rmContainer $__container_name
                return
        fi

        if [[ "$__always" == "true" ]]; then
                local __kill_container="y"
        else
                echo -n -e "Enter y to kill $__container_name, or else to continue.\n"; read __kill_container
        fi

        if [[ "$__kill_container" == "y" ]]; then
                sudo docker rm -f $__container_name
                #if [[ "$__container_status" == "running" ]]; then
                #        stopContainer $__container_name
                #fi 

                #rmContainer $__container_name
        fi
}
