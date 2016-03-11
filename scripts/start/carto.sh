#!/bin/bash

root="/path to postgis parent dir/"

CMD="sudo docker run --name="carto" \
    --link redis:redis --link postgis:postgis \
    -p 3000:3000 \
    -it \
    cartodb/cartodb:latest"

echo 'Running cartodb'
echo $CMD
eval $CMD
