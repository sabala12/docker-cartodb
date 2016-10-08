#!/bin/bash

root=$(dirname $0)

$root/start/redis.sh
$root/start/postgis.sh
$root/start/setup.sh
