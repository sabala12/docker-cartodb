CONF="/etc/postgresql/9.3/main/postgresql.conf"

# Restrict subnet to docker private network
# Listen on all ip addresses
echo "listen_addresses = '*'" >> /etc/postgresql/9.3/main/postgresql.conf
echo "port = 5432" >> /etc/postgresql/9.3/main/postgresql.conf
