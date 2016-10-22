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

        local confs_base="/home/opt/base/configs"
        cd /home/opt/base/config-editor
        node index.js --source="$carto_app_conf" --override="$confs_base/$carto_app_conf"
        node index.js --source="$carto_db_conf" --override="$confs_base/$carto_db_conf"
        node index.js --source="$wind_conf" --override="$confs_base/$wind_conf"
        node index.js --source="$sql_conf" --override="$confs_base/$sql_conf"
}
