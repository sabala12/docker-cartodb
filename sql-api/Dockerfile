FROM ubuntu:14.04
MAINTAINER Ido Shamon

ENV  DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
      useradd -m -d /home/cartodb -s /bin/bash cartodb && \
      apt-get install -y -q software-properties-common && \
      add-apt-repository -y ppa:chris-lea/node.js && \
      apt-get update
RUN apt-get install -y nodejs git make automake g++

RUN apt-get install -y -q python-setuptools python-simplejson 
RUN apt-get install -y -q libpq-dev gdal-bin proj-data

RUN cd /home && git clone git://github.com/CartoDB/CartoDB-SQL-API.git
RUN cd /home/CartoDB-SQL-API && ./configure
RUN cd /home/CartoDB-SQL-API && npm install --unsafe-perm

ADD ./config/CartoDB-dev.js \
      /CartoDB-SQL-API/config/environments/development.js

COPY entry-point.sh /home
RUN chmod 700 /home/entry-point.sh
ENTRY [/home/entry-point.sh]
