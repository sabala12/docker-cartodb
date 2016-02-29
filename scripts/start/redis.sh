#!/bin/bash

root="/path to redis parent dir/"
user_name="panda"
pass="itry2"

sudo docker run --name="redis" -d cartodb/redis:latest -v $persistent_storage -u $user_name -p $pass
