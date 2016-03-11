#!/bin/bash


#################### Setup Addresses ##################################
cd /cartodb

redis_6379_addr=$REDIS_PORT_6379_TCP_ADDR
redis_6335_addr=$REDIS_PORT_6335_TCP_ADDR
sed -i 's/REDIS_PORT_6379_TCP_ADDR/'$REDIS_PORT_6379_TCP_ADDR'/g' ./config/app_config.yml
sed -i 's/REDIS_PORT_6335_TCP_ADDR/'$REDIS_PORT_6335_TCP_ADDR'/g' ./config/app_config.yml

sed -i 's/POSTGIS_PORT_5432_TCP_ADDR/'$POSTGIS_PORT_5432_TCP_ADDR'/g' ./config/database.yml

sed -i 's/MAPS_API_PORT_8181_TCP_ADDR/'$MAPS_API_PORT_8181_TCP_ADDR'/g' ./config/app_config.yml

sed -i 's/SQL_API_PORT_8080_TCP_ADDR/'$SQL_API_PORT_8080_TCP_ADDR'/g' ./config/app_config.yml
########################################################################

bash -l -c "cd /cartodb && bash script/create_dev_user || bash script/create_dev_user && bash script/setup_organization.sh"

PORT=3000

service varnish start

cd /Windshaft-cartodb
node app.js development &

cd /CartoDB-SQL-API
node app.js development &

cd /cartodb
source /usr/local/rvm/scripts/rvm

/bin/bash
bundle exec script/restore_redis
bundle exec script/resque > resque.log 2>&1 &
bundle exec rails s -p $PORT
