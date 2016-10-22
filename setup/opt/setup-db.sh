#!/bin/sh

if test -n "$1"; then
        DOMAIN="$1"
else
        echo -n "Enter a domain: "; read DOMAIN
fi

if test -n "$2"; then
        USERNAME="$2"
else
        echo -n "Enter a user name: "; read USERNAME
fi

if test -n "$3"; then
        PASSWORD="$3"
else
        echo -n "Enter a password: "; read PASSWORD
fi

if test -n "$4"; then
        EMAIL="$4"
else
        echo -n "Enter an email: "; read EMAIL
fi

cd /cartodb20
timeout=2

RAILS_ENV=${DOMAIN} bundle exec rake db:create
sleep $timeout
if test $? -ne 0; then exit 1; fi

RAILS_ENV=${DOMAIN} bundle exec rake db:migrate
sleep $timeout
if test $? -ne 0; then exit 1; fi

RAILS_ENV=${DOMAIN} bundle exec rake cartodb:db:create_publicuser 
sleep $timeout
if test $? -ne 0; then exit 1; fi

#RAILS_ENV=${DOMAIN} bundle exec rake cartodb:db:setup_user SUBDOMAIN="admin" PASSWORD="277336" ENAIL="sabalah21@gmail.com"
#if test $? -ne 0; then exit 1; fi

#RAILS_ENV=${DOMAIN} bundle exec rake cartodb:db:reset_trigger_check_quota
#if test $? -ne 0; then exit 1; fi
#
#RAILS_ENV=${DOMAIN} bundle exec rake cartodb:db:load_functions
#if test $? -ne 0; then exit 1; fi
#
#RAILS_ENV=${DOMAIN} bundle exec rake cartodb:db:create_schemas
#if test $? -ne 0; then exit 1; fi
#
#RAILS_ENV=${DOMAIN} bundle exec rake cartodb:db:create_default_vis_permissions
#if test $? -ne 0; then exit 1; fi
#
#RAILS_ENV=${DOMAIN} bundle exec rake cartodb:db:populate_permission_entity_id
#if test $? -ne 0; then exit 1; fi
#
#RAILS_ENV=${DOMAIN} bundle exec rake cartodb:overlays:create_overlays
#if test $? -ne 0; then exit 1; fi
