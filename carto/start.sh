#!/bin/bash

# Configure files
sed -i 's/REDIS_ADDRESS/'$REDIS_ADDRESS'/g' /CartoDB-SQL-API/config/environments/development.js
sed -i 's/POSTGRES_ADDRESS/'$POSTGRES_ADDRESS'/g' /CartoDB-SQL-API/config/environments/development.js

sed -i 's/REDIS_ADDRESS/'$REDIS_ADDRESS'/g' /Windshaft-cartodb/config/environments/development.js
sed -i 's/POSTGRES_ADDRESS/'$POSTGRES_ADDRESS'/g' /Windshaft-cartodb/config/environments/development.js

sed -i 's/REDIS_ADDRESS/'$REDIS_ADDRESS'/g' /cartodb20/config/app_config.yml
sed -i 's/POSTGRES_ADDRESS/'$POSTGRES_ADDRESS'/g' /cartodb20/config/database.yml

sed -i 's/POSTGRES_PASS/'$POSTGRES_PASS'/g' /cartodb20/config/database.yml

DOCKER_HOST_ADDRESS=$(gethostip -d dockerhost)
sed -i 's/DOCKER_HOST_ADDRESS/'$DOCKER_HOST_ADDRESS'/g' /cartodb20/config/app_config.yml

# Ask if user initialization is needed
echo -n -e "Enter 'y' to run user initialization, or else to continue...\n"; read SET_DEV_USER

if [[ "$SET_DEV_USER" == "y" ]]; then
   cd /cartodb20
   sh script/create_dev_user $SUBDOMAIN $CARTO_PASS example@gmail.com
fi

/bin/bash

/opt/carto-service.sh

/bin/bash
