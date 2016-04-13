#!/bin/bash

cd /Windshaft-cartodb
node app.js development &

cd /CartoDB-SQL-API
node app.js development &

cd /cartodb20
RAILS_ENV=development bundle exec script/resque \
    > resque.log 2> resque_err.log &

RAILS_ENV=development bundle exec thin start --threaded -p 3000 --threadpool-size 5 \
    > carto.log 2> carto_err.log &
