FROM carto-base:latest
MAINTAINER sabalah21@gmail.com

ADD ./scripts/setup-db.sh /cartodb20/script/setup-db.sh
ADD ./scripts/upgrade-user.sh /cartodb20/script/upgrade-user.sh
ADD ./scripts/start.sh /opt/start.sh

CMD ["/bin/bash", "/opt/start.sh"]
