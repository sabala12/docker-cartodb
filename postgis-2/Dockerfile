#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM ubuntu:12.04
MAINTAINER Tim Sutton<tim@kartoza.com>

ENV DEBIAN_FRONTEND noninteractive
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

RUN apt-get update && apt-get install -y software-properties-common python-software-properties

RUN add-apt-repository ppa:cartodb/postgresql-9.3 && \
    add-apt-repository ppa:cartodb/gis && \
    apt-get update

# Some dependencies
RUN apt-get install -y autoconf binutils-doc bison build-essential
RUN apt-get install -y flex sudo nano netcat git make pwgen ca-certificates 

#-------------Application Specific Stuff ----------------------------------------------------

# We add postgis as well to prevent build errors (that we dont see on local builds)
# on docker hub e.g.
# The following packages have unmet dependencies:
# postgresql-9.3-postgis-2.1 : Depends: libgdal1h (>= 1.9.0) but it is not going to be installed
#                              Recommends: postgis but it is not going to be installed

# Install client packages
RUN apt-get install -y libpq5 libpq-dev postgresql-client-9.3 postgresql-client-common
# Install server packages
RUN apt-get install -y postgresql-9.3 postgresql-contrib-9.3 postgresql-server-dev-9.3 postgresql-plpython-9.3

# GIS dependencies
RUN apt-get install -y proj proj-bin proj-data libproj-dev
RUN apt-get install -y libjson0 libjson0-dev python-simplejson
RUN apt-get install -y libgeos-c1v5 libgeos-dev
RUN apt-get install -y gdal-bin libgdal1-dev libgdal-dev
RUN apt-get install -y ogr2ogr2-static-bin

# Postgis
RUN apt-get install -y libxml2-dev liblwgeom-2.1.8 \
    postgis postgresql-9.3-postgis-2.2 postgresql-9.3-postgis-scripts

# Set connections policy
RUN rm /etc/postgresql/9.3/main/pg_hba.conf
ADD ./pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf
RUN service postgresql restart

ADD auth-configuration.sh /home/auth-configuration.sh
RUN chmod 0755 /home/auth-configuration.sh
RUN service postgresql start && /home/auth-configuration.sh && \
    service postgresql stop
#---------------------------------------------------------------------------------------------

ADD postgres.conf /etc/supervisor/conf.d/postgres.conf

# Open port 5432 so linked containers can see them
EXPOSE 5432

#---------------------------Tedious Tasks--------------------------------------------------------
# postgis defaults setup
ADD postgis-defaults.sh /home/postgis-defaults.sh
RUN chmod 0755 /home/postgis-defaults.sh

# cartodb extensions
ADD cartodb-extension.sh /home/cartodb-extension.sh
RUN chmod 0755 /home/cartodb-extension.sh

# schema triggers
ADD schema-triggers.sh /home/schema-triggers.sh
RUN chmod 0755 /home/schema-triggers.sh

# carto-db psql setup
ADD cartodb-setup.sh /home/cartodb-setup.sh
RUN chmod 0755 /home/cartodb-setup.sh
#-------------------------------------------------------------------------------------------------

# We will RUN any commands in this when the container starts
ADD start-postgis.sh /start-postgis.sh
RUN chmod 0755 /start-postgis.sh

CMD /start-postgis.sh
