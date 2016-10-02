#!/bin/bash

echo -n -e "Enter 'y' to start setup.\n"; read SETUP
if [[ "$SETUP" == "y" ]]; then

        echo -n -e "Enter 'y' to run user initialization.\n"; read DB
        if [[ "$DB" == "y" ]]; then
                sh script/setup-db.sh
                sh script/create_dev_user "${CARTO_USER}" "${CARTO_PASSWORD}" "${CARTO_EMAIL}"
                sh script/modify-user-settings.sh
        fi

        /cartodb20/script/run-services.sh
fi

/bin/bash
