#!/bin/bash

root="/path to postgis parent dir/"

CMD="sudo docker run --name="carto" \
    --link redis:redis --link postgis:postgis \
    --link sql-api:sql-api --link maps-api:maps-api \
    -p 3000:3000 \
    -it \
    cartodb/cartodb:latest"

echo 'Running cartodb'
echo $CMD
eval $CMD
