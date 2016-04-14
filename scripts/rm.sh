#!/bin/bash

sudo rm -r /data/*
sudo docker rm -f postgis
sudo docker rm -f redis
sudo docker rm -f carto
