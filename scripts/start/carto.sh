#!/bin/bash

root="/path to postgis parent dir/"

sudo docker run --name="carto" --link postgis:postgis --link redis:redis --link maps-api:maps-api --link sql-api:sql-api cartodb/cartodb:latest
