#!/bin/bash

STORAGE="/data/postgis"

if [[ -d $STORAGE ]]; then
        sudo rm -r $STORAGE
else
        if [[ ! -e $STORAGE ]]; then
                echo "$STORAGE does not exist!"
        fi
fi
