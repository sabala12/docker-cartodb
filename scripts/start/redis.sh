#!/bin/bash

persistent_storage="/data/redis"

sudo docker run --name="redis" -v $persistent_storage:/data -p 6379:6379 -it -d cartodb/redis:latest
