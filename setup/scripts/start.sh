#!/bin/bash

source /usr/local/lib/utils.sh

checkOption NET_DOMAIN
checkOption CARTO_DOMAIN
checkOption CARTO_USER
checkOption CARTO_PASSWORD
checkOption CARTO_EMAIL
checkOption POSTGRES_ADDRESS
checkOption POSTGRES_PASSWORD

# Edit config files
editConfigs

cd /cartodb20
# Setup db
sh script/setup-db.sh "${CARTO_DOMAIN}" "${CARTO_USER}" "${CARTO_PASSWORD}" "${CARTO_EMAIL}" 

# Create deve user
sh script/create_dev_user "${CARTO_USER}" "${CARTO_PASSWORD}" "${CARTO_EMAIL}"

# Upgrafe settings
sh script/upgrade-user.sh "${CARTO_DOMAIN}" "${CARTO_USER}"
