#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM ubuntu:12.04
MAINTAINER Tim Sutton<tim@kartoza.com>

ENV DEBIAN_FRONTEND noninteractive
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

RUN apt-get update && \
    apt-get install -y \
    software-properties-common \
    python-software-properties && \
    add-apt-repository ppa:cartodb/postgresql-9.3 && \
    add-apt-repository ppa:cartodb/gis && \
    apt-get update

# Some dependencies
RUN apt-get install -y \
    autoconf binutils-doc \
    bison build-essential make \
    netcat git pwgen ca-certificates \
    flex vim 

#-------------Application Specific Stuff ----------------------------------------------------

# We add postgis as well to prevent build errors (that we dont see on local builds)
# on docker hub e.g.
# The following packages have unmet dependencies:
# postgresql-9.3-postgis-2.1 : Depends: libgdal1h (>= 1.9.0) but it is not going to be installed
#                              Recommends: postgis but it is not going to be installed

# Install client packages
RUN apt-get install -y \
    libpq5 libpq-dev \
    postgresql-client-9.3 \
    postgresql-client-common \
    postgresql-9.3 \
    postgresql-contrib-9.3 \
    postgresql-server-dev-9.3 \
    postgresql-plpython-9.3 \
    pgtune \
    proj proj-bin proj-data libproj-dev \
    libjson0 libjson0-dev python-simplejson \
    libgeos-c1v5 libgeos-dev \
    gdal-bin libgdal1-dev libgdal-dev \
    ogr2ogr2-static-bin

# Postgis
RUN apt-get install -y \
    libxml2-dev liblwgeom-2.1.8 \
    postgis postgresql-9.3-postgis-2.2 \
    postgresql-9.3-postgis-scripts

# Set connections policy
RUN rm /etc/postgresql/9.3/main/pg_hba.conf
ADD ./pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf

ADD auth-configuration.sh /home/auth-configuration.sh
RUN chmod 0755 /home/auth-configuration.sh
RUN service postgresql start && /home/auth-configuration.sh && \
    service postgresql stop

# Setting PostgreSQL
RUN pgtune -T Web -c 100 -i /etc/postgresql/9.3/main/postgresql.conf -o /etc/postgresql/9.3/main/postgresql.conf.pgtune && \
    mv /etc/postgresql/9.3/main/postgresql.conf /etc/postgresql/9.3/main/postgresql.conf.orig && \
    mv /etc/postgresql/9.3/main/postgresql.conf.pgtune /etc/postgresql/9.3/main/postgresql.conf

# Install schema_triggers
RUN git clone https://github.com/CartoDB/pg_schema_triggers.git && \
      cd pg_schema_triggers && \
      make all install && \
      sed -i \
      "/#shared_preload/a shared_preload_libraries = 'schema_triggers.so'" \
      /etc/postgresql/9.3/main/postgresql.conf
ADD ./template_postgis.sh /tmp/template_postgis.sh
RUN service postgresql start && /bin/su postgres -c \
      /tmp/template_postgis.sh && service postgresql stop

# Install cartodb extension
RUN git clone https://github.com/CartoDB/cartodb-postgresql && \
      cd cartodb-postgresql && \
      PGUSER=postgres make install
ADD ./cartodb_pgsql.sh /tmp/cartodb_pgsql.sh
RUN service postgresql start && /bin/su postgres -c \
      /tmp/cartodb_pgsql.sh && service postgresql stop

RUN service postgresql start && \
    cd /cartodb-postgresql && \
    PGUSER=postgres make installcheck && \
    service postgresql stop
#---------------------------------------------------------------------------------------------
# Copy all postgresql data becuase of volume initialization
RUN mkdir /tmp/postgres-backup 
RUN cp -r /var/lib/postgresql/* /tmp/postgres-backup/

# Open port 5432 so linked containers can see them
EXPOSE 5432

# We will RUN any commands in this when the container starts
ADD start-postgis.sh /start-postgis.sh
RUN chmod 0755 /start-postgis.sh

CMD /start-postgis.sh
