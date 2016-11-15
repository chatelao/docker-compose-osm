# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  # config.vm.box = "ubuntu/trusty64"
  config.vm.box = "minimal/trusty64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  for i in 8080..8099
    config.vm.network :forwarded_port, guest: i, host: i
  end

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  config.vm.synced_folder "./osm_mapdata",  "/vagrant_data/osm_mapdata"
  config.vm.synced_folder "./osm_mapstyle", "/vagrant_data/osm_mapstyle"

  # Provider-specific configuration, example for VirtualBox:
  config.vm.provider "virtualbox" do |vb|
      vb.memory = "4096"
      vb.cpus   = 3
      vb.customize ["modifyvm", :id, "--cpuexecutioncap", "75"]
  end

  # config.vm.provision "shell", path: "bootstrap.sh"
  
  config.vm.network "forwarded_port", guest: 8083, host: 8083
  config.vm.provision :docker
  config.vm.provision :docker_compose
  # config.vm.provision :docker_compose, yml: "/vagrant/docker-compose.yml", rebuild: true, run: "always"
  # config.vm.provision :docker_compose, yml: "/vagrant/docker-compose.yml", run: "always"
  
end
