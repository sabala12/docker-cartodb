FROM ubuntu:12.04
MAINTAINER Ido Shamon

# Configuring locales
ENV DEBIAN_FRONTEND noninteractive
RUN dpkg-reconfigure locales && \
      locale-gen en_US.UTF-8 && \
      update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get update && \
    apt-get install -y \
    software-properties-common \
    python-software-properties

RUN add-apt-repository ppa:cartodb/postgresql-9.3 && \
    add-apt-repository ppa:cartodb/gis && \
    add-apt-repository ppa:cartodb/redis && \
    add-apt-repository ppa:cartodb/nodejs-010

RUN apt-get update && \
    apt-get install -y \
    build-essential \
    autoconf \
    automake \
    libtool \
    checkinstall \
    unp \
    zip \
    unzip \
    git-core \
    git \
    subversion \
    wget \
    libjson0 \
    python-simplejson \
    nodejs \
    ca-certificates \
    redis-server \
    python2.7-dev \
    python-setuptools \
    imagemagick \
    python-argparse \
    python-chardet \
    openssl \
    libreadline6 \
    zlib1g \
    zlib1g-dev \
    libssl-dev \
    libyaml-dev \
    libsqlite3-dev \
    libxml2-dev \
    libxslt-dev \
    libc6-dev \
    ncurses-dev \
    bison \
    pkg-config \
    libpq5 \
    libpq-dev \
    libffi-dev \
    libgdbm-dev \
    libreadline6-dev \
    libcairo2-dev \
    libjpeg8-dev \
    libpango1.0-dev \
    libgif-dev \
    pgtune \
    libgmp-dev \
    libicu-dev \
    postgresql-client \
    varnish \
    vim

# GIS dependencies
RUN apt-get install -y proj proj-bin proj-data libproj-dev
RUN apt-get install -y libjson0 libjson0-dev python-simplejson
RUN apt-get install -y libgeos-c1v5 libgeos-dev
RUN apt-get install -y gdal-bin libgdal1-dev libgdal-dev
RUN apt-get install -y ogr2ogr2-static-bin
 
# Install Ruby
RUN cd /tmp && \
    wget -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz && \
    tar -xzvf ruby-install-0.5.0.tar.gz && \
    cd ruby-install-0.5.0/ && \
    make install && \
    ruby-install ruby 2.2.3

# Set ruby && gdal enviorment variables
ENV PATH $PATH:/opt/rubies/ruby-2.2.3/bin
ENV CPLUS_INCLUDE_PATH $CPLUS_INCLUDE_PATH:/usr/include/gdal
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:/usr/include/gdal
ENV PATH $PATH:/usr/include/gdal

# Install SQL API
RUN git clone git://github.com/CartoDB/CartoDB-SQL-API.git && \
    cd CartoDB-SQL-API && \
    git checkout master && \
    ./configure && \
    npm install && \
    cp config/environments/development.js.example config/environments/development.js

# Install Windshaft
RUN git clone git://github.com/CartoDB/Windshaft-cartodb.git && \
    cd Windshaft-cartodb && \
    git checkout master && \
    ./configure && \
    npm install && \
    mkdir logs && \
    cp config/environments/development.js.example config/environments/development.js

# Install gems
RUN gem install bundler
RUN gem install compass

# Install pip
RUN cd /tmp && \
    wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py && \
    python /tmp/get-pip.py

# Install CartoDB app
RUN git clone --recursive https://github.com/CartoDB/cartodb20.git
RUN sed -i 's/jwt (1.5.3)/jwt (1.5.4)/g' /cartodb20/Gemfile.lock
RUN cd /cartodb20 && \
    RAILS_ENV=development bundle install && \
    npm install && \
    pip install --no-use-wheel -r python_requirements.txt

ENV PATH $PATH:/cartodb20/node_modules/grunt-cli/bin
RUN npm install -g grunt-cli
RUN cd /cartodb20 && \
    npm install grunt --save-dev && \
    bundle exec grunt --environment development && \
    cp config/app_config.yml.sample config/app_config.yml && \
    cp config/database.yml.sample config/database.yml

ENV REDIS_PORT 6379

EXPOSE 3000 8080 8181

#ADD ./config/app_config.yml /cartodb/config/app_config.yml
ADD ./config/database.yml /cartodb20/config/database.yml
ADD ./start.sh /opt/start.sh

CMD ["/bin/bash", "/opt/start.sh"]
