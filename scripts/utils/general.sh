#!/bin/bash

checkArgs()
{
        local __argc=3
        if [[ "$__argc" -gt "$#" ]]; then
                $FUNCNAME $FUNCNAME $__argc $#
        fi

        local __function_name=$1
        local __expected_args=$2
        local __real_args=$3

        if [[ "$__expected_args" -gt "$__real_args" ]]; then
                echo "$__function_name(): wrong number of arguments"
                echo "$__function_name(): expected $__expected_args, actual $__real_args"
                exit 1
        fi
}

setVal() 
{
        local __argc=2
        checkArgs $FUNCNAME $__argc $#

        local __result_var=$1
        local __result_val=$2
        eval "$__result_var='$__result_val'"
}

printErr()
{
        local __argc=2
        checkArgs $FUNCNAME $__argc $#

        local __err_msg=$1
        local __exit_code=$2

        echo $__err_msg
        local __err=$(declare -f usage > /dev/null; echo $?)
        if [[ $__err == "0" ]]; then
                usage
        fi

        exit $__exit_code
}

checkOption()
{
        local __argc=1
        
        if [[ $# -lt "1" ]]; then
                printErr "option is not set!" 1
        fi
        
        local __value=$(echo "${!1}")
        if [[ -z ${__value} ]]; then
                printErr "option $1 is not set!" 1
        fi
}

#setEntry()
#{
#        local __argc=2
#        checkArgs $FUNCNAME $__argc $#
#
#        local __dir_name=$1
#        local __result=$2
#
#        if ! test -n "$CARTODB_BASE_PATH"; then
#                echo "\$CARTODB_BASE_PATH is not set"
#                exit 1;
#        fi
#        
#        local __entry="$CARTODB_BASE_PATH/$__dir_name/run-container.sh"
#        
#        if [[ ! -e $__entry ]]; then
#                echo "cannot find $__entry."
#                echo "check 'CARTODB_BASE_PATH' env is set correctly."
#                exit 1
#        else
#                setVal $__result $__entry
#        fi
#}
