#!/bin/bash

source /usr/local/lib/utils.sh

checkOption "CARTO_DOMAIN"
checkOption "CARTO_USER"
checkOption "CARTO_PASSWORD"
checkOption "CARTO_EMAIL"
checkOption "POSTGRES_ADDRESS"
checkOption "POSTGRES_PASSWORD"

setPostgresConfig

cd /cartodb20
echo "***** setup-db *****"
sh script/setup-db.sh "${CARTO_DOMAIN}" "${CARTO_USER}" "${CARTO_PASSWORD}" "${CARTO_EMAIL}" 
echo "** create_dev_user *"
sh script/create_dev_user "${CARTO_USER}" "${CARTO_PASSWORD}" "${CARTO_EMAIL}"
echo "*** upgrade-user ***"
sh script/upgrade-user.sh "${CARTO_DOMAIN}" "${CARTO_USER}"
