#!/bin/bash

check_args()
{
        local argc=3
        if [[ "$argc" -gt "$#" ]]; then
                $FUNCNAME $FUNCNAME $argc $#
        fi

        local FUNCTION_NAME=$1
        local EXPECTED_ARGS=$2
        local REAL_ARGS=$3

        if [[ "$EXPECTED_ARGS" -gt "$REAL_ARGS" ]]; then
                echo "$FUNCTION_NAME(): wrong number of arguments"
                echo "$FUNCTION_NAME(): expected $EXPECTED_ARGS, actual $REAL_ARGS"
                exit 1
        fi
}

set_val() 
{
        local argc=2
        check_args $FUNCNAME $argc $#

        local __SET_VAL_RESULT_VAR=$1
        local __SET_VAL_RESULT_VALUE=$2
        eval "$__SET_VAL_RESULT_VAR='$__SET_VAL_RESULT_VALUE'"
}

check_option()
{
        local argc=2
        check_args $FUNCNAME $argc $#
        
        local OPT_NAME=$1
        local OPT_VALUE=$2
        if [[ -z $OPT_VALUE ]]; then
                echo "option $OPT_NAME no set"
                usage
                exit 1
        fi
}
