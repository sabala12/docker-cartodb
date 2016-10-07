#!/bin/bash

WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source $WORKING_DIR/utils/docker.sh

killContainer "redis" true
killContainer "postgis" true
killContainer "setup" true
killContainer "carto" true
