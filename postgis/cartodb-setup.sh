#!/bin/bash
#
# Init script for template postgis
#

POSTGIS_SQL_PATH=`pg_config --sharedir`/contrib/postgis-2.1.2;
psql -U postgres -d template_postgis -c "CREATE USER publicuser WITH NOCREATEROLE NOCREATEDB NOSUPERUSER;"
psql -U postgres -d template_postgis -c "CREATE USER tileuser WITH NOCREATEROLE NOCREATEDB NOSUPERUSER;"

psql -U postgres -d template_postgis -c "CREATE EXTENSION plpythonu;"
psql -U postgres -d template_postgis -c "CREATE EXTENSION schema_triggers;"
psql -U postgres -d template_postgis -c "CREATE EXTENSION cartodb;"

#git fetch --tags
#export latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
