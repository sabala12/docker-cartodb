#!/bin/bash

kill_container()
{
        CONTAINER=$1
        
        RUNNING=$(sudo docker inspect --format="{{ .State.Running }}" $CONTAINER 2> /dev/null)
        
        if [ $? -eq 1 ]; then
          return
        fi
        
        if [ "$RUNNING" == "true" ]; then
          sudo docker stop $CONTAINER &> /dev/null
        fi
        
        sudo docker rm $CONTAINER &> /dev/null
}

kill_container redis
kill_container postgis
kill_container carto
