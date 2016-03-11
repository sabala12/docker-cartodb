#
# Cartodb container
#
FROM ubuntu:14.04
MAINTAINER Stefan Verhoeven <s.verhoeven@esciencecenter.nl>

# Configuring locales
ENV DEBIAN_FRONTEND noninteractive
RUN dpkg-reconfigure locales && \
      locale-gen en_US.UTF-8 && \
      update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update &&\
    apt-get install -y -q \
    build-essential \
    autoconf \
    automake \
    libtool \
    checkinstall \
    git \
    libgeos-c1 \
    libgeos-dev \
    libjson0 \
    python-simplejson \
    libjson0-dev \
    proj-bin \
    proj-data \
    libproj-dev \
    gdal-bin \
    libgdal1-dev \
    postgresql-9.3 \
    postgresql-client-9.3 \
    postgresql-contrib-9.3 \
    postgresql-server-dev-9.3 \
    postgresql-plpython-9.3 \
    postgresql-9.3-plproxy \
    postgresql-9.3-postgis-2.1 \
    postgresql-9.3-postgis-2.1-scripts \
    postgis \
    ca-certificates \
    python2.7-dev \
    python-setuptools \
    python-gdal \
    python-chardet \
    openssl \
    #libreadline6 \
    libssl-dev \
    #libsqlite3-dev \
    #sqlite3 \
    #libxml2-dev \
    #libxslt-dev \
    #libc6-dev \
    pkg-config \
    libpq5 \
    libpq-dev \
    libcurl4-gnutls-dev \
    #libffi-dev \
    #libgdbm-dev \
    #gnupg \
    #libreadline6-dev \
    #libcairo2-dev \
    #libjpeg8-dev \
    #libpango1.0-dev \
    #libgif-dev \
    pgtune \
    libgmp-dev \
    curl \
    #libicu-dev \
  --no-install-recommends &&\
  rm -rf /var/lib/apt/lists/*

# Setting PostgreSQL
RUN sed -i 's/\(peer\|md5\)/trust/' /etc/postgresql/9.3/main/pg_hba.conf && \
      pgtune -T Web -c 100 -i /etc/postgresql/9.3/main/postgresql.conf -o /etc/postgresql/9.3/main/postgresql.conf.pgtune && \
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

# Install rvm
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3
RUN curl -L https://get.rvm.io | bash -s stable --ruby
RUN echo 'source /usr/local/rvm/scripts/rvm' >> /etc/bash.bashrc
RUN /bin/bash -l -c rvm requirements
ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN echo rvm_max_time_flag=15 >> ~/.rvmrc
RUN /bin/bash -l -c 'rvm install 2.2.3'
RUN /bin/bash -l -c 'rvm use 2.2.3 --default'
RUN /bin/bash -l -c 'gem install bundle archive-tar-minitar'

# Geocoder SQL client + server
RUN git clone https://github.com/CartoDB/geocoder-api.git &&\
  ln -s /usr/local/rvm/rubies/ruby-2.2.3/bin/ruby /usr/bin &&\
  cd geocoder-api/server/extension && PGUSER=postgres make install &&\
  cd ../../client && PGUSER=postgres make install

# login configurations
ADD ./auth-configuration.sh /tmp/auth-configuration.sh
RUN chmod 0755 /tmp/auth-configuration.sh
RUN /tmp/auth-configuration.sh

RUN rm /etc/postgresql/9.3/main/pg_hba.conf
ADD ./pg_hba.conf /etc/postgresql/9.3/main/pg_hba.conf

# Copy all postgresql data becuase of volume initialization
RUN mkdir /tmp/postgres-backup 
RUN cp -r /var/lib/postgresql/* /tmp/postgres-backup/

# Open port 5432 so linked containers can see them
EXPOSE 5432

# We will RUN any commands in this when the container starts
ADD start-postgis.sh /start-postgis.sh
RUN chmod 0755 /start-postgis.sh

CMD /start-postgis.sh
