#!/bin/bash

cd /Windshaft-cartodb
node app.js ${CARTO_DOMAIN} &

cd /CartoDB-SQL-API
node app.js ${CARTO_DOMAIN} &

cd /cartodb20
RAILS_ENV=${CARTO_DOMAIN} bundle exec script/resque \
    > resque.log 2> resque_err.log &

RAILS_ENV=${CARTO_DOMAIN} bundle exec thin start --threaded -p 3000 --threadpool-size 5 \
    > carto.log 2> carto_err.log &
