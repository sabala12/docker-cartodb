#!/bin/bash

root=$(dirname $0)

sudo $root/start/redis.sh
sudo $root/start/postgis.sh
sudo $root/start/carto.sh
