#!/bin/bash

CMD="sudo docker run --name="carto" \
    --link postgis:postgis \
    --link redis:redis \
    -p 3000:3000 \
    -p 8080:8080 \
    -p 8181:8181 \
    -it \
    cartodb/cartodb:latest"

echo 'Running cartodb'
echo $CMD
eval $CMD
