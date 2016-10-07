#!/bin/bash

root=$(dirname $0)

sudo $root/start/postgis.sh
sudo $root/start/setup.sh
