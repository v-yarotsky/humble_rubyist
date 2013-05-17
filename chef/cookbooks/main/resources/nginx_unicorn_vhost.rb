actions :create

attribute :app_root, :kind_of => String, :required => true
attribute :hostname, :kind_of => String, :name_attribute => true, :required => true
attribute :unicorn_socket, :kind_of => String, :required => true
attribute :unicorn_instance_name, :kind_of => String, :required => true


