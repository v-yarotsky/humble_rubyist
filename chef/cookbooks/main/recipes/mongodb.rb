apt_repository "10gen" do
  uri "http://downloads-distro.mongodb.org/repo/ubuntu-upstart"
  distribution "dist"
  components ["10gen"]
  keyserver "keyserver.ubuntu.com"
  key "7F0CEB10"
end

package "mongodb-10gen"

service "mongodb" do
  action [:enable, :start]
  supports :start => true, :stop => true, :restart => true
end

