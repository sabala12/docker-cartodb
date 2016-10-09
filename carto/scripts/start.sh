#!/bin/bash

if [[ -z ${CARTO_DOMAIN} ]]; then
        echo "CARTO_DOMAIN is not set!"
        exit 1
fi

bash

#TODO: python script to edit config files
cd /Windshaft-cartodb
node app.js ${CARTO_DOMAIN} > windshaft.log 2> windshaft.err &

cd /CartoDB-SQL-API
node app.js ${CARTO_DOMAIN} > cartodb_sql_api.log 2> cartodb_sql_api.err &

cd /cartodb20
RAILS_ENV=${CARTO_DOMAIN} bundle exec script/resque > resque.log 2> resque_err.log &

RAILS_ENV=${CARTO_DOMAIN} bundle exec thin start --threaded -p 3000 --threadpool-size 5 > carto.log 2> carto.err &

bash
