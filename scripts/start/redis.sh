#!/bin/bash

user_name="development"
pass="no_more"

sudo docker run --name="redis" -p 6335:6335 -p 6379:6379 -it -d cartodb/redis:latest -v $persistent_storage -u $user_name -p $pass
