#!/bin/bash

# This script will run as the postgres user due to the Dockerfile USER directive
ldconfig

DATADIR="/var/lib/postgresql/9.3/main"
CONF="/etc/postgresql/9.3/main/postgresql.conf"
POSTGRES="/usr/lib/postgresql/9.3/bin/postgres"
INITDB="/usr/lib/postgresql/9.3/bin/initdb"
LOCALONLY="-c listen_addresses='127.0.0.1, ::1'"

# /etc/ssl/private can't be accessed from within container for some reason
# (@andrewgodwin says it's something AUFS related)  - taken from https://github.com/orchardup/docker-postgresql/blob/master/Dockerfile
cp -r /etc/ssl /tmp/ssl-copy/
chmod -R 0700 /etc/ssl
chown -R postgres /tmp/ssl-copy
rm -r /etc/ssl
mv /tmp/ssl-copy /etc/ssl

# Needed under debian, wasnt needed under ubuntu
mkdir /var/run/postgresql/9.3-main.pg_stat_tmp
chmod 0777 /var/run/postgresql/9.3-main.pg_stat_tmp

# test if DATADIR is existent
if [ ! -d $DATADIR ]; then
  echo "Creating Postgres data at $DATADIR"
  mkdir -p $DATADIR
fi
# needs to be done as root:
chown -R postgres:postgres $DATADIR

# test if DATADIR has content
if [ ! "$(ls -A $DATADIR)" ]; then

  # No content yet - first time pg is being run!
  # Initialise db
  echo "Initializing Postgres Database at $DATADIR"
  #chown -R postgres $DATADIR
  su - postgres -c "$INITDB $DATADIR"
fi

# Make sure we have a user set up
if [ -z "$POSTGRES_USER" ]; then
  echo "Missing user name!"
  exit 0
fi  
if [ -z "$POSTGRES_PASS" ]; then
  echo "Missing password!"
  exit 0
fi  

# docker logs when container starts
# so that we can tell user their password
echo "postgresql user: $POSTGRES_USER" > /tmp/PGPASSWORD.txt
echo "postgresql password: $POSTGRES_PASS" >> /tmp/PGPASSWORD.txt
su - postgres -c "$POSTGRES --single -D $DATADIR -c config_file=$CONF <<< \"CREATE USER $POSTGRES_USER WITH SUPERUSER ENCRYPTED PASSWORD '$POSTGRES_PASS';\""

trap "echo \"Sending SIGTERM to postgres\"; killall -s SIGTERM postgres" SIGTERM

su - postgres -c "$POSTGRES -D $DATADIR -c config_file=$CONF $LOCALONLY &"

# wait for postgres to come up
until `nc -z 127.0.0.1 5432`; do
    echo "$(date) - waiting for postgres (localhost-only)..."
    sleep 1
done
echo "postgres ready"

# set envs for user postgres
su - postgres -c "echo 'export POSTGRES_DATABASE=$POSTGRES_DATABASE' >> ~/.profile"
su - postgres -c "source ~/.profile"

# start postgres service
service postgresql restart

RESULT=`su - postgres -c "psql -l | grep postgis | wc -l"`
if [[ ${RESULT} == '1' ]]
then
    echo 'Postgis Already There'
else

    echo "postgis default setup"
    su - postgres -c "/home/postgis-defaults.sh"

    ldconfig

    echo "postgres extensions"
    /home/cartodb-extension.sh

    echo "schema triggers"
    /home/schema-triggers.sh

    su - postgres -c "psql -d template_postgis -c 'GRANT ALL ON geometry_columns TO PUBLIC;'"
    su - postgres -c "psql -d template_postgis -c 'GRANT ALL ON spatial_ref_sys TO PUBLIC;'"

    echo "cartodb postgres extension setup"
    su - postgres -c "/home/cartodb-setup.sh"

    echo "create user requested database"
    su - postgres -c "createdb -U $POSTGRES_USER -O $POSTGRES_USER -T template_postgis $POSTGRES_DATABASE;"
fi

# This should show up in docker logs afterwards
su - postgres -c "psql -l"

PID=`cat /var/run/postgresql/9.3-main.pid`
kill -9 ${PID}
echo "Postgres initialisation process completed .... restarting in foreground"
exec su - postgres -c "$POSTGRES -D $DATADIR -c config_file=$CONF"
