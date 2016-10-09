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

cd /cartodb20

timeout=2

# # Update your quota to 100GB
echo "--- Updating quota to 100GB"
RAILS_ENV=${DOMAIN} bundle exec rake cartodb:db:set_user_quota["${USERNAME}",102400]
sleep $timeout
if test $? -ne 0; then exit 1; fi

# # Allow unlimited tables to be created
echo "--- Allowing unlimited tables creation"
RAILS_ENV=${DOMAIN} bundle exec rake cartodb:db:set_unlimited_table_quota["${USERNAME}"]
sleep $timeout
if test $? -ne 0; then exit 1; fi

# # Allow user to create private tables in addition to public
echo "--- Allowing private tables creation"
RAILS_ENV=${DOMAIN} bundle exec rake cartodb:db:set_user_private_tables_enabled["${USERNAME}",'true']
sleep $timeout
if test $? -ne 0; then exit 1; fi

# # Set the account type
echo "--- Setting cartodb account type"
RAILS_ENV=${DOMAIN} bundle exec rake cartodb:db:set_user_account_type["${USERNAME}",'[DEDICATED]']
sleep $timeout
