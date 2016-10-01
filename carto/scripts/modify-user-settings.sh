#!/bin/sh

cd /cartodb20

# # Update your quota to 100GB
echo "--- Updating quota to 100GB"
bundle exec rake cartodb:db:set_user_quota["${CARTO_USER}",102400]
if test $? -ne 0; then exit 1; fi

# # Allow unlimited tables to be created
echo "--- Allowing unlimited tables creation"
bundle exec rake cartodb:db:set_unlimited_table_quota["${CARTO_USER}"]
if test $? -ne 0; then exit 1; fi

# # Allow user to create private tables in addition to public
echo "--- Allowing private tables creation"
bundle exec rake cartodb:db:set_user_private_tables_enabled["${CARTO_USER}",'true']
 if test $? -ne 0; then exit 1; fi

# # Set the account type
echo "--- Setting cartodb account type"
bundle exec rake cartodb:db:set_user_account_type["${CARTO_USER}",'[DEDICATED]']
if test $? -ne 0; then exit 1; fi
