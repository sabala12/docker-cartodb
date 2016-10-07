#!/bin/bash

WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $WORKING_DIR/utils/docker.sh

kill_container "redis" "true"
kill_container "postgis" "true"
kill_container "setup" "true"
kill_container "carto" "true"
