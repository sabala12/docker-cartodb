#!/bin/bash

#########################
export SUBDOMAIN=development

# Add entries to /etc/hosts needed in development
echo "127.0.0.1 ${SUBDOMAIN}.localhost.lan" | sudo tee -a /etc/hosts

# Create a development user
sh script/create_dev_user ${SUBDOMAIN}
#########################
cd $CARTO_SQL_DIR
node app.js development
