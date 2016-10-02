#!/bin/bash

echo -n -e "Enter 'y' to start cartodb setup.\n"; read SETUP
if [[ "$SETUP" == "y" ]]; then

        #echo -n -e "Enter 'y' to run database initialization.\n"; read DB
        read -t 3 -p "Enter 'y' to run database initialization.\n" DB;
        if [[ "$DB" == "y" ]]; then

                cd /cartodb20

                sh script/setup-db.sh
                sh script/create_dev_user "${CARTO_USER}" "${CARTO_PASSWORD}" "${CARTO_EMAIL}"
                sh script/modify-user-settings.sh
        fi

        echo -n -e "Enter 'y' to run cartodb services.\n"; read SERVICES
        if [[ "$SERVICES" == "y" ]]; then
                /cartodb20/script/run-services.sh
        fi
fi

/bin/bash
