#!/bin/bash

container_name="carto"
persistent_storage="/data/cartodb"
user_name="development"
password="277336"
domain="development"
email="example@gmail.com"
organization="development"
#postgis_pass=475909
#redis_ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' redis)
#postgis_ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' postgis)

#if [[ -z $redis_ip ]]; then
#    echo "no redis ip!"; exit 0
#fi
#
#if [[ -z $postgis_ip ]]; then
#    echo "no postgis ip!"; exit 0
#fi

sudo ~/Dev/docker-cartodb/carto/run-container.sh -n $container_name \
                                                 -v $persistent_storage \
                                                 -u $user_name \
                                                 -p $password \
                                                 -d $domain \
                                                 -e $email \
                                                 -o $organization
#                                              -a $redis_ip \
#                                              -b $postgis_ip \
#                                              -c $postgis_pass
