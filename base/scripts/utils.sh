#!/bin/bash

checkOption()
{
        local __value=$(echo "${!1}")
        if [[ -z ${__value} ]]; then
                echo "option $1 is not set!"
                exit 1
        fi
}

configs_editor="/opt/configs-editor"

setOfflineConfig()
{
        cd $configs_editor
        local carto_conf="/cartodb20/config/app_config.yml"
        local wind_conf="/Windshaft-cartodb/config/environments/${CARTO_DOMAIN}.js"
        local sql_conf="/CartoDB-SQL-API/config/environments/${CARTO_DOMAIN}.js"

        node index.js --source="$carto_conf" --override="/opt/configs/offline/$carto_conf"
        node index.js --source="$wind_conf" --override="/opt/configs/offline/$wind_conf"
        node index.js --source="$sql_conf" --override="/opt/configs/offline/$sql_conf"
}

setPostgresConfig()
{
        cd $configs_editor
        local carto_conf="/cartodb20/config/database.yml"
        local wind_conf="/Windshaft-cartodb/config/environments/${CARTO_DOMAIN}.js"
        local sql_conf="/CartoDB-SQL-API/config/environments/${CARTO_DOMAIN}.js"

        node index.js --source="$carto_conf" --override="/opt/configs/$carto_conf"
        node index.js --source="$wind_conf" --override="/opt/configs/$wind_conf"
        node index.js --source="$sql_conf" --override="/opt/configs/$sql_conf"
}
