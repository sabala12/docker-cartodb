#!/bin/bash


cd $CARTODB_DIR

# Setup redis address
redis_6379_addr=$REDIS_PORT_6379_TCP_ADDR
redis_6335_addr=$REDIS_PORT_6335_TCP_ADDR
sed -i 's/REDIS_PORT_6379_TCP_ADDR/'$REDIS_PORT_6379_TCP_ADDR'/g' ./config/app_config.yml
sed -i 's/REDIS_PORT_6335_TCP_ADDR/'$REDIS_PORT_6335_TCP_ADDR'/g' ./config/app_config.yml

# Setup postgis address
sed -i 's/POSTGIS_PORT_5432_TCP_ADDR/'$POSTGIS_PORT_5432_TCP_ADDR'/g' ./config/database.yml

# Setup maps-api address
sed -i 's/MAPS_API_PORT_8181_TCP_ADDR/'$MAPS_API_PORT_8181_TCP_ADDR'/g' ./config/app_config.yml

# Setup sql-api address
sed -i 's/SQL_API_PORT_8080_TCP_ADDR/'$SQL_API_PORT_8080_TCP_ADDR'/g' ./config/app_config.yml

RAILS_ENV=development bundle exec rake db:migrate

RAILS_ENV=development bundle exec rake db:setup_user

#RAILS_ENV=development bundle exec rails server >& /dev/null &

RAILS_ENV=development bundle exec ./script/resque >& /dev/null &

#####################################################################
export SUBDOMAIN=development

# Add entries to /etc/hosts needed in development
echo "127.0.0.1 ${SUBDOMAIN}.localhost.lan" | sudo tee -a /etc/hosts

# Create a development user
sh script/create_dev_user ${SUBDOMAIN}

bundle exec script/resque >& /dev/null &

bundle exec thin start --threaded -p 3000 --threadpool-size 5

/bin/bash
