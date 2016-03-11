#!/bin/bash

# Note the dockerfile must have put the postgis.sql and spatialrefsys.sql scripts into /root/
# We use template0 since we want t different encoding to template1

SQLDIR="/usr/share/postgresql/9.3/contrib/postgis-2.2/"

# Create some users for cartodb app
#createuser publicuser --no-createrole --no-createdb --no-superuser
#createuser tileuser --no-createrole --no-createdb --no-superuser

echo "Creating template postgis"
createdb template_postgis -E UTF8 -T template0

echo "Enabling template_postgis as a template"
psql -c "UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_postgis';"

echo "Loading postgis extension"
psql template_postgis -c 'CREATE EXTENSION postgis;'

echo "Loading postgis_topology"
psql template_postgis -c 'CREATE EXTENSION postgis_topology;'

#echo "Enabling hstore in the template"
psql template_postgis -c 'CREATE EXTENSION hstore;'

#echo "Loading plpgsql"
#psql template_postgis -c "CREATE LANGUAGE plpgsql;"

psql -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;"
psql -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"

# Needed when importing old dumps using e.g ndims for constraints
echo "Loading legacy sql"
psql template_postgis -f $SQLDIR/legacy_minimal.sql
psql template_postgis -f $SQLDIR/legacy_gist.sql
