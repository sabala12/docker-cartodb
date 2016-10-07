#!/bin/bash

WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $WORKING_DIR/../utils/general.sh

dir_name="redis"
container_name="redis"

setEntry $dir_name entry

sudo $entry -n $container_name
