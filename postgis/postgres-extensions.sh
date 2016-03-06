#!/bin/bash

# Install cartodb extension
cd /home && git clone https://github.com/CartoDB/cartodb-postgresql                                                                                                                       
cd ./cartodb-postgresql && git checkout master                                                                                                                                            
make all install                                                                                                                                                                          
PGUSER=postgres make installcheck

# Install schema_triggers
cd /home && git clone https://github.com/CartoDB/pg_schema_triggers.git
cd ./pg_schema_triggers && make all install
sed -i "/#shared_preload/a shared_preload_libraries = 'schema_triggers.so'" /etc/postgresql/9.3/main/postgresql.conf
