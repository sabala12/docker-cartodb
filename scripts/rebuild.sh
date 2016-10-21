#!/bin/bash

WORKING_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

cd $WORKING_DIR/../base && ./build.sh
cd $WORKING_DIR/../setup && ./build.sh
cd $WORKING_DIR/../carto && ./build.sh
