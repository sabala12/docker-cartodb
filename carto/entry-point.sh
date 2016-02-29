#!/bin/bash

cd $CARTODB_DIR
sed -i 's/REDIS_TCP_ADDR/$REDIS_PORT_6379_TCP_ADDR/g' ./config/app_config.yml

/bin/bas

echo "executing db:migrate"
RAILS_ENV=development bundle exec rake db:migrate

echo "executing db:setup_user"
RAILS_ENV=development bundle exec rake db:setup_user

echo "executing rails server"
RAILS_ENV=development bundle exec rails server

echo "executing ./script/resque"
RAILS_ENV=development bundle exec ./script/resque

bundle exec script/resque &
bundle exec rails s -p $PORT

