
# # http://askubuntu.com/questions/3503/best-way-to-cache-apt-downloads-on-a-lan
apt-get install -y squid-deb-proxy avahi-utils
apt-get install -y squid-deb-proxy-client

apt-get update

# for all container gets
apt-get install -y git

# install Docker the easy way
# apt-get install -y docker-engine
sudo curl -sSL https://get.docker.com/ | sh
sudo usermod -aG docker vagrant
sudo service docker start

# Let's make the source destination visible
cd /vagrant

# Ladewerkzeuge für die DB mit PostGIS Erweiterung
git clone https://github.com/chatelao/docker-postgres-osm

# Rohe DB mit PostGIS Erweiterung
git clone https://github.com/chatelao/docker-osm2pgsql

# Der Renderd-Server mit Apache mod_tile
git clone https://github.com/chatelao/docker-renderd-osm

# And finally add the search engine
git clone https://github.com/chatelao/nominatim-docker

#
# INSTALL DATABASE
#
pushd docker-postgres-osm
docker build -t chatelao/postgres-osm .
popd

# start the database detached
docker run -d -p 5432:5432 --name postgres-osm chatelao/postgres-osm

# Just test the connection
docker run -i -t --rm --link postgres-osm:pg --entrypoint /bin/bash postgres:9.3.6 -c 'psql -h $PG_PORT_5432_TCP_ADDR -p $PG_PORT_5432_TCP_PORT -U postgres postgres'

#
# LOAD DATA INTO DATABASE
#
pushd docker-osm2pgsql
docker build -t chatelao/osm2pgsql .
popd

# Just test the importer
docker run -i -t --rm chatelao/osm2pgsql -c 'osm2pgsql -h'

# And import monaco
docker run -i -t --rm --link postgres-osm:pg -v /vagrant_data/osm_import:/osm chatelao/osm2pgsql -c 'osm2pgsql --create --slim --hstore --cache 2000 --number-processes 2 --database $PG_ENV_OSM_DB --username $PG_ENV_OSM_USER --host pg --port $PG_PORT_5432_TCP_PORT /osm/monaco-latest.osm.pbf'

#
# MAP TILE RENDER SERVER
#
pushd docker-renderd-osm
docker build -t chatelao/renderd-osm .
popd

docker start postgres-osm
docker run -i -t -p 8080:80 --link postgres-osm:pg  chatelao/renderd-osm

#
# NOMINATIM SEARCH SERVER
#
mv nominatim-docker docker-nominatim
pushd nominatim-docker
docker build -t chatelao/nominatim .
popd
docker run -i -t -p 8081:8081 chatelao/nominatim
