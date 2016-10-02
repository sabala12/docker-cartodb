=======
# CartoDB

Docker configuration for CartoDB.

This is a simple configuration for running cartodb app.

Redis, Postgres, and CartoDB are separated to three containers.
The containers net stack is linked to localhost, and therefor no config
file was changed.

If you would like to run postgres or redis on different host you would have
to update the configs:
/cartodb20/config/database.yml -> postgres
/cartodb20/config/app_config.yml -> redis
/Windshaft-cartodb/config/environments/{domain}.js -> redis, postgres
/CartoDB-SQL-API/config/environments/{domain}.js -> redis, postgres

Since config files tend to change from version to the next, I choose
not to deal with the hosts separation.
It would have been much more simple if the installation used environment 
variables insted of specifing the same redis and postgres ip addressed in
multiple location. But since it does not, I am leaving it up to you.

# Installation

cd docker-cartodb/redis/  
./build.sh

cd docker-cartodb/postgis/  
./build.sh

cd docker-cartodb/carto/  
./base/build.sh  
./build.sh

cd docker-cartodb/scripts/  
./entry.sh

And it should be up and running on http://localhost:3000

You might want to put nginx in front of it to make it available from all hosts.

# Comments

I hope you find this installation helpful.

If you encounter any troubles feal free send me a message to sabalah21@gmail.com.


# Credits
kartoza/docker-postgis
