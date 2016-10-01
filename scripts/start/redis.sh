#!/bin/bash

persistent_storage="/data/redis"

sudo docker run --name="redis" \
                --net=host \
                -v $persistent_storage:/data \
                -itd \
                redis:latest
