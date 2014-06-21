provision = proc do |chef|
  chef.provisioning_path = "/etc/chef"
  chef.run_list = ["recipe[main::blog_dev]"]
  chef.json = {
  }
  chef.cookbooks_path = "chef/cookbooks"
  chef.log_level = :debug
end

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu-12.04.-omnibus-chef"
  config.vm.box_url = "http://grahamc.com/vagrant/ubuntu-12.04-omnibus-chef.box"
  config.vm.network :private_network, :ip => "10.0.10.2"
  config.vm.network :forwarded_port,  :guest => 9393, :host => 9393
  config.vm.synced_folder ".", "/vagrant/", :nfs => true

  config.vm.provision :shell, :inline => "curl -L https://www.opscode.com/chef/install.sh | bash"
  config.vm.provision(:chef_solo, &provision)
end

