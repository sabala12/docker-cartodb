#!/bin/bash

source /usr/local/lib/utils.sh

checkOption NET_DOMAIN
checkOption CARTO_DOMAIN
checkOption CARTO_HOST
checkOption POSTGRES_ADDRESS
checkOption POSTGRES_PASSWORD

# Edit config files
editConfigs

# Start Windshaft
cd /Windshaft-cartodb
forever start app.js ${CARTO_DOMAIN} &> /dev/null &

# Start Sql-Api
cd /CartoDB-SQL-API
forever start app.js ${CARTO_DOMAIN} &> /dev/null &

# Start Carto
cd /cartodb20
RAILS_ENV=${CARTO_DOMAIN} bundle exec script/resque > resque.log &

RAILS_ENV=${CARTO_DOMAIN} bundle exec thin start --threaded -p 3000 --threadpool-size 5 > carto.log &

bash
