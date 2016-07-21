# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "dummy"

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = "#{ENV['access_key_id']}" # Your access key id from AWS
    aws.secret_access_key = "#{ENV['secret_access_key']}" # Your secret_access_key id from AWS
    aws.keypair_name = "#{ENV['keypair_name']}" # Your keypair_name id from AWS
    aws.region = "ap-northeast-1"

    aws.ami = "ami-374db956"
    aws.instance_type = "t2.small"


    override.ssh.username = "ec2-user"
    override.ssh.private_key_path = "#{ENV['private_key_path']}" # Path to your keypair file with .pem extention
  end

  config.vm.synced_folder ".", "/app", type: "rsync",
  rsync__exclude: [".git/", "environment-bootstrap/", "LICENSE", "README.md"]

  config.vm.provision "shell", path: "environment-bootstrap/bootstrap-vagrant.sh"
end
