# vagrant_env
Development Environment for Skyhopper using Vagrant.



Setting Environment Variables:
=======
  `export access_key_id="your access key from aws"`
  `export secret_access_key="your secret key from aws"`
  `export keypair_name="your keypair file name"`
  `export private_key_path="your keypair file path .pem"`

Vagrant
=======

There is a special bootstrap script for vagrant usage. To get started with vagrant:

  1. [Requirement] An AWS account created with the following credentials:
    - Access Key ID
    - Scret Access Key
    - Keypair Files
  2. Install vagrant from http://www.vagrantup.com/downloads.html
  3. Install vagrant-aws plugin

        vagrant plugin install vagrant-aws

  3. Add a new box to vagrant for AWS

        vagrant box add dummy https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box

  4. Clone this repository into your workspace

        git clone https://github.com/Joeper214/vagrant_env.git

  5. Copy the vagrant file from the bootstrap into your workspace (you should now have workspace/Vagrantfile and vagrant_env/bootstrap-vagrant.sh)

        cp vagrant_env/Vagrantfile Vagrantfile

  6. Start-up vagrant. This may take a few minutes while vagrant initializes the machine.

        vagrant up

  7. SSH into the VM. The workspace directory should be mapped to your local workspace.

        vagrant ssh
        $> cd /app/skyhopper
        $> ls

  8. When you're done use ``vagrant suspend`` to pause the machine. Use ``vagrant resume`` to start it back up. If you need to delete it use ``vagrant destroy``.
