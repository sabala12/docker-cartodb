#!/bin/bash

cd $CARTODB_DIR

#################### Setup Addresses ##################################

redis_6379_addr=$REDIS_PORT_6379_TCP_ADDR
redis_6335_addr=$REDIS_PORT_6335_TCP_ADDR
sed -i 's/REDIS_PORT_6379_TCP_ADDR/'$REDIS_PORT_6379_TCP_ADDR'/g' ./config/app_config.yml
sed -i 's/REDIS_PORT_6335_TCP_ADDR/'$REDIS_PORT_6335_TCP_ADDR'/g' ./config/app_config.yml

sed -i 's/POSTGIS_PORT_5432_TCP_ADDR/'$POSTGIS_PORT_5432_TCP_ADDR'/g' ./config/database.yml

sed -i 's/MAPS_API_PORT_8181_TCP_ADDR/'$MAPS_API_PORT_8181_TCP_ADDR'/g' ./config/app_config.yml

sed -i 's/SQL_API_PORT_8080_TCP_ADDR/'$SQL_API_PORT_8080_TCP_ADDR'/g' ./config/app_config.yml


##################### Configure CartoDB ################################

/bin/bash

RAILS_ENV=development bundle exec rake db:migrate
RAILS_ENV=development bundle exec rake db:setup

echo "creating setup user..."
sh script/setup_user
echo "creating dev user..."]
sh script/create_dev_user

export CARTO_LOG=/var/log/cartodb
mkdir $CARTO_LOG
touch $CARTO_LOG/rails-server.log
touch $CARTO_LOG/rails-server-error.log
touch $CARTO_LOG/resque.log
touch $CARTO_LOG/resque-error.log

##################### Run CartoDB #######################################

export SUBDOMAIN=development

# Add entries to /etc/hosts needed in development
echo "127.0.0.1 ${SUBDOMAIN}.localhost.lan" | sudo tee -a /etc/hosts

RAILS_ENV=development bundle exec script/resque \
    > $CARTO_LOG/rails-server.log 2> $CARTO_LOG/rails-server-error.log &

RAILS_ENV=development bundle exec thin start --threaded -p 3000 --threadpool-size 5 \
    > $CARTO_LOG/resque.log 2> $CARTO_LOG/resque-error.log

