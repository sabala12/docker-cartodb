=======
# CartoDB

Docker configuration for CartoDB.

This is a simple configuration for running cartodb app, with separate postgres and redis hosts.

cartodb            3.12.3
SQL-API            1.26.0
Windshaft          2.31.1
cartodb-postgres   0.14.4
schema-triggers    0.1

Credits:
kartoza/docker-postgis for the postgres container.

#Run
Go to scripts/start and run ./redis ./postgis ./carto in the following order.
