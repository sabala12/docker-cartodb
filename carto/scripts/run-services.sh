#!/bin/bash

if test -n "$1"; then
        DOMAIN="$1"
else
        echo -n "Enter a domain: "; read DOMAIN
fi

cd /Windshaft-cartodb
node app.js ${DOMAIN} &

cd /CartoDB-SQL-API
node app.js ${DOMAIN} &

cd /cartodb20
RAILS_ENV=${DOMAIN} bundle exec script/resque \
    > resque.log 2> resque_err.log &

RAILS_ENV=${DOMAIN} bundle exec thin start --threaded -p 3000 --threadpool-size 5 \
    > carto.log 2> carto_err.log &
