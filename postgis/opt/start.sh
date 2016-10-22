#!/bin/bash

# This script will run as the postgres user due to the Dockerfile USER directive
DATADIR="/var/lib/postgresql/9.3/main"
CONF="/etc/postgresql/9.3/main/postgresql.conf"
POSTGRES="/usr/lib/postgresql/9.3/bin/postgres"
INITDB="/usr/lib/postgresql/9.3/bin/initdb"
LOCALONLY="-c listen_addresses='127.0.0.1, ::1'"

# Handle data deletion due to volume initialization
if [ ! -d $DATADIR ]; then
  echo "Postgres data at $DATADIR"
  mkdir -p $DATADIR
fi

if [ ! "$(ls -A $DATADIR)" ]; then
  echo "Setting up Postgres Database at $DATADIR"
  cp -r /tmp/postgres-backup/9.3/main/* $DATADIR/
fi

rm -r /tmp/postgres-backup

# cahange postgres data directory
chown -R postgres:postgres $DATADIR
chmod -R 700 $DATADIR

# Make sure we have a user set up
if [ -z "$POSTGRES_USER" ]; then
  #TODO set user
  echo "Missing user name!"
  exit 0
fi  

if [ -z "$POSTGRES_PASS" ]; then
  #TODO set password
  echo "Missing password!"
  exit 0
fi  

# Fix ssl-cert permissions
ssl_private="/etc/ssl/private"
ssl_private_copy="/etc/ssl/private-copy"
mkdir $ssl_private_copy
cp -r $ssl_private/* $ssl_private_copy
rm -r $ssl_private
mv $ssl_private_copy $ssl_private

chmod -R 0700 $ssl_private
chown -R postgres $ssl_private

service postgresql start
until `nc -z 127.0.0.1 5432`; do
    echo "$(date) - waiting for postgres (localhost-only)..."
    sleep 1
done

#Set password
su - postgres  -c "psql -U $POSTGRES_USER -d postgres -c \"alter user postgres with password '$POSTGRES_PASS';\""

# Create database
#if [ "$POSTGRES_DATABASE" ]; then
#    IS_DATABASE_EXIST=$(psql -lqt -U postgres -h localhost | cut -d \| -f 1 | grep -w $POSTGRES_DATABASE)
#
#    if [[ -n $IS_DATABASE_EXIST ]]; then
#        echo "$POSTGRES_DATABASE already exist."
#    else
#        echo "creating $POSTGRES_DATABASE out of postgis template"
#        su - postgres -c "createdb -U $POSTGRES_USER -O $POSTGRES_USER -T template_postgis $POSTGRES_DATABASE;"
#    fi
#fi

# signal job is done
echo "postgres_up">/var/lib/postgresql/container_sock

PID=`cat /var/run/postgresql/9.3-main.pid`
kill -9 ${PID}
exec su - postgres -c "$POSTGRES -D $DATADIR -c config_file=$CONF"
