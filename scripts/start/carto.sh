#!/bin/bash

container_name="carto"
persistent_storage="/data/cartodb"
user_name="development"
password="277336"
domain="development"
email="sabalah21@gmail.com"
organization="org"
#postgis_password=475909
#postgis_ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' postgis)

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
#                                              -b $postgis_ip \
#                                              -c $postgis_password
