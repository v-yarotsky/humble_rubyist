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
  action [:enable, :start]
  supports :start => true, :stop => true, :restart => true, :reload => true
end

