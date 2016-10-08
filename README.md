=======
# CartoDB

Docker configuration for CartoDB.

This is a simple configuration for running cartodb app.

All containers are linked to the host net stack, and therefore share
the same ip address.
To run postgres or redis on different hosts, you will have to change
the corresponding configs.

# Installation

cd docker-cartodb/redis/  
./build.sh

cd docker-cartodb/postgis/  
./build.sh

cd docker-cartodb/carto/  
./base/build.sh  
./build.sh

cd docker-cartodb/scripts/  
./setup.sh
./deploy.sh

echo "127.0.0.1 {USERNAME}.localhost.lan" | sudo tee -a /etc/hosts
And it should be up and running on http://{USERNAME}.localhost.lan:3000

# Comments

I hope you find this installation helpful.

If you encounter any troubles feal free send me a message. 

sabalah21@gmail.com

# Credits
kartoza/docker-postgis
