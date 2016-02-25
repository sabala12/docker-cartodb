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

RUN wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
RUN python /tmp/get-pip.py
ENV RAILS_ENV development

#install gdal and other dependencies
RUN apt-get install -y software-properties-common 
RUN add-apt-repository ppa:cartodb/gis && apt-get -y update
RUN apt-get install -y gdal-bin libgdal1-dev libgdal-dev ogr2ogr2-static-bin \
    unp zip imagemagick

ENV CPLUS_INCLUDE_PATH $CPLUS_INCLUDE_PATH:/usr/include/gdal
ENV C_INCLUDE_PATH $C_INCLUDE_PATH:/usr/include/gdal

RUN mkdir /home/installations
RUN cd /home/installations/ && git clone https://github.com/CartoDB/cartodb.git
RUN cd /home/installations/cartodb && ./configure
RUN cd /home/installations/cartodb && npm install
RUN cd /home/installations/cartodb && pip install --no-use-wheel -r python_requirements.txt

# Copy confs
ADD ./config/app_config.yml /cartodb/config/app_config.yml
ADD ./config/database.yml /cartodb/config/database.yml

EXPOSE 3000

COPY entry-point.sh /home
RUN chmod 700 /home/entry-point.sh
ENTRY [/home/entry-point.sh]
