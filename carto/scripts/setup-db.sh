#!/bin/sh

cd /cartodb20

RAILS_ENV=${CARTO_DOMAIN} bundle exec rake db:create
if test $? -ne 0; then exit 1; fi

RAILS_ENV=${CARTO_DOMAIN} bundle exec rake db:migrate
if test $? -ne 0; then exit 1; fi

RAILS_ENV=${CARTO_DOMAIN} bundle exec rake cartodb:db:setup SUBDOMAIN="${CARTO_DOMAIN}" \
                                                            PASSWORD="${CARTO_PASSWORD}" \
                                                            ADMIN_PASSWORD="${CARTO_PASSWORD}" \
                                                            EMAIL="${CARTO_EMAIL}"
if test $? -ne 0; then exit 1; fi
