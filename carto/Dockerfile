FROM carto-base:latest

ADD ./config/sql-dev.js /CartoDB-SQL-API/config/environments/development.js
ADD ./config/ws-dev.js /Windshaft-cartodb/config/environments/development.js
ADD ./config/app_config.yml /cartodb20/config/app_config.yml
ADD ./config/database.yml /cartodb20/config/database.yml
ADD ./setup_organization.sh /cartodb20/script/setup_organization.sh
ADD ./carto-services.sh /opt/carto-services.sh
ADD ./start.sh /opt/start.sh

EXPOSE 3000 8080 8181

CMD ["/bin/bash", "/opt/start.sh"]
