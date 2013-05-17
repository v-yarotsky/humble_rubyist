def unicorn_instance_name
  unicorn_instance_name = "unicorn-#{new_resource.name}"
end

action :create do
  gem_package "unicorn"

  unicorn_app_path = new_resource.app_path
  unicorn_environment = new_resource.environment

  unicorn_path = new_resource.path
  log_path    = ::File.join(unicorn_path, "log")
  pid_path    = ::File.join(unicorn_path, "tmp", "pids")

  [unicorn_path, log_path, pid_path].each do |dir|
    directory dir do
      owner "root"
      group "root"
      mode  "0755"
      recursive true
    end
  end

  unicorn_out = ::File.join(log_path, "unicorn_out.log")
  unicorn_err = ::File.join(log_path, "unicorn_err.log")
  unicorn_pid = ::File.join(pid_path, "unicorn.pid")

  [unicorn_out, unicorn_err, unicorn_pid].each do |f|
    file f do
      owner "root"
      group "root"
      mode  "0644"
      action :touch
    end
  end

  unicorn_config = ::File.join(unicorn_path, "unicorn.rb")

  template unicorn_config do
    source "unicorn.rb.erb"
    owner "root"
    group "root"
    mode  "0644"
    variables :app_path    => unicorn_app_path,
              :unicorn_out => unicorn_out,
              :unicorn_err => unicorn_err,
              :unicorn_pid => unicorn_pid,
              :unicorn_instance_name => unicorn_instance_name
    notifies :restart, "service[#{unicorn_instance_name}]"
  end

  template "/etc/init.d/#{unicorn_instance_name}" do
    source "init.d/unicorn.erb"
    owner "root"
    group "root"
    mode  "0755"
    variables :unicorn_config => unicorn_config,
              :unicorn_environment => unicorn_environment,
              :unicorn_pid => unicorn_pid
  end

  service unicorn_instance_name do
    action :nothing
    supports :starts => true, :stop => true, :restart => true
  end

  new_resource.updated_by_last_action(true)
end

action :enable do
  service (unicorn_instance_name) { action :enable }
  new_resource.updated_by_last_action(true)
end

action :restart do
  service (unicorn_instance_name) { action :restart }
  new_resource.updated_by_last_action(true)
end

