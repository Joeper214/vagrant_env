# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant on AWS Example
# Brian Cantoni

# This sample sets up 1 VM ('delta') with only Java installed.

# Adjustable settings


# Configure VM server
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define :delta do |x|
    x.vm.box = "hashicorp/precise64"
    x.vm.hostname = "skyhopper-server"
    x.vm.provision "shell", path: "environment-bootstrap/bootstrap-vagrant.sh"

    x.vm.provider :virtualbox do |v|
      v.name = "skyhopper-server"
    end

    # config.vm.synced_folder "../data", "/vagrant_data"

    x.vm.provider :aws do |aws, override|
      aws.access_key_id = ENV['AWS_KEY']
      aws.secret_access_key = ENV['AWS_SECRET']
      aws.keypair_name = ENV['AWS_KEYNAME']
      aws.ami = "ami-383c1956"
      aws.region = "ap-northeast-1"
      aws.instance_type = "t2.small"
      aws.tags = {
        'Name' => 'skyhopper-server',
      }
      override.vm.box = "dummy"
      override.ssh.username = "ec2-user"
      override.ssh.private_key_path = ENV['AWS_KEYPATH']
    end
  end
end
