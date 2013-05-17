action :create do
  hostname              = new_resource.hostname
  app_public            = ::File.join(new_resource.app_root, "public")
  unicorn_socket        = new_resource.unicorn_socket
  unicorn_instance_name = new_resource.unicorn_instance_name

  template "/etc/nginx/conf.d/nginx-#{hostname}.conf" do
    source "nginx-vhost.conf.erb"
    owner "root"
    group "root"
    mode  "0644"
    variables :app_public => app_public,
              :hostname => hostname,
              :unicorn_socket => unicorn_socket,
              :unicorn_instance_name => unicorn_instance_name
    notifies :restart, "service[nginx]"
  end
end

