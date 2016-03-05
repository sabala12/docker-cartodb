#!/bin/bash

# Install cartodb extension

cd /home
git clone https://github.com/CartoDB/cartodb-postgresql
cd cartodb-postgresql
git fetch --tags
export latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
git checkout master
make all install

PGUSER=postgres make installcheck >> /home/log.txt
/bin/bash
