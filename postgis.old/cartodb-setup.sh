#!/bin/bash
#
# Init script for template postgis
#

POSTGIS_SQL_PATH=`pg_config --sharedir`/contrib/postgis-2.1.2;
psql -d template_postgis -c "CREATE USER publicuser WITH NOCREATEROLE NOCREATEDB NOSUPERUSER;"
psql -d template_postgis -c "CREATE USER tileuser WITH NOCREATEROLE NOCREATEDB NOSUPERUSER;"

psql -d template_postgis -c "CREATE LANGUAGE plpgsql;"
psql -d template_postgis -c "UPDATE pg_database SET datistemplate='true' \
      WHERE datname='template_postgis'"
psql -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;"
psql -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"
psql -d template_postgis -c "CREATE EXTENSION plpythonu;"
psql -d template_postgis -c "CREATE EXTENSION schema_triggers;"

psql -d template_postgis -c "CREATE EXTENSION cartodb;"
