#!/bin/bash

psql -d template_postgis -U postgres -c "create extension cdb_geocoder;"
psql -d template_postgis -U postgres -c "create extension plproxy;"
psql -d template_postgis -U postgres -c "create extension cdb_dataservices_server;"
psql -d template_postgis -U postgres -c "create extension cdb_dataservices_client;"
