#!/bin/bash

source /usr/local/lib/utils.sh

checkOption "CARTO_DOMAIN"
checkOption "CARTO_HOST"
checkOption "CARTO_OFFLINE"
checkOption "POSTGRES_ADDRESS"
checkOption "POSTGRES_PASSWORD"

if [[ "$CARTO_OFFLINE" == "true" ]]; then
        setOfflineConfig
fi

setPostgresConfig

cd /Windshaft-cartodb
node app.js ${CARTO_DOMAIN} &> /dev/null &

cd /CartoDB-SQL-API
node app.js ${CARTO_DOMAIN} &> /dev/null &

cd /cartodb20
RAILS_ENV=${CARTO_DOMAIN} bundle exec script/resque > resque.log &

RAILS_ENV=${CARTO_DOMAIN} bundle exec thin start --threaded -p 3000 --threadpool-size 5 > carto.log &

bash
