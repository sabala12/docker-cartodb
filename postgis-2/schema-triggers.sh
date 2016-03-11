#!/bin/bash

# Install schema_triggers
cd /home && git clone https://github.com/CartoDB/pg_schema_triggers.git
cd ./pg_schema_triggers && make all install
sed -i "/#shared_preload/a shared_preload_libraries = 'schema_triggers.so'" /etc/postgresql/9.3/main/postgresql.conf
