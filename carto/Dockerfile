FROM carto-base:latest
MAINTAINER sabalah21@gmail.com

#ADD ./config/sql-dev.js /CartoDB-SQL-API/config/environments/development.js
#ADD ./config/ws-dev.js /Windshaft-cartodb/config/environments/development.js
#ADD ./config/app_config.yml /cartodb/config/app_config.yml
#ADD ./config/database.yml /cartodb/config/database.yml

ADD ./scripts/run-services.sh /cartodb20/script/run-services.sh
ADD ./scripts/modify-user-settings.sh /cartodb20/script/modify-user-settings.sh
ADD ./scripts/setup-db.sh /cartodb20/script/setup-db.sh
ADD ./scripts/setup-organization.sh /cartodb20/script/setup-organization.sh
ADD ./start.sh /opt/start.sh

CMD ["/bin/bash", "/opt/start.sh"]
