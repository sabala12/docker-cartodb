#!/bin/bash

if [[ -z ${CARTO_DOMAIN} ]]; then
        echo "CARTO_DOMAIN is not set!"
        exit 1
fi

cd /cartodb20

#TODO: edit configs python script

sh script/setup-db.sh "${CARTO_DOMAIN}"
sh script/create_dev_user "${CARTO_USER}" "${CARTO_PASSWORD}" "${CARTO_EMAIL}"
sh script/upgrade-user.sh "${CARTO_USER}"
