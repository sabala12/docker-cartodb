FROM ubuntu:12.04
MAINTAINER Ido Shamon

ENV DEBIAN_FRONTEND noninteractive

RUN apt-key update && apt-get update
RUN apt-get install -y curl sudo software-properties-common python-software-properties

RUN useradd -m -d /home/cartodb -s /bin/bash cartodb && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:cartodb/gis && \
    add-apt-repository ppa:cartodb/postgresql-9.3 && \
    add-apt-repository -y ppa:cartodb/nodejs-010 && \
    apt-get update

RUN apt-get install -y redis-server build-essential git-core pkg-config nodejs
RUN apt-get install -y libpango1.0-dev libgif-dev libjpeg-dev libjpeg8-dev libcairo2-dev libpango1.0-dev
RUN apt-get install -y python-setuptools python-simplejson \
        postgresql-9.3-postgis-2.1 postgresql-plpython-9.3 postgresql-server-dev-9.3

#update gcc
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update -qq
RUN apt-get install -y -qq gcc-4.9 g++-4.9
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.9

RUN cd /home && git clone git://github.com/CartoDB/Windshaft-cartodb.git
ENV WIND_DIR /home/Windshaft-cartodb
RUN cd $WIND_DIR && ./configure
RUN cd $WIND_DIR && npm install
RUN cd $WIND_DIR && mkdir logs

EXPOSE 8181

COPY entry-point.sh /home
RUN chmod 754 /home/entry-point.sh
ENTRYPOINT ["/home/entry-point.sh"]
