provision = proc do |chef|
  chef.provisioning_path = "/etc/chef"
  chef.run_list = ["recipe[main::blog]"]
  chef.json = {
    "blog" => {
      "dns_name" => "blog.yarotsky.me",
      "deploy_path" => "/var/www/humble_rubyist",
      "repo" => "https://github.com/v-yarotsky/humble_rubyist.git",
      "branch" => "production"
    }
  }
  chef.cookbooks_path = "chef/cookbooks"
  chef.log_level = :debug
end

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu-12.04.-omnibus-chef"
  config.vm.box_url = "http://grahamc.com/vagrant/ubuntu-12.04-omnibus-chef.box"
  config.vm.network :private_network, :ip => "10.0.1.1"
  config.vm.synced_folder ".", "/vagrant/"
  config.vm.provision(:chef_solo, &provision)
end

