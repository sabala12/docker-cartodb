#!/bin/bash
#
# Init script for template postgis
#

createdb -T template0 -O postgres -U postgres -E UTF8 template_postgis
psql -d template_postgis -c "CREATE EXTENSION postgis;"
psql -d template_postgis -c "CREATE EXTENSION postgis_topology;"
psql -d template_postgis -c "CREATE EXTENSION plpythonu;"
#psql -d postgres -c "UPDATE pg_database SET datistemplate='true' \
#  WHERE datname='template_postgis'"
#psql -d template_postgis -c "CREATE EXTENSION cartodb;"
#psql -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;"
#psql -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"
#psql -d template_postgis -c "CREATE EXTENSION schema_triggers;"
#psql -d template_postgis -c "SELECT datname FROM pg_database WHERE datistemplate = false;"
#psql -U postgres -c "SELECT datname FROM pg_database WHERE datistemplate = false;"
