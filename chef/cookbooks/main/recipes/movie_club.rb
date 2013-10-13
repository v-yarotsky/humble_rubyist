include_recipe "main::nginx"

%w(
  unzip
  sqlite3
  libsqlite3-dev
  libxml2-dev
  libxslt1-dev
).each { |pkg| package pkg }

gem_package "bundler"

attrs = node[:movie_club]

deploy_path  = attrs[:deploy_path]
unicorn_path = File.join(deploy_path, "unicorn")

builds_path  = File.join(deploy_path, "builds")
shared_path  = File.join(deploy_path, "shared")
db_path      = File.join(shared_path, "db")
bundle_path  = File.join(shared_path, "vendor/bundle")
current_app  = File.join(deploy_path, "current")

main_unicorn "movie_club" do
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

build_dir = File.join(builds_path, "movie_club-#{Time.now.strftime("%Y%m%d%H%M%S")}")

git build_dir do
  repository attrs[:repo]
  reference attrs[:branch]
  action :sync
  notifies :run, "execute[movie-club-after-update-code]", :immediately
end

execute "movie-club-after-update-code" do
  environment("RACK_ENV" => "production")
  command <<-SH
    rm -f #{current_app}
    ln -s #{build_dir} #{current_app}
    ln -s #{db_path} #{current_app}/db
    ln -s #{shared_path}/Keyfile #{current_app}/Keyfile
    cd #{current_app}
    bundle install --deployment --without=development --path=#{bundle_path}
    bundle exec rake assets:precompile
  SH
  notifies :restart, "main_unicorn[movie_club]"
end

main_nginx_unicorn_vhost attrs[:dns_name] do
  app_root current_app
  unicorn_socket "/tmp/unicorn_movie_club.socket"
  unicorn_instance_name "unicorn_movie_club"
  action :create
end

