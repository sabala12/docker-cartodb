#!/bin/bash

r1=$(psql -lqt -U postgres -h localhost | cut -d \| -f 1 | grep -w no)
r2=$(psql -lqt -U postgres -h localhost | cut -d \| -f 1 | grep -w carto_db_development)

if [[ -n $r1 ]]; then
        echo "r1=$r1"
fi

if [[ -n $r2 ]]; then
        echo "r2=$r2"
fi
