FROM ubuntu:12.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-key update && apt-get update
RUN apt-get install -y sudo software-properties-common python-software-properties

RUN add-apt-repository ppa:cartodb/redis && sudo apt-get update
RUN apt-get install -y redis-server

VOLUME ["/data"]

WORKDIR /data

EXPOSE 6379

ADD start.sh /opt/start.sh

CMD ["/bin/bash", "/opt/start.sh"]
