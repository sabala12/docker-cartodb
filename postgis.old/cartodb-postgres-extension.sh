#!/bin/bash

# Install schema_triggers
cd /home && git clone https://github.com/CartoDB/pg_schema_triggers.git
cd ./pg_schema_triggers && make all install
sed -i "/#shared_preload/a shared_preload_libraries = 'schema_triggers.so'" /etc/postgresql/9.3/main/postgresql.conf

# Install cartodb extension
#cd /home
#git clone --recursive https://github.com/CartoDB/cartodb
#cd cartodb
#git checkout 3.12.3
#cd lib/sql
#make all install
#PGUSER=postgres make installcheck

cd /home
git clone https://github.com/CartoDB/cartodb-postgresql.git
cd cartodb-postgresql
git checkout 0.11.5
make all install
PGUSER=postgres make installcheck
