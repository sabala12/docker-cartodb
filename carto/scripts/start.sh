#!/bin/bash

read -t 4 -p "Enter 'n' to exit.\n" EXIT;
if [[ "$EXIT" == "n" ]]; then
        bash
else
        # edit configs if postgis address and ip are set
        
        /cartodb20/script/run-services.sh ${CARTO_DOMAIN}
fi
