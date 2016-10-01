cd /cartodb20
source /usr/local/rvm/scripts/rvm

echo "insert into feature_flags (id,name, restricted) VALUES (1, 'heatmaps', false);" | psql -U postgres carto_db_development
echo "insert into feature_flags (id,name, restricted) VALUES (2, 'georef_disabled', false);" | psql -U postgres carto_db_development

rake cartodb:db:create_user EMAIL="${CARTO_EMAIL}" PASSWORD="${CARTO_PASSWORD}" SUBDOMAIN="${CARTO_DOMAIN}"
rake cartodb:db:set_unlimited_table_quota["${CARTO_USER}"]
rake cartodb:db:create_new_organization_with_owner ORGANIZATION_NAME="${CARTO_ORGANIZATION}" USERNAME="${CARTO_USER}" ORGANIZATION_SEATS=100 ORGANIZATION_QUOTA=102400 ORGANIZATION_DISPLAY_NAME="${CARTO_ORGANIZATION}"
rake cartodb:db:set_organization_quota[${CARTO_ORGANIZATION},100]
