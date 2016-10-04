#!/bin/bash

read -t 3 -p "Enter 'n' to exit setup.\n" EXIT;
if [[ "$EXIT" == "n" ]]; then

        bash
else
        cd /cartodb20

        # edit configs
        sh script/setup-db.sh "${CARTO_DOMAIN}"
        sh script/create_dev_user "${CARTO_USER}" "${CARTO_PASSWORD}" "${CARTO_EMAIL}"
        sh script/upgrate-user.sh "${CARTO_USER}"
fi
