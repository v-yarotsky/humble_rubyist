package "libsqlite3-dev"

gem_package "bundler"

deploy_path = node[:deploy_path]
builds_path = File.expand_path("../builds", deploy_path)
shared_path = File.expand_path("../shared", deploy_path)
log_path    = File.join(shared_path, "log")
pid_path    = File.join(shared_path, "tmp", "pids")
db_path     = File.join(shared_path, "db")

[builds_path, shared_path, log_path, pid_path, db_path].each do |dir|
  directory dir do
    owner "www-data"
    group "www-data"
    mode  "0755"
    recursive true
  end
end

unicorn_out = File.join(log_path, "unicorn_out.log")
unicorn_err = File.join(log_path, "unicorn_err.log")
unicorn_pid = File.join(pid_path, "unicorn.pid")

[unicorn_out, unicorn_err, unicorn_pid].each do |f|
  file f do
    owner "www-data"
    group "www-data"
    mode  "0644"
    action :touch
  end
end

code_archive = "#{Chef::Config[:file_cache_path]}/humble_rubyist.zip"
remote_file code_archive do
  source "https://github.com/v-yarotsky/humble_rubyist/archive/master.zip"
  #notifies :run, "execute[update-code]"
end

execute "update-code" do
  build_dir = File.join(builds_path, "humble_rubyist-#{Time.now.strftime("%Y%m%d%H%M%S")}")
  command <<-SH
    mkdir -p #{build_dir}
    unzip #{code_archive} -x 'humble_rubyist-master/chef/*' -d #{build_dir}
    rm -f #{deploy_path}
    ln -s #{build_dir}/humble_rubyist-master #{deploy_path}
    ln -s #{log_path} #{deploy_path}/log
    ln -s #{File.dirname(pid_path)} #{deploy_path}/tmp
    ln -s #{shared_path}/unicorn.rb #{deploy_path}/unicorn.rb
    ln -s #{db_path} #{deploy_path}/db
    chown -R www-data:www-data #{build_dir}
    cd #{deploy_path}
    bundle install
  SH
  notifies :restart, "service[unicorn]"
end

template "/etc/init.d/unicorn" do
  source "init.d/unicorn.erb"
  owner "root"
  group "root"
  mode  "0755"
  variables :deploy_path => deploy_path,
            :unicorn_pid => unicorn_pid
end

service "unicorn" do
  action :nothing
  supports :starts => true, :stop => true, :restart => true
end

unicorn_conf = File.join(shared_path, "unicorn.rb")

template unicorn_conf do
  source "unicorn.rb.erb"
  owner "www-data"
  group "www-data"
  mode  "0644"
  variables :deploy_path => deploy_path,
            :unicorn_out => unicorn_out,
            :unicorn_err => unicorn_err,
            :unicorn_pid => unicorn_pid
  notifies :restart, "service[unicorn]"
end

apt_repository "nginx" do
  uri "http://ppa.launchpad.net/nginx/stable/ubuntu"
  distribution node["lsb"]["codename"]
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "8B3981E7A6852F782CC4951600A6F0A3C300EE8C"
  deb_src true
end

package "nginx"

service "nginx" do
  action :nothing
  supports :start => true, :stop => true, :restart => true, :reload => true
end

app_public = File.join(deploy_path, "public")

template "/etc/nginx/conf.d/nginx.conf" do
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode  "0644"
  variables :app_public => app_public, :hostname => node[:new_hostname]
  notifies :restart, "service[nginx]"
end

