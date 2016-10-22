=======
# CartoDB

Docker configuration for CartoDB.

This is a simple configuration for running cartodb app.

By default All containers are linked to the host net stack, and therefore share
the same ip address.  

# Installation

Set your parameters in ./docker-cartodb/scripts/utils/params.sh.  
Run:  
cd docker-cartodb/redis/ && ./build.sh

cd docker-cartodb/postgis/ && ./build.sh

cd docker-cartodb/base/ && ./build.sh

cd docker-cartodb/scripts/  
./setup.sh  
./deploy.sh

echo "127.0.0.1 {USERNAME}.localhost.lan" | sudo tee -a /etc/hosts
And it should be up and running on http://{USERNAME}.localhost.lan:3000

# Offline
I managed to run cartodb offline. I discarded this option for simplicity.  
If it is necessary send me a message.

# Comments

I hope you find this installation helpful.

If you encounter any troubles feal free to send me a message. 

sabalah21@gmail.com

# Credits
kartoza/docker-postgis
