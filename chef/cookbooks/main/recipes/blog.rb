include_recipe "main::default"

include_recipe "nginx"
include_recipe "ruby"
include_recipe "unicorn"
include_recipe "mongodb"

ruby_gem "bundler"

attrs = node[:blog]

deploy_path  = attrs[:deploy_path]
unicorn_path = File.join(deploy_path, "unicorn")

#builds_path  = File.join(deploy_path, "builds")
#shared_path  = File.join(deploy_path, "shared")
#bundle_path  = File.join(shared_path, "vendor/bundle")
current_app  = File.join(deploy_path, "current")

unicorn_instance "blog" do
  owner "app"
  group "app"
  path unicorn_path
  app_path current_app
  environment "production"
  action :create
end

#[deploy_path, builds_path, shared_path, bundle_path].each do |dir|
#  directory dir do
#    owner "root"
#    group "root"
#    mode  "0755"
#    recursive true
#  end
#end
#
#build_dir = File.join(builds_path, "humble_rubyist-#{Time.now.strftime("%Y%m%d%H%M%S")}")
#
#git build_dir do
#  repository attrs[:repo]
#  reference attrs[:branch]
#  action :sync
#  notifies :run, "execute[humble-rubyist-after-update-code]", :immediately
#end
#
#execute "humble-rubyist-after-update-code" do
#  environment("RACK_ENV" => "production")
#  command <<-SH
#    rm -f #{current_app}
#    ln -s #{build_dir} #{current_app}
#    ln -s #{shared_path}/Keyfile #{current_app}/Keyfile
#    cd #{current_app}
#    bundle install --deployment --without=development --path=#{bundle_path}
#    bundle exec rake assets:precompile
#  SH
#  notifies :restart, "main_unicorn[blog]"
#end

unicorn_nginx_vhost attrs[:dns_name] do
  app_root current_app
  unicorn_socket "/tmp/unicorn_blog.socket"
  unicorn_instance_name "unicorn_blog"
  action :create
end

