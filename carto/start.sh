#!/bin/bash


#################### Setup Addresses ##################################
#sed -i 's/REDIS_PORT_6379_TCP_ADDR/'$REDIS_PORT_6379_TCP_ADDR'/g' /cartodb20/config/app_config.yml
#sed -i 's/REDIS_PORT_6335_TCP_ADDR/'$REDIS_PORT_6335_TCP_ADDR'/g' /cartodb20/config/app_config.yml
sed -i 's/POSTGIS_PORT_5432_TCP_ADDR/'$POSTGIS_PORT_5432_TCP_ADDR'/g' /cartodb20/config/database.yml
########################################################################

service varnish start

cd /Windshaft-cartodb
node app.js development &

cd /CartoDB-SQL-API
node app.js development &

cd /cartodb20
export SUBDOMAIN="development"
export PASSWORD="no_more"
export EMAIL="sabalah21@gmail.com"

echo "127.0.0.1 ${SUBDOMAIN}.localhost.lan" | tee -a /etc/hosts

/bin/bash
#sh script/create_dev_user ${SUBDOMAIN} ${PASSWORD} ${EMAIL}

#RAILS_ENV=development bundle exec script/resque \
#    > resque.log 2> resque_err.log &
#
#sleep 5
#
#RAILS_ENV=development bundle exec thin start --threaded -p 3000 --threadpool-size 5 \
#    > carto.log 2> carto_err.log &
