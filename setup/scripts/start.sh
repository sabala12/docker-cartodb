#!/bin/bash

checkOption()
{
        local __value=$(echo "${!1}")
        if [[ -z ${__value} ]]; then
                echo "option $1 is not set!"
                exit 1
        fi
}

checkOption "CARTO_DOMAIN"
checkOption "CARTO_USER"
checkOption "CARTO_PASSWORD"
checkOption "CARTO_EMAIL"

cd /cartodb20

#TODO: edit configs python script
echo "***** setup-db *****"
sh script/setup-db.sh "${CARTO_DOMAIN}" "${CARTO_USER}" "${CARTO_PASSWORD}" "${CARTO_EMAIL}" 
echo "** create_dev_user *"
sh script/create_dev_user "${CARTO_USER}" "${CARTO_PASSWORD}" "${CARTO_EMAIL}"
echo "*** upgrade-user ***"
sh script/upgrade-user.sh "${CARTO_DOMAIN}" "${CARTO_USER}"
