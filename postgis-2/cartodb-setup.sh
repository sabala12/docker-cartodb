#!/bin/bash
#
# Init script for template postgis
#

POSTGIS_SQL_PATH=`pg_config --sharedir`/contrib/postgis-2.1.2;
psql -d template_postgis -c "CREATE USER publicuser WITH NOCREATEROLE NOCREATEDB NOSUPERUSER;"
psql -d template_postgis -c "CREATE USER tileuser WITH NOCREATEROLE NOCREATEDB NOSUPERUSER;"

psql -d template_postgis -c "CREATE EXTENSION plpythonu;"
psql -d template_postgis -c "CREATE EXTENSION schema_triggers;"
psql -d template_postgis -c "CREATE EXTENSION cartodb;"
