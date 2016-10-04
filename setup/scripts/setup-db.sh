#!/bin/sh

if test -n "$1"; then
        DOMAIN="$1"
else
        echo -n "Enter a domain: "; read DOMAIN
fi


cd /cartodb20

# Initialize the metadata database
RAILS_ENV=${DOMAIN} bundle exec rake db:create
if test $? -ne 0; then exit 1; fi

# Initialize the metadata database
RAILS_ENV=${DOMAIN} bundle exec rake db:migrate
if test $? -ne 0; then exit 1; fi

# Create an admin user
RAILS_ENV=${DOMAIN} bundle exec rake cartodb:db:setup_user
