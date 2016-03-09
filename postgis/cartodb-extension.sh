#!/bin/bash

# Install cartodb extension
cd /home && git clone https://github.com/CartoDB/cartodb-postgresql                        
cd ./cartodb-postgresql && git checkout master                                             
make all install                     
PGUSER=postgres make installcheck
