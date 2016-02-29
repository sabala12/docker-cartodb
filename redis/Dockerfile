FROM ubuntu:12.04
MAINTAINER Ido Shamon

ENV DEBIAN_FRONTEND noninteractive

RUN apt-key update && apt-get update
RUN apt-get install -y sudo software-properties-common python-software-properties

RUN add-apt-repository ppa:cartodb/redis && sudo apt-get update
RUN apt-get install -y redis-server

ADD entry-point.sh /home/
RUN chmod 754 /home/entry-point.sh
RUN ls /home
ENTRYPOINT ["/home/entry-point.sh"]
