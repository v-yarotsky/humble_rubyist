provision = proc do |chef|
  chef.provisioning_path = "/etc/chef"
  chef.run_list = ["recipe[main::blog_dev]"]
  chef.json = {
  }
  chef.cookbooks_path = "chef/cookbooks"
  chef.log_level = :debug
end

Vagrant.configure("2") do |config|
  config.vm.box = "opscode-ubuntu-13.10"
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-13.10_chef-provisionerless.box"
  config.vm.box_check_update = false

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.memory = 2048
  end

  config.omnibus.chef_version = :latest

  config.vm.network :private_network, ip: "192.168.1.101"
  config.vm.network :forwarded_port,  guest: 9393, host: 9393
  config.vm.network :forwarded_port,  guest: 5984, host: 5984
  config.vm.synced_folder ".", "/home/vagrant/humble_rubyist", nfs: true

  config.vm.provision(:chef_solo, &provision)
end

