FROM ubuntu:12.04
MAINTAINER Ido Shamon

ENV DEBIAN_FRONTEND noninteractiveo

RUN apt-key update && apt-get update
RUN apt-get install -y curl sudo software-properties-common python-software-properties

RUN useradd -m -d /home/cartodb -s /bin/bash cartodb && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:cartodb/gis && \
    add-apt-repository -y ppa:cartodb/postgresql-9.3 && \
    add-apt-repository ppa:cartodb/nodejs-010 && \
    apt-get update

RUN apt-get update -y && apt-get install -y nodejs git make pkg-config wget \
    libreadline6-dev openssl \
    python-setuptools python-simplejson python-all-dev software-properties-common 

#update gcc
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update
RUN apt-get install -y gcc-4.9 g++-4.9
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 50 --slave /usr/bin/g++ g++ /usr/bin/g++-4.9

ENV RUBY_VERSION 0.5.0
RUN mkdir /home/ruby && cd /home/ruby \
    && wget -O ruby-install-$RUBY_VERSION.tar.gz https://github.com/postmodern/ruby-install/archive/v$RUBY_VERSION.tar.gz
RUN cd /home/ruby/ && tar -xzvf ruby-install-$RUBY_VERSION.tar.gz
RUN cd /home/ruby/ruby-install-$RUBY_VERSION/ && make install
RUN ruby-install ruby 2.2.3
ENV PATH $PATH:/opt/rubies/ruby-2.2.3/bin/
RUN echo $PATH
RUN rm -r /home/ruby

# Install bundler & compass
RUN gem install bundler --no-doc --no-ri
RUN gem install compass --no-doc --no-ri

# Install pip & other stuff
RUN wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
RUN python /tmp/get-pip.py
RUN apt-get install -y python-all-dev imagemagick unp zip libpq-dev libicu-dev
RUN apt-get install -y gdal-bin libgdal1-dev libgdal-dev ogr2ogr2-static-bin libgdal-dev python-gdal
RUN pip install gdal
RUN pip install mapnik
# Set envs
ENV CPLUS_INCLUDE_PATH $CPLUS_INCLUDE_PATH:/usr/include/gdal
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:/usr/include/gdal
ENV PATH $PATH:/usr/include/gdal
# Install Cartodb
RUN mkdir /home/installations
RUN cd /home/installations/ && git clone git://github.com/CartoDB/cartodb.git
ENV CARTODB_DIR /home/installations/cartodb
RUN cd $CARTODB_DIR && git submodule update --init --recursive
RUN cd $CARTODB_DIR && RAILS_ENV=development bundle install
RUN cd $CARTODB_DIR && npm install
RUN cd $CARTODB_DIR && pip install --no-use-wheel -r python_requirements.txt
ENV PATH $PATH:$CARTODB_DIR/node_modules/grunt-cli/bin
RUN cd $CARTODB_DIR && bundle install

#########move up###########
RUN dpkg-reconfigure locales && \
      locale-gen en_US.UTF-8 && \
      update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8
RUN apt-get install -y vim
ENV REDIS_PORT 6379
#########move up##########

RUN cd $CARTODB_DIR && bundle exec grunt --environment development

#RUN cp $CARTODB_DIR/config/app_config.yml.sample $CARTODB_DIR/config/app_config.yml
#RUN cp $CARTODB_DIR/config/database.yml.sample $CARTODB_DIR/config/database.yml
ADD ./config/app_config.yml $CARTODB_DIR/config/app_config.yml
ADD ./config/database.yml $CARTODB_DIR/config/database.yml

EXPOSE 3000

####move up#####
RUN apt-get install -y net-tools htop
################

COPY entry-point.sh /home
RUN chmod 754 /home/entry-point.sh
ENTRYPOINT ["/home/entry-point.sh"]
