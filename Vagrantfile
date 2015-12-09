# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant on AWS Example
# Brian Cantoni

# This sample sets up 1 VM ('delta') with only Java installed.

# Adjustable settings
CFG_TZ = "Asia/Pacific"     # timezone, like US/Pacific, US/Eastern, UTC, Europe/Warsaw, etc.

# Provisioning script
node_script = <<SCRIPT
#!/bin/bash
# set timezone
echo "#{CFG_TZ}" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata
# install a few base packages
apt-get update
apt-get install vim curl zip unzip git python-pip -y
# install java
apt-get install openjdk-7-jre -y
echo Provisioning is complete
SCRIPT


# Configure VM server
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define :delta do |x|
    x.vm.box = "hashicorp/precise64"
    x.vm.hostname = "delta"
    x.vm.provision :shell, :inline => node_script

    x.vm.provider :virtualbox do |v|
      v.name = "delta"
    end

    # config.vm.synced_folder "../data", "/vagrant_data"

    config.vm.provision "shell", path: "environment-bootstrap/bootstrap-vagrant.sh"

    x.vm.provider :aws do |aws, override|
      aws.access_key_id = ENV['AWS_KEY']
      aws.secret_access_key = ENV['AWS_SECRET']
      aws.keypair_name = ENV['AWS_KEYNAME']
      aws.ami = "ami-383c1956"
      aws.region = "ap-northeast-1"
      aws.instance_type = "t2.small"

      override.vm.box = "dummy"
      override.ssh.username = "ec2-user"
      override.ssh.private_key_path = ENV['AWS_KEYPATH']
    end
  end
end
