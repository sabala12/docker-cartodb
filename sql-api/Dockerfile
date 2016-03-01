FROM ubuntu:12.04
MAINTAINER Ido Shamon

ENV DEBIAN_FRONTEND noninteractive

RUN apt-key update && apt-get update
RUN apt-get install -y curl sudo software-properties-common python-software-properties

#install nodejs && npm
#RUN curl --silent --location https://deb.nodesource.com/setup_5.x | sudo bash -
#RUN apt-get install -y nodejs 

RUN useradd -m -d /home/cartodb -s /bin/bash cartodb && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:cartodb/gis && \
    add-apt-repository -y ppa:cartodb/postgresql-9.3 && \
    add-apt-repository -y ppa:cartodb/nodejs-010 && \
    apt-get update

RUN apt-get install -y redis-server zip build-essential git nodejs
#gdal
RUN apt-get install -y gdal-bin libgdal1-dev libgdal-dev
#proj
RUN apt-get install -y proj-bin proj-data libproj-dev
#postgres
RUN apt-get install -y libpq5 libpq-dev postgresql-client-9.3 postgresql-client-common
#postgis
RUN apt-get install -y libxml2-dev liblwgeom-2.1.8 postgis postgresql-9.3-postgis-2.2 postgresql-9.3-postgis-scripts

#update gcc
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update
RUN apt-get install -y gcc-4.9 g++-4.9
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 50 --slave /usr/bin/g++ g++ /usr/bin/g++-4.9

RUN cd /home && git clone git://github.com/CartoDB/CartoDB-SQL-API.git
ENV CARTO_SQL_DIR /home/CartoDB-SQL-API
RUN ls /home
RUN cd $CARTO_SQL_DIR && ./configure
RUN cd $CARTO_SQL_DIR && npm install 

EXPOSE 8080

COPY entry-point.sh /home
RUN chmod 754 /home/entry-point.sh
ENTRYPOINT ["/home/entry-point.sh"]
