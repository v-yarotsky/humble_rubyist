include_recipe "main::nginx"
include_recipe "main::mongodb"

%w(
  unzip
  sqlite3
  libsqlite3-dev
  libxml2-dev
  libxslt1-dev
).each { |pkg| package pkg }

gem_package "bundler"

deploy_path  = node[:blog][:deploy_path]
unicorn_path = File.join(deploy_path, "unicorn")

builds_path  = File.join(deploy_path, "builds")
shared_path  = File.join(deploy_path, "shared")
db_path      = File.join(shared_path, "db")
bundle_path  = File.join(shared_path, "vendor/bundle")
current_app  = File.join(deploy_path, "current")

main_unicorn "blog" do
  path unicorn_path
  app_path current_app
  environment "production"
  action :create
end

[deploy_path, builds_path, shared_path, db_path, bundle_path].each do |dir|
  directory dir do
    owner "root"
    group "root"
    mode  "0755"
    recursive true
  end
end

code_archive = "#{Chef::Config[:file_cache_path]}/humble_rubyist.zip"
remote_file code_archive do
  source "https://github.com/v-yarotsky/humble_rubyist/archive/master.zip"
  #notifies :run, "execute[update-code]"
end

execute "update-code" do
  environment("RACK_ENV" => "production")
  build_dir = File.join(builds_path, "humble_rubyist-#{Time.now.strftime("%Y%m%d%H%M%S")}")
  command <<-SH
    mkdir -p #{build_dir}
    unzip #{code_archive} -x 'humble_rubyist-master/chef/*' -d #{build_dir}
    rm -f #{current_app}
    ln -s #{build_dir}/humble_rubyist-master #{current_app}
    ln -s #{db_path} #{current_app}/db
    ln -s #{shared_path}/Keyfile #{current_app}/Keyfile
    cd #{current_app}
    bundle install --deployment --without=development --path=#{bundle_path}
    bundle exec rake ensure_schema assets:precompile
  SH
  notifies :restart, "main_unicorn[blog]"
end

main_nginx_unicorn_vhost "blog.yarotsky.me" do
  app_root current_app
  unicorn_socket "/tmp/unicorn_blog.socket"
  unicorn_instance_name "unicorn_blog"
  action :create
end

