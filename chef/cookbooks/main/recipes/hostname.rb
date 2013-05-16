hostname = node[:new_hostname]

service "hostname" do
  action :nothing
  supports :restart => true
end

file "/etc/hostname" do
  content "#{hostname}\n"
  notifies :restart, "service[hostname]"
end

file "/etc/hosts" do
  content "127.0.0.1 localhost #{hostname}\n"
end


