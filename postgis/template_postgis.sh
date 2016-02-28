#!/bin/bash
#
# Init script for template postgis
#

createdb -T template0 -O postgres -U postgres -E UTF8 template_postgis
createlang plpgsql -U postgres -d template_postgis
psql -U postgres template_postgis -c 'CREATE EXTENSION postgis;CREATE EXTENSION postgis_topology;CREATE EXTENSION schema_triggers;'
sudo ldconfig
