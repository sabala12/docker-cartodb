#!/bin/bash
#
# Init script to success tests.
#

createuser publicuser --no-createrole --no-createdb --no-superuser -U postgres
createuser tileuser --no-createrole --no-createdb --no-superuser -U postgres

#psql -d template_postgis -c "CREATE EXTENSION postgis;"
psql -d template_postgis -c "CREATE EXTENSION cartodb;"
