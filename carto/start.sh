#!/bin/bash

# Configure files
sed -i 's/REDIS_ADDRESS/'$REDIS_ADDRESS'/g' /CartoDB-SQL-API/config/environments/development.js
sed -i 's/POSTGRES_ADDRESS/'$POSTGRES_ADDRESS'/g' /CartoDB-SQL-API/config/environments/development.js

sed -i 's/REDIS_ADDRESS/'$REDIS_ADDRESS'/g' /Windshaft-cartodb/config/environments/development.js
sed -i 's/POSTGRES_ADDRESS/'$POSTGRES_ADDRESS'/g' /Windshaft-cartodb/config/environments/development.js

sed -i 's/REDIS_ADDRESS/'$REDIS_ADDRESS'/g' /cartodb20/config/app_config.yml
sed -i 's/POSTGRES_ADDRESS/'$POSTGRES_ADDRESS'/g' /cartodb20/config/database.yml
sed -i 's/POSTGRES_PASS/'$POSTGRES_PASS'/g' /cartodb20/config/database.yml

cd /Windshaft-cartodb
node app.js development &

cd /CartoDB-SQL-API
node app.js development &

export SUBDOMAIN="development"
echo "127.0.0.1 development.localhost.lan" | tee -a /etc/hosts

cd /cartodb20
/bin/bash

#sh script/create_dev_user ${SUBDOMAIN} ${PASSWORD} ${PASSWORD} ${EMAIL}

#bundle exec script/resque \
#    > resque.log 2> resque_err.log &
#
#sleep 5
#
#bundle exec thin start --threaded -p 3000 --threadpool-size 5 \
#    > carto.log 2> carto_err.log &
