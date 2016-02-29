#!/bin/bash

cd $CARTODB_DIR

RAILS_ENV=development bundle exec rake db:migrate
RAILS_ENV=development bundle exec rake db:setup_user

RAILS_ENV=development bundle exec rails server
RAILS_ENV=development bundle exec ./script/resque

bundle exec script/resque &
bundle exec rails s -p $PORT
