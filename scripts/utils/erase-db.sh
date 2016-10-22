#!/bin/bash

WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $WORKING_DIR/general.sh
source $WORKING_DIR/params.sh

erase()
{
        local __argc=1
        checkArgs $FUNCNAME $__argc $#

        local __storage=$1
        if [[ -d $__storage ]]; then
                sudo rm -r $__storage
        else
                if [[ ! -e $__storage ]]; then
                        echo "$__storage does not exist!"
                fi
        fi
}

erase $postgres_storage
erase $redis_storage
