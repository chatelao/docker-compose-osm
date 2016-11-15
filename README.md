# docker-compose-osm
A Vagrant / Docker-Compose bundle of all relevant OSM stuff

- Install Vagrant: https://www.vagrantup.com/downloads.html

## Install the docker compose plugin for vagrant
```bash
vagrant plugin install vagrant-docker-compose
```
For more details about the plug-in see: https://github.com/leighmcculloch/vagrant-docker-compose

## Usage

### Get your VM running (This takes a while!)
Open a command line and go to the location of this project.
```bash
vagrant up
```
### And now connect to your fresh "docker-compose" VM
And now let's login with a SSH connection.
```bash
vagrant ssh
```
### Start the DB + Application stack
Now let's download the docker images (yes a few GB, don't ask me why):
```bash
cd /vagrant
docker-compose pull
```

### Start the DB + Application stack
Finally the fun starts here, running your own OSM-Stack with a few commands:
```bash
docker-compose up -d
```

### Load the minimal testdata into your database
Loading big amounts of data takes quite a bit of time, so starting with a small dataset like "Belize" is a good idea. Later you can 
load any data from http://download.geofabrik.de/ (as long as you have enough space on you disk).
```bash
docker-compose run --rm osm2pgsql
osm2pgsql --create --slim --cache 2000 --database gis --username osm --host pg --port 5432 /osm/belize-latest.osm.pbf
```

### And get your tiles from your own server!
- We are the world: http://localhost:8080/0/0/0.png
- We are the childern: http://localhost:8080/13/2088/3691.png

### To know more about your server:
- Access the database: http://localhost:8089/phppgadmin (User: gis, Pass: osm)
- Watch the docker containers: http://localhost:8099, http://localhost:8095

Enjoy!

