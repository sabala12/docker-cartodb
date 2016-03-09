FROM ubuntu:12.04
MAINTAINER Ido Shamon

ENV DEBIAN_FRONTEND noninteractiveo

RUN dpkg-reconfigure locales && \
      locale-gen en_US.UTF-8 && \
      update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8
ENV REDIS_PORT 6379

RUN apt-key update && apt-get update
RUN apt-get install -y software-properties-common python-software-properties
RUN apt-get install -y htop vim sudo make git pkg-config
RUN apt-get install -y python-setuptools python-simplejson python-all-dev
RUN apt-get install -y libreadline6-dev openssl net-tools wget
RUN apt-get install -y python-all-dev imagemagick unp zip libpq-dev libicu-dev
RUN apt-get install -y gdal-bin libgdal1-dev libgdal-dev libgdal-dev python-gdal
RUN add-apt-repository ppa:cartodb/gis && sudo apt-get update
RUN apt-get install -y ogr2ogr2-static-bin 
# Set gdal envs
ENV CPLUS_INCLUDE_PATH $CPLUS_INCLUDE_PATH:/usr/include/gdal
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:/usr/include/gdal
ENV PATH $PATH:/usr/include/gdal

RUN useradd -m -d /home/cartodb -s /bin/bash cartodb && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:cartodb/gis && \
    add-apt-repository -y ppa:cartodb/postgresql-9.3 && \
    add-apt-repository ppa:cartodb/nodejs-010 && \
    apt-get update

RUN apt-get install -y nodejs

# Update gcc
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update
RUN apt-get install -y gcc-4.9 g++-4.9
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 50 --slave /usr/bin/g++ g++ /usr/bin/g++-4.9

ENV RUBY_VERSION 0.5.0
#RUN cd /home && \
#    wget -O ruby-install-$RUBY_VERSION.tar.gz https://github.com/postmodern/ruby-install/archive/v$RUBY_VERSION.tar.gz
#RUN cd /home && tar -xzvf ruby-install-$RUBY_VERSION.tar.gz
#RUN cd /home/ruby-install-$RUBY_VERSION && make install
#RUN ruby-install ruby 2.2.3
#ENV PATH $PATH:/opt/rubies/ruby-2.2.3/bin/

# Install bundler & compass
#RUN gem install bundler
#RUN gem install compass

ENV RUBY_VERSION 2.2.3
ENV RAILS_VERSION 0.5.0
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN apt-get install -y curl
RUN curl -sSL https://get.rvm.io | bash -s stable --rails
RUN echo 'source /usr/local/rvm/scripts/rvm' >> /etc/bash.bashrc
RUN /bin/bash -l -c rvm requirements
ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN /bin/bash -l -c 'rvm install $RUBY_VERSION'
RUN /bin/bash -l -c 'rvm use $RUBY_VERSION --default'
RUN /bin/bash -l -c 'gem install bundle archive-tar-minitar'
RUN /bin/bash -l -c 'gem install bundler'
RUN /bin/bash -l -c 'gem install compass'
#RUN /bin/bash -l -c 'gem install rails -v $RAILS_VERSION'

# Install pip
RUN wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
RUN python /tmp/get-pip.py
RUN pip install mapnik

# Install Cartodb
RUN mkdir /home/installations
RUN cd /home/installations/ && git clone --recursive git://github.com/CartoDB/cartodb.git
ENV CARTODB_DIR /home/installations/cartodb
#RUN cd $CARTODB_DIR && git submodule update --init --recursive
RUN cd $CARTODB_DIR && git checkout 3.12.3

RUN /bin/bash -l -c 'cd $CARTODB_DIR && RAILS_ENV=development bundle install'
RUN cd $CARTODB_DIR && npm install
RUN apt-get install -y libgdal-dev libgdal1h
RUN cd $CARTODB_DIR && pip install --no-use-wheel -r python_requirements.txt
ENV PATH $PATH:$CARTODB_DIR/node_modules/grunt-cli/bin
RUN /bin/bash -l -c 'cd $CARTODB_DIR && bundle install'
RUN /bin/bash -l -c 'cd $CARTODB_DIR && bundle exec grunt --environment development'

ADD ./config/app_config.yml $CARTODB_DIR/config/app_config.yml
ADD ./config/database.yml $CARTODB_DIR/config/database.yml
ADD ./script/setup_user $CARTODB_DIR/script/setup_user
ADD ./script/create_dev_user $CARTODB_DIR/script/create_dev_user
RUN chmod +x $CARTODB_DIR/script/create_dev_user
RUN chmod +x $CARTODB_DIR/script/setup_user

EXPOSE 3000

COPY entry-point.sh /home/
RUN chmod 754 /home/entry-point.sh
ENTRYPOINT ["/home/entry-point.sh"]
