#!/bin/bash

cd /cartodb
bundle exec script/resque &
bundle exec rails s -p $PORT
