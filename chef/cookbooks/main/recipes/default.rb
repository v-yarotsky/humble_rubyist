user "app" do
  action :create
  supports :manage_home => true
  home "/home/app"
end
