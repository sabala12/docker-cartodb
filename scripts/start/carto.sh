#!/bin/bash

container_name="carto"
persistent_storage="/data/cartodb"
user_name="development"
password="277336"
redis_ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' redis)
postgis_ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' postgis)
postgis_pass=475909

if [[ -z $redis_ip ]]; then
    echo "no redis ip!"; exit 0
fi

if [[ -z $postgis_ip ]]; then
    echo "no postgis ip!"; exit 0
fi

sudo ~/Projects/carto-db/carto/run-cartodb.sh -n $container_name \
                                              -v $persistent_storage \
                                              -u $user_name \
                                              -p $password \
                                              -a $redis_ip \
                                              -b $postgis_ip \
                                              -c $postgis_pass
