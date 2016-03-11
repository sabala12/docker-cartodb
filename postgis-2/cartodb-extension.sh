#!/bin/bash

# Install cartodb extension
cd /home && git clone https://github.com/CartoDB/cartodb-postgresql
git fetch --tags
latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
cd ./cartodb-postgresql && git checkout 0.14.0
make all install                     
PGUSER=postgres make installcheck
