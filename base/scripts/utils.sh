#!/bin/bash

checkOption()
{
        local __value=$(echo "${!1}")
        if [[ -z ${__value} ]]; then
                echo "option $1 is not set!"
                exit 1
        fi
}

editConfigs()
{
        local carto_app_conf="/cartodb20/config/app_config.yml"
        local carto_db_conf="/cartodb20/config/database.yml"
        local wind_conf="/Windshaft-cartodb/config/environments/${CARTO_DOMAIN}.js"
        local sql_conf="/CartoDB-SQL-API/config/environments/${CARTO_DOMAIN}.js"

        cd /opt/configs-editor
        node index.js --source="$carto_app_conf" --override="/opt/configs/$carto_app_conf"
        node index.js --source="$carto_db_conf" --override="/opt/configs/$carto_db_conf"
        node index.js --source="$wind_conf" --override="/opt/configs/$wind_conf"
        node index.js --source="$sql_conf" --override="/opt/configs/$sql_conf"
}
