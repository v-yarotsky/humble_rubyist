include_recipe "apt"
include_recipe "ruby"
include_recipe "mongodb"
include_recipe "couchdb"

ruby_gem "bundler"

bash "Install bundle" do
  cwd "/vagrant"
  user "vagrant"
  code <<-SH
    bundle install --path ./.bundle/
  SH
end

