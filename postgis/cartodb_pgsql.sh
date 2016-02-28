#!/bin/bash
#
# Init script to success tests.
#

psql -U postgres -c "CREATE EXTENSION postgis;"
psql -c "CREATE EXTENSION cartodb;"
