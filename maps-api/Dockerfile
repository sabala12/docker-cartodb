FROM ubuntu:14.04
MAINTAINER Ido Shamon

ENV  DEBIAN_FRONTEND noninteractive

RUN apt-get update && \
      useradd -m -d /home/cartodb -s /bin/bash cartodb && \
      apt-get install -y -q software-properties-common && \
      add-apt-repository -y ppa:chris-lea/node.js && \
      apt-get update
RUN apt-get install -y nodejs git make automake g++ pkg-config \
    python-setuptools python-simplejson \
    libcairo2 libcairo2-dev libpq-dev

RUN cd /home && git clone git://github.com/CartoDB/Windshaft-cartodb.git
RUN cd /home/Windshaft-cartodb && ./configure
RUN cd /home/Windshaft-cartodb && npm install --unsafe-perm
RUN cd /home/Windshaft-cartodb && mkdir logs

ADD ./config/WS-dev.js \
      /Windshaft-cartodb/config/environments/development.js

COPY entry-point.sh /home
RUN chmod 700 /home/entry-point.sh
ENTRY [/home/entry-point.sh]
