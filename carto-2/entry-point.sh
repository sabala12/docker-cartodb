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

echo "Init metadata database"
/bin/bash -l -c "cd $CARTODB_DIR && RAILS_ENV=development bundle exec rake db:migrate"

#echo "Setup admin user"
#/bin/bash -l -c "$CARTODB_DIR/script/setup_user"

#echo "Start editor"
#/bin/bash -l -c "RAILS_ENV=development bundle exec rails server &"

#echo "Start resque process"
#/bin/bash -l -c "RAILS_ENV=development bundle exec ./script/resque &"

export CARTO_LOG=/var/log/cartodb
export SUBDOMAIN=development

mkdir $CARTO_LOG
touch $CARTO_LOG/rails-server.log
touch $CARTO_LOG/rails-server-error.log
touch $CARTO_LOG/resque.log

touch $CARTO_LOG/resque-error.log
echo "127.0.0.1 ${SUBDOMAIN}.localhost.lan" | sudo tee -a /etc/hosts

/bin/bash -l -c "$CARTODB_DIR/script/create_dev_user"

/bin/bash -l -c "bundle exec script/resque \
    > $CARTO_LOG/rails-server.log 2> $CARTO_LOG/rails-server-error.log &"

/bin/bash -l -c "bundle exec thin start --threaded -p 3000 --threadpool-size 5 \
    > $CARTO_LOG/resque.log 2> $CARTO_LOG/resque-error.log"

/bin/bash
