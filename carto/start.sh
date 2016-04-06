#!/bin/bash

# Configure files
sed -i 's/REDIS_ADDRESS/'$REDIS_ADDRESS'/g' /CartoDB-SQL-API/config/environments/development.js
sed -i 's/POSTGRES_ADDRESS/'$POSTGRES_ADDRESS'/g' /CartoDB-SQL-API/config/environments/development.js

sed -i 's/REDIS_ADDRESS/'$REDIS_ADDRESS'/g' /Windshaft-cartodb/config/environments/development.js
sed -i 's/POSTGRES_ADDRESS/'$POSTGRES_ADDRESS'/g' /Windshaft-cartodb/config/environments/development.js

sed -i 's/REDIS_ADDRESS/'$REDIS_ADDRESS'/g' /cartodb20/config/app_config.yml
sed -i 's/POSTGRES_ADDRESS/'$POSTGRES_ADDRESS'/g' /cartodb20/config/database.yml

sed -i 's/POSTGRES_PASS/'$POSTGRES_PASS'/g' /cartodb20/config/database.yml

export SUBDOMAIN="development"
echo "127.0.0.1 ${SUBDOMAIN}.localhost.lan" | tee -a /etc/hosts

cd /cartodb20

/bin/bash

#cd /Windshaft-cartodb
#node app.js development &

#cd /CartoDB-SQL-API
#node app.js development &

#sh script/create_dev_user ${SUBDOMAIN} ${PASSWORD} ${EMAIL}

#RAILS_ENV=development bundle exec script/resque \
#    > resque.log 2> resque_err.log &
#
#sleep 5
#
#RAILS_ENV=development bundle exec thin start --threaded -p 3000 --threadpool-size 5 \
#    > carto.log 2> carto_err.log &
