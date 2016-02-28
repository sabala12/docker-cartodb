#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM ubuntu:12.04
MAINTAINER Tim Sutton<tim@kartoza.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Use local cached debs from host (saves your bandwidth!)
# Change ip below to that of your apt-cacher-ng host
# Or comment this line out if you do not with to use caching
ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

RUN apt-get install -y make git pwgen ca-certificates build-essential \
    software-properties-common python-software-properties

RUN add-apt-repository ppa:cartodb/postgresql-9.3
RUN add-apt-repository ppa:cartodb/pg-schema-trigger
RUN add-apt-repository ppa:cartodb/gis
RUN apt-get update

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
# Install schema triggers
RUN apt-get install -y postgresql-9.3-pg-schema-triggers
# Install python extension
RUN apt-get install -y postgresql-contrib-9.3 postgresql-plpython3-9.3 

RUN cd /home && git clone https://github.com/CartoDB/cartodb-postgresql.git
RUN cd /home/cartodb-postgresql && make all install

# GIS dependencies
RUN apt-get install -y proj proj-bin proj-data libproj-dev \
    libjson0 libjson0-dev python-simplejson libgeos-c1v5 libgeos-dev \
    gdal-bin libgdal1-dev libgdal-dev ogr2ogr2-static-bin

# Postgis
RUN apt-get install -y libxml2-dev liblwgeom-2.1.8 \
    postgis postgresql-9.3-postgis-2.2 postgresql-9.3-postgis-scripts


# Install schema_triggers
RUN git clone https://github.com/CartoDB/pg_schema_triggers.git && \
      cd pg_schema_triggers && \
      make all install && \
      sed -i \
      "/#shared_preload/a shared_preload_libraries = 'schema_triggers.so'" \
      /etc/postgresql/9.3/main/postgresql.conf 

RUN apt-get install -y sudo
# Init template
#ADD ./template_postgis.sh /tmp/template_postgis.sh
#RUN chmod +x /tmp/template_postgis.sh
#RUN service postgresql start && su -c /tmp/template_postgis.sh -s /bin/sh postgres && \
#    service postgresql stop

# Install cartodb extension
RUN git clone --branch 0.5.1 https://github.com/CartoDB/cartodb-postgresql && \
      cd cartodb-postgresql && \
      PGUSER=postgres make install
#ADD ./cartodb_pgsql.sh /tmp/cartodb_pgsql.sh
#RUN chmod +x /tmp/cartodb_pgsql.sh
#RUN service postgresql start && /tmp/cartodb_pgsql.sh && service postgresql stop

#---------------------------------------------------------------------------------------------

ADD postgres.conf /etc/supervisor/conf.d/postgres.conf

# Open port 5432 so linked containers can see them
EXPOSE 5432

# RUN any additional tasks here that are too tedious to put in
# this dockerfile directly.
ADD postgres-conf.sh /home/postgres-conf.sh
RUN chmod 0755 /home/postgres-conf.sh
RUN /home/postgres-conf.sh
RUN service postgresql restart

# Run carto-db setup tasks here
ADD cartodb-setup.sh /home/cartodb-setup.sh
RUN chmod 0755 /home/cartodb-setup.sh
RUN service postgresql start &&  su -c "/home/cartodb-setup.sh" -s /bin/sh postgres && \
    service postgresql stop

# We will RUN any commands in this when the container starts
ADD start-postgis.sh /start-postgis.sh
RUN chmod 0755 /start-postgis.sh

CMD /start-postgis.sh
