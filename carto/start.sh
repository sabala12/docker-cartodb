#!/bin/bash

# Configure files
sed -i 's/REDIS_ADDRESS/'$REDIS_ADDRESS'/g' /CartoDB-SQL-API/config/environments/development.js
sed -i 's/POSTGRES_ADDRESS/'$POSTGRES_ADDRESS'/g' /CartoDB-SQL-API/config/environments/development.js

sed -i 's/REDIS_ADDRESS/'$REDIS_ADDRESS'/g' /Windshaft-cartodb/config/environments/development.js
sed -i 's/POSTGRES_ADDRESS/'$POSTGRES_ADDRESS'/g' /Windshaft-cartodb/config/environments/development.js

sed -i 's/REDIS_ADDRESS/'$REDIS_ADDRESS'/g' /cartodb20/config/app_config.yml
sed -i 's/POSTGRES_ADDRESS/'$POSTGRES_ADDRESS'/g' /cartodb20/config/database.yml

sed -i 's/POSTGRES_PASS/'$POSTGRES_PASS'/g' /cartodb20/config/database.yml

# Set subdomain DNS entry
export SUBDOMAIN="development"
echo "127.0.0.1 ${SUBDOMAIN}.localhost.lan" | tee -a /etc/hosts

cd /cartodb20

# Ask if user initialization is needed
echo -n -e "Enter 'y' to run user initialization, or else to continue...\n"; read SET_DEV_USER

if [[ "$SET_DEV_USER" == "y" ]]; then
   sh script/create_dev_user $SUBDOMAIN $CARTO_PASS example@gmail.com
fi

/bin/bash
# Run app
RAILS_ENV=development bundle exec script/resque \
    > resque.log 2> resque_err.log &

RAILS_ENV=development bundle exec thin start --threaded -p 3000 --threadpool-size 5 \
    > carto.log 2> carto_err.log &

cd /Windshaft-cartodb
node app.js development &

cd /CartoDB-SQL-API
node app.js development &

/bin/bash
